minetest.register_node("paragenv7:dirt", {
	description = "Dirt",
	tiles = {"default_dirt.png"},
	groups = {crumbly=3,soil=1, not_in_craft_guide=1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_alias("paragenv7:dirt","default:dirt")

minetest.register_node("paragenv7:grass", {
	description = "Grass",
	tiles = {"default_grass.png", "default_dirt.png", "default_grass.png"},
	groups = {crumbly=3,soil=1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_grass_footstep", gain=0.25},
	}),
})

minetest.register_node("paragenv7:drygrass", {
	description = "Dry Grass",
	tiles = {"paragenv7_drygrass.png"},
	groups = {crumbly=3,soil=1},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_grass_footstep", gain=0.4},
	}),
})

minetest.register_node("paragenv7:permafrost", {
	description = "Permafrost",
	tiles = {"paragenv7_permafrost.png"},
	groups = {crumbly=2},
	drop = "default:dirt",
	sounds = default.node_sound_dirt_defaults(),
})

minetest.register_node("paragenv7:goldengrass", {
	description = "Golden Grass",
	drawtype = "plantlike",
	tiles = {"paragenv7_goldengrass.png"},
	inventory_image = "paragenv7_goldengrass.png",
	wield_image = "paragenv7_goldengrass.png",
	paramtype = "light",
	walkable = false,
	buildable_to = true,
	groups = {snappy=3,flammable=3,flora=1,attached_node=1,grass=1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
	},
})

