if (mouse_check_button_pressed(mb_left)) {
	if (point_in_rectangle(mouse_x, mouse_y, x, y, x-sprite_width, y-sprite_width)) {
		pressed = true;
		show_debug_message("obj_par_buttons LEFT_PRESS: pressed true");
	}
}
if (mouse_check_button_released(mb_left)) {
	if (pressed) {
		show_debug_message("obj_par_buttons LEFT_RELEASE: "+string(id)+" activated");
	}
}

if (pressed) {
	if (image_index != 1) { image_index = 1; }
} else {
	if (image_index != 0) { image_index = 0; }
}