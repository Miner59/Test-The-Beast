
local S = technic.getter

minetest.register_craftitem("technic:silicon_wafer", {
	description = S("Silicon Wafer"),
	inventory_image = "technic_silicon_wafer.png",
})

minetest.register_craftitem( "technic:doped_silicon_wafer", {
	description = S("Doped Silicon Wafer"),
	inventory_image = "technic_doped_silicon_wafer.png",
})

minetest.register_craftitem("technic:enriched_uranium", {
	description = S("Enriched Uranium"),
	inventory_image = "technic_enriched_uranium.png",
})

minetest.register_craftitem("technic:uranium_fuel", {
	description = S("Uranium Fuel"),
	inventory_image = "technic_uranium_fuel.png",
})

	minetest.register_craft({
		type = "fuel",
		recipe = "technic:uranium_fuel",
		burntime = 900,
	})

minetest.register_craftitem("technic:fine_copper_wire", {
	description = S("Fine Copper Wire"),
	inventory_image = "technic_fine_copper_wire.png",
})

minetest.register_craftitem("technic:copper_coil", {
	description = S("Copper Coil"),
	inventory_image = "technic_copper_coil.png",
})

minetest.register_craftitem("technic:motor", {
	description = S("Electric Motor"),
	inventory_image = "technic_motor.png",
})

minetest.register_craftitem("technic:lv_transformer", {
	description = S("Low Voltage Transformer"),
	inventory_image = "technic_lv_transformer.png",
})
minetest.register_craftitem("technic:mv_transformer", {
	description = S("Medium Voltage Transformer"),
	inventory_image = "technic_mv_transformer.png",
})

minetest.register_craftitem( "technic:hv_transformer", {
	description = S("High Voltage Transformer"),
	inventory_image = "technic_hv_transformer.png",
})

minetest.register_craftitem( "technic:diamond_drill_head", {
	description = S("Diamond Drill Head"),
	inventory_image = "technic_diamond_drill_head.png",
})

minetest.register_tool("technic:blue_energy_crystal", {
	description = S("Blue Energy Crystal"),
	inventory_image = minetest.inventorycube(
		"technic_diamond_block_blue.png",
		"technic_diamond_block_blue.png",
		"technic_diamond_block_blue.png"),
	wear_represents = "technic_RE_charge",
	on_refill = technic.refill_RE_charge,
	tool_capabilities = {
		max_drop_level = 0,
		groupcaps = {
			fleshy = {times={}, uses=10000, maxlevel=0}
		}
	}
}) 

minetest.register_tool("technic:green_energy_crystal", {
	description = S("Green Energy Crystal"),
	inventory_image = minetest.inventorycube(
		"technic_diamond_block_green.png",
		"technic_diamond_block_green.png",
		"technic_diamond_block_green.png"),
	wear_represents = "technic_RE_charge",
	on_refill = technic.refill_RE_charge,
	tool_capabilities = {
		max_drop_level = 0,
		groupcaps = {
			fleshy = {times={}, uses=10000, maxlevel=0}
		}
	}
}) 

minetest.register_tool("technic:red_energy_crystal", {
	description = S("Red Energy Crystal"),
	inventory_image = minetest.inventorycube(
		"technic_diamond_block_red.png",
		"technic_diamond_block_red.png",
		"technic_diamond_block_red.png"),
	wear_represents = "technic_RE_charge",
	on_refill = technic.refill_RE_charge,
	tool_capabilities = {
		max_drop_level = 0,
		groupcaps = {
			fleshy = {times={}, uses=10000, maxlevel=0}
		}
	}
}) 

