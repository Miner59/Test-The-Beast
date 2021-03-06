-- Plantlife library mod by Vanessa Ezekowitz
-- last revision, 2014-05-15
--
-- License:  WTFPL
--
-- I got the temperature map idea from "hmmmm", values used for it came from
-- Splizard's snow mod.
--

-- Various settings - most of these probably won't need to be changed

plantslib = {}

plantslib.modpath = minetest.get_modpath("plants_lib")
plantslib.intllib_modpath = minetest.get_modpath("intllib")

local S
if plantslib.intllib_modpath then
    dofile(plantslib.intllib_modpath.."/intllib.lua")
    S = intllib.Getter(minetest.get_current_modname())
else
    S = function ( s ) return s end
end

local DEBUG = false --... except if you want to spam the console with debugging info :-)

function plantslib:dbg(msg)
	if DEBUG then
		print("[Plantlife] "..msg)
		minetest.log("verbose", "[Plantlife] "..msg)
	end
end

plantslib.plantlife_seed_diff = 329	-- needs to be global so other mods can see it

local perlin_octaves = 3
local perlin_persistence = 0.6
local perlin_scale = 100

local temperature_seeddiff = 112
local temperature_octaves = 3
local temperature_persistence = 0.5
local temperature_scale = 150

local humidity_seeddiff = 9130
local humidity_octaves = 3
local humidity_persistence = 0.5
local humidity_scale = 250

local time_scale = 1
local time_speed = tonumber(minetest.setting_get("time_speed"))

if time_speed and time_speed > 0 then
	time_scale = 72 / time_speed
end

--PerlinNoise(seed, octaves, persistence, scale)

plantslib.perlin_temperature = PerlinNoise(temperature_seeddiff, temperature_octaves, temperature_persistence, temperature_scale)
plantslib.perlin_humidity = PerlinNoise(humidity_seeddiff, humidity_octaves, humidity_persistence, humidity_scale)

-- Local functions

function plantslib:is_node_loaded(node_pos)
	local n = minetest.get_node_or_nil(node_pos)
	if (not n) or (n.name == "ignore") then
		return false
	end
	return true
end

function plantslib:clone_node(name)
	node2={}
	node=minetest.registered_nodes[name]
	for k,v in pairs(node) do
		node2[k]=v
	end
	return node2
end

function plantslib:set_defaults(biome)
	biome.seed_diff = biome.seed_diff or 0
	biome.min_elevation = biome.min_elevation or -31000
	biome.max_elevation = biome.max_elevation or 31000
	biome.temp_min = biome.temp_min or 1
	biome.temp_max = biome.temp_max or -1
	biome.humidity_min = biome.humidity_min or 1
	biome.humidity_max = biome.humidity_max or -1
	biome.plantlife_limit = biome.plantlife_limit or 0.1
	biome.near_nodes_vertical = biome.near_nodes_vertical or 1

-- specific to on-generate

	biome.neighbors = biome.neighbors or biome.surface
	biome.near_nodes_size = biome.near_nodes_size or 0
	biome.near_nodes_count = biome.near_nodes_count or 1
	biome.rarity = biome.rarity or 50
	biome.max_count = biome.max_count or 5
	if biome.check_air ~= false then biome.check_air = true end

-- specific to abm spawner
	biome.seed_diff = biome.seed_diff or 0
	biome.light_min = biome.light_min or 0
	biome.light_max = biome.light_max or 15
	biome.depth_max = biome.depth_max or 1
	biome.facedir = biome.facedir or 0
end

-- Spawn plants using the map generator

function plantslib:register_generate_plant(biomedef, node_or_function_or_model)
	minetest.register_on_generated(plantslib:search_for_surfaces(minp, maxp, biomedef, node_or_function_or_model))
end

