// Check if left mouse is pressed
if (mouse_check_button_pressed(mb_left)) {
    mouse_dragging = true;
    mouse_prev_x = device_mouse_x_to_gui(0);
    mouse_prev_y = device_mouse_y_to_gui(0);
}

// Stop dragging
if (mouse_check_button_released(mb_left)) {
    mouse_dragging = false;
}

// While dragging, update camera position
if (mouse_dragging) {
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
