dofile(minetest.get_modpath("kpgmobs").."/api.lua")

minetest.register_node("kpgmobs:uley", {
	description = "Uley",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles ={"uley.png"},
	inventory_image = "uley.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {fleshy=3,dig_immediate=3},
--	on_use = minetest.item_eat(4),
	sounds = default.node_sound_defaults(),
	after_place_node = function(pos, placer, itemstack)
		if placer:is_player() then
			minetest.set_node(pos, {name="kpgmobs:uley", param2=1})
			minetest.env:add_entity(pos, "kpgmobs:bee")
		end
	end,
	
})

minetest.register_craft({
	output = 'kpgmobs:uley',
	recipe = {
		{'kpgmobs:bee','kpgmobs:bee','kpgmobs:bee'},
	}
})

minetest.register_node("kpgmobs:manger", {
	description = "Manger",
	drawtype = "plantlike",
	visual_scale = 1.2,
	tiles ={"manger.png"},
	inventory_image = "manger.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {oddly_breakable_by_hand=2},
	sounds = default.node_sound_defaults(),
	on_rightclick = function(pos, node, clicker, itemstack)
		if not itemstack then return end
		local meta = minetest.env:get_meta(pos)
			if meta:get_string("item") ==nil or meta:get_string("item")=="" then
			if itemstack:get_name()=="default:apple" or itemstack:get_name()=="farming:wheat" or itemstack:get_name()=="farming:seed_wheat" then
			local s = itemstack:take_item()
			meta:set_string("item",s:to_string())
			pos.y = pos.y + 0.65
			itmp.nodename = node.name
			itmp.texture = ItemStack(meta:get_string("item")):get_name()
			local e = minetest.env:add_entity(pos,"homedecor:item")
			end
			end
		return itemstack
	end,
	on_punch = function(pos,node,puncher)
		local meta = minetest.env:get_meta(pos)
		local item = meta:get_string("item")
		if puncher~=nil and item~=nil and item~="" then
			local name=puncher:get_player_name()
			if not minetest.is_protected(pos,name) then
			local inv=puncher:get_inventory()
			if inv~=nil then
				if inv:room_for_item("main", ItemStack(item)) then
					inv:add_item("main", ItemStack(item))
					meta:set_string("item","")

	local objs = nil
		objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y+0.8,z=pos.z}, .5)
	if objs then
		for _, obj in ipairs(objs) do
			if obj and obj:get_luaentity() and obj:get_luaentity().name == "homedecor:item" then
				obj:remove()
			end
		end
	end

				end
			end
			end
		end		
	end,

})

minetest.register_craft({
	output = 'kpgmobs:manger',
	recipe = {
		{'group:stick','farming:wheat','group:stick'},
		{'','group:stick',''},
		{'group:stick','','group:stick'}
	}
})

--HORSE go go goooo :)
local horse = {
    
	
	physical = true,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	visual = "mesh",
	stepheight = 1.6,
	visual_size = {x=1,y=1},
	mesh = "mobs_horseh1.x",
	textures = {"mobs_horseh1.png"},
		
	driver = nil,
	v = 0,
	lastpos=nil,
	goodlastpos=nil,
}


local function is_ground(pos)
	local nn = minetest.get_node(pos).name
	return nn~="air" and nn~="default:water_flowing" and nn~="default:water_source" and nn~="default:lava_flowing" and nn~="default:lava_source"
end

local function get_sign(i)
	if i == 0 then
		return 0
	else
		return i/math.abs(i)
	end
end

local function get_velocity(v, yaw, y)
	local x = math.cos(yaw)*v
	local z = math.sin(yaw)*v
	return {x=x, y=y, z=z}
end

local function get_v(v)
	return math.sqrt(v.x^2+v.z^2)
end

function horse:on_rightclick(clicker)
	if not clicker or not clicker:is_player() then
		return
	end
	if self.driver and clicker == self.driver then
if self.goodlastpos~=nil then
				self.object:setpos(self.goodlastpos)
end

		self.driver = nil
		clicker:set_detach()
		default.player_attached[clicker:get_player_name()] = false
		default.player_set_animation(clicker, "stand" , 30)
		clicker:set_attach(self.object, "", {x=0,y=11,z=-3}, {x=0,y=0,z=0})
		minetest.after(0.2, function()
			default.player_set_animation(clicker, "stand" , 30)
		end)
		clicker:set_attach(self.object, "", {x=0,y=2,z=0}, {x=0,y=0,z=0})
		self.object:setyaw(clicker:get_look_yaw())
		self.driver = nil
		clicker:set_detach()
		default.player_attached[clicker:get_player_name()] = false
		default.player_set_animation(clicker, "stand" , 30)

	elseif not self.driver then
		self.driver = clicker
		clicker:set_attach(self.object, "", {x=0,y=5,z=0}, {x=0,y=0,z=0})
		self.object:setyaw(clicker:get_look_yaw())
	end
end


function horse:on_activate(staticdata, dtime_s)
	self.object:set_armor_groups({immortal=1})
	if staticdata then
		self.v = tonumber(staticdata)
	end
end

function horse:get_staticdata()
	return tostring(v)
end

function horse:on_punch(puncher, time_from_last_punch, tool_capabilities, direction)
	if self.driver and puncher == self.driver then
if self.goodlastpos~=nil then
				self.object:setpos(self.goodlastpos)
end

		self.driver = nil
		puncher:set_detach()
		default.player_attached[puncher:get_player_name()] = false
		default.player_set_animation(puncher, "stand" , 30)
end
	self.object:remove()
	if puncher and puncher:is_player() then
		puncher:get_inventory():add_item("main", "kpgmobs:horseh1")
	end
end


