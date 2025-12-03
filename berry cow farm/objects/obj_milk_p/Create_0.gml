// Start at mouse in GUI space
start_x = device_mouse_x_to_gui(0);
start_y = device_mouse_y_to_gui(0);

// End point (top-center of screen)
end_x = 1020; // same as obj_milk_button
end_y = 48; // adjust depending on UI layout, same as obj_milk_button

// t goes from 0 → 1
t = 0;

// Initial speed (slow)
t_speed = 0.001;

// How much faster it gets each frame
accel = 0.0005;

//// Optional: sprite scale
//scale_start = 0.6;
//scale_end = 1.0;
