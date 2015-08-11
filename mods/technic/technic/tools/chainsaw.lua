local chainsaw_max_charge      = 30000 -- Maximum charge of the saw
-- Gives 2500 nodes on a single charge (about 50 complete normal trees)
local chainsaw_charge_per_node = 12
-- Cut down tree leaves.  Leaf decay may cause slowness on large trees
-- if this is disabled.
local chainsaw_leaves = true
local chainsaw_all_leaves = false

-- The default trees
local selected_nodes={}
local timber_nodenames = {
	["default:jungletree"] = true,
	["default:papyrus"]    = true,
	["default:cactus"]     = true,
	["default:tree"]       = true,
	["default:apple"]      = true,
}

if chainsaw_leaves then
	timber_nodenames["default:leaves"] = true
	timber_nodenames["default:jungleleaves"] = true
end

-- technic_worldgen defines rubber trees if moretrees isn't installed
if minetest.get_modpath("technic_worldgen") or
		minetest.get_modpath("moretrees") then
	timber_nodenames["moretrees:rubber_tree_trunk_empty"] = true
	timber_nodenames["moretrees:rubber_tree_trunk"]       = true
	if chainsaw_leaves then
		timber_nodenames["moretrees:rubber_tree_leaves"] = true
	end
end

-- Support moretrees if it is there
if minetest.get_modpath("moretrees") then
	timber_nodenames["moretrees:apple_tree_trunk"]                 = true
	timber_nodenames["moretrees:apple_tree_trunk_sideways"]        = true
	timber_nodenames["moretrees:beech_trunk"]                      = true
	timber_nodenames["moretrees:beech_trunk_sideways"]             = true
	timber_nodenames["moretrees:birch_trunk"]                      = true
	timber_nodenames["moretrees:birch_trunk_sideways"]             = true
	timber_nodenames["moretrees:fir_trunk"]                        = true
	timber_nodenames["moretrees:fir_trunk_sideways"]               = true
	timber_nodenames["moretrees:oak_trunk"]                        = true
	timber_nodenames["moretrees:oak_trunk_sideways"]               = true
	timber_nodenames["moretrees:palm_trunk"]                       = true
	timber_nodenames["moretrees:palm_trunk_sideways"]              = true
	timber_nodenames["moretrees:pine_trunk"]                       = true
	timber_nodenames["moretrees:pine_trunk_sideways"]              = true
	timber_nodenames["moretrees:rubber_tree_trunk_sideways"]       = true
	timber_nodenames["moretrees:rubber_tree_trunk_sideways_empty"] = true
	timber_nodenames["moretrees:sequoia_trunk"]                    = true
	timber_nodenames["moretrees:sequoia_trunk_sideways"]           = true
	timber_nodenames["moretrees:spruce_trunk"]                     = true
	timber_nodenames["moretrees:spruce_trunk_sideways"]            = true
	timber_nodenames["moretrees:willow_trunk"]                     = true
	timber_nodenames["moretrees:willow_trunk_sideways"]            = true
	timber_nodenames["moretrees:jungletree_trunk"]                 = true
	timber_nodenames["moretrees:jungletree_trunk_sideways"]        = true

	if chainsaw_leaves then
		timber_nodenames["moretrees:apple_tree_leaves"]        = true
		timber_nodenames["moretrees:oak_leaves"]               = true
		timber_nodenames["moretrees:fir_leaves"]               = true
		timber_nodenames["moretrees:fir_leaves_bright"]        = true
		timber_nodenames["moretrees:sequoia_leaves"]           = true
		timber_nodenames["moretrees:beech_leaves"]             = true
		timber_nodenames["moretrees:birch_leaves"]             = true
		timber_nodenames["moretrees:palm_leaves"]              = true
		timber_nodenames["moretrees:spruce_leaves"]            = true
		timber_nodenames["moretrees:pine_leaves"]              = true
		timber_nodenames["moretrees:willow_leaves"]            = true
		timber_nodenames["moretrees:jungletree_leaves_green"]  = true
		timber_nodenames["moretrees:jungletree_leaves_yellow"] = true
		timber_nodenames["moretrees:jungletree_leaves_red"]    = true
