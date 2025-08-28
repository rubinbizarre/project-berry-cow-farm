if (instance_exists(obj_camera_controller)) and (global.tracked_cow == noone) {
	draw_sprite(btn_sprite, obj_camera_controller.zoom_level, btn_x, btn_y);
}