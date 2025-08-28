// switched from draw event to draw end event due to overlapping sprites

// if a patch is selected, draw it as well as the selected sprite
if (selected_patch_id != noone) {
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
	
	draw_sprite(spr_patch_selected, 0, x, y);
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
	
	// draw central milk bucket with subtle hover effect (tied to harvest_alpha)
	draw_sprite(spr_milk_bucket, 0, x, y + harvest_alpha*4);
}