//// move
//x += lengthdir_x(speed, direction);
//y += lengthdir_y(speed, direction);

//// when close, destroy
//if (point_distance(x, y, target_x, target_y) < 3) {
//    instance_destroy();
//}


// Cubic Bezier interpolation
var u = 1 - t;

xpos = 
      (u*u*u)       * start_x
    + (3*u*u*t)     * cp1_x
    + (3*u*t*t)     * cp2_x
    + (t*t*t)       * end_x;

ypos =
      (u*u*u)       * start_y
    + (3*u*u*t)     * cp1_y
    + (3*u*t*t)     * cp2_y
    + (t*t*t)       * end_y;

t += t_speed;

if (t >= 1) {
	show_debug_message("xpos: "+string(xpos + 24));
	show_debug_message("ypos: "+string(ypos + 5));
	instance_create_layer(1020, 48, "GUI", obj_milk_p_fade);
    instance_destroy();
}
