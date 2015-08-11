technic_shops = {}
technic_shops.path = minetest.get_modpath("technic_shops")

technic_shops.money={}

technic_shops.money["default:gold_ingot"] = 10
technic_shops.money["moreores:silver_ingot"] = 2
technic_shops.money["default:copper_ingot"] = 1

minetest.register_node("technic_shops:traders_scale", {
	description = "Traders Scale",
	tiles = {"xpanes_space.png","xpanes_space.png","xpanes_space.png","xpanes_space.png","technic_shops_traders_scale.png","technic_shops_traders_scale.png"},
	drawtype = "nodebox",
        node_box = {
            type = "fixed",
            fixed = {
    {-0.5, -0.5, -0.06, 0.5, 0.5, 0.06},
}
        },
        selection_box = {
            type = "fixed",
            fixed = {
    {-0.5, -0.5, -0.06, 0.5, 0.5, 0.06},
}
        },
	inventory_image = "technic_shops_traders_scale.png",
	wield_image = "technic_shops_traders_scale.png",
	   groups = {cracky=3},
	light_source=7,
	sounds = default.node_sound_wood_defaults(),
        paramtype = "light",
        paramtype2 = "facedir",
        sunlight_propagates = true,
        buildable_to = true,
        air_equivalent = true,
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Traders Scale (owned by "..
				meta:get_string("owner")..")")
	end,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("price", 1)
		inv:set_size("sell", 4*4)
		inv:set_size("storage", 1*4)
		inv:set_size("storage3", 1*4)
		inv:set_size("storage2", 20)
		inv:set_size("money", 3*4)
		meta:set_string("altt1","")
		meta:set_string("altt2","")
		meta:set_string("altt3","")
		meta:set_string("altt4","")
		meta:set_string("alt1","0")
		meta:set_string("alt2","0")
		meta:set_string("alt3","0")
		meta:set_string("alt4","0")
		meta:set_string("storage2", "1")
		meta:set_string("owner", "")
		meta:set_string("mode","sell")
		meta:set_string("update", "0")
		meta:set_string("infotext", "Traders Scale")
		meta:set_string("chest", technic_shops.find_chest(pos))
		meta:set_string("nodepos",tostring(pos.x)..","..tostring(pos.y)..","..tostring(pos.z))
--		meta:set_string("formspec", technic_shops.traders_scale_formspec(meta))

	end,

	on_dig = function(pos, node, digger)
		if digger==nil then
		 return false
		end
		if minetest.is_protected(pos, digger:get_player_name()) then
		 return false
		end
		local meta=minetest.get_meta(pos)
		if meta==nil then
		minetest.remove_node(pos)
		minetest.env:add_item(pos, ItemStack("technic_shops:traders_scale"))
		 return true
		end
		local inv2=meta:get_inventory()
		if inv2==nil then
		minetest.remove_node(pos)
		minetest.env:add_item(pos, ItemStack("technic_shops:traders_scale"))
		 return true
		end
		local price=inv2:get_stack("price",1)
		if price==nil then
		minetest.remove_node(pos)
		minetest.env:add_item(pos, ItemStack("technic_shops:traders_scale"))
		 return true
		end
		if digger~=nil then
			local inv=digger:get_inventory()
			if inv~=nil then
				if inv:room_for_item("main",ItemStack("technic_shops:traders_scale")) then
		minetest.remove_node(pos)
			inv:add_item("main",ItemStack("technic_shops:traders_scale"))
				if inv:room_for_item("main",price) then
			inv:add_item("main",price)
			else
		minetest.env:add_item(pos, price)
			end
		 return true
		end
		end
		end
		minetest.remove_node(pos)
		minetest.env:add_item(pos, price)
		minetest.env:add_item(pos, ItemStack("technic_shops:traders_scale"))
		 return true
	end,

	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		local inv=meta:get_inventory()
		if meta:get_string("chest")=="" then
		meta:set_string("chest", technic_shops.find_chest(pos))
--		meta:set_string("formspec", technic_shops.traders_scale_formspec(meta))
		else
		local chest=meta:get_string("chest")
local x=meta:get_string("chestx")
local y=meta:get_string("chesty")
local z=meta:get_string("chestz")

local meta2=minetest.get_meta({x=tonumber(x),y=tonumber(y),z=tonumber(z)})
local inv2=meta2:get_inventory()
if inv2==nil then
		meta:set_string("chest", technic_shops.find_chest(pos))
--		meta:set_string("formspec", technic_shops.traders_scale_formspec(meta))
		if meta:get_string("chest")~="" then
		chest=meta:get_string("chest")
local x=meta:get_string("chestx")
local y=meta:get_string("chesty")
local z=meta:get_string("chestz")

meta2=minetest.get_meta({x=tonumber(x),y=tonumber(y),z=tonumber(z)})
inv2=meta2:get_inventory()
end
elseif inv2:get_size("main")<32 then
		meta:set_string("chest", technic_shops.find_chest(pos))
--		meta:set_string("formspec", technic_shops.traders_scale_formspec(meta))
		if meta:get_string("chest")~="" then
		chest=meta:get_string("chest")
local x=meta:get_string("chestx")
local y=meta:get_string("chesty")
local z=meta:get_string("chestz")

meta2=minetest.get_meta({x=tonumber(x),y=tonumber(y),z=tonumber(z)})
inv2=meta2:get_inventory()
end
		end
if inv2~=nil then
if inv2:get_size("main")>=32 then

	technic_shops.transfer_items(meta2,meta)
		end
end
end
local xx=string.sub("      "..tostring(pos.x),string.len(tostring(pos.x))+1,6+string.len(tostring(pos.x)))
local yy=string.sub("      "..tostring(pos.y),string.len(tostring(pos.y))+1,6+string.len(tostring(pos.y)))
local zz=string.sub("      "..tostring(pos.z),string.len(tostring(pos.z))+1,6+string.len(tostring(pos.z)))

			minetest.show_formspec(
				clicker:get_player_name(),
				"technic_shops:traders_scale"..clicker:get_player_name()..xx..yy..zz,
				technic_shops.traders_scale_formspec(meta,clicker:get_player_name())
			)
end,


	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.env:get_meta(pos)
	if meta:get_string("chest")==nil then
		return 0
	end
	local inv=meta:get_inventory()
	local x=meta:get_string("chestx")
	local y=meta:get_string("chesty")
	local z=meta:get_string("chestz")
	local meta2=minetest.get_meta({x=tonumber(x),y=tonumber(y),z=tonumber(z)})
	local inv2=meta2:get_inventory()
	local add=0
	local widht=4
	if from_list=="money" then
	add=5
	widht=3
	elseif from_list=="storage" then
	add=4
	widht=1
	end
	local nr=from_index+32
	if from_list~="storage2" then
		nr=math.floor(from_index/widht-0.01)*8+(from_index-1)%widht+1+add
	end
	meta:set_string("update", "1")
	local add2=0
	local widht2=4
	if to_list=="money" then
	add2=5
	widht2=3
	elseif to_list=="storage" then
	add2=4
	widht2=1
	end
	local nr2=to_index+32
	if to_list~="storage2" then
		nr2=math.floor(to_index/widht2-0.01)*8+(to_index-1)%widht2+1+add2
	end
	if (to_list~="price"
and inv:get_stack(to_list,to_index):get_name()~=inv2:get_stack("main",nr2):get_name() 
and inv:get_stack(to_list,to_index):get_count()~=inv2:get_stack("main",nr2):get_count())
or (from_list~="price"
and inv:get_stack(from_list,from_index):get_name()~=inv2:get_stack("main",nr):get_name() 
and inv:get_stack(from_list,from_index):get_count()~=inv2:get_stack("main",nr):get_count()) then
			return 0
end
	if player:get_player_name()==meta:get_string("owner") and (from_list==to_list or to_list=="price" or (to_list~="money" and from_list~="money")) then
local moved=0
	if to_list~="price" then
	if from_list=="sell" or from_list=="storage2" or from_list=="storage" or from_list=="money" then
		inv2:set_stack("main",nr,inv:get_stack(to_list,to_index))
		moved=1
	end
	if to_list=="sell" or to_list=="storage2" or to_list=="storage" or to_list=="money" then
		inv2:set_stack("main",nr2,inv:get_stack(from_list,from_index))
		moved=1
	end
	else
	if technic_shops.money[inv:get_stack(from_list,from_index):get_name()]~=nil then
		inv2:set_stack("main",nr,inv:get_stack(to_list,to_index))
		moved=1
	end
	end
	if moved==1 then
	return count
	end
	end
	return 0
	end,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
	local meta = minetest.env:get_meta(pos)
	if meta:get_string("chest")==nil then
		return 0
	end
	local inv=meta:get_inventory()
	local x=meta:get_string("chestx")
	local y=meta:get_string("chesty")
	local z=meta:get_string("chestz")
	local meta2=minetest.get_meta({x=tonumber(x),y=tonumber(y),z=tonumber(z)})
	local inv2=meta2:get_inventory()

	if meta:get_string("mode")=="buy" and meta:get_string("owner")~= player and listname~="price" then
		if listname=="sell" and inv:get_stack("sell",index):get_count()==0 then
			local stn=stack:get_name()
			local stc=stack:get_count()
			local inv3=player:get_inventory()
local tsd=1
if meta:get_string("nr1")==tostring(stc) then
if meta:get_string("alt1")=="1" then
local groups=minetest.registered_items[inv:get_stack("storage",1):get_name()].groups
if groups~=nil then
for group,v in pairs(groups) do
if v>0 and group~="not_in_craft_guide" and group~="not_in_creative_inventory" then
if minetest.get_item_group(stack:get_name(),group) then
tsd=0
else
tsd=1
end
if tsd==1 then 
break
end
end
end
end
elseif tonumber(meta:get_string("alt1"))>1 then
if minetest.get_item_group(stack:get_name(),meta:get_string("altt1")) then
tsd=0
end
end
end
if tsd==1 then
if meta:get_string("nr2")==tostring(stc) then
if meta:get_string("alt2")=="1" then
groups=minetest.registered_items[inv:get_stack("storage",2):get_name()].groups
if groups~=nil then
for group,v in pairs(groups) do
if v>0 and group~="not_in_craft_guide" and group~="not_in_creative_inventory" then
if minetest.get_item_group(stack:get_name(),group) then
tsd=0
else
tsd=1
end
if tsd==1 then 
break
end
end
end
end
elseif tonumber(meta:get_string("alt2"))>1 then
if minetest.get_item_group(stack:get_name(),meta:get_string("altt2")) then
tsd=0
end
end
end
if tsd==1 then
if meta:get_string("nr3")==tostring(stc) then
if meta:get_string("alt3")=="1" then
groups=minetest.registered_items[inv:get_stack("storage",3):get_name()].groups
if groups~=nil then
for group,v in pairs(groups) do
if v>0 and group~="not_in_craft_guide" and group~="not_in_creative_inventory" then
if minetest.get_item_group(stack:get_name(),group) then
tsd=0
else
tsd=1
end
if tsd==1 then 
break
end
end
end
end
elseif tonumber(meta:get_string("alt3"))>1 then
if minetest.get_item_group(stack:get_name(),meta:get_string("altt3")) then
tsd=0
end
end
end
if tsd==1 then
if meta:get_string("nr4")==tostring(stc) then
if meta:get_string("alt4")=="1" then
groups=minetest.registered_items[inv:get_stack("storage",4):get_name()].groups
if groups~=nil then
for group,v in pairs(groups) do
if v>0 and group~="not_in_craft_guide" and group~="not_in_creative_inventory" then
if minetest.get_item_group(stack:get_name(),group) then
tsd=0
else
tsd=1
end
if tsd==1 then 
break
end
end
end
end
elseif tonumber(meta:get_string("alt4"))>1 then
if minetest.get_item_group(stack:get_name(),meta:get_string("altt4")) then
tsd=0
end
end
end
end
end
end
			if (tsd==0
			or (inv:get_stack("storage3",1):get_name()==stn and tonumber(meta:get_string("nr1"))==stc
			or inv:get_stack("storage3",2):get_name()==stn and tonumber(meta:get_string("nr2"))==stc
			or inv:get_stack("storage3",3):get_name()==stn and tonumber(meta:get_string("nr3"))==stc
			or inv:get_stack("storage3",4):get_name()==stn and tonumber(meta:get_string("nr4"))==stc)) then
			local cardnr=0
			local card=0
			for i,stack in ipairs(inv3:get_list("main")) do
			cardnr=cardnr+1
				if string.sub(stack:get_name(), 0, 21) == "technic_shops:ec_card" then
					card=cardnr
				end
			if card>0 then
				break
			end
			end
if card>0 then
			local cardst=inv3:get_stack("main",card)
			local meta4=cardst:get_metadata()
			local meta5=nil
			local inv5=nil
			if meta4~=nil then
				meta5=minetest.env:get_meta(minetest.string_to_pos(meta4))
				inv5=meta5:get_inventory()
			end				
			if meta5:get_string("owner")==player:get_player_name()
				and(inv2:contains_item("main",inv:get_stack("price",1)) and inv5:room_for_item("main",inv:get_stack("price",1))) then
			inv2:remove_item("main",inv:get_stack("price",1))
			inv5:add_item("main",inv:get_stack("price",1))
			meta:set_string("update", "1")
			inv2:set_stack("main",math.floor(index/4-0.01)*8+(index-1)%4+1,stack)
			if meta5:get_string("owner")~=player:get_player_name() then
			minetest.log("action", player:get_player_name()..
				" sells "..tostring(stc).." "..stack:get_name().." for "
				..tostring(inv:get_stack("price",1):get_count()).." "..inv:get_stack("price",1):get_name().." with an EC-Card at "..
				minetest.pos_to_string(pos))
			end
			return stc
			end			
end
			if (inv2:contains_item("main",inv:get_stack("price",1)) and inv3:room_for_item("main",inv:get_stack("price",1))) then
			inv2:remove_item("main",inv:get_stack("price",1))
			inv3:add_item("main",inv:get_stack("price",1))
			meta:set_string("update", "1")
			inv2:set_stack("main",math.floor(index/4-0.01)*8+(index-1)%4+1,stack)
			if meta:get_string("owner")~=player:get_player_name() then
			minetest.log("action", player:get_player_name()..
				" sells "..tostring(stc).." "..stack:get_name().." for "
				..tostring(inv:get_stack("price",1):get_count()).." "..inv:get_stack("price",1):get_name().." at "..
				minetest.pos_to_string(pos))
			end
			return stc
			end
		end
		return 0
	end	
end
	meta:set_string("update", "1")
	local add=0
	local widht=4
	if listname=="money" then
	add=5
	widht=3
	elseif listname=="storage" then
	add=4
	widht=1
	end
	local nr=index+32
	if listname~="storage2" then
		nr=math.floor(index/widht-0.01)*8+(index-1)%widht+1+add
	end
	if listname~="price" then
	if inv:get_stack(listname,index):get_name()~=inv2:get_stack("main",nr):get_name() and inv:get_stack(listname,index):get_name()~=inv2:get_stack("main",nr):get_count() then
			return 0
end
	end
	if (player:get_player_name()==meta:get_string("owner") and ((technic_shops.money[stack:get_name()]~=nil and listname=="money") or listname=="sell" or listname=="storage2" or listname=="storage" or listname=="price")) then
	if listname=="sell" or listname=="storage2" or listname=="storage" or listname=="money" then
		inv2:set_stack("main",nr,stack)
	end
if listname=="price" then
	if technic_shops.money[stack:get_name()]==nil then
return 0
end
end
	return stack:get_count()
	elseif (player:get_player_name()~=meta:get_string("owner") and listname=="money") then
	if inv2:get_stack("main",nr):get_name()~=stack:get_name() and inv2:get_stack("main",nr):get_count()>0 then
return 0
end
local price=technic_shops.money[inv:get_stack("price",1):get_name()]
if price==nil or price==0 then
return 0
else
 price=price*inv:get_stack("price",1):get_count()
end
if technic_shops.money[stack:get_name()]==nil then
	return 0
elseif technic_shops.money[stack:get_name()]*stack:get_count() < price 
	or (math.floor(0.999+price/technic_shops.money[stack:get_name()])*technic_shops.money[stack:get_name()])/price > 1.43 or inv2:get_stack("main",nr):get_count()+math.floor(0.999+price/technic_shops.money[stack:get_name()])>stack:get_stack_max() then
	return 0
end

	local payed=0
if meta:get_string("payed"..player:get_player_name())~=nil then 
payed=tonumber(meta:get_string("payed"..player:get_player_name()))
end
if payed==nil then
payed=0
end
	meta:set_string("payed"..player:get_player_name(),tostring(payed+(math.floor(0.999+price/technic_shops.money[stack:get_name()])*technic_shops.money[stack:get_name()])))
	inv2:set_stack("main",nr,ItemStack(stack:get_name().." "..tostring(inv2:get_stack("main",nr):get_count()+math.floor(0.999+price/technic_shops.money[stack:get_name()]))))
	return math.floor(0.999+price/technic_shops.money[stack:get_name()])
	end
	return 0
	end,

    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
	local meta = minetest.env:get_meta(pos)
	if meta:get_string("chest")==nil then
		return 0
	end
	local inv=meta:get_inventory()
	local x=meta:get_string("chestx")
	local y=meta:get_string("chesty")
	local z=meta:get_string("chestz")
	local meta2=minetest.get_meta({x=tonumber(x),y=tonumber(y),z=tonumber(z)})
	local inv2=meta2:get_inventory()
	local add=0
	local widht=4
	if listname=="money" then
	add=5
	widht=3
	elseif listname=="storage" then
	add=4
	widht=1
	end
	local nr=index+32
	if listname~="storage2" then
		nr=math.floor(index/widht-0.01)*8+(index-1)%widht+1+add
	end
	if listname~="price" then
	meta:set_string("update", "1")
	if inv:get_stack(listname,index):get_name()~=inv2:get_stack("main",nr):get_name() and inv:get_stack(listname,index):get_name()~=inv2:get_stack("main",nr):get_count() then
			return 0
end
	end
	if player:get_player_name()==meta:get_string("owner") then
	if listname=="sell" or listname=="storage2" or listname=="storage" or listname=="money" then
		inv2:set_stack("main",nr,ItemStack(nil))
	end
		return stack:get_count()
	else
local price=technic_shops.money[inv:get_stack("price",1):get_name()]
if price==nil or price==0 then
return 0
else
 price=price*inv:get_stack("price",1):get_count()
end
local pyd=0
if meta:get_string("payed"..player:get_player_name())~=nil then
pyd=tonumber(meta:get_string("payed"..player:get_player_name()))
if pyd==nil then
return 0
end
end
if (listname=="sell") and pyd<price then
			local inv3=player:get_inventory()
			local cardnr=0
			local card=0
			for i,stack in ipairs(inv3:get_list("main")) do
			cardnr=cardnr+1
				if string.sub(stack:get_name(), 0, 21) == "technic_shops:ec_card" then
					card=cardnr
				end
			if card>0 then
				break
			end
			end
if card>0 then
			local cardst=inv3:get_stack("main",card)
			local meta4=cardst:get_metadata()
			local meta5=nil
			local inv5=nil
			if meta4~=nil then
				meta5=minetest.env:get_meta(minetest.string_to_pos(meta4))
				inv5=meta5:get_inventory()
			end				
			if meta5:get_string("owner")==player:get_player_name()
				and(inv5:contains_item("main",inv:get_stack("price",1)) and inv:room_for_item("money",inv:get_stack("price",1))) then
			inv5:remove_item("main",inv:get_stack("price",1))
			inv:add_item("money",inv:get_stack("price",1))
			if meta5:get_string("owner")~=player:get_player_name() then
			minetest.log("action", player:get_player_name()..
				" buys "..tostring(stc).." "..stack:get_name().." for "
				..tostring(inv:get_stack("price",1):get_count()).." "..inv:get_stack("price",1):get_name().." with an EC-Card at "..
				minetest.pos_to_string(pos))
			end
			meta:set_string("update", "1")
			return stc
			end			

end
end
if (listname=="sell") and meta:get_string("payed"..player:get_player_name())==nil then
return 0
end
if (listname=="sell") and tonumber(meta:get_string("payed"..player:get_player_name()))>=price then
	local payed=tonumber(meta:get_string("payed"..player:get_player_name()))
	meta:set_string("payed"..player:get_player_name(),tostring(payed-price))
		if inv:contains_item("storage3",stack) or inv:contains_item("storage2",ItemStack(stack:get_name().." "..tostring(stack:get_count()))) then
			local store=0
			for i=1,inv:get_size("storage"),1 do
				local stx=inv2:get_stack("main", (i-1)*8+5)
				if stx:get_count() > stack:get_count() then
					inv2:set_stack("main", (i-1)*8+5,ItemStack(stack:get_name().." "..tostring(stx:get_count()-stack:get_count())))
					store=1
					break;
				end
			end			
			if store==0 then
				for i=1,inv:get_size("storage2"),1 do
					local stx=inv2:get_stack("main", i+32)
					if stx:get_count() == stack:get_count() then
						inv2:set_stack("main", i+32, nil)
					elseif stx:get_count() > stack:get_count() then
						inv2:set_stack("main", i+32,ItemStack(stack:get_name().." "..tostring(stx:get_count()-stack:get_count())))
						break;
					end
				end
			end			
		else
			inv2:set_stack("main",nr,ItemStack(nil))
		end
			if meta:get_string("owner")~=player:get_player_name() then
			minetest.log("action", player:get_player_name()..
				" buys "..tostring(stc).." "..stack:get_name().." for "
				..tostring(inv:get_stack("price",1):get_count()).." "..inv:get_stack("price",1):get_name().." at "..
				minetest.pos_to_string(pos))
			end
		return stack:get_count()
else
if (listname=="money") and meta:get_string("payed"..player:get_player_name())==nil then
return 0
end
if (listname=="money") and tonumber(meta:get_string("payed"..player:get_player_name()))>=0 and inv:get_stack("money",index):get_count()>0 then
if technic_shops.money[stack:get_name()]~=nil and technic_shops.money[stack:get_name()]>0 then
local payed=tonumber(meta:get_string("payed"..player:get_player_name()))
if technic_shops.money[stack:get_name()]<=payed then
	meta:set_string("payed"..player:get_player_name(),tostring(payed-math.floor(payed/technic_shops.money[stack:get_name()])))
	inv2:set_stack("main",nr,ItemStack(stack:get_name().." "..tostring(inv2:get_stack("main",nr,ItemStack(stack:get_count()-math.floor(payed/technic_shops.money[stack:get_name()]))))))
		return math.floor(payed/technic_shops.money[stack:get_name()])
end
end
end
		end
end
			return 0
	end,

})