--cut this fruits down too
		timber_nodenames["moretrees:acorn"]  		       = true
		timber_nodenames["moretrees:coconut"]                  = true
		timber_nodenames["moretrees:pine_cone"]                = true
		timber_nodenames["moretrees:fir_cone"]                 = true
		timber_nodenames["moretrees:spruce_cone"]              = true


	end
end

-- Support growing_trees
if minetest.get_modpath("growing_trees") then
	timber_nodenames["growing_trees:trunk"]         = true
	timber_nodenames["growing_trees:medium_trunk"]  = true
	timber_nodenames["growing_trees:big_trunk"]     = true
	timber_nodenames["growing_trees:trunk_top"]     = true
	timber_nodenames["growing_trees:trunk_sprout"]  = true
	timber_nodenames["growing_trees:branch_sprout"] = true
	timber_nodenames["growing_trees:branch"]        = true
	timber_nodenames["growing_trees:branch_xmzm"]   = true
	timber_nodenames["growing_trees:branch_xpzm"]   = true
	timber_nodenames["growing_trees:branch_xmzp"]   = true
	timber_nodenames["growing_trees:branch_xpzp"]   = true
	timber_nodenames["growing_trees:branch_zz"]     = true
	timber_nodenames["growing_trees:branch_xx"]     = true

	if chainsaw_leaves then
		timber_nodenames["growing_trees:leaves"] = true
	end
end

--Support paragenv7
if minetest.get_modpath("paragenv7") then
	timber_nodenames["paragenv7:acaciatree"] 	= true
	timber_nodenames["paragenv7:pinetree"] 		= true
	timber_nodenames["paragenv7:cactus"] 		= true

	if chainsaw_leaves then
		timber_nodenames["paragenv7:acacialeaf"]= true
		timber_nodenames["paragenv7:appleleaf"] = true
		timber_nodenames["paragenv7:jungleleaf"]= true
		timber_nodenames["paragenv7:needles"] 	= true
	end
end

-- Support growing_cactus
if minetest.get_modpath("growing_cactus") then
	timber_nodenames["growing_cactus:sprout"]                       = true
	timber_nodenames["growing_cactus:branch_sprout_vertical"]       = true
	timber_nodenames["growing_cactus:branch_sprout_vertical_fixed"] = true
	timber_nodenames["growing_cactus:branch_sprout_xp"]             = true
	timber_nodenames["growing_cactus:branch_sprout_xm"]             = true
	timber_nodenames["growing_cactus:branch_sprout_zp"]             = true
	timber_nodenames["growing_cactus:branch_sprout_zm"]             = true
	timber_nodenames["growing_cactus:trunk"]                        = true
	timber_nodenames["growing_cactus:branch_trunk"]                 = true
	timber_nodenames["growing_cactus:branch"]                       = true
	timber_nodenames["growing_cactus:branch_xp"]                    = true
	timber_nodenames["growing_cactus:branch_xm"]                    = true
	timber_nodenames["growing_cactus:branch_zp"]                    = true
	timber_nodenames["growing_cactus:branch_zm"]                    = true
	timber_nodenames["growing_cactus:branch_zz"]                    = true
	timber_nodenames["growing_cactus:branch_xx"]                    = true
end

-- Support farming_plus
if minetest.get_modpath("farming_plus") then
	if chainsaw_leaves then
		timber_nodenames["farming_plus:cocoa_leaves"] = true
	end
end


local S = technic.getter

technic.register_power_tool("technic:chainsaw", chainsaw_max_charge)

-- Table for saving what was sawed down
local produced = {}
local sapling=""

-- Save the items sawed down so that we can drop them in a nice single stack
local function handle_drops(drops,plant)
	for _, item in ipairs(drops) do
		local stack = ItemStack(item)
		local name = stack:get_name()
		if plant then
		if minetest.get_item_group(name, "sapling")>0 then
			sapling=name
			return
		end
		end
--dont give snow stacks, just remove snow from sky
		if name~="default:snowblock" and name~="default:snow" then 
