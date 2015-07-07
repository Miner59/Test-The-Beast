-- This file adds fences of various types

local S = homedecor.gettext

minetest.register_node("homedecor:fence_brass", {
	description = S("Brass Fence/railing"),
	drawtype = "fencelike",
	tiles = {"homedecor_tile_brass.png"},
	inventory_image = "homedecor_fence_brass.png",
	wield_image = "homedecor_pole_brass.png",
	paramtype = "light",
	selection_box = {
	        type = "fixed",
	        fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	walkable = true,
})

minetest.register_node("homedecor:fence_wrought_iron", {
	description = S("Wrought Iron Fence/railing"),
	drawtype = "fencelike",
	tiles = {"homedecor_tile_wrought_iron.png"},
	inventory_image = "homedecor_fence_wrought_iron.png",
	wield_image = "homedecor_pole_wrought_iron.png",
	paramtype = "light",
	selection_box = {
	        type = "fixed",
	        fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
	},
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	walkable = true,
})

-- brass/wrought iron with signs:

minetest.register_node("homedecor:fence_brass_with_sign", {
	description = S("Brass Fence/railing with sign"),
	drawtype = "nodebox",
	tiles = {
		"homedecor_sign_brass_post_top.png",
		"homedecor_sign_brass_post_bottom.png",
		"homedecor_sign_brass_post_side.png",
		"homedecor_sign_brass_post_side.png",
		"homedecor_sign_brass_post_back.png",
		"homedecor_sign_brass_post_front.png",
	},
	wield_image = "homedecor_sign_brass_post.png",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = { 
			{ -0.125, -0.5, -0.125, 0.125, 0.5, 0.125 },
			{ -0.45, -0.1875, -0.225, 0.45, 0.4375, -0.125 },
		}
	},
	selection_box = {
		type = "fixed",
		fixed = { 
			{ -0.125, -0.5, -0.125, 0.125, 0.5, 0.125 },
			{ -0.45, -0.1875, -0.225, 0.45, 0.4375, -0.125 },
		}
	},
	groups = {snappy=3,not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	walkable = true,
	drop = {
		max_items = 2,
		items = {
			{ items = { "default:sign_wall" }},
			{ items = { "homedecor:fence_brass" }},
		},
	},
})

minetest.register_node("homedecor:fence_wrought_iron_with_sign", {
	description = S("Wrought Iron Fence/railing with sign"),
	drawtype = "nodebox",
		tiles = {
		"homedecor_sign_wrought_iron_post_top.png",
		"homedecor_sign_wrought_iron_post_bottom.png",
		"homedecor_sign_wrought_iron_post_side.png",
		"homedecor_sign_wrought_iron_post_side.png",
		"homedecor_sign_wrought_iron_post_back.png",
		"homedecor_sign_wrought_iron_post_front.png",
	},
	wield_image = "homedecor_sign_wrought_iron_post.png",
	paramtype = "light",
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = { 
			{ -0.125, -0.5, -0.125, 0.125, 0.5, 0.125 },
			{ -0.45, -0.1875, -0.225, 0.45, 0.4375, -0.125 },
		}
	},
	selection_box = {
		type = "fixed",
		fixed = { 
			{ -0.125, -0.5, -0.125, 0.125, 0.5, 0.125 },
			{ -0.45, -0.1875, -0.225, 0.45, 0.4375, -0.125 },
		}
	},
	groups = {snappy=3,not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	walkable = true,
	drop = {
		max_items = 2,
		items = {
			{ items = { "default:sign_wall" }},
			{ items = { "homedecor:fence_wrought_iron" }},
		},
	},
})

-- other types of fences

minetest.register_node("homedecor:fence_picket", {
	drawtype = "nodebox",
        description = S("Unpainted Picket Fence"),
        tiles = {
		"homedecor_blanktile.png",
		"homedecor_blanktile.png",
		"homedecor_fence_picket.png",
		"homedecor_fence_picket.png",
		"homedecor_fence_picket_backside.png",
		"homedecor_fence_picket.png"
	},
        paramtype = "light",
        is_ground_content = true,
        groups = {snappy=3},
        sounds = default.node_sound_wood_defaults(),
	walkable = true,
	paramtype2 = "facedir",
        selection_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, 0.4, 0.5, 0.5, 0.5 }
        },
        node_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, 0.498, 0.5, 0.5, 0.498 }
        },
})

