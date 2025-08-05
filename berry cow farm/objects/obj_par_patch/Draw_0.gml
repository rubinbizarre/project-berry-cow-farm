if (!patch_active) {
	draw_self();
} else {
	draw_set_alpha(border_alpha);
	draw_rectangle_color(x-border_gap, y-border_gap, sprite_width+border_gap, sprite_height+border_gap, c_white, c_white, c_white, c_white, false);
	draw_set_alpha(1);
	draw_self();
}