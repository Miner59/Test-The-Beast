dofile(minetest.get_modpath("monorail").."/functions.lua")

monorail={}
monorail.registered_driver={}

--
-- Cart entity
--

minetest.register_globalstep(function(dtime)
	--jump out if needed and keep accurate list
	for i, EachDriver in ipairs(monorail.registered_driver) do
		if EachDriver.state == 3 then
			monorail.registered_driver[i].driver:set_detach()
			if monorail.registered_driver[i].driver and monorail.registered_driver[i].driver:is_player() then
				local name = monorail.registered_driver[i].driver:get_player_name()
				default.player_attached[name] = false
			end
			table.remove(monorail.registered_driver, i)
			if EachDriver.cart then
				EachDriver.cart.driver=nil
			end
			-- minetest.log("action", "Cart - cleared")
		elseif not EachDriver.driver or not EachDriver.driver:is_player() then	--no player
			table.remove(monorail.registered_driver, i)
			if EachDriver.cart then
				EachDriver.cart.driver=nil
			end
			minetest.log("action", "Cart - cleared. no player")
		elseif not EachDriver.cart or EachDriver.cart==nil then	--no cart
			monorail.registered_driver[i].driver:set_detach()
			if monorail.registered_driver[i].driver and monorail.registered_driver[i].driver:is_player() then
				local name = monorail.registered_driver[i].driver:get_player_name()
				default.player_attached[name] = false
			end
			table.remove(monorail.registered_driver, i)
			minetest.log("action", "Cart - cleared. no cart")
		end
	end
	
	for i, EachDriver in ipairs(monorail.registered_driver) do
		if EachDriver.state == 1 then
			if EachDriver.cart and EachDriver.driver and EachDriver.driver:is_player() then
				monorail.registered_driver[i].state=2	--drive
				EachDriver.cart.driver=monorail.registered_driver[i].driver
				monorail.registered_driver[i].driver:set_attach(monorail.registered_driver[i].cart.object, "", {x=0,y=5,z=0}, {x=0,y=0,z=0})
				if monorail.registered_driver[i].driver and monorail.registered_driver[i].driver:is_player() then
					local name = monorail.registered_driver[i].driver:get_player_name()
					default.player_attached[name] = true
				end
				-- minetest.log("action", "Cart - occupied")
			else
				monorail.registered_driver[i].state=3	--something wrong
				minetest.log("action", "Cart - something wrong")
			end
		end
	end
	
end)

local cart = {
	physical = false,
	collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5},
	visual = "cube",
	stepheight = 1.6,
	visual_size = {x=1, y=1},
	textures = {"monorail_top.png","monorail_bottom.png","monorail_side.png","monorail_side.png","monorail_side.png","monorail_side.png"},
	groups = { immortal=1, },

	driver = nil,
	
	old_pos = nil,	--rounded
	old_direction = {x=0, y=0, z=0},
	
	current_pos = nil,	--rounded
	current_direction = {x=0, y=0, z=0},
	
	next_pos = nil,	--rounded
	
	current_speed = 0,	--positive
	MAX_SPEED = 12, -- Limit of the velocity
}

function cart:on_rightclick(clicker)
	if not clicker or not clicker:is_player() then
		return
	end
	
	for i, EachDriver in ipairs(monorail.registered_driver) do
		if EachDriver.state == 2 and EachDriver.driver and EachDriver.driver == clicker then
			monorail.registered_driver[i].state=3	--jump out from old carts
			if EachDriver.cart == self then
				return	--just jump out from current cart
			end
		elseif EachDriver.state == 1 and EachDriver.driver and EachDriver.driver == clicker  then
			return	--this driver already registered
		elseif EachDriver.cart == self then
			return	--cart busy by other player
		end
	end
	
	table.insert(monorail.registered_driver, {cart=self, driver=clicker, state=1} )
end

function cart:on_activate(staticdata, dtime_s)
	
	self.object:set_armor_groups({immortal=1})
	self.old_pos = monorail_func.v3:round( self.object:getpos() )
	self.current_pos = monorail_func.v3:round( self.object:getpos() )
	self.next_pos = monorail_func.v3:round( self.object:getpos() )
	self.driver=nil
	self.dtime=0	
	local p=self.current_pos
	if not monorail_func:is_rail( self.current_pos ) then
		minetest.log("action", "Removing old chart at "..self.current_pos.x..","..self.current_pos.y..","..self.current_pos.z)
		if self.driver ~= nil then
			self.driver:set_detach()
		end
		self.object:remove()
		return
	elseif monorail_func:is_rail({x=p.x, y=p.y-1, z=p.z-1}) or monorail_func:is_rail({x=p.x, y=p.y+1, z=p.z+1}) then
		self.next_pos={x=p.x, y=p.y, z=p.z-1}
		self.current_direction={x=0, y=0, z=-1}
		self.current_speed=1
		self:recalculate_way()
		self:get_moving()
	elseif monorail_func:is_rail({x=p.x, y=p.y-1, z=p.z+1}) or monorail_func:is_rail({x=p.x, y=p.y+1, z=p.z-1}) then
		self.next_pos={x=p.x, y=p.y, z=p.z+1}
		self.current_direction={x=0, y=0, z=1}
		self.current_speed=1
		self:recalculate_way()
		self:get_moving()
	elseif monorail_func:is_rail({x=p.x-1, y=p.y-1, z=p.z}) or monorail_func:is_rail({x=p.x+1, y=p.y+1, z=p.z}) then
		self.next_pos={x=p.x-1, y=p.y, z=p.z}
		self.current_direction={x=-1, y=0, z=0}
		self.current_speed=1
		self:recalculate_way()
		self:get_moving()
	elseif monorail_func:is_rail({x=p.x+1, y=p.y-1, z=p.z}) or monorail_func:is_rail({x=p.x-1, y=p.y+1, z=p.z}) then
		self.next_pos={x=p.x+1, y=p.y, z=p.z}
		self.current_direction={x=1, y=0, z=0}
		self.current_speed=1
		self:recalculate_way()
		self:get_moving()
	end
	
	-- if staticdata then
		-- local tmp = minetest.deserialize(staticdata)
		-- if tmp and tmp.current_speed then
			-- self.current_speed = current_speed
		-- end
		-- if tmp and tmp.current_direction then
			-- self.current_direction = current_direction
			-- self.old_direction = current_direction
		-- end
	-- end
	
end

function cart:get_staticdata()
	return minetest.serialize({
		current_speed = self.current_speed,
		current_direction = self.current_direction,
	})
end

-- Remove the cart if holding a tool or accelerate it
function cart:on_punch(puncher, time_from_last_punch, tool_capabilities, direction)
	if not puncher or not puncher:is_player() then
		return
	end
	
	if puncher:get_player_control().sneak then
		-- first partially drop driver from the cart, only then remove cart
		if self.driver ~= nil then
			self.driver:set_detach()
		end
		self.object:remove()
		local inv = puncher:get_inventory()
		local cart="monorail:cart" 
		if minetest.setting_getbool("creative_mode") then
			if not inv:contains_item("main", cart) then
				inv:add_item("main", cart)
			end
		else
			inv:add_item("main", cart)
		end
		return
	end
	
	if puncher == self.driver then
		return
	end
	
	local d = monorail_func:velocity_to_dir(direction)
	if time_from_last_punch > tool_capabilities.full_punch_interval then
		time_from_last_punch = tool_capabilities.full_punch_interval
	end
	local f = 4*(time_from_last_punch/tool_capabilities.full_punch_interval)
	
	--change speed or stop cart
	if monorail_func.v3:empty( self.current_direction ) or self.current_speed == 0 then
		self.current_direction.x = d.x
		self.current_direction.z = d.z
		self:recalculate_way()
		self.current_speed = f
	elseif d.x==self.current_direction.x and d.z==self.current_direction.z then
		self.current_speed=self.current_speed + f
	else
		self.current_speed = 0
	end
	
	-- Speed limits
	if self.current_speed < 0 then
		self.current_speed = 0
	end
	if self.current_speed > self.MAX_SPEED then
		self.current_speed = self.MAX_SPEED
	end
	
	self:get_moving()
	
end

