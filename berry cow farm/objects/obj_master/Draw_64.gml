//// moved to obj_gui_manager
//switch (room) {
//	case rm_load: {
//		draw_set_font(font_debug);
//		draw_set_color(c_white);
		
//		draw_text(20, 20, "1. Create new save file");
//		draw_text(20, 50, "2. Load save file");
		
//		draw_set_font(font_custom);
//		draw_set_color(c_white);
//	} break;
//	case rm_main: {
//		#region debugging values
//		draw_set_font(font_debug);
//		draw_set_color(c_green);

//		if (global.debug) {
//			draw_text(20, 20, "mouse_x: "+string(mouse_x));
//			draw_text(20, 50, "mouse_y: "+string(mouse_y));
//			draw_text(20, 80, "camera_x: "+string(camera_get_view_x(camera)));
//			draw_text(20, 110, "camera_y: "+string(camera_get_view_y(camera)));
//			draw_text(20, 150, "view_centre_x: "+string((camera_get_view_x(camera) + obj_camera_controller.zoom_current_w) / 2));
//			draw_text(20, 180, "view_centre_y: "+string((camera_get_view_y(camera) + obj_camera_controller.zoom_current_h) / 2));
//		}
//		#endregion

//		#region game drawing: tracked cow info, gui mode, money etc
//		draw_set_font(font_custom);
//		draw_set_color(c_white);

//		// for positioning and sizing GUI elements
//		var gui_scale_x = view_get_wport(0) / base_viewport_width;
//		var gui_scale_y = view_get_hport(0) / base_viewport_height;

//		#region display cow info card when tracking
//		if (global.tracked_cow != noone) {
//			var divider = 2.5;
//			var line_sep = 60;
//			var text_xscale = 0.8;
//			var line_1_y = room_height/divider-line_sep;
//			var line_2_y = room_height/divider;
//			var line_3_y = room_height/divider+line_sep+(line_sep/4);
//			var card_offset = 30; // align card to right centre of text, giving actual values more space
	
//			// draw card background sprite
//			draw_sprite_ext(spr_card_patch, 0, room_width/5 + card_offset, line_2_y, 1, 2, 0, c_white, 1);
	
//			var prev_halign = draw_get_halign();
//			var prev_valign = draw_get_valign();
//			var prev_color = draw_get_color();
	
//			draw_set_halign(fa_right);
//			draw_set_valign(fa_middle);
//			draw_set_color(global.font_color);
	
//			// draw category text
//			draw_text_transformed(room_width/5.5, line_1_y, "Name:", text_xscale, 1, 0);
//			draw_text_transformed(room_width/5.5, line_2_y, "Type:", text_xscale, 1, 0);
//			//draw_text_transformed(room_width/5.5, line_3_y, "Mood:", text_xscale, 1, 0);
	
//			draw_set_halign(fa_left);
	
//			// draw value text
//			draw_text_transformed(room_width/5, line_1_y, global.tracked_cow.cow_name, text_xscale, 1, 0);
//			draw_text_transformed(room_width/5, line_2_y, global.tracked_cow.cow_type, text_xscale, 1, 0);
//			if (global.debug) draw_text_transformed(room_width/5, room_height/1.25, string(global.tracked_cow.cow_mood), text_xscale, 1, 0);
	
//			// draw mood slider
//			draw_sprite(spr_mood_slider, global.tracked_cow.cow_mood * 10, room_width/5 + card_offset, line_3_y);
	
//			draw_set_halign(prev_halign);
//			draw_set_valign(prev_valign);
//			draw_set_color(prev_color);
//		}
//		#endregion

//		#region display text indicating what gui mode we're in
//		if (instance_exists(obj_btn_patch_edit)) {
//			if (obj_btn_patch_edit.btn_activated) {
//				var prev_halign = draw_get_halign();
//				draw_set_halign(fa_center);
//				draw_text_transformed(display_get_gui_width()/2, display_get_gui_height()-60, "Patch Edit Mode", 0.8, 0.9, 0);
//				draw_set_halign(prev_halign);
//			}
//		}
//		#endregion

