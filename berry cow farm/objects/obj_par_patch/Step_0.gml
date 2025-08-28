if (patch_time_active) {
	if (time_source_exists(patch_time)) {
		// track time remaining in patch timer only if it's active
		if (time_source_get_state(patch_time) == time_source_state_active) {
			production_time_remaining = time_source_get_time_remaining(patch_time);
		}
	}
}

#region handle changing the alpha value for the active patch highlight border - see draw event (working) (commented)
//if (patch_selected) {
//	if (border_alpha >= border_alpha_max) {
//		if (border_alpha_switch) border_alpha_switch = false;
//	}
//	if (border_alpha <= border_alpha_min) {
//		if (!border_alpha_switch) border_alpha_switch = true;
//	}
	
//	if (border_alpha_switch) {
//		border_alpha += border_alpha_speed;
//	} else {
//		border_alpha -= border_alpha_speed;
//	}
//}
#endregion

#region handle changing rect offset and alpha for harvestable patch overlay - see draw event
if (ready_to_harvest) {
	// rect offset
	harvest_rect_offset += harvest_rect_rate;
	// alpha
	if (!harvest_alpha_switch) {
		if (harvest_alpha < 1) {
			harvest_alpha += harvest_alpha_speed;
		} else {
			if (alarm[0] == -1) {
				alarm[0] = game_get_speed(gamespeed_fps) * 0.5;
			}
		}
	} else {
		if (harvest_alpha > 0) {
			harvest_alpha -= harvest_alpha_speed/2;
		} else {
			// reset and loop
			harvest_alpha = 0;
			harvest_rect_offset = 0;
			harvest_alpha_switch = false;
		}
	}
}
#endregion

#region handle switching selected_patch with mouse press and operations
// Get sprite dimensions
var sprite_w = sprite_get_width(spr_patch);
var sprite_h = sprite_get_height(spr_patch);

// Check if mouse is over patch
patch_hover = point_in_rectangle(
	mouse_x, mouse_y, 
    x - sprite_w/2, y - sprite_h/2, 
    x + sprite_w/2, y + sprite_h/2
);

// Handle click
if (mouse_check_button_pressed(mb_left)) {
	// if hovering over patch while clicking, make patch pressed true (setup for mouse-release to do action)
	if (patch_hover) {
		if (!patch_pressed) patch_pressed = true;
		show_debug_message("obj_par_patch STEP: "+string(id)+" patch clicked! Patch pressed");
	} else { // else if click elsewhere, reset selected_patch_id
		if (selected_patch_id != noone) {
			selected_patch_id = noone;
			show_debug_message("obj_par_patch STEP: Clicked outside of "+string(id)+"! Selected patch: "+string(selected_patch_id));
		}
	}
}

// Do action and reset pressed state when released while pressed
// if releasing on top of a patch while pressed and while not tracking a cow,
if (mouse_check_button_released(mb_left)) and (patch_pressed) and (global.tracked_cow == noone) {
	// disengage patch press
	patch_pressed = false;
	
	//// if patch is ready for harvest,
	//if (ready_to_harvest) {
	//	// disable visual overlay
	//	ready_to_harvest = false;
	//	// add milk
	//	obj_farm_manager.farm_milk += 100;
	//	// restart timer
	//	patch_timer_reset();
	//} else {
	//	// if no patch is selected,
	//	if (selected_patch_id == noone) {
	//		// make the selected_patch_id the patch user clicked on.
	//		selected_patch_id = id;
	//		show_debug_message("obj_par_patch STEP: "+string(id)+" patch clicked + released! Selected patch: "+string(selected_patch_id));
	//	}
	//}
	
	if (!ready_to_harvest) {
		// if no patch is selected,
		if (selected_patch_id == noone) {
			// make the selected_patch_id the patch user clicked on.
			selected_patch_id = id;
			show_debug_message("obj_par_patch STEP: "+string(id)+" patch clicked + released! Selected patch: "+string(selected_patch_id));
		}
	} else {
		// disable visual overlay
		ready_to_harvest = false;
		// add milk
		obj_farm_manager.farm_milk += 100;
		// restart timer
		patch_timer_reset();
	}
}

// Reset pressed state when not hovering over
if (!patch_hover) and (patch_pressed) {
	patch_pressed = false;
}
#endregion