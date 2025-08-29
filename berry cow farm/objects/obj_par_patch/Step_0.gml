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

#region handle mouse press operations and switching selected_patch
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
	//	obj_farm_manager.milk_total += 100;
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
		
		//// add milk (simple)
		//obj_farm_manager.milk_total += 100;
		
		#region add milk (complex)
		/*
			consider individual milk types
			100ml per cow
			net mood of cows used as final multiplier
			
			so for Nana and BB
			Nana		banana			100ml	* cow_count (2)	= 200ml		* net_mood (1.4) = 280ml
			BB			blackberry		100ml	* cow_count (2)	= 200ml		* net_mood (1.4) = 280ml
			
			maybe each milk count should only be multiplied by net mood, unaffected by number of cows
			Nana		banana			100ml	* net_mood (1.4) = 140ml
			BB			blackberry		100ml	* net_mood (1.4) = 140ml
		*/
		
		var net_mood = net_mood_in_patch();
		var cow_list = ds_list_create();
	    var cow_count = instance_place_list(x, y, obj_par_cow, cow_list, false);
		var milk_produced_per_cow = obj_farm_manager.milk_base_amount * net_mood;
		var milk_produced_total = 0;
		// loop through list of cow instances
		for (var i = 0; i < ds_list_size(cow_list); i++) {
			// isolate each cow from the list of cow instances
			var cow = ds_list_find_value(cow_list, i);
			// with each cow
			with (cow) {
				// add to milk type total depending on cow type
				switch (cow.cow_type) {
					case "Banana": {
						obj_farm_manager.milk_banana += milk_produced_per_cow;
						milk_produced_total += milk_produced_per_cow;
					} break;
					case "Blackberry": {
						obj_farm_manager.milk_blackberry += milk_produced_per_cow;
						milk_produced_total += milk_produced_per_cow;
					} break;
					case "Blueberry": {
						obj_farm_manager.milk_blueberry += milk_produced_per_cow;
						milk_produced_total += milk_produced_per_cow;
					} break;
					case "Raspberry": {
						obj_farm_manager.milk_raspberry += milk_produced_per_cow;
						milk_produced_total += milk_produced_per_cow;
					} break;
					case "Strawberry": {
						obj_farm_manager.milk_strawberry += milk_produced_per_cow;
						milk_produced_total += milk_produced_per_cow;
					} break;
					default: {
						show_debug_message("obj_par_patch STEP: error! cow type not recognised, no milk added!");
					} break;
				}
			}
		}
		ds_list_destroy(cow_list);
		
		// now calculate total milk produced across all time
		var temp_milk_total = (
			obj_farm_manager.milk_banana +
			obj_farm_manager.milk_blackberry +
			obj_farm_manager.milk_blueberry +
			obj_farm_manager.milk_raspberry +
			obj_farm_manager.milk_strawberry
		);
		// clamp total value to milk capacity
		obj_farm_manager.milk_total = clamp(temp_milk_total, 0, obj_farm_manager.milk_capacity);
		
		show_debug_message("obj_par_patch STEP: Patch with "+string(cow_count)+" cows with net mood of "+string(net_mood)+" produced "+string(milk_produced_total)+" in total");
		show_debug_message("obj_par_patch STEP: Farm now has "+string(obj_farm_manager.milk_total)+" in total!");
		#endregion
		
		// restart timer
		patch_timer_reset();
		
		// save
		obj_farm_manager.save_farm_data();
		show_debug_message("obj_par_patch STEP: called save_farm_data() ...");
	}
}

// Reset pressed state when not hovering over
if (!patch_hover) and (patch_pressed) {
	patch_pressed = false;
}
#endregion