local mower_check_interval = 0.5 
local mower_max_distance 	= 20  
local mower_max_charge 	= 20000
local mower_charge_per_grass= 50

local lastmowing={}
local mowing=false
local timerX=0
local S = technic.getter

technic.register_power_tool("technic:mower", mower_max_charge)

minetest.register_tool("technic:mower", {
	description = S("Electric Lawnmower"),
	inventory_image = "technic_lawnmower.png",
	stack_max = 1,
	wear_represents = "technic_RE_charge",
	on_refill = technic.refill_RE_charge,
	on_use = function(itemstack, user, pointed_thing)
		local meta = minetest.deserialize(itemstack:get_metadata())
		if not meta then
			meta={}
		end
		local keys = user:get_player_control()
		local sneak=keys["sneak"] 
		if sneak then
			if meta.collect=="0" then
				meta.collect="1"
				if meta.flowers=="1" then
				minetest.chat_send_player(user:get_player_name(), "Collect the cutted grass and flowers")
				else
				minetest.chat_send_player(user:get_player_name(), "Collect the cutted grass")
				end
			elseif meta.collect=="1" then
				meta.collect="2"
				if meta.flowers=="1" then
				minetest.chat_send_player(user:get_player_name(), "Completely remove all mowed grass and flowers")
				else
				minetest.chat_send_player(user:get_player_name(), "Completely remove the cutted grass")
				end
			elseif meta.collect=="2" and meta.flowers=="1" then
				meta.collect="3"
				minetest.chat_send_player(user:get_player_name(), "Collect flowers but remove grass")
			elseif meta.collect=="2" or meta.collect=="3" then
				meta.collect="0"
				if meta.flowers=="1" then
				minetest.chat_send_player(user:get_player_name(), "Don't collect cutted grass and flowers")
				else
				minetest.chat_send_player(user:get_player_name(), "Don't collect cutted grass")
				end
			else 
				meta.collect="0"
				if meta.flowers=="1" then
				minetest.chat_send_player(user:get_player_name(), "Don't collect cutted grass and flowers")
				else
				minetest.chat_send_player(user:get_player_name(), "Don't collect cutted grass")
				end
			end
		else
			if meta.flowers=="1" then
				meta.flowers="0"
				minetest.chat_send_player(user:get_player_name(), "Mow only grass")
			else
				meta.flowers="1"
				minetest.chat_send_player(user:get_player_name(), "Mow grass and flowers")
			end
		end
		itemstack:set_metadata(minetest.serialize(meta))
		return itemstack
	end,
})

