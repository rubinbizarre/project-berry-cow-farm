//if (mouse_check_button_pressed(mb_left)) {
//	if (point_in_rectangle(mouse_x, mouse_y, x, y, sprite_width, sprite_height)) {
//		show_debug_message("obj_par_patch STEP: mouse pressed!");
//	}
//}

#region handle changing the alpha value for the active patch highlight border (see draw event)
if (patch_active) {
	if (border_alpha >= border_alpha_max) {
		if (border_alpha_switch) border_alpha_switch = false;
	}
	if (border_alpha <= border_alpha_min) {
		if (!border_alpha_switch) border_alpha_switch = true;
	}
	
	if (border_alpha_switch) {
		border_alpha += border_alpha_speed;
	} else {
		border_alpha -= border_alpha_speed;
	}
}
#endregion

#region if click on no instances while a patch is active, reset patch_active to false
if (mouse_check_button_pressed(mb_left)) and (obj_par_patch.patch_active) {
	if (point_in_rectangle(mouse_x, mouse_y, camera_get_view_x(camera), camera_get_view_y(camera), camera_get_view_width(camera), camera_get_view_height(camera))) {
		if (!place_meeting(mouse_x, mouse_y, all)) {
			obj_par_patch.patch_active = false;
			show_debug_message("obj_master STEP: obj_par_patch.patch_active set to false");
		}
	}
}
#endregion