technic_shops.transfer_items=function(meta2,meta)
local inv=meta:get_inventory()
local inv2=meta2:get_inventory()
		for i=1,inv:get_size("sell"),1 do
			inv:set_stack("sell",i,inv2:get_stack("main", math.floor(i/4-0.01)*8+i-math.floor(i/4-0.01)*4))
		end
		for i=1,inv:get_size("money"),1 do
			inv:set_stack("money",i,inv2:get_stack("main", math.floor(i/3-0.01)*8+5+i-math.floor(i/3-0.01)*3))
		end
		for i=1,inv:get_size("storage"),1 do
			inv:set_stack("storage",i,inv2:get_stack("main", (i-1)*8+5))
			inv:set_stack("storage3",i,inv2:get_stack("main", (i-1)*8+5):get_name())
		end
	local size=inv2:get_size("main")
		if size>32 then
			local rsize=0
			for i=1,size-32,1 do
			local sst=inv2:get_stack("main", i+32)
			if sst:get_count()>0 then
			inv:set_stack("storage2",i,sst)
if i+32~=rsize+33 then
			inv2:set_stack("main",i+32,nil)
			inv2:set_stack("main",rsize+33,sst)
end
			rsize=rsize+1
			end
			end
			for i=rsize+1,size-32,1 do
			inv:set_stack("storage2",i,nil)
			end
			if (math.floor(rsize/4)+1)*4+32>size then
			rsize=rsize-4
			end
			rsize=(math.floor(rsize/4)+1)*4
			if rsize>20 then
			rsize=20
			end
			meta:set_string("storage2", tostring(rsize))
		end
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name=player:get_player_name()

	if string.sub(formname,1,27+string.len(name))=="technic_shops:traders_scale"..name then
