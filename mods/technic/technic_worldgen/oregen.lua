minetest.register_ore({
	ore_type       = "scatter",
	ore            = "technic:mineral_uranium",
	wherein        = "default:stone",
	clust_scarcity = 22*22*22,
	clust_num_ores = 4,
	clust_size     = 6,
	height_min     = -323,
	height_max     = -80,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "technic:mineral_chromium",
	wherein        = "default:stone",
	clust_scarcity = 18*18*18,
	clust_num_ores = 2,
	clust_size     = 3,
	height_min     = -31000,
	height_max     = -123,
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "technic:mineral_zinc",
	wherein        = "default:stone",
	clust_scarcity = 16*16*16,
	clust_num_ores = 4,
	clust_size     = 3,
	height_min     = -373,
	height_max     = -43,
})

if technic.config:get_bool("enable_marble_generation") then
minetest.register_ore({
	ore_type       = "sheet",
	ore            = "technic:marble",
	wherein        = "default:stone",
	clust_scarcity = 1,
	clust_num_ores = 1,
	clust_size     = 3,
	height_min     = -31000,
	height_max     = -50,
	noise_threshhold = 0.4,
	noise_params = {offset=0, scale=15, spread={x=150, y=150, z=150}, seed=23, octaves=3, persist=0.70}
})
end

if technic.config:get_bool("enable_granite_generation") then
minetest.register_ore({
	ore_type       = "sheet",
	ore            = "technic:granite",
	wherein        = "default:stone",
	clust_scarcity = 1,
	clust_num_ores = 1,
	clust_size     = 4,
	height_min     = -31000,
	height_max     = -150,
	noise_threshhold = 0.4,
	noise_params = {offset=0, scale=15, spread={x=130, y=130, z=130}, seed=24, octaves=3, persist=0.70}
})
end