--step done. all checked. now just calculate next rail and direction
function cart:recalculate_way()
	if not monorail_func.v3:empty(self.current_direction) and self.current_speed>0 then
		local p=monorail_func.v3:copy(self.current_pos)
		-- Check player control.
		--this code is long, but optimal enough. If you think you can make it better - do it.
		local switch=false
		local left=false
		local right=false
		if minetest.get_node({x=p.x+1, y=p.y, z=p.z}).name=="monorail:switch_on" or minetest.get_node({x=p.x-1, y=p.y, z=p.z}).name=="monorail:switch_on"
			or minetest.get_node({x=p.x, y=p.y, z=p.z+1}).name=="monorail:switch_on" or minetest.get_node({x=p.x, y=p.y, z=p.z-1}).name=="monorail:switch_on" then
			switch=true
		end
		if self.driver and self.driver:is_player() then
			if self.driver:get_player_control().right then
				right=true
			end
			if self.driver:get_player_control().left then
				left=true
			end
		end
			if switch or left then
				if self.current_direction.x == -1 then
					if monorail_func:is_rail({x=p.x, y=p.y, z=p.z-1}) then
						self.next_pos={x=p.x, y=p.y, z=p.z-1}
						self.current_direction={x=0, y=0, z=-1}
						return
					end
					if monorail_func:is_rail({x=p.x, y=p.y-1, z=p.z-1}) then
						self.next_pos={x=p.x, y=p.y-1, z=p.z-1}
						self.current_direction={x=0, y=-1, z=-1}
						return
					end
					if monorail_func:is_rail({x=p.x, y=p.y+1, z=p.z-1}) then
						self.next_pos={x=p.x, y=p.y+1, z=p.z-1}
						self.current_direction={x=0, y=1, z=-1}
						return
					end
				end
				if self.current_direction.x == 1 then
					if monorail_func:is_rail({x=p.x, y=p.y, z=p.z+1}) then
						self.next_pos={x=p.x, y=p.y, z=p.z+1}
						self.current_direction={x=0, y=0, z=1}
						return
					end
					if monorail_func:is_rail({x=p.x, y=p.y+1, z=p.z+1}) then
						self.next_pos={x=p.x, y=p.y+1, z=p.z+1}
						self.current_direction={x=0, y=1, z=1}
						return
					end
					if monorail_func:is_rail({x=p.x, y=p.y-1, z=p.z+1}) then
						self.next_pos={x=p.x, y=p.y-1, z=p.z+1}
						self.current_direction={x=0, y=-1, z=1}
						return
					end
				end
				if self.current_direction.z == -1 then
					if monorail_func:is_rail({x=p.x+1, y=p.y, z=p.z}) then
						self.next_pos={x=p.x+1, y=p.y, z=p.z}
						self.current_direction={x=1, y=0, z=0}
						return
					end
					if monorail_func:is_rail({x=p.x+1, y=p.y+1, z=p.z}) then
						self.next_pos={x=p.x+1, y=p.y+1, z=p.z}
						self.current_direction={x=1, y=1, z=0}
						return
					end
					if monorail_func:is_rail({x=p.x+1, y=p.y-1, z=p.z}) then
						self.next_pos={x=p.x+1, y=p.y-1, z=p.z}
						self.current_direction={x=1, y=-1, z=0}
						return
					end
				end
				if self.current_direction.z == 1 then
					if monorail_func:is_rail({x=p.x-1, y=p.y, z=p.z}) then
						self.next_pos={x=p.x-1, y=p.y, z=p.z}
						self.current_direction={x=-1, y=0, z=0}
						return
					end
					if monorail_func:is_rail({x=p.x-1, y=p.y+1, z=p.z}) then
						self.next_pos={x=p.x-1, y=p.y+1, z=p.z}
						self.current_direction={x=-1, y=1, z=0}
						return
					end
					if monorail_func:is_rail({x=p.x-1, y=p.y-1, z=p.z}) then
						self.next_pos={x=p.x-1, y=p.y-1, z=p.z}
						self.current_direction={x=-1, y=-1, z=0}
						return
					end
				end

			end
			if switch or right then
				if self.current_direction.x == 1 then
					if monorail_func:is_rail({x=p.x, y=p.y, z=p.z-1}) then
						self.next_pos={x=p.x, y=p.y, z=p.z-1}
						self.current_direction={x=0, y=0, z=-1}
						return
					end
					if monorail_func:is_rail({x=p.x, y=p.y-1, z=p.z-1}) then
						self.next_pos={x=p.x, y=p.y-1, z=p.z-1}
						self.current_direction={x=0, y=-1, z=-1}
						return
					end
					if monorail_func:is_rail({x=p.x, y=p.y+1, z=p.z-1}) then
						self.next_pos={x=p.x, y=p.y+1, z=p.z-1}
						self.current_direction={x=0, y=1, z=-1}
						return
					end
				end
				if self.current_direction.x == -1 then
					if monorail_func:is_rail({x=p.x, y=p.y, z=p.z+1}) then
						self.next_pos={x=p.x, y=p.y, z=p.z+1}
						self.current_direction={x=0, y=0, z=1}
						return
					end
					if monorail_func:is_rail({x=p.x, y=p.y+1, z=p.z+1}) then
						self.next_pos={x=p.x, y=p.y+1, z=p.z+1}
						self.current_direction={x=0, y=1, z=1}
						return
					end
					if monorail_func:is_rail({x=p.x, y=p.y-1, z=p.z+1}) then
						self.next_pos={x=p.x, y=p.y-1, z=p.z+1}
						self.current_direction={x=0, y=-1, z=1}
						return
					end
				end
				if self.current_direction.z == 1 then
					if monorail_func:is_rail({x=p.x+1, y=p.y, z=p.z}) then
						self.next_pos={x=p.x+1, y=p.y, z=p.z}
						self.current_direction={x=1, y=0, z=0}
						return
					end
					if monorail_func:is_rail({x=p.x+1, y=p.y+1, z=p.z}) then
						self.next_pos={x=p.x+1, y=p.y+1, z=p.z}
						self.current_direction={x=1, y=1, z=0}
						return
					end
					if monorail_func:is_rail({x=p.x+1, y=p.y-1, z=p.z}) then
						self.next_pos={x=p.x+1, y=p.y-1, z=p.z}
						self.current_direction={x=1, y=-1, z=0}
						return
					end
				end
				if self.current_direction.z == -1 then
					if monorail_func:is_rail({x=p.x-1, y=p.y, z=p.z}) then
						self.next_pos={x=p.x-1, y=p.y, z=p.z}
						self.current_direction={x=-1, y=0, z=0}
						return
					end
					if monorail_func:is_rail({x=p.x-1, y=p.y+1, z=p.z}) then
						self.next_pos={x=p.x-1, y=p.y+1, z=p.z}
						self.current_direction={x=-1, y=1, z=0}
						return
					end
					if monorail_func:is_rail({x=p.x-1, y=p.y-1, z=p.z}) then
						self.next_pos={x=p.x-1, y=p.y-1, z=p.z}
						self.current_direction={x=-1, y=-1, z=0}
						return
					end
				end
			end

		local pp = monorail_func.v3:add(monorail_func.v3:copy(self.current_pos), self.current_direction)
		pp.y=self.current_pos.y --y is handled differently
		-- Check right and left. positive direction has priority. not sure about uphill/downhill priority.
		p=monorail_func.v3:copy(self.current_pos)
		-- Check front
		if monorail_func:is_rail(pp) then
			self.next_pos=pp
			self.current_direction={x=self.current_direction.x, y=0, z=self.current_direction.z}
			return
		end
		-- Check downhill
		if monorail_func:is_rail({x=pp.x, y=pp.y-1, z=pp.z}) then
			self.next_pos={x=pp.x, y=pp.y-1, z=pp.z}
			self.current_direction={x=self.current_direction.x, y=-1, z=self.current_direction.z}
			return
		end
		-- Check uphill
		if monorail_func:is_rail({x=pp.x, y=pp.y+1, z=pp.z}) then
			self.next_pos={x=pp.x, y=pp.y+1, z=pp.z}
			self.current_direction={x=self.current_direction.x, y=1, z=self.current_direction.z}
			return
		end
		if math.abs(self.current_direction.x)==1 then
			if monorail_func:is_rail({x=p.x, y=p.y, z=p.z+1}) then
				self.next_pos={x=p.x, y=p.y, z=p.z+1}
				self.current_direction={x=0, y=0, z=1}
			return
			end
			if monorail_func:is_rail({x=p.x, y=p.y, z=p.z-1}) then
				self.next_pos={x=p.x, y=p.y, z=p.z-1}
				self.current_direction={x=0, y=0, z=-1}
			return
			end
			if monorail_func:is_rail({x=p.x, y=p.y+1, z=p.z+1}) then
				self.next_pos={x=p.x, y=p.y+1, z=p.z+1}
				self.current_direction={x=0, y=1, z=1}
			return
			end
			if monorail_func:is_rail({x=p.x, y=p.y-1, z=p.z-1}) then
				self.next_pos={x=p.x, y=p.y-1, z=p.z-1}
				self.current_direction={x=0, y=-1, z=-1}
			return
			end
			if monorail_func:is_rail({x=p.x, y=p.y+1, z=p.z-1}) then
				self.next_pos={x=p.x, y=p.y+1, z=p.z-1}
				self.current_direction={x=0, y=1, z=-1}
			return
			end
			if monorail_func:is_rail({x=p.x, y=p.y-1, z=p.z+1}) then
				self.next_pos={x=p.x, y=p.y-1, z=p.z+1}
				self.current_direction={x=0, y=-1, z=1}
			return
			end
		end
		if math.abs(self.current_direction.z)==1 then
			if monorail_func:is_rail({x=p.x+1, y=p.y, z=p.z}) then
				self.next_pos={x=p.x+1, y=p.y, z=p.z}
				self.current_direction={x=1, y=0, z=0}
			return
			end
			if monorail_func:is_rail({x=p.x-1, y=p.y, z=p.z}) then
				self.next_pos={x=p.x-1, y=p.y, z=p.z}
				self.current_direction={x=-1, y=0, z=0}
			return
			end
			if monorail_func:is_rail({x=p.x+1, y=p.y+1, z=p.z}) then
				self.next_pos={x=p.x+1, y=p.y+1, z=p.z}
				self.current_direction={x=1, y=1, z=0}
			return
			end
			if monorail_func:is_rail({x=p.x-1, y=p.y-1, z=p.z}) then
				self.next_pos={x=p.x-1, y=p.y-1, z=p.z}
				self.current_direction={x=-1, y=-1, z=0}
			return
			end
			if monorail_func:is_rail({x=p.x-1, y=p.y+1, z=p.z}) then
				self.next_pos={x=p.x-1, y=p.y+1, z=p.z}
				self.current_direction={x=-1, y=1, z=0}
			return
			end
			if monorail_func:is_rail({x=p.x+1, y=p.y-1, z=p.z}) then
				self.next_pos={x=p.x+1, y=p.y-1, z=p.z}
				self.current_direction={x=1, y=-1, z=0}
			return
			end
		end
		-- Else it is ded-end, check that somewhere.
		minetest.log("action","Cart stopped at: "..minetest.get_node( monorail_func.v3:add( self.next_pos, self.current_direction ) ).name) --debug
		self.current_direction = {x=0, y=0, z=0}
		
		self.next_pos = p
	end
