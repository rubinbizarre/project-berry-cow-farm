harvest_rect_offset = 0;
harvest_rect_rate = 0.1;
harvest_alpha = 0;
harvest_alpha_speed = 0.02;
harvest_alpha_switch = false;

//border_gap = 5; // unused currently
//border_alpha = 0;
//border_alpha_min = 0;
//border_alpha_max = 0.8;
//border_alpha_speed = 0.02;
//border_alpha_switch = false;

patch_pressed = false;
patch_hover = false;
//selected_patch_id = noone;

// default values
patch_sprite = spr_patch;
patch_name = "Plain Patch";

// for patch timer
//patch_harvest = false;
patch_time = noone;
patch_time_active = false;
patch_time_period_modifier = 5;
//patch_time_remaining = 0; // assigned in step event
//patch_time_period = 0; // count_cows_in_patch() * 3; // not detecting cow instances in this create event

// add persistent timer variables
production_start_time = 0;
production_duration = 0;
production_time_remaining = 0;
ready_to_harvest = false;

// push world instance id to obj_master world_objects[] upon creation
// for layered objects handling purposes. similar to obj_gui_manager's gui_elements[]
if (instance_exists(obj_master)) {
	array_push(obj_master.world_objects, id);
}

function check_world_click() {
	//var sprite_w = sprite_get_width(spr_patch);
	//var sprite_h = sprite_get_height(spr_patch);
	//if (point_in_rectangle(mouse_x, mouse_y, x - sprite_w/2, y - sprite_h/2, x + sprite_w/2, y + sprite_h/2)) {
	if (point_in_rectangle(mouse_x, mouse_y, x - sprite_width/2, y - sprite_height/2, x + sprite_width/2, y + sprite_height/2)) {
        handle_click();
        return true;
    }
    return false;
}

function handle_click() {
	var cow_object_pressed = false;
	with (obj_par_cow) {
		if (cow_pressed) {
			cow_object_pressed = true;
		}
	}
	if (patch_hover) and (!patch_pressed) and (!cow_object_pressed) {
		patch_pressed = true;
		//show_debug_message("obj_par_patch handle_click(): "+string(id)+" patch pressed!");
		//if (obj_gui_manager.selected_patch_id != id) { // <--- always changes selected_patch when clicking on a patch
		if (obj_gui_manager.selected_patch_id != id) and (!ready_to_harvest) { // <--- only changes selected_patch when clicking on a patch that is not ready to harvest
			obj_gui_manager.selected_patch_id = id;
			//show_debug_message("obj_par_patch handle_click(): "+string(id)+" is now the selected patch!");
		}
	}
}

function patch_timer_done(patch_id) {
    if (!patch_id.ready_to_harvest) patch_id.ready_to_harvest = true;
	if (patch_id.patch_time != noone) patch_id.patch_time = noone;
	show_debug_message("obj_par_patch CREATE: patch_timer_done(): "+string(patch_id)+" made ready_to_harvest true and patch_time noone");
}

function patch_timer_reset(patch_id) {
	patch_id.ready_to_harvest = false;
	show_debug_message("obj_par_patch CREATE: patch_timer_reset(): "+string(patch_id)+" made ready_to_harvest false");
	if (time_source_exists(patch_id.patch_time)) {
		// restart patch timer only if it's inactive
		if (time_source_get_state(patch_id.patch_time) == time_source_state_stopped) {
			time_source_destroy(patch_id.patch_time);
			start_patch_time();
			show_debug_message("obj_par_patch CREATE: patch_timer_reset(): "+string(patch_id)+" restarted patch_time");
		}
	}
}