function horse:on_step(dtime)

	self.v = get_v(self.object:getvelocity())*get_sign(self.v)
	local p = self.object:getpos()
	local jump=0
	if self.driver then
		local ctrl = self.driver:get_player_control()
		if ctrl.up then
			self.v = self.v+2
		end
		if ctrl.down then
			self.v = self.v-0.1
		end
		if ctrl.left then
			self.object:setyaw(self.object:getyaw()+math.pi/95+dtime*math.pi/95)
		end
		if ctrl.right then
			self.object:setyaw(self.object:getyaw()-math.pi/95-dtime*math.pi/95)
		end
		if ctrl.jump then
		jump=1
		local p = self.object:getpos()

		p.y = p.y-0.5

			if (is_ground({x=p.x,y=p.y+1,z=p.z}) and is_ground({x=p.x,y=p.y+3,z=p.z})) or is_ground({x=p.x,y=p.y+2,z=p.z})  then
				local pos = self.object:getpos()
				local last=self.lastpos
				if last==nil then 
					last=pos
				end
				if math.abs(last.x-pos.x)>2 or math.abs(last.z-pos.z)>2 then
					local llast=self.goodlastpos
					if llast==nil then 
						llast=pos
					end
					if math.abs(llast.x-last.x)>2 or math.abs(llast.z-last.z)>2 then
						self.goodlastpos = last
					end
					self.lastpos = pos
				end
				pos.y = math.floor(pos.y)+4
				self.object:setpos(pos)
				self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), 0))
			end
		end
	end
	local s = get_sign(self.v)
	self.v = self.v - 0.02*s
	if self.v~=0 and s ~= get_sign(self.v) then
		self.object:setvelocity({x=0, y=0, z=0})
		self.v = 0
		if not is_ground(p) then
			if minetest.registered_nodes[minetest.get_node(p).name].walkable then
				self.v = 0
			end
			self.object:setacceleration({x=0, y=-10, z=0})
			if self.goodlastpos~=nil then
				self.object:setpos(self.goodlastpos)
			end
		end
		return
	end
	if math.abs(self.v) > 4.5+jump then
		self.v = (4.5+jump)*get_sign(self.v)
	end
	
	local p = self.object:getpos()
	p.y = p.y-0.5
	if not is_ground(p) then
		if minetest.registered_nodes[minetest.get_node(p).name].walkable then
			self.v = 0
		end
		self.object:setacceleration({x=0, y=-10, z=0})
		self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), self.object:getvelocity().y))
	else

		p.y = p.y+1

		if (is_ground(p) and is_ground({x=p.x,y=p.y+2,z=p.z})) or is_ground({x=p.x,y=p.y+1,z=p.z})  then
			local yaw=self.object:getyaw()
			if yaw~=nil then
				self.object:setvelocity(get_velocity(self.v, (yaw+180)%360, self.object:getvelocity().y))
			end
			self.object:setacceleration({x=0, y=-10, z=0})
			self.v = 0
			if self.goodlastpos~=nil then
				self.object:setpos(self.goodlastpos)
			end
			return
		elseif is_ground(p) then
			local pos = self.object:getpos()
			local last=self.lastpos
			if last==nil then 
				last=pos
			end
			if math.abs(last.x-pos.x)>2 or math.abs(last.z-pos.z)>2 then
				local llast=self.goodlastpos
				if llast==nil then 
					llast=pos
				end
				if math.abs(llast.x-last.x)>2 or math.abs(llast.z-last.z)>2 then
					self.goodlastpos = last
				end
				self.lastpos = pos
			end

			self.object:setpos({x=p.x, y=p.y+1, z=p.z})
			self.object:setacceleration({x=0, y=3, z=0})
			local y = self.object:getvelocity().y
			if y > 1.4 then
				y = 1.4
			end
			if y < 0 then
				self.object:setacceleration({x=0, y=10, z=0})
			end
			self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), y))

		else
			self.object:setacceleration({x=0, y=0, z=0})
			if math.abs(self.object:getvelocity().y) < 1 then
				local pos = self.object:getpos()
				pos.y = math.floor(pos.y)+0.5
				self.object:setpos(pos)
				self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), 0))
			else
				self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), self.object:getvelocity().y))
			end
		end
	end
end

--horse white

local horsepeg = {
    
	
	physical = true,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	visual = "mesh",
	stepheight = 1.1,
	visual_size = {x=1,y=1},
	mesh = "mobs_horseh1.x",
	textures = {"mobs_horsepegh1.png"},
		
	driver = nil,
	v = 0,
	lastpos=nil,
	goodlastpos=nil,
}


local function is_ground(pos)
	local nn = minetest.get_node(pos).name
	return nn~="air" and nn~="default:water_flowing" and nn~="default:water_source" and nn~="default:lava_flowing" and nn~="default:lava_source"
end

local function get_sign(i)
	if i == 0 then
		return 0
	else
		return i/math.abs(i)
	end
end

local function get_velocity(v, yaw, y)
	local x = math.cos(yaw)*v
	local z = math.sin(yaw)*v
	return {x=x, y=y, z=z}
end

local function get_v(v)
	return math.sqrt(v.x^2+v.z^2)
end

function horsepeg:on_rightclick(clicker)
	if not clicker or not clicker:is_player() then
		return
	end
	if self.driver and clicker == self.driver then
	if self.goodlastpos~=nil then
				self.object:setpos(self.goodlastpos)
end
	self.driver = nil
		clicker:set_detach()
		default.player_attached[clicker:get_player_name()] = false
		default.player_set_animation(clicker, "stand" , 30)
		clicker:set_attach(self.object, "", {x=0,y=11,z=-3}, {x=0,y=0,z=0})
		minetest.after(0.2, function()
			default.player_set_animation(clicker, "stand" , 30)
		end)
		clicker:set_attach(self.object, "", {x=0,y=2,z=0}, {x=0,y=0,z=0})
		self.object:setyaw(clicker:get_look_yaw())
		self.driver = nil
		clicker:set_detach()
		default.player_attached[clicker:get_player_name()] = false
		default.player_set_animation(clicker, "stand" , 30)

	elseif not self.driver then
		self.driver = clicker
		clicker:set_attach(self.object, "", {x=0,y=5,z=0}, {x=0,y=0,z=0})
		self.object:setyaw(clicker:get_look_yaw())
	end
end


function horsepeg:on_activate(staticdata, dtime_s)
	self.object:set_armor_groups({immortal=1})
	if staticdata then
		self.v = tonumber(staticdata)
	end
end

function horsepeg:get_staticdata()
	return tostring(v)
end

function horsepeg:on_punch(puncher, time_from_last_punch, tool_capabilities, direction)
	if self.driver and puncher == self.driver then
	if self.goodlastpos~=nil then
				self.object:setpos(self.goodlastpos)
end
	self.driver = nil
		puncher:set_detach()
		default.player_attached[puncher:get_player_name()] = false
		default.player_set_animation(puncher, "stand" , 30)
end
	self.object:remove()
	if puncher and puncher:is_player() then
		puncher:get_inventory():add_item("main", "kpgmobs:horsepegh1")
	end
end


