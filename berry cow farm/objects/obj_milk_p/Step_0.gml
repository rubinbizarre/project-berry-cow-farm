// Accelerate from slow -> fast
t_speed += accel * 2;

// Move along the 0→1 timeline
t += t_speed;

// If done, remove
if (t >= 1) {
	instance_create_layer(1020, 48, "GUI", obj_milk_p_fade);
    instance_destroy();
}