end

-- Handle chart physical stuff
function cart:get_moving()
	
	local pos = self.object:getpos()
	
	local correction_x = (self.current_pos.x-pos.x)*0.2
	local correction_y = (self.current_pos.y-pos.y)*0.2
	local correction_z = (self.current_pos.z-pos.z)*0.2
	
	-- Actually change cart speed
	if math.abs(self.current_direction.y) == 1 and math.abs(self.current_direction.x) == 1 then
		self.object:setvelocity({x=self.current_direction.x*self.current_speed*0.71, y=self.current_direction.y*self.current_speed*0.71, z=correction_z})
	elseif math.abs(self.current_direction.y) == 1 and math.abs(self.current_direction.z) == 1 then
		self.object:setvelocity({x=correction_x, y=self.current_direction.y*self.current_speed*0.71, z=self.current_direction.z*self.current_speed*0.71})
	elseif math.abs(self.current_direction.x) == 1 then
		self.object:setvelocity({x=self.current_direction.x*self.current_speed, y=correction_y, z=correction_z})
	elseif math.abs(self.current_direction.z) == 1 then
		self.object:setvelocity({x=correction_x, y=correction_y, z=self.current_direction.z*self.current_speed})
	end
	
	-- Direction
	if self.current_direction.x < 0 then
		self.object:setyaw(math.pi/2)
	elseif self.current_direction.x > 0 then
		self.object:setyaw(3*math.pi/2)
	elseif self.current_direction.z < 0 then
		self.object:setyaw(math.pi)
	elseif self.current_direction.z > 0 then
		self.object:setyaw(0)
	end
	
	-- And animation.
	if self.current_direction.y == -1 then
		self.object:set_animation({x=1, y=1}, 1, 0)
	elseif self.current_direction.y == 1 then
		self.object:set_animation({x=2, y=2}, 1, 0)
	else
		self.object:set_animation({x=0, y=0}, 1, 0)
	end
	
end

-- Correct cart position on rail
function cart:precize_on_rail(pos)
	if self.current_direction.x == 0 and math.abs(self.current_pos.x-pos.x)>0.2 then
		self.object:setpos(self.current_pos)
	elseif self.current_direction.z == 0 and math.abs(self.current_pos.z-pos.z)>0.2 then
		self.object:setpos(self.current_pos)
	elseif self.current_direction.y == 0 and math.abs(self.current_pos.y-pos.y)>0.2 then
		self.object:setpos(self.current_pos)
	end
end

function cart:on_step(dtime)
	
	local pos = self.object:getpos()
	local new_pos=monorail_func.v3:round(pos) --rounded

	-- When on new position, check the route
	if not monorail_func.v3:equal( self.current_pos, new_pos ) then
		--wait for unloaded world
		if self.next_pos and self.driver and minetest.get_node( monorail_func.v3:add( self.next_pos, self.current_direction ) ).name == "ignore" then
			self.object:setvelocity({x=0, y=0, z=0}) --don't move cart, until world ahead is loaded
			return
		end
		
		local newpos ={x=new_pos.x-1,y=new_pos.y,z=new_pos.z}
		if minetest.get_node(newpos).name == "monorail:cart_detector_off" then
			minetest.env:add_node(newpos,{name="monorail:cart_detector_on"})
			mesecon.receptor_on(newpos, mesecon.rules.default)
		end
		newpos ={x=new_pos.x+1,y=new_pos.y,z=new_pos.z}
		if minetest.get_node(newpos).name == "monorail:cart_detector_off" then
			minetest.env:add_node(newpos,{name="monorail:cart_detector_on"})
			mesecon.receptor_on(newpos, mesecon.rules.default)
		end
		newpos ={x=new_pos.x,y=new_pos.y,z=new_pos.z-1}
		if minetest.get_node(newpos).name == "monorail:cart_detector_off" then
			minetest.env:add_node(newpos,{name="monorail:cart_detector_on"})
			mesecon.receptor_on(newpos, mesecon.rules.default)
		end
		newpos ={x=new_pos.x,y=new_pos.y,z=new_pos.z+1}
		if minetest.get_node(newpos).name == "monorail:cart_detector_off" then
			minetest.env:add_node(newpos,{name="monorail:cart_detector_on"})
			mesecon.receptor_on(newpos, mesecon.rules.default)
		end
		newpos ={x=new_pos.x,y=new_pos.y-1,z=new_pos.z}
		if minetest.get_node(newpos).name == "monorail:cart_detector_off" then
			minetest.env:add_node(newpos,{name="monorail:cart_detector_on"})
			mesecon.receptor_on(newpos, mesecon.rules.default)
		end
		--move back if out of road
		if not monorail_func:is_rail(new_pos) then
			if monorail_func:is_rail(self.next_pos) then
				self.object:setpos(self.next_pos)
				self.current_pos = monorail_func.v3:copy(self.next_pos)
				self.current_speed=self.current_speed-0.01
			elseif monorail_func:is_rail(self.current_pos) then
				self.object:setpos(self.current_pos)
				self.current_speed=self.current_speed-0.01
			else
				if self.driver ~= nil then
					self.driver:set_detach()
				end
				self.object:remove() --not on rails
				return
			end
		else
			self.old_pos=self.current_pos
			self.current_pos=new_pos
		end
		
		-- Direction to new rail node
		self:recalculate_way()
		
		-- Stop if ded-end
		if monorail_func.v3:empty(self.current_direction ) then
			self.object:setvelocity({x=0, y=0, z=0})
			self:precize_on_rail(pos)
			self.current_speed = 0
			return
		end
		
		-- Increase or decrease speed on uphill/downhill
		if self.current_direction.y == 1 then
			self.current_speed = self.current_speed - 0.8
		end
		if self.current_direction.y == -1 then
			self.current_speed = self.current_speed + 0.8
		end
		
		-- Decrease speed a little at any rail.
		self.current_speed = self.current_speed - 0.1
		
		
		-- Increase or decrease speed on powerrail/brakerail  LATER!!!
		if minetest.get_node(self.current_pos).name == "monorail:powerrail" or minetest.get_node(self.current_pos).name == "monorail:brakerail" then
			local accel=minetest.get_meta(pos):get_string("cart_acceleration")
			if accel~=nil then
				if tonumber(accel)~=nil then
					self.current_speed = self.current_speed + tonumber(accel)
				end
			end
		end
		
		
		-- Speed limits
		if self.current_speed < 0 then
			self.current_speed = 0
		end


		if self.current_speed > self.MAX_SPEED then
			self.current_speed = self.MAX_SPEED
		end
		
		-- Stop the cart if the velocity is nearly 0
		-- On all, not just flat
		if self.current_speed < 0.1 and self.current_direction.y == 0 then
			self:precize_on_rail(pos)
			self.object:setvelocity({x=0, y=0, z=0})
			return
		end
		
		-- Move opposite direction if the velocity is nearly 0 but not stopped yet
		-- Only uphill/downhill
		 if self.current_speed < 0.8 and self.current_direction.y ~= 0 then
			 self.current_direction={x=-self.current_direction.x, y=-self.current_direction.y, z=-self.current_direction.z}
			 self.object:setvelocity({x=0, y=0, z=0})
			 self.current_speed = 1
			 self.next_pos=monorail_func.v3:copy(self.old_pos)
			 self:recalculate_way()
		 end
		
		-- Need to move cart precise on rail.
		self:precize_on_rail(pos)
		
		self:get_moving()
	
	elseif self.dtime>0.3 and self.current_speed == 0 then
		self.dtime=0
		if self.driver==nil then
			local all_objects = minetest.get_objects_inside_radius(pos, 0.6)
			for _,obj in ipairs(all_objects) do
				if obj:get_luaentity() ~= nil then
					if obj:get_luaentity().name == "monorail:cart" and obj:get_luaentity().driver~=nil then
						return
					end
				end
			end
		end
			local nodex={x=pos.x+1,y=pos.y,z=pos.z}
			local nodex2={x=pos.x-1,y=pos.y,z=pos.z}
			local nodez={x=pos.x,y=pos.y,z=pos.z+1}
			local nodez2={x=pos.x,y=pos.y,z=pos.z-1}
			local nodey=minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z})
			if (minetest.get_node(nodex).name=="monorail:accelerator_on" and monorail_func:is_rail(nodex2))
				or (nodey.name=="monorail:accelerator_on" and monorail_func:is_rail(nodex2) and not monorail_func:is_rail(nodex) 
				and not monorail_func:is_rail(nodez) and not monorail_func:is_rail(nodez2)) then
				if minetest.get_node(nodex).name=="monorail:accelerator_on" then
				        minetest.env:set_node(nodex, {name="monorail:accelerator_off"})
				end
				self.current_direction.x = -1
				self.current_direction.z = 0
			elseif (minetest.get_node(nodez).name=="monorail:accelerator_on" and monorail_func:is_rail(nodez2))
				or (nodey.name=="monorail:accelerator_on" and monorail_func:is_rail(nodez2) and not monorail_func:is_rail(nodex) 
				and not monorail_func:is_rail(nodez) and not monorail_func:is_rail(nodex2)) then
				if minetest.get_node(nodez).name=="monorail:accelerator_on" then
				        minetest.env:set_node(nodez, {name="monorail:accelerator_off"})
				end
				self.current_direction.x = 0
				self.current_direction.z = -1
			elseif (minetest.get_node(nodez2).name=="monorail:accelerator_on" and monorail_func:is_rail(nodez))
				or (nodey.name=="monorail:accelerator_on" and monorail_func:is_rail(nodez) and not monorail_func:is_rail(nodex) 
				and not monorail_func:is_rail(nodez2) and not monorail_func:is_rail(nodex2)) then
				if minetest.get_node(nodez2).name=="monorail:accelerator_on" then
				        minetest.env:set_node(nodez2, {name="monorail:accelerator_off"})
				end
				self.current_direction.x = 0
				self.current_direction.z = 1
			elseif (minetest.get_node(nodex2).name=="monorail:accelerator_on" and monorail_func:is_rail(nodex))
				or (nodey.name=="monorail:accelerator_on" and monorail_func:is_rail(nodex) and not monorail_func:is_rail(nodez) 
				and not monorail_func:is_rail(nodez2) and not monorail_func:is_rail(nodex2)) then
				if minetest.get_node(nodex2).name=="monorail:accelerator_on" then
				        minetest.env:set_node(nodex2, {name="monorail:accelerator_off"})
				end

				self.current_direction.x = 1
				self.current_direction.z = 0
			else
				return
			end
			if nodey.name=="monorail:accelerator_on" then
			        minetest.env:set_node({x=pos.x,y=pos.y-1,z=pos.z}, {name="monorail:accelerator_off"})
			end
			self:recalculate_way()
			self.current_speed = 5
			self:get_moving()
			return
	
	else
		self.dtime=self.dtime+dtime
	end