local x=tonumber(string.sub(formname,28+string.len(name),33+string.len(name)))
local y=tonumber(string.sub(formname,34+string.len(name),39+string.len(name)))
local z=tonumber(string.sub(formname,40+string.len(name),45+string.len(name)))
local pos={x=x,y=y,z=z}

	local meta = minetest.env:get_meta(pos)
	local inv = meta:get_inventory()
	if name==meta:get_string("owner") and fields["mode"] then
		if meta:get_string("mode")=="buy" then
		meta:set_string("mode","sell")
		else
		meta:set_string("mode","buy")
		end
		minetest.show_formspec(
			name,
			formname,
			technic_shops.traders_scale_formspec(meta,name)
		)
		return true
	end
	if name==meta:get_string("owner") then
		if fields["g1"] then
		meta:set_string("alt1",tostring(tonumber(meta:get_string("alt1"))+1))
		meta:set_string("update","1")
		elseif fields["g2"] then
		meta:set_string("alt2",tostring(tonumber(meta:get_string("alt2"))+1))
		meta:set_string("update","1")
		elseif fields["g3"] then
		meta:set_string("alt3",tostring(tonumber(meta:get_string("alt3"))+1))
		meta:set_string("update","1")
		elseif fields["g4"] then
		meta:set_string("alt4",tostring(tonumber(meta:get_string("alt4"))+1))
		meta:set_string("update","1")
		end
		local nr1=fields.nr1
		if nr1~=nil then
		meta:set_string("nr1",tostring(nr1))
		end				
		local nr2=fields.nr2
		if nr2~=nil then
		meta:set_string("nr2",tostring(nr2))
		end				
		local nr3=fields.nr3
		if nr3~=nil then
		meta:set_string("nr3",tostring(nr3))
		end				
		local nr4=fields.nr4
		if nr4~=nil then
		meta:set_string("nr4",tostring(nr4))
		end				
	end
	if meta:get_string("update")=="1" and meta:get_string("chest")~=nil then
		meta:set_string("update","0")
		for i=1,inv:get_size("sell"),1 do
			inv:set_stack("sell", i,nil)
		end
		for i=1,inv:get_size("money"),1 do
			inv:set_stack("money", i, nil)
		end
		for i=1,inv:get_size("storage"),1 do
			inv:set_stack("storage", i, nil)
			inv:set_stack("storage3", i, nil)
		end
		for i=1,inv:get_size("storage2"),1 do
			inv:set_stack("storage2", i, nil)
		end
		
