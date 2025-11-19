// switched from draw event to draw end event due to overlapping sprites

// if a patch is selected, draw it as well as the selected sprite
if (obj_gui_manager.selected_patch_id != noone) {
	#region apply thick, blinking highlight border - see step event (working) (commented)
	//draw_set_alpha(border_alpha);
	//draw_rectangle_color(
	//	x - (sprite_width/2) - border_gap,
	//	y - (sprite_height/2) - border_gap,
	//	x + (sprite_width/2) + border_gap,
	//	y + (sprite_height/2) + border_gap,
	//	c_white, c_white, c_white, c_white, false
	//);
	//draw_set_alpha(1);
	//draw_self();
	#endregion
	var patch = obj_gui_manager.selected_patch_id;
	draw_sprite(spr_patch_selected, 0, patch.x, patch.y);
}

// if patch is harvestable, draw an effect to indicate so
if (ready_to_harvest) {
	#region draw flat white square overlay, flashing (working) (commented)
	//draw_set_alpha(border_alpha);
	//draw_rectangle_color(
	//	x - (sprite_width/2),
	//	y - (sprite_height/2),
	//	x + (sprite_width/2),
	//	y + (sprite_height/2),
	//	c_white, c_white, c_white, c_white, false
	//);
	//draw_set_alpha(1);
	#endregion
	
	#region draw shifting rectangles imitating fallout shelter's ready-to-harvest effect
	var _weight = 9;
	var _offset = 10;
	draw_set_alpha(harvest_alpha);
	// top rect
	draw_rectangle(
		x - (sprite_width/2) + _offset - harvest_rect_offset,
		y - (sprite_height/2) - harvest_rect_offset,
		x + (sprite_width/2) - _offset + harvest_rect_offset,
		y - (sprite_height/2) + _weight - harvest_rect_offset,
		false
	);
	// bottom rect
	draw_rectangle(
		x - (sprite_width/2) + _offset - harvest_rect_offset,
		y + (sprite_height/2) - _weight + harvest_rect_offset,
		x + (sprite_width/2) - _offset + harvest_rect_offset,
		y + (sprite_height/2) + harvest_rect_offset,
		false
	);
	// left-side rect
	draw_rectangle(
		x - (sprite_width/2) - harvest_rect_offset,
		y - (sprite_height/2) + _offset - harvest_rect_offset,
		x - (sprite_width/2) + _weight - harvest_rect_offset,
		y + (sprite_height/2) - _offset + harvest_rect_offset,
		false
	);
	// right-side rect
	draw_rectangle(
		x + (sprite_width/2) - _weight + harvest_rect_offset,
		y - (sprite_height/2) + _offset - harvest_rect_offset,
		x + (sprite_width/2) + harvest_rect_offset,
		y + (sprite_height/2) - _offset + harvest_rect_offset,
		false
	);
	#endregion
	
	#region corner squares!!!!!!!!!!!
	// top left
	draw_rectangle(
		x - (sprite_width/2) + _offset - harvest_rect_offset - _offset,
		y - (sprite_height/2) - harvest_rect_offset,
		x - (sprite_width/2) + _weight - harvest_rect_offset,
		y - (sprite_height/2) + _weight - harvest_rect_offset,
		false
	);
	// bottom left
	draw_rectangle(
		x - (sprite_width/2) + _offset - harvest_rect_offset - _offset,
		y + (sprite_height/2) - _weight + harvest_rect_offset,
		x - (sprite_width/2) + _weight - harvest_rect_offset,
		y + (sprite_height/2) + harvest_rect_offset,
		false
	);
	// top right
	draw_rectangle(
		x + (sprite_width/2) - _weight + harvest_rect_offset,
		y - (sprite_height/2) - harvest_rect_offset,
		x + (sprite_width/2) + harvest_rect_offset,
		y - (sprite_height/2) + _weight - harvest_rect_offset,
		false
	);
	// bottom right
	draw_rectangle(
		x + (sprite_width/2) - _weight + harvest_rect_offset,
		y + (sprite_height/2) - _weight + harvest_rect_offset,
		x + (sprite_width/2) + harvest_rect_offset,
		y + (sprite_height/2) + harvest_rect_offset,
		false
	);
	#endregion
		
	draw_set_alpha(1);
	
	// draw central milk icon with subtle hover effect (tied to harvest_alpha)
	//draw_sprite(spr_milk_bucket, 0, x, y + harvest_alpha*4);
	draw_sprite_ext(spr_milk_bottle_large, 0, x, y + harvest_alpha*4, 0.75, 0.75, 0, c_white, 1);
}

if (global.debug) {
	draw_set_halign(fa_center);
	//draw_text_transformed(x, y+sprite_height/2, "patch_time_active = "+string(patch_time_active), 0.25, 0.3, 0);
	draw_text_transformed(x, y+sprite_height/2+40, "patch_time = "+string(patch_time), 0.25, 0.3, 0);
	draw_text_transformed(x, y+sprite_height/2+80, "time_remaining = "+string(production_time_remaining), 0.25, 0.3, 0);
	draw_set_halign(fa_left);
}