end

minetest.register_entity("monorail:cart", cart)

function monorail_calc_distance(pos1,pos2)
if pos1==nil or pos2==nil then
return 99
end
	return math.sqrt(   math.pow(pos1.x-pos2.x,2) +
					math.pow(pos1.y-pos2.y,2) +
					math.pow(pos1.z-pos2.z,2))
end

minetest.register_craftitem("monorail:cart", {
	description = "Cart",
	inventory_image = minetest.inventorycube("monorail_top.png", "monorail_side.png", "monorail_side.png"),
	
	on_place = function(itemstack, placer, pointed_thing)
		if not pointed_thing.type == "node" then
			return
		end
		if monorail_func:is_rail(pointed_thing.under) then
			minetest.add_entity(pointed_thing.under, "monorail:cart")
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		elseif monorail_func:is_rail(pointed_thing.above) then
			minetest.add_entity(pointed_thing.above, "monorail:cart")
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end
	end,
})

--Transport Cart

function transport_cart_button_handler(player, formname, fields)
	if formname == "monorail_rightclick:main" then
		for k,v in pairs(fields) do
			local parts = string.split(k,"_")

			if parts[1] == "pbrightclick" then
				local tansport_cart_store_id = parts[2]
				local todo = parts[3]

				local cart = monorail_global_data_get(tansport_cart_store_id)

				if cart ~= nil then
					local playername = player:get_player_name()
					local distance = monorail_calc_distance(cart.object:getpos(),player:getpos())

					if distance > 4 then
						minetest.chat_send_player(playername, "Too far away from transport cart")
						return true
					end

					if todo == "take" and
						cart.inventory:is_empty("main") then
						--print("Info: "..detect_slider_type(self.object:getpos()).. " :",self.moving_up)
						player:get_inventory():add_item("main", "monorail:transport_cart")
						cart.object:remove()
					end

					if todo == "inventory" then
						minetest.show_formspec(playername,"transport_cart_formspec",
							"size[8,9;]"..
							"label[0,0;Transport cart content:]" ..
							"list[detached:" .. cart.inventoryname .. ";main;2,1;4,3;]"..
							"list[current_player;main;0,5;8,4;]")
					end
				end
			end
		end
		return true
	end
	return false
end

--function transport_cart_onpunch_handler(self,hitter)
--	cart:on_punch(hitter)
--end


minetest.register_on_player_receive_fields(transport_cart_button_handler)



local transportcart = {
	physical = false,
	collisionbox = {-0.5,-0.5,-0.5, 0.5,0.5,0.5},
	visual = "cube",
	textures = {"monorail_transport.png","monorail_bottom.png","monorail_side.png","monorail_side.png","monorail_side.png","monorail_side.png"},
	visual_size     = {x=1,y=1},
	groups = { immortal=1, },
	
	driver = nil,
	
	old_pos = nil,	--rounded
	old_direction = {x=0, y=0, z=0},
	
	current_pos = nil,	--rounded
	current_direction = {x=0, y=0, z=0},
	
	next_pos = nil,	--rounded
	
	current_speed = 0,	--positive
	MAX_SPEED = 9, -- Limit of the velocity
		
	on_activate = function(self, staticdata)
	self.object:set_armor_groups({immortal=1})
	self.old_pos = monorail_func.v3:round( self.object:getpos() )
	self.current_pos = monorail_func.v3:round( self.object:getpos() )
	self.next_pos = monorail_func.v3:round( self.object:getpos() )
	self.driver=nil
	self.dtime=0	
	local p=self.current_pos
	
	if not monorail_func:is_rail( self.current_pos ) then
		minetest.log("action", "Removing old chart at "..self.current_pos.x..","..self.current_pos.y..","..self.current_pos.z)
		if self.driver ~= nil then
			self.driver:set_detach()
		end
		self.object:remove()
		return
	elseif monorail_func:is_rail({x=p.x, y=p.y-1, z=p.z-1}) or monorail_func:is_rail({x=p.x, y=p.y+1, z=p.z+1}) then
		self.next_pos={x=p.x, y=p.y, z=p.z-1}
		self.current_direction={x=0, y=0, z=-1}
		self.current_speed=1
		self:recalculate_way()
		self:get_moving()
	elseif monorail_func:is_rail({x=p.x, y=p.y-1, z=p.z+1}) or monorail_func:is_rail({x=p.x, y=p.y+1, z=p.z-1}) then
		self.next_pos={x=p.x, y=p.y, z=p.z+1}
		self.current_direction={x=0, y=0, z=1}
		self.current_speed=1
		self:recalculate_way()
		self:get_moving()
	elseif monorail_func:is_rail({x=p.x-1, y=p.y-1, z=p.z}) or monorail_func:is_rail({x=p.x+1, y=p.y+1, z=p.z}) then
		self.next_pos={x=p.x-1, y=p.y, z=p.z}
		self.current_direction={x=-1, y=0, z=0}
		self.current_speed=1
		self:recalculate_way()
		self:get_moving()
	elseif monorail_func:is_rail({x=p.x+1, y=p.y-1, z=p.z}) or monorail_func:is_rail({x=p.x-1, y=p.y+1, z=p.z}) then
		self.next_pos={x=p.x+1, y=p.y, z=p.z}
		self.current_direction={x=1, y=0, z=0}
		self.current_speed=1
		self:recalculate_way()
		self:get_moving()
	end
		self.inventoryname = string.gsub(tostring(self),"table: ","")
		

		self.inventory = minetest.create_detached_inventory(self.inventoryname, nil)

		self.inventory:set_size("main",12)

		local restored = minetest.deserialize(staticdata)

		if restored ~= nil then
			if restored.stacks ~= nil then
				for i=1,#restored.stacks,1 do
					self.inventory:set_stack("main",i,restored.stacks[i])
				end
			end

		end
	end,

	get_staticdata = function(self)
		local stacks = {}
		local list = self.inventory:get_list("main")
		for i=1,#list,1 do
			table.insert(stacks,list[i]:to_string())
		end
		return minetest.serialize({
		current_speed = self.current_speed,
		current_direction = self.current_direction,
		stacks=stacks,
		})
	end,

	on_rightclick = function(self,clicker)

		--get rightclick storage id
		local storage_id = monorail_global_data_store(self)
		local y_pos = 0.25
		local buttons = ""

		local playername = clicker:get_player_name()

if self.inventory:is_empty("main")then
		buttons = buttons .. "button_exit[0," .. y_pos .. ";2.5,0.5;" ..
					"pbrightclick_" .. storage_id .. "_inventory;Content]"


			y_pos = y_pos + 0.75
	
			buttons = buttons .. "button_exit[0," .. y_pos .. ";2.5,0.5;" ..
						"pbrightclick_" .. storage_id .. "_take;Take]"
else
				local cart = monorail_global_data_get(storage_id)

				if cart ~= nil then
					local distance = monorail_calc_distance(cart.object:getpos(),clicker:getpos())

					if distance > 4 then
						minetest.chat_send_player(playername, "Too far away from transport cart")
						return true
					end


						minetest.show_formspec(playername,"transport_cart_formspec",
							"size[8,9;]"..
							"label[0,0;Transport cart content:]" ..
							"list[detached:" .. string.gsub(tostring(self),"table: ","") .. ";main;2,1;4,3;]"..
							"list[current_player;main;0,5;8,4;]")
return true
end
end

		y_pos = y_pos + 0.5

		local y_size = y_pos

		local formspec = "size[2.5," .. y_size .. "]" ..
				buttons

		if playername ~= nil then
			--TODO start form close timer
			minetest.show_formspec(playername,"monorail_rightclick:main",formspec)
		end
		return true
	end


}


-- Remove the cart if holding a tool or accelerate it
function transportcart:on_punch(puncher, time_from_last_punch, tool_capabilities, direction)
	if not puncher or not puncher:is_player() then
		return
	end
	
	if puncher:get_player_control().sneak then
		-- first partially drop driver from the cart, only then remove cart
		if self.driver ~= nil then
			self.driver:set_detach()
		end
		self.object:remove()
		local inv = puncher:get_inventory()
		local cart="monorail:transport_cart" 
		if minetest.setting_getbool("creative_mode") then
			if not inv:contains_item("main", cart) then
				inv:add_item("main", cart)
			end
		else
			inv:add_item("main", cart)
		end
		return
	end
	
	if puncher == self.driver then
		return
	end
	
	local d = monorail_func:velocity_to_dir(direction)
	if time_from_last_punch > tool_capabilities.full_punch_interval then
		time_from_last_punch = tool_capabilities.full_punch_interval
	end
	local f = 4*(time_from_last_punch/tool_capabilities.full_punch_interval)
	
	--change speed or stop cart
	if monorail_func.v3:empty( self.current_direction ) or self.current_speed == 0 then
		self.current_direction.x = d.x
		self.current_direction.z = d.z
		self:recalculate_way()
		self.current_speed = f
	elseif d.x==self.current_direction.x and d.z==self.current_direction.z then
		self.current_speed=self.current_speed + f
	else
		self.current_speed = 0
	end
	
	-- Speed limits
	if self.current_speed < 0 then
		self.current_speed = 0
	end
	if self.current_speed > self.MAX_SPEED then
		self.current_speed = self.MAX_SPEED
	end
	
	self:get_moving()
	