function horsepeg:on_step(dtime)

	self.v = get_v(self.object:getvelocity())*get_sign(self.v)
	local p = self.object:getpos()
	local jump=0
	if self.driver then
		local ctrl = self.driver:get_player_control()
		if ctrl.up then
			self.v = self.v+2.8
		end
		if ctrl.down then
			self.v = self.v-0.1
		end
		if ctrl.left then
			self.object:setyaw(self.object:getyaw()+math.pi/110+dtime*math.pi/110)
		end
		if ctrl.right then
			self.object:setyaw(self.object:getyaw()-math.pi/110-dtime*math.pi/110)
		end
		if ctrl.jump then
			jump=2

			p.y = p.y-0.5

			if (is_ground({x=p.x,y=p.y+1,z=p.z}) and is_ground({x=p.x,y=p.y+3,z=p.z})) or is_ground({x=p.x,y=p.y+2,z=p.z})  then
				local pos = self.object:getpos()
				local last=self.lastpos
				if last==nil then 
					last=pos
				end
				if math.abs(last.x-pos.x)>2 or math.abs(last.z-pos.z)>2 then
					local llast=self.goodlastpos
					if llast==nil then 
						llast=pos
					end
					if math.abs(llast.x-last.x)>2 or math.abs(llast.z-last.z)>2 then
						self.goodlastpos = last
					end
					self.lastpos = pos
				end
				pos.y = math.floor(pos.y)+4
				self.object:setpos(pos)
				self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), 0))
			end
		end
	end
	local s = get_sign(self.v)
	self.v = self.v - 0.02*s
	if self.v~=0 and s ~= get_sign(self.v) then
		self.object:setvelocity({x=0, y=0, z=0})
		self.v = 0

		return
	end
	if math.abs(self.v) > 5+jump then
		self.v = (5+jump)*get_sign(self.v)
	end
	
	local p = self.object:getpos()
	p.y = p.y-0.5
	if  not is_ground(p) then
		if minetest.registered_nodes[minetest.get_node(p).name].walkable then
			self.v = 0
		end
		self.object:setacceleration({x=0, y=-10, z=0})
		self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), self.object:getvelocity().y))
		if self.goodlastpos~=nil then
			self.object:setpos(self.goodlastpos)
		end
	else
		p.y = p.y+1

		if (is_ground(p) and is_ground({x=p.x,y=p.y+2,z=p.z})) or is_ground({x=p.x,y=p.y+1,z=p.z})  then
			local yaw=self.object:getyaw()
			if yaw~=nil then
				self.object:setvelocity(get_velocity(self.v, (yaw+180)%360, self.object:getvelocity().y))
			end
			self.object:setacceleration({x=0, y=-10, z=0})
			self.v = 0
			if self.goodlastpos~=nil then
				self.object:setpos(self.goodlastpos)
			end
			if not is_ground(p) then
				if minetest.registered_nodes[minetest.get_node(p).name].walkable then
					self.v = 0
				end
				self.object:setacceleration({x=0, y=-10, z=0})
			end

			return
		elseif is_ground(p) then
			local pos = self.object:getpos()
			local last=self.lastpos
			if last==nil then 
				last=pos
			end
			if math.abs(last.x-pos.x)>2 or math.abs(last.z-pos.z)>2 then
				local llast=self.goodlastpos
				if llast==nil then 
					llast=pos
				end
				if math.abs(llast.x-last.x)>2 or math.abs(llast.z-last.z)>2 then
					self.goodlastpos = last
				end
				self.lastpos = pos
			end



			self.object:setpos({x=p.x, y=p.y+1, z=p.z})
			self.object:setacceleration({x=0, y=3, z=0})
			local y = self.object:getvelocity().y
			if y > 1.4 then
				y = 1.4
			end
			if y < 0 then
				self.object:setacceleration({x=0, y=10, z=0})
			end
			self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), y))
		else
			self.object:setacceleration({x=0, y=0, z=0})
			if math.abs(self.object:getvelocity().y) < 1 then
				local pos = self.object:getpos()
				pos.y = math.floor(pos.y)+0.5
				self.object:setpos(pos)
				self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), 0))
			else
				self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), self.object:getvelocity().y))
			end
		end
	end
end

--horse arabik
  local horseara = {
    
	
	physical = true,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	visual = "mesh",
	stepheight = 2.1,
	visual_size = {x=1,y=1},
	mesh = "mobs_horseh1.x",
	textures = {"mobs_horsearah1.png"},
		
	driver = nil,
	v = 0,
	lastpos=nil,
	goodlastpos=nil,
}


local function is_ground(pos)
	local nn = minetest.get_node(pos).name
	return nn~="air" and nn~="default:water_flowing" and nn~="default:water_source" and nn~="default:lava_flowing" and nn~="default:lava_source"
end

local function get_sign(i)
	if i == 0 then
		return 0
	else
		return i/math.abs(i)
	end
end

local function get_velocity(v, yaw, y)
	local x = math.cos(yaw)*v
	local z = math.sin(yaw)*v
	return {x=x, y=y, z=z}
end

local function get_v(v)
	return math.sqrt(v.x^2+v.z^2)
end

function horseara:on_rightclick(clicker)
	if not clicker or not clicker:is_player() then
		return
	end
	if self.driver and clicker == self.driver then
	if self.goodlastpos~=nil then
				self.object:setpos(self.goodlastpos)
end
	self.driver = nil
		clicker:set_detach()
		default.player_attached[clicker:get_player_name()] = false
		default.player_set_animation(clicker, "stand" , 30)
		clicker:set_attach(self.object, "", {x=0,y=11,z=-3}, {x=0,y=0,z=0})
		minetest.after(0.2, function()
			default.player_set_animation(clicker, "stand" , 30)
		end)
		clicker:set_attach(self.object, "", {x=0,y=2,z=0}, {x=0,y=0,z=0})
		self.object:setyaw(clicker:get_look_yaw())
		self.driver = nil
		clicker:set_detach()
		default.player_attached[clicker:get_player_name()] = false
		default.player_set_animation(clicker, "stand" , 30)

	elseif not self.driver then
		self.driver = clicker
		clicker:set_attach(self.object, "", {x=0,y=5,z=0}, {x=0,y=0,z=0})
		self.object:setyaw(clicker:get_look_yaw())
	end
end


function horseara:on_activate(staticdata, dtime_s)
	self.object:set_armor_groups({immortal=1})
	if staticdata then
		self.v = tonumber(staticdata)
	end
end

function horseara:get_staticdata()
	return tostring(v)
end

function horseara:on_punch(puncher, time_from_last_punch, tool_capabilities, direction)
	if self.driver and puncher == self.driver then
	if self.goodlastpos~=nil then
				self.object:setpos(self.goodlastpos)
end
	self.driver = nil
		puncher:set_detach()
		default.player_attached[puncher:get_player_name()] = false
		default.player_set_animation(puncher, "stand" , 30)
end	self.object:remove()
	if puncher and puncher:is_player() then
		puncher:get_inventory():add_item("main", "kpgmobs:horsearah1")
	end
