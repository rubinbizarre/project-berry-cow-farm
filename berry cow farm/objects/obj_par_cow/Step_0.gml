#region PSEUDO CODE DRAFTING
/*

AI cows need various modes:

ai_mode
	static
		totally stationary, idle animation
	moving
		linear move to a random spot nearby at constant speed, walk animation
		pick a spot
			x_end: window of +-30 to +-50 from origin
			y_end: window of +-40 to +-60 from origin
	grazing
		totally stationary, grazing animation

need to switch between them at random intervals

	may be appropriate to trigger an alarm at a random window time
	e.g. alarm[0] = game_get_speed(gamespeed_fps) * random_time
	
	random_time = choose(3, 5, 6);
	
	inside alarm[0]:
		counter = choose(0, 1, 2);
		ai_mode = counter;

*/
#endregion

// depth sorting based on room y position
if (depth != -y) { depth = -y; }

#region handle sprites, movement calculations and delays for state changes
switch (cow_state) {
    case COW_STATE.IDLE: {
		// change sprite and queue state change
        if (sprite_index != sprite_idle) {
			sprite_index = sprite_idle;
			image_index = 0;
			
			randomise_delay();
			alarm[0] = game_get_speed(gamespeed_fps) * choose(delay_idle, delay_random);
		}
	} break;
    case COW_STATE.WALKING: {
		#region change sprite, calculate endpoint and direction towards it
		if (sprite_index != sprite_walking) {
			sprite_index = sprite_walking;
			image_index = 0;
			
			//show_debug_message("obj_par_cow STEP: x = "+string(x));
			//show_debug_message("obj_par_cow STEP: y = "+string(y));
			x_end = choose(
				x + irandom_range(-x_range_min, -x_range_max),	// rand between -30 and -60 offset by x
				x + irandom_range(x_range_min, x_range_max)		// or rand between 30 and 60 offset by x
			);
			//show_debug_message("obj_par_cow STEP: x_end = "+string(x_end));
			y_end = choose(
				y + irandom_range(-y_range_min, -y_range_max),	// rand between -30 and -60 offset by y
				y + irandom_range(y_range_min, y_range_max)		// or rand between 30 and 60 offset by y
			);
			//show_debug_message("obj_par_cow STEP: y_end = "+string(y_end));
			
			// get direction to endpoint
			dir = point_direction(x, y, x_end, y_end);
			//show_debug_message("obj_par_cow STEP: dir = "+string(dir));
			
			// if direction to endpoint faces east, make image_xscale normal
			if ((dir >= 0) and (dir <= 90)) or ((dir >= 270) and (dir <= 359)) {
				if (image_xscale < 0) { image_xscale = 1; }
			// if direction to endpoint faces west, make image_xscale inverted
			} else {
				if (image_xscale > 0) { image_xscale *= -1; }
			}
		}
		#endregion
		
		// get distance to endpoint every step
		dist = point_distance(x, y, x_end, y_end);
		//show_debug_message("obj_par_cow STEP: dist = "+string(dist));
		
		#region apply movement. when close enough to endpoint, snap to it and change state to IDLE with alarm. otherwise check for collision and reset if collided
		if (dist <= 0.5) and (x != x_end) and (y != y_end) {
		    x = x_end;
		    y = y_end;
			alarm[0] = 2;
			//show_debug_message("obj_par_cow STEP: called state alarm to activate almost instantly");
		} else {
			// calculate movement delta
			var _dx = lengthdir_x(walk_speed, dir);
			var _dy = lengthdir_y(walk_speed, dir);
			// apply movement delta and detect collision
			/*	
				obj colliding with should be something like self.patch.collision_upper
				so that the cows only collide with collision objects in their patch??
				but that doesn't include any environment objects like haybales, trees..
			*/
			if (!place_meeting(x + _dx, y, obj_par_collision)) or (!place_meeting(x, y + _dy, obj_par_collision)) {
				x += _dx;
				y += _dy;
			} else {
				cow_state = COW_STATE.IDLE;
				alarm[0] = game_get_speed(gamespeed_fps) * delay_idle;
				//show_debug_message("obj_par_cow STEP: collision detected! "+string(id));
			}
		}
		#endregion
	} break;
	case COW_STATE.SITTING: {
		// change sprite and queue change to RESTING
	    if (sprite_index != sprite_sit) {
			sprite_index = sprite_sit;
			image_index = 0;
				
			// call alarm to change state to RESTING once sitting animation is done
			// fps * (total-animation-frames / animation-frame-rate)
			// 60 * (2 / 3) = 40 steps or frames
			alarm[0] = game_get_speed(gamespeed_fps) * (2 / 3);
			//show_debug_message("obj_par_cow STEP: "+string(id)+" sprite changed to sitting at "+string(current_time));
		}
	} break;
	case COW_STATE.RESTING: {
		// change sprite
        if (sprite_index != sprite_rest) {
			sprite_index = sprite_rest;
			image_index = 0;
			//show_debug_message("obj_par_cow STEP: "+string(id)+" sprite changed to resting at "+string(current_time));
		}
	} break;
	case COW_STATE.STANDING: {
		// change sprite and queue change to IDLE
	    if (sprite_index != sprite_stand) {
			sprite_index = sprite_stand;
			image_index = 0;
				
			// call alarm to change state to IDLE once reversed sitting animation is done
			alarm[0] = game_get_speed(gamespeed_fps) * (2 / 3);
		}
	} break;
}
#endregion

if (mouse_check_button_pressed(mb_left)) and (!obj_gui_manager.click_handled) {
	var clicked_cow = instance_position(mouse_x, mouse_y, obj_par_cow);
    if (clicked_cow != noone) {
        with (clicked_cow) {
            handle_click();
        }
    }
}