end

--step done. all checked. now just calculate next rail and direction
function transportcart:recalculate_way()
	if not monorail_func.v3:empty(self.current_direction) and self.current_speed>0 then
		local p=monorail_func.v3:copy(self.current_pos)
		-- Check player control.
		--this code is long, but optimal enough. If you think you can make it better - do it.
		local switch=false
		local left=false
		local right=false
		if minetest.get_node({x=p.x+1, y=p.y, z=p.z}).name=="monorail:switch_on" or minetest.get_node({x=p.x-1, y=p.y, z=p.z}).name=="monorail:switch_on"
			or minetest.get_node({x=p.x, y=p.y, z=p.z+1}).name=="monorail:switch_on" or minetest.get_node({x=p.x, y=p.y, z=p.z-1}).name=="monorail:switch_on" then
			switch=true
		end
		if self.driver and self.driver:is_player() then
			if self.driver:get_player_control().right then
				right=true
			end
			if self.driver:get_player_control().left then
				left=true
			end
		end
			if switch or left then
				if self.current_direction.x == -1 then
					if monorail_func:is_rail({x=p.x, y=p.y, z=p.z-1}) then
						self.next_pos={x=p.x, y=p.y, z=p.z-1}
						self.current_direction={x=0, y=0, z=-1}
						return
					end
					if monorail_func:is_rail({x=p.x, y=p.y-1, z=p.z-1}) then
						self.next_pos={x=p.x, y=p.y-1, z=p.z-1}
						self.current_direction={x=0, y=-1, z=-1}
						return
					end
					if monorail_func:is_rail({x=p.x, y=p.y+1, z=p.z-1}) then
						self.next_pos={x=p.x, y=p.y+1, z=p.z-1}
						self.current_direction={x=0, y=1, z=-1}
						return
					end
				end
				if self.current_direction.x == 1 then
					if monorail_func:is_rail({x=p.x, y=p.y, z=p.z+1}) then
						self.next_pos={x=p.x, y=p.y, z=p.z+1}
						self.current_direction={x=0, y=0, z=1}
						return
					end
					if monorail_func:is_rail({x=p.x, y=p.y+1, z=p.z+1}) then
						self.next_pos={x=p.x, y=p.y+1, z=p.z+1}
						self.current_direction={x=0, y=1, z=1}
						return
					end
					if monorail_func:is_rail({x=p.x, y=p.y-1, z=p.z+1}) then
						self.next_pos={x=p.x, y=p.y-1, z=p.z+1}
						self.current_direction={x=0, y=-1, z=1}
						return
					end
				end
				if self.current_direction.z == -1 then
					if monorail_func:is_rail({x=p.x+1, y=p.y, z=p.z}) then
						self.next_pos={x=p.x+1, y=p.y, z=p.z}
						self.current_direction={x=1, y=0, z=0}
						return
					end
					if monorail_func:is_rail({x=p.x+1, y=p.y+1, z=p.z}) then
						self.next_pos={x=p.x+1, y=p.y+1, z=p.z}
						self.current_direction={x=1, y=1, z=0}
						return
					end
					if monorail_func:is_rail({x=p.x+1, y=p.y-1, z=p.z}) then
						self.next_pos={x=p.x+1, y=p.y-1, z=p.z}
						self.current_direction={x=1, y=-1, z=0}
						return
					end
				end
				if self.current_direction.z == 1 then
					if monorail_func:is_rail({x=p.x-1, y=p.y, z=p.z}) then
						self.next_pos={x=p.x-1, y=p.y, z=p.z}
						self.current_direction={x=-1, y=0, z=0}
						return
					end
					if monorail_func:is_rail({x=p.x-1, y=p.y+1, z=p.z}) then
						self.next_pos={x=p.x-1, y=p.y+1, z=p.z}
						self.current_direction={x=-1, y=1, z=0}
						return
					end
					if monorail_func:is_rail({x=p.x-1, y=p.y-1, z=p.z}) then
						self.next_pos={x=p.x-1, y=p.y-1, z=p.z}
						self.current_direction={x=-1, y=-1, z=0}
						return
					end
				end

			end
			if switch or right then
				if self.current_direction.x == 1 then
					if monorail_func:is_rail({x=p.x, y=p.y, z=p.z-1}) then
						self.next_pos={x=p.x, y=p.y, z=p.z-1}
						self.current_direction={x=0, y=0, z=-1}
						return
					end
					if monorail_func:is_rail({x=p.x, y=p.y-1, z=p.z-1}) then
						self.next_pos={x=p.x, y=p.y-1, z=p.z-1}
						self.current_direction={x=0, y=-1, z=-1}
						return
					end
					if monorail_func:is_rail({x=p.x, y=p.y+1, z=p.z-1}) then
						self.next_pos={x=p.x, y=p.y+1, z=p.z-1}
						self.current_direction={x=0, y=1, z=-1}
						return
					end
				end
				if self.current_direction.x == -1 then
					if monorail_func:is_rail({x=p.x, y=p.y, z=p.z+1}) then
						self.next_pos={x=p.x, y=p.y, z=p.z+1}
						self.current_direction={x=0, y=0, z=1}
						return
					end
					if monorail_func:is_rail({x=p.x, y=p.y+1, z=p.z+1}) then
						self.next_pos={x=p.x, y=p.y+1, z=p.z+1}
						self.current_direction={x=0, y=1, z=1}
						return
					end
					if monorail_func:is_rail({x=p.x, y=p.y-1, z=p.z+1}) then
						self.next_pos={x=p.x, y=p.y-1, z=p.z+1}
						self.current_direction={x=0, y=-1, z=1}
						return
					end
				end
				if self.current_direction.z == 1 then
					if monorail_func:is_rail({x=p.x+1, y=p.y, z=p.z}) then
						self.next_pos={x=p.x+1, y=p.y, z=p.z}
						self.current_direction={x=1, y=0, z=0}
						return
					end
					if monorail_func:is_rail({x=p.x+1, y=p.y+1, z=p.z}) then
						self.next_pos={x=p.x+1, y=p.y+1, z=p.z}
						self.current_direction={x=1, y=1, z=0}
						return
					end
					if monorail_func:is_rail({x=p.x+1, y=p.y-1, z=p.z}) then
						self.next_pos={x=p.x+1, y=p.y-1, z=p.z}
						self.current_direction={x=1, y=-1, z=0}
						return
					end
				end
				if self.current_direction.z == -1 then
					if monorail_func:is_rail({x=p.x-1, y=p.y, z=p.z}) then
						self.next_pos={x=p.x-1, y=p.y, z=p.z}
						self.current_direction={x=-1, y=0, z=0}
						return
					end
					if monorail_func:is_rail({x=p.x-1, y=p.y+1, z=p.z}) then
						self.next_pos={x=p.x-1, y=p.y+1, z=p.z}
						self.current_direction={x=-1, y=1, z=0}
						return
					end
					if monorail_func:is_rail({x=p.x-1, y=p.y-1, z=p.z}) then
						self.next_pos={x=p.x-1, y=p.y-1, z=p.z}
						self.current_direction={x=-1, y=-1, z=0}
						return
					end
				end
			end

		local pp = monorail_func.v3:add(monorail_func.v3:copy(self.current_pos), self.current_direction)
		pp.y=self.current_pos.y --y is handled differently
		-- Check right and left. positive direction has priority. not sure about uphill/downhill priority.
		p=monorail_func.v3:copy(self.current_pos)
		-- Check front
		if monorail_func:is_rail(pp) then
			self.next_pos=pp
			self.current_direction={x=self.current_direction.x, y=0, z=self.current_direction.z}
			return
		end
		-- Check downhill
		if monorail_func:is_rail({x=pp.x, y=pp.y-1, z=pp.z}) then
			self.next_pos={x=pp.x, y=pp.y-1, z=pp.z}
			self.current_direction={x=self.current_direction.x, y=-1, z=self.current_direction.z}
			return
		end
		-- Check uphill
		if monorail_func:is_rail({x=pp.x, y=pp.y+1, z=pp.z}) then
			self.next_pos={x=pp.x, y=pp.y+1, z=pp.z}
			self.current_direction={x=self.current_direction.x, y=1, z=self.current_direction.z}
			return
		end
		if math.abs(self.current_direction.x)==1 then
			if monorail_func:is_rail({x=p.x, y=p.y, z=p.z+1}) then
				self.next_pos={x=p.x, y=p.y, z=p.z+1}
				self.current_direction={x=0, y=0, z=1}
			return
			end
			if monorail_func:is_rail({x=p.x, y=p.y, z=p.z-1}) then
				self.next_pos={x=p.x, y=p.y, z=p.z-1}
				self.current_direction={x=0, y=0, z=-1}
			return
			end
			if monorail_func:is_rail({x=p.x, y=p.y+1, z=p.z+1}) then
				self.next_pos={x=p.x, y=p.y+1, z=p.z+1}
				self.current_direction={x=0, y=1, z=1}
			return
			end
			if monorail_func:is_rail({x=p.x, y=p.y-1, z=p.z-1}) then
				self.next_pos={x=p.x, y=p.y-1, z=p.z-1}
				self.current_direction={x=0, y=-1, z=-1}
			return
			end
			if monorail_func:is_rail({x=p.x, y=p.y+1, z=p.z-1}) then
				self.next_pos={x=p.x, y=p.y+1, z=p.z-1}
				self.current_direction={x=0, y=1, z=-1}
			return
			end
			if monorail_func:is_rail({x=p.x, y=p.y-1, z=p.z+1}) then
				self.next_pos={x=p.x, y=p.y-1, z=p.z+1}
				self.current_direction={x=0, y=-1, z=1}
			return
			end
		end
		if math.abs(self.current_direction.z)==1 then
			if monorail_func:is_rail({x=p.x+1, y=p.y, z=p.z}) then
				self.next_pos={x=p.x+1, y=p.y, z=p.z}
				self.current_direction={x=1, y=0, z=0}
			return
			end
			if monorail_func:is_rail({x=p.x-1, y=p.y, z=p.z}) then
				self.next_pos={x=p.x-1, y=p.y, z=p.z}
				self.current_direction={x=-1, y=0, z=0}
			return
			end
			if monorail_func:is_rail({x=p.x+1, y=p.y+1, z=p.z}) then
				self.next_pos={x=p.x+1, y=p.y+1, z=p.z}
				self.current_direction={x=1, y=1, z=0}
			return
			end
			if monorail_func:is_rail({x=p.x-1, y=p.y-1, z=p.z}) then
				self.next_pos={x=p.x-1, y=p.y-1, z=p.z}
				self.current_direction={x=-1, y=-1, z=0}
			return
			end
			if monorail_func:is_rail({x=p.x-1, y=p.y+1, z=p.z}) then
				self.next_pos={x=p.x-1, y=p.y+1, z=p.z}
				self.current_direction={x=-1, y=1, z=0}
			return
			end
			if monorail_func:is_rail({x=p.x+1, y=p.y-1, z=p.z}) then
				self.next_pos={x=p.x+1, y=p.y-1, z=p.z}
				self.current_direction={x=1, y=-1, z=0}
			return
			end
		end
		-- Else it is ded-end, check that somewhere.
		minetest.log("action","Cart stopped at: "..minetest.get_node( monorail_func.v3:add( self.next_pos, self.current_direction ) ).name) --debug
		self.current_direction = {x=0, y=0, z=0}
		
		self.next_pos = p
	end
