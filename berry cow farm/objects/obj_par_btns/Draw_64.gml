// Choose subimage based on button state
// Assume sprite subimages: 0 = normal, 1 = hover, 2 = pressed
var subimage = 0; // normal
if (btn_is_toggle) {
	if (btn_hover) {
	    subimage = btn_activated ? 2 : 1; // activated/toggled : hover
	}
	if (btn_activated) subimage = 2;
} else {
	if (btn_hover) {
	    subimage = btn_pressed ? 2 : 1; // pressed : hover
	}
}

// Draw button sprite
draw_sprite(gui_sprite, subimage, gui_x, gui_y);