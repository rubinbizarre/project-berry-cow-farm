// Store the camera ID
camera = view_camera[0]; // or use camera_get_active_view() if dynamic

// Store mouse position
mouse_prev_x = 0;
mouse_prev_y = 0;
camera_panning = false;

pan_scale_factor = 0.25;

tracking = false;

zoom_0_w = 1120;//800;
zoom_0_h = 630;//450;
zoom_1_w = 800;//640;
zoom_1_h = 450;//360;
zoom_2_w = 480;
zoom_2_h = 270;
zoom_3_w = 320;
zoom_3_h = 180;
zoom_current_w = zoom_0_w;
zoom_current_h = zoom_0_h;
zoom_level = 0;

// set camera zoom level
camera_set_view_size(camera, zoom_current_w, zoom_current_h);
// centre camera in room
camera_set_view_pos(
	camera,
	room_width/2 - (camera_get_view_width(camera)/2),
	room_height/2 - (camera_get_view_height(camera)/2)
);