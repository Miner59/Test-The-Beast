-- simple shaped bed
beds.register_bed("beds:bed", {
	description = "Bed",
	inventory_image = "beds_bed.png",
	wield_image = "beds_bed.png",
	tiles = {
	    bottom = {
		"beds_bed_top_bottom.png^[transformR90",
		"default_wood.png",
		"beds_bed_side_bottom_r.png",
		"beds_bed_side_bottom_r.png^[transformfx",
		"beds_transparent.png",
		"beds_bed_side_bottom.png"
	    },
	    top = {
		"beds_bed_top_top.png^[transformR90",
		"default_wood.png", 
		"beds_bed_side_top_r.png",
		"beds_bed_side_top_r.png^[transformfx",
		"beds_bed_side_top.png",
		"beds_transparent.png",
	    }
	},
	nodebox = {
	    bottom = {-0.5, -0.5, -0.5, 0.5, 0.06, 0.5},
	    top = {-0.5, -0.5, -0.5, 0.5, 0.06, 0.5},
	},
	selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5},
	recipe = {
		{"wool:red", "wool:red", "wool:white"},
		{"group:wood", "group:wood", "group:wood"}
	},

})

