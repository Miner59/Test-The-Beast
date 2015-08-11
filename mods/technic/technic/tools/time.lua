local lasttime = "default"
local huddd={}
local hudxx={}
local hudyy={}

minetest.register_tool("technic:clock", {
	description = ("Clock"),
	inventory_image = "technic_clock.png",
	on_use = function(itemstack, user)
local state="off"
local wear=itemstack:get_wear()
if wear+65535/2920 > 65535 then
local broken=true
local a=0
if user:get_inventory()~=nil then
for i,stack in ipairs(user:get_inventory():get_list("main")) do
	if string.sub(stack:get_name(), 0, 13) == "technic:clock" then
a=a+1
end
end
end
if a>1 then
broken=false
end
if broken then
player:hud_remove(huddd[player:get_player_name()])
huddd[player:get_player_name()]=nil
return ItemStack(nil)
end
end
if huddd[user:get_player_name()]==nil then
state="on"
itemstack:set_wear (wear+65535/2920) --365*8, clock breaks after one year
end
if state=="on" then
	local now = minetest.env:get_timeofday() * 24
if now>=22 then
now=22
elseif now>=20 then
now=20
elseif now>=18 then
now=18
elseif now>=15 then
now=15
elseif now>=9 then
now=9
elseif now>=6 then
now=6
elseif now>=4 then
now=4
elseif now>=2 then
now=2
else 
now=22
end
local xx=hudxx[user:get_player_name()]
local yy=hudyy[user:get_player_name()]
if xx==nil or yy==nil then
	xx=0.502
	yy=0.872
end
huddd[user:get_player_name()] = user:hud_add({
    hud_elem_type = "image",
    position = {x=xx,y=yy},
    scale = {x=1, y=1},
    text = "technic_clock_"..tostring(now)..".png",
    alignment = {x=0,y=0},
    offset = {x=0, y=0},
})
else
local xx=hudxx[user:get_player_name()]
local yy=hudyy[user:get_player_name()]
if xx==nil or yy==nil then
	xx=0.502
	yy=0.872
end
local keys = user:get_player_control()
local moving=0.025
if keys["sneak"] then
 moving=0.001 
end
if keys["up"] then
 yy=yy-moving 
end
if keys["down"] then
 yy=yy+moving 
end
if keys["left"] then
 xx=xx-moving 
end
if keys["right"] then
 xx=xx+moving 
end
if xx~=hudxx[user:get_player_name()] or yy~=hudyy[user:get_player_name()] then
if xx<0 then xx=0 end
if xx>0.995 then xx=0.995 end
if yy<0 then yy=0 end
if yy>0.995 then yy=0.995 end
hudxx[user:get_player_name()]=xx
hudyy[user:get_player_name()]=yy
state="on"
user:hud_change(huddd[user:get_player_name()], "position",  {x=xx,y=yy})		
else
user:hud_remove(huddd[user:get_player_name()])
huddd[user:get_player_name()]=nil
end
end
for i,stack in ipairs(user:get_inventory():get_list("main")) do
	if string.sub(stack:get_name(), 0, 13) == "technic:clock" then
local item=stack
item:set_metadata(state)
user:get_inventory():set_stack("main",i,item)
end
end
itemstack:set_metadata(state)
return itemstack
end,
})

minetest.register_craft({
	output = "technic:clock",
	recipe = {
		{"", "default:gold_ingot",    ""},
		{"default:gold_ingot", "technic:battery", "default:gold_ingot"},
		{"",               "default:gold_ingot", ""}
	},
})