end

-- Handle chart physical stuff
function transportcart:get_moving()
	
	local pos = self.object:getpos()
	
	local correction_x = (self.current_pos.x-pos.x)*0.2
	local correction_y = (self.current_pos.y-pos.y)*0.2
	local correction_z = (self.current_pos.z-pos.z)*0.2
	
	-- Actually change cart speed
	if math.abs(self.current_direction.y) == 1 and math.abs(self.current_direction.x) == 1 then
		self.object:setvelocity({x=self.current_direction.x*self.current_speed*0.71, y=self.current_direction.y*self.current_speed*0.71, z=correction_z})
	elseif math.abs(self.current_direction.y) == 1 and math.abs(self.current_direction.z) == 1 then
		self.object:setvelocity({x=correction_x, y=self.current_direction.y*self.current_speed*0.71, z=self.current_direction.z*self.current_speed*0.71})
	elseif math.abs(self.current_direction.x) == 1 then
		self.object:setvelocity({x=self.current_direction.x*self.current_speed, y=correction_y, z=correction_z})
	elseif math.abs(self.current_direction.z) == 1 then
		self.object:setvelocity({x=correction_x, y=correction_y, z=self.current_direction.z*self.current_speed})
	end
	
	-- Direction
	if self.current_direction.x < 0 then
		self.object:setyaw(math.pi/2)
	elseif self.current_direction.x > 0 then
		self.object:setyaw(3*math.pi/2)
	elseif self.current_direction.z < 0 then
		self.object:setyaw(math.pi)
	elseif self.current_direction.z > 0 then
		self.object:setyaw(0)
	end
	
	-- And animation.
	if self.current_direction.y == -1 then
		self.object:set_animation({x=1, y=1}, 1, 0)
	elseif self.current_direction.y == 1 then
		self.object:set_animation({x=2, y=2}, 1, 0)
	else
		self.object:set_animation({x=0, y=0}, 1, 0)
	end
	
end

-- Correct cart position on rail
function transportcart:precize_on_rail(pos)
	if self.current_direction.x == 0 and math.abs(self.current_pos.x-pos.x)>0.2 then
		self.object:setpos(self.current_pos)
	elseif self.current_direction.z == 0 and math.abs(self.current_pos.z-pos.z)>0.2 then
		self.object:setpos(self.current_pos)
	elseif self.current_direction.y == 0 and math.abs(self.current_pos.y-pos.y)>0.2 then
		self.object:setpos(self.current_pos)
	end
end

function transportcart:on_step(dtime)
	
	local pos = self.object:getpos()
	local new_pos=monorail_func.v3:round(pos) --rounded
	-- When on new position, check the route
	if not monorail_func.v3:equal( self.current_pos, new_pos ) then
		--wait for unloaded world
		if self.next_pos and self.driver and minetest.get_node( monorail_func.v3:add( self.next_pos, self.current_direction ) ).name == "ignore" then
			self.object:setvelocity({x=0, y=0, z=0}) --don't move cart, until world ahead is loaded
			return
		end
		local newpos ={x=new_pos.x-1,y=new_pos.y,z=new_pos.z}
		if minetest.get_node(newpos).name == "monorail:cart_detector_off" then
			minetest.env:add_node(newpos,{name="monorail:cart_detector_on"})
			mesecon.receptor_on(newpos, mesecon.rules.default)
		end
		newpos ={x=new_pos.x+1,y=new_pos.y,z=new_pos.z}
		if minetest.get_node(newpos).name == "monorail:cart_detector_off" then
			minetest.env:add_node(newpos,{name="monorail:cart_detector_on"})
			mesecon.receptor_on(newpos, mesecon.rules.default)
		end
		newpos ={x=new_pos.x,y=new_pos.y,z=new_pos.z-1}
		if minetest.get_node(newpos).name == "monorail:cart_detector_off" then
			minetest.env:add_node(newpos,{name="monorail:cart_detector_on"})
			mesecon.receptor_on(newpos, mesecon.rules.default)
		end
		newpos ={x=new_pos.x,y=new_pos.y,z=new_pos.z+1}
		if minetest.get_node(newpos).name == "monorail:cart_detector_off" then
			minetest.env:add_node(newpos,{name="monorail:cart_detector_on"})
			mesecon.receptor_on(newpos, mesecon.rules.default)
		end
		newpos ={x=new_pos.x,y=new_pos.y-1,z=new_pos.z}
		if minetest.get_node(newpos).name == "monorail:cart_detector_off" then
			minetest.env:add_node(newpos,{name="monorail:cart_detector_on"})
			mesecon.receptor_on(newpos, mesecon.rules.default)
		end

		--move back if out of road
		if not monorail_func:is_rail(new_pos) then
			if monorail_func:is_rail(self.next_pos) then
				self.object:setpos(self.next_pos)
				self.current_pos = monorail_func.v3:copy(self.next_pos)
				self.current_speed=self.current_speed-0.01
			elseif monorail_func:is_rail(self.current_pos) then
				self.object:setpos(self.current_pos)
				self.current_speed=self.current_speed-0.01
			else
				if self.driver ~= nil then
					self.driver:set_detach()
				end
				self.object:remove() --not on rails
				return
			end
		else
			self.old_pos=self.current_pos
			self.current_pos=new_pos
		end
		
		-- Direction to new rail node
		self:recalculate_way()
		
		-- Stop if ded-end
		if monorail_func.v3:empty(self.current_direction ) then
			self.object:setvelocity({x=0, y=0, z=0})
			self:precize_on_rail(pos)
			self.current_speed = 0
			return
		end
		
		-- Increase or decrease speed on uphill/downhill
		if self.current_direction.y == 1 then
			self.current_speed = self.current_speed - 0.8
		end
		if self.current_direction.y == -1 then
			self.current_speed = self.current_speed + 0.8
		end
		
		-- Decrease speed a little at any rail.
		self.current_speed = self.current_speed - 0.1
		
		
		-- Increase or decrease speed on powerrail/brakerail  LATER!!!
		if minetest.get_node(self.current_pos).name == "monorail:powerrail" or minetest.get_node(self.current_pos).name == "monorail:brakerail" then
			local accel=minetest.get_meta(pos):get_string("cart_acceleration")
			if accel~=nil then
				if tonumber(accel)~=nil then
				self.current_speed = self.current_speed + tonumber(accel)
				end
			end
		end
		
		
		-- Speed limits
		if self.current_speed < 0 then
			self.current_speed = 0
		end
		if self.current_speed > self.MAX_SPEED then
			self.current_speed = self.MAX_SPEED
		end
		
		-- Stop the cart if the velocity is nearly 0
		-- On all, not just flat
		if self.current_speed < 0.1 and self.current_direction.y == 0 then
			self:precize_on_rail(pos)
			self.object:setvelocity({x=0, y=0, z=0})
			return
		end
		
		-- Move opposite direction if the velocity is nearly 0 but not stopped yet
		-- Only uphill/downhill
		 if self.current_speed < 0.8 and self.current_direction.y ~= 0 then
			 self.current_direction={x=-self.current_direction.x, y=-self.current_direction.y, z=-self.current_direction.z}
			 self.object:setvelocity({x=0, y=0, z=0})
			 self.current_speed = 1
			 self.next_pos=monorail_func.v3:copy(self.old_pos)
			 self:recalculate_way()
		 end
		
		-- Need to move cart precise on rail.
		self:precize_on_rail(pos)
		
		self:get_moving()

	elseif self.dtime>0.8 and self.current_speed == 0 then
			self.dtime=0
			local all_objects = minetest.get_objects_inside_radius(pos, 0.6)
			for _,obj in ipairs(all_objects) do
				if obj:get_luaentity() ~= nil then
					if obj:get_luaentity().name == "monorail:cart" and obj:get_luaentity().driver~=nil then
						return
					end
				end
			end
			local nodex={x=pos.x+1,y=pos.y,z=pos.z}
			local nodex2={x=pos.x-1,y=pos.y,z=pos.z}
			local nodez={x=pos.x,y=pos.y,z=pos.z+1}
			local nodez2={x=pos.x,y=pos.y,z=pos.z-1}
			local nodey=minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z})
			if (minetest.get_node(nodex).name=="monorail:accelerator_on" and monorail_func:is_rail(nodex2))
				or (nodey.name=="monorail:accelerator_on" and monorail_func:is_rail(nodex2) and not monorail_func:is_rail(nodex) 
				and not monorail_func:is_rail(nodez) and not monorail_func:is_rail(nodez2)) then
				if minetest.get_node(nodex).name=="monorail:accelerator_on" then
				        minetest.env:set_node(nodex, {name="monorail:accelerator_off"})
				end
				self.current_direction.x = -1
				self.current_direction.z = 0
			elseif (minetest.get_node(nodez).name=="monorail:accelerator_on" and monorail_func:is_rail(nodez2))
				or (nodey.name=="monorail:accelerator_on" and monorail_func:is_rail(nodez2) and not monorail_func:is_rail(nodex) 
				and not monorail_func:is_rail(nodez) and not monorail_func:is_rail(nodex2)) then
				if minetest.get_node(nodez).name=="monorail:accelerator_on" then
				        minetest.env:set_node(nodez, {name="monorail:accelerator_off"})
				end
				self.current_direction.x = 0
				self.current_direction.z = -1
			elseif (minetest.get_node(nodez2).name=="monorail:accelerator_on" and monorail_func:is_rail(nodez))
				or (nodey.name=="monorail:accelerator_on" and monorail_func:is_rail(nodez) and not monorail_func:is_rail(nodex) 
				and not monorail_func:is_rail(nodez2) and not monorail_func:is_rail(nodex2)) then
				if minetest.get_node(nodez2).name=="monorail:accelerator_on" then
				        minetest.env:set_node(nodez2, {name="monorail:accelerator_off"})
				end
				self.current_direction.x = 0
				self.current_direction.z = 1
			elseif (minetest.get_node(nodex2).name=="monorail:accelerator_on" and monorail_func:is_rail(nodex))
				or (nodey.name=="monorail:accelerator_on" and monorail_func:is_rail(nodex) and not monorail_func:is_rail(nodez) 
				and not monorail_func:is_rail(nodez2) and not monorail_func:is_rail(nodex2)) then
				if minetest.get_node(nodex2).name=="monorail:accelerator_on" then
				        minetest.env:set_node(nodex2, {name="monorail:accelerator_off"})
				end

				self.current_direction.x = 1
				self.current_direction.z = 0
			else
				return
			end
			if nodey.name=="monorail:accelerator_on" then
			        minetest.env:set_node({x=pos.x,y=pos.y-1,z=pos.z}, {name="monorail:accelerator_off"})
			end			self:recalculate_way()
			self.current_speed = 5
			self:get_moving()
			return
	
	else
	self.dtime=self.dtime+dtime	
	end