--minetest.after(0.8,function(meta,pos,name)
		local x=meta:get_string("chestx")
		local y=meta:get_string("chesty")
		local z=meta:get_string("chestz")
		local meta2=minetest.get_meta({x=tonumber(x),y=tonumber(y),z=tonumber(z)})
		technic_shops.transfer_items(meta2,meta)
		local xx=string.sub("      "..tostring(pos.x),string.len(tostring(pos.x))+1,6+string.len(tostring(pos.x)))
local yy=string.sub("      "..tostring(pos.y),string.len(tostring(pos.y))+1,6+string.len(tostring(pos.y)))
local zz=string.sub("      "..tostring(pos.z),string.len(tostring(pos.z))+1,6+string.len(tostring(pos.z)))

			minetest.show_formspec(
				name,
				"technic_shops:traders_scale"..name..xx..yy..zz,
				technic_shops.traders_scale_formspec(meta,name)
			)
--		end,meta,pos,name)
	end
		if fields["quit"] then

		for i=1,inv:get_size("sell"),1 do
			inv:set_stack("sell", i, nil)
		end
		for i=1,inv:get_size("money"),1 do
			inv:set_stack("money", i, nil)
		end
		for i=1,inv:get_size("storage"),1 do
			inv:set_stack("storage", i, nil)
			inv:set_stack("storage3", i, nil)
		end
		for i=1,inv:get_size("storage2"),1 do
			inv:set_stack("storage2", i, nil)
		end
		end
	end