minetest.register_globalstep(function(dtime)
	local now = minetest.env:get_timeofday() * 24
if now>=22 then
now=22
elseif now>=20 then
now=20
elseif now>=18 then
now=18
elseif now>=15 then
now=15
elseif now>=9 then
now=9
elseif now>=6 then
now=6
elseif now>=4 then
now=4
elseif now>=2 then
now=2
else 
now=22
end
	if now ~= lasttime then
		lasttime = now
		local players  = minetest.get_connected_players()
		for i,player in ipairs(players) do

local broken=false
local seton=false
local off=false
local success=false

if player:get_inventory()~=nil then
if player:get_inventory():get_list("main")~=nil then

			for i,stack in ipairs(player:get_inventory():get_list("main")) do
				if string.sub(stack:get_name(), 0, 13) == "technic:clock" then
local item=player:get_inventory():get_stack("main", i)
if (huddd[player:get_player_name()]~=nil or item:get_metadata()=="on") and not success then
broken=false
local wear=item:get_wear()
if wear+65535/2920 > 65535 then
	item:clear()
broken=true
else
if huddd[player:get_player_name()]~=nil then
player:hud_change(huddd[player:get_player_name()], "text", "technic_clock_"..tostring(now)..".png")		
else
local xx=hudxx[player:get_player_name()]
local yy=hudyy[player:get_player_name()]
if xx==nil or yy==nil then
	xx=0.502
	yy=0.872
end
huddd[player:get_player_name()] = player:hud_add({
    hud_elem_type = "image",
    position = {x=xx,y=yy},
    scale = {x=1, y=1},
    text = "technic_clock_"..tostring(now)..".png",
    alignment = {x=0,y=0},
    offset = {x=0, y=0},
})
end
item:set_wear (wear+65535/2920) --365*8, clock breaks after one year

player:get_inventory():set_stack("main",i, item)
success=true
end
end
if item:get_metadata()=="on" then
seton=true
else
if seton then
item:set_metadata("on")
player:get_inventory():set_stack("main",i,item)
else
off=true
end
end
--			player:get_inventory():get_item("main", stack:get_name())
--					player:get_inventory():add_item("main", "technic:clock_"..now)
end
				end
if broken or not success then
player:hud_remove(huddd[player:get_player_name()])
huddd[player:get_player_name()]=nil
elseif off and success then
			for i,stack in ipairs(player:get_inventory():get_list("main")) do
				if string.sub(stack:get_name(), 0, 13) == "technic:clock" then
local item=stack
item:set_metadata("on")
player:get_inventory():set_stack("main",i,item)
end
end
end
end
end
		end
	end
end)

