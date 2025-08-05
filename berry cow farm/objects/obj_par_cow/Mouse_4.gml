// if pressed on cow while not dragging and tracked_cow is inactive, make dragging true
if (global.tracked_cow == noone) and (!cow_dragging) {
	cow_dragging = true;
	mouse_prev_x = mouse_x;
	mouse_prev_y = mouse_y;
}