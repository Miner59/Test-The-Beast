
--
-- Helper functions
--

monorail_func = {}

function monorail_func:get_sign(z)
	if z > 0.1 then
		return 1
	elseif z < -0.1 then
		return -1
	else
		return 0
	end
end

-- Returns the velocity as a unit vector
-- The smaller part of the vector will be turned to 0
function monorail_func:velocity_to_dir(v)
	if math.abs(v.x) > math.abs(v.z) then
		return {x=monorail_func:get_sign(v.x), y=monorail_func:get_sign(v.y), z=0}
	else
		return {x=0, y=monorail_func:get_sign(v.y), z=monorail_func:get_sign(v.z)}
	end
end

function monorail_func:is_rail(p)
	local nn = minetest.get_node(p).name
if nn=="ignore" then
 local vm = minetest.get_voxel_manip()
 local pos1, pos2 = vm:read_from_map(vector.add(p, {x=-1,y=-1,z=-1}),vector.add(p, {x=1,y=1,z=1}))
 local a = VoxelArea:new{
 MinEdge=pos1,
 MaxEdge=pos2,
 }

 local data = vm:get_data()
 local vi = a:indexp(p)
 local railid = data[vi]
	return minetest.get_item_group(minetest.get_name_from_content_id(railid), "rail") ~= 0
 end
	return minetest.get_item_group(nn, "rail") ~= 0
end

function monorail_func:is_int(z)
	z = math.abs(z)
	return z-math.floor(z)<=0.1
end

monorail_func.v3 = {}

function monorail_func.v3:add(v1, v2)
	return {x=v1.x+v2.x, y=v1.y+v2.y, z=v1.z+v2.z}
end

function monorail_func.v3:copy(v)
	return {x=v.x, y=v.y, z=v.z}
end

function monorail_func.v3:round(v)
	return {
		x = math.floor(v.x+0.5),
		y = math.floor(v.y+0.5),
		z = math.floor(v.z+0.5),
	}
end

function monorail_func.v3:equal(v1, v2)
if v1==nil or v2==nil then
return false
end
	return v1.x == v2.x and v1.y == v2.y and v1.z == v2.z
end

function monorail_func.v3:empty(v)
	return v and v.x == 0 and v.y == 0 and v.z == 0
end
