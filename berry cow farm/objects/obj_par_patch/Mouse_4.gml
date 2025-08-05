if (!place_meeting(mouse_x, mouse_y, obj_par_cow)) and (!patch_active) {
	patch_active = true;
	border_alpha = 0;
	//show_debug_message("obj_par_patch STEP: mouse pressed!");
}