minetest.register_node("paragenv7:cactus", {
	description = "Cactus",
	tiles = {"default_cactus_top.png", "default_cactus_top.png", "default_cactus_side.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {snappy=1,choppy=3,flammable=2},
	drop = "default:cactus",
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node
})

minetest.register_node("paragenv7:appleleaf", {
	description = "Appletree Leaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"default_leaves.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy=3, flammable=2, leaves=1},
	sounds = default.node_sound_leaves_defaults(),
			drop = {
				max_items = 1,
				items = {
					{items = {"paragenv7:sapling"}, rarity = 55 },
					{items = {"paragenv7:appleleaf"} }
				}},

})

		minetest.register_node("paragenv7:acaciasapling", {
			description = "Acacia Sapling",
			drawtype = "plantlike",
			tiles = {"paragenv7_acaciasapling.png"},
			inventory_image = "paragenv7_acaciasapling.png",
			paramtype = "light",
			paramtype2 = "waving",
			walkable = false,
			selection_box = {
				type = "fixed",
				fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
			},
			groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1,sapling=1},
			sounds = default.node_sound_defaults(),
		})

	minetest.register_abm({
		nodenames = "paragenv7:acaciasapling",
		interval = 500,
		chance = 20,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local p_top = {x=pos.x, y=pos.y+1, z=pos.z}
			local p_bot = {x=pos.x, y=pos.y-1, z=pos.z}
			local n_top = minetest.get_node(p_top)
			local n_bot = minetest.get_node(p_bot)
			if n_top.name == "air" and (n_bot.name == "default:dirt"or n_bot.name == "default:dirt_with_grass"or n_bot.name == "paragenv7:dirt"or n_bot.name =="paragenv7:grass" or n_bot.name == "default:sand" or n_bot.name == "default:desert_sand" or n_bot.name == "paragenv7:drygrass")
			  then
		minetest.remove_node(pos)
if n_bot.name =="default:dirt_with_snow" or n_bot.name == "default:dirt"or n_bot.name == "default:dirt_with_grass"or n_bot.name == "paragenv7:dirt"or n_bot.name =="paragenv7:grass" or n_bot.name =="paragenv7:drygrass"or n_bot.name =="default:desert_sand"or n_bot.name =="default:sand"or n_bot.name == "paragenv7:permafrost"or n_bot.name == "default:snow"or n_bot.name == "default:gravel"or n_bot.name == "default:clay" or n_bot.name == "default:snowblock" then
		minetest.remove_node({x=pos.x,y=pos.y-1,z=pos.z})
n_bot = minetest.get_node({x=pos.x,y=pos.y-2,z=pos.z})
if n_bot.name =="default:dirt_with_snow" or n_bot.name == "default:dirt"or n_bot.name == "default:dirt_with_grass"or n_bot.name == "paragenv7:dirt"or n_bot.name =="paragenv7:grass" or n_bot.name =="paragenv7:drygrass"or n_bot.name =="default:desert_sand"or n_bot.name =="default:sand"or n_bot.name == "paragenv7:permafrost"or n_bot.name == "default:snow"or n_bot.name == "default:gravel"or n_bot.name == "default:clay" or n_bot.name == "default:snowblock" then
		minetest.remove_node({x=pos.x,y=pos.y-2,z=pos.z})
n_bot = minetest.get_node({x=pos.x,y=pos.y-3,z=pos.z})
if n_bot.name =="default:dirt_with_snow" or n_bot.name == "default:dirt"or n_bot.name == "default:dirt_with_grass"or n_bot.name == "paragenv7:dirt"or n_bot.name =="paragenv7:grass" or n_bot.name =="paragenv7:drygrass"or n_bot.name =="default:desert_sand"or n_bot.name =="default:sand"or n_bot.name == "paragenv7:permafrost"or n_bot.name == "default:snow"or n_bot.name == "default:gravel"or n_bot.name == "default:clay" or n_bot.name == "default:snowblock" then
		minetest.remove_node({x=pos.x,y=pos.y-3,z=pos.z})
end
end
end
				minetest.spawn_tree(pos, 
{
	axiom="&&GGGG&&TTTTTTTT[&G+G^T&G-G^T][/&G+G^T&G-G^T][//&G+G^T&G-G^T][*&G+G^T&G-G^T]GG[&G+Gfff-f-fff+f+fff-f-ffff][/&G+Gfff-f-fff+f+fff-f-ffff][//&G+Gfff-f-fff+f+fff-f-ffff][*&G+Gfff-f-fff+f+fff-f-ffff",
	trunk="paragenv7:acaciatree",
	leaves="paragenv7:acacialeaf",
	leaves2="air",
	leaves2_chance=8,
	angle=90,
	iterations=1,
	random_level=0,
	trunk_type="single",
	thin_branches=true
})	

			end

		end
	})

		minetest.register_node("paragenv7:pinesapling", {
			description = "Pine Sapling",
			drawtype = "plantlike",
			tiles = {"paragenv7_pinesapling.png"},
			inventory_image = "paragenv7_pinesapling.png",
			paramtype = "light",
			paramtype2 = "waving",
			walkable = false,
			selection_box = {
				type = "fixed",
				fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
			},
			groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1,sapling=1},
			sounds = default.node_sound_defaults(),
		})

	minetest.register_abm({
		nodenames = "paragenv7:pinesapling",
		interval = 600,
		chance = 20,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local p_top = {x=pos.x, y=pos.y+1, z=pos.z}
			local p_bot = {x=pos.x, y=pos.y-1, z=pos.z}
			local n_top = minetest.get_node(p_top)
			local n_bot = minetest.get_node(p_bot)
local blk=n_bot.name
			if n_top.name == "air" and (n_bot.name =="default:dirt_with_snow" or n_bot.name == "default:snowblock" or n_bot.name == "default:snow"or n_bot.name == "paragenv7:permafrost")
			  then
		minetest.remove_node(pos)
if n_bot.name =="default:dirt_with_snow" or n_bot.name == "default:dirt"or n_bot.name == "default:dirt_with_grass"or n_bot.name == "paragenv7:dirt"or n_bot.name =="paragenv7:grass" or n_bot.name =="paragenv7:drygrass"or n_bot.name =="default:desert_sand"or n_bot.name =="default:sand"or n_bot.name == "paragenv7:permafrost"or n_bot.name == "default:snow"or n_bot.name == "default:gravel"or n_bot.name == "default:clay" or n_bot.name == "default:snowblock" then
		minetest.remove_node({x=pos.x,y=pos.y-1,z=pos.z})
n_bot = minetest.get_node({x=pos.x,y=pos.y-2,z=pos.z})
if n_bot.name =="default:dirt_with_snow" or n_bot.name == "default:dirt"or n_bot.name == "default:dirt_with_grass"or n_bot.name == "paragenv7:dirt"or n_bot.name =="paragenv7:grass" or n_bot.name =="paragenv7:drygrass"or n_bot.name =="default:desert_sand"or n_bot.name =="default:sand"or n_bot.name == "paragenv7:permafrost"or n_bot.name == "default:snow"or n_bot.name == "default:gravel"or n_bot.name == "default:clay" or n_bot.name == "default:snowblock" then
		minetest.remove_node({x=pos.x,y=pos.y-2,z=pos.z})
n_bot = minetest.get_node({x=pos.x,y=pos.y-3,z=pos.z})
if n_bot.name =="default:dirt_with_snow" or n_bot.name == "default:dirt"or n_bot.name == "default:dirt_with_grass"or n_bot.name == "paragenv7:dirt"or n_bot.name =="paragenv7:grass" or n_bot.name =="paragenv7:drygrass"or n_bot.name =="default:desert_sand"or n_bot.name =="default:sand"or n_bot.name == "paragenv7:permafrost"or n_bot.name == "default:snow"or n_bot.name == "default:gravel"or n_bot.name == "default:clay" or n_bot.name == "default:snowblock" then
		minetest.remove_node({x=pos.x,y=pos.y-3,z=pos.z})
n_bot = minetest.get_node({x=pos.x,y=pos.y-4,z=pos.z})
if n_bot.name =="default:dirt_with_snow" or n_bot.name == "default:dirt"or n_bot.name == "default:dirt_with_grass"or n_bot.name == "paragenv7:dirt"or n_bot.name =="paragenv7:grass" or n_bot.name =="paragenv7:drygrass"or n_bot.name =="default:desert_sand"or n_bot.name =="default:sand"or n_bot.name == "paragenv7:permafrost"or n_bot.name == "default:snow"or n_bot.name == "default:snowblock"or n_bot.name == "default:gravel"or n_bot.name == "default:clay" then
		minetest.remove_node({x=pos.x,y=pos.y-4,z=pos.z})
end
end
end
end
if blk=="default:snow" then
blk="default:snowblock"
elseif blk~="default:snowblock" then
blk="default:snow"
end
				minetest.spawn_tree(pos, 
{
	axiom="[&&GGGGG&&TTTTTTTTTTTTTTTTTTTfffR]GGG[&GG+Gf+ffff+ffff+ffff+fff^G&R+RRRR+RRRR+RRRR+RRR+fff+ff+ff+f^G&R+RR+RR+RR+RR]GGG[&GG+Gf+ffff+ffff+ffff+fff^G&R+RRRR+RRRR+RRRR+RRR+fff+ff+ff+f^G&R+RR+RR+RR+RR]GGG[&GG+Gf+ffff+ffff+ffff+fff^G&R+RRRR+RRRR+RRRR+RRR+fff+ff+ff+f^G&R+RR+RR+RR+RR]GGG[&GG+Gf+ffff+ffff+ffff+fff^G&R+RRRR+RRRR+RRRR+RRR]G[&f+f+ff+ff+ff+ff]f[&f+f+ff+ff+ff+ff]f[&R+R+RR+RR+RR+RR]R",
	trunk="paragenv7:pinetree",
	leaves="paragenv7:needles",
	angle=89.9,
	iterations=1,
	random_level=0,
	trunk_type="single",
	thin_branches=true,
	fruit=blk,
	fruit_chance=0
})	
			end

		end
	})

		minetest.register_node("paragenv7:junglesapling", {
			description = "Jungle Sapling",
			drawtype = "plantlike",
			tiles = {"default_junglesapling.png"},
			inventory_image = "default_junglesapling.png",
			paramtype = "light",
			paramtype2 = "waving",
			walkable = false,
			selection_box = {
				type = "fixed",
				fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
			},
			groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1,sapling=1},
			sounds = default.node_sound_defaults(),
		})

