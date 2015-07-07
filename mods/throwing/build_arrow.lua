minetest.register_craftitem("throwing:arrow_build", {
	description = "Build Arrow",
	inventory_image = "throwing_arrow_build.png",
})

minetest.register_node("throwing:arrow_build_box", {
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			-- Shaft
			{-6.5/17, -1.5/17, -1.5/17, 6.5/17, 1.5/17, 1.5/17},
			--Spitze
			{-4.5/17, 2.5/17, 2.5/17, -3.5/17, -2.5/17, -2.5/17},
			{-8.5/17, 0.5/17, 0.5/17, -6.5/17, -0.5/17, -0.5/17},
			--Federn
			{6.5/17, 1.5/17, 1.5/17, 7.5/17, 2.5/17, 2.5/17},
			{7.5/17, -2.5/17, 2.5/17, 6.5/17, -1.5/17, 1.5/17},
			{7.5/17, 2.5/17, -2.5/17, 6.5/17, 1.5/17, -1.5/17},
			{6.5/17, -1.5/17, -1.5/17, 7.5/17, -2.5/17, -2.5/17},
			
			{7.5/17, 2.5/17, 2.5/17, 8.5/17, 3.5/17, 3.5/17},
			{8.5/17, -3.5/17, 3.5/17, 7.5/17, -2.5/17, 2.5/17},
			{8.5/17, 3.5/17, -3.5/17, 7.5/17, 2.5/17, -2.5/17},
			{7.5/17, -2.5/17, -2.5/17, 8.5/17, -3.5/17, -3.5/17},
		}
	},
	tiles = {"throwing_arrow_build.png", "throwing_arrow_build.png", "throwing_arrow_build_back.png", "throwing_arrow_build_front.png", "throwing_arrow_build_2.png", "throwing_arrow_build.png"},
	groups = {not_in_creative_inventory=1},
})

local THROWING_ARROW_ENTITY={
	physical = false,
	timer=0,
	visual = "wielditem",
	visual_size = {x=0.1, y=0.1},
	textures = {"throwing:arrow_build_box"},
	lastpos={},
	collisionbox = {0,0,0,0,0,0},
	node = "",
}

THROWING_ARROW_ENTITY.on_step = function(self, dtime)
	self.timer=self.timer+dtime
	local pos = self.object:getpos()
	local node = minetest.env:get_node(pos)

	if self.timer>0.2
		or (node.name ~= "air" and node.name ~= "default:water_source" 
		and node.name ~= "default:water_flowing" and node.name ~= "default:lava_flowing" 
		and node.name ~= "default:lava_source") then
		self.timer=0
		local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 1)
		for k, obj in pairs(objs) do
			if obj:get_luaentity() ~= nil then
				if obj:get_luaentity().name ~= "throwing:arrow_build_entity" and obj:get_luaentity().name ~= "__builtin:item" then
					if self.node ~= "" and self.player~=nil then
						if not minetest.is_protected(self.lastpos,self.player:get_player_name()) then
							local buildable=true
							local nname = minetest.env:get_node({x=self.lastpos.x, y=self.lastpos.y-1, z=self.lastpos.z}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
							nname = minetest.env:get_node({x=self.lastpos.x+1, y=self.lastpos.y, z=self.lastpos.z}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
							nname = minetest.env:get_node({x=self.lastpos.x-1, y=self.lastpos.y, z=self.lastpos.z}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
							nname = minetest.env:get_node({x=self.lastpos.x, y=self.lastpos.y, z=self.lastpos.z+1}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
							nname = minetest.env:get_node({x=self.lastpos.x, y=self.lastpos.y, z=self.lastpos.z-1}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
							nname = minetest.env:get_node({x=self.lastpos.x, y=self.lastpos.y+1, z=self.lastpos.z}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
								buildable=false
							end end end end end end
							if buildable then
							self.object:get_luaentity().player:get_inventory():remove_item("main",ItemStack(self.node.name))
							minetest.env:set_node(self.lastpos, {name=self.node})
							end
						end
					end
					self.object:remove()
				end
			else
				if self.node ~= "" then
						if not minetest.is_protected(self.lastpos,self.player:get_player_name()) then
							local buildable=true
							local nname = minetest.env:get_node({x=self.lastpos.x, y=self.lastpos.y-1, z=self.lastpos.z}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
							nname = minetest.env:get_node({x=self.lastpos.x+1, y=self.lastpos.y, z=self.lastpos.z}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
							nname = minetest.env:get_node({x=self.lastpos.x-1, y=self.lastpos.y, z=self.lastpos.z}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
							nname = minetest.env:get_node({x=self.lastpos.x, y=self.lastpos.y, z=self.lastpos.z+1}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
							nname = minetest.env:get_node({x=self.lastpos.x, y=self.lastpos.y, z=self.lastpos.z-1}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
							nname = minetest.env:get_node({x=self.lastpos.x, y=self.lastpos.y+1, z=self.lastpos.z}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
								buildable=false
							end end end end end end
							if buildable then
							self.object:get_luaentity().player:get_inventory():remove_item("main",ItemStack(self.node.name))
							minetest.env:set_node(self.lastpos, {name=self.node})
							end
						end
				end
				self.object:remove()
			end
		end
	end

	if self.lastpos.x~=nil then
		if node.name ~= "air" then
			if self.player and self.node ~= "" then
						if not minetest.is_protected(self.lastpos,self.player:get_player_name()) then
							local buildable=true
							local nname = minetest.env:get_node({x=self.lastpos.x, y=self.lastpos.y-1, z=self.lastpos.z}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
							nname = minetest.env:get_node({x=self.lastpos.x+1, y=self.lastpos.y, z=self.lastpos.z}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
							nname = minetest.env:get_node({x=self.lastpos.x-1, y=self.lastpos.y, z=self.lastpos.z}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
							nname = minetest.env:get_node({x=self.lastpos.x, y=self.lastpos.y, z=self.lastpos.z+1}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
							nname = minetest.env:get_node({x=self.lastpos.x, y=self.lastpos.y, z=self.lastpos.z-1}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
							nname = minetest.env:get_node({x=self.lastpos.x, y=self.lastpos.y+1, z=self.lastpos.z}).name
							if nname=="air" or nname=="default:water_source" or nname=="default:water_flowing" then
								buildable=false
							end end end end end end
							if buildable then
							self.object:get_luaentity().player:get_inventory():remove_item("main",ItemStack(self.node.name))
							minetest.env:set_node(self.lastpos, {name=self.node})
							end
						end
			end
			self.object:remove()
		end
	end
	self.lastpos={x=pos.x, y=pos.y, z=pos.z}
end

minetest.register_entity("throwing:arrow_build_entity", THROWING_ARROW_ENTITY)

minetest.register_craft({
	output = 'throwing:arrow_build',
	recipe = {
		{'group:stick', 'group:stick', 'default:shovel_steel'},
	}
})