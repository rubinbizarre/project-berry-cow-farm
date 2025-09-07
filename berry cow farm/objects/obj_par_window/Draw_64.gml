// draw window sprite
draw_sprite(gui_sprite, 0, gui_x, gui_y);

//// debug values:
//draw_text(gui_x, gui_y + 500, "gui_x: "+string(gui_x));
//draw_text(gui_x, gui_y + 550, "gui_y: "+string(gui_y));

#region draw cancel button (commented)
//// determine cancel button subimage based on state
//cancel_subimage = 0;
//if (cancel_hover) {
//	cancel_subimage = cancel_pressed ? 2 : 1; // pressed : hover
//}

//// draw cancel button sprite
//draw_sprite_ext(
//	cancel_sprite,
//	cancel_subimage,
//	gui_x + sprite_get_width(gui_sprite) - (sprite_get_width(cancel_sprite)/2) - cancel_corner_offset,
//	gui_y + cancel_corner_offset,
//	0.5, 0.5, 0, c_white, 1
//);
#endregion

//// debug: show designated clickable window area
//draw_set_alpha(0.3);
//draw_rectangle(
//	window_x,
//	window_y,
//	window_x + (sprite_get_width(window_sprite) - sprite_get_width(cancel_sprite)),
//	window_y + (sprite_get_height(window_sprite)/6),
//	false
//);
//draw_set_alpha(1);
//// debug: show window vars
//draw_text(200, room_height-400, "window_hover: "+string(window_hover));
//draw_text(200, room_height-350, "window_pressed: "+string(window_pressed));
//draw_text(200, room_height-300, "window_released: "+string(window_released));
//draw_text(200, room_height-250, "window_dragging: "+string(window_dragging));