minetest.register_on_joinplayer(function(player)
minetest.after(0.2, function(player) 

local broken=false
local seton=false
local off=false
local success=false
huddd[player:get_player_name()]=nil
if player:get_inventory()~=nil then
if player:get_inventory():get_list("main")~= nil then
			for i,stack in ipairs(player:get_inventory():get_list("main")) do
				if string.sub(stack:get_name(), 0, 13) == "technic:clock" then
local item=player:get_inventory():get_stack("main", i)
if (huddd[player:get_player_name()]~=nil or item:get_metadata()=="on") and not success then
broken=false
local wear=item:get_wear()
if wear+65535/2920 > 65535 then
	item:clear()
broken=true
else
	local now = minetest.env:get_timeofday() * 24
if now>=22 then
now=22
elseif now>=20 then
now=20
elseif now>=18 then
now=18
elseif now>=15 then
now=15
elseif now>=9 then
now=9
elseif now>=6 then
now=6
elseif now>=4 then
now=4
elseif now>=2 then
now=2
else 
now=22
end

local xx=hudxx[player:get_player_name()]
local yy=hudyy[player:get_player_name()]
if xx==nil or yy==nil then
	xx=0.502
	yy=0.872
end
huddd[player:get_player_name()] = player:hud_add({
    hud_elem_type = "image",
    position = {x=xx,y=yy},
    scale = {x=1, y=1},
    text = "technic_clock_"..tostring(now)..".png",
    alignment = {x=0,y=0},
    offset = {x=0, y=0},
})
item:set_wear (wear+65535/2920) --365*8, clock breaks after one year

player:get_inventory():set_stack("main",i, item)
success=true
end
end
if item:get_metadata()=="on" then
seton=true
else
if seton then
item:set_metadata("on")
player:get_inventory():set_stack("main",i,item)
else
off=true
end
end
end
end
end
if broken or not success then
player:hud_remove(huddd[player:get_player_name()])
huddd[player:get_player_name()]=nil
elseif off and success then
			for i,stack in ipairs(player:get_inventory():get_list("main")) do
				if string.sub(stack:get_name(), 0, 13) == "technic:clock" then
local item=stack
item:set_metadata("on")
player:get_inventory():set_stack("main",i,item)
end
end
end
end

end,player)
end)


		minetest.register_node("technic:cuckoo_clock", {
			description = "Cuckoo Clock",
			tiles = {
				"moretrees_oak_trunk.png",
				"moretrees_oak_trunk_top.png",
				"moretrees_oak_trunk.png",
				"moretrees_oak_trunk.png",
				"moretrees_oak_trunk.png",
"technic_cuckoo_clock.png^[combine:12x12:4,3=technic_clock_9.png^technic_cuckoo_clock2.png"
			},
			paramtype2 = "facedir",
			is_ground_content = true,
			groups = {snappy=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
			sounds = default.node_sound_wood_defaults(),
		})

for i=22,2,-1 do
local now=i
if now>=22 then
now=22
elseif now>=20 then
now=20
elseif now>=18 then
now=18
elseif now>=15 then
now=15
elseif now>=9 then
now=9
elseif now>=6 then
now=6
elseif now>=4 then
now=4
elseif now>=2 then
now=2
else 
now=22
end
if i==now then
		minetest.register_node("technic:cuckoo_clock_"..tostring(now), {
			description = "Cuckoo Clock",
			tiles = {
				"moretrees_oak_trunk.png",
				"moretrees_oak_trunk_top.png",
				"moretrees_oak_trunk.png",
				"moretrees_oak_trunk.png",
				"moretrees_oak_trunk.png",
"technic_cuckoo_clock.png^[combine:12x12:4,3=technic_clock_"..tostring(now)..".png^technic_cuckoo_clock2.png"
			},
			paramtype2 = "facedir",
			is_ground_content = true,
			groups = {snappy=1,choppy=2,oddly_breakable_by_hand=1,flammable=2,not_in_craft_guide=1,not_in_creative_inventory=1,cuckoo_clock=1},
			sounds = default.node_sound_wood_defaults(),
		})


end
end

minetest.register_abm({
	nodenames = {"technic:cuckoo_clock"}, --only new built clocks
	interval = 1,
	chance = 1,
	action = function(pos, node)
local now = minetest.env:get_timeofday() * 24
if now>=22 then
now=22
elseif now>=20 then
now=20
elseif now>=18 then
now=18
elseif now>=15 then
now=15
elseif now>=9 then
now=9
elseif now>=6 then
now=6
elseif now>=4 then
now=4
elseif now>=2 then
now=2
else 
now=22
end
minetest.set_node(pos, {name = "technic:cuckoo_clock_"..tostring(now),param2=node.param2})
end
})


minetest.register_abm({
	nodenames = {"group:cuckoo_clock"},
	interval = math.floor(3600/(minetest.setting_get("time_speed") or 72)),
	chance = 1,
	action = function(pos, node)
		local lasttime = tonumber(string.sub(node.name,22))
local now = minetest.env:get_timeofday() * 24
if now>=22 then
now=22
elseif now>=20 then
now=20
elseif now>=18 then
now=18
elseif now>=15 then
now=15
elseif now>=9 then
now=9
elseif now>=6 then
now=6
elseif now>=4 then
now=4
elseif now>=2 then
now=2
else 
now=22
end
if now~=lasttime then
minetest.set_node(pos, {name = "technic:cuckoo_clock_"..tostring(now),param2=node.param2})
--play cuckoo sound in the morning 6 times
if now==6 then
minetest.after(10, function(pos) 
minetest.sound_play(
            "cuckoo",
            {
               pos = pos,
               gain = 15.0,
               max_hear_distance = 22
            });
end, pos)
minetest.after(10.9, function(pos) 
minetest.sound_play(
            "cuckoo",
            {
               pos = pos,
               gain = 15.0,
               max_hear_distance = 22
            });
end, pos)
minetest.after(11.8, function(pos) 
minetest.sound_play(
            "cuckoo",
            {
               pos = pos,
               gain = 15.0,
               max_hear_distance = 22
            });
end, pos)
minetest.after(12.7, function(pos) 
minetest.sound_play(
            "cuckoo",
            {
               pos = pos,
               gain = 15.0,
               max_hear_distance = 22
            });
end, pos)
minetest.after(13.6, function(pos) 
minetest.sound_play(
            "cuckoo",
            {
               pos = pos,
               gain = 15.0,
               max_hear_distance = 22
            });
end, pos)
minetest.after(14.5, function(pos) 
minetest.sound_play(
            "cuckoo",
            {
               pos = pos,
               gain = 15.0,
               max_hear_distance = 22
            });
end, pos)
end
end
	end
})





minetest.register_craft({
	output = "technic:cuckoo_clock",
	recipe = {
		{"moretrees:oak_trunk", "technic:clock",    "moretrees:oak_trunk"},
		{"moretrees:oak_trunk", "homedecor:chains", "moretrees:oak_trunk"},
		{"moretrees:oak_trunk", "default:steel_ingot", "moretrees:oak_trunk"}
	},
})

minetest.register_craft({

	type="fuel",
	recipe = "technic:cuckoo_clock",
	burntime = 30,

})