--give only a few leaves
			if chainsaw_all_leaves or (math.random(0, 50)>48 or (
name~="default:leaves" 
and
name~="default:jungleleaves"
and
name~="moretrees:rubber_tree_leaves"
and
name~="moretrees:apple_tree_leaves"
and
name~="moretrees:oak_leaves"
and
name~="moretrees:fir_leaves"
and
name~="moretrees:fir_leaves_bright"
and
name~="moretrees:sequoia_leaves"
and
name~="moretrees:birch_leaves"
and
name~="moretrees:birch_leaves"
and
name~="moretrees:palm_leaves"
and
name~="moretrees:spruce_leaves"
and
name~="moretrees:spruce_leaves"
and
name~="moretrees:pine_leaves"
and
name~="moretrees:willow_leaves"
and
name~="moretrees:jungletree_leaves_green"
and
name~="moretrees:jungletree_leaves_yellow"
and
name~="moretrees:jungletree_leaves_red"
and
name~="moretrees:acorn"
and
name~="moretrees:coconut"
and
name~="moretrees:pine_cone"
and
name~="moretrees:fir_cone"
and
name~="moretrees:spruce_cone"
and
name~="paragenv7:acacialeaf"
and
name~="paragenv7:appleleaf"
and
name~="paragenv7:jungleleaf"
and
name~="paragenv7:needles"

)) then

		local p = produced[name]
		if not p then
			produced[name] = stack
		else
			p:set_count(p:get_count() + stack:get_count())
		end
		end
end
	end
end

--- Iterator over positions to try to saw around a sawed node.
-- This returns positions in a 3x1x3 area around the position, plus the
-- position above it.  This does not return the bottom position to prevent
-- the chainsaw from cutting down nodes below the cutting position.
-- @param pos Sawing position.
local function iterSawTries(pos)
	-- Copy position to prevent mangling it
	local pos = vector.new(pos)
	local i = 0

	return function()
		i = i + 1
		-- Given a (top view) area like so (where 5 is the starting position):
		-- X -->
		-- Z 123
		-- | 456
		-- V 789
		-- This will return positions 1, 4, 7, 2, 8 (skip 5), 3, 6, 9,
		-- and the position above 5.
		if i == 1 then
			-- Move to starting position
			pos.x = pos.x - 1
			pos.z = pos.z - 1
		elseif i == 4 or i == 7 then
			-- Move to next X and back to start of Z when we reach
			-- the end of a Z line.
			pos.x = pos.x + 1
			pos.z = pos.z - 2
		elseif i == 5 then
			-- Skip the middle position (we've already run on it)
			-- and double-increment the counter.
			pos.z = pos.z + 2
			i = i + 1
		elseif i <= 9 then
			-- Go to next Z.
			pos.z = pos.z + 1
		elseif i == 10 then
			-- Move back to center and up.
			-- The Y+ position must be last so that we don't dig
			-- straight upward and not come down (since the Y-
			-- position isn't checked).
			pos.x = pos.x - 1
			pos.z = pos.z - 1
			pos.y = pos.y + 1
		else
			return nil
		end
		return pos
	end
end

-- This function does all the hard work. Recursively we dig the node at hand
-- if it is in the table and then search the surroundings for more stuff to dig.
local function recursive_dig(pos, remaining_charge,sneak,plant)
	if remaining_charge < chainsaw_charge_per_node then
		return remaining_charge
	end
	local node = minetest.get_node(pos)

if sneak then
	if not selected_nodes[node.name] then
		return remaining_charge
	end
else
	if not timber_nodenames[node.name] then
		return remaining_charge
	end
end
--remove snow too for snowy trees
	if node.name=="default:snow" or node.name=="default:snowblock" then
		local bnode = minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z})
		if (bnode.name~="paragenv7:needles" and bnode.name~="paragenv7:pinetree" and bnode.name~="air") then
		return remaining_charge
		end
	end
	if chainsaw_leaves and (node.name=="paragenv7:needles" or node.name=="paragenv7:pinetree") then
		timber_nodenames["default:snowblock"]        = true
		timber_nodenames["default:snow"]             = true
	end
	if plant and sapling~="" then
		plant=false
	end

	-- Wood found - cut it
	handle_drops(minetest.get_node_drops(node.name, ""),plant)
	minetest.remove_node(pos)
	remaining_charge = remaining_charge - chainsaw_charge_per_node

	-- Check surroundings and run recursively if any charge left
	for npos in iterSawTries(pos) do
		if remaining_charge < chainsaw_charge_per_node then
			break
		end