function plantslib:search_for_surfaces(minp, maxp, biomedef, node_or_function_or_model)
	return function(minp, maxp, blockseed)
		local biome = biomedef
		plantslib:set_defaults(biome)

		local searchnodes = minetest.find_nodes_in_area(minp, maxp, biome.surface)
		local in_biome_nodes = {}
		for _ , pos in ipairs(searchnodes) do
			local p_top = { x = pos.x, y = pos.y + 1, z = pos.z }
			local perlin1 = minetest.get_perlin(biome.seed_diff, perlin_octaves, perlin_persistence, perlin_scale)
			local noise1 = perlin1:get2d({x=p_top.x, y=p_top.z})
			local noise2 = plantslib.perlin_temperature:get2d({x=p_top.x, y=p_top.z})
			local noise3 = plantslib.perlin_humidity:get2d({x=p_top.x+150, y=p_top.z+50})
			if (not biome.depth or minetest.get_node({ x = pos.x, y = pos.y-biome.depth-1, z = pos.z }).name ~= biome.surface)
			  and (not biome.check_air or (biome.check_air and minetest.get_node(p_top).name == "air"))
			  and pos.y >= biome.min_elevation
			  and pos.y <= biome.max_elevation
			  and noise1 > biome.plantlife_limit
			  and noise2 <= biome.temp_min
			  and noise2 >= biome.temp_max
			  and noise3 <= biome.humidity_min
			  and noise3 >= biome.humidity_max
			  and (not biome.ncount or #(minetest.find_nodes_in_area({x=pos.x-1, y=pos.y, z=pos.z-1}, {x=pos.x+1, y=pos.y, z=pos.z+1}, biome.neighbors)) > biome.ncount)
			  and (not biome.near_nodes or #(minetest.find_nodes_in_area({x=pos.x-biome.near_nodes_size, y=pos.y-biome.near_nodes_vertical, z=pos.z-biome.near_nodes_size}, {x=pos.x+biome.near_nodes_size, y=pos.y+biome.near_nodes_vertical, z=pos.z+biome.near_nodes_size}, biome.near_nodes)) >= biome.near_nodes_count)
			  and math.random(1,100) > biome.rarity
			  and (not biome.below_nodes or string.find(dump(biome.below_nodes), minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name) )
			  then
				table.insert(in_biome_nodes, pos)
			end
		end

		local num_in_biome_nodes = #in_biome_nodes

		if num_in_biome_nodes > 0 then
			for i = 1, math.min(biome.max_count, num_in_biome_nodes) do
				local tries = 0
				local spawned = false
				while tries < 2 and not spawned do
					local pos = in_biome_nodes[math.random(1, num_in_biome_nodes)]
					if biome.spawn_replace_node then
						pos.y = pos.y-1
					end
					local p_top = { x = pos.x, y = pos.y + 1, z = pos.z }

					if not (biome.avoid_nodes and biome.avoid_radius and minetest.find_node_near(p_top, biome.avoid_radius + math.random(-1.5,2), biome.avoid_nodes)) then
						if biome.delete_above then
							minetest.remove_node(p_top)
							minetest.remove_node({x=p_top.x, y=p_top.y+1, z=p_top.z})
						end

						if biome.delete_above_surround then
							minetest.remove_node({x=p_top.x-1, y=p_top.y, z=p_top.z})
							minetest.remove_node({x=p_top.x+1, y=p_top.y, z=p_top.z})
							minetest.remove_node({x=p_top.x,   y=p_top.y, z=p_top.z-1})
							minetest.remove_node({x=p_top.x,   y=p_top.y, z=p_top.z+1})

							minetest.remove_node({x=p_top.x-1, y=p_top.y+1, z=p_top.z})
							minetest.remove_node({x=p_top.x+1, y=p_top.y+1, z=p_top.z})
							minetest.remove_node({x=p_top.x,   y=p_top.y+1, z=p_top.z-1})
							minetest.remove_node({x=p_top.x,   y=p_top.y+1, z=p_top.z+1})
						end

						if biome.spawn_replace_node then
							minetest.remove_node(pos)
						end

						local objtype = type(node_or_function_or_model)

						if objtype == "table" then
							plantslib:generate_tree(pos, node_or_function_or_model)
							spawned = true
						elseif objtype == "string" and
							minetest.registered_nodes[node_or_function_or_model] then
							minetest.add_node(p_top, { name = node_or_function_or_model })
							spawned = true
						elseif objtype == "function" then
							node_or_function_or_model(pos)
							spawned = trueload
						elseif objtype == "string" and pcall(loadstring(("return %s(...)"):
							format(node_or_function_or_model)),pos) then
							spawned = true
						else
							print("Ignored invalid definition for object "..dump(node_or_function_or_model).." that was pointed at {"..dump(pos).."}")
						end
					else
						tries = tries + 1
					end
				end
			end
		end
	end
end

-- The spawning ABM

function plantslib:spawn_on_surfaces(sd,sp,sr,sc,ss,sa)

	local biome = {}

	if type(sd) ~= "table" then
		biome.spawn_delay = sd	-- old api expects ABM interval param here.
		biome.spawn_plants = {sp}
		biome.avoid_radius = sr
		biome.spawn_chance = sc
		biome.spawn_surfaces = {ss}
		biome.avoid_nodes = sa
	else
		biome = sd
	end

	if biome.spawn_delay*time_scale >= 1 then
		biome.interval = biome.spawn_delay*time_scale
	else
		biome.interval = 1
	end

	plantslib:set_defaults(biome)
	biome.spawn_plants_count = #(biome.spawn_plants)

	minetest.register_abm({
		nodenames = biome.spawn_surfaces,
		interval = biome.interval,
		chance = biome.spawn_chance,
		neighbors = biome.neighbors,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local p_top = { x = pos.x, y = pos.y + 1, z = pos.z }	
			local n_top = minetest.get_node(p_top)
			local perlin1 = minetest.get_perlin(biome.seed_diff, perlin_octaves, perlin_persistence, perlin_scale)
			local noise1 = perlin1:get2d({x=p_top.x, y=p_top.z})
			local noise2 = plantslib.perlin_temperature:get2d({x=p_top.x, y=p_top.z})
			local noise3 = plantslib.perlin_humidity:get2d({x=p_top.x+150, y=p_top.z+50})
			if noise1 > biome.plantlife_limit 
			  and noise2 <= biome.temp_min
			  and noise2 >= biome.temp_max
			  and noise3 <= biome.humidity_min
			  and noise3 >= biome.humidity_max
			  and plantslib:is_node_loaded(p_top) then
				local n_light = minetest.get_node_light(p_top, nil)
				if not (biome.avoid_nodes and biome.avoid_radius and minetest.find_node_near(p_top, biome.avoid_radius + math.random(-1.5,2), biome.avoid_nodes))
				  and n_light >= biome.light_min
				  and n_light <= biome.light_max
				  and (not(biome.neighbors and biome.ncount) or #(minetest.find_nodes_in_area({x=pos.x-1, y=pos.y, z=pos.z-1}, {x=pos.x+1, y=pos.y, z=pos.z+1}, biome.neighbors)) > biome.ncount )
				  and (not(biome.near_nodes and biome.near_nodes_count and biome.near_nodes_size) or #(minetest.find_nodes_in_area({x=pos.x-biome.near_nodes_size, y=pos.y-biome.near_nodes_vertical, z=pos.z-biome.near_nodes_size}, {x=pos.x+biome.near_nodes_size, y=pos.y+biome.near_nodes_vertical, z=pos.z+biome.near_nodes_size}, biome.near_nodes)) >= biome.near_nodes_count)
				  and (not(biome.air_count and biome.air_size) or #(minetest.find_nodes_in_area({x=p_top.x-biome.air_size, y=p_top.y, z=p_top.z-biome.air_size}, {x=p_top.x+biome.air_size, y=p_top.y, z=p_top.z+biome.air_size}, "air")) >= biome.air_count)
				  and pos.y >= biome.min_elevation
				  and pos.y <= biome.max_elevation
				  then
					local walldir = plantslib:find_adjacent_wall(p_top, biome.verticals_list)
					if biome.alt_wallnode and walldir then
						if n_top.name == "air" then
							minetest.add_node(p_top, { name = biome.alt_wallnode, param2 = walldir })
						end
					else
						local currentsurface = minetest.get_node(pos).name
						if currentsurface ~= "default:water_source"
						  or (currentsurface == "default:water_source" and #(minetest.find_nodes_in_area({x=pos.x, y=pos.y-biome.depth_max-1, z=pos.z}, {x=pos.x, y=pos.y, z=pos.z}, {"default:dirt", "default:dirt_with_grass", "default:sand"})) > 0 )
						  then
							local rnd = math.random(1, biome.spawn_plants_count)
							local plant_to_spawn = biome.spawn_plants[rnd]
							local fdir = biome.facedir
							if biome.random_facedir then
								fdir = math.random(biome.random_facedir[1],biome.random_facedir[2])
							end
							if type(spawn_plants) == "string" then
								assert(loadstring(spawn_plants.."(...)"))(pos)
							elseif not biome.spawn_on_side and not biome.spawn_on_bottom and not biome.spawn_replace_node then
								if n_top.name == "air" then
									minetest.add_node(p_top, { name = plant_to_spawn, param2 = fdir })
								end
							elseif biome.spawn_replace_node then
								minetest.add_node(pos, { name = plant_to_spawn, param2 = fdir })

							elseif biome.spawn_on_side then
								local onside = plantslib:find_open_side(pos)
								if onside then 
									minetest.add_node(onside.newpos, { name = plant_to_spawn, param2 = onside.facedir })
								end
							elseif biome.spawn_on_bottom then
								if minetest.get_node({x=pos.x, y=pos.y-1, z=pos.z}).name == "air" then
									minetest.add_node({x=pos.x, y=pos.y-1, z=pos.z}, { name = plant_to_spawn, param2 = fdir} )
								end
							end
						end
					end
				end
			end
		end
	})
end

-- The growing ABM

function plantslib:grow_plants(opts)

	local options = opts

	options.height_limit = options.height_limit or 5
	options.ground_nodes = options.ground_nodes or { "default:dirt_with_grass" }
	options.grow_nodes = options.grow_nodes or { "default:dirt_with_grass" }
	options.seed_diff = options.seed_diff or 0

	if options.grow_delay*time_scale >= 1 then
		options.interval = options.grow_delay*time_scale
	else
		options.interval = 1
	end

	minetest.register_abm({
		nodenames = { options.grow_plant },
		interval = options.interval,
		chance = options.grow_chance,
		action = function(pos, node, active_object_count, active_object_count_wider)
			local p_top = {x=pos.x, y=pos.y+1, z=pos.z}
			local p_bot = {x=pos.x, y=pos.y-1, z=pos.z}
			local n_top = minetest.get_node(p_top)
			local n_bot = minetest.get_node(p_bot)
			local root_node = minetest.get_node({x=pos.x, y=pos.y-options.height_limit, z=pos.z})
			local walldir = nil
			if options.need_wall and options.verticals_list then
				walldir = plantslib:find_adjacent_wall(p_top, options.verticals_list)
			end
			if n_top.name == "air" and (not options.need_wall or (options.need_wall and walldir))
			  then
				-- corner case for changing short junglegrass
				-- to dry shrub in desert
				if n_bot.name == options.dry_early_node and options.grow_plant == "junglegrass:short" then
					minetest.add_node(pos, { name = "default:dry_shrub" })

				elseif options.grow_vertically and walldir then
					if plantslib:search_downward(pos, options.height_limit, options.ground_nodes) then
						minetest.add_node(p_top, { name = options.grow_plant, param2 = walldir})
					end

				elseif not options.grow_result and not options.grow_function then
					minetest.remove_node(pos)

				else
					plantslib:replace_object(pos, options.grow_result, options.grow_function, options.facedir, options.seed_diff)
				end
			end
		end
	})
end

-- Function to decide how to replace a plant - either grow it, replace it with
-- a tree, run a function, or die with an error.

function plantslib:replace_object(pos, replacement, grow_function, walldir, seeddiff)
	local growtype = type(grow_function)
	if growtype == "table" then
		minetest.remove_node(pos)
		plantslib:grow_tree(pos, grow_function)
		return
	elseif growtype == "function" then
		local perlin1 = minetest.get_perlin(seeddiff, perlin_octaves, perlin_persistence, perlin_scale)
		local noise1 = perlin1:get2d({x=pos.x, y=pos.z})
		local noise2 = plantslib.perlin_temperature:get2d({x=pos.x, y=pos.z})
		grow_function(pos,noise1,noise2,walldir)
		return
	elseif growtype == "string" then
		local perlin1 = minetest.get_perlin(seeddiff, perlin_octaves, perlin_persistence, perlin_scale)
		local noise1 = perlin1:get2d({x=pos.x, y=pos.z})
		local noise2 = plantslib.perlin_temperature:get2d({x=pos.x, y=pos.z})
		assert(loadstring(grow_function.."(...)"))(pos,noise1,noise2,walldir)
		return
	elseif growtype == "nil" then
		minetest.add_node(pos, { name = replacement, param2 = walldir})
		return
	elseif growtype ~= "nil" and growtype ~= "string" and growtype ~= "table" then
		error("Invalid grow function "..dump(grow_function).." used on object at ("..dump(pos)..")")
	end
end

-- function to decide if a node has a wall that's in verticals_list{}
-- returns wall direction of valid node, or nil if invalid.

function plantslib:find_adjacent_wall(pos, verticals)
	local verts = dump(verticals)
	if string.find(verts, minetest.get_node({ x=pos.x-1, y=pos.y, z=pos.z   }).name) then return 3 end
	if string.find(verts, minetest.get_node({ x=pos.x+1, y=pos.y, z=pos.z   }).name) then return 2 end
	if string.find(verts, minetest.get_node({ x=pos.x  , y=pos.y, z=pos.z-1 }).name) then return 5 end
	if string.find(verts, minetest.get_node({ x=pos.x  , y=pos.y, z=pos.z+1 }).name) then return 4 end
	return nil
end

-- Function to search downward from the given position, looking for the first
-- node that matches the ground table.  Returns the new position, or nil if
-- height limit is exceeded before finding it.

function plantslib:search_downward(pos, heightlimit, ground)
	for i = 0, heightlimit do
		if string.find(dump(ground), minetest.get_node({x=pos.x, y=pos.y-i, z = pos.z}).name) then
			return {x=pos.x, y=pos.y-i, z = pos.z}
		end
	end
	return false
end

function plantslib:find_open_side(pos)
	if minetest.get_node({ x=pos.x-1, y=pos.y, z=pos.z }).name == "air" then
		return {newpos = { x=pos.x-1, y=pos.y, z=pos.z }, facedir = 2}
	end
	if minetest.get_node({ x=pos.x+1, y=pos.y, z=pos.z }).name == "air" then
		return {newpos = { x=pos.x+1, y=pos.y, z=pos.z }, facedir = 3}
	end
	if minetest.get_node({ x=pos.x, y=pos.y, z=pos.z-1 }).name == "air" then
		return {newpos = { x=pos.x, y=pos.y, z=pos.z-1 }, facedir = 4}
	end
	if minetest.get_node({ x=pos.x, y=pos.y, z=pos.z+1 }).name == "air" then
		return {newpos = { x=pos.x, y=pos.y, z=pos.z+1 }, facedir = 5}
	end
	return nil
end

-- spawn_tree() on generate is routed through here so that other mods can hook
-- into it.

function plantslib:generate_tree(pos, node_or_function_or_model)
	minetest.spawn_tree(pos, node_or_function_or_model)
end

-- and this one's for the call used in the growing code

function plantslib:grow_tree(pos, node_or_function_or_model)
	minetest.spawn_tree(pos, node_or_function_or_model)
end

-- check if a node is owned before allowing manual placement of a node
-- (used by flowers_plus)

function plantslib:node_is_owned(pos, placer)
	local ownername = false
	if type(IsPlayerNodeOwner) == "function" then					-- node_ownership mod
		if HasOwner(pos, placer) then						-- returns true if the node is owned
			if not IsPlayerNodeOwner(pos, placer:get_player_name()) then
				if type(getLastOwner) == "function" then		-- ...is an old version
					ownername = getLastOwner(pos)
				elseif type(GetNodeOwnerName) == "function" then	-- ...is a recent version
					ownername = GetNodeOwnerName(pos)
				else
					ownername = S("someone")
				end
			end
		end

	elseif type(isprotect)=="function" then 					-- glomie's protection mod
		if not isprotect(5, pos, placer) then
			ownername = S("someone")
		end
	elseif type(protector)=="table" and type(protector.can_dig)=="function" then 	-- Zeg9's protection mod
		if not protector.can_dig(5, pos, placer) then
			ownername = S("someone")
		end
	end

	if ownername ~= false then
		minetest.chat_send_player( placer:get_player_name(), S("Sorry, %s owns that spot."):format(ownername) )
		return true
	else
		return false
	end
end

-- Check for infinite stacks

if minetest.get_modpath("unified_inventory") or not minetest.setting_getbool("creative_mode") then
	plantslib.expect_infinite_stacks = false
else
	plantslib.expect_infinite_stacks = true
end

-- read a field from a node's definition

function plantslib:get_nodedef_field(nodename, fieldname)
	if not minetest.registered_nodes[nodename] then
		return nil
	end
	return minetest.registered_nodes[nodename][fieldname]
end


print(S("[Plantlife Library] Loaded"))
