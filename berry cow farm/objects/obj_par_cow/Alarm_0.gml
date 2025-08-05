switch (cow_state) {
	case COW_STATE.IDLE: { // if was idle
		// change state
		//cow_state = COW_STATE.WALKING;
		cow_state = determine_next_state();
		//show_debug_message("obj_par_cow ALARM_0: "+string(id)+" state changed from IDLE to "+string(cow_state));
		
		//// for testing, set to any state
		//cow_state = COW_STATE.SITTING;
		
		#region call self to change state to IDLE after chosen delay (commented)
		//// randomise the delay_random var (see create event)
		//randomise_delay();
		//// choose between the random or default delay
		//var _delay = choose(delay_idle, delay_random);
		//// call self with chosen delay for another state change
		//alarm[0] = game_get_speed(gamespeed_fps) * _delay;
		//show_debug_message("obj_par_cow ALARM_0: state changed to WALKING for "+string(_delay)+" secs");
		#endregion
	} break;
	case COW_STATE.WALKING: { // if was walking
		// change state
		cow_state = COW_STATE.IDLE;
		//show_debug_message("obj_par_cow ALARM_0: "+string(id)+" state changed from WALKING to IDLE "+string(cow_state));
		
		#region call self to change state to IDLE after chosen delay
		// randomise the delay_random var (see create event)
		randomise_delay();
		// choose between the random or default delay
		var _delay = choose(delay_walking, delay_random);
		// call self with chosen delay for another state change
		alarm[0] = game_get_speed(gamespeed_fps) * _delay;
		//show_debug_message("obj_par_cow ALARM_0: state changed to IDLE for "+string(_delay)+" secs");
		#endregion
	} break;
	case COW_STATE.SITTING: {
		// change state
		cow_state = COW_STATE.RESTING;
		//show_debug_message("obj_par_cow ALARM_0: "+string(id)+" state changed from SITTING to RESTING "+string(cow_state));
		
		// call self with chosen delay to change state to STANDING
		alarm[0] = game_get_speed(gamespeed_fps) * 8;
	} break;
	case COW_STATE.RESTING: {
		// change state
		cow_state = COW_STATE.STANDING;
		//show_debug_message("obj_par_cow ALARM_0: "+string(id)+" state changed from RESTING to STANDING "+string(cow_state));
	} break;
	case COW_STATE.STANDING: {
		// change state
		cow_state = COW_STATE.IDLE;
		//show_debug_message("obj_par_cow ALARM_0: "+string(id)+" state changed from STANDING to IDLE "+string(cow_state));
	} break;
}