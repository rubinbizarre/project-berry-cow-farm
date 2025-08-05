// if tracked_cow is active, track it every step at a higher zoom level
if (global.tracked_cow != noone) {
	//camera_set_view_pos(camera, cow_inst.x, cow_inst.y);
	
	//if (camera_get_view_target(camera) != global.tracked_cow) {
	//	camera_set_view_target(camera, global.tracked_cow);
	//	show_debug_message("obj_camera STEP: set target to "+string(global.tracked_cow));
	//}
	
	var _tx = global.tracked_cow.x;
    var _ty = global.tracked_cow.y;
	if (camera_get_view_width(camera) != zoom_3_w) camera_set_view_size(camera, zoom_3_w, zoom_3_h);
	// center on cow first (wip)
	if (camera_get_view_x(camera) != _tx - zoom_3_w/2) camera_set_view_pos(camera, _tx - zoom_3_w/2, _ty - zoom_3_h/2);
	// track constantly
	camera_set_view_pos(camera,
        lerp(camera_get_view_x(camera), _tx - camera_get_view_width(camera)/2, 0.1),
        lerp(camera_get_view_y(camera), _ty - camera_get_view_height(camera)/2, 0.1)
    );
	// tween camera size to zoomed in
	// default width: 480
	// default height: 270
	// new width: 320
	// new height: 180
	// factor of 1.5
	// 480 - 320 = 160
	// 270 - 180 = 90
	
} else {
	#region manual camera panning with mouse
	// Check if left mouse is pressed while mouse_dragging is false and cow dragging is false
	if (mouse_check_button_pressed(mb_middle)) and (!camera_panning) and (!obj_par_cow.cow_dragging) {
	    camera_panning = true;
	    mouse_prev_x = device_mouse_x_to_gui(0);
	    mouse_prev_y = device_mouse_y_to_gui(0);
		cursor_sprite = spr_cursor_pan;
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
	
		// Control rate of movement with scaling_factor
		dx *= scaling_factor;
		dy *= scaling_factor;

	    // Get current camera position
	    var cam_x = camera_get_view_x(camera);
	    var cam_y = camera_get_view_y(camera);

	    // Move the camera in the opposite direction of drag
	    camera_set_view_pos(camera, cam_x - dx, cam_y - dy);

	    // Update previous mouse pos
	    mouse_prev_x = mx;
	    mouse_prev_y = my;
	}
	#endregion
}

#region reset tracked_cow camera by clicking anywhere but the cows
// if user clicked and tracked_cow was active
if (device_mouse_check_button_pressed(0, mb_left)) and (global.tracked_cow != noone) {
	// if click was anywhere but cows
	if (point_in_rectangle(
		mouse_x, mouse_y,
		camera_get_view_x(camera), camera_get_view_y(camera),
		camera_get_view_width(camera)*4, camera_get_view_height(camera)*4
	)) and (!place_meeting(mouse_x, mouse_y, obj_par_cow)) {
		camera_set_view_pos(camera, global.tracked_cow.x - zoom_0_w/2, global.tracked_cow.y - zoom_0_h/2);
		global.tracked_cow = noone;
		show_debug_message("obj_camera STEP: tracked_cow reset to noone");
		if (camera_get_view_width(camera) != zoom_0_w) camera_set_view_size(camera, zoom_0_w, zoom_0_h);
		
	}
}
#endregion