minetest.register_node("homedecor:fence_picket_corner", {
	drawtype = "nodebox",
	description = S("Unpainted Picket Fence Corner"),
	tiles = {
		"homedecor_blanktile.png",
		"homedecor_blanktile.png",
		"homedecor_fence_picket.png",
		"homedecor_fence_picket_backside.png",
		"homedecor_fence_picket_backside.png",
		"homedecor_fence_picket.png",
	},
	paramtype = "light",
	is_ground_content = true,
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	walkable = true,
	paramtype2 = "facedir",
	selection_box = {
	type = "fixed",
		fixed = {
			{ -0.5, -0.5, 0.4, 0.5, 0.5, 0.5 },
			{ -0.5, -0.5, -0.5, -0.4, 0.5, 0.4 }
		}
	},
	node_box = {
	type = "fixed",
		fixed = {
			{ -0.5, -0.5, 0.498, 0.5, 0.5, 0.5 },
			{ -0.5, -0.5, -0.5, -0.498, 0.5, 0.5 }
		}
	},
})

minetest.register_node("homedecor:fence_picket_white", {
	drawtype = "nodebox",
        description = S("White Picket Fence"),
        tiles = {
		"homedecor_blanktile.png",
		"homedecor_blanktile.png",
		"homedecor_fence_picket_white.png",
		"homedecor_fence_picket_white.png",
		"homedecor_fence_picket_white_backside.png",
		"homedecor_fence_picket_white.png"
	},
        paramtype = "light",
        is_ground_content = true,
        groups = {snappy=3},
        sounds = default.node_sound_wood_defaults(),
	walkable = true,
	paramtype2 = "facedir",
        selection_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, 0.4, 0.5, 0.5, 0.5 }
        },
        node_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, 0.498, 0.5, 0.5, 0.498 }
        },
})

minetest.register_node("homedecor:fence_picket_corner_white", {
	drawtype = "nodebox",
	description = S("White Picket Fence Corner"),
	tiles = {
		"homedecor_blanktile.png",
		"homedecor_blanktile.png",
		"homedecor_fence_picket_white.png",
		"homedecor_fence_picket_white_backside.png",
		"homedecor_fence_picket_white_backside.png",
		"homedecor_fence_picket_white.png",
	},
	paramtype = "light",
	is_ground_content = true,
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	walkable = true,
	paramtype2 = "facedir",
	selection_box = {
	type = "fixed",
		fixed = {
			{ -0.5, -0.5, 0.4, 0.5, 0.5, 0.5 },
			{ -0.5, -0.5, -0.5, -0.4, 0.5, 0.4 }
		}
	},
	node_box = {
	type = "fixed",
		fixed = {
			{ -0.5, -0.5, 0.498, 0.5, 0.5, 0.5 },
			{ -0.5, -0.5, -0.5, -0.498, 0.5, 0.5 }
		}
	},
})

minetest.register_node("homedecor:fence_privacy", {
	drawtype = "nodebox",
        description = S("Wooden Privacy Fence"),
        tiles = {
		"homedecor_fence_privacy_tb.png",
		"homedecor_fence_privacy_tb.png",
		"homedecor_fence_privacy_sides.png",
		"homedecor_fence_privacy_sides.png",
		"homedecor_fence_privacy_backside.png",
		"homedecor_fence_privacy_front.png"
	},
        paramtype = "light",
        is_ground_content = true,
        groups = {snappy=3},
        sounds = default.node_sound_wood_defaults(),
	walkable = true,
	paramtype2 = "facedir",
        selection_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, 5/16, 0.5, 0.5, 8/16 }
        },
        node_box = {
                type = "fixed",
		fixed = {
			{ -8/16, -8/16, 5/16, -5/16,  8/16, 7/16 },	-- left part
			{ -4/16, -8/16, 5/16,  3/16,  8/16, 7/16 },	-- middle part
			{  4/16, -8/16, 5/16,  8/16,  8/16, 7/16 },	-- right part
			{ -8/16, -2/16, 7/16,  8/16,  2/16, 8/16 },	-- connecting rung
		}
        },
})

