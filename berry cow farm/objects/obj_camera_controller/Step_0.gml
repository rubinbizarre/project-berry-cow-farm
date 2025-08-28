#region if tracked_cow is active, centre camera on tracked_cow and at a higher zoom level. while inactive, allow for camera controls
if (global.tracked_cow != noone) {
	// store the tracked_cow pos every step
	var _tx = global.tracked_cow.x;
    var _ty = global.tracked_cow.y;
	// set the correct zoom level if not already
	if (zoom_current_w != zoom_3_w) {
		zoom_current_w = zoom_3_w;
		zoom_current_h = zoom_3_h;
	}
	// apply the correct zoom level if not already
	if (camera_get_view_width(camera) != zoom_current_w) camera_set_view_size(camera, zoom_current_w, zoom_current_h);
	// track constantly with slight follow delay
	camera_set_view_pos(camera,
        lerp(camera_get_view_x(camera), _tx - camera_get_view_width(camera)/2, 0.1),
        lerp(camera_get_view_y(camera), _ty - camera_get_view_height(camera)/2, 0.1)
    );
	
} else { // else if tracked_cow is inactive, allow for:
	// 1) manual camera panning with mouse
	// 2) switching zoom level with mouse wheel
	// 3) applying zoom level to camera
	
	#region manual camera panning with mouse
	// Check if left mouse is pressed while mouse_dragging is false and cow dragging is false
	if (instance_exists(obj_par_cow)) {
		if (mouse_check_button_pressed(mb_middle)) and (!camera_panning) and (!obj_par_cow.cow_dragging) {
		    camera_panning = true;
		    mouse_prev_x = device_mouse_x_to_gui(0);
		    mouse_prev_y = device_mouse_y_to_gui(0);
			cursor_sprite = spr_cursor_pan;
		}
	}
	
	// Stop dragging when released if was dragging
	if (mouse_check_button_released(mb_middle)) and (camera_panning) {
	    camera_panning = false;
		cursor_sprite = spr_cursor_default;
	}

	// While dragging, update camera position
	if (camera_panning) {
	    var mx = device_mouse_x_to_gui(0);
	    var my = device_mouse_y_to_gui(0);

	    var dx = mx - mouse_prev_x;
	    var dy = my - mouse_prev_y;
	
		//// Control rate of movement with pan_scaling_factor
		//dx *= pan_scaling_factor;
		//dy *= pan_scaling_factor;
		
		// figure out viewport size for current zoom
	    var vw;
	    switch (zoom_level) {
	        case 0: vw = zoom_3_w; break;
	        case 1: vw = zoom_2_w; break;
	        case 2: vw = zoom_1_w; break;
	        case 3: vw = zoom_0_w; break;
	    }
		
		// scale factor based on base zoom (level 0)
		var speed_factor = zoom_0_w / vw;
		// 1120 / 1120 = 1;
		// 1120 / 800 = 1.4;
		// 1120 / 480 = 2.333;
		// 1120 / 320 = 3.5;
		
		dx *= speed_factor;
		dy *= speed_factor;
		
		dx *= pan_scale_factor;
		dy *= pan_scale_factor;

	    // Get current camera position
	    var cam_x = camera_get_view_x(camera);
	    var cam_y = camera_get_view_y(camera);

	    // Apply scaled camera movement in the opposite direction of drag
	    camera_set_view_pos(camera, cam_x - dx, cam_y - dy);

	    // Update previous mouse pos
	    mouse_prev_x = mx;
	    mouse_prev_y = my;
	}
	#endregion
	
	#region switch zoom level with mouse wheel
	if mouse_wheel_up() {
		if (zoom_level < 3) zoom_level += 1;
	}
	if mouse_wheel_down() {
		if (zoom_level > 0) zoom_level -= 1;
	}
	#endregion
	
	#region watch to update camera zoom with current zoom level while tracked_cow is inactive
	if (camera_get_view_width(camera) != zoom_current_w) {
		// get centre of previous camera zoom
		// camera needs to be centred on room position at centre
		var _center_x = camera_get_view_x(camera) + camera_get_view_width(camera) / 2;
		var _center_y = camera_get_view_y(camera) + camera_get_view_height(camera) / 2;
		// set new camera zoom level
		camera_set_view_size(camera, zoom_current_w, zoom_current_h);
		// position camera correctly, centred at same point as before
		camera_set_view_pos(camera, _center_x - zoom_current_w/2, _center_y - zoom_current_h/2);
	}
	#endregion
}
#endregion

#region reset tracked_cow camera by clicking anywhere but the cows
// if user clicked and tracked_cow was active
if (device_mouse_check_button_pressed(0, mb_left)) and (global.tracked_cow != noone) {
	// if click was anywhere but cows
	if (point_in_rectangle(
		mouse_x, mouse_y,
		camera_get_view_x(camera), camera_get_view_y(camera),
		//camera_get_view_width(camera)*4, camera_get_view_height(camera)*4
		view_get_wport(0), view_get_hport(0)
	)) and (!place_meeting(mouse_x, mouse_y, obj_par_cow)) {
		
		// make tracked_cow inactive
		global.tracked_cow = noone;
		show_debug_message("obj_camera STEP: tracked_cow reset to noone");
	}
}
#endregion

#region handle changing current camera zoom values
// handle changing current camera zoom depending on zoom_level
switch (zoom_level) {
	case 0: {
		if (zoom_current_w != zoom_0_w) zoom_current_w = zoom_0_w;
		if (zoom_current_h != zoom_0_h) zoom_current_h = zoom_0_h;
	} break;
	case 1: {
		if (zoom_current_w != zoom_1_w) zoom_current_w = zoom_1_w;
		if (zoom_current_h != zoom_1_h) zoom_current_h = zoom_1_h;
	} break;
	case 2: {
		if (zoom_current_w != zoom_2_w) zoom_current_w = zoom_2_w;
		if (zoom_current_h != zoom_2_h) zoom_current_h = zoom_2_h;
	} break;
	case 3: {
		if (zoom_current_w != zoom_3_w) zoom_current_w = zoom_3_w;
		if (zoom_current_h != zoom_3_h) zoom_current_h = zoom_3_h;
	} break;
}
#endregion