end


function horseara:on_step(dtime)

	self.v = get_v(self.object:getvelocity())*get_sign(self.v)
	local jump=0
	local p = self.object:getpos()
	if self.driver then
		local ctrl = self.driver:get_player_control()
		if ctrl.up then
			self.v = self.v+3
		end
		if ctrl.down then
			self.v = self.v-0.1
		end
		if ctrl.left then
			self.object:setyaw(self.object:getyaw()+math.pi/125+dtime*math.pi/125)
		end
		if ctrl.right then
			self.object:setyaw(self.object:getyaw()-math.pi/125-dtime*math.pi/125)
		end
		if ctrl.jump then
			jump=1
			local p = self.object:getpos()
			p.y = p.y-0.5

			if (is_ground({x=p.x,y=p.y+1,z=p.z}) and is_ground({x=p.x,y=p.y+3,z=p.z})) or is_ground({x=p.x,y=p.y+2,z=p.z})  then
				local pos = self.object:getpos()
				local last=self.lastpos
				if last==nil then 
					last=pos
				end
				if math.abs(last.x-pos.x)>2 or math.abs(last.z-pos.z)>2 then
					local llast=self.goodlastpos
					if llast==nil then 
						llast=pos
					end
					if math.abs(llast.x-last.x)>2 or math.abs(llast.z-last.z)>2 then
						self.goodlastpos = last
					end
					self.lastpos = pos
				end
				pos.y = math.floor(pos.y)+4
				self.object:setpos(pos)
				self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), 0))
			end
		end
	end
	local s = get_sign(self.v)
	self.v = self.v - 0.02*s
	if self.v~=0 and s ~= get_sign(self.v) then
		self.object:setvelocity({x=0, y=0, z=0})
		self.v = 0
		return
	end
	if math.abs(self.v) > 5.5+jump then
		self.v = (5.5+jump)*get_sign(self.v)
	end
	
	local p = self.object:getpos()
	p.y = p.y-0.5
	if not is_ground(p) then
		if minetest.registered_nodes[minetest.get_node(p).name].walkable then
			self.v = 0
		end
		if self.goodlastpos~=nil then
			self.object:setpos(self.goodlastpos)
		end
		self.object:setacceleration({x=0, y=-10, z=0})
		self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), self.object:getvelocity().y))
	else
		p.y = p.y+1

		if (is_ground(p) and is_ground({x=p.x,y=p.y+2,z=p.z})) or is_ground({x=p.x,y=p.y+1,z=p.z})  then
			local yaw=self.object:getyaw()
			if yaw~=nil then
				self.object:setvelocity(get_velocity(self.v, (yaw+180)%360, self.object:getvelocity().y))
			end
			self.object:setacceleration({x=0, y=-10, z=0})
			self.v = 0
			if self.goodlastpos~=nil then
				self.object:setpos(self.goodlastpos)
			end
			if not is_ground(p) then
				if minetest.registered_nodes[minetest.get_node(p).name].walkable then
					self.v = 0
				end
				self.object:setacceleration({x=0, y=-10, z=0})
			end
			return
		elseif is_ground(p) then
			local pos = self.object:getpos()
			local last=self.lastpos
			if last==nil then 
				last=pos
			end
			if math.abs(last.x-pos.x)>2 or math.abs(last.z-pos.z)>2 then
				local llast=self.goodlastpos
				if llast==nil then 
					llast=pos
				end
				if math.abs(llast.x-last.x)>2 or math.abs(llast.z-last.z)>2 then
					self.goodlastpos = last
				end
				self.lastpos = pos
			end


			self.object:setpos({x=p.x, y=p.y+1, z=p.z})
			self.object:setacceleration({x=0, y=3, z=0})
			local y = self.object:getvelocity().y
			if y > 1.4 then
				y = 1.4
			end
			if y < 0 then
				self.object:setacceleration({x=0, y=10, z=0})
			end
			self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), y))
		else
			self.object:setacceleration({x=0, y=0, z=0})
			if math.abs(self.object:getvelocity().y) < 1 then
				local pos = self.object:getpos()
				pos.y = math.floor(pos.y)+0.5
				self.object:setpos(pos)
				self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), 0))
			else
				self.object:setvelocity(get_velocity(self.v, self.object:getyaw(), self.object:getvelocity().y))
			end
		end
	end
end

--END HORSE

kpgmobs:register_mob("kpgmobs:sheep", {
	type = "animal",
	hp_max = 5,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	textures = {"mobs_sheep.png"},
	visual = "mesh",
	mesh = "mobs_sheep.x",
	makes_footstep_sound = true,
	stepheight = 1.1,
	walk_velocity = 1,
	armor = 200,
	drops = {
		{name = "kpgmobs:meat_raw",
		chance = 1,
		min = 1,
		max = 2,},
	},
	drawtype = "front",
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	sounds = {
		random = "mobs_sheep",
	},
	animation = {
		speed_normal = 15,
		stand_start = 0,
		stand_end = 80,
		walk_start = 81,
		walk_end = 100,
	},
	follow = "farming:wheat",
	view_range = 5,
	
	on_rightclick = function(self, clicker)
		local item = clicker:get_wielded_item()
		if item:get_name() == "farming:wheat" then
			if not self.tamed then
				if not minetest.setting_getbool("creative_mode") then
					item:take_item()
					clicker:set_wielded_item(item)
				end
				self.tamed = true
			self.object:set_properties({
				stepheight=0.9			
			})
			elseif self.naked then
				if not minetest.setting_getbool("creative_mode") then
					item:take_item()
					clicker:set_wielded_item(item)
				end
				self.food = (self.food or 0) + 1
				if self.food >= 8 then
					self.food = 0
					self.naked = false
					self.object:set_properties({
						textures = {"mobs_sheep.png"},
						mesh = "mobs_sheep.x",
					})
				end
			end
			return
		end
		if clicker:get_inventory() and not self.naked then
			self.naked = true
			if minetest.registered_items["wool:white"] then
				clicker:get_inventory():add_item("main", ItemStack("wool:white "..math.random(1,3)))
			end
			self.object:set_properties({
				textures = {"mobs_sheep_shaved.png"},
				mesh = "mobs_sheep_shaved.x",
			})
		end
	end,
})
kpgmobs:register_spawn("kpgmobs:sheep", {"default:dirt_with_grass"}, 20, 8, 9000, 1, 31000)


minetest.register_craftitem("kpgmobs:meat_raw", {
	description = "Raw Meat",
	inventory_image = "mobs_meat_raw.png",
})

