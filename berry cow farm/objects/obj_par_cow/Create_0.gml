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

// store mouse position, etc for click+dragging function
mouse_prev_x = 0;
mouse_prev_y = 0;
cow_prev_x = 0;
cow_prev_y = 0;
cow_dragging = false;
cow_pressed = false;

// parameters used in movement calculation
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

shadow_width = 20;
shadow_height = 5;

// save data:
cow_id = id;
// edited in child obj:
cow_name = "Unnamed";
cow_type = "Notype";
cow_mood = 0.5;

// push gui instance id to gui manager upon creation
// for layered gui click handling purposes
if (instance_exists(obj_gui_manager)) {
	array_push(obj_gui_manager.gui_elements, id);
}

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
	
function determine_mood() {
	// set multiplier values
	var multiplier_patch = 1.5;
	var multiplier_overcrowded = 0.8;
	var multiplier_solitary = 0.25;
	var points_accessory = 0.1;
	
	// initial mood value
	cow_mood = 0.5;
	var cow_mood_prev = cow_mood;

	// if cow's type matches their patch type, apply multiplier to mood
	var save_data_local_temp = global.save_data_local;
	var patches_array = save_data_local_temp.patches;
	var found_patch = {};
	for (var i = 0; i < array_length(patches_array); i++) {
		var patch_struct = patches_array[i];
		found_patch = patch_struct;
		// if patch matches cow's patch (by patch grid x-coord)
		if (patch_struct.xpos == global.tracked_cow.patch_x) { // <----------
			// if patch type matches cow type
			if (patch_struct.patch_type == cow_type) {
				cow_mood *= 1.5;
			}
		}
	}
	
	// if cow's patch is overcrowded, apply lesser multiplier to mood
	if (found_patch.current_cows > 2) {
		cow_mood *= 0.8;
	}
	// else if cow is alone in patch, apply lesser multiplier to mood
	else if (found_patch.current_cows < 2) {
		cow_mood *= 0.25;
	}
	
	//// if cow has accessories, apply points
	//if (cow_accessories > 0) {
	//	cow_mood += 0.1;
	//}
	
	show_debug_message("obj_par_cow DETERMINE_MOOD: cow_mood was "+string(cow_mood_prev)+". now it's "+string(cow_mood)+".");
}

function handle_click() {
	var current_patch = instance_place(x, y, obj_par_patch);
	// if pressed on cow while not dragging and tracked_cow is inactive and patch is not ready to harvest
	if (global.tracked_cow == noone) and (!cow_dragging) and (!cow_pressed) and (!current_patch.ready_to_harvest) {
		// store mouse_x and mouse_y pos at time of press
		mouse_prev_x = mouse_x;
		mouse_prev_y = mouse_y;
		cow_pressed = true;
	}
}
	
function check_gui_click() {
    if (point_in_rectangle(mouse_x, mouse_y, x - sprite_width/2, y - sprite_height/2, x + sprite_width/2, y + sprite_height/2)) {
        handle_click();
		//show_debug_message("obj_par_cow check_gui_click(): "+string(id)+" called handle_click()");
        return true;
    }
	
	//show_debug_message("obj_par_cow check_gui_click(): "+string(id)+" did not call handle_click()");
    return false;
}