if (!cow_dragging) {
	draw_set_alpha(global.shadow_alpha);
	draw_ellipse_color(x-shadow_width-2, y-shadow_height-2, x+shadow_width, y+shadow_height-2, c_black, c_black, false);
	draw_set_alpha(1);
	draw_self();
} else {
	draw_set_alpha(global.shadow_alpha - 0.1);
	draw_ellipse_color(x-shadow_width-4, y-shadow_height-4, x+shadow_width-2, y+shadow_height-4, c_black, c_black, false);
	draw_set_alpha(1);
	draw_sprite_ext(sprite_idle, 0, x, y-10, image_xscale, image_yscale, 0, c_white, 1);
}