minetest.register_craftitem("kpgmobs:meat", {
	description = "Meat",
	inventory_image = "mobs_meat.png",
	on_use = minetest.item_eat(5.12),
})

minetest.register_craft({
	type = "cooking",
	output = "kpgmobs:meat",
	recipe = "kpgmobs:meat_raw",
	cooktime = 5,
})

minetest.register_craft({
	type = "cooking",
	output = "kpgmobs:rat_cooked",
	recipe = "kpgmobs:rat",
	cooktime = 4,
})

kpgmobs:register_mob("kpgmobs:rat", {
	type = "animal",
	hp_max = 1,
	collisionbox = {-0.2, -0.01, -0.2, 0.2, 0.2, 0.2},
	visual = "mesh",
	mesh = "mobs_rat.x",
	textures = {"mobs_rat.png"},
	makes_footstep_sound = false,
	walk_velocity = 1,
	armor = 200,
	drops = {},
	drawtype = "front",
	water_damage = 0,
	lava_damage = 1,
	light_damage = 0,
	
	on_rightclick = function(self, clicker)
		if clicker:is_player() and clicker:get_inventory() then
			clicker:get_inventory():add_item("main", "kpgmobs:rat")
			self.object:remove()
		end
	end,
})
kpgmobs:register_spawn("kpgmobs:rat", {"default:dirt_with_grass", "default:stone"}, 20, -1, 7000, 1, 31000)

minetest.register_craftitem("kpgmobs:rat", {
	description = "Rat",
	inventory_image = "mobs_rat_inventory.png",
	
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.above then
			minetest.env:add_entity(pointed_thing.above, "kpgmobs:rat")
			itemstack:take_item()
		end
		return itemstack
	end,
})
	
minetest.register_craftitem("kpgmobs:rat_cooked", {
	description = "Cooked Rat",
	inventory_image = "mobs_cooked_rat.png",
	groups = {not_in_craft_guide=1},
	on_use = minetest.item_eat(1.07),
})


kpgmobs:register_mob("kpgmobs:bee", {
	type = "animal",
	hp_max = 1,
	collisionbox = {-0.2, -0.01, -0.2, 0.2, 0.2, 0.2},
	visual = "mesh",
	mesh = "mobs_bee.x",
	textures = {"mobs_bee.png"},
	makes_footstep_sound = false,
	walk_velocity = 1,
	stepheight=3.9,			
	armor = 200,
	drops = {
		{name = "kpgmobs:honey",
		chance = 1,
		min = 1,
		max = 1,},
	},
	drawtype = "front",
	water_damage = 0,
	lava_damage = 1,
	light_damage = 0,
	
	animation = {
		speed_normal = 15,
		stand_start = 0,
		stand_end = 30,
		walk_start = 35,
		walk_end = 65,
	},
	
	on_rightclick = function(self, clicker)
		--bees can sting when catched with your bare hands
		local item = clicker:get_wielded_item()
		if item==nil or item:get_name()=="" and math.random(1,3)>2 then
		minetest.item_eat(-1) --should do damage
		else
		if clicker:is_player() and clicker:get_inventory() then
			clicker:get_inventory():add_item("main", "kpgmobs:bee")
			self.object:remove()
		end
		end
	end,
})
kpgmobs:register_spawn("kpgmobs:bee", {"default:dirt_with_grass"}, 20, -1, 7000, 1, 31000)

minetest.register_craftitem("kpgmobs:bee", {
	description = "Bee",
	inventory_image = "mobs_bee_inventar.png",
	
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.above then
			minetest.env:add_entity(pointed_thing.above, "kpgmobs:bee")
			itemstack:take_item()
		end
		return itemstack
	end,
})
	
minetest.register_craftitem("kpgmobs:honey", {
	description = "Honey",
	inventory_image = "mobs_med_inventar.png",
	groups = {food_sugar=1},

	on_use = minetest.item_eat(1),
})

minetest.register_craftitem("kpgmobs:leather", {
	description = "Leather",
	inventory_image = "leather.png",
})

minetest.register_tool("kpgmobs:leather_boots", {
	description = "Leather Boots",
	inventory_image = "leather_boots.png",

})

players = {}
local checktime = 0
minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	players[name] = {
		fast=10,
		boots = nil,
		floor= 0,
		water=false,
		diving=0,
		checkx=0,
		checkz=0,
	}
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	players[name] = nil
end)

