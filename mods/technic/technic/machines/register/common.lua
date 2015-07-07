
local S = technic.getter

function technic.handle_machine_upgrades(meta)
	-- Get the names of the upgrades
	local inv = meta:get_inventory()
	local upg_item1
	local upg_item2
	local srcstack = inv:get_stack("upgrade1", 1)
	if srcstack then
		upg_item1 = srcstack:to_table()
	end
	srcstack = inv:get_stack("upgrade2", 1)
	if srcstack then
		upg_item2 = srcstack:to_table()
	end

	-- Save some power by installing battery upgrades.
	-- Tube loading speed can be upgraded using control logic units.
	local EU_upgrade = 0
	if upg_item1 then
		if     upg_item1.name == "technic:battery" then
			EU_upgrade = EU_upgrade + 1
		end
	end
	if upg_item2 then
		if     upg_item2.name == "technic:battery" then
			EU_upgrade = EU_upgrade + 1
		end
	end
	return EU_upgrade
end




function technic.smelt_item(meta, result, speed)
	local inv = meta:get_inventory()
	meta:set_int("cook_time", meta:get_int("cook_time") + 1)
	if meta:get_int("cook_time") < result.time / speed then
		return
	end
	local result = minetest.get_craft_result({method = "cooking", width = 1, items = inv:get_list("src")})

	if result and result.item then
		meta:set_int("cook_time", 0)
		-- check if there's room for output in "dst" list
		if inv:room_for_item("dst", result.item) then
			srcstack = inv:get_stack("src", 1)
			srcstack:take_item()
			inv:set_stack("src", 1, srcstack)
			inv:add_item("dst", result.item)
		end
	end
end


function technic.machine_can_dig(pos, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if not inv:is_empty("src") or not inv:is_empty("dst") or
	   not inv:is_empty("upgrade1") or not inv:is_empty("upgrade2") then
		minetest.chat_send_player(player:get_player_name(),
			S("Machine cannot be removed because it is not empty"))
		return false
	else
		return true
	end
end

local function inv_change(pos, player, count)
	if minetest.is_protected(pos, player:get_player_name()) then
		minetest.chat_send_player(player:get_player_name(),
			S("Inventory move disallowed due to protection"))
		return 0
	end
	return count
end

function technic.machine_inventory_put(pos, listname, index, stack, player)
	return inv_change(pos, player, stack:get_count())
end

function technic.machine_inventory_take(pos, listname, index, stack, player)
	return inv_change(pos, player, stack:get_count())
end

function technic.machine_inventory_move(pos, from_list, from_index,
		to_list, to_index, count, player)
	return inv_change(pos, player, count)
end

