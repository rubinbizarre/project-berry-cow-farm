randomize();

global.debug = 0;

global.shadow_alpha = 0.4;

global.tracked_cow = noone;

global.font_color = #59344e;

//application_surface_draw_enable(false); // for pixel-perfect application surface (wip)

camera = view_camera[0];

window_set_cursor(cr_none);
cursor_sprite = spr_cursor_default;

global.cows = [
	//obj_cow_bb,
	//obj_cow_nana
];

patch_grid = ds_grid_create(2, 2); // create a 3x3 cell ds_grid for patches
ds_grid_set(patch_grid, 0, 0, obj_patch_default); // assign obj_patch to grid 0,0

//player_data = {
//	"money": 1000,
//	"level": 1,
//	"patches": [
//		{ "type": "grass", "level": 1, "patch_pos": [0,0] },
//		{ "type": "barn", "level": 1, "patch_pos": [1,0] }
//	],
//	"cows": [
//		{
//			"id": "cow_001",
//			"type": "blackberry",
//			"name": "BB",
//			"mood": 0.8,
//			"patch_pos": [0,0],
//			"accessories": [
//				"nose_ring_gold",
//				"ear_ring_gold_right"
//			]
//		},
//		{
//			"id": "cow_002",
//			"type": "banana",
//			"name": "Nana",
//			"mood": 1.0,
//			"patch_pos": [1,0],
//			"accessories": []
//		}
//	],
//	//"upgrade_progress": {},
//	//"statistics": {}
//}

global.save_data_local = {};

//// create patch edit button
//instance_create_layer(camera_get_view_width(camera) - 20, 20, "Instances", obj_btn_patch_edit);

//===================//
// target resolution
base_viewport_width = 1920;
base_viewport_height = 1080;

//btn_patch = { // worked for claude button
//	xpos: 50,
//	ypos: 50,
//	w: 180,
//	h: 180,
//	pressed: false,
//}

//gui_patch_editing = false;
//gui_upgrades = false;
//gui_jobs = false;

card_patch = {
	x1: room_width/2 - 90,
	y1: 20,
	x2: room_width/2 + 90,
	y2: 20 + 60
}

click_handled = false;
world_objects = [];