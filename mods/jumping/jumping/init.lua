local trampolinebox = {
	type = "fixed",
	fixed = {
		{-0.5, -0.2, -0.5,  0.5,    0,  0.5},

		{-0.5, -0.5, -0.5, -0.4, -0.2, -0.4},
		{ 0.4, -0.5, -0.5,  0.5, -0.2, -0.4},
		{ 0.4, -0.5,  0.4,  0.5, -0.2,  0.5},
		{-0.5, -0.5,  0.4, -0.4, -0.2,  0.5},
		}
}

local cushionbox = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.5,  0.5, -0.3,  0.5},
		}
}

local trampoline_punch = function(pos, node)
	local id = string.sub(node.name, #node.name)
	id = id + math.random(1,5)-2
	if id >= 8 then id = id-7 end
	minetest.add_node(pos, {name = string.sub(node.name, 1, #node.name - 1)..id})
end

local groups={dig_immediate=2, bouncy=math.random(8,24)+67, fall_damage_add_percent=-70}
for i = 1, 7 do
	minetest.register_node("jumping:trampoline"..i, {
		description = "Trampoline",
		drawtype = "nodebox",
		node_box = trampolinebox,
		selection_box = trampolinebox,
		paramtype = "light",
		on_punch = trampoline_punch,
		tiles = {
			"jumping_trampoline_top.png",
			"jumping_trampoline_bottom.png",
			"jumping_trampoline_sides.png^jumping_trampoline_sides_overlay"..i..".png"
		},
		groups = groups,
	})
groups={dig_immediate=2, not_in_craft_guide=1, not_in_creative_inventory=1, bouncy=math.random(68,84)+i*7, fall_damage_add_percent=-70}
end

minetest.register_node("jumping:cushion", {
	description = "Cushion",
	drawtype = "nodebox",
	node_box = cushionbox,
	selection_box = cushionbox,
	paramtype = "light",
	tiles = {
		"jumping_cushion_tb.png",
		"jumping_cushion_tb.png",
		"jumping_cushion_sides.png"
	},
	groups = {dig_immediate=2, disable_jump=1, fall_damage_add_percent=-100},
})

minetest.register_craft({
	output = "jumping:trampoline1",
	recipe = {
		{"technic:rubber", "technic:rubber", "technic:rubber"},
		{"group:stick", "group:stick", "group:stick"}
	}
})

minetest.register_craft({
	output = "jumping:cushion",
	recipe = {
		{"wool:white", "wool:white", "wool:white"},
		{"wool:white", "wool:white", "wool:white"}
	}
})
