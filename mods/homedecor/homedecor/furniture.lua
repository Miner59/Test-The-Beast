local S = homedecor.gettext

-- Test
minetest.register_node("homedecor:table", {
    description = S("Table"),
    tiles = {
        "forniture_wood.png",
        "forniture_wood.png",
        "forniture_wood_s1.png",
        "forniture_wood_s1.png",
        "forniture_wood_s2.png",
        "forniture_wood_s2.png",
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    node_box = {
        type = "fixed",
        fixed = {
            { -0.4, -0.5, -0.4, -0.3,  0.4, -0.3 },
            {  0.3, -0.5, -0.4,  0.4,  0.4, -0.3 },
            { -0.4, -0.5,  0.3, -0.3,  0.4,  0.4 },
            {  0.3, -0.5,  0.3,  0.4,  0.4,  0.4 },
            { -0.5,  0.4, -0.5,  0.5,  0.5,  0.5 },
            { -0.4, -0.2, -0.3, -0.3, -0.1,  0.3 },
            {  0.3, -0.2, -0.4,  0.4, -0.1,  0.3 },
            { -0.3, -0.2, -0.4,  0.4, -0.1, -0.3 },
            { -0.3, -0.2,  0.3,  0.3, -0.1,  0.4 },
        },
    },
    groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
})  

minetest.register_node("homedecor:chair", {
    description = S("Chair"),
    tiles = {
        "forniture_wood.png",
        "forniture_wood.png",
        "forniture_wood_s1.png",
        "forniture_wood_s1.png",
        "forniture_wood_s2.png",
        "forniture_wood_s2.png",
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    node_box = {
        type = "fixed",
        fixed = {
            { -0.3, -0.5,  0.20, -0.2,  0.5,  0.30 },
            {  0.2, -0.5,  0.20,  0.3,  0.5,  0.30 },
            { -0.3, -0.5, -0.30, -0.2, -0.1, -0.20 },
            {  0.2, -0.5, -0.30,  0.3, -0.1, -0.20 },
            { -0.3, -0.1, -0.30,  0.3,  0.0,  0.20 },
            { -0.2,  0.1,  0.25,  0.2,  0.4,  0.26 },
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3},
    },
    groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
})

local chaircolors = {
	{ "black", "Black" },
	{ "red", "Red" },
	{ "pink", "Pink" },
	{ "violet", "Violet" },
	{ "blue", "Blue" },
	{ "dark_green", "Dark Green" },
}

for i in ipairs(chaircolors) do
	local color = chaircolors[i][1]
	local name = S(chaircolors[i][2])
	minetest.register_node("homedecor:armchair_"..color, {
	    description = S("Armchair (%s)"):format(name),
	    tiles = {
		"forniture_armchair_top_"..color..".png",
		"forniture_armchair_top_"..color..".png",
		"forniture_armchair_lat1_"..color..".png",
		"forniture_armchair_lat1_"..color..".png",
		"forniture_armchair_lat2_"..color..".png",
		"forniture_armchair_lat2_"..color..".png",
	    },
	    drawtype = "nodebox",
	    sunlight_propagates = true,
	    paramtype = "light",
	    paramtype2 = "facedir",
	    node_box = {
		type = "fixed",
		fixed = {
		    { -0.50, -0.50, -0.45, -0.30,  0.05,  0.30 },
		    { -0.45, -0.50, -0.50, -0.35,  0.05, -0.45 },
		    { -0.45,  0.05, -0.45, -0.35,  0.10,  0.15 },
		    {  0.30, -0.50, -0.45,  0.50,  0.05,  0.30 },
		    {  0.35, -0.50, -0.50,  0.45,  0.05, -0.45 },
		    {  0.35,  0.05, -0.45,  0.45,  0.10,  0.15 },
		    { -0.50, -0.50,  0.30,  0.50,  0.45,  0.50 },
		    { -0.45,  0.45,  0.35,  0.45,  0.50,  0.45 },
		    { -0.30, -0.45, -0.35,  0.30, -0.10,  0.30 },
		    { -0.30, -0.45, -0.40,  0.30, -0.15, -0.35 },
		    { -0.50,  0.05,  0.15, -0.30,  0.45,  0.30 },
		    { -0.45,  0.10,  0.10, -0.35,  0.45,  0.15 },
		    { -0.45,  0.45,  0.15, -0.35,  0.50,  0.35 },
		    {  0.30,  0.05,  0.15,  0.50,  0.45,  0.30 },
		    {  0.35,  0.10,  0.10,  0.45,  0.45,  0.15 },
		    {  0.35,  0.45,  0.15,  0.45,  0.50,  0.35 },
		},
	    },
	    groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	})

	minetest.register_craft({
	    output = "homedecor:armchair_"..color.." 2",
	    recipe = {
		{ "wool:"..color,""},
		{ "group:wood","group:wood" },
		{ "wool:"..color,"wool:"..color },
	    },
	})

end

local repl = { off="low", low="med", med="hi", hi="max", max="off", }

local function reg_lamp(suffix, nxt, desc, tilesuffix, light)
	minetest.register_node("homedecor:table_lamp_"..suffix, {
	description = S(desc),
	drawtype = "nodebox",
	tiles = {
		"forniture_table_lamp_s"..tilesuffix..".png",
		"forniture_table_lamp_s"..tilesuffix..".png",
		"forniture_table_lamp_l"..tilesuffix..".png",
	},
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{ -0.1500, -0.500, -0.1500,  0.1500, -0.45,  0.1500 },
			{ -0.0500, -0.450, -0.0500,  0.0500, -0.40,  0.0500 },
			{ -0.0250, -0.400, -0.0250,  0.0250, -0.10,  0.0250 },
			{ -0.0125, -0.125, -0.2000,  0.0125, -0.10,  0.2000 },
			{ -0.2000, -0.125, -0.0125,  0.2000, -0.10,  0.0125 },
			{ -0.2000, -0.100, -0.2000, -0.1750,  0.30,  0.2000 },
			{  0.1750, -0.100, -0.2000,  0.2000,  0.30,  0.2000 },
			{ -0.1750, -0.100, -0.2000,  0.1750,  0.30, -0.1750 },
			{ -0.1750, -0.100,  0.1750,  0.1750,  0.30,  0.2000 },
		},
	},
	walkable = false,
	light_source = light,
	selection_box = {
		type = "fixed",
		fixed = { -0.2, -0.5, -0.2, 0.2, 0.30, 0.2 },
	},
	groups = {cracky=2,oddly_breakable_by_hand=1,
		not_in_creative_inventory=((desc == nil) and 1) or nil,
	},
	drop = "homedecor:table_lamp_off",
	on_punch = function(pos, node, puncher)
		node.name = "homedecor:table_lamp_"..repl[suffix]
		minetest.set_node(pos, node)
		nodeupdate(pos)
	end,
	})
	minetest.register_alias("3dforniture:table_lamp_"..suffix, "homedecor:table_lamp_"..suffix)