// if released anywhere and was cow_dragging, make cow_dragging false
if (mouse_check_button_released(mb_left)) and (cow_dragging) {
	cow_dragging = false;
	mouse_prev_x = 0;
	mouse_prev_y = 0;
	// reset cow behaviour
	cow_state = COW_STATE.IDLE;
	alarm[0] = game_get_speed(gamespeed_fps) * delay_idle;
	show_debug_message("obj_par_cow STEP: cow behaviour reset");
	
	#region if placed in a different patch, echo that change in save data, make persistent
	// Store reference to old patch before changing current_patch
	var old_patch = current_patch;
	// find patch instance at mouse pos
	var destination_patch = instance_position(mouse_x, mouse_y, obj_par_patch);
	// debug output the ref id of patches
	show_debug_message("obj_par_cow STEP: old_patch = "+string(old_patch)+" | destination_patch = "+string(destination_patch));
	// if this destination patch is not the same as previous cow patch, allow move and assign cow to new patch in save data
	if (destination_patch != current_patch) {
		#region if placed outside a valid patch, move cow back to previous x,y pos
		if (destination_patch == noone) {
			show_debug_message("obj_par_cow STEP: destination_patch is not a valid patch! moved cow back");
			x = cow_prev_x;
			y = cow_prev_y;
			cow_prev_x = 0;
			cow_prev_y = 0;
			return; // leave
		}
		#endregion
		
		//show_debug_message("obj_par_cow STEP: destination_patch is not the same as current_patch!");

		#region output the previous cows_list *debug* (commented)
		//var output = "";
		//for (var i = 0; i < ds_list_size(obj_farm_manager.cows_list); i++) {
		//    var cow_map = ds_list_find_value(obj_farm_manager.cows_list, i);
		//    output += ds_map_to_string(cow_map);
		//    if (i < ds_list_size(obj_farm_manager.cows_list) - 1) output += ", ";
		//}
		//show_debug_message("obj_par_cow STEP: previous cows_list: "+output);
		#endregion
		
		#region edit cows_list to reflect the patch change and save this data
		// loop through cows in ds_list to find matching entry to current instance
		for (var i = 0; i < ds_list_size(obj_farm_manager.cows_list); i++) {
		    var cow_map = ds_list_find_value(obj_farm_manager.cows_list, i);
		    // find cow map with matching name to one being dragged
		    if (ds_map_find_value(cow_map, "name") == cow_name) {
				#region cycle through all patches to find one that matches mouse pos, get patch x,y pos and save data
				var patch_key = ds_map_find_first(obj_farm_manager.patches_map);
				var patch_index = 0;
				var new_patch_x = 0;
				var new_patch_y = 0;
    
				while (!is_undefined(patch_key)) {
				    var patch_data = ds_map_find_value(obj_farm_manager.patches_map, patch_key);
				    var coords = obj_farm_manager.split_coordinates(patch_key);
        
					// Find the patch instance at these coordinates
					var patch_inst = instance_position(
						obj_farm_manager.grid_origin_x + (coords[0] * obj_farm_manager.patch_size),
						obj_farm_manager.grid_origin_y + (coords[1] * obj_farm_manager.patch_size),
						obj_par_patch
					);
					
					// If this patch is the same as the patch just moved to, execute data saving
					if (patch_inst == destination_patch) {
						new_patch_x = coords[0];
						new_patch_y = coords[1];
						show_debug_message("obj_par_cow STEP: found matching patch! new_patch_x: "+string(new_patch_x)+" and new_patch_y: "+string(new_patch_y));
						// assign new patch data to the one cow ds map inside cows_list ds list
				        ds_map_replace(cow_map, "patch_x", new_patch_x);
				        ds_map_replace(cow_map, "patch_y", new_patch_y);
						// save
						obj_farm_manager.save_farm_data();
						show_debug_message("obj_par_cow STEP: called save_farm_data() ...");
				        break; // stop after finding match and saving
					}
					
					patch_index++;
					patch_key = ds_map_find_next(obj_farm_manager.patches_map, patch_key);
				}
				#endregion
		    }
		}
		#endregion
		
		//// recalculate patch production timer
		//if (current_patch.patch_time != noone) {
		//	current_patch.start_patch_time();
		//	show_debug_message("obj_par_cow STEP: called for current_patch to recalculate timer with start_patch_time()");
		//}
		//current_patch = destination_patch;
		
		// After successful move, update BOTH patches' timers
		if (old_patch != destination_patch) {
			// Update old patch (cow left)
			with (old_patch) {
			    if (patch_time != noone) {
			        destroy_patch_time(); // Stop current timer
			    }
			    start_patch_time(); // Recalculate with remaining cows
			    show_debug_message("obj_par_cow STEP: recalculated old patch timer");
			}
			// Update new patch (cow arrived)  
			with (destination_patch) {
			    if (patch_time != noone) {
			        destroy_patch_time(); // Stop current timer
			    }
			    start_patch_time(); // Start new timer with additional cow
			    show_debug_message("obj_par_cow STEP: recalculated new patch timer");
			}
			// Update cow's patch reference
			current_patch = destination_patch;
		}
	}
	#endregion
}

// if mouse moves from initial pos while dragging, then move cow pos
if (cow_dragging) {
	if (mouse_x != mouse_prev_x) or (mouse_y != mouse_prev_y) {
		self.x = mouse_x;
		self.y = mouse_y;
	}
}

// if mouse moves at all whilst clicked on the cow, swap from pressed to dragging
if (cow_pressed) and ((mouse_x != mouse_prev_x) or (mouse_y != mouse_prev_y)) {
	cow_dragging = true;
	cow_pressed = false;
	mouse_prev_x = 0;
	mouse_prev_y = 0;
}