//		#region draw fundamental vars: money, level, milk
//		//if (!global.debug) {
//			var border = 40;
//			//draw_text_transformed(border, border, "Farm Level: "+string(obj_farm_manager.farm_level), 0.8, 0.9, 0);
//			var prev_halign = draw_get_halign();
//			draw_set_halign(fa_right);
//			draw_text_transformed(display_get_gui_width()/2-60, border, "$"+string(obj_farm_manager.farm_money), 0.9, 1, 0);
//			draw_set_halign(fa_left);
//			draw_text_transformed(display_get_gui_width()/2+100, border, string(obj_farm_manager.milk_total)+"ml", 0.9, 1, 0);
//			draw_set_halign(prev_halign);
//		//}
//		#endregion

//		#region draw selected patch card with info (commented) (moved to obj_par_patch)
//		//if (obj_par_patch.selected_patch_id != noone) {
//		//	var card_sprite_x = display_get_gui_width()/2;
//		//	var card_sprite_y = display_get_gui_height() - sprite_get_height(spr_card_patch)/2 - 10;
	
//		//	draw_sprite(spr_card_patch, 0, card_sprite_x, card_sprite_y);
	
//		//	var prev_font = draw_get_font();
//		//	var prev_halign = draw_get_halign();
//		//	var prev_valign = draw_get_valign();
//		//	var prev_color = draw_get_color();
//		//	draw_set_font(font_custom);
//		//	draw_set_color(global.font_color);
//		//	draw_set_halign(fa_center);
//		//	draw_set_valign(fa_middle);
//		//	var line_offset = 25
//		//	draw_text_transformed(card_sprite_x, card_sprite_y - line_offset, obj_par_patch.selected_patch_id.patch_name, 0.8, 1, 0);
//		//	draw_text_transformed(card_sprite_x, card_sprite_y + line_offset, string(int64(obj_par_patch.selected_patch_id.production_time_remaining)), 1, 1, 0);
	
//		//	// cleanup
//		//	draw_set_font(prev_font);
//		//	draw_set_color(prev_color);
//		//	draw_set_halign(prev_halign);
//		//	draw_set_valign(prev_valign);
//		//}
//		#endregion

//		#region claude pixel-perfect application surface drawing (wip) (commented)
//		//var cam = view_camera[0];
//		//var view_x = camera_get_view_x(cam);
//		//var view_y = camera_get_view_y(cam);
//		//var view_w = camera_get_view_width(cam);
//		//var view_h = camera_get_view_height(cam);

//		//// Calculate integer scaling for pixel-perfect rendering
//		//var scale = floor(view_get_hport(0) / view_h);
//		//if (scale < 1) scale = 1;

//		//var scaled_w = view_w * scale;
//		//var scaled_h = view_h * scale;
//		//var offset_x = (view_get_wport(0) - scaled_w) * 0.5;
//		//var offset_y = (view_get_hport(0) - scaled_h) * 0.5;

//		//// Draw the application surface manually
//		//// (because we disabled automatic drawing of it in create event)
//		//if (surface_exists(application_surface)) {
//		//    draw_surface_part_ext(application_surface, 0, 0, view_w, view_h, 
//		//                         offset_x, offset_y, scale, scale, c_white, 1);
//		//}
//		#endregion

//		#region claude gui button (working) (commented)
//		//// Choose button color based on state
//		//var button_color = c_gray;
//		//if (btn_patch.hovering) {
//		//    button_color = btn_patch.pressed ? c_dkgray : c_ltgray;
//		//}

//		//// Draw button
//		//draw_set_color(button_color);
//		//draw_rectangle(btn_patch.xpos, btn_patch.ypos, btn_patch.xpos + btn_patch.w, btn_patch.ypos + btn_patch.h, false);

//		//// Draw button border
//		//draw_set_color(c_black);
//		//draw_rectangle(btn_patch.xpos, btn_patch.ypos, btn_patch.xpos + btn_patch.w, btn_patch.ypos + btn_patch.h, true);

//		//// Draw button text/icon
//		//draw_set_color(c_white);
//		//draw_set_halign(fa_center);
//		//draw_set_valign(fa_middle);
//		//draw_text(btn_patch.xpos + btn_patch.w/2, btn_patch.ypos + btn_patch.h/2, "?");
//		#endregion

//		#endregion
//	} break;
//}

