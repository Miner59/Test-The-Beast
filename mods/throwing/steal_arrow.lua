minetest.register_craftitem("throwing:arrow_steal", {
	description = "Stealing Arrow",
	inventory_image = "throwing_arrow_steal.png",
})

minetest.register_node("throwing:arrow_steal_box", {
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			-- Shaft
			{-6.5/17, -1.5/17, -1.5/17, 6.5/17, 1.5/17, 1.5/17},
			--Spitze
			{-4.5/17, 2.5/17, 2.5/17, -3.5/17, -2.5/17, -2.5/17},
			{-8.5/17, 0.5/17, 0.5/17, -6.5/17, -0.5/17, -0.5/17},
			--Federn
			{6.5/17, 1.5/17, 1.5/17, 7.5/17, 2.5/17, 2.5/17},
			{7.5/17, -2.5/17, 2.5/17, 6.5/17, -1.5/17, 1.5/17},
			{7.5/17, 2.5/17, -2.5/17, 6.5/17, 1.5/17, -1.5/17},
			{6.5/17, -1.5/17, -1.5/17, 7.5/17, -2.5/17, -2.5/17},
			
			{7.5/17, 2.5/17, 2.5/17, 8.5/17, 3.5/17, 3.5/17},
			{8.5/17, -3.5/17, 3.5/17, 7.5/17, -2.5/17, 2.5/17},
			{8.5/17, 3.5/17, -3.5/17, 7.5/17, 2.5/17, -2.5/17},
			{7.5/17, -2.5/17, -2.5/17, 8.5/17, -3.5/17, -3.5/17},
		}
	},
	tiles = {"throwing_arrow_steal.png", "throwing_arrow_steal.png", "throwing_arrow_steal_back.png", "throwing_arrow_steal_front.png", "throwing_arrow_steal_2.png", "throwing_arrow_steal.png"},
	groups = {not_in_creative_inventory=1},
})

local THROWING_ARROW_ENTITY={
	physical = false,
	timer=0,
	visual = "wielditem",
	visual_size = {x=0.1, y=0.1},
	textures = {"throwing:arrow_steal_box"},
	lastpos={},
	collisionbox = {0,0,0,0,0,0},
}

THROWING_ARROW_ENTITY.on_step = function(self, dtime)
	self.timer=self.timer+dtime
	local pos = self.object:getpos()
	local node = minetest.env:get_node(pos)

	if self.timer>0.2
		or (node.name ~= "air" and node.name ~= "default:water_source" 
		and node.name ~= "default:water_flowing" and node.name ~= "default:lava_flowing" 
		and node.name ~= "default:lava_source") then
		self.timer=0
		local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 2)
		for k, obj in pairs(objs) do
			if obj:get_luaentity() ~= nil then
				if obj:get_luaentity().name ~= "throwing:arrow_steal_entity" and obj:get_luaentity().name ~= "__builtin:item" then
					local damage = 3
					obj:punch(self.object, 1.0, {
						full_punch_interval=1.0,
						damage_groups={fleshy=damage},
					}, nil)
					self.object:remove()
					return

				end
			else
				local rnd=math.random(0,100000)
				if rnd<74088 then
					local i={}
					local n={}
					local j={}
					local l={}
					i[1]=math.floor(rnd/1764)
					i[2]=math.floor((rnd%1764)/42)
					i[3]=rnd%42
					local inv = obj:get_inventory()
					local maxx=0
					local maxi=0
					for z=1,3,1 do
						if i[z]<=8 then
							j[z]=0
						elseif i[z]==41 then
							j[z]=inv:get_stack("craftresult",1):get_count()
							n[z]=inv:get_stack("craftresult",1):get_name()
							l[z]="craftresult"
						elseif i[z]>31 then
							j[z]=inv:get_stack("craft",i[z]-31):get_count()
							n[z]=inv:get_stack("craft",i[z]-31):get_name()
							l[z]="craft"
						else
							j[z]=inv:get_stack("main",i[z]):get_count()
							n[z]=inv:get_stack("main",i[z]):get_name()
							l[z]="main"
						end
						if j[z]>maxx then 
							maxx=j[z]
							maxi=z
						end

					end
					if maxx>0 then 
						inv:remove_item(l[maxi], ItemStack(n[maxi]))
						self.player:get_inventory():add_item("main",ItemStack(n[maxi]))
					end
					local damage = 1
					obj:punch(self.object, 1.0, {
						full_punch_interval=1.0,
						damage_groups={fleshy=damage},
						}, nil)
					self.object:remove()
					return


				end

			end
		end
	end
	if self.lastpos.x~=nil then
		if self.player~=nil then
		if node.name ~= "air" and node.name ~= "default:water_source" 
			and node.name ~= "default:water_flowing" and node.name ~= "default:lava_flowing" 
			and node.name ~= "default:lava_source" then
			if self.object:get_luaentity().player~=nil and self.object:get_luaentity().player:get_inventory()~=nil then
				self.object:get_luaentity().player:get_inventory():add_item("main",ItemStack("throwing:arrow_steal"))
			end
			self.object:remove()
		end
	end
	end
	self.lastpos={x=pos.x, y=pos.y, z=pos.z}
end

minetest.register_entity("throwing:arrow_steal_entity", THROWING_ARROW_ENTITY)

if (minetest.get_modpath("mesecons_materials")) then

	minetest.register_alias("throwing:glue","mesecons_materials:glue")
	
	minetest.register_craft({
		output = 'throwing:arrow_steal',
		type='shapeless',
		recipe = {
			'mesecons_materials:glue',
			'throwing:golden_arrow' ,
		}
	})
else
minetest.register_craftitem("throwing:glue", {
	image = "throwing_glue.png", --copied from mesecons mod
	on_place_on_ground = minetest.craftitem_place_item,
    	description="Glue",
})

minetest.register_craft({
	output = "throwing:glue",
	type = "cooking",
	recipe = "group:sapling",
	cooktime = 2
})

	minetest.register_craft({
		output = 'throwing:arrow_steal',
		type='shapeless',
		recipe = {
			'throwing:glue',
			'throwing:golden_arrow' ,
		}
	})
end
if (minetest.get_modpath("kpgmobs")) then

	minetest.register_craft({
		output = 'throwing:arrow_steal',
		type='shapeless',
		recipe = {
			'kpgmobs:honey',
			'throwing:golden_arrow' ,
		}
	})
end
