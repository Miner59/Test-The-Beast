--
--Fireworks by InfinityProject
--License code and textures WTFPL 
--Thanks to Mauvebic, Cornernote, and Neuromancer

--REWRITE BY: crayzginger72 (2014)

local burndelay=5
local colours_list = {
["red"]="Red",
["green"]="Green",
["blue"]="Blue",
["violet"]="Purple",
["orange"]="Orange",
["cyan"]="Cyan",
["yellow"]="Yellow",
["pink"]="Pink",
["dark_green"]="Dark Green",
["black"]="Black",
["grey"]="Grey",
["dark_grey"]="Dark Grey",
["magenta"]="Magenta",
["brown"]="Brown",
["white"]="White",
 }

for colour,desc in pairs(colours_list) do
	if colour == "white" then 
		minetest.register_node("fireworks:white", {
			drawtype = "airlike",
			light_source = 14,
			buildable_to = true,
			sunlight_propagates = true,
			walkable = false,
			is_ground_content = false,
			pointable = false,
			groups = {not_in_creative_inventory=1, not_in_craft_guide=1},
		})

		minetest.register_abm({
			nodenames = {"fireworks:white"},
			interval =20,
			chance = 1,	
			
			action = function(pos, node, active_object_count, active_object_count_wider)
				if node.name == "fireworks:white" then
					minetest.remove_node(pos,{name="fireworks:white"})  
				end
			end
		})
	minetest.register_node("fireworks:firework", {
		description = "Fireworks",
		tiles = {"fireworks_firework.png"},
		is_ground_content = true,
		groups = {cracky=3},
		sounds = default.node_sound_stone_defaults(),
		mesecons = {effector = { action_on = function(pos, node)
			fireworks_activate(pos, node)
			end}},

		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			inv:set_size("main", 5*2)
			meta:set_string("infotext", "Firework (no dyes)")
			local formspec =
			"size[8,9]"..
		 	 "button_exit[0,0;1,0.8;button1;ESC]"..
			"list[current_name;main;1.5,1.8;5,2;]"..
			"list[current_player;main;0,5;8,4;]"
			meta:set_string("formspec", formspec)
		end,

		after_place_node = function(pos,placer)
		if placer==nil then
			return
		end
			local inv2=placer:get_inventory()
		if inv2==nil then
			return
		end
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			local c=0
			local sname=""
			for i,stack in ipairs(inv2:get_list("main")) do
			if stack~=nil then
				local name=stack:get_name()
				if string.sub(name, 0, 4) == "dye:" then
					if not inv:contains_item("main",ItemStack(name.." 1")) then
					sname=name
					c=c+1
					inv:add_item("main",ItemStack(name.." 1"))
					inv2:remove_item("main",ItemStack(name.." 1"))
					end
				end
			if i>=8 and c>0 then
				break
			end
			end
			end
			if c==1 then
			local cstr=string.sub(sname,5,sname:len())
			if cstr~=nil then
			meta:set_string("infotext", colours_list[cstr].." Firework")
			end
			elseif c>1 then
			meta:set_string("infotext", "Firework")
			end
		end,

		on_punch = function(pos, node, puncher)
		if puncher==nil then
			return
		end
			local keys = puncher:get_player_control()
			if not keys["sneak"] then
				fireworks_activate(pos, node)
else
			local inv2=puncher:get_inventory()
		if inv2==nil then
			return
		end
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			for i,stack in ipairs(inv:get_list("main")) do
			if stack~=nil then
					if inv2:room_for_item("main",stack) then
					inv2:add_item("main",stack)
					else
					minetest.env:add_item(pos, stack:get_name())
					end
				end
			end
				minetest.remove_node(pos)
					if inv2:room_for_item("main",stack) then
					inv2:add_item("main","fireworks:firework 1")
					else
					minetest.env:add_item(pos, "fireworks:firework")
					end
			end
	 	end,	
    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
	if count==1 and from_list==to_list then
		return 1
	end
	return 0
	end,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
	if stack==nil then
	return 0
	end
	if string.sub(stack:get_name(),1,4)~="dye:" then
	return 0
	end
	local meta = minetest.get_meta(pos)
	local info=meta:get_string("infotext")
	local name=stack:get_name()
	local cstr=string.sub(name,5,string.len(name))
	if info=="Firework (no dyes)" and cstr~=nil then
		meta:set_string("infotext", colours_list[cstr].." Firework")
	else
		if cstr~=nil then
		if info~=colours_list[cstr].." Firework" then
		meta:set_string("infotext", "Firework")
		end
		end
	end
	return 1
	end,

    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
	local name=""
	local z=0
	local meta = minetest.get_meta(pos)
	local inv=meta:get_inventory()
	for i,dye in ipairs(inv:get_list("main")) do
	if dye~=nil then
	if dye:get_name()==stack:get_name() and z==0 then
	z=1
	else	
		if name=="" then
			name=dye:get_name()
		elseif name~=dye:get_name() then
		return stack:get_count()
		end
	end
	end
	end
	if name=="" then
		meta:set_string("infotext", "Firework (no dyes)")
	else
		local cstr=string.sub(name,5,string.len(name))
		if cstr~=nil then
		meta:set_string("infotext", colours_list[cstr].." Firework")
		else
		meta:set_string("infotext", "Firework")
		end
	end
	return stack:get_count()
	end,

	})

	minetest.register_craft({
	output = "fireworks:firework 2",
	recipe = {
		 {"group:wood", "group:wood", "group:wood"},
		 {"group:wood", "default:torch", "group:wood"},
		 {"group:wood", "group:wood", "group:wood"}
		}
		})
	end


	minetest.register_node("fireworks:"..colour, {
		drawtype = "plantlike",
		description = desc,
		tiles = {"fireworks_"..colour..".png"},
		light_source = 14,
		sunlight_propagates = true,
		walkable = false,
		is_ground_content = true,
		pointable = false,
		groups = {cracky=3, not_in_creative_inventory=1, not_in_craft_guide=1},
		sounds = default.node_sound_stone_defaults(),
	})
		minetest.register_abm({
			nodenames = {"fireworks:"..colour},
			interval =20,
			chance = 1,	
			
			action = function(pos, node, active_object_count, active_object_count_wider)
				if node.name == "fireworks:"..colour then
					minetest.remove_node(pos,{name="fireworks:"..colour})  
				end
			end
		})