minetest.register_abm({
	nodenames = {"paragenv7:junglesapling"},
	interval = 500,
	chance = 20,
	action = function(pos, node)
		local n_bot =  minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name
		local p_top = minetest.get_node({x=pos.x, y=pos.y+1, z=pos.z})
		local is_soil = minetest.get_item_group(n_bot, "soil")
		if is_soil == 0 or p_top.name~="air" then
			return
		end
		minetest.remove_node(pos)
if n_bot.name =="default:dirt_with_snow" or n_bot.name == "default:dirt"or n_bot.name == "default:dirt_with_grass"or n_bot.name == "paragenv7:dirt"or n_bot.name =="paragenv7:grass" or n_bot.name =="paragenv7:drygrass"or n_bot.name =="default:desert_sand"or n_bot.name =="default:sand"or n_bot.name == "paragenv7:permafrost"or n_bot.name == "default:snow"or n_bot.name == "default:gravel"or n_bot.name == "default:clay" or n_bot.name == "default:snowblock" then
		minetest.remove_node({x=pos.x,y=pos.y-1,z=pos.z})
if n_bot.name =="default:dirt_with_snow" or n_bot.name == "default:dirt"or n_bot.name == "default:dirt_with_grass"or n_bot.name == "paragenv7:dirt"or n_bot.name =="paragenv7:grass" or n_bot.name =="paragenv7:drygrass"or n_bot.name =="default:desert_sand"or n_bot.name =="default:sand"or n_bot.name == "paragenv7:permafrost"or n_bot.name == "default:snow"or n_bot.name == "default:gravel"or n_bot.name == "default:clay" or n_bot.name == "default:snowblock" then
		minetest.remove_node({x=pos.x,y=pos.y-2,z=pos.z})
if n_bot.name =="default:dirt_with_snow" or n_bot.name == "default:dirt"or n_bot.name == "default:dirt_with_grass"or n_bot.name == "paragenv7:dirt"or n_bot.name =="paragenv7:grass" or n_bot.name =="paragenv7:drygrass"or n_bot.name =="default:desert_sand"or n_bot.name =="default:sand"or n_bot.name == "paragenv7:permafrost"or n_bot.name == "default:snow"or n_bot.name == "default:gravel"or n_bot.name == "default:clay" or n_bot.name == "default:snowblock" then
		minetest.remove_node({x=pos.x,y=pos.y-3,z=pos.z})
if n_bot.name =="default:dirt_with_snow" or n_bot.name == "default:dirt"or n_bot.name == "default:dirt_with_grass"or n_bot.name == "paragenv7:dirt"or n_bot.name =="paragenv7:grass" or n_bot.name =="paragenv7:drygrass"or n_bot.name =="default:desert_sand"or n_bot.name =="default:sand"or n_bot.name == "paragenv7:permafrost"or n_bot.name == "default:snow"or n_bot.name == "default:gravel"or n_bot.name == "default:clay" or n_bot.name == "default:snowblock" then
		minetest.remove_node({x=pos.x,y=pos.y-4,z=pos.z})
if n_bot.name =="default:dirt_with_snow" or n_bot.name == "default:dirt"or n_bot.name == "default:dirt_with_grass"or n_bot.name == "paragenv7:dirt"or n_bot.name =="paragenv7:grass" or n_bot.name =="paragenv7:drygrass"or n_bot.name =="default:desert_sand"or n_bot.name =="default:sand"or n_bot.name == "paragenv7:permafrost"or n_bot.name == "default:snow"or n_bot.name == "default:gravel"or n_bot.name == "default:clay" or n_bot.name == "default:snowblock" then
		minetest.remove_node({x=pos.x,y=pos.y-5,z=pos.z})
		
end
end
end
end
end
		minetest.log("action", "A jungle sapling grows into a tree at "..minetest.pos_to_string(pos))
		local vm = minetest.get_voxel_manip()
		local minp, maxp = vm:read_from_map({x=pos.x-16, y=pos.y-1, z=pos.z-16}, {x=pos.x+16, y=pos.y+16, z=pos.z+16})
		local a = VoxelArea:new{MinEdge=minp, MaxEdge=maxp}
		local data = vm:get_data()
		paragenv7_jungletree(pos, a, data)
		vm:set_data(data)
		vm:write_to_map(data)
		vm:update_map()
	end
})

		minetest.register_node("paragenv7:sapling", {
			description = "Sapling",
			drawtype = "plantlike",
			tiles = {"default_sapling.png"},
			inventory_image = "default_sapling.png",
			paramtype = "light",
			paramtype2 = "waving",
			walkable = false,
			selection_box = {
				type = "fixed",
				fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
			},
			groups = {snappy=2,dig_immediate=3,flammable=2,attached_node=1,sapling=1},
			sounds = default.node_sound_defaults(),
		})

	minetest.register_abm({
		nodenames = "paragenv7:sapling",
		interval = 500,
		chance = 20,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local p_top = {x=pos.x, y=pos.y+1, z=pos.z}
			local p_bot = {x=pos.x, y=pos.y-1, z=pos.z}
			local n_top = minetest.get_node(p_top)
			local n_bot = minetest.get_node(p_bot)
			if n_top.name == "air" and (n_bot.name =="default:dirt_with_snow" or n_bot.name == "default:dirt"or n_bot.name == "default:dirt_with_grass"or n_bot.name == "paragenv7:dirt"or n_bot.name =="paragenv7:grass"or n_bot.name =="paragenv7:drygrass"or n_bot.name == "paragenv7:permafrost")
			  then
		minetest.remove_node(pos)
if n_bot.name =="default:dirt_with_snow" or n_bot.name == "default:dirt"or n_bot.name == "default:dirt_with_grass"or n_bot.name == "paragenv7:dirt"or n_bot.name =="paragenv7:grass" or n_bot.name =="paragenv7:drygrass"or n_bot.name =="default:desert_sand"or n_bot.name =="default:sand"or n_bot.name == "paragenv7:permafrost"or n_bot.name == "default:snow"or n_bot.name == "default:gravel"or n_bot.name == "default:clay" or n_bot.name == "default:snowblock" then
		minetest.remove_node({x=pos.x,y=pos.y-1,z=pos.z})
n_bot = minetest.get_node({x=pos.x,y=pos.y-2,z=pos.z})
if n_bot.name =="default:dirt_with_snow" or n_bot.name == "default:dirt"or n_bot.name == "default:dirt_with_grass"or n_bot.name == "paragenv7:dirt"or n_bot.name =="paragenv7:grass" or n_bot.name =="paragenv7:drygrass"or n_bot.name =="default:desert_sand"or n_bot.name =="default:sand"or n_bot.name == "paragenv7:permafrost"or n_bot.name == "default:snow"or n_bot.name == "default:gravel"or n_bot.name == "default:clay" or n_bot.name == "default:snowblock" then
		minetest.remove_node({x=pos.x,y=pos.y-2,z=pos.z})
end
end
				minetest.spawn_tree(pos, 
{
	axiom="&&GGG&&TTTTT[&G+G^T][/&G+G^T][//&G+G^T][*&G+G^T]G[&ff+ff+ffff+f+fff-f-fff+f+ffff-f-fffff][G&ff+ff+ffff+f+fff-f-fff+f+ffff-f-Gfffff]",
	trunk="default:tree",
	leaves="paragenv7:appleleaf",
	leaves2="air",
	leaves2_chance=12,
	angle=90,
	iterations=2,
	random_level=2,
	trunk_type="single",
	thin_branches=true,
	fruit="default:apple",
	fruit_chance=1
})	

	end
	end
	})

	minetest.register_abm({
		nodenames = "paragenv7:cactus",
		interval = 2000,
		chance = 60,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local p_top = {x=pos.x, y=pos.y+1, z=pos.z}
			local pp_top = {x=pos.x, y=pos.y+2, z=pos.z}
			local p_bot = {x=pos.x, y=pos.y-1, z=pos.z}
			local p_bbot = {x=pos.x, y=pos.y-2, z=pos.z}
			local n_top = minetest.get_node(p_top)
			local nn_top = minetest.get_node(pp_top)
			local n_bot = minetest.get_node(p_bot)
			local n_bbot = minetest.get_node(p_bbot)
			if n_top.name == "air" and nn_top.name == "air" and n_bot.name =="paragenv7:cactus" and (n_bbot.name == "default:sand" or n_bbot.name == "default:desert_sand") and minetest.get_node({x=pos.x+1,y=pos.y-1,z=pos.z}).name~="air" and minetest.get_node({x=pos.x-1,y=pos.y-1,z=pos.z}).name~="air" and minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z+1}).name~="air" and minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z-1}).name~="air"
			  then
				minetest.spawn_tree(pos, 
{
	axiom="&&G&&TTTT[TTT][&TT^TT][^TT&TT",
	trunk="paragenv7:cactus",
	angle=90,
	iterations=2,
	random_level=0,
	trunk_type="single",
	thin_branches=true
})	
		end

		end
	})