end)


technic_shops.find_chest=function(pos)
local meta2=minetest.get_meta(pos)
local meta=minetest.get_meta({x=pos.x,y=pos.y-1,z=pos.z})
local inv=meta:get_inventory()
if inv~=nil and (meta:get_string("owner")==nil or meta:get_string("owner")=="" or meta:get_string("owner")==meta2:get_string("owner")) then
if inv:get_size("main")>=32 then
meta2:set_string("chestx", tostring(pos.x))
meta2:set_string("chesty", tostring(pos.y-1))
meta2:set_string("chestz", tostring(pos.z))
return tostring(pos.x)..","..tostring(pos.y-1)..","..tostring(pos.z)
end
end
local facedir=minetest.get_node(pos).param2
local dir=minetest.facedir_to_dir((facedir+3)%4)
meta=minetest.get_meta({x=pos.x+dir.x,y=pos.y,z=pos.z+dir.z})
inv=meta:get_inventory()
if inv~=nil and (meta:get_string("owner")==nil or meta:get_string("owner")=="" or meta:get_string("owner")==meta2:get_string("owner")) then
if inv:get_size("main")>=32 then
meta2:set_string("chestx", tostring(pos.x+dir.x))
meta2:set_string("chesty", tostring(pos.y))
meta2:set_string("chestz", tostring(pos.z+dir.z))
return tostring(pos.x+dir.x)..","..tostring(pos.y)..","..tostring(pos.z+dir.z)
end
end
dir=minetest.facedir_to_dir((facedir+1)%4)
meta=minetest.get_meta({x=pos.x+dir.x,y=pos.y,z=pos.z+dir.z})
inv=meta:get_inventory()
if inv~=nil and (meta:get_string("owner")==nil or meta:get_string("owner")=="" or meta:get_string("owner")==meta2:get_string("owner")) then
if inv:get_size("main")>=32 then
meta2:set_string("chestx", tostring(pos.x+dir.x))
meta2:set_string("chesty", tostring(pos.y))
meta2:set_string("chestz", tostring(pos.z+dir.z))
return tostring(pos.x+dir.x)..","..tostring(pos.y)..","..tostring(pos.z+dir.z)
end
end
dir=minetest.facedir_to_dir((facedir))
meta=minetest.get_meta({x=pos.x+dir.x,y=pos.y,z=pos.z+dir.z})
inv=meta:get_inventory()
if inv~=nil and (meta:get_string("owner")==nil or meta:get_string("owner")=="" or meta:get_string("owner")==meta2:get_string("owner")) then
if inv:get_size("main")>=32 then
meta2:set_string("chestx", tostring(pos.x+dir.x))
meta2:set_string("chesty", tostring(pos.y))
meta2:set_string("chestz", tostring(pos.z+dir.z))
return tostring(pos.x+dir.x)..","..tostring(pos.y)..","..tostring(pos.z+dir.z)
end
end
meta2:set_string("chestx", "")
meta2:set_string("chesty", "")
meta2:set_string("chestz", "")

return ""
end

technic_shops.traders_scale_formspec=function(meta,player)
		local inv = meta:get_inventory()
