// Inherit the parent event
event_inherited();

gui_sprite = spr_window_jobs;
//gui_alpha = 0.8;

function handle_click() {
	if (!window_pressed) and (window_hover) {
		var gui_mouse_x = device_mouse_x_to_gui(0);
		var gui_mouse_y = device_mouse_y_to_gui(0);
		window_pressed = true;
		mouse_prev_x = gui_mouse_x;
		mouse_prev_y = gui_mouse_y;
		mouse_offset_x = mouse_prev_x - gui_x;
		mouse_offset_y = mouse_prev_y - gui_y;
		show_debug_message("obj_window_jobs handle_click(): window pressed");
	}	
}