if sneak then
		if selected_nodes[minetest.get_node(npos).name] then
			remaining_charge = recursive_dig(npos, remaining_charge,sneak,plant)
		end

else
		if timber_nodenames[minetest.get_node(npos).name] then
			remaining_charge = recursive_dig(npos, remaining_charge,sneak,plant)
		end
	end
end
	return remaining_charge
end

-- Function to randomize positions for new node drops
local function get_drop_pos(pos)
	local drop_pos = {}

	for i = 0, 8 do
		-- Randomize position for a new drop
		drop_pos.x = pos.x + math.random(-3, 3)
		drop_pos.y = pos.y - 1
		drop_pos.z = pos.z + math.random(-3, 3)

		-- Move the randomized position upwards until
		-- the node is air or unloaded.
		for y = drop_pos.y, drop_pos.y + 5 do
			drop_pos.y = y
			local node = minetest.get_node_or_nil(drop_pos)

			if not node then
				-- If the node is not loaded yet simply drop
				-- the item at the original digging position.
				return pos
			elseif node.name == "air" then
				-- Add variation to the entity drop position,
				-- but don't let drops get too close to the edge
				drop_pos.x = drop_pos.x + (math.random() * 0.8) - 0.5
				drop_pos.z = drop_pos.z + (math.random() * 0.8) - 0.5
				return drop_pos
			end
		end
	end

	-- Return the original position if this takes too long
	return pos
end

-- Chainsaw entry point
local function chainsaw_dig(pos, current_charge,sneak)
	-- Start sawing things down

	local remaining_charge=current_charge
	local plant=false
	if current_charge~=50000 then
		minetest.sound_play("chainsaw", {pos = pos, gain = 1.0,
			max_hear_distance = 10})
	else
		local under=minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name
		if under=="default:dirt" or under=="paragenv7:drygrass" or under=="paragenv7:grass" or under=="paragenv7:permafrost" or under=="paragenv7:dirt" or under=="default:dirt_with_grass" or under=="default:sand" or under=="default:desert_sand" or under=="default:snowblock" or under=="default:dirt_with_snow" then
			plant=true 
		else
			local nt=0
			under=minetest.get_node({x=pos.x-1,y=pos.y-1,z=pos.z}).name
		if not (under=="default:dirt" or under=="paragenv7:drygrass" or under=="paragenv7:grass" or under=="paragenv7:permafrost" or under=="paragenv7:dirt" or under=="default:dirt_with_grass" or under=="default:sand" or under=="default:desert_sand" or under=="default:snowblock" or under=="default:dirt_with_snow") then
				nt=nt+1
			end
			under=minetest.get_node({x=pos.x+1,y=pos.y-1,z=pos.z}).name
		if not (under=="default:dirt" or under=="paragenv7:drygrass" or under=="paragenv7:grass" or under=="paragenv7:permafrost" or under=="paragenv7:dirt" or under=="default:dirt_with_grass" or under=="default:sand" or under=="default:desert_sand" or under=="default:snowblock" or under=="default:dirt_with_snow") then
				nt=nt+1
			end
			under=minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z-1}).name
		if not (under=="default:dirt" or under=="paragenv7:drygrass" or under=="paragenv7:grass" or under=="paragenv7:permafrost" or under=="paragenv7:dirt" or under=="default:dirt_with_grass" or under=="default:sand" or under=="default:desert_sand" or under=="default:snowblock" or under=="default:dirt_with_snow") then
				nt=nt+1
			end

			under=minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z+1}).name
		if not (under=="default:dirt" or under=="paragenv7:drygrass" or under=="paragenv7:grass" or under=="paragenv7:permafrost" or under=="paragenv7:dirt" or under=="default:dirt_with_grass" or under=="default:sand" or under=="default:desert_sand" or under=="default:snowblock" or under=="default:dirt_with_snow") then
				nt=nt+1
			end
			if nt<2 then
			plant=true 
			end
		end
	end
	remaining_charge= recursive_dig(pos, current_charge,sneak,plant)
	-- Now drop items for the player
	for name, stack in pairs(produced) do
		-- Drop stacks of stack max or less
		local count, max = stack:get_count(), stack:get_stack_max()
		stack:set_count(max)
		while count > max do
			minetest.add_item(get_drop_pos(pos), stack)
			count = count - max
		end
		stack:set_count(count)
		minetest.add_item(get_drop_pos(pos), stack)
	end

	-- Clean up
	produced = {}
	if plant and sapling~="" then
		minetest.set_node(pos, {name=sapling})
		sapling=""	
	end

	timber_nodenames["default:snowblock"]        = false
	timber_nodenames["default:snow"]             = false

	return remaining_charge
