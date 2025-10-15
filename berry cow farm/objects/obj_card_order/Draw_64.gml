if (order_data == noone) return;

// determine card appearance
var alpha = 1.0;
var subimage = 0;
if (!can_afford) alpha = 0.5;
if (is_hovered) and (can_afford) subimage = 1;

draw_sprite_ext(spr_card_order, subimage, card_x, card_y, 1, 1, 0, c_white, alpha);

// draw highlighted overlay rectangle when active
if (is_active) {
	draw_set_alpha(0.3);
	var time_left = order_data.time_to_complete - (current_time - order_data.start_time) / 1000;
	var time_left_as_percentage = time_left / order_data.time_to_complete;
	//show_debug_message(string(time_left_as_percentage));
	draw_rectangle(card_x, card_y, (card_x + sprite_width) * time_left_as_percentage, card_y + sprite_height, false);
	draw_set_alpha(1);
}

// draw order details
var text_x = card_x + 10;
var text_y = card_y + card_h/2;
//var text_color = can_afford ? #536641 : c_gray;

//draw_set_color(text_color);
draw_set_color(#536641);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

//draw_text_transformed(text_x, text_y, order_data.milk_type, 1, 1.2, 0);
draw_text_transformed(text_x + 150, text_y, string(order_data.milk_amount) + "ml", 1, 1.2, 0);
draw_set_halign(fa_right);
draw_text_transformed(text_x + 950, text_y, "$" + string(order_data.reward), 1, 1.2, 0);
draw_set_halign(fa_center);

var time_text_x = text_x + sprite_get_width(sprite_index)/2 + 50;
if (is_active) {
	// show time left on clock for active orders
	var time_left = order_data.time_to_complete - (current_time - order_data.start_time) / 1000;
	var time_conversion = convert_to_mins_and_secs(time_left);
	if (time_conversion.minutes > 0) {
		draw_text_transformed(time_text_x, text_y, string(time_conversion.minutes) + "m " + string(time_conversion.seconds) + "s", 1, 1.2, 0);
	} else {
		draw_text_transformed(time_text_x, text_y, string(time_conversion.seconds) + "s", 1, 1.2, 0);
	}
} else {
	// show time to complete for orders
	//draw_text_transformed(time_text_x, text_y, string(order_data.time_to_complete) + "s", 1, 1.2, 0);
	var time_conversion = convert_to_mins_and_secs(order_data.time_to_complete);
	if (time_conversion.minutes > 0) and (time_conversion.seconds == 0) {
		draw_text_transformed(time_text_x, text_y, string(time_conversion.minutes) + "min", 1, 1.2, 0);
	} else if (time_conversion.minutes > 0) {
		draw_text_transformed(time_text_x, text_y, string(time_conversion.minutes) + "m " + string(time_conversion.seconds) + "s", 1, 1.2, 0);
	} else {
		draw_text_transformed(time_text_x, text_y, string(time_conversion.seconds) + "s", 1, 1.2, 0);
	}
}

draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);