minetest.register_node("homedecor:fence_privacy_corner", {
	drawtype = "nodebox",
        description = S("Wooden Privacy Fence Corner"),
        tiles = {
		"homedecor_fence_privacy_corner_top.png",
		"homedecor_fence_privacy_corner_bottom.png",
		"homedecor_fence_privacy_corner_right.png",
		"homedecor_fence_privacy_backside2.png",
		"homedecor_fence_privacy_backside.png",
		"homedecor_fence_privacy_corner_front.png"
	},
        paramtype = "light",
        is_ground_content = true,
        groups = {snappy=3},
        sounds = default.node_sound_wood_defaults(),
	walkable = true,
	paramtype2 = "facedir",
        selection_box = {
                type = "fixed",
                fixed = {
			{ -0.5, -0.5, 5/16,   0.5, 0.5,  0.5 },
			{ -0.5, -0.5, -0.5, -5/16, 0.5, 5/16 },
		}			
        },
        node_box = {
                type = "fixed",
		fixed = {
			{ -7/16, -8/16, 5/16, -5/16, 8/16, 7/16 },	-- left part
			{ -4/16, -8/16, 5/16,  3/16, 8/16, 7/16 },	-- middle part
			{  4/16, -8/16, 5/16,  8/16, 8/16, 7/16 },	-- right part
			{ -8/16, -2/16, 7/16,  8/16, 2/16, 8/16 },	-- back-side connecting rung

			{ -7/16, -8/16,  4/16, -5/16, 8/16,  7/16 },	-- back-most part
			{ -7/16, -8/16, -4/16, -5/16, 8/16,  3/16 },	-- middle part
			{ -7/16, -8/16, -8/16, -5/16, 8/16, -5/16 },	-- front-most part
			{ -8/16, -2/16, -8/16, -7/16, 2/16,  7/16 },	-- left-side connecting rung
		}
        },
})

minetest.register_node("homedecor:fence_barbed_wire", {
	drawtype = "nodebox",
        description = S("Barbed Wire Fence"),
        tiles = {"homedecor_fence_barbed_wire.png"},
        paramtype = "light",
        is_ground_content = true,
        groups = {snappy=3},
        sounds = default.node_sound_wood_defaults(),
	walkable = true,
	paramtype2 = "facedir",
        selection_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, 0.375, 0.5, 0.5, 0.5 }
        },
        node_box = {
                type = "fixed",
		fixed = {
			{ -8/16, -8/16, 6/16, -6/16, 8/16, 8/16 },	-- left post
			{  6/16, -8/16, 6/16,  8/16, 8/16, 8/16 }, 	-- right post
			{ -6/16, -8/16, 7/16,  6/16, 8/16, 7/16 }	-- the wire
		}		
        },
})

minetest.register_node("homedecor:fence_barbed_wire_corner", {
	drawtype = "nodebox",
        description = S("Barbed Wire Fence Corner"),
        tiles = {
		"homedecor_fence_barbed_wire.png"
	},
        paramtype = "light",
        is_ground_content = true,
        groups = {snappy=3},
        sounds = default.node_sound_wood_defaults(),
	walkable = true,
	paramtype2 = "facedir",
        selection_box = {
                type = "fixed",
                fixed = {
			{ -0.5, -0.5, 0.375, 0.5, 0.5, 0.5 },
                	{ -0.5, -0.5, -0.5, -0.375, 0.5, 0.375 }
		}
        },
        node_box = {
                type = "fixed",
		fixed = {
			{ -8/16, -8/16,  6/16, -6/16, 8/16,  8/16 },	-- left post
			{  6/16, -8/16,  6/16,  8/16, 8/16,  8/16 }, 	-- right post
			{ -6/16, -8/16,  7/16,  6/16, 8/16,  7/16 },	-- the wire

			{  -8/16, -8/16, -8/16, -6/16, 8/16, -6/16 },	-- front post
			{  -7/16, -8/16, -6/16, -7/16, 8/16,  6/16 }	-- more wire
		}		
        },
})