local chest=meta:get_string("chest")
local nodepos=meta:get_string("nodepos")
local formspec= ""
local ssize=tonumber(meta:get_string("storage2"))
if meta:get_string("owner")~=player then
formspec=formspec.."invsize[8.2,11;]"
else
formspec=formspec.."invsize["..tostring(9.35+math.floor(1+(ssize-2)/4))..",11;]"
end
formspec=formspec..
		"label[0,0;Traders Scale]"..
		 "button_exit["..tostring(7.4+math.floor(1+(ssize-2)/4))..",0;1,0.8;button1;ESC]"..
		"list[nodemeta:"..nodepos..";price;"..tostring(6.2+math.floor(1+(ssize-2)/4))..",0;1,1;]"..
		"label["..tostring(3.7+math.floor(1+(ssize-2)/4))..",0;Price for one slot:]"..
		"list[current_player;main;0.1,7;8,4;]"
if chest=="" then
formspec=formspec.."label[0,3.7;No chest with >=32 slots under, beside or behind Traders Scale!]"
else
if meta:get_string("mode")=="sell" then
formspec=formspec.."label[0,0.6;Pay the price first on right side,]"..
		"label[0,1;then take a stack from left side]"..
		"label[0,1.7;Offered Goods]"..
		"list[nodemeta:"..nodepos..";sell;0,2.5;4,4;]"
if meta:get_string("owner")~=player then
formspec=formspec.."label[5,1.7;Money]"..
		"list[nodemeta:"..nodepos..";money;4.9,2.5;3,4;]"
else
formspec=formspec.."label["..tostring(7.3+math.floor(1+(ssize-2)/4))..",1.1;Sell Items]"
		.."button["..tostring(6+math.floor(1+(ssize-2)/4))..",1.1;1.35,0.8;mode;Mode:]"..

		"label[4.2,1.7;Money]"..
		"list[nodemeta:"..nodepos..";money;4.15,2.5;3,4;]"..
		"label[7.5,1.7;Storage]"..
		"list[nodemeta:"..nodepos..";storage;7.5,2.5;1,4;]"
if ssize>1 then
formspec=formspec.."list[nodemeta:"..nodepos..";storage2;8.5,2.5;"..tostring(1+math.floor((ssize-1)/4))..",4;]"



end
end
else
formspec=formspec.."label[0,0.6;Put your items in a free slot,]"..
		"label[0,1;then you will receive money for it.]"..
		"label[2,1.7;Item Slots]"..
		"list[nodemeta:"..nodepos..";sell;2,2.5;4,4;]"..
		"label[0,1.7;Wanted Items]"
local groups=minetest.registered_items[inv:get_stack("storage",1):get_name()].groups
local gi1=0
local alt1=tonumber(meta:get_string("alt1"))
local grp1=""
if groups~=nil then
for group,v in pairs(groups) do
if v>0 and group~="not_in_craft_guide" and group~="not_in_creative_inventory" then
gi1=gi1+1
if alt1==1 then
if gi1==1 then
grp1=grp1..group
else
grp1=grp1..","..group
end
elseif alt1>1 and alt1-1==gi1 then
grp1=group
end
end
end
end
if gi1>1 then
gi1=gi1+1
end
groups=minetest.registered_items[inv:get_stack("storage",2):get_name()].groups
local gi2=0
local alt2=tonumber(meta:get_string("alt2"))
local grp2=""
if groups~=nil then
for group,v in pairs(groups) do
if v>0 and group~="not_in_craft_guide" and group~="not_in_creative_inventory" then
gi2=gi2+1
if alt2==1 then
if gi2==1 then
grp2=grp2..group
else
grp2=grp2..","..group
end
elseif alt2>1 and alt2-1==gi2 then
grp2=group
end
end
end
end
if gi2>1 then
gi2=gi2+1
end
groups=minetest.registered_items[inv:get_stack("storage",3):get_name()].groups
local gi3=0
local alt3=tonumber(meta:get_string("alt3"))
local grp3=""
if groups~=nil then
for group,v in pairs(groups) do
if v>0 and group~="not_in_craft_guide" and group~="not_in_creative_inventory" then
gi3=gi3+1
if alt3==1 then
if gi3==1 then
grp3=grp3..group
else
grp3=grp3..","..group
end
elseif alt3>1 and alt3-1==gi3 then
grp3=group
end
end
end
end
if gi3>1 then
gi3=gi3+1
end
groups=minetest.registered_items[inv:get_stack("storage",4):get_name()].groups
local gi4=0
local alt4=tonumber(meta:get_string("alt4"))
local grp4=""
if groups~=nil then
for group,v in pairs(groups) do
if v>0 and group~="not_in_craft_guide" and group~="not_in_creative_inventory" then
gi4=gi4+1
if alt4==1 then
if gi4==1 then
grp4=grp4..group
else
grp4=grp4..","..group
end
elseif alt4>1 and alt4-1==gi4 then
grp4=group
end
end
end
end
if gi4>1 then
gi4=gi4+1
end
meta:set_string("altt1",grp1)
meta:set_string("altt2",grp2)
meta:set_string("altt3",grp3)
meta:set_string("altt4",grp4)
if meta:get_string("owner")~=player then
formspec=formspec.."label[0.9,2.85;"..meta:get_string("nr1").."]"
		.."label[0.9,3.85;"..meta:get_string("nr2").."]"
		.."label[0.9,4.85;"..meta:get_string("nr3").."]"
		.."label[0.9,5.85;"..meta:get_string("nr4").."]"
if tonumber(meta:get_string("alt1")) > gi1+1 then
formspec=formspec .."list[nodemeta:"..nodepos..";storage3;0,2.5;1,1;]"
elseif tonumber(meta:get_string("alt1")) > 0 then
formspec=formspec .."item_image_button[0,2.5;1,1;"..inv:get_stack("storage3",1):get_name()..";t_758g1;group]"
		.."tooltip[t_758g1;"..string.upper(string.sub(grp1,1,1))..string.sub(grp1.." ",2).."]"
else
formspec=formspec .."list[nodemeta:"..nodepos..";storage3;0,2.5;1,1;]"
end
if tonumber(meta:get_string("alt2")) > gi2+1 then
formspec=formspec .."list[nodemeta:"..nodepos..";storage3;0,3.5;1,1;1]"
elseif tonumber(meta:get_string("alt2")) > 0 then
formspec=formspec .."item_image_button[0,3.5;1,1;"..inv:get_stack("storage3",2):get_name()..";t_758g2;group]"
		.."tooltip[t_758g2;"..string.upper(string.sub(grp2,1,1))..string.sub(grp2.." ",2).."]"
