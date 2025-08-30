// Choose subimage based on button state
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
draw_sprite_ext(btn_sprite, subimage, btn_x, btn_y, btn_scale, btn_scale, 0, c_white, 1);