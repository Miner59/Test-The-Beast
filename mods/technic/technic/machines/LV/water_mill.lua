-- A water mill produces LV EUs by exploiting flowing water across it
-- It is a LV EU supplyer and fairly low yield (max 120EUs)
-- It is a little under half as good as the thermal generator.

local S = technic.getter

minetest.register_alias("water_mill", "technic:water_mill")

minetest.register_craft({
	output = 'technic:water_mill',
	recipe = {
		{'default:stone', 'default:stone',        'default:stone'},
		{'group:wood',    'default:diamond',      'group:wood'},
		{'default:stone', 'default:copper_ingot', 'default:stone'},
	}
})

minetest.register_node("technic:water_mill", {
	description = S("Water Mill"),
	tiles = {"technic_water_mill_top.png",  "technic_machine_bottom.png",
	         "technic_water_mill_side.png", "technic_water_mill_side.png",
	         "technic_water_mill_side.png", "technic_water_mill_side.png"},
	paramtype2 = "facedir",
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", S("Water Mill"))
		meta:set_int("LV_EU_supply", 0)
	end,	
})

minetest.register_node("technic:water_mill_active", {
	description = S("Water Mill"),
	tiles = {"technic_water_mill_top_active.png", "technic_machine_bottom.png",
	         "technic_water_mill_side.png",       "technic_water_mill_side.png",
	         "technic_water_mill_side.png",       "technic_water_mill_side.png"},
	paramtype2 = "facedir",
	groups = {snappy=2, choppy=2, oddly_breakable_by_hand=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	drop = "technic:water_mill",
})

local function check_node_around_mill(pos)
	local node = minetest.get_node(pos)
	if node.name == "default:water_flowing" then
		return true
	end
	return false
end

minetest.register_abm({
	nodenames = {"technic:water_mill", "technic:water_mill_active"},
	interval = 1,
	chance   = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta             = minetest.get_meta(pos)
		local water_nodes      = 0
		local lava_nodes       = 0
		local production_level = 0
		local eu_supply        = 0

		local positions = {
			{x=pos.x+1, y=pos.y, z=pos.z},
			{x=pos.x-1, y=pos.y, z=pos.z},
			{x=pos.x,   y=pos.y, z=pos.z+1},
			{x=pos.x,   y=pos.y, z=pos.z-1},
		}

		for _, p in pairs(positions) do
			local check = check_node_around_mill(p)
			if check then
				water_nodes = water_nodes + 1
			end
		end
local deep=0
local sgn=1
if pos.x+pos.z<0 then sgn=-1 end
		for ji=1,10,1 do
	if minetest.get_node({x=pos.x+sgn, y=pos.y-ji, z=pos.z}).name == "default:water_source" then
	deep=deep+5
	elseif minetest.get_node({x=pos.x+sgn, y=pos.y-ji, z=pos.z}).name.name == "default:water_flowing" then
	deep=deep+8
	elseif minetest.get_node({x=pos.x, y=pos.y-ji, z=pos.z+sgn}).name == "default:water_source" then
	deep=deep+5
	elseif minetest.get_node({x=pos.x, y=pos.y-ji, z=pos.z+sgn}).name.name == "default:water_flowing" then
	deep=deep+8
	else
	break
	end
		end

		if water_nodes==3 then
		  water_nodes=4
		elseif water_nodes==4 then
	  	  water_nodes=2
		end
		production_level = 25 * water_nodes
		eu_supply = 20 * water_nodes+deep

		if production_level > 0 then
			meta:set_int("LV_EU_supply", eu_supply)
		end

		meta:set_string("infotext",
			S("Water Mill").." ("..production_level.."%)")

		if production_level > 0 and
		   minetest.get_node(pos).name == "technic:water_mill" then
			technic.swap_node (pos, "technic:water_mill_active")
			meta:set_int("LV_EU_supply", 0)
			return
		end
		if production_level == 0 then
			technic.swap_node(pos, "technic:water_mill")
		end
	end
}) 

technic.register_machine("LV", "technic:water_mill",        technic.producer)
technic.register_machine("LV", "technic:water_mill_active", technic.producer)