end


minetest.register_tool("technic:chainsaw", {
	description = S("Chainsaw"),
	inventory_image = "technic_chainsaw.png",
	stack_max = 1,
	wear_represents = "technic_RE_charge",
	on_refill = technic.refill_RE_charge,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end
		local nodename=minetest.get_node(pointed_thing.under).name
		if not timber_nodenames[nodename] then
			return
		end
		local meta = minetest.deserialize(itemstack:get_metadata())
		if not meta or not meta.charge or
				meta.charge < chainsaw_charge_per_node then
			return
		end

		local name = user:get_player_name()
		if minetest.is_protected(pointed_thing.under, name) then
			minetest.record_protection_violation(pointed_thing.under, name)
			return
		end
		local keys = user:get_player_control()
		local sneak=keys["sneak"] 
selected_nodes={}
if sneak then
local treename = nodename
selected_nodes={
	[treename]       = true,
}
if not chainsaw_leaves then
if treename=="moretrees:rubber_tree_trunk_empty" or treename=="moretrees:rubber_tree_trunk" then
selected_nodes={
	["moretrees:rubber_tree_trunk_empty"] = true,
	["moretrees:rubber_tree_trunk"]       = true,
}
end
else
if treename=="default:tree" or treename=="default:leaves" or treename=="default:apple" or treename=="paragenv7:appleleaf" then
selected_nodes["default:tree"]       = true
selected_nodes["default:leaves"]       = true
selected_nodes["default:apple"]       = true
selected_nodes["paragenv7:appleleaf"]       = true
elseif treename=="default:jungletree" or treename=="default:jungleleaves" or treename=="paragenv7:jungleleaf" then
selected_nodes["default:jungletree"]       = true
selected_nodes["default:jungleleaves"]       = true
selected_nodes["paragenv7:jungleleaf"]       = true
elseif treename=="moretrees:apple_tree_trunk" or treename== "moretrees:apple_tree_leaves" then
selected_nodes["moretrees:apple_tree_trunk"]       = true
selected_nodes["moretrees:apple_tree_leaves"]       = true
selected_nodes["default:apple"]       = true
elseif treename=="moretrees:fir_trunk" or treename=="moretrees:fire_leaves" or treename=="moretrees:fire_leaves_bright" or treename=="moretrees:fire_cone" then
selected_nodes["moretrees:fir_trunk"]       = true
selected_nodes["moretrees:fir_leaves"]       = true
selected_nodes["moretrees:fir_leaves_bright"]       = true
selected_nodes["moretrees:fir_cone"]                 = true
elseif treename=="moretrees:oak_trunk" or treename=="moretrees:oak_leaves" or treename=="moretrees:acorn" then
selected_nodes["moretrees:oak_trunk"]       = true
selected_nodes["moretrees:oak_leaves"]       = true
selected_nodes["moretrees:acorn"]  		       = true
elseif treename=="moretrees:sequoia_trunk" or treename=="moretrees:sequoia_leaves" then
selected_nodes["moretrees:sequoia_trunk"]       = true
selected_nodes["moretrees:sequoia_leaves"]       = true
elseif treename=="moretrees:birch_trunk" or treename=="moretrees:birch_leaves" then
selected_nodes["moretrees:birch_trunk"]       = true
selected_nodes["moretrees:birch_leaves"]       = true
elseif treename=="moretrees:beech_trunk" or treename=="moretrees:beech_leaves" then
selected_nodes["moretrees:beech_trunk"]       = true
selected_nodes["moretrees:beech_leaves"]       = true
elseif treename=="moretrees:palm_trunk" or treename=="moretrees:palm_leaves" or treename=="moretrees:coconut" then
selected_nodes["moretrees:palm_trunk"]       = true
selected_nodes["moretrees:palm_leaves"]       = true
selected_nodes["moretrees:coconut"]                  = true
elseif treename=="moretrees:spruce_trunk" or treename=="moretrees:spruce_leaves"or  treename=="moretrees:spruce_cone" then
selected_nodes["moretrees:spruce_trunk"]       = true
selected_nodes["moretrees:spruce_leaves"]       = true
selected_nodes["moretrees:spruce_cone"]              = true
elseif treename=="moretrees:pine_trunk" or treename=="moretrees:pine_leaves" or treename=="moretrees:pine_cone" then
selected_nodes["moretrees:pine_trunk"]       = true
selected_nodes["moretrees:pine_leaves"]       = true
selected_nodes["moretrees:pine_cone"]                = true
elseif treename=="moretrees:willow_trunk" or treename=="moretrees:willow_leaves" then
selected_nodes["moretrees:willow_trunk"]       = true
selected_nodes["moretrees:willow_leaves"]       = true
elseif treename=="moretrees:jungletree_trunk" or treename=="moretrees:jungletree_leaves_yellow" or treename=="moretrees:jungletree_leaves_green" or treename=="moretrees:jungletree_leaves_red" then
selected_nodes["moretrees:jungletree_trunk"]       = true
selected_nodes["moretrees:jungletree_leaves_green"]       = true
selected_nodes["moretrees:jungletree_leaves_yellow"]       = true
selected_nodes["moretrees:jungletree_leaves_red"]       = true
elseif treename=="moretrees:rubber_tree_trunk" or treename=="moretrees:rubber_tree_trunk_empty" or treename=="moretrees:rubber_tree_leaves" then
selected_nodes["moretrees:rubber_tree_trunk"]       = true
selected_nodes["moretrees:rubber_tree_trunk_empty"]       = true
selected_nodes["moretrees:rubber_tree_leaves"]       = true
elseif treename=="paragenv7:acaciatree" or treename=="paragenv7:acacialeaf" then
selected_nodes["paragenv7:acaciatree"]       = true
selected_nodes["paragenv7:acacialeaf"]       = true
elseif treename=="paragenv7:pinetree" or treename=="paragenv7:needles" then
selected_nodes["paragenv7:pinetree"]       = true
selected_nodes["paragenv7:needles"]       = true
selected_nodes["default:snowblock"]        = true
selected_nodes["default:snow"]             = true
end
end
end

		timber_nodenames["moretrees:apple_tree_leaves"]        = true
		timber_nodenames["moretrees:oak_leaves"]               = true
		timber_nodenames["moretrees:fir_leaves"]               = true
		timber_nodenames["moretrees:fir_leaves_bright"]        = true
		timber_nodenames["moretrees:sequoia_leaves"]           = true
		timber_nodenames["moretrees:birch_leaves"]             = true
		timber_nodenames["moretrees:birch_leaves"]             = true
		timber_nodenames["moretrees:palm_leaves"]              = true
		timber_nodenames["moretrees:spruce_leaves"]            = true
		timber_nodenames["moretrees:spruce_leaves"]            = true
		timber_nodenames["moretrees:pine_leaves"]              = true
		timber_nodenames["moretrees:willow_leaves"]            = true
		timber_nodenames["moretrees:jungletree_leaves_green"]  = true
		timber_nodenames["moretrees:jungletree_leaves_yellow"] = true
		timber_nodenames["moretrees:jungletree_leaves_red"]    = true
--cut this fruits down too
		timber_nodenames["moretrees:acorn"]  		       = true
		timber_nodenames["moretrees:coconut"]                  = true
		timber_nodenames["moretrees:pine_cone"]                = true
		timber_nodenames["moretrees:fir_cone"]                 = true
		timber_nodenames["moretrees:spruce_cone"]              = true


		-- Send current charge to digging function so that the
		-- chainsaw will stop after digging a number of nodes
		meta.charge = chainsaw_dig(pointed_thing.under, meta.charge, sneak)

		technic.set_RE_wear(itemstack, meta.charge, chainsaw_max_charge)
		itemstack:set_metadata(minetest.serialize(meta))
		return itemstack
	end,
})

