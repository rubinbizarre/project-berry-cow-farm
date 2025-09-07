if (instance_exists(obj_camera_controller)) and (global.tracked_cow == noone) {
	draw_sprite(gui_sprite, obj_camera_controller.zoom_level, gui_x, gui_y);
}