end

local tmp = {}

minetest.register_entity("homedecor:item",{
	hp_max = 1,
	visual="wielditem",
	visual_size={x=.33,y=.33},
	collisionbox = {0,0,0,0,0,0},
	physical=false,
	textures={"air"},
	on_activate = function(self, staticdata)
		if tmp.nodename ~= nil and tmp.texture ~= nil then
			self.nodename = tmp.nodename
			tmp.nodename = nil
			self.texture = tmp.texture
			tmp.texture = nil
		else
			if staticdata ~= nil and staticdata ~= "" then
				local data = staticdata:split(';')
				if data and data[1] and data[2] then
					self.nodename = data[1]
					self.texture = data[2]

				end
			end
		end
		if self.texture ~= nil then
			self.object:set_properties({textures={self.texture}})
		end
		if self.nodename == "homedecor:pedestal" then
			self.object:set_properties({automatic_rotate=1})
		end
	end,
	get_staticdata = function(self)
		if self.nodename ~= nil and self.texture ~= nil then
			return self.nodename .. ';' .. self.texture
		end
		return ""
	end,
})


local facedir = {}
facedir[0] = {x=0,y=0,z=1}
facedir[1] = {x=1,y=0,z=0}
facedir[2] = {x=0,y=0,z=-1}
facedir[3] = {x=-1,y=0,z=0}

local remove_item = function(pos, node)
	local objs = nil
	if node.name == "homedecor:frame" then
		objs = minetest.env:get_objects_inside_radius(pos, .5)
	elseif node.name == "homedecor:pedestal" then
		objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y+1,z=pos.z}, .5)
	end
	if objs then
		for _, obj in ipairs(objs) do
			if obj and obj:get_luaentity() and obj:get_luaentity().name == "homedecor:item" then
				obj:remove()
			end
		end
	end
end

local update_item = function(pos, node)
	remove_item(pos, node)
	local meta = minetest.env:get_meta(pos)
	if meta:get_string("item") ~= "" then
		if node.name == "homedecor:frame"  then
			local posad = facedir[node.param2]
			if not posad then return end
			pos.x = pos.x + posad.x*6.5/16
			pos.y = pos.y + posad.y*6.5/16
			pos.z = pos.z + posad.z*6.5/16
		tmp.nodename = node.name
		tmp.texture = ItemStack(meta:get_string("item")):get_name()
		elseif node.name == "homedecor:pedestal" then
			pos.y = pos.y + 12/16+.33
		tmp.nodename = node.name
		tmp.texture = ItemStack(meta:get_string("item")):get_name()
		end
		local e = minetest.env:add_entity(pos,"homedecor:item")
		if node.name == "homedecor:frame"  then
			local yaw = math.pi*2 - node.param2 * math.pi/2
			e:setyaw(yaw)
		end
	end
end

local drop_item = function(pos, node)
	local meta = minetest.env:get_meta(pos)
	if meta:get_string("item") ~= "" then
		if node.name == "homedecor:frame" then
			minetest.env:add_item(pos, meta:get_string("item"))
		elseif node.name == "homedecor:pedestal" then
			minetest.env:add_item({x=pos.x,y=pos.y+1,z=pos.z}, meta:get_string("item"))
		end
		meta:set_string("item","")
	end
	remove_item(pos, node)
