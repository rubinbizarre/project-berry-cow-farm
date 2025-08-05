// Store the camera ID
camera = view_camera[0]; // or use camera_get_active_view() if dynamic

// Store mouse position
mouse_prev_x = 0;
mouse_prev_y = 0;
camera_panning = false;

scaling_factor = 0.2;

tracking = false;

zoom_0_w = 800;
zoom_0_h = 450;
zoom_1_w = 640;
zoom_1_h = 360;
zoom_2_w = 480;
zoom_2_h = 270;
zoom_3_w = 320;
zoom_3_h = 180;

camera_set_view_size(camera, zoom_0_w, zoom_0_h);