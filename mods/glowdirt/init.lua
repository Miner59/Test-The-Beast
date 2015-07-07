glowdirt = {}
glowdirt.path = minetest.get_modpath("glowdirt")

glowdirt.uranium_hoe_on_use = function(itemstack, user, pointed_thing, uses)
	local pt = pointed_thing
	-- check if pointing at a node
	if not pt then
		return
	end
	if pt.type ~= "node" then
		return
	end
	
	local under = minetest.get_node(pt.under)
	local p = {x=pt.under.x, y=pt.under.y+1, z=pt.under.z}
	local above = minetest.get_node(p)
	
	-- return if any of the nodes is not registered
	if not minetest.registered_nodes[under.name] then
		return
	end
	if not minetest.registered_nodes[above.name] then
		return
	end
	
	-- check if the node above the pointed thing is air
	if above.name ~= "air" then
		return
	end
	
	-- check if pointing at soil
	if minetest.get_item_group(under.name, "soil") < 1 then
		return
	end
	
	-- check if (wet) soil defined
	local regN = minetest.registered_nodes
	if regN[under.name].soil == nil or regN[under.name].soil.dry2 == nil then
		return
	end

	
	-- turn the node into soil, wear out item and play sound
	minetest.set_node(pt.under, {name = regN[under.name].soil.dry2})
	minetest.sound_play("default_dig_crumbly", {
		pos = pt.under,
		gain = 0.5,
	})
	itemstack:add_wear(65535/(uses-1))
	return itemstack
end

minetest.register_node("glowdirt:mossygravel", {
	description = "Mossy Gravel",
	tiles = {"glowdirt_mossygravel.png"},
	is_ground_content = true,
	groups = {crumbly=2, falling_node=1},
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_gravel_footstep", gain=0.4},
		dug = {name="default_gravel_footstep", gain=1.0},
	}),
})

technic.register_grinder_recipe({input={"default:mossycobble"}, output="glowdirt:mossygravel 1"})

minetest.override_item("default:dirt", {
	groups = {crumbly=3,soil=1 },
	soil = {
		base = "default:dirt",
		dry = "farming:soil",
		wet = "farming:soil_wet",
		glow = "glowdirt:glowdirt",
		dry2 = "default:dirt",
	}

})

minetest.register_node("glowdirt:glowdirt", {
	description = "Glowdirt",
	tiles = {"default_dirt.png"},
	inventory_image = minetest.inventorycube("glowdirt_glowdirt.png","glowdirt_glowdirt.png","glowdirt_glowdirt.png"),
	wield_image = minetest.inventorycube("glowdirt_glowdirt.png","glowdirt_glowdirt.png","glowdirt_glowdirt.png"),
	drop = "glowdirt:glowdirt",
	is_ground_content = true,
	light_source = 14,
	groups = {crumbly=3,soil=1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "glowdirt:glowdirt",
		dry = "glowdirt:glowsoil_inactive",
		wet = "glowdirt:glowsoil_inactive_wet",
		glow = "glowdirt:glowdirt",
		dry2 = "glowdirt:glowsoil",
	}
})

minetest.register_node("glowdirt:glowsoil", {
	description = "Glowsoil",
	tiles = {"farming_soil.png","default_dirt.png"},
	drop = "glowdirt:glowdirt",
	is_ground_content = true,
	light_source = 14,
	groups = {crumbly=3, not_in_creative_inventory=1, soil=2, grassland = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "glowdirt:glowdirt",
		dry = "glowdirt:glowsoil",
		wet = "glowdirt:glowsoil_wet",
		glow = "glowdirt:glowdirt",
--		dry2 = "glowdirt:glowsoil",
	}
})

