// if released on cow while not dragging then make that tracked cow
if (global.tracked_cow != id) and (cow_pressed) {
	global.tracked_cow = id;
	show_debug_message("obj_par_cow LEFT_PRESS: tracked_cow set to "+string(id));
	
	// center on cow first (wip)
	if (instance_exists(obj_camera_controller)) {
		if (camera_get_view_x(obj_camera_controller.camera) != global.tracked_cow.x - obj_camera_controller.zoom_3_w/2)
			camera_set_view_pos(obj_camera_controller.camera, global.tracked_cow.x - obj_camera_controller.zoom_3_w/2, global.tracked_cow.y - obj_camera_controller.zoom_3_h/2);
		show_debug_message("obj_par_cow LEFT_RELEASE: centered camera on tracked cow");
	}
	
	cow_pressed = false;
	mouse_prev_x = 0;
	mouse_prev_y = 0;
	
	//determine_mood();
}

//// if released on cow and was dragging, make dragging false // commented due to not being executed anyway
//if (cow_dragging) {
//	cow_dragging = false;
//	mouse_prev_x = 0;
//	mouse_prev_y = 0;
//	// reset cow behaviour
//	cow_state = COW_STATE.IDLE;
//	alarm[0] = game_get_speed(gamespeed_fps) * delay_idle;
//	show_debug_message("obj_par_cow LEFT_RELEASE: cow behaviour reset");
//}