// if released on cow while dragging then make that tracked cow
if (global.tracked_cow != id) and (cow_dragging) {
	global.tracked_cow = id;
	show_debug_message("obj_par_cow LEFT_PRESS: tracked_cow set to "+string(id));
}
// if released on cow and was dragging, make dragging false
if (cow_dragging) {
	cow_dragging = false;
	mouse_prev_x = 0;
	mouse_prev_y = 0;
}