function start_patch_time() {
	//if (patch_time == noone) and (!ready_to_harvest) {
	
	if (patch_time != noone) {
		destroy_patch_time();
	}
	
	if (!ready_to_harvest) {
		show_debug_message("obj_par_patch CREATE: start_patch_time(): "+string(id)+" patch_time was noone, creating new patch timer...");
		var cow_count = count_cows_in_patch();	
		// create and start patch timer if there are cows inside
		if (cow_count > 0) {
			production_duration = cow_count * patch_time_period_modifier;
		    production_start_time = date_current_datetime();
		    ready_to_harvest = false;
		
			patch_time = time_source_create(time_source_game, production_duration, time_source_units_seconds, patch_timer_done, [id], 1, time_source_expire_after);
			time_source_start(patch_time);
			//patch_time_active = true;
			show_debug_message("obj_par_patch CREATE: start_patch_time(): "+string(id)+" has cows in patch. created patch timer ("+string(production_duration)+" secs)");
		} else {
			destroy_patch_time();
			show_debug_message("obj_par_patch CREATE: start_patch_time(): "+string(id)+" has zero cows in patch! timer called to be destroyed!");
		}
	}
	
	//} else {
	//	//destroy_patch_time();
	//	show_debug_message("obj_par_patch CREATE: start_patch_time(): "+string(id)+" patch_time was already assigned or patch was ready to harvest! no timer created. | patch_time: "+string(patch_time)+" | ready_to_harvest: "+string(ready_to_harvest));
	//}
}

function destroy_patch_time() {
	if (patch_time != noone) {
        if (time_source_exists(patch_time)) {
            time_source_destroy(patch_time);
            show_debug_message("obj_par_patch CREATE: destroy_patch_time(): "+string(id)+" destroyed patch time");
        }
        patch_time = noone; // Important: reset to noone after destroying
		production_time_remaining = 0;
    }
}

function resume_production_after_load(patch_id, time_remaining) {
    if (!ready_to_harvest) {
		//// not working but related to calculating whether production has completed in real world time as opposed to only while app being open
        //var _current_time = date_current_datetime();
        //var time_elapsed = date_second_span(start_time, _current_time);
        //var time_remaining = production_duration - time_elapsed;
        
        if (time_remaining > 0) {
            // Still producing, create a new timer for remaining time
            patch_time = time_source_create(time_source_game, time_remaining, time_source_units_seconds, patch_timer_done, [id], 1, time_source_expire_after);
            time_source_start(patch_time);
            //patch_time_active = true;
            show_debug_message("obj_par_patch CREATE: resume_production_after_load(): "+string(patch_id)+" Resumed production with " + string(time_remaining) + " secs remaining");
        } else {
			show_debug_message("obj_par_patch CREATE: resume_production_after_load(): "+string(patch_id)+" No time remaining!");
		}
    } else {
		show_debug_message("obj_par_patch CREATE: resume_production_after_load(): "+string(patch_id)+" Ready to harvest!");
		patch_time = time_source_create(time_source_game, 0.1, time_source_units_seconds, patch_timer_done, [id], 1, time_source_expire_after);
        time_source_start(patch_time);
        //patch_time_active = true;
	}
}

function count_cows_in_patch() {
	var cow_list = ds_list_create();
    var cow_count = instance_place_list(x, y, obj_par_cow, cow_list, false);
    ds_list_destroy(cow_list);
    return cow_count;
}

function net_mood_in_patch() {
	var cow_list = ds_list_create();
    var cow_count = instance_place_list(x, y, obj_par_cow, cow_list, false);
	var net_mood = 0;
	for (var i = 0; i < ds_list_size(cow_list); i++) {
		var cow = ds_list_find_value(cow_list, i);
		with (cow) {
			net_mood += cow.cow_mood;
		}
	}
	//with (cow_list) {
	//	net_mood += cow_count.cow_mood;
	//}
	ds_list_destroy(cow_list);
	return net_mood;
}

#region create patch collision objects for each patch
collision_upper = instance_create_layer(x-sprite_width/2, y-40-sprite_height/2, "Instances", obj_collision);
collision_upper.image_xscale = 4;
collision_upper.image_yscale = 0.5;

collision_lower = instance_create_layer(x-sprite_width/2, y+248-sprite_height/2, "Instances", obj_collision);
collision_lower.image_xscale = 4;
collision_lower.image_yscale = 0.5;

collision_left = instance_create_layer(x-24-sprite_width/2, y-8-sprite_height/2, "Instances", obj_collision);
collision_left.image_xscale = 0.5;
collision_left.image_yscale = 4;

collision_right = instance_create_layer(x+248-sprite_width/2, y-8-sprite_height/2, "Instances", obj_collision);
collision_right.image_xscale = 0.5;
collision_right.image_yscale = 4;
#endregion