end

minetest.register_entity("monorail:transport_cart", transportcart)



	tcart_inventorycube = minetest.inventorycube("monorail_transport.png",
													"monorail_side.png",
													"monorail_side.png")
minetest.register_craftitem("monorail:transport_cart", {
	description = "Transport Cart",
	image = tcart_inventorycube,
	
	on_place = function(itemstack, placer, pointed_thing)
		if not pointed_thing.type == "node" then
			return
		end
		if monorail_func:is_rail(pointed_thing.under) then
			minetest.add_entity(pointed_thing.under, "monorail:transport_cart")
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		elseif monorail_func:is_rail(pointed_thing.above) then
			minetest.add_entity(pointed_thing.above, "monorail:transport_cart")
			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end
	end,
})


--
-- Mesecon support
--

minetest.register_node(":default:rail", {
	description = "Rail",
	drawtype = "raillike",
	tiles = {"default_rail.png", "default_rail_curved.png", "default_rail_t_junction.png", "default_rail_crossing.png"},
	inventory_image = "default_rail.png",
	wield_image = "default_rail.png",
	paramtype = "light",
	is_ground_content = true,
	walkable = false,
	after_place_node = function(pos, placer, itemstack)
		if placer:get_player_name()~=nil then
			if not minetest.check_player_privs(placer:get_player_name(), {settime=true}) then
				minetest.get_meta(pos):set_string("owner", placer:get_player_name())
			end
		end
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local name=player:get_player_name()
		if player==nil then return false end
		if minetest.check_player_privs(name, {settime=true}) then
			return true
		end
		if meta==nil then return false end
		return meta:get_string("owner")~=""
		
	end,
	selection_box = {
		type = "fixed",
		-- but how to specify the dimensions for curved and sideways rails?
		fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	groups = {bendy=2,cracky=1,rail=1,connect_to_raillike=1,level=2},
})

minetest.register_node("monorail:powerrail", {
	description = "Powered Rail",
	drawtype = "raillike",
	tiles = {"monorail_rail_pwr.png", "monorail_rail_curved_pwr.png", "monorail_rail_t_junction_pwr.png", "monorail_rail_crossing_pwr.png"},
	inventory_image = "monorail_rail_pwr.png",
	wield_image = "monorail_rail_pwr.png",
	paramtype = "light",
	is_ground_content = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		-- but how to specify the dimensions for curved and sideways rails?
		fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	groups = {bendy=2,cracky=1,rail=1,connect_to_raillike=1,level=2},
	
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local name=player:get_player_name()
		if player==nil then return false end
		if minetest.check_player_privs(name, {settime=true}) then
			return true
		end
		if meta==nil then return false end
		return meta:get_string("owner")~=""
		
	end,
	after_place_node = function(pos, placer, itemstack)
		if placer:get_player_name()~=nil then
			if not minetest.check_player_privs(placer:get_player_name(), {settime=true}) then
				minetest.get_meta(pos):set_string("owner", placer:get_player_name())
			end
		end
		if not mesecon then
			minetest.get_meta(pos):set_string("cart_acceleration", "1.32")
		end
	end,
	
	mesecons = {
		effector = {
			action_on = function(pos, node)
				minetest.get_meta(pos):set_string("cart_acceleration", "1.32")
			end,
			
			action_off = function(pos, node)
				minetest.get_meta(pos):set_string("cart_acceleration", "0")
			end,
		},
	},
})

minetest.register_node("monorail:brakerail", {
	description = "Brake Rail",
	drawtype = "raillike",
	tiles = {"monorail_rail_brk.png", "monorail_rail_curved_brk.png", "monorail_rail_t_junction_brk.png", "monorail_rail_crossing_brk.png"},
	inventory_image = "monorail_rail_brk.png",
	wield_image = "monorail_rail_brk.png",
	paramtype = "light",
	is_ground_content = true,
	walkable = false,
	selection_box = {
		type = "fixed",
		-- but how to specify the dimensions for curved and sideways rails?
		fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
	},
	groups = {bendy=2,cracky=1,rail=1,connect_to_raillike=1,level=2},
	
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local name=player:get_player_name()
		if player==nil then return false end
		if minetest.check_player_privs(name, {settime=true}) then
			return true
		end
		if meta==nil then return false end
		return meta:get_string("owner")~=""
		
	end,

	after_place_node = function(pos, placer, itemstack)
		if placer:get_player_name()~=nil then
			if not minetest.check_player_privs(placer:get_player_name(), {settime=true}) then
				minetest.get_meta(pos):set_string("owner", placer:get_player_name())
			end
		end
		if not mesecon then
			minetest.get_meta(pos):set_string("cart_acceleration", "-0.8")
		end
	end,
	
	mesecons = {
		effector = {
			action_on = function(pos, node)
				minetest.get_meta(pos):set_string("cart_acceleration", "-0.8")
			end,
			
			action_off = function(pos, node)
				minetest.get_meta(pos):set_string("cart_acceleration", "0")
			end,
		},
	},
})




--------------------------------------------------------------------------------
--
-- Crafts
--
--------------------------------------------------------------------------------

	minetest.register_craft({
		output = "monorail:cart",
		recipe = {
			{"", "", ""},
			{"default:steel_ingot", "", "default:steel_ingot"},
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		},
	})

		minetest.register_craft({
		output = "monorail:transport_cart",
		recipe = {
			{"", "", ""},
			{"default:steel_ingot", "default:chest_locked", "default:steel_ingot"},
			{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		},
	})


minetest.register_craft({
    output = 'craft "monorail:switch_off" 1',
    recipe = {
        {"default:stick"},
        {"default:steel_ingot"},
    }
})


	minetest.register_craft({
		output = "monorail:powerrail 2",
		recipe = {
			{"default:steel_ingot", "default:mese_crystal_fragment", "default:steel_ingot"},
			{"default:steel_ingot", "group:stick", "default:steel_ingot"},
			{"default:steel_ingot", "", "default:steel_ingot"},
		}
	})

	minetest.register_craft({
		output = "monorail:powerrail 2",
		recipe = {
			{"default:steel_ingot", "", "default:steel_ingot"},
			{"default:steel_ingot", "group:stick", "default:steel_ingot"},
			{"default:steel_ingot", "default:mese_crystal_fragment", "default:steel_ingot"},
		}
	})

	minetest.register_craft({
		output = "monorail:brakerail 2",
		recipe = {
			{"default:steel_ingot", "default:coal_lump", "default:steel_ingot"},
			{"default:steel_ingot", "group:stick", "default:steel_ingot"},
			{"default:steel_ingot", "", "default:steel_ingot"},
		}
	})

	minetest.register_craft({
		output = "monorail:brakerail 2",
		recipe = {
			{"default:steel_ingot", "", "default:steel_ingot"},
			{"default:steel_ingot", "group:stick", "default:steel_ingot"},
			{"default:steel_ingot", "default:coal_lump", "default:steel_ingot"},
		}
	})




minetest.register_craft({
    output = 'node "monorail:accelerator_off" 5',
    recipe = {
        {"default:cobble", "default:mese_crystal","default:cobble"},
        {"default:mese_crystal", "default:glass", "default:mese_crystal"},
        {"default:cobble", "default:mese_crystal","default:cobble"},
        }
    })

minetest.register_craft({
        output = 'node "monorail:cart_detector_off" 5',
    recipe = {
        {"default:cobble", "default:glass","default:cobble"},
        {"default:glass", "default:mese_crystal", "default:glass"},
        {"default:cobble", "default:glass","default:cobble"},
    }
})

minetest.register_alias("monorail:booster", "monorail:powerrail")
--------------------------------------------------------------------------------
--
-- Craftitems
--
--------------------------------------------------------------------------------


minetest.register_node("monorail:switch_on", {
	description = "Rail Switch",
    paramtype2 = "facedir",
    tiles = {"monorail_switch_on_top.png","monorail_switch_on_top.png","monorail_switch_on.png"},
    drop = "monorail:switch_off",
    groups = {bendy=2, snappy=1, dig_immediate=2,not_in_craft_guide=1},
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local name=player:get_player_name()
		if player==nil then return false end
		if minetest.check_player_privs(name, {settime=true}) then
			return true
		end
		if meta==nil then return false end
		return meta:get_string("owner")~=""
		
	end,
    on_punch = function(pos, node, puncher)
        node.name = "monorail:switch_off"
        minetest.env:set_node(pos, node)
    end,

    drawtype = "nodebox",
    paramtype = "light",
    node_box = {
        type = "fixed",
        fixed = {
                    -- shaft
                    {-0.05, -0.5, -0.05, 0.05, 0.0, 0.05},
                    -- head
                    {-0.25, 0.0, -0.05, 0.25, 0.5, 0.05},
                    {-0.05, 0.0, -0.25, 0.05, 0.5, 0.25},
                },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
        }
    },
    walkable = false,

    mesecons = { conductor = {
				state = "on",
				offstate = "monorail:switch_off",
				} }
})

minetest.register_node("monorail:switch_off", {
	description = "Rail switch",
    paramtype2 = "facedir",
    tiles = {"monorail_switch_off_top.png","monorail_switch_off_top.png","monorail_switch_off.png"},
    drop = "monorail:switch_off",
    groups = {bendy=2, snappy=1, dig_immediate=2},
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local name=player:get_player_name()
		if player==nil then return false end
		if minetest.check_player_privs(name, {settime=true}) then
			return true
		end
		if meta==nil then return false end
		return meta:get_string("owner")~=""
		
	end,
	after_place_node = function(pos, placer, itemstack)
		if placer:get_player_name()~=nil then
			if not minetest.check_player_privs(placer:get_player_name(), {settime=true}) then
				minetest.get_meta(pos):set_string("owner", placer:get_player_name())
			end
		end
	end,
    on_punch = function(pos, node, puncher)
        node.name = "monorail:switch_on"
        minetest.env:set_node(pos, node)
    end,

    drawtype = "nodebox",
    paramtype = "light",
    node_box = {
        type = "fixed",
        fixed = {
                    -- shaft
                    {-0.05, -0.5, -0.05, 0.05, 0.0, 0.05},
                    -- head
                    {-0.25, 0.0, -0.05, 0.25, 0.5, 0.05},
                    {-0.05, 0.0, -0.25, 0.05, 0.5, 0.25},
                },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.25, -0.5, -0.25, 0.25, 0.5, 0.25},
        }
    },
    walkable = false,

    mesecons = { conductor = {
				state = "off",
				onstate = "monorail:switch_on",
				} }
})