else
formspec=formspec .."list[nodemeta:"..nodepos..";storage3;0,3.5;1,1;1]"
end
if tonumber(meta:get_string("alt3")) > gi3+1 then
formspec=formspec .."list[nodemeta:"..nodepos..";storage3;0,4.5;1,1;2]"
elseif tonumber(meta:get_string("alt3")) > 0 then
formspec=formspec .."item_image_button[0,4.5;1,1;"..inv:get_stack("storage3",3):get_name()..";t_758g3;group]"
		.."tooltip[t_758g3;"..string.upper(string.sub(grp3,1,1))..string.sub(grp3.." ",2).."]"
else
formspec=formspec .."list[nodemeta:"..nodepos..";storage3;0,4.5;1,1;2]"
end
if tonumber(meta:get_string("alt4")) > gi4+1 then
formspec=formspec .."list[nodemeta:"..nodepos..";storage3;0,5.5;1,1;3]"
elseif tonumber(meta:get_string("alt4")) > 0 then
formspec=formspec .."item_image_button[0,5.5;1,1;"..inv:get_stack("storage3",4):get_name()..";t_758g4;group]"
		.."tooltip[t_758g4;"..string.upper(string.sub(grp4,1,1))..string.sub(grp4.." ",2).."]"
else
formspec=formspec .."list[nodemeta:"..nodepos..";storage3;0,5.5;1,1;3]"
end

else
local z=0
if meta:get_string("nr1")==nil or meta:get_string("nr1")=="" or meta:get_string("nr1")=="0" then
z=inv:get_stack("storage",1):get_count()
meta:set_string("nr1",tostring(z))
meta:set_string("alt1","0")
end
if meta:get_string("nr2")==nil or meta:get_string("nr2")=="" or meta:get_string("nr2")=="0" then
z=inv:get_stack("storage",2):get_count()
meta:set_string("nr2",tostring(z))
meta:set_string("alt2","0")
end
if meta:get_string("nr3")==nil or meta:get_string("nr3")=="" or meta:get_string("nr3")=="0" then
z=inv:get_stack("storage",3):get_count()
meta:set_string("nr3",tostring(z))
meta:set_string("alt3","0")
end
if meta:get_string("nr4")==nil or meta:get_string("nr4")=="" or meta:get_string("nr4")=="0" then
z=inv:get_stack("storage",4):get_count()
meta:set_string("nr4",tostring(z))
meta:set_string("alt4","0")
end
formspec=formspec.."field[1.2,2.9;0.8,0.8;nr1;;"..meta:get_string("nr1").."]"
		.."field[1.2,3.9;0.8,0.8;nr2;;"..meta:get_string("nr2").."]"
		.."field[1.2,4.9;0.8,0.8;nr3;;"..meta:get_string("nr3").."]"
		.."field[1.2,5.9;0.8,0.8;nr4;;"..meta:get_string("nr4").."]"
if gi1>0 then
formspec=formspec .."button[1.5,2.6;0.7,0.8;g1;grp]"
end
if tonumber(meta:get_string("alt1")) > gi1 then
meta:set_string("alt1","0")
formspec=formspec .."list[nodemeta:"..nodepos..";storage;0,2.5;1,1;]"
elseif tonumber(meta:get_string("alt1")) > 0 then
formspec=formspec .."item_image_button[0,2.5;1,1;"..inv:get_stack("storage",1):get_name()..";t_758g1;group]"
		.."tooltip[t_758g1;"..string.upper(string.sub(grp1,1,1))..string.sub(grp1.." ",2).."]"
else
formspec=formspec .."list[nodemeta:"..nodepos..";storage;0,2.5;1,1;]"
end
if gi2>0 then
formspec=formspec.."button[1.5,3.6;0.7,0.8;g2;grp]"
end
if tonumber(meta:get_string("alt2")) > gi2 then
meta:set_string("alt2","0")
formspec=formspec .."list[nodemeta:"..nodepos..";storage;0,3.5;1,1;1]"
elseif tonumber(meta:get_string("alt2")) > 0 then
formspec=formspec .."item_image_button[0,3.5;1,1;"..inv:get_stack("storage",2):get_name()..";t_758g2;group]"
		.."tooltip[t_758g2;"..string.upper(string.sub(grp2,1,1))..string.sub(grp2.." ",2).."]"
else
formspec=formspec .."list[nodemeta:"..nodepos..";storage;0,3.5;1,1;1]"
end
if gi3>0 then
formspec=formspec.."button[1.5,4.6;0.7,0.8;g3;grp]"
end
if tonumber(meta:get_string("alt3")) > gi3 then
meta:set_string("alt3","0")
formspec=formspec .."list[nodemeta:"..nodepos..";storage;0,4.5;1,1;2]"
elseif tonumber(meta:get_string("alt3")) > 0 then
formspec=formspec .."item_image_button[0,4.5;1,1;"..inv:get_stack("storage",3):get_name()..";t_758g3;group]"
		.."tooltip[t_758g3;"..string.upper(string.sub(grp3,1,1))..string.sub(grp3.." ",2).."]"
else
formspec=formspec .."list[nodemeta:"..nodepos..";storage;0,4.5;1,1;2]"
end
if gi4>0 then
formspec=formspec.."button[1.5,5.6;0.7,0.8;g4;grp]"
end
if tonumber(meta:get_string("alt4")) > gi4 then
meta:set_string("alt4","0")
formspec=formspec .."list[nodemeta:"..nodepos..";storage;0,5.5;1,1;3]"
elseif tonumber(meta:get_string("alt4")) > 0 then
formspec=formspec .."item_image_button[0,5.5;1,1;"..inv:get_stack("storage",4):get_name()..";t_758g4;group]"
		.."tooltip[t_758g4;"..string.upper(string.sub(grp4,1,1))..string.sub(grp4.." ",2).."]"
else
formspec=formspec .."list[nodemeta:"..nodepos..";storage;0,5.5;1,1;3]"
end
formspec=formspec.."label["..tostring(7.3+math.floor(1+(ssize-2)/4))..",1.1;Buy Items]"
		.."button["..tostring(6+math.floor(1+(ssize-2)/4))..",1.1;1.35,0.8;mode;Mode:]"..

		"label[6.2,1.7;Money]"..
		"list[nodemeta:"..nodepos..";money;6.15,2.5;3,4;]"
if ssize>1 then
formspec=formspec.."label[9.25,1.7;Storage]"..
"list[nodemeta:"..nodepos..";storage2;9.25,2.5;"..tostring(1+math.floor((ssize-1)/4))..",4;]"



end
end

end
end
return formspec
end

