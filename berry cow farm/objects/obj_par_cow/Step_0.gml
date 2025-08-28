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

// if released anywhere and was cow_dragging, make cow_dragging false
if (mouse_check_button_released(mb_left)) and (cow_dragging) {
	cow_dragging = false;
	mouse_prev_x = 0;
	mouse_prev_y = 0;
	// reset cow behaviour
	cow_state = COW_STATE.IDLE;
	alarm[0] = game_get_speed(gamespeed_fps) * delay_idle;
	show_debug_message("obj_par_cow STEP: cow behaviour reset");
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