minetest.register_node("monorail:accelerator_off", {
	description = "Accelerator",
	tiles ={"monorail_accelerator_off.png"},
	is_ground_content = true,
	groups = {cracky=3, mesecon=2},
	drop = 'monorail:accelerator_off 1',
	after_place_node = function(pos, placer, itemstack)
		if placer:get_player_name()~=nil then
			if not minetest.check_player_privs(placer:get_player_name(), {settime=true}) then
				minetest.get_meta(pos):set_string("owner", placer:get_player_name())
			end
		end
	end,

	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local name=player:get_player_name()
		if player==nil then return false end
		if minetest.check_player_privs(name, {settime=true}) then
			return true
		end
		if meta==nil then return false end
		return meta:get_string("owner")~=""
		
	end,
	mesecons = { conductor = {
				state = "off",
				onstate = "monorail:accelerator_on",
				} }
})

minetest.register_node("monorail:accelerator_on", {
	description = "Accelerator",
	tiles ={"monorail_accelerator_on.png"},
	is_ground_content = true,
	groups = {cracky=3, mesecon=2,not_in_craft_guide=1},
	drop = 'monorail:accelerator_off 1',

	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local name=player:get_player_name()
		if player==nil then return false end
		if minetest.check_player_privs(name, {settime=true}) then
			return true
		end
		if meta==nil then return false end
		return meta:get_string("owner")~=""
		
	end,
	mesecons = { conductor = {
				state = "on",
				offstate = "monorail:accelerator_off",
				} }

})

minetest.register_node("monorail:cart_detector_on", {
	description = "Cart Detector",
	tiles ={"monorail_cart_detector.png"},
	is_ground_content = true,
	groups = {cracky=3, mesecon=2,not_in_craft_guide=1},
	drop = 'monorail:cart_detector_off 1',
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local name=player:get_player_name()
		if player==nil then return false end
		if minetest.check_player_privs(placer:get_player_name(), {settime=true}) then
			return true
		end
		if meta==nil then return false end
		return meta:get_string("owner")~=""
		
	end,
	mesecons = { receptor = {
					state = "on"
					} }

})

minetest.register_abm({
	nodenames = { "monorail:cart_detector_on"},
	interval = 2,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local all_objects = minetest.get_objects_inside_radius(pos, 1.1)
		for _,obj in ipairs(all_objects) do
			if obj:get_luaentity() ~= nil then
				if obj:get_luaentity().name == "monorail:cart" or obj:get_luaentity().name == "monorail:transport_cart" then
					return
				end
			end
		end
		minetest.env:add_node(pos,{name="monorail:cart_detector_off"})
		mesecon.receptor_off(pos, mesecon.rules.default)
	end
	})

minetest.register_node("monorail:cart_detector_off", {
	description = "Cart Detector",
	tiles ={"monorail_cart_detector.png"},
	is_ground_content = true,
	groups = {cracky=3, mesecon=2},
	drop = 'monorail:cart_detector_off 1',
	after_place_node = function(pos, placer, itemstack)
		if placer:get_player_name()~=nil then
			if not minetest.check_player_privs(placer:get_player_name(), {settime=true}) then
				minetest.get_meta(pos):set_string("owner", placer:get_player_name())
			end
		end
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local name=player:get_player_name()
		if player==nil then return false end
		if minetest.check_player_privs(name, {settime=true}) then
			return true
		end
		if meta==nil then return false end
		return meta:get_string("owner")~=""
		
	end,
	mesecons = { receptor = {
					state = "off"
					} }
})

function monorail_get_current_time()
	return os.time(os.date('*t'))
	--return minetest.get_time()
end
-------------------------------------------------------------------------------
-- name: monorail_global_data_store(value)
--
--! @brief save data and return unique identifier
--
--! @param value to save
--
--! @return unique identifier
-------------------------------------------------------------------------------
monorail_global_data_identifier = 0
monorail_global_data = {}
monorail_global_data.cleanup_index = 0
monorail_global_data.last_cleanup = monorail_get_current_time()
function monorail_global_data_store(value)

	local current_id = monorail_global_data_identifier

	monorail_global_data_identifier = monorail_global_data_identifier + 1

	monorail_global_data[current_id] = {
									value = value,
									added = monorail_get_current_time(),
									}
	return current_id
end


-------------------------------------------------------------------------------
-- name: monorail_global_data_store(value)
--
--! @brief pop data from global store
--
--! @param id to pop
--
--! @return stored value
-------------------------------------------------------------------------------
function monorail_global_data_get(id)

	local dataid = tonumber(id)

	if dataid == nil or
		monorail_global_data[dataid] == nil then
		return nil
	end

	local retval = monorail_global_data[dataid].value
	monorail_global_data[dataid] = nil
	return retval
end

-------------------------------------------------------------------------------
-- name: monorail_global_data_store(value)
--
--! @brief pop data from global store
--
--! @param id to pop
--
--! @return stored value
-------------------------------------------------------------------------------
function monorail_global_data_cleanup(id)

	if monorail_global_data.last_cleanup + 500 <
											monorail_get_current_time() then

		for i=1,50,1 do
			if monorail_global_data[monorail_global_data.cleanup_index] ~= nil then
				if monorail_global_data[monorail_global_data.cleanup_index].added <
						monorail_get_current_time() - 300 then

					monorail_global_data[monorail_global_data.cleanup_index] = nil
				end
				monorail_global_data.cleanup_index = monorail_global_data.cleanup_index +1

				if monorail_global_data.cleanup_index > #monorail_global_data then
					monorail_global_data.cleanup_index = 0
					break
				end
			end
		end

		monorail_global_data.last_cleanup = monorail_get_current_time()
	end
end