end




local function make_ps(r)
local tab = {}
local num = 1
local tmp = r*r
for x=-math.floor(r*(math.random(9,13)/10)),math.floor(r*(math.random(9,13)/10)) do
for y=-r,r do
for z=-math.floor(r*(math.random(9,13)/10)),math.floor(r*(math.random(9,13)/10)) do
if x*x+y*y+z*z <= tmp then
tab[num] = {x=x,y=y,z=z}
num = num+1
end
end
end
end
return tab
end
local fireworks_ps
local c_air = minetest.get_content_id("air")

local function show_fireworks(p, name,pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local dyes=""
	local j=0
	local same=0
	local white=0
		for i=1,inv:get_size("main"),1 do
			local stack=inv:get_stack("main", i)
			if stack~=nil and stack:get_count()>0 then
				if dyes=="" then
					dyes=string.sub(stack:get_name().."             ",1,20)
					j=j+1
				else
					if stack:get_name()=="dye:white" then
					white=(white+1)*2
					if same>0 then
						dyes=dyes..string.sub(stack:get_name().."             ",1,20)
						j=j+1
					end
					else					
					if string.find(dyes,stack:get_name()) then
						same=same+1
					end
					dyes=dyes..string.sub(stack:get_name().."             ",1,20)
					j=j+1
					end
				end
			end
		end
local mmw=5+math.floor(j/5+same/2)
local mnw=mmw-3
if mnw<3 then
	mnw=3 
end
local radius = math.random(mnw,mmw)

fireworks_ps = fireworks_ps or make_ps(radius)
local manip = minetest.get_voxel_manip()
local emerged_pos1, emerged_pos2 = manip:read_from_map(
vector.subtract(p, radius),
vector.add(p, radius)
)
local area = VoxelArea:new({MinEdge=emerged_pos1, MaxEdge=emerged_pos2})
local nodes = manip:get_data()
local id = minetest.get_content_id("fireworks:white")
local ind=0
local r_colour = "white"
local a,b=0,0
local id2 = minetest.get_content_id("fireworks:"..r_colour)
for _,i in ipairs(fireworks_ps) do
local posi = vector.add(p, i)
local p_posi = area:index(posi.x, posi.y, posi.z)
if nodes[p_posi] == c_air then
if math.random(0,3+white)>=1 then
nodes[p_posi] = id
else
if j~=0 then
if j>1 then
	ind=math.random(0,j-1)
end
r_colour = string.sub(dyes,ind*20+1,ind*20+20)
a,b=string.find(r_colour," ")
if a~=nil then
r_colour=string.sub(r_colour,5,a-1)
id2 = minetest.get_content_id("fireworks:"..r_colour)
end
end
nodes[p_posi] = id2
end
local xvel=(((posi.x-p.x)/math.abs((posi.x-p.x)*0.25))*0.45+math.random(-0.32,0.32))*math.random(0.5,1.5)
local zvel=(((posi.z-p.z)/math.abs((posi.z-p.z)*0.25))*0.45+math.random(-0.32,0.32))*math.random(0.5,1.5)
if j~=0 then
minetest.after(1.1, function(posi,pos,xvel,zvel,radius,r_colour)
							minetest.add_particle({
    								pos = {x=posi.x+math.random(-0.15,0.15),y=posi.y+math.random(-2.15,2.15),z=posi.z+math.random(-0.15,0.15)},
    								vel = {x=xvel, y=0, z=zvel},
    								acc = {x=-xvel/6, y=-0.22, z=-zvel/6},
    								expirationtime = math.random(math.floor((radius/3)+(posi.x-pos.x)/4-1), math.floor((radius/3)+(posi.x-pos.x)/4+3)) ,
    								size = math.random(3, 6),
    								collisiondetection = false,
    								vertical = false,
    								texture = "fireworks_"..r_colour..".png"
							})
end,posi,pos,xvel,zvel,radius,r_colour)
end
minetest.after((math.random()*burndelay+1.45+radius/3), function(posi)
minetest.remove_node(posi)
end, posi)
end
end
manip:set_data(nodes)
manip:write_to_map()
manip:update_map()
end
function fireworks_activate(pos, name)
local pos2 = vector.add(pos, {x=math.random(-10, 10), y=math.random(15, 45), z=math.random(-10, 10)})
show_fireworks(pos2, name,pos)
minetest.remove_node(pos)
end


print("Fireworks Mod Loaded v3.0!")
