local vacuum_max_charge        = 15000 -- 15000 - Maximum charge of the vacuum cleaner
local vacuum_charge_per_object = 30   -- 30   - Capable of picking up 50 objects
local vacuum_range             = 7     -- 7     - Area in which to pick up objects

local S = technic.getter

technic.register_power_tool("technic:vacuum", vacuum_max_charge)

minetest.register_tool("technic:vacuum", {
	description = S("Vacuum Cleaner"),
	inventory_image = "technic_vacuum.png",
	stack_max = 1,
	wear_represents = "technic_RE_charge",
	on_refill = technic.refill_RE_charge,
	on_use = function(itemstack, user, pointed_thing)
		local pos=nil
		local inv = user:get_inventory()
		local inv2=nil
		local inv3=nil
		if pointed_thing~=nil then
			if pointed_thing.type=="node" then --pointing at a node, check if it is a chest
				pos=pointed_thing.under
				local meta2=minetest.get_meta(pos)
				if meta2~=nil then
					local owner=meta2:get_string("owner")
					if owner=="" or owner==nil or user:get_player_name() == owner then
						inv3=meta2:get_inventory()
					end
				end
			elseif pointed_thing.type=="object" then
				pos=pointed_thing.ref:getpos()
			end
		end
		if pos==nil then
			pos=user:getpos()
		end
		local meta = minetest.deserialize(itemstack:get_metadata())
		if not meta or not meta.charge then
			return itemstack
		end
		local keys = user:get_player_control()
		local sneak=keys["sneak"]
		if meta.full~=nil then
			sneak=true 
		else
			meta.full=nil
		end
		if meta.invname==nil then
			--contencate a unique string for detached inventory
			meta.invname="vac"..user:get_player_name()..os.date("%c") 
			inv2=minetest.create_detached_inventory(meta.invname, {})		
			inv2:set_size("main",16)
		end
		if inv2==nil then
			inv2=minetest.get_inventory({type="detached", name=meta.invname})
		end
		if inv2==nil then
			meta.invname="vac"..user:get_player_name()..os.date("%c") 
			inv2=minetest.create_detached_inventory(meta.invname, {})		
			inv2:set_size("main",16)
			if meta.stacks ~= nil then
				for i=1,#meta.stacks,1 do
					inv2:set_stack("main",i,meta.stacks[i])
				end
			end

		end
		if inv3~=nil then
			if inv3:get_size("main")>0 then
				if sneak then
					for i=1,inv2:get_size("main"),1 do
						local stack=inv2:get_stack("main", i)
						if stack:get_count() > 0 then
							inv3:add_item("main", ItemStack(stack))
							inv2:set_stack("main", i,ItemStack(nil))
						end
					end			
				else
					local invpos=1
					for i=1,inv3:get_size("main"),1 do
						local stack=inv3:get_stack("main", i)
						--not allow to put vacuum cleaner in another vaccum cleaner
						if stack:get_count() > 0 and stack:get_name()~="technic:vacuum" then
							for ii=invpos,inv2:get_size("main"),1 do
								meta.charge = meta.charge - vacuum_charge_per_object
								if meta.charge < vacuum_charge_per_object then
		local stacks = {}
		local list = inv2:get_list("main")
		for i=1,#list,1 do
			table.insert(stacks,list[i]:to_string())
		end
		meta.stacks = stacks
									technic.set_RE_wear(itemstack, meta.charge, vacuum_max_charge)
									itemstack:set_metadata(minetest.serialize(meta))
									return itemstack
								end
								invpos=ii
								local sstack=inv2:get_stack("main", ii,ItemStack(stack))
								if sstack:get_count()==0 then
									inv2:set_stack("main", ii,ItemStack(stack))
									inv3:set_stack("main", i,ItemStack(nil))
									break
								end
							end
							if invpos>15 then
								minetest.chat_send_player(user:get_player_name(), "Vacuum Cleaner is full! Punch again to empty it.")
								meta.full="1"
								break
							end
						end
					end			
				end
		local stacks = {}
		local list = inv2:get_list("main")
		for i=1,#list,1 do
			table.insert(stacks,list[i]:to_string())
		end
		meta.stacks = stacks
				technic.set_RE_wear(itemstack, meta.charge, vacuum_max_charge)
				itemstack:set_metadata(minetest.serialize(meta))
				return itemstack
			end
		end

		local log=0
		for _, object in ipairs(minetest.env:get_objects_inside_radius(pos, vacuum_range)) do
			local luaentity = object:get_luaentity()
			if not object:is_player() and luaentity and luaentity.name == "__builtin:item" and luaentity.itemstring ~= ""
				and luaentity.itemstring ~="technic:vacuum" then --not allow to put vacuum cleaner in another vaccum cleaner
				if sneak and inv and inv:room_for_item("main", ItemStack(luaentity.itemstring)) then
					meta.charge = meta.charge - vacuum_charge_per_object
					if meta.charge < vacuum_charge_per_object then
		local stacks = {}
		local list = inv2:get_list("main")
		for i=1,#list,1 do
			table.insert(stacks,list[i]:to_string())
		end
		meta.stacks = stacks

						technic.set_RE_wear(itemstack, meta.charge, vacuum_max_charge)
						itemstack:set_metadata(minetest.serialize(meta))
						return itemstack
					end
					inv:add_item("main", ItemStack(luaentity.itemstring))
					minetest.sound_play("item_drop_pickup", {
						to_player = user:get_player_name(),
						gain = 0.4,
					})
					luaentity.itemstring = ""
					object:remove()
				elseif inv2 then
					if inv2:room_for_item("main", ItemStack(luaentity.itemstring)) then
						meta.charge = meta.charge - vacuum_charge_per_object
						if meta.charge < vacuum_charge_per_object then
		local stacks = {}
		local list = inv2:get_list("main")
		for i=1,#list,1 do
			table.insert(stacks,list[i]:to_string())
		end
		meta.stacks = stacks

							technic.set_RE_wear(itemstack, meta.charge, vacuum_max_charge)
							itemstack:set_metadata(minetest.serialize(meta))
							return itemstack
						end
						inv2:add_item("main", ItemStack(luaentity.itemstring))
						minetest.sound_play("item_drop_pickup", {
							to_player = user:get_player_name(),
							gain = 0.4,
						})
						luaentity.itemstring = ""
						object:remove()
					elseif log==0 then
						log=1
						minetest.chat_send_player(user:get_player_name(), "Vacuum Cleaner is full! Punch again to empty it.")
						meta.full="1"
					end
				end
			end
		end
		if sneak and inv then
			for i=1,inv2:get_size("main"),1 do
				local stack=inv2:get_stack("main", i)
				if inv:room_for_item("main", ItemStack(stack)) then
					if stack:get_count() > 0 then
						inv:add_item("main", ItemStack(stack))
						inv2:set_stack("main", i,ItemStack(nil))
					end
				else
					break
				end
			end			
		end
		local stacks = {}
		local list = inv2:get_list("main")
		for i=1,#list,1 do
			table.insert(stacks,list[i]:to_string())
		end
		meta.stacks = stacks
		technic.set_RE_wear(itemstack, meta.charge, vacuum_max_charge)
		itemstack:set_metadata(minetest.serialize(meta))
		return itemstack
	end,
})

minetest.register_craft({
	output = 'technic:vacuum',
	recipe = {
		{'homedecor:plastic_sheeting', 'technic:battery', 'technic:battery'},
		{'homedecor:plastic_sheeting', 'default:coalblock', 'technic:motor'},
		{'moreblocks:sweeper', '', 'vessels:steel_bottle'},
	}
})