minetest.register_craft({
	output = 'technic_shops:traders_scale',
	recipe = {
		{'default:steel_ingot', 'group:stick', 'default:steel_ingot'},
		{'', 'default:gold_ingot', ''},
		{'default:gold_ingot', '', 'default:gold_ingot'},
	}
})

minetest.register_tool("technic_shops:ec_card", {
	description = "EC Card",
	inventory_image = "technic_shops_ec_card.png",

})

minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
	if puncher:get_wielded_item():get_name() == "technic_shops:ec_card" then
		local name=puncher:get_player_name()
		local meta=minetest.get_meta(pos)
		if meta~=nil then
			local inv=meta:get_inventory()
			if inv~=nil then
				local owner=meta:get_string("owner")
				if owner==name then
					local inv2=puncher:get_inventory()
					local card=ItemStack(puncher:get_wielded_item())
					card:set_metadata(minetest.pos_to_string(pos))
					minetest.chat_send_player(name,"EC-Card is connected to locked chest at "..minetest.pos_to_string(pos))
				end
			else
				minetest.chat_send_player(name,"Click with the EC-Card on a locked chest!")
			end
		else
			minetest.chat_send_player(name,"Click with the EC-Card on a locked chest!")
		end
	end
end)

minetest.register_craft({
	output = 'technic_shops:ec_card',
	recipe = {
		{'homedecor:ic', 'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting'},
		{'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting', 'homedecor:plastic_sheeting'},
	}
})

minetest.register_node("technic_shops:lv_slot_machine", {
	description = "LV Slot Machine",
	tiles = {"technic_shops_slot_machine_top.png",  "technic_compressor_bottom.png",
	         "technic_shops_slot_machine_side.png", "technic_shops_slot_machine_side.png",
	         "technic_shops_slot_machine_side.png", "technic_shops_slot_machine_front.png" 
},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	groups = {cracky=3},
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Slot Machine (owned by "..
				meta:get_string("owner")..")")
	end,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("sell", 4*4)
		inv:set_size("storage", 1*4)
		inv:set_size("storage3", 1*4)
		inv:set_size("storage2", 20)
		inv:set_size("money", 9*5)
		meta:set_string("owner", "")
		meta:set_string("infotext", "Slot Machine")
		meta:set_string("chest", technic_shops.find_chest(pos))
		meta:set_string("nodepos",tostring(pos.x)..","..tostring(pos.y)..","..tostring(pos.z))
--		meta:set_string("formspec", technic_shops.traders_scale_formspec(meta))

	end,

	on_dig = function(pos, node, digger)
		if digger==nil then
		 return false
		end
		if minetest.is_protected(pos, digger:get_player_name()) then
		 return false
		end
	end,
	on_rightclick = function(pos, node, clicker)
		local meta = minetest.get_meta(pos)
		local inv=meta:get_inventory()
		if meta:get_string("chest")=="" then
		meta:set_string("chest", technic_shops.find_chest(pos))
--		meta:set_string("formspec", technic_shops.traders_scale_formspec(meta))
		else
		local chest=meta:get_string("chest")
local x=meta:get_string("chestx")
local y=meta:get_string("chesty")
local z=meta:get_string("chestz")

local meta2=minetest.get_meta({x=tonumber(x),y=tonumber(y),z=tonumber(z)})
local inv2=meta2:get_inventory()
if inv2==nil then
		meta:set_string("chest", technic_shops.find_chest(pos))
--		meta:set_string("formspec", technic_shops.traders_scale_formspec(meta))
		if meta:get_string("chest")~="" then
		chest=meta:get_string("chest")
local x=meta:get_string("chestx")
local y=meta:get_string("chesty")
local z=meta:get_string("chestz")

meta2=minetest.get_meta({x=tonumber(x),y=tonumber(y),z=tonumber(z)})
inv2=meta2:get_inventory()
end
elseif inv2:get_size("main")<32 then
		meta:set_string("chest", technic_shops.find_chest(pos))
--		meta:set_string("formspec", technic_shops.traders_scale_formspec(meta))
		if meta:get_string("chest")~="" then
		chest=meta:get_string("chest")
local x=meta:get_string("chestx")
local y=meta:get_string("chesty")
local z=meta:get_string("chestz")

meta2=minetest.get_meta({x=tonumber(x),y=tonumber(y),z=tonumber(z)})
inv2=meta2:get_inventory()
end
		end
--if inv2~=nil then
--if inv2:get_size("main")>=32 then

--	technic_shops.transfer_items(meta2,meta)
--		end
--end
end
local xx=string.sub("      "..tostring(pos.x),string.len(tostring(pos.x))+1,6+string.len(tostring(pos.x)))
local yy=string.sub("      "..tostring(pos.y),string.len(tostring(pos.y))+1,6+string.len(tostring(pos.y)))
local zz=string.sub("      "..tostring(pos.z),string.len(tostring(pos.z))+1,6+string.len(tostring(pos.z)))

			minetest.show_formspec(
				clicker:get_player_name(),
				"technic_shops:slot_machine"..clicker:get_player_name()..xx..yy..zz,
				technic_shops.slot_machine_formspec(meta,clicker:get_player_name())
			)
end,

	
})

technic_shops.slot_machine_formspec=function(meta,player)
local chest=meta:get_string("chest")
local nodepos=meta:get_string("nodepos")
local x=meta:get_string("chestx")
local y=meta:get_string("chesty")
local z=meta:get_string("chestz")

		local a,b=string.find(chest,",")
		local x=string.sub(chest,1,b-1)
		local c,d=string.find(chest,",",b+1)
		local y=string.sub(chest,b+1,d-1)
		a,b=string.find(chest,",",d+1)
		local z=string.sub(chest,d+1,string.len(chest))

local meta2=minetest.get_meta({x=tonumber(x),y=tonumber(y),z=tonumber(z)})
local inv2=meta2:get_inventory()

local formspec= ""
formspec=formspec.."invsize[8,11;]"
return formspec
end

--minetest.register_craft({
--	output = 'technic_shops:lv_slot_machine',
--	recipe = {
--		{'technic:carbon_steel_ingot', 'technic:iron_locked_chest', 'technic:carbon_steel_ingot'},
--		{'technic_shops:traders_scale', 'mesecons_luacontroller:luacontroller0000', 'technic_shops:traders_scale'},
--		{'technic:carbon_steel_ingot', 'technic:lv_cable0', 'technic:carbon_steel_ingot'},
--	}
--})
