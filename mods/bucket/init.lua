-- Minetest 0.4 mod: bucket
-- See README.txt for licensing and other information.

local LIQUID_MAX = 8  --The number of water levels when liquid_finite is enabled

minetest.register_alias("bucket", "bucket:bucket_empty")
minetest.register_alias("bucket_water", "bucket:bucket_water")
minetest.register_alias("bucket_lava", "bucket:bucket_lava")

minetest.register_craft({
	output = 'bucket:bucket_empty 1',
	recipe = {
		{'default:steel_ingot', '', 'default:steel_ingot'},
		{'', 'default:steel_ingot', ''},
	}
})

bucket = {}
bucket.liquids = {}

local function check_protection(pos, name, text)
	if minetest.is_protected(pos, name) then
		minetest.log("action", (name ~= "" and name or "A mod")
			.. " tried to " .. text
			.. " at protected position "
			.. minetest.pos_to_string(pos)
			.. " with a bucket")
		minetest.record_protection_violation(pos, name)
		return true
	end
	return false
end

-- Register a new liquid
--   source = name of the source node
--   flowing = name of the flowing node
--   itemname = name of the new bucket item (or nil if liquid is not takeable)
--   inventory_image = texture of the new bucket item (ignored if itemname == nil)
-- This function can be called from any mod (that depends on bucket).
function bucket.register_liquid(source, flowing, itemname, inventory_image, name)
	bucket.liquids[source] = {
		source = source,
		flowing = flowing,
		itemname = itemname,
	}
	bucket.liquids[flowing] = bucket.liquids[source]

	if itemname ~= nil then
local eat=0
local rp=itemname
if itemname=="bucket:bucket_water" then
eat=0.6
rp="bucket:bucket_empty"
end
		minetest.register_craftitem(itemname, {
			description = name,
			inventory_image = inventory_image,
			stack_max = 1,
			liquids_pointable = true,
			groups = {},
			on_use = minetest.item_eat(eat,rp),
			on_place = function(itemstack, user, pointed_thing)
				-- Must be pointing to node
				if pointed_thing.type ~= "node" then
					return
				end
				
				local node = minetest.get_node_or_nil(pointed_thing.under)
				local ndef
				if node then
					ndef = minetest.registered_nodes[node.name]
				end
				-- Call on_rightclick if the pointed node defines it
				if ndef and ndef.on_rightclick and
				   user and not user:get_player_control().sneak then
					return ndef.on_rightclick(
						pointed_thing.under,
						node, user,
						itemstack) or itemstack
				end

				local place_liquid = function(pos, node, source, flowing, fullness)
					if check_protection(pos,
							user and user:get_player_name() or "",
							"place "..source) then
						return
					end
					if math.floor(fullness/128) == 1 or
						not minetest.setting_getbool("liquid_finite") then
						minetest.add_node(pos, {name=source,
								param2=fullness})
						return
					elseif node.name == flowing then
						fullness = fullness + node.param2
					elseif node.name == source then
						fullness = LIQUID_MAX
					end

					if fullness >= LIQUID_MAX then
						minetest.add_node(pos, {name=source,
								param2=LIQUID_MAX})
					else
						minetest.add_node(pos, {name=flowing,
								param2=fullness})
					end
				end

				-- Check if pointing to a buildable node
				local fullness = tonumber(itemstack:get_metadata())
				if not fullness then fullness = LIQUID_MAX end

				if ndef and ndef.buildable_to then
					-- buildable; replace the node
					place_liquid(pointed_thing.under, node,
							source, flowing, fullness)
				else
					-- not buildable to; place the liquid above
					-- check if the node above can be replaced
					local node = minetest.get_node_or_nil(pointed_thing.above)
					if node and minetest.registered_nodes[node.name].buildable_to then
						place_liquid(pointed_thing.above,
								node, source,
								flowing, fullness)
					else
						-- do not remove the bucket with the liquid
						return
					end
				end
				return {name="bucket:bucket_empty"}
			end
		})
	end
end

bucket.register_liquid(
	"default:water_source",
	"default:water_flowing",
	"bucket:bucket_water",
	"bucket_water.png",
	"Water Bucket"
)

bucket.register_liquid(
	"default:lava_source",
	"default:lava_flowing",
	"bucket:bucket_lava",
	"bucket_lava.png",
	"Lava Bucket"
)

minetest.register_craft({
	type = "fuel",
	recipe = "bucket:bucket_lava",
	burntime = 60,
	replacements = {{"bucket:bucket_lava", "bucket:bucket_empty"}},
})

local function check_protection(pos, name, text)
	if minetest.is_protected(pos, name) then
		minetest.log("action", (name ~= "" and name or "A mod")
			.. " tried to " .. text
			.. " at protected position "
			.. minetest.pos_to_string(pos)
			.. " with a bucket")
		minetest.record_protection_violation(pos, name)
		return true
	end
	return false
end

minetest.register_craftitem(":bucket:bucket_empty", {
	description = "Empty Bucket",
	inventory_image = "bucket.png",
	liquids_pointable = true,
	on_use = function(itemstack, user, pointed_thing)
		-- Must be pointing to node
		if pointed_thing.type ~= "node" then
			return
		end
		-- Check if pointing to a liquid source
		local node = minetest.get_node(pointed_thing.under)
		local liquiddef = bucket.liquids[node.name]
		if liquiddef ~= nil and liquiddef.itemname ~= nil and
			(node.name == liquiddef.source or
			(node.name == liquiddef.flowing and
				minetest.setting_getbool("liquid_finite"))) then
			if check_protection(pointed_thing.under,
					user:get_player_name(),
					"take ".. node.name) then
				return
			end
			
			-- only one bucket: replace
			local count = itemstack:get_count()
			if count == 1 then
				minetest.add_node(pointed_thing.under, {name="air"})
				return ItemStack({name = liquiddef.itemname,
					metadata = tostring(node.param2)})
			end

			-- staked buckets: add a filled bucket, replace stack
			local inv = user:get_inventory()
			if inv:room_for_item("main", liquiddef.itemname) then
				minetest.add_node(pointed_thing.under, {name="air"})
				count = count - 1
				itemstack:set_count(count)
				if node.name == liquiddef.source then
					node.param2 = LIQUID_MAX
				end
				bucket_liquid = ItemStack({name = liquiddef.itemname,
					metadata = tostring(node.param2)})
				inv:add_item("main", bucket_liquid)
				return itemstack
			else
				minetest.chat_send_player(user:get_player_name(), "Your inventory is full.")
			end

		end
	end,
})
