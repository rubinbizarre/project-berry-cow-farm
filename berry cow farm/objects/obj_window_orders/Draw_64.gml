// Inherit the parent event
event_inherited();

if (!visible) return;

var orders_margin = 30;
var orders_active_y_gap = 0;

// draw order window title
draw_set_color(#536641);
draw_text_transformed(gui_x + 100, gui_y + 45, "orders", 1.3, 1.5, 0);

//// draw active subheading
//if (array_length(obj_farm_manager.orders_active) != 0) {
//	draw_set_color(#bdd4a6);
//	draw_text_transformed(gui_x + orders_margin, gui_y + 180 - scroll_y, "active", 1, 1.2, 0);
//	draw_set_color(c_white);
//	orders_active_y_gap = 200;
//}

//// draw available subheading
//draw_set_color(#bdd4a6);
//draw_text_transformed(gui_x + orders_margin, gui_y + 180 + orders_active_y_gap - scroll_y, "available", 1, 1.2, 0);
//draw_set_color(c_white);

#region draw order cards with info as sprites (commented)
//var _x = gui_x + orders_margin - 5;
//var _y = gui_y + 180 + orders_active_y_gap + 60;
//for (var i = 0; i < array_length(obj_farm_manager.orders_available); i++) {
//	// draw card sprite
//	draw_sprite(spr_card_order, 0, _x, _y);
	
//	// draw milk type for this order as coloured rectangle
//	var rect_color = c_white;
//	switch (obj_farm_manager.orders_available[i].milk_type) {
//		case "banana": rect_color = #fedf6a; break; //{ draw_sprite(milk, 0, _x + 50, _y + sprite_get_height(spr_card_order)/2); } break;
//		case "blackberry": rect_color = #d0b1eb; break; //{ draw_sprite(milk, 0, _x + 50, _y + sprite_get_height(spr_card_order)/2); } break;
//	}
//	draw_set_color(rect_color);
//	draw_rectangle(_x+50, _y + sprite_get_height(spr_card_order)/2 - 20, _x+90, _y + sprite_get_height(spr_card_order)/2 + 20, false);
	
//	// draw amount of milk needed for this order
//	draw_set_color(#536641);
//	draw_text_transformed(_x + 150, _y + sprite_get_height(spr_card_order)/2 - 20,
//		string(obj_farm_manager.orders_available[i].milk_amount),
//		1, 1.2, 0
//	);
	
//	// draw amount of time to complete this order in minutes (converted from seconds)
//	draw_set_halign(fa_center);
//	draw_text_transformed(_x + sprite_get_width(spr_card_order)/2 + 25, _y + sprite_get_height(spr_card_order)/2 - 20,
//		string(obj_farm_manager.orders_available[i].time_to_complete/60)+" min",
//		1, 1.2, 0
//	);
	
//	// draw $ reward for this order
//	draw_set_halign(fa_right);
//	draw_text_transformed(_x + 950, _y + sprite_get_height(spr_card_order)/2 - 20,
//		"$"+string(obj_farm_manager.orders_available[i].reward),
//		1, 1.2, 0
//	);
	
//	draw_set_halign(fa_left);
//	// create y separation between available orders
//	_y += sprite_get_height(spr_card_order)-8;
//}
#endregion

// draw scrollbar
if (scroll_max > 0) {
	draw_set_color(#536641);
    draw_rectangle(scrollbar_x, scrollbar_y, scrollbar_x + scrollbar_w, scrollbar_y + scrollbar_h, false);
    
    var handle_height = max(20, scrollbar_h * (gui_h / (scroll_max + gui_h)));
    var handle_y = scrollbar_y + (scroll_y / scroll_max) * (scrollbar_h - handle_height);
    
    draw_set_color(#93af78);
    draw_rectangle(scrollbar_x, handle_y, scrollbar_x + scrollbar_w, handle_y + handle_height, false);
}

draw_set_color(c_white);