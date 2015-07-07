
minetest.register_craft({
	output = 'technic:gold_chest',
	recipe = {
		{'default:gold_ingot','default:gold_ingot','default:gold_ingot'},
		{'default:gold_ingot','technic:silver_chest','default:gold_ingot'},
		{'default:gold_ingot','default:gold_ingot','default:gold_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:gold_locked_chest',
	recipe = {
		{'default:gold_ingot','default:gold_ingot','default:gold_ingot'},
		{'default:gold_ingot','technic:silver_locked_chest','default:gold_ingot'},
		{'default:gold_ingot','default:gold_ingot','default:gold_ingot'},
	}
})

minetest.register_craft({
	type= "shapeless",
	output = 'technic:gold_locked_chest',
	recipe = {
		'technic:gold_chest',
		'default:steel_ingot',
	}
})

technic.chests:register("Gold", {
	width = 15,
	height = 6,
	sort = true,
	autosort = true,
	infotext = true,
	color = true,
	locked = false,
})

technic.chests:register("Gold", {
	width = 15,
	height = 6,
	sort = true,
	autosort = true,
	infotext = true,
	color = true,
	locked = true,
})