minetest.register_globalstep(function(dtime)
	local time = minetest.get_gametime()
	if time-checktime>1.3 then
		checktime=time
		for name,_ in pairs(players) do
			local player = minetest.get_player_by_name(name)
			if player ~= nil then
				local pos = player:getpos()
				local checkx=players[name]["checkx"]
				local checkz=players[name]["checkz"]
				if checkx~=pos.x or checkz~=pos.z or players[name]["diving"]>0 then
					players[name]["checkx"]=pos.x
					players[name]["checkz"]=pos.z
					local itemstack=nil
					local fast=players[name]["fast"]
					if fast==false then
						fast=10
					end
					local boots=players[name]["boots"]
					local floor=players[name]["floor"]
					local water=players[name]["water"]
						if player:get_breath()~=11 and player:get_breath()~=nil or default.player_attached[name] == true then
						if not water then
							players[name]["water"]=true
							water=true
						end
					else
						if water then
							players[name]["water"]=false
							water=false
						end
					end
					if not water then
						local node = minetest.get_node({x=pos.x,y=pos.y,z=pos.z})
						local node1 = minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z})
						if minetest.get_item_group(node1.name, "fast")>0 or minetest.get_item_group(node.name, "fast")>0 then
							floor=1
						elseif floor==1 then
							floor=2
						else
							floor=0
						end
						players[name]["floor"]=floor
						local inv=player:get_inventory()
						if boots~=nil then
							itemstack=inv:get_stack("main",boots)
							if string.sub(itemstack:get_name(), 0, 21) ~= "kpgmobs:leather_boots" then
								players[name]["boots"]=nil
								boots=nil
							end
						end
						if boots==nil then
						local ffound=0
						if inv:get_list("armor")~=nil then
							for i,stack in ipairs(inv:get_list("armor")) do
								if string.sub(stack:get_name(), 0, 21) == "kpgmobs:leather_boots" then
									players[name]["boots"]=i+100
									boots=i+100
									itemstack=stack
								end
							end
						end
						if found==0 then
						if inv:get_list("main")~=nil then
							for i,stack in ipairs(inv:get_list("main")) do
								if string.sub(stack:get_name(), 0, 21) == "kpgmobs:leather_boots" then
									players[name]["boots"]=i
									boots=i
									itemstack=stack
								end
							end
						end
						end
						end
					elseif default.player_attached[name] ~= true then
						local inv=player:get_inventory()
						local ffound=0
						for i,stack in ipairs(inv:get_list("armor")) do
							if string.sub(stack:get_name(), 0, 19) == "technic:diving_gear" then
								local itemstack=stack
								local wear=itemstack:get_wear()
								if wear+56 > 65535 then
									player:get_inventory():set_stack("armor",i,ItemStack("technic:diving_gear_empty"))
								else
									players[name]["diving"]=i
									player:set_breath(10);
									itemstack:set_wear (wear+70) --should allow ~20 minutes diving
									player:get_inventory():set_stack("armor",i,itemstack)
								end
								ffound=1
								break
							end
						end
						if ffound==0 then
						for i,stack in ipairs(inv:get_list("craft")) do
							if string.sub(stack:get_name(), 0, 19) == "technic:diving_gear" then
								local itemstack=stack
								local wear=itemstack:get_wear()
								if wear+56 > 65535 then
									player:get_inventory():set_stack("craft",i,ItemStack("technic:diving_gear_empty"))
								else
									players[name]["diving"]=i
									player:set_breath(10);
									itemstack:set_wear (wear+70) --should allow ~20 minutes diving
									player:get_inventory():set_stack("craft",i,itemstack)
								end
								ffound=1
								break
							end
						end
						if ffound==0 then
						for i,stack in ipairs(inv:get_list("main")) do
							if string.sub(stack:get_name(), 0, 19) == "technic:diving_gear" then
								local itemstack=stack
								local wear=itemstack:get_wear()
								if wear+56 > 65535 then
									player:get_inventory():set_stack("main",i,ItemStack("technic:diving_gear_empty"))
								else
									players[name]["diving"]=i+9
									player:set_breath(10);
									itemstack:set_wear (wear+70)
									player:get_inventory():set_stack("main",i,itemstack)
								end
								ffound=1
								break
							end
							if i>=8 then break end
						end
						if ffound==0 then
							players[name]["diving"]=0
						end
						end
						end
					end
					if ((boots==nil or water) and fast>14) then
						if floor==0 then
						players[name]["fast"]=10
						player:set_physics_override({speed=1.0})
						else
						players[name]["fast"]=14
						player:set_physics_override({speed=1.4})
						end
					elseif ((floor==0 or water) and fast==14) then
						players[name]["fast"]=10
						player:set_physics_override({speed=1.0})
					elseif ((floor>0 and not water) and fast==10) then
						players[name]["fast"]=14
						player:set_physics_override({speed=1.4})
					elseif ((floor>0 and boots and not water) and fast<18) then --additional advantage:no wear for boots
						players[name]["fast"]=18
						player:set_physics_override({speed=1.8})
					elseif (boots~=nil and not water) then
						if fast<15 then
							players[name]["fast"]=15
							player:set_physics_override({speed=1.5})
						end
						local node2 = minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z})
						local badground=1
						if node2.name=="default:dirt_with_grass" then
							badground=3
						elseif node2.name=="default:dirt" then --dont run around in dirt with your good shoes :-)
							badground=10
						end
						local wear=itemstack:get_wear()
						if wear+65535/(4000/badground) > 65535 then
if boots <=100 then
							player:get_inventory():set_stack("main",boots,ItemStack(nil))
else
							player:get_inventory():set_stack("armor",boots-100,ItemStack(nil))

end
						else
							itemstack:set_wear (wear+65535/(4000/badground))
if boots <=100 then
							player:get_inventory():set_stack("main",boots,itemstack)
else
							player:get_inventory():set_stack("armor",boots-100,itemstack)

end
						end
					end
				end
			end
		end
	end
end)


minetest.register_craft({
	output = "kpgmobs:leather_boots",
	recipe = {
		{"","",""},
		{"kpgmobs:leather","","kpgmobs:leather"},
		{"kpgmobs:leather","","kpgmobs:leather"},
	}
})


minetest.register_alias("kpgmobs:med_cooked","kpgmobs:honey")

minetest.register_craft({
	type = "cooking",
	output = "kpgmobs:honey",
	recipe = "kpgmobs:bee",
	cooktime = 5,
})

kpgmobs:register_mob("kpgmobs:deer", {
	type = "animal",
	hp_max = 5,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	textures = {"mobs_deer.png"},
	visual = "mesh",
	mesh = "mobs_deer2.x",
	stepheight=1.1,		
	makes_footstep_sound = true,
	walk_velocity = 1,
	armor = 200,
	drops = {
		{name = "kpgmobs:meat_raw",
		chance = 1,
		min = 2,
		max = 2,},
		{name = "kpgmobs:leather",
		chance = 10007,
		min = 1,
		max = 1,},
		{name = "kpgmobs:leather",
		chance = 32,
		min = 1,
		max = 1,},
		{name = "kpgmobs:antlers",
		chance = 5,
		min = 1,
		max = 1,},

	},
	drawtype = "front",
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	on_rightclick = function(self, clicker)
		local item = clicker:get_wielded_item()
		if item:get_name() == "moretrees:pine_nuts" then
			if not self.tamed then
				if not minetest.setting_getbool("creative_mode") then
					item:take_item()
					clicker:set_wielded_item(item)
				end
				if math.random(1,4)<2 then 
				self.tamed = true
				end
			end
		end
	end,

	animation = {
		speed_normal = 15,
		stand_start = 25,
		stand_end = 75,
		walk_start = 75,
		walk_end = 100,
	},
	follow = "moretrees:pine_nuts",
	view_range = 5,
	
	
})
kpgmobs:register_spawn("kpgmobs:deer", {"default:dirt_with_grass"}, 20, 8, 9000, 1, 31000)

kpgmobs:register_mob("kpgmobs:horse", {
	type = "animal",
	hp_max = 5,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	textures = {"mobs_horse.png"},
	visual = "mesh",
	mesh = "mobs_horse.x",
	makes_footstep_sound = true,
	walk_velocity = 1,
	armor = 200,
	drops = {
		{name = "kpgmobs:meat_raw",
		chance = 1,
		min = 2,
		max = 3,},
		{name = "kpgmobs:leather",
		chance = 10011,
		min = 1,
		max = 1,},
		{name = "kpgmobs:leather",
		chance = 25,
		min = 1,
		max = 1,},

	},
	drawtype = "front",
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	animation = {
		speed_normal = 15,
		stand_start = 25,
		stand_end = 75,
		walk_start = 75,
		walk_end = 100,
	},
	follow = "farming:wheat",
	view_range = 5,
	
	on_rightclick = function(self, clicker)
		if clicker:is_player() and clicker:get_inventory() then
			clicker:get_inventory():add_item("main", "kpgmobs:horseh1")
			self.object:remove()
		end
	end,
	
})
kpgmobs:register_spawn("kpgmobs:horse", {"default:dirt_with_grass"}, 20, 8, 9000, 1, 31000)

