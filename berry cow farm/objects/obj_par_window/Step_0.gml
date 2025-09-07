var gui_mouse_x = device_mouse_x_to_gui(0);
var gui_mouse_y = device_mouse_y_to_gui(0);

#region built-in cancel button functionality (commented)
//var cancel_x = gui_x + sprite_get_width(gui_sprite) - sprite_get_width(cancel_sprite)/2 - cancel_corner_offset;
//var cancel_y = gui_y + cancel_corner_offset;

//// check if mouse is over cancel button
//cancel_hover = point_in_rectangle(
//	gui_mouse_x, gui_mouse_y, 
//    cancel_x,
//	cancel_y, 
//    cancel_x + sprite_get_width(cancel_sprite)/2,
//	cancel_y + sprite_get_height(cancel_sprite)/2
//);

//if (mouse_check_button_pressed(mb_left)) and (cancel_hover) {
//	if (!cancel_pressed) cancel_pressed = true;
//}

//if (cancel_pressed) and (!cancel_hover) {
//	cancel_pressed = false;
//}

//if (mouse_check_button_released(mb_left)) and (cancel_pressed) {
//	if (cancel_pressed) cancel_pressed = false;
//	// do action here
//	//instance_destroy();
//	show_debug_message("cancel button confirm pressed+released");
//}
#endregion

window_hover = point_in_rectangle(
	gui_mouse_x, gui_mouse_y,
	gui_x,
	gui_y,
	//gui_x + (sprite_get_width(gui_sprite) - sprite_get_width(cancel_sprite)),
	gui_x + (sprite_get_width(gui_sprite)),
	gui_y + (sprite_get_height(gui_sprite)/6)
);

//if (device_mouse_check_button_pressed(0, mb_left)) and (window_hover) {
//	// clicked inside designated window sprite area
//	if (!window_pressed) {
//		window_pressed = true;
//		mouse_prev_x = gui_mouse_x;
//		mouse_prev_y = gui_mouse_y;
//		mouse_offset_x = mouse_prev_x - gui_x;
//		mouse_offset_y = mouse_prev_y - gui_y;
//		//show_debug_message("window pressed");
//	}	
//}

if (window_pressed) and (!window_hover) {
	window_pressed = false;
}

if (device_mouse_check_button_released(0, mb_left)) {
	//show_debug_message("release detected");
	if (window_pressed) or (window_dragging) {
		window_pressed = false;
		window_dragging = false;
		mouse_prev_x = 0;
		mouse_prev_y = 0;
		mouse_offset_x = 0;
		mouse_offset_y = 0;
		//show_debug_message("window released");
	}
}

if (window_pressed) {
	if (gui_mouse_x != mouse_prev_x) or (gui_mouse_y != mouse_prev_y) {
		window_dragging = true;
		window_pressed = false;
		//show_debug_message("window dragging");
	}
}

if (window_dragging) {
	gui_x = gui_mouse_x - mouse_offset_x;
	gui_y = gui_mouse_y - mouse_offset_y;
}