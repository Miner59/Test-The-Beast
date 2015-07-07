minetest.register_tool("technic:diving_gear", {
	description = ("Diving gear"),
	inventory_image = "diving_gear.png",
})

minetest.register_craftitem("technic:diving_gear_used", {
	description = ("Diving gear (air empty)"),
	inventory_image = "diving_gear.png",
})

minetest.register_craftitem("technic:diving_helmet", {
	description = ("Diving helmet"),
	inventory_image = "diving_helmet.png",
})

minetest.register_craftitem("technic:diving_boots", {
	description = ("Diving boots"),
	inventory_image = "diving_boots.png",
})

minetest.register_craftitem("technic:diving_suit_vest", {
	description = ("Diving suit vest"),
	inventory_image = "technic_rubber_vest.png",
})

minetest.register_craftitem("technic:diving_suit_trousers", {
	description = ("Diving suit trousers"),
	inventory_image = "technic_rubber_trousers.png",
})

minetest.register_craftitem("technic:diving_suit", {
	description = ("Diving suit"),
	inventory_image = "diving_suit.png",
})

minetest.register_craftitem("technic:gas_cylinder", {
	description = ("Gas cylinder"),
	inventory_image = "technic_gas_cylinder.png",
})

minetest.register_craft({
	output = "technic:diving_gear",
	recipe = {
		{"technic:diving_helmet",""},
		{"technic:diving_suit","technic:gas_cylinder"},
		{"technic:diving_boots",""},

	},
})

minetest.register_craft({
	output = "technic:diving_helmet",
	recipe = {
		{"default:copper_ingot","default:copper_ingot","default:copper_ingot"},
		{"default:copper_ingot","default:glass","default:copper_ingot"},
		{"default:copper_ingot","technic:rubber","default:copper_ingot"},

	},
})

minetest.register_craft({
	output = "technic:diving_helmet",
	recipe = {
		{"technic:brass_ingot","technic:brass_ingot","technic:brass_ingot"},
		{"technic:brass_ingot","default:glass","technic:brass_ingot"},
		{"technic:brass_ingot","technic:rubber","technic:brass_ingot"},

	},
})

minetest.register_craft({
	output = "technic:diving_suit_vest",
	recipe = {
		{"technic:rubber","","technic:rubber"},
		{"technic:rubber","technic:rubber","technic:rubber"},
		{"technic:rubber","technic:rubber","technic:rubber"},
	},
})

minetest.register_craft({
	output = "technic:diving_suit",
	recipe = {
		{"technic:diving_suit_vest"},
		{"technic:diving_suit_trousers"},

	},
})

minetest.register_craft({
	output = "technic:diving_boots",
	recipe = {
		{"","",""},
		{"technic:brass_ingot","","technic:brass_ingot"},
		{"technic:brass_ingot","","technic:brass_ingot"},
	},
})


--in very new versions of technic modpack there is lead available, so use as alternative
if minetest.get_all_craft_recipes("technic:lead_ingot")~=nil then 

minetest.register_craft({
	output = "technic:diving_boots 2",
	recipe = {
		{"","",""},
		{"technic:lead_ingot","","technic:lead_ingot"},
		{"technic:lead_ingot","","technic:lead_ingot"},
	},
})

end

minetest.register_craft({
	output = "technic:diving_suit_trousers",
	recipe = {
		{"technic:rubber","technic:rubber","technic:rubber"},
		{"technic:rubber","","technic:rubber"},
		{"technic:rubber","","technic:rubber"},
	},
})

minetest.register_craft({
	output = "technic:diving_gear",
	type="shapeless",
	recipe = {"technic:gas_cylinder", "technic:diving_gear"},

	replacements = { { "technic:gas_cylinder", "vessels:steel_bottle"}, },
})

minetest.register_craft({
	output = "technic:diving_gear",
	type="shapeless",
	recipe = {"technic:gas_cylinder", "technic:diving_gear_used"},
	replacements = { { "technic:gas_cylinder", "vessels:steel_bottle"}, },
})


