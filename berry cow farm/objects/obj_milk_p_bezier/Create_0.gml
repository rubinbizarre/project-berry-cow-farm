//// set from outside when created:
//// x, y = start pos
//// target_x, target_y = end location (milk bar UI)

//// precise end location:
//// x 1980
//// y 615

////target_x = 0;//1980;
////target_y = 0;//615;
//target_x = camera_get_view_width(view_camera[0])/2;
//target_y = 0;//camera_get_view_height(view_camera[0]);
////speed = 2;
////direction = point_direction(x, y, target_x, target_y);
//image_alpha = 1;
//image_speed = 0;

//x_ = device_mouse_x_to_gui(0);
//y_ = device_mouse_y_to_gui(0);


// Start at mouse in GUI space
start_x = device_mouse_x_to_gui(0);
start_y = device_mouse_y_to_gui(0);

// End point (top-center of screen)
end_x = 1020; // same as obj_milk_button
end_y = 48; // adjust depending on UI layout, same as obj_milk_button

// Time parameter 0 → 1
t = 0;
t_speed = 0.02; // lower = slower movement

cpx_strength = 80;
cpy_strength = 60;

xpos = 0;
ypos = 0;

// Control points for S-curve (Bezier)
var mid_y = (start_y + end_y) * 0.5;

// Move left then right OR right then left to create S shape
if (irandom(1) == 0) {
    cp1_x = start_x - cpx_strength;
    cp2_x = end_x + cpx_strength;
} else {
    cp1_x = start_x + cpx_strength;
    cp2_x = end_x - cpx_strength;
}

cp1_y = mid_y - cpy_strength;
cp2_y = mid_y + cpy_strength;