minetest.register_globalstep(function(dtime)
if (timerX<mower_check_interval*10 and not mowing) or timerX<mower_check_interval then
timerX=timerX+dtime
else
timerX=0
local players  = minetest.get_connected_players()
mowing=false
for i,player in ipairs(players) do
if player:get_inventory()~=nil then
if player:get_inventory():get_list("main")~=nil then
local name=player:get_player_name()
	local pos=player:getpos()
if pos~=nil then
		pos={x=math.floor(pos.x+0.5),y=math.floor(pos.y+0.4),z=math.floor(pos.z+0.5)}
	if lastmowing[name]==nil then
	lastmowing[name]=pos
	elseif lastmowing[name].x==pos.x and lastmowing[name].z==pos.z then
	lastmowing[name]=pos
	break
	elseif lastmowing[name].y+1>pos.y or lastmowing[name].y-1<pos.y then
	lastmowing[name]=pos
	end
	for i,stack in ipairs(player:get_inventory():get_list("main")) do
	if string.sub(stack:get_name(), 0, 13) == "technic:mower" then
	local item=player:get_inventory():get_stack("main", i)
	local meta = minetest.deserialize(item:get_metadata())
		if meta and meta.charge and meta.charge > mower_charge_per_grass then
		local cutted=0
		local ps=0
		if math.abs(pos.x-lastmowing[name].x)>math.abs(pos.z-lastmowing[name].z) then
		local step=(math.abs(lastmowing[name].x-pos.x)/(lastmowing[name].x-pos.x))*2
		local pp=lastmowing[name].x
		while true do
		pp=pp+step
			ps={x=pp,y=pos.y,z=math.floor(((pp-lastmowing[name].x)/(pos.x-lastmowing[name].x))*(pos.z-lastmowing[name].z))}
			local nodes=minetest.find_nodes_in_area({x=ps.x-1,y=ps.y-1,z=ps.z-1},{x=ps.x+1,y=ps.y+1,z=ps.z+1},"group:grass")
			if nodes~=nil then
			for _,np in ipairs(nodes) do

				if not minetest.is_protected(np,name)then
				local itemstacks = minetest.get_node_drops(minetest.get_node(np).name)
				for _, itemname in ipairs(itemstacks) do
				if (meta.collect=="1" or meta.collect==nil) and (player:get_inventory()):room_for_item("main", ItemStack(itemname)) then
					player:get_inventory():add_item("main", ItemStack(itemname))
				elseif not (meta.collect=="3" or meta.collect=="2") then
					minetest.add_item(np, itemname)
				end
				end				
				cutted=cutted+1
				minetest.set_node(np,{name="air"})
			end
			end
			end
			if meta.flowers=="1" then
			nodes=minetest.find_nodes_in_area({x=ps.x-1,y=ps.y-1,z=ps.z-1},{x=ps.x+1,y=ps.y+1,z=ps.z+1},"group:flower")
			if nodes~=nil then
			for _,np in ipairs(nodes) do
				if not minetest.is_protected(np,name)then
				local itemstacks = minetest.get_node_drops(minetest.get_node(np).name)
				for _, itemname in ipairs(itemstacks) do
				if (meta.collect=="1" or meta.collect=="3" or meta.collect==nil) and (player:get_inventory()):room_for_item("main", ItemStack(itemname)) then
					player:get_inventory():add_item("main", ItemStack(itemname))
				elseif not meta.collect=="2" then
					minetest.add_item(np, itemname)
				end
				end				
				cutted=cutted+1
				minetest.set_node(np,{name="air"})
			end
			end
			end
			end
			if (pp+step>=pos.x and step>=0) or (step~=-2 and step~=2) or (pp+step<=pos.x and step<=0) then break end
		end
		else
		local step=(math.abs(lastmowing[name].z-pos.z)/(lastmowing[name].z-pos.z))*2
		local pp=lastmowing[name].z
		while true do
		pp=pp+step
		ps=pos
		if math.abs(pos.x-lastmowing[name].z)>math.abs(pos.z-lastmowing[name].x) then
			ps={x=math.floor(((pp-lastmowing[name].z)/(pos.z-lastmowing[name].z))*(pos.x-lastmowing[name].x)),y=pos.y,z=pp}
		end
			local nodes=minetest.find_nodes_in_area({x=ps.x-1,y=ps.y-1,z=ps.z-1},{x=ps.x+1,y=ps.y+1,z=ps.z+1},"group:grass")
			if nodes~=nil then
			for _,np in ipairs(nodes) do
				if not minetest.is_protected(np,name)then
				local itemstacks = minetest.get_node_drops(minetest.get_node(np).name)
				for _, itemname in ipairs(itemstacks) do
				if (meta.collect=="1" or meta.collect==nil) and (player:get_inventory()):room_for_item("main", ItemStack(itemname)) then
					player:get_inventory():add_item("main", ItemStack(itemname))
				elseif not (meta.collect=="3" or meta.collect=="2") then
					minetest.add_item(np, itemname)
				end
				end				
				cutted=cutted+1
				minetest.set_node(np,{name="air"})
			end
			end
			end
			if meta.flowers=="1" then
			nodes=minetest.find_nodes_in_area({x=ps.x-1,y=ps.y-1,z=ps.z-1},{x=ps.x+1,y=ps.y+1,z=ps.z+1},"group:flower")
			if nodes~=nil then
			for _,np in ipairs(nodes) do

				if not minetest.is_protected(np,name)then
				local itemstacks = minetest.get_node_drops(minetest.get_node(np).name)
				for _, itemname in ipairs(itemstacks) do
				if (meta.collect=="1" or meta.collect=="3" or meta.collect==nil) and (player:get_inventory()):room_for_item("main", ItemStack(itemname)) then
					player:get_inventory():add_item("main", ItemStack(itemname))
				elseif not meta.collect=="2" then
					minetest.add_item(np, itemname)
				end
				end				
				cutted=cutted+1
				minetest.set_node(np,{name="air"})
			end
			end
			end
			end
			if (pp+step>=pos.z and step>=0) or (step~=-2 and step~=2) or (pp+step<=pos.z and step<=0) then break end
		end
		end
		meta.charge = meta.charge-(cutted*mower_charge_per_grass)
		if meta.charge<0 then 
			meta.charge = 0
		end
		technic.set_RE_wear(item, meta.charge, mower_max_charge)
		item:set_metadata(minetest.serialize(meta))
		player:get_inventory():set_stack("main",i, item)
		mowing=true
		break
	end
	end
	if i>=8 then
		lastmowing[name]=nil
		break
	end
end
end
end
end
end
end
end)

minetest.register_craftitem("technic:small_tyre", {
	description = S("Small Tyre"),
	inventory_image = "technic_small_tyre.png",
})

minetest.register_craftitem("technic:blades", {
	description = S("Blades"),
	inventory_image = "technic_blades.png",
})

minetest.register_craft({
	output = 'technic:small_tyre',
	recipe = {
		{'', 'technic:rubber', ''},
		{'technic:rubber', 'homedecor:plastic_sheeting', 'technic:rubber'},
		{'', 'technic:rubber', ''},
	}
})

minetest.register_craft({
	output = 'technic:blades',
	recipe = {
		{'technic:carbon_steel_ingot', '', 'technic:carbon_steel_ingot'},
		{'', 'technic:carbon_steel_ingot', ''},
		{'technic:carbon_steel_ingot', '', 'technic:carbon_steel_ingot'},
	}
})

minetest.register_craft({
	output = 'technic:mower',
	recipe = {
		{'technic:small_tyre', 'homedecor:pole_steel', 'technic:small_tyre'},
		{'technic:battery', 'technic:motor', 'technic:battery'},
		{'technic:small_tyre', 'technic:blades', 'technic:small_tyre'},
	}
})

