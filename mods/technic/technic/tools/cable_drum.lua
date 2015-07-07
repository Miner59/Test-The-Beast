local S = technic.getter

minetest.register_tool("technic:cable_drum", {
	description = S("Cable Drum"),
	inventory_image = "technic_cable_drum.png",
	stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
		local inv = user:get_inventory()
		local name=user:get_player_name()
		local inv2=nil
		local meta = minetest.deserialize(itemstack:get_metadata())
		if not meta or not meta.charge or not inv then
			return
		end
		local keys = user:get_player_control()
		local sneak=keys["sneak"]
		if meta.cable==nil then
			sneak=true 
		end
		if meta.invname==nil then
			--contencate a unique string for detached inventory
			meta.invname="drum"..user:get_player_name()..os.date("%c") 
			inv2=minetest.create_detached_inventory(meta.invname, {
			allow_put = function(inv, listname, index, stack, player) 
				local name=stack:get_name()
				if name=="technic:lv_cable0" or name=="technic:mv_cable0" or name=="technic:hv_cable0" or name=="mesecons:wire_00000000_off" then
					return true
				end
				return false
			end,
			on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
				if player~=nil then
					local inv3=player:get_inventory()
					if inv3~=nil then
					local i=player:get_wield_index()
					local stack=inv3:get_stack("main",i)
					if stack:get_name=="technic:cable_drum" then
					local meta=minetest.deserialize(stack:get_metadata())
					local stacks = {}
					local list = inv:get_list("main")
					local count=0
					for i=1,#list,1 do
						table.insert(stacks,list[i]:to_string())
						count=count+inv:get_stack("main",i):get_count()
					end
					meta.stacks = stacks
					itemstack:set_wear(65535-(165*count))
					itemstack:set_metadata(minetest.serialize(meta))
					inv3:set_stack("main",i,itemstack)
					end
					end
				end
			end,
			on_put = function(inv, listname, index, stack, player)
				if player~=nil then
					local inv3=player:get_inventory()
					if inv3~=nil then
					local i=player:get_wield_index()
					local stack=inv3:get_stack("main",i)
					if stack:get_name=="technic:cable_drum" then
					local meta=minetest.deserialize(stack:get_metadata())
					local stacks = {}
					local list = inv:get_list("main")
					local count=0
					for i=1,#list,1 do
						table.insert(stacks,list[i]:to_string())
						count=count+inv:get_stack("main",i):get_count()
					end
					meta.stacks = stacks
					itemstack:set_wear(65535-(165*count))
					itemstack:set_metadata(minetest.serialize(meta))
					inv3:set_stack("main",i,itemstack)
					end
					end
				end
			end,
			on_take = function(inv, listname, index, stack, player)
				if player~=nil then
					local inv3=player:get_inventory()
					if inv3~=nil then
					local i=player:get_wield_index()
					local stack=inv3:get_stack("main",i)
					if stack:get_name=="technic:cable_drum" then
					local meta=minetest.deserialize(stack:get_metadata())
					local stacks = {}
					local list = inv:get_list("main")
					local count=0
					for i=1,#list,1 do
						table.insert(stacks,list[i]:to_string())
						count=count+inv:get_stack("main",i):get_count()
					end
					meta.stacks = stacks
					itemstack:set_wear(65535-(165*count))
					itemstack:set_metadata(minetest.serialize(meta))
					inv3:set_stack("main",i,itemstack)
					end
					end
				end
			end,
			})		
			inv2:set_size("main",4) --4 stacks of cable
		end
		if inv2==nil then
			inv2=minetest.get_inventory({type="detached", name=meta.invname})
		end
		if inv2==nil then
			meta.invname="drum"..user:get_player_name()..os.date("%c") 
			inv2=minetest.create_detached_inventory(meta.invname, {
			allow_put = function(inv, listname, index, stack, player) 
				local name=stack:get_name()
				if name=="technic:lv_cable0" or name=="technic:mv_cable0" or name=="technic:hv_cable0" or name=="mesecons:wire_00000000_off" then
					return true
				end
				return false
			end,
			on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
				if player~=nil then
					local inv3=player:get_inventory()
					if inv3~=nil then
					local i=player:get_wield_index()
					local stack=inv3:get_stack("main",i)
					if stack:get_name=="technic:cable_drum" then
					local meta=minetest.deserialize(stack:get_metadata())
					local stacks = {}
					local list = inv:get_list("main")
					local count=0
					for i=1,#list,1 do
						table.insert(stacks,list[i]:to_string())
						count=count+inv:get_stack("main",i):get_count()
					end
					meta.stacks = stacks
					itemstack:set_wear(65535-(165*count))
					itemstack:set_metadata(minetest.serialize(meta))
					inv3:set_stack("main",i,itemstack)
					end
					end
				end
			end,
			on_put = function(inv, listname, index, stack, player)
				if player~=nil then
					local inv3=player:get_inventory()
					if inv3~=nil then
					local i=player:get_wield_index()
					local stack=inv3:get_stack("main",i)
					if stack:get_name=="technic:cable_drum" then
					local meta=minetest.deserialize(stack:get_metadata())
					local stacks = {}
					local list = inv:get_list("main")
					local count=0
					for i=1,#list,1 do
						table.insert(stacks,list[i]:to_string())
						count=count+inv:get_stack("main",i):get_count()
					end
					meta.stacks = stacks
					itemstack:set_wear(65535-(165*count))
					itemstack:set_metadata(minetest.serialize(meta))
					inv3:set_stack("main",i,itemstack)
					end
					end
				end
			end,
			on_take = function(inv, listname, index, stack, player)
				if player~=nil then
					local inv3=player:get_inventory()
					if inv3~=nil then
					local i=player:get_wield_index()
					local stack=inv3:get_stack("main",i)
					if stack:get_name=="technic:cable_drum" then
					local meta=minetest.deserialize(stack:get_metadata())
					local stacks = {}
					local list = inv:get_list("main")
					local count=0
					for i=1,#list,1 do
						table.insert(stacks,list[i]:to_string())
						count=count+inv:get_stack("main",i):get_count()
					end
					meta.stacks = stacks
					itemstack:set_wear(65535-(165*count))
					itemstack:set_metadata(minetest.serialize(meta))
					inv3:set_stack("main",i,itemstack)
					end
					end
				end
			end,
			})		
			inv2:set_size("main",4) --4 stacks of cable
			if meta.stacks ~= nil then
				for i=1,#meta.stacks,1 do
					inv2:set_stack("main",i,meta.stacks[i])
				end
			end
		end
		if meta.cable==nil then
		for i,stack in ipairs(inv2:get_list("main")) do
			if stack:get_count()>0 then
				meta.cable=stack:get_name()
				break
			end
		end
		end
		if sneak then
			minetest.show_formspec(name,"drum_formspec",
				"size[8,9;]"..
				"label[0,0;Cables on this cable drum:]" ..
				"list[detached:" .. meta.invname .. ";main;2,1;2,2;]"..
				"list[current_player;main;0,5;8,4;]")
		else
			if meta.cable==nil or pointed_thing.type ~= "node" then
				return itemstack
			end
			if meta.start==nil then
				meta.start=minetest.pos_to_string(pointed_thing.above)
			else
				local pos=pointed_thing.above
				if pos==nil then
					return itemstack
				end
				local start=minetest.string_to_pos(meta.start)
				if start==nil then
					meta.start=nil
					itemstack:set_metadata(minetest.serialize(meta))
					return itemstack
				end
				local ps=0
				local under=0
				local miny=pos.y
				local maxy=start.y
				if miny>start.y then
					miny=start.y
					maxy=pos.y
				end
				local x=start.x
				local y=start.y
				local z=start.z
				local node=minetest.get_node({x=y,y=y-1,z=z})
				local table1={}
				local table2={}
				local table3={}
				local path={}
				local blocked=0
				local attached1=0
				local blocked1=0
				local attached2=0
				local blocked2=0
				local attached3=0
				local blocked3=0
				local ground=(not (node.name=="air" or node.name=="default:water_source" or node.name=="default:water_flowing") and minetest.get_item_group(node.name, "attached_node")~=0)
				local stepx=(math.abs(start.x-pos.x)/(start.x-pos.x))
				local stepz=(math.abs(start.z-pos.z)/(start.z-pos.z))
				--search ways to lay the cable, first search the 2 straight paths following x and z axis, then a diagonal path
				if math.abs(pos.x-start.x)>math.abs(pos.z-start.z) then
					for pp=0,math.abs(start.x-pos.x)+math.abs(start.z-pos.z)
						ps={x=y,y=y,z=z}
						under={x=y,y=y-1,z=z}
						node==minetest.get_node(ps)
						if minetest.is_protected(ps,name) then
							blocked=1
						elseif not (node.name=="air" or node.name=="default:water_source" or node.name=="default:water_flowing") then
							if minetest.get_item_group(node.name, "attached_node")~=0 then
								attached1=attached1+1
							else
								blocked=1
							end
						end			
						if blocked>0 then
						blocked=0
						ps=under
						node==minetest.get_node(ps)
						if minetest.is_protected(ps,name) then
							blocked=1
						elseif not (node.name=="air" or node.name=="default:water_source" or node.name=="default:water_flowing") then
							if minetest.get_item_group(node.name, "attached_node")~=0 then
								attached1=attached1+1
							else
								blocked=1
							end
						end			

						while true do
							if y>miny then
							end
						end
						end
						table1[pp]=ps
						if x==pos.x then
							z=z+stepz
						else
							x=x+stepx
						end
					end
					if attached1+blocked1>0 then
						x=start.x
						y=start.y
						z=start.z
						for pp=0,math.abs(start.x-pos.x)+math.abs(start.z-pos.z)
							ps={x=y,y=y,z=z}
							node==minetest.get_node(ps)
							if minetest.is_protected(ps,name) then
								blocked2=blocked2+1
							elseif not (node.name=="air" or node.name=="default:water_source" or node.name=="default:water_flowing") then
							if minetest.get_item_group(node.name, "attached_node")~=0 then
									attached2=attached2+1
								else
									blocked2=blocked2+1
								end
							end
							table2[pp]=ps
							if z==pos.z then
								x=x+stepx
							else
								z=z+stepz
							end
						end
						if blocked1>0 and blocked2>0 then
							x=start.x
							y=start.y
							z=start.z
							for pp=0,math.abs(start.x-pos.x)+math.abs(start.z-pos.z)
								ps={x=y,y=y,z=z}
								node==minetest.get_node(ps)
								if minetest.is_protected(ps,name) then
									blocked3=blocked3+1
								elseif not (node.name=="air" or node.name=="default:water_source" or node.name=="default:water_flowing") then
							if minetest.get_item_group(node.name, "attached_node")~=0 then
										attached3=attached3+1
									else
										blocked3=blocked3+1
									end
								end
								table3[pp]=ps
								if z+(math.abs(x-start.x)*stepz)*(math.abs(z-start.z)/(math.abs(pos.x-start.x)))>=z+stepz then
									z=z+stepz
								else
									x=x+stepx
								end
							end
						end
					end
				else
					for pp=0,math.abs(start.x-pos.x)+math.abs(start.z-pos.z)
						ps={x=y,y=y,z=z}
						node==minetest.get_node(ps)
						if minetest.is_protected(ps,name) then
							blocked1=blocked1+1
						elseif not (node.name=="air" or node.name=="default:water_source" or node.name=="default:water_flowing") then
							if minetest.get_item_group(node.name, "attached_node")~=0 then
								attached1=attached1+1
							else
								blocked1=blocked1+1
							end
						end						
						table1[pp]=ps
						if z==pos.z then
							x=x+stepx
						else
							z=z+stepz
						end
					end
					if attached1+blocked1>0 then
						x=start.x
						y=start.y
						z=start.z
						for pp=0,math.abs(start.x-pos.x)+math.abs(start.z-pos.z)
							ps={x=y,y=y,z=z}
							node==minetest.get_node(ps)
							if minetest.is_protected(ps,name) then
								blocked2=blocked2+1
							elseif not (node.name=="air" or node.name=="default:water_source" or node.name=="default:water_flowing") then
							if minetest.get_item_group(node.name, "attached_node")~=0 then
									attached2=attached2+1
								else
									blocked2=blocked2+1
								end
							end
							table2[pp]=ps
							if x==pos.x then
								z=z+stepz
							else
								x=x+stepx
							end
						end
						if blocked1>0 and blocked2>0 then
							x=start.x
							y=start.y
							z=start.z
							for pp=0,math.abs(start.x-pos.x)+math.abs(start.z-pos.z)
								ps={x=y,y=y,z=z}
								node==minetest.get_node(ps)
								if minetest.is_protected(ps,name) then
									blocked3=blocked3+1
								elseif not (node.name=="air" or node.name=="default:water_source" or node.name=="default:water_flowing") then
							if minetest.get_item_group(node.name, "attached_node")~=0 then
										attached3=attached3+1
									else
										blocked3=blocked3+1
									end
								end
								table3[pp]=ps
								if x+(math.abs(z-start.z)*stepx)*(math.abs(x-start.x)/(math.abs(pos.z-start.z)))>=x+stepx then
									x=x+stepx
								else
									z=z+stepz
								end
							end
						end
					end
				end
				local maxblockers=math.abs(start.x-pos.x)+math.abs(start.z-pos.z))/14+1)
				if (blocked1<1 and (attached1<1 or attached1<attached2))
					or (((blocked1<blocked2 or (blocked1==blocked2 and attached1<=attached2)) and blocked1<=blocked3) and blocked1<maxblockers then
					path=table1
				elseif (blocked2<1 or blocked2<=blocked3) and blocked2<maxblockers then
					path=table2
				elseif blocked3<maxblockers
					path=table3
				else
					minetest.chat_send_player(name, "Can't find a good way to lay a cable here!")
					meta.start=nil
					itemstack:set_metadata(minetest.serialize(meta))
					return itemstack
				end


				meta.start=nil
			end
		end		
		itemstack:set_metadata(minetest.serialize(meta))
		return itemstack
	end,
})


minetest.register_craft({
	output = 'technic:cable_drum',
	recipe = {
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot', ''},
		{'technic:stainless_steel_ingot', 'technic:stainless_steel_ingot', 'technic:lv_cable0'},
	}
})

