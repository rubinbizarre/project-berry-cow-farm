draw_set_color(c_white);

if (global.debug) {
	draw_text(20, 20, "mouse_x: "+string(mouse_x));
	draw_text(20, 50, "mouse_y: "+string(mouse_y));
	draw_text(20, 80, "camera_x: "+string(camera_get_view_x(camera)));
	draw_text(20, 110, "camera_y: "+string(camera_get_view_y(camera)));
	
	//draw_set_alpha(0.3);
	//draw_rectangle(camera_get_view_x(camera), camera_get_view_y(camera),
	//camera_get_view_width(camera), camera_get_view_height(camera), false);
	//draw_set_alpha(1);
}

draw_set_color(c_white);