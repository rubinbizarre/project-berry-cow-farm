randomize();

global.debug = 1;

global.shadow_alpha = 0.4;

//global.tracking = false;
global.tracked_cow = noone;

draw_set_font(font_custom);

camera = view_camera[0];

window_set_cursor(cr_none);
cursor_sprite = spr_cursor_default;

global.cows = [
	obj_cow_bb,
	obj_cow_nana
];

patch_grid = ds_grid_create(2, 2); // create a 3x3 cell ds_grid for patches
ds_grid_set(patch_grid, 0, 0, obj_patch); // assign obj_patch to grid 0,0

player_data = {
	"money": 1000,
	"level": 1,
	"patches": [
		{ "type": "grass", "level": 1, "patch_pos": [0,0] },
		{ "type": "barn", "level": 1, "patch_pos": [1,0] }
	],
	"cows": [
		{
			"id": "cow_001",
			"type": "blackberry",
			"name": "BB",
			"mood": 0.8,
			"patch_pos": [0,0],
			"accessories": [
				"nose_ring_gold",
				"ear_ring_gold_right"
			]
		},
		{
			"id": "cow_002",
			"type": "banana",
			"name": "Nana",
			"mood": 1.0,
			"patch_pos": [1,0],
			"accessories": []
		}
	],
	//"upgrade_progress": {},
	//"statistics": {}
}