enum COW_STATE {
	IDLE,
	WALKING,
	SITTING,
	RESTING,
	STANDING,
	//MILKING,
	//GRAZING,
}

cow_state = COW_STATE.IDLE;

state_timer = 0;
delay_idle = 2;
delay_walking = 3;
delay_random = 0;

walk_speed = 0.25;

// store mouse position for click+dragging function
mouse_prev_x = 0;
mouse_prev_y = 0;
cow_prev_x = 0;
cow_prev_y = 0;
cow_dragging = false;
selected_cow = noone;

// parameters used in movement
x_end = 0;
y_end = 0;
dir = 0;
dist = 0;
// movement ranges determining how far the cow moves when walking
// initialised here with default values but can be overwritten by each cow object individually
x_range_min = 20;
x_range_max = 50;
y_range_min = 20;
y_range_max = 50;

// create instance of obj_cow_shadow at each cow
cow_shadow_inst = instance_create_depth(x, y - 2, depth + 10, obj_cow_shadow);

#region initiate state cycle with alarm:
//alarm[0] = game_get_speed(gamespeed_fps) * (4 / 3);
//show_debug_message("obj_par_cow CREATE: "+string(id)+" called for alarm[0] at "+string(current_time));

//alarm[0] = game_get_speed(gamespeed_fps) * delay_idle;
//show_debug_message("obj_par_cow CREATE: initial state change to WALKING in "+string(delay_idle)+" secs");

randomise_delay();
alarm[0] = game_get_speed(gamespeed_fps) * choose(delay_idle, delay_random);
#endregion

function randomise_delay() {
	delay_random = irandom_range(2, 5);
}

function determine_next_state() {
	switch (cow_state) {
		case COW_STATE.IDLE: { // from idle, go to either walking, or, rarely, sitting
			var _i = irandom_range(1, 100);
			if (_i >= 1) and (_i <= 90) {
				return COW_STATE.WALKING;
			} else if (_i > 90) and (_i <= 100) {
				return COW_STATE.SITTING;
			}
		} break;
	}
}

//function determine_endpoint() {
//	x_end = irandom_range(x - x_range, x + x_range);
//	y_end = irandom_range(y - y_range, y + y_range);
//}