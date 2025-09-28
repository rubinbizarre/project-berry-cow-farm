//if (selected_patch_id != noone) {
//	var card_sprite_x = display_get_gui_width()/2;
//	var card_sprite_y = display_get_gui_height() - sprite_get_height(spr_card_patch)/2 - 10;
	
//	draw_sprite(spr_card_patch, 0, card_sprite_x, card_sprite_y);
	
//	var prev_font = draw_get_font();
//	var prev_halign = draw_get_halign();
//	var prev_valign = draw_get_valign();
//	var prev_color = draw_get_color();
//	draw_set_font(font_custom);
//	draw_set_color(global.font_color);
//	draw_set_halign(fa_center);
//	draw_set_valign(fa_middle);
//	var line_offset = 25
//	draw_text_transformed(card_sprite_x, card_sprite_y - line_offset, selected_patch_id.patch_name, 0.8, 1, 0);
//	draw_text_transformed(card_sprite_x, card_sprite_y + line_offset, string(int64(selected_patch_id.patch_time_remaining)), 1, 1, 0);
	
//	// cleanup
//	draw_set_font(prev_font);
//	draw_set_color(prev_color);
//	draw_set_halign(prev_halign);
//	draw_set_valign(prev_valign);
//}

#region draw selected patch card with info
if (obj_gui_manager.selected_patch_id != noone) {
	var card_sprite_x = display_get_gui_width()/2;
	var card_sprite_y = display_get_gui_height() - sprite_get_height(spr_card_patch)/2 - 10;
	
	draw_sprite(spr_card_patch, 0, card_sprite_x, card_sprite_y);
	
	var prev_font = draw_get_font();
	var prev_halign = draw_get_halign();
	var prev_valign = draw_get_valign();
	var prev_color = draw_get_color();
	draw_set_font(font_custom);
	draw_set_color(global.font_color);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	var line_offset = 25;
	
	var patch = obj_gui_manager.selected_patch_id;
	// write patch name
	draw_text_transformed(card_sprite_x, card_sprite_y - line_offset, patch.patch_name, 0.8, 1, 0);
	// write production time status / remaining secs
	if (patch.ready_to_harvest) {
		draw_text_transformed(card_sprite_x, card_sprite_y + line_offset, "DONE!", 0.8, 1, 0);
	} else {
		draw_text_transformed(card_sprite_x, card_sprite_y + line_offset, string(int64(patch.production_time_remaining)), 1, 1, 0);
	}
	
	// cleanup
	draw_set_font(prev_font);
	draw_set_color(prev_color);
	draw_set_halign(prev_halign);
	draw_set_valign(prev_valign);
}
#endregion

