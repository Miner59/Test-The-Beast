minetest.register_craftitem("throwing:golden_arrow", {
	description = "Golden Arrow",
	inventory_image = "throwing_golden_arrow.png",
})

minetest.register_node("throwing:golden_arrow_box", {
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
	tiles = {"throwing_golden_arrow.png", "throwing_golden_arrow.png", "throwing_golden_arrow_back.png", "throwing_golden_arrow_front.png", "throwing_golden_arrow_2.png", "throwing_golden_arrow.png"},
	groups = {not_in_creative_inventory=1},
})

local THROWING_ARROW_ENTITY={
	physical = false,
	timer=0,
	visual = "wielditem",
	visual_size = {x=0.1, y=0.1},
	textures = {"throwing:golden_arrow_box"},
	lastpos={},
	collisionbox = {0,0,0,0,0,0},
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
		local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 2)
		for k, obj in pairs(objs) do
			if obj:get_luaentity() ~= nil then
				if obj:get_luaentity().name ~= "throwing:golden_arrow_entity" and obj:get_luaentity().name ~= "__builtin:item" then
					local damage = 3
					obj:punch(self.object, 1.0, {
						full_punch_interval=1.0,
						damage_groups={fleshy=damage},
					}, nil)
					self.object:remove()
					return
				end
			else
				local damage = 3
				obj:punch(self.object, 1.0, {
					full_punch_interval=1.0,
					damage_groups={fleshy=damage},
				}, nil)
				self.object:remove()
					return
			end
		end
	end

	if self.lastpos.x~=nil then
		if node.name ~= "air" and node.name ~= "default:water_source" 
			and node.name ~= "default:water_flowing" and node.name ~= "default:lava_flowing" 
			and node.name ~= "default:lava_source" then
			if self.object:get_luaentity().player~=nil and self.object:get_luaentity().player:get_inventory()~=nil then
				self.object:get_luaentity().player:get_inventory():add_item("main",ItemStack("throwing:golden_arrow"))
			end
			self.object:remove()
		end
	end
	self.lastpos={x=pos.x, y=pos.y, z=pos.z}
end

minetest.register_entity("throwing:golden_arrow_entity", THROWING_ARROW_ENTITY)

minetest.register_craft({
	output = 'throwing:golden_arrow 16',
	recipe = {
		{'group:stick', 'group:stick', 'default:gold_ingot'},
	}
})


