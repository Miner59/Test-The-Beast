minetest.register_craft({
	output = 'technic:diamond_drill_head',
	recipe = {
		{'technic:stainless_steel_ingot', 'default:diamond', 'technic:stainless_steel_ingot'},
		{'default:diamond',               '',                'default:diamond'},
		{'technic:stainless_steel_ingot', 'default:diamond', 'technic:stainless_steel_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:green_energy_crystal',
	recipe = {
		{'default:gold_ingot', 'technic:battery', 'dye:green'},
		{'technic:battery', 'technic:red_energy_crystal', 'technic:battery'},
		{'dye:green', 'technic:battery', 'default:gold_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:blue_energy_crystal',
	recipe = {
		{'moreores:mithril_ingot', 'technic:battery', 'dye:blue'},
		{'technic:battery', 'technic:green_energy_crystal', 'technic:battery'},
		{'dye:blue', 'technic:battery', 'moreores:mithril_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:red_energy_crystal',
	recipe = {
		{'moreores:silver_ingot', 'technic:battery', 'dye:red'},
		{'technic:battery', 'default:diamondblock', 'technic:battery'},
		{'dye:red', 'technic:battery', 'moreores:silver_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:fine_copper_wire 2',
	recipe = {
		{'', 'default:copper_ingot', ''},
		{'', 'default:copper_ingot', ''},
		{'', 'default:copper_ingot', ''},
	}
})

minetest.register_craft({
	output = 'technic:copper_coil 1',
	recipe = {
		{'technic:fine_copper_wire', 'technic:wrought_iron_ingot', 'technic:fine_copper_wire'},
		{'technic:wrought_iron_ingot', '', 'technic:wrought_iron_ingot'},
		{'technic:fine_copper_wire', 'technic:wrought_iron_ingot', 'technic:fine_copper_wire'},
	}
})

minetest.register_craft({
	output = 'technic:motor',
	recipe = {
		{'technic:carbon_steel_ingot', 'technic:copper_coil', 'technic:carbon_steel_ingot'},
		{'technic:carbon_steel_ingot', 'technic:copper_coil', 'technic:carbon_steel_ingot'},
		{'technic:carbon_steel_ingot', 'default:copper_ingot', 'technic:carbon_steel_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:lv_transformer',
	recipe = {
		{'technic:wrought_iron_ingot', 'technic:wrought_iron_ingot', 'technic:wrought_iron_ingot'},
		{'technic:copper_coil',        'technic:wrought_iron_ingot', 'technic:copper_coil'},
		{'technic:wrought_iron_ingot', 'technic:wrought_iron_ingot', 'technic:wrought_iron_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:mv_transformer',
	recipe = {
		{'technic:carbon_steel_ingot', 'technic:carbon_steel_ingot', 'technic:carbon_steel_ingot'},
		{'technic:copper_coil',        'technic:carbon_steel_ingot', 'technic:copper_coil'},
		{'technic:carbon_steel_ingot', 'technic:carbon_steel_ingot', 'technic:carbon_steel_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:hv_transformer',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot'},
		{'technic:copper_coil',           'technic:stainless_steel_ingot', 'technic:copper_coil'},
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot'},
	}
})


minetest.register_craftitem("technic:nothing", {
	description = "",
	inventory_image = "blank.png",
})

minetest.register_craft({
	type = "shapeless",
	output = "technic:nothing",
	recipe = {"default:copper_ingot", "default:steel_ingot"}
})

if minetest.register_craft_predict then
	minetest.register_craft_predict(function(itemstack, player, old_craft_grid, craft_inv)
		if itemstack:get_name() == "technic:nothing" then
			return ItemStack("")
		end
	end)
end

minetest.register_craft( {
	type = "shapeless",
        output = "technic:brass_ingot 2",
	recipe = {
		"moreores:silver_ingot",
		"default:copper_ingot",
	},
})