minetest.register_craftitem("kpgmobs:horseh1", {
	description = "Horse",
	inventory_image = "mobs_horse_inventar.png",
	
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.above then
			minetest.env:add_entity(pointed_thing.above, "kpgmobs:horseh1")
			itemstack:take_item()
		end
		return itemstack
	end,
})

minetest.register_node("kpgmobs:antlers",{
	description = "Antlers",
	drawtype = "nodebox",
	node_box = { type = "fixed", fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5} },
	selection_box = { type = "fixed", fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5} },
	tiles = {"kpgmobs_blank.png"},
	inventory_image = "antlers.png",
	wield_image = "antlers.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = { choppy=2,dig_immediate=2 },
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	after_place_node = function(pos, placer, itemstack)
		local node=minetest.get_node(pos)
		if node.param2==1 then
			pos={x=pos.x+0.3,y=pos.y,z=pos.z}
		elseif node.param2==3 then
			pos={x=pos.x-0.3,y=pos.y,z=pos.z}
		elseif node.param2==0 then
			pos={x=pos.x,y=pos.y,z=pos.z+0.3}
		elseif node.param2==2 then
			pos={x=pos.x,y=pos.y,z=pos.z-0.3}
		end
		local e = minetest.env:add_entity(pos,"kpgmobs:antlers_item")
		local yaw = math.pi*2 - node.param2 * math.pi/2
		e:setyaw(yaw)
	end,
	on_punch = function(pos,node,puncher)
		if minetest.is_protected(pos,puncher:get_player_name()) then
			return
		end
		local meta = minetest.env:get_meta(pos)
		local objs = nil
		objs = minetest.env:get_objects_inside_radius(pos, .5)
		if objs then
			for _, obj in ipairs(objs) do
				if obj and obj:get_luaentity() and obj:get_luaentity().name == "kpgmobs:antlers_item" then
					obj:remove()
				end
			end
		end
		minetest.remove_node(pos)			
		minetest.env:add_item(pos, "kpgmobs:antlers")
	end,
})

minetest.register_entity("kpgmobs:antlers_item",{
	hp_max = 1,
	visual="wielditem",
	visual_size={x=.75,y=.75},
	collisionbox = {0,0,0,0,0,0},
	physical=false,
	textures={"kpgmobs:antlers"},
})

--minetest.register_abm({
--	nodenames = { "kpgmobs:antlers" },
--	interval = 600,
--	chance = 1,
--	action = function(pos, node, active_object_count, active_object_count_wider)
--		if #minetest.get_objects_inside_radius(pos, 0.5) > 0 then return end
--		local e = minetest.env:add_entity(pos,"kpgmobs:antlers_item")
--		local yaw = math.pi*2 - node.param2 * math.pi/2
--		e:setyaw(yaw)
--	end
--})

minetest.register_entity("kpgmobs:horseh1", horse)

minetest.register_craftitem("kpgmobs:horsepegh1", {
	description = "HorseWhite",
	inventory_image = "mobs_horse_inventar.png",
	
groups={not_in_craft_guide=1},
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.above then
			minetest.env:add_entity(pointed_thing.above, "kpgmobs:horsepegh1")
			itemstack:take_item()
		end
		return itemstack
	end,
})
minetest.register_entity("kpgmobs:horsepegh1", horsepeg)

minetest.register_craftitem("kpgmobs:horsearah1", {
	description = "HorseBlack",
	inventory_image = "mobs_horse_inventar.png",
	
groups={not_in_craft_guide=1},
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.above then
			minetest.env:add_entity(pointed_thing.above, "kpgmobs:horsearah1")
			itemstack:take_item()
		end
		return itemstack
	end,
})
minetest.register_entity("kpgmobs:horsearah1", horseara)

kpgmobs:register_mob("kpgmobs:wolf", {
	type = "monster",
	hp_max = 5,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	textures = {"mobs_wolf.png"},
	visual = "mesh",
	mesh = "mobs_wolf.x",
	makes_footstep_sound = true,
	view_range = 7,
	walk_velocity = 2,
	run_velocity = 3,
	stepheight=1.1,
	damage = 2,
	armor = 200,
	attack_type = "dogfight",
	drops = {
		{name = "kpgmobs:meat_raw",
		chance = 1,
		min = 1,
		max = 2,},
	},
	drawtype = "front",
	water_damage = 1,
	lava_damage = 5,
	light_damage = 2,
	on_rightclick = function(self, clicker)
		local item = clicker:get_wielded_item()
		if item:get_name() == "kpgmobs:meat_raw" then
			if not self.tamed then
				if not minetest.setting_getbool("creative_mode") then
					item:take_item()
					clicker:set_wielded_item(item)
				end
				if math.random(1,33)<2 then 
				self.tamed = true
				end
			end
		end
	end,

	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 10,
		stand_end = 20,
		walk_start = 75,
		walk_end = 100,
		run_start = 100,
		run_end = 130,
		punch_start = 135,
		punch_end = 155,
	},
})
kpgmobs:register_spawn("kpgmobs:wolf", {"default:dirt_with_grass","default:dirt","default:desert_sand"}, 10, -1, 11000, 3, 31000)

kpgmobs:register_mob("kpgmobs:pumba", {
	type = "animal",
	hp_max = 5,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	textures = {"mobs_pumba.png"},
	visual = "mesh",
	mesh = "mobs_pumba.x",
	makes_footstep_sound = true,
	stepheight=1.1,
	walk_velocity = 2,
	armor = 200,
	drops = {
		{name = "kpgmobs:meat_raw",
		chance = 1,
		min = 2,
		max = 3,},
	},
	drawtype = "front",
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	animation = {
		speed_normal = 15,
		stand_start = 25,
		stand_end = 55,
		walk_start = 70,
		walk_end = 100,
	},
	follow = "farming:wheat",
	view_range = 5,

})
kpgmobs:register_spawn("kpgmobs:pumba", {"default:desert_sand"}, 20, 8, 9000, 1, 31000)