minetest.register_node("paragenv7:jungleleaf", {
	description = "Jungletree Leaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"default_jungleleaves.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy=3, leafdecay=4, flammable=2, leaves=1},
	sounds = default.node_sound_leaves_defaults(),
			drop = {
				max_items = 1,
				items = {
					{items = {"paragenv7:junglesapling"}, rarity = 100 },
					{items = {"paragenv7:jungleleaf"} }
				}},
})

minetest.register_node("paragenv7:vine", {
	description = "Jungletree Vine",
	drawtype = "airlike",
	paramtype = "light",
	inventory_image = "default_jungleleaves.png",
	walkable = false,
	climbable = true,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	groups = {not_in_creative_inventory=1},
})

minetest.register_node("paragenv7:acacialeaf", {
	description = "Acacia Leaves",
	drawtype = "allfaces_optional",
	visual_scale = 1.3,
	tiles = {"paragenv7_acacialeaf.png"},
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy=3, leafdecay=4, flammable=2, leaves=1},
	sounds = default.node_sound_leaves_defaults(),
			drop = {
				max_items = 1,
				items = {
					{items = {"paragenv7:acaciasapling"}, rarity = 70 },
					{items = {"paragenv7:acacialeaf"} }
				}},
})

minetest.register_node("paragenv7:acaciatree", {
	description = "Acacia Tree",
	tiles = {"paragenv7_acaciatreetop.png", "paragenv7_acaciatreetop.png", "paragenv7_acaciatree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node
})

minetest.register_node("paragenv7:acaciawood", {
	description = "Acacia Wood Planks",
	tiles = {"paragenv7_acaciawood.png"},
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
	sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("paragenv7:needles", {
	description = "Pine Needles",
	tiles = {"paragenv7_needles.png"},
	is_ground_content = false,
	groups = {snappy=3, leafdecay=3},
	sounds = default.node_sound_leaves_defaults(),
			drop = {
				max_items = 1,
				items = {
					{items = {"paragenv7:pinesapling"}, rarity = 150 },
					{items = {"moretrees:pine_sapling"}, rarity = 25000 },
					{items = {"paragenv7:needles"} }
				}},
})

minetest.register_node("paragenv7:pinetree", {
	description = "Pine Tree",
	tiles = {"paragenv7_pinetreetop.png", "paragenv7_pinetreetop.png", "paragenv7_pinetree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
	on_place = minetest.rotate_node
})

minetest.register_node("paragenv7:pinewood", {
	description = "Pine Wood Planks",
	tiles = {"paragenv7_pinewood.png"},
	groups = {choppy=2,oddly_breakable_by_hand=2,flammable=3,wood=1},
	sounds = default.node_sound_wood_defaults(),
})

-- Crafting

minetest.register_craft({
	output = "paragenv7:acaciawood 4",
	recipe = {
		{"paragenv7:acaciatree"},
	}
})

minetest.register_craft({
	output = "paragenv7:pinewood 4",
	recipe = {
		{"paragenv7:pinetree"},
	}
})


minetest.register_craft({
	output = "paragenv7:permafrost",
	recipe = {
		{"default:snow", "default:snow", "default:snow"},
		{"default:snow", "default:dirt", "default:snow"},
		{"default:snow", "default:snow", "default:snow"}
	}
})


