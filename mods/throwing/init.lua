arrows = {
	{"throwing:arrow", "throwing:arrow_entity"},
	{"throwing:golden_arrow", "throwing:golden_arrow_entity"},
	{"throwing:arrow_steal", "throwing:arrow_steal_entity"},
	{"throwing:arrow_fire", "throwing:arrow_fire_entity"},
	{"throwing:arrow_teleport", "throwing:arrow_teleport_entity"},
	{"throwing:arrow_dig", "throwing:arrow_dig_entity"},
	{"throwing:arrow_build", "throwing:arrow_build_entity"}
}

local throwing_shoot_arrow = function(itemstack, player,speed)
	for _,arrow in ipairs(arrows) do
		if player:get_inventory():get_stack("main", player:get_wield_index()+1):get_name() == arrow[1] then
			if not minetest.setting_getbool("creative_mode") then
				player:get_inventory():remove_item("main", arrow[1])
			end
			local playerpos = player:getpos()
			local obj = minetest.env:add_entity({x=playerpos.x,y=playerpos.y+1.5,z=playerpos.z}, arrow[2])
			local dir = player:get_look_dir()
			if obj:get_luaentity().player == "" or obj:get_luaentity().player == nil then
				obj:get_luaentity().player = player
			end
			obj:get_luaentity().node = player:get_inventory():get_stack("main", player:get_wield_index()+2):get_name()
			obj:setyaw(player:get_look_yaw()+math.pi)
			minetest.after(0.2, function (playerpos, obj, dir, speed)
				obj:setvelocity({x=dir.x*speed, y=dir.y*speed, z=dir.z*speed})
				obj:setacceleration({x=dir.x*-3, y=-10, z=dir.z*-3})
--				minetest.sound_play("throwing_sound", {pos=playerpos})
			end, playerpos, obj, dir, speed)
			return true
		end
	end
	local search=0
	for _,arrow in ipairs(arrows) do
		search=search+1
		if player:get_inventory():contains_item("main",arrow[1]) then
			if not minetest.setting_getbool("creative_mode") then
				player:get_inventory():remove_item("main", arrow[1])
			end
			local playerpos = player:getpos()
			local obj = minetest.env:add_entity({x=playerpos.x,y=playerpos.y+1.5,z=playerpos.z}, arrow[2])
			local dir = player:get_look_dir()
			if obj:get_luaentity().player == "" or obj:get_luaentity().player == nil then
				obj:get_luaentity().player = player
			end
			obj:get_luaentity().node = player:get_inventory():get_stack("main", player:get_wield_index()+2):get_name()
			obj:setyaw(player:get_look_yaw()+math.pi)
			minetest.after(0.2, function (playerpos, obj, dir, speed)
				obj:setvelocity({x=dir.x*speed, y=dir.y*speed, z=dir.z*speed})
				obj:setacceleration({x=dir.x*-3, y=-10, z=dir.z*-3})
--				minetest.sound_play("throwing_sound", {pos=playerpos})
			end, playerpos, obj, dir, speed)
			return true
		end
		if search>=3 then
			break
		end
	end
	return false
end

minetest.register_tool("throwing:bow_wood", {
	description = "Wood Bow",
	inventory_image = "throwing_bow_wood.png",
    stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		if throwing_shoot_arrow(itemstack, user, 10) then
			if not minetest.setting_getbool("creative_mode") then
				itemstack:add_wear(65535/35)
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = 'throwing:bow_wood',
	recipe = {
		{'farming:cotton', 'moreblocks:jungle_stick', ''},
		{'farming:cotton', '', 'moreblocks:jungle_stick'},
		{'farming:cotton', 'moreblocks:jungle_stick', ''},
	}
})

if (minetest.get_modpath("moreores")) then

minetest.register_tool("throwing:bow_silver", {
	description = "Silver Bow",
	inventory_image = "throwing_bow_stone.png",
    stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
	local keys = user:get_player_control()
		if keys["RMB"] == true or keys["sneak"] == true then 
			if pointed_thing~= nil and pointed_thing.type=="object" and pointed_thing.ref:get_luaentity().itemstring ~=nil and user:get_inventory():room_for_item("main", ItemStack(pointed_thing.ref:get_luaentity().itemstring)) then
				user:get_inventory():add_item("main", ItemStack(pointed_thing.ref:get_luaentity().itemstring))
				pointed_thing.ref:get_luaentity().itemstring = ""
				pointed_thing.ref:remove()
			end
		return
		end
		if throwing_shoot_arrow(itemstack, user, 25) then
			if not minetest.setting_getbool("creative_mode") then
				itemstack:add_wear(65535/400)
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = 'throwing:bow_silver',
	recipe = {
		{'farming:cotton', 'moreores:silver_ingot', ''},
		{'farming:cotton', '', 'moreores:silver_ingot'},
		{'farming:cotton', 'moreores:silver_ingot', ''},
	}
})

end

