//order_milk_type = "";
//order_milk_amount = 0;
//order_time_to_complete = 0;
//order_reward = 0;

//randomize_order();

//function randomize_order() {
//	var factor = irandom_range(1, 6);
//	order_milk_type = choose("blackberry", "banana");
//	order_milk_amount = 500 * factor;
//	order_time_to_complete = 60 * factor; // how many minutes
//	order_reward = (500 * factor) * 1.5;
//}


order_data = noone; // hold the order struct
//card_x = 0;
//card_y = 0;
card_x = obj_gui_manager.last_window_jobs_gui_x + 25;
card_y = obj_gui_manager.last_window_jobs_gui_y;
if (array_length(obj_farm_manager.orders_active) > 0) card_y = obj_gui_manager.last_window_jobs_gui_y + 200;
card_w = sprite_get_width(spr_card_order);
card_h = sprite_get_height(spr_card_order);

is_hovered = false;
is_active = false;
can_afford = false;

// register with gui_manager
if (instance_exists(obj_gui_manager)) {
	array_push(obj_gui_manager.gui_elements, id);
}

function check_gui_click() {
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	
	if (point_in_rectangle(mx, my, card_x, card_y, card_x + card_w, card_y + card_h)) {
		handle_click();
		return true;
	}
	return false;
}

function handle_click() {
	if (!is_active) and (can_afford) {
		// accept the order
		obj_farm_manager.accept_order(order_data);
		is_active = true;
		show_debug_message("obj_card_order handle_click(): order accepted! "+string(order_data.milk_type));
	}
}

function update_hover_state() {
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	is_hovered = point_in_rectangle(mx, my, card_x, card_y, card_x + card_w, card_y + card_h);
}

function check_affordability() {
	// check if player has enough milk for this order
	can_afford = obj_farm_manager.has_milk(order_data.milk_type, order_data.milk_amount);
}