minetest.register_node("glowdirt:glowsoil_wet", {
	description = "Wet Glowsoil",
	tiles = {"farming_soil_wet.png","farming_soil_wet_side.png"},
	drop = "glowdirt:glowdirt_inactive",
	is_ground_content = true,
	light_source = 14,
	groups = {crumbly=3, not_in_creative_inventory=1, soil=3, wet = 1, grassland = 1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "glowdirt:glowdirt",
		dry = "glowdirt:glowsoil_inactive",
		wet = "glowdirt:glowsoil_wet",
		glow = "glowdirt:glowdirt",
--		dry2 = "glowdirt:glowsoil",
}
})

minetest.register_node("glowdirt:glowdirt_inactive", {
	description = "Radioactive Dirt",
	tiles = {"default_dirt.png"},
	inventory_image = minetest.inventorycube("glowdirt_glowdirt_inactive.png","glowdirt_glowdirt_inactive.png","glowdirt_glowdirt_inactive.png"),
	wield_image = minetest.inventorycube("glowdirt_glowdirt_inactive.png","glowdirt_glowdirt_inactive.png","glowdirt_glowdirt_inactive.png"),
	drop = "glowdirt:glowdirt_inactive",
	is_ground_content = true,
	light_source = 2,
	groups = {crumbly=3, not_in_creative_inventory=1, soil=1},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "glowdirt:glowdirt_inactive",
		dry = "glowdirt:glowsoil_inactive",
--		wet = "glowdirt:glowsoil_wet",
		glow = "glowdirt:glowdirt_inactive",
		dry2 = "glowdirt:glowsoil",
}
})

minetest.register_node("glowdirt:glowsoil_inactive", {
	description = "Radioactive Soil",
	tiles = {"farming_soil.png","default_dirt.png"},
	drop = "glowdirt:glowdirt_inactive",
	is_ground_content = true,
	light_source = 2,
	groups = {crumbly=3, not_in_creative_inventory=1, soil=2},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "glowdirt:glowdirt_inactive",
		dry = "glowdirt:glowsoil_inactive",
--		wet = "glowdirt:glowsoil_inactive_wet",
		glow = "glowdirt:glowdirt_inactive",
		dry2 = "glowdirt:glowsoil",
}
})

minetest.register_node("glowdirt:glowsoil_inactive_wet", {
	description = "Wet Radioactive Soil",
	tiles = {"farming_soil_wet.png","farming_soil_wet_side.png"},
	drop = "glowdirt:glowdirt_inactive",
	is_ground_content = true,
	light_source = 2,
	groups = {crumbly=3, not_in_creative_inventory=1, wet = 1, soil=3},
	sounds = default.node_sound_dirt_defaults(),
	soil = {
		base = "glowdirt:glowdirt_inactive",
		dry = "glowdirt:glowsoil_inactive",
		wet = "glowdirt:glowsoil_inactive_wet",
		glow = "glowdirt:glowdirt_inactive",
		dry2 = "glowdirt:glowsoil",

}
})


minetest.register_craft({
	output = 'glowdirt:glowdirt',
	recipe = {
		{'', 'technic:uranium', ''},
		{'technic:uranium', 'default:dirt', 'technic:uranium'},
		{'', 'glowdirt:mossygravel', ''},
	}
})

minetest.register_craftitem("glowdirt:uranium_hoe", {
	description = "Uranium Hoe",
	inventory_image = "glowdirt_tool_uraniumhoe.png",
})

minetest.register_tool("glowdirt:uranium_hoe", {
		description = "Uranium Hoe",
		inventory_image = "glowdirt_tool_uraniumhoe.png",
		on_use = function(itemstack, user, pointed_thing)
			return glowdirt.uranium_hoe_on_use(itemstack, user, pointed_thing, 110)
		end
	})
	
minetest.register_craft({
	output = 'glowdirt:uranium_hoe',
	recipe = {
		{'technic:uranium', 'technic:uranium', ''},
		{'', 'group:stick', ''},
		{'', 'group:stick', ''},
	}
})

minetest.register_craft( {
	type = "shapeless",
        output = "default:gravel",
        recipe = {
		"bucket:bucket_water",
		"glowdirt:mossygravel",
        },
	replacements = { {"bucket:bucket_water", "bucket:bucket_empty"}, },
})