end


minetest.register_node("homedecor:frame",{
	description = "Item frame",
	drawtype = "nodebox",
	node_box = { type = "fixed", fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5} },
	selection_box = { type = "fixed", fixed = {-0.5, -0.5, 7/16, 0.5, 0.5, 0.5} },
	tiles = {"homedecor_frame.png"},
	inventory_image = "homedecor_frame.png",
	wield_image = "homedecor_frame.png",
	paramtype = "light",
	paramtype2 = "facedir",
	sunlight_propagates = true,
	groups = { choppy=2,dig_immediate=2 },
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner",placer:get_player_name())
		meta:set_string("infotext","Item frame (owned by "..placer:get_player_name()..")")
	end,
	on_rightclick = function(pos, node, clicker, itemstack)
		if not itemstack then return end
		local meta = minetest.env:get_meta(pos)
		if clicker:get_player_name() == meta:get_string("owner") then
			drop_item(pos,node)
			local s = itemstack:take_item()
			meta:set_string("item",s:to_string())
			update_item(pos,node)
		end
		return itemstack
	end,
	on_punch = function(pos,node,puncher)
		local meta = minetest.env:get_meta(pos)
		if puncher:get_player_name() == meta:get_string("owner") then
			drop_item(pos, node)
		end
	end,
	can_dig = function(pos,player)
		
		local meta = minetest.env:get_meta(pos)
		return player:get_player_name() == meta:get_string("owner")
	end,
})


minetest.register_node("homedecor:pedestal",{
	description = "Pedestal",
	drawtype = "nodebox",
	node_box = { type = "fixed", fixed = {
		{-7/16, -8/16, -7/16, 7/16, -7/16, 7/16}, -- bottom plate
		{-6/16, -7/16, -6/16, 6/16, -6/16, 6/16}, -- bottom plate (upper)
		{-0.25, -6/16, -0.25, 0.25, 11/16, 0.25}, -- pillar
		{-7/16, 11/16, -7/16, 7/16, 12/16, 7/16}, -- top plate
	} },
	--selection_box = { type = "fixed", fixed = {-7/16, -0.5, -7/16, 7/16, 12/16, 7/16} },
	tiles = {
"technic_marble.png",
"technic_marble.png",
"homedecor_pedestal.png",
},
	paramtype = "light",
	groups = { cracky=3 },
	sounds = default.node_sound_defaults(),
	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner",placer:get_player_name())
		meta:set_string("infotext","Pedestal (owned by "..placer:get_player_name()..")")
	end,
	on_rightclick = function(pos, node, clicker, itemstack)
		if not itemstack then return end
		local meta = minetest.env:get_meta(pos)
		if clicker:get_player_name() == meta:get_string("owner") then
			drop_item(pos,node)
			local s = itemstack:take_item()
			meta:set_string("item",s:to_string())
			update_item(pos,node)
		end
		return itemstack
	end,
	on_punch = function(pos,node,puncher)
		local meta = minetest.env:get_meta(pos)
		if puncher:get_player_name() == meta:get_string("owner") then
			drop_item(pos,node)
		end
	end,
	can_dig = function(pos,player)
		
		local meta = minetest.env:get_meta(pos)
		return player:get_player_name() == meta:get_string("owner")
	end,
})

-- automatically restore entities lost from frames/pedestals
-- due to /clearobjects or similar

minetest.register_abm({
	nodenames = { "homedecor:frame","kpgmobs:antlers", "homedecor:pedestal" },
	interval = 600,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		if #minetest.get_objects_inside_radius(pos, 0.5) > 0 then return end
		update_item(pos, node)
	end
})

-- crafts

minetest.register_craft({
	output = 'homedecor:frame',
	recipe = {
		{'group:stick', 'group:stick', 'group:stick'},
		{'group:stick', 'default:paper', 'group:stick'},
		{'group:stick', 'group:stick', 'group:stick'},
	}
})
minetest.register_craft({
	output = 'homedecor:pedestal',
	recipe = {
		{'technic:marble', 'technic:marble', 'technic:marble'},
		{'', 'technic:marble', ''},
		{'technic:marble', 'technic:marble', 'technic:marble'},
	}
})

reg_lamp("off", "low", "Table Lamp",  "", nil )
reg_lamp("low", "med", nil,          "l", 3   )
reg_lamp("med", "hi" , nil,          "m", 7   )
reg_lamp("hi" , "max", nil,          "h", 11  )
reg_lamp("max", "off", nil,          "x", 14  )

-- Aliases for 3dforniture mod.
minetest.register_alias("3dforniture:table", "homedecor:table")
minetest.register_alias("3dforniture:chair", "homedecor:chair")
minetest.register_alias("3dforniture:armchair", "homedecor:armchair_black")
minetest.register_alias("homedecor:armchair", "homedecor:armchair_black")

minetest.register_alias('table', 'homedecor:table')
minetest.register_alias('chair', 'homedecor:chair')
minetest.register_alias('armchair', 'homedecor:armchair')
