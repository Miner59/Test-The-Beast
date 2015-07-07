
minetest.register_alias("grinder", "technic:grinder", "lv_grinder", "technic:lv_grinder")
minetest.register_craft({
	output = 'technic:lv_grinder',
	recipe = {
		{'default:desert_stone', 'default:desert_stone',  'default:desert_stone'},
		{'default:desert_stone', 'default:diamond',       'default:desert_stone'},
		{'default:stone',        'default:copperblock',   'default:stone'},
	}
})

technic.register_grinder({tier="LV", demand={200}, speed=1})

