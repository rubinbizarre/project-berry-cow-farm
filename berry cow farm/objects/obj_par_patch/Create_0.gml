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
selected_patch_id = noone;

// default values
patch_sprite = spr_patch;
patch_name = "Plain Patch";

// for patch timer
//patch_harvest = false;
patch_time_active = false;
patch_time_period_modifier = 3;
//patch_time_remaining = 0; // assigned in step event
//patch_time_period = 0; // count_cows_in_patch() * 3; // not detecting cow instances in this create event

// NEW: Add persistent timer variables
production_start_time = 0;
production_duration = 0;
production_time_remaining = 0;
ready_to_harvest = false;

function patch_timer_done(patch_id) {
	//show_debug_message("obj_par_patch PATCH_TIMER_DONE");
    patch_id.ready_to_harvest = true;
	show_debug_message("obj_par_patch CREATE: patch_timer_done(): made ready_to_harvest true for "+string(patch_id));
}

function patch_timer_reset() {
	ready_to_harvest = false;
	show_debug_message("obj_par_patch CREATE: patch_timer_reset(): made ready_to_harvest false");
	if (time_source_exists(patch_time)) {
		// restart patch timer only if it's inactive (working)
		if (time_source_get_state(patch_time) == time_source_state_stopped) {
			//time_source_reset(patch_time);
			//time_source_start(patch_time);
			
			time_source_destroy(patch_time);
			start_patch_time();
			show_debug_message("obj_par_patch CREATE: patch_timer_reset(): restarted patch_time");
		}
	}
}

function start_patch_time() {
	var cow_count = count_cows_in_patch();
	production_duration = cow_count * patch_time_period_modifier;
	
	// start patch timer if there are cows inside
	if (cow_count > 0) {
		// NEW: Record when production started
        production_start_time = date_current_datetime();
        //production_duration = patch_time_period;
        ready_to_harvest = false;
		
		patch_time = time_source_create(time_source_game, production_duration, time_source_units_seconds, patch_timer_done, [id], 1, time_source_expire_after);
		time_source_start(patch_time);
		patch_time_active = true;
		show_debug_message("obj_par_patch CREATE: start_patch_time(): Created patch timer ("+string(production_duration)+" secs) for patch "+string(id));
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
            patch_time_active = true;
            show_debug_message("obj_par_patch CREATE: resume_production_after_load(): "+string(patch_id)+" Resumed production with " + string(time_remaining) + " secs remaining");
        } else {
			show_debug_message("obj_par_patch CREATE: resume_production_after_load(): "+string(patch_id)+" No time remaining!");
		}
    } else {
		show_debug_message("obj_par_patch CREATE: resume_production_after_load(): "+string(patch_id)+" Ready to harvest!");
		patch_time = time_source_create(time_source_game, 0.1, time_source_units_seconds, patch_timer_done, [id], 1, time_source_expire_after);
        time_source_start(patch_time);
        patch_time_active = true;
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