minetest.register_node("homedecor:fence_chainlink", {
	drawtype = "nodebox",
        description = S("Chainlink Fence"),
        tiles = {
		"homedecor_fence_chainlink_tb.png",
		"homedecor_fence_chainlink_tb.png",
		"homedecor_fence_chainlink_sides.png",
		"homedecor_fence_chainlink_sides.png",
		"homedecor_fence_chainlink_fb.png",
		"homedecor_fence_chainlink_fb.png",
	},
        paramtype = "light",
        is_ground_content = true,
        groups = {snappy=3},
        sounds = default.node_sound_wood_defaults(),
	walkable = true,
	paramtype2 = "facedir",
        selection_box = {
                type = "fixed",
                fixed = { -0.5, -0.5, 0.375, 0.5, 0.5, 0.5 }
        },
        node_box = {
                type = "fixed",
		fixed = {
			{ -8/16, -8/16,  6/16, -7/16,  8/16,  8/16 },	-- left post
			{  7/16, -8/16,  6/16,  8/16,  8/16,  8/16 }, 	-- right post
			{ -8/16,  7/16, 13/32,  8/16,  8/16, 15/32 },	-- top piece
			{ -8/16, -8/16, 13/32,  8/16, -7/16, 15/32 },	-- bottom piece
			{ -8/16, -8/16,  7/16,  8/16,  8/16,  7/16 }	-- the chainlink itself
		}		
        },
})

minetest.register_node("homedecor:fence_chainlink_corner", {
	drawtype = "nodebox",
	description = S("Chainlink Fence Corner"),
	tiles = {
		"homedecor_fence_chainlink_corner_top.png",
		"homedecor_fence_chainlink_corner_bottom.png",
		"homedecor_fence_chainlink_corner_left.png",
		"homedecor_fence_chainlink_corner_right.png",
		"homedecor_fence_chainlink_corner_front.png",
		"homedecor_fence_chainlink_corner_back.png",
	},
	paramtype = "light",
	is_ground_content = true,
	groups = {snappy=3},
	sounds = default.node_sound_wood_defaults(),
	walkable = true,
	paramtype2 = "facedir",
	selection_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, 0.375, 0.5, 0.5, 0.5 },
			{ -0.5, -0.5, -0.5, -0.375, 0.5, 0.375 }
		}
	},
	node_box = {
		type = "fixed",
		fixed = {
			{  -8/16, -8/16,  6/16,  -6/16,  8/16,  8/16 },	-- left post, rear
			{  -8/16, -8/16, -8/16,  -6/16,  8/16, -7/16 }, -- left post, front
			{   7/16, -8/16,  6/16,   8/16,  8/16,  8/16 }, -- right post, rear
			{  -8/16,  7/16, 13/32,   8/16,  8/16, 15/32 },	-- top piece, rear
			{  -8/16, -8/16, 13/32,   8/16, -7/16, 15/32 },	-- bottom piece, rear
			{ -15/32,  7/16, -8/16, -13/32,  8/16,  8/16 },	-- top piece, side
			{ -15/32, -8/16, -8/16, -13/32, -7/16,  8/16 },	-- bottom piece, side
			{  -8/16, -8/16,  7/16,   8/16,  8/16,  7/16 },	-- the chainlink itself, rear
			{  -7/16, -8/16, -8/16,  -7/16,  8/16,  8/16 }	-- the chainlink itself, side
		}
	},
})

signs_lib.register_fence_with_sign("homedecor:fence_brass", "homedecor:fence_brass_with_sign")
signs_lib.register_fence_with_sign("homedecor:fence_wrought_iron", "homedecor:fence_wrought_iron_with_sign")