minetest.register_tool("throwing:bow_steel", {
	description = "Steel Bow",
	inventory_image = "throwing_bow_steel.png",
    stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
	local keys = user:get_player_control()
		if keys["RMB"] == true or keys["sneak"] == true then 
			if pointed_thing~= nil and pointed_thing.type=="object" and pointed_thing.ref:get_luaentity().itemstring ~=nil and user:get_inventory():room_for_item("main", ItemStack(pointed_thing.ref:get_luaentity().itemstring)) then
user:get_inventory():add_item("main", ItemStack(pointed_thing.ref:get_luaentity().itemstring))
pointed_thing.ref:get_luaentity().itemstring = ""
pointed_thing.ref:remove()
end
return
end
		if throwing_shoot_arrow(itemstack, user, 18) then
			if not minetest.setting_getbool("creative_mode") then
				itemstack:add_wear(65535/150)
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = 'throwing:bow_steel',
	recipe = {
		{'farming:cotton', 'default:steel_ingot', ''},
		{'farming:cotton', '', 'default:steel_ingot'},
		{'farming:cotton', 'default:steel_ingot', ''},
	}
})

if (minetest.get_modpath("technic")) then

minetest.register_tool("throwing:bow_carbon_steel", {
	description = "Carbon Steel Bow",
	inventory_image = "throwing_bow_carbon_steel.png",
    stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
	local keys = user:get_player_control()
		if keys["RMB"] == true or keys["sneak"] == true then 
			if pointed_thing~= nil and pointed_thing.type=="object" and pointed_thing.ref:get_luaentity().itemstring ~=nil and user:get_inventory():room_for_item("main", ItemStack(pointed_thing.ref:get_luaentity().itemstring)) then
				user:get_inventory():add_item("main", ItemStack(pointed_thing.ref:get_luaentity().itemstring))
				pointed_thing.ref:get_luaentity().itemstring = ""
				pointed_thing.ref:remove()
			end
			return
		end

		if throwing_shoot_arrow(itemstack, user, 22) then
			if not minetest.setting_getbool("creative_mode") then
				itemstack:add_wear(65535/250)
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = 'throwing:bow_carbon_steel',
	recipe = {
		{'farming:cotton', 'technic:carbon_steel_ingot', ''},
		{'farming:cotton', '', 'technic:carbon_steel_ingot'},
		{'farming:cotton', 'technic:carbon_steel_ingot', ''},
	}
})

end

minetest.register_tool("throwing:bow_bronze", {
	description = "Bronze Bow",
	inventory_image = "throwing_bow_bronze.png",
    stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
	local keys = user:get_player_control()
		if keys["RMB"] == true or keys["sneak"] == true then 
			if pointed_thing~= nil and pointed_thing.type=="object" and pointed_thing.ref:get_luaentity().itemstring ~=nil and user:get_inventory():room_for_item("main", ItemStack(pointed_thing.ref:get_luaentity().itemstring)) then
				user:get_inventory():add_item("main", ItemStack(pointed_thing.ref:get_luaentity().itemstring))
				pointed_thing.ref:get_luaentity().itemstring = ""
				pointed_thing.ref:remove()
			end
			return
		end

		if throwing_shoot_arrow(itemstack, user, 21) then
			if not minetest.setting_getbool("creative_mode") then
				itemstack:add_wear(65535/80)
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = 'throwing:bow_bronze',
	recipe = {
		{'farming:cotton', 'default:bronze_ingot', ''},
		{'farming:cotton', '', 'default:bronze_ingot'},
		{'farming:cotton', 'default:bronze_ingot', ''},
	}
})

if (minetest.get_modpath("moreores")) then

minetest.register_tool("throwing:bow_mithril", {
	description = "Mithril Bow",
	inventory_image = "throwing_bow_mithril.png",
    stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
	local keys = user:get_player_control()
		if keys["RMB"] == true or keys["sneak"] == true then 
			if pointed_thing~= nil and pointed_thing.type=="object" and pointed_thing.ref:get_luaentity().itemstring ~=nil and user:get_inventory():room_for_item("main", ItemStack(pointed_thing.ref:get_luaentity().itemstring)) then
				user:get_inventory():add_item("main", ItemStack(pointed_thing.ref:get_luaentity().itemstring))
				pointed_thing.ref:get_luaentity().itemstring = ""
				pointed_thing.ref:remove()
			end
		return
		end

		if throwing_shoot_arrow(itemstack, user, 30) then
			if not minetest.setting_getbool("creative_mode") then
				itemstack:add_wear(65535/900)
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = 'throwing:bow_mithril',
	recipe = {
		{'farming:cotton', 'moreores:mithril_ingot', ''},
		{'farming:cotton', '', 'moreores:mithril_ingot'},
		{'farming:cotton', 'moreores:mithril_ingot', ''},
	}
})

end

dofile(minetest.get_modpath("throwing").."/arrow.lua")
dofile(minetest.get_modpath("throwing").."/golden_arrow.lua")
dofile(minetest.get_modpath("throwing").."/fire_arrow.lua")
dofile(minetest.get_modpath("throwing").."/teleport_arrow.lua")
dofile(minetest.get_modpath("throwing").."/dig_arrow.lua")
dofile(minetest.get_modpath("throwing").."/build_arrow.lua")
dofile(minetest.get_modpath("throwing").."/steal_arrow.lua")

if minetest.setting_get("log_mods") then
	minetest.log("action", "throwing loaded")
end
