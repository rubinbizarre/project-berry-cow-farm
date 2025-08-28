//// if pressed on cow while not dragging and tracked_cow is inactive, make dragging true (working)
//if (global.tracked_cow == noone) and (!cow_dragging) {
//	cow_dragging = true;
//	mouse_prev_x = mouse_x;
//	mouse_prev_y = mouse_y;
//}

// if pressed on cow while not dragging and tracked_cow is inactive
if (global.tracked_cow == noone) and (!cow_dragging) and (!cow_pressed) {
	// store mouse_x and mouse_y pos at time of press
	mouse_prev_x = mouse_x;
	mouse_prev_y = mouse_y;
	cow_pressed = true;
}
