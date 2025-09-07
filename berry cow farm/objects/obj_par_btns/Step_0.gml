// Get GUI mouse coordinates
var gui_mouse_x = device_mouse_x_to_gui(0);
var gui_mouse_y = device_mouse_y_to_gui(0);

// Get sprite dimensions
var sprite_w = sprite_get_width(gui_sprite);
var sprite_h = sprite_get_height(gui_sprite);

// Check if mouse is over button
btn_hover = point_in_rectangle(gui_mouse_x, gui_mouse_y, 
                                 gui_x, gui_y, 
                                 gui_x + sprite_w, gui_y + sprite_h);

//// Handle click
//if (btn_hover and mouse_check_button_pressed(mb_left)) {
//	btn_pressed = true;
//}

// Do action and reset pressed state when released while pressed
// exact output depends on whether btn is toggle or not
if (btn_is_toggle) {
	if (mouse_check_button_released(mb_left)) and (btn_pressed) {
		btn_pressed = false;
		btn_activated = !btn_activated;
		// button action:
		show_debug_message("obj_par_btns STEP: "+string(id)+" button clicked! It's now "+string(btn_activated));
	}
} else {
	if (mouse_check_button_released(mb_left)) and (btn_pressed) {
		btn_pressed = false;
		// button action:
		show_debug_message("obj_par_btns STEP: "+string(id)+" button clicked!");
		switch (gui_sprite) {
			case spr_zoom_slider: {
				// increment/reset zoom level by clicking the zoomslider
				if (instance_exists(obj_camera_controller)) {
					if (obj_camera_controller.zoom_level < 3) obj_camera_controller.zoom_level += 1; else obj_camera_controller.zoom_level = 0;
				}
			} break;
		}
	}
}
// Reset pressed state when not hovering over
if (!btn_hover) and (btn_pressed) {
	btn_pressed = false;
}