minetest.register_tool(":moreores:chopping_axe", {
	description = S("Chopping Axe"),
	inventory_image = "chopping_axe.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return itemstack
		end
		local nodename=minetest.get_node(pointed_thing.under).name
		if not timber_nodenames[nodename] then
			return
		end

		local name = user:get_player_name()
		if minetest.is_protected(pointed_thing.under, name) then
			minetest.record_protection_violation(pointed_thing.under, name)
			return
		end
		local keys = user:get_player_control()
		local sneak=keys["sneak"] 
selected_nodes={}
if sneak then
local treename = nodename
selected_nodes={
	[treename]       = true,
}
if not chainsaw_leaves then
if treename=="moretrees:rubber_tree_trunk_empty" or treename=="moretrees:rubber_tree_trunk" then
selected_nodes={
	["moretrees:rubber_tree_trunk_empty"] = true,
	["moretrees:rubber_tree_trunk"]       = true,
}
end
else
if treename=="default:tree" or treename=="default:leaves" or treename=="default:apple" or treename=="paragenv7:appleleaf" then
selected_nodes["default:tree"]       = true
selected_nodes["default:leaves"]       = true
selected_nodes["default:apple"]       = true
selected_nodes["paragenv7:appleleaf"]       = true
elseif treename=="default:jungletree" or treename=="default:jungleleaves" or treename=="paragenv7:jungleleaf" then
selected_nodes["default:jungletree"]       = true
selected_nodes["default:jungleleaves"]       = true
selected_nodes["paragenv7:jungleleaf"]       = true
elseif treename=="moretrees:apple_tree_trunk" or treename== "moretrees:apple_tree_leaves" then
selected_nodes["moretrees:apple_tree_trunk"]       = true
selected_nodes["moretrees:apple_tree_leaves"]       = true
selected_nodes["default:apple"]       = true
elseif treename=="moretrees:fir_trunk" or treename=="moretrees:fire_leaves" or treename=="moretrees:fire_leaves_bright" or treename=="moretrees:fire_cone" then
selected_nodes["moretrees:fir_trunk"]       = true
selected_nodes["moretrees:fir_leaves"]       = true
selected_nodes["moretrees:fir_leaves_bright"]       = true
selected_nodes["moretrees:fir_cone"]                 = true
elseif treename=="moretrees:oak_trunk" or treename=="moretrees:oak_leaves" or treename=="moretrees:acorn" then
selected_nodes["moretrees:oak_trunk"]       = true
selected_nodes["moretrees:oak_leaves"]       = true
selected_nodes["moretrees:acorn"]  		       = true
elseif treename=="moretrees:sequoia_trunk" or treename=="moretrees:sequoia_leaves" then
selected_nodes["moretrees:sequoia_trunk"]       = true
selected_nodes["moretrees:sequoia_leaves"]       = true
elseif treename=="moretrees:birch_trunk" or treename=="moretrees:birch_leaves" then
selected_nodes["moretrees:birch_trunk"]       = true
selected_nodes["moretrees:birch_leaves"]       = true
elseif treename=="moretrees:beech_trunk" or treename=="moretrees:beech_leaves" then
selected_nodes["moretrees:beech_trunk"]       = true
selected_nodes["moretrees:beech_leaves"]       = true
elseif treename=="moretrees:palm_trunk" or treename=="moretrees:palm_leaves" or treename=="moretrees:coconut" then
selected_nodes["moretrees:palm_trunk"]       = true
selected_nodes["moretrees:palm_leaves"]       = true
selected_nodes["moretrees:coconut"]                  = true
elseif treename=="moretrees:spruce_trunk" or treename=="moretrees:spruce_leaves"or  treename=="moretrees:spruce_cone" then
selected_nodes["moretrees:spruce_trunk"]       = true
selected_nodes["moretrees:spruce_leaves"]       = true
selected_nodes["moretrees:spruce_cone"]              = true
elseif treename=="moretrees:pine_trunk" or treename=="moretrees:pine_leaves" or treename=="moretrees:pine_cone" then
selected_nodes["moretrees:pine_trunk"]       = true
selected_nodes["moretrees:pine_leaves"]       = true
selected_nodes["moretrees:pine_cone"]                = true
elseif treename=="moretrees:willow_trunk" or treename=="moretrees:willow_leaves" then
selected_nodes["moretrees:willow_trunk"]       = true
selected_nodes["moretrees:willow_leaves"]       = true
elseif treename=="moretrees:jungletree_trunk" or treename=="moretrees:jungletree_leaves_yellow" or treename=="moretrees:jungletree_leaves_green" or treename=="moretrees:jungletree_leaves_red" then
selected_nodes["moretrees:jungletree_trunk"]       = true
selected_nodes["moretrees:jungletree_leaves_green"]       = true
selected_nodes["moretrees:jungletree_leaves_yellow"]       = true
selected_nodes["moretrees:jungletree_leaves_red"]       = true
elseif treename=="moretrees:rubber_tree_trunk" or treename=="moretrees:rubber_tree_trunk_empty" or treename=="moretrees:rubber_tree_leaves" then
selected_nodes["moretrees:rubber_tree_trunk"]       = true
selected_nodes["moretrees:rubber_tree_trunk_empty"]       = true
selected_nodes["moretrees:rubber_tree_leaves"]       = true
elseif treename=="paragenv7:acaciatree" or treename=="paragenv7:acacialeaf" then
selected_nodes["paragenv7:acaciatree"]       = true
selected_nodes["paragenv7:acacialeaf"]       = true
elseif treename=="paragenv7:pinetree" or treename=="paragenv7:needles" then
selected_nodes["paragenv7:pinetree"]       = true
selected_nodes["paragenv7:needles"]       = true
selected_nodes["default:snowblock"]        = true
selected_nodes["default:snow"]             = true
end
end
end

		timber_nodenames["moretrees:apple_tree_leaves"]        = true
		timber_nodenames["moretrees:oak_leaves"]               = true
		timber_nodenames["moretrees:fir_leaves"]               = true
		timber_nodenames["moretrees:fir_leaves_bright"]        = true
		timber_nodenames["moretrees:sequoia_leaves"]           = true
		timber_nodenames["moretrees:birch_leaves"]             = true
		timber_nodenames["moretrees:birch_leaves"]             = true
		timber_nodenames["moretrees:palm_leaves"]              = true
		timber_nodenames["moretrees:spruce_leaves"]            = true
		timber_nodenames["moretrees:spruce_leaves"]            = true
		timber_nodenames["moretrees:pine_leaves"]              = true
		timber_nodenames["moretrees:willow_leaves"]            = true
		timber_nodenames["moretrees:jungletree_leaves_green"]  = true
		timber_nodenames["moretrees:jungletree_leaves_yellow"] = true
		timber_nodenames["moretrees:jungletree_leaves_red"]    = true
--cut this fruits down too
		timber_nodenames["moretrees:acorn"]  		       = true
		timber_nodenames["moretrees:coconut"]                  = true
		timber_nodenames["moretrees:pine_cone"]                = true
		timber_nodenames["moretrees:fir_cone"]                 = true
		timber_nodenames["moretrees:spruce_cone"]              = true


		-- Send current charge to digging function so that the
		-- chainsaw will stop after digging a number of nodes
		local chopped = 50000-chainsaw_dig(pointed_thing.under, 50000, sneak)
if chopped>40 then
		itemstack:set_wear(itemstack:get_wear()+150)
end
		return itemstack
	end,
})

minetest.register_craft({
        output = 'technic:chainsaw',
        recipe = {
                {'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot', 'technic:battery'},
                {'technic:stainless_steel_ingot', 'technic:motor',                 'technic:battery'},
                {'',                               '',                             'default:copper_ingot'},
        }
})

minetest.register_craft({
        output = 'moreores:chopping_axe',
        recipe = {
                {'moreores:mithril_block', 'moreores:mithril_block',''},
                {'moreores:mithril_block','group:stick',''},
                {'','group:stick',''},
        }
})

minetest.register_craft({
        output = 'moreores:chopping_axe',
        recipe = {
                {'', 'moreores:mithril_block', 'moreores:mithril_block'},
                {'','group:stick','moreores:mithril_block'},
                {'','group:stick',''},
        }
})

minetest.register_alias("chopping_axe", "moreores:chopping_axe")