kpgmobs:register_mob("kpgmobs:horse3", {
	type = "animal",
	hp_max = 5,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	textures = {"mobs_horseara.png"},
	visual = "mesh",
	mesh = "mobs_horse.x",
	makes_footstep_sound = true,
	walk_velocity = 1,
	armor = 200,
	drops = {
		{name = "kpgmobs:meat_raw",
		chance = 1,
		min = 2,
		max = 3,},
		{name = "kpgmobs:leather",
		chance = 10010,
		min = 1,
		max = 1,},
		{name = "kpgmobs:leather",
		chance = 25,
		min = 1,
		max = 1,},

	},
	drawtype = "front",
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	animation = {
		speed_normal = 15,
		stand_start = 25,
		stand_end = 75,
		walk_start = 75,
		walk_end = 100,
	},
	follow = "farming:wheat",
	view_range = 5,
	
	on_rightclick = function(self, clicker)
		if clicker:is_player() and clicker:get_inventory() then
			clicker:get_inventory():add_item("main", "kpgmobs:horsearah1")
			self.object:remove()
		end
	end,
})
kpgmobs:register_spawn("kpgmobs:horse3", {"default:desert_sand"}, 20, 8, 9000, 1, 31000)

kpgmobs:register_mob("kpgmobs:horse2", {
	type = "animal",
	hp_max = 5,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	textures = {"mobs_horsepeg.png"},
	visual = "mesh",
	mesh = "mobs_horse.x",
	makes_footstep_sound = true,
	walk_velocity = 1,
	armor = 200,
	drops = {
		{name = "kpgmobs:meat_raw",
		chance = 1,
		min = 2,
		max = 3,},
		{name = "kpgmobs:leather",
		chance = 10008,
		min = 1,
		max = 1,},
		{name = "kpgmobs:leather",
		chance = 25,
		min = 1,
		max = 1,},

	},
	drawtype = "front",
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	animation = {
		speed_normal = 15,
		stand_start = 25,
		stand_end = 75,
		walk_start = 75,
		walk_end = 100,
	},
	follow = "farming:wheat",
	view_range = 5,
	
	on_rightclick = function(self, clicker)
		if clicker:is_player() and clicker:get_inventory() then
			clicker:get_inventory():add_item("main", "kpgmobs:horsepegh1")
			self.object:remove()
		end
	end,
})
kpgmobs:register_spawn("kpgmobs:horse2", {"default:dirt_with_grass"}, 20, 8, 10000, 1, 31000)

kpgmobs:register_mob("kpgmobs:jeraf", {
	type = "animal",
	hp_max = 5,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	textures = {"mobs_jeraf.png"},
	visual = "mesh",
	mesh = "mobs_jeraf.x",
	makes_footstep_sound = true,
	walk_velocity = 2,
	stepheight=0.9,		
	armor = 200,
	drops = {
		{name = "kpgmobs:meat_raw",
		chance = 1,
		min = 2,
		max = 3,},
	},
	drawtype = "front",
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	
	animation = {
		speed_normal = 15,
		stand_start = 0,
		stand_end = 30,
		walk_start = 70,
		walk_end = 100,
	},
	follow = "farming:wheat",
	view_range = 5,
	
})
kpgmobs:register_spawn("kpgmobs:jeraf", {"default:desert_sand"}, 20, 8, 9000, 1, 31000)

kpgmobs:register_mob("kpgmobs:medved", {
	type = "animal",
	hp_max = 5,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	textures = {"mobs_medved.png"},
	visual = "mesh",
	mesh = "mobs_medved.x",
	makes_footstep_sound = true,
	stepheight=1.1,
	view_range = 7,
	walk_velocity = 1,
	run_velocity = 2,
	damage = 10,
	armor = 200,
	attack_type = "dogfight",
	drops = {
		{name = "kpgmobs:meat_raw",
		chance = 1,
		min = 3,
		max = 6,},
	},
	drawtype = "front",
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	on_rightclick = nil,

	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 30,
		walk_start = 35,
		walk_end = 65,
		run_start = 105,
		run_end = 135,
		punch_start = 70,
		punch_end = 100,
	},
})
kpgmobs:register_spawn("kpgmobs:medved", {"default:dirt_with_grass","default:dirt","default:desert_sand"}, 20, 0, 11000, 3, 31000)

kpgmobs:register_mob("kpgmobs:cow", {
	type = "animal",
	hp_max = 5,
	collisionbox = {-0.4, -0.01, -0.4, 0.4, 1, 0.4},
	textures = {"mobs_cow.png"},
	visual = "mesh",
	mesh = "mobs_cow.x",
	makes_footstep_sound = true,
	stepheight=1.1,
	view_range = 7,
	walk_velocity = 1,
	run_velocity = 2,
	damage = 10,
	armor = 200,
	drops = {
		{name = "kpgmobs:meat_raw",
		chance = 1,
		min = 2,
		max = 4,},
		{name = "kpgmobs:leather",
		chance = 10,
		min = 1,
		max = 1,},
		{name = "kpgmobs:leather",
		chance = 10006,
		min = 1,
		max = 1,},
	},
	drawtype = "front",
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
    follow = "farming:wheat",
	view_range = 5,
	-- ADDED TenPlus1 (right-clicking cow with empty bucket gives bucket of milk and moo sound)
	on_rightclick = function(self, clicker)
		local tool = clicker:get_wielded_item():get_name()
		if tool == "farming:wheat" then
			if not self.tamed then
				if not minetest.setting_getbool("creative_mode") then
					tool:take_item()
					clicker:set_wielded_item(tool)
				end
				self.object:set_properties({
					stepheight=0.9,		
				})
				self.tamed = true
			end
		elseif tool == "bucket:bucket_empty" then
			if self.milked then
				minetest.sound_play("cow", {
					object = self.object,
					gain = 1.0, -- default
					max_hear_distance = 32, -- default
					loop = false,
				})
				do return end
			end
			clicker:get_inventory():remove_item("main", "bucket:bucket_empty")
			clicker:get_inventory():add_item("main", "kpgmobs:bucket_milk")
			if math.random(1,2) > 1 then self.milked = true	end
		end
	end,


	animation = {
		speed_normal = 15,
		speed_run = 15,
		stand_start = 0,
		stand_end = 30,
		walk_start = 35,
		walk_end = 65,
		run_start = 105,
		run_end = 135,
		punch_start = 70,
		punch_end = 100,
	},
})
kpgmobs:register_spawn("kpgmobs:cow", {"default:dirt_with_grass","default:dirt","default:desert_sand"}, 20, 0, 11000, 3, 31000)

-- ADDED Tenplus1 (Bucket of Milk gives 4 hearts and returns empty bucket)
minetest.register_craftitem("kpgmobs:bucket_milk", {
	description = "Bucket of Milk",
	inventory_image = "bucket_milk.png",
	on_use = minetest.item_eat(2.4, "bucket:bucket_empty"),
})

if minetest.setting_get("log_mods") then
	minetest.log("action", "kpgmobs loaded")
end
