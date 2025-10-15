// Inherit the parent event
event_inherited();

gui_sprite = spr_window_orders;
gui_w = sprite_get_width(gui_sprite);
gui_h = sprite_get_height(gui_sprite);
gui_x = obj_gui_manager.last_window_jobs_gui_x;
gui_y = obj_gui_manager.last_window_jobs_gui_y;

scroll_y = 0;
scroll_max = 0;
card_spacing = 10;
card_display_y = gui_y + 170; // start below window header

order_cards = [];

needs_card_refresh = false;

// scrollbar properties
scrollbar_w = 20;
scrollbar_h = gui_h - 170;
scrollbar_x = gui_x + gui_w - scrollbar_w - 18;
scrollbar_y = gui_y + 155;

is_scrolling = false;

create_order_cards();

function create_order_cards() {
	// clear existing cards
	for (var i = 0; i < array_length(order_cards); i++) {
		if (instance_exists(order_cards[i])) {
			instance_destroy(order_cards[i]);
		}
	}
	order_cards = [];
	
	// create cards for available orders
	var card_h = sprite_get_height(spr_card_order);
	var y_offset = 0;
	
	for (var i = 0; i < array_length(obj_farm_manager.orders_available); i++) {
		var card = instance_create_layer(0, 0, "GUI", obj_card_order);
		card.order_data = obj_farm_manager.orders_available[i];
		//card.card_x = gui_x + 10;
		//card.card_y = card_display_y + y_offset - scroll_y;
		card.is_active = false;
		
		array_push(order_cards, card);
		y_offset += card_h + card_spacing;
	}
	
	// create cards for active orders
	for (var i = 0; i < array_length(obj_farm_manager.orders_active); i++) {
		var card = instance_create_layer(0, 0, "GUI", obj_card_order);
		card.order_data = obj_farm_manager.orders_active[i];
		//card.card_x = gui_x + 10;
		//card.card_y = card_display_y + y_offset - scroll_y;
		card.is_active = true;
		
		array_push(order_cards, card);
		y_offset += card_h + card_spacing;
	}
	
	// calculate max scroll
	scroll_max = max(0, y_offset - (gui_h - 60));
}

function check_gui_click() {
	var mx = device_mouse_x_to_gui(0);
	var my = device_mouse_y_to_gui(0);
	
	// check scrollbar first
	if (point_in_rectangle(mx, my, scrollbar_x, scrollbar_y, scrollbar_x + scrollbar_w, scrollbar_y + scrollbar_h)) {
		is_scrolling = true;
		return true;
	}
	
	// check window area
	if (point_in_rectangle(mx, my, gui_x, gui_y, gui_x + gui_w, gui_y + gui_h)) {
		handle_click();
		return true;
	}
	return false;
}

function handle_click() {
	if (!window_pressed) and (window_hover) {
		var gui_mouse_x = device_mouse_x_to_gui(0);
		var gui_mouse_y = device_mouse_y_to_gui(0);
		window_pressed = true;
		mouse_prev_x = gui_mouse_x;
		mouse_prev_y = gui_mouse_y;
		mouse_offset_x = mouse_prev_x - gui_x;
		mouse_offset_y = mouse_prev_y - gui_y;
		show_debug_message("obj_window_jobs handle_click(): window pressed");
	}	
}

function update_scroll() {
	// mouse wheel scrolling
	if (mouse_check_button(mb_left)) and (is_scrolling) {
        var my = device_mouse_y_to_gui(0);
        var scroll_percent = clamp((my - scrollbar_y) / scrollbar_h*2, 0, 1);
        scroll_y = scroll_percent * scroll_max;
    }
    
    if (mouse_check_button_released(mb_left)) {
        is_scrolling = false;
    }
	
	//// mouse wheel support
	//var wheel = mouse_wheel_down() - mouse_wheel_up();
    //scroll_y = clamp(scroll_y + wheel * 30, 0, scroll_max);
	
	// update card positions
    var card_height = sprite_get_height(spr_card_order);
	// go through active cards first
	var card_count = 0;
    for (var i = 0; i < array_length(order_cards); i++) {
        if (instance_exists(order_cards[i])) {
			if (order_cards[i].is_active) {
				order_cards[i].card_y = card_display_y + (card_count * (card_height + card_spacing)) - scroll_y;
				card_count += 1;
			}
        }
    }
	// go through available cards
	//var active_offset = 0;
	//if (array_length(obj_farm_manager.orders_active) > 0) {
	//	active_offset = 200;
	//}
	for (var i = 0; i < array_length(order_cards); i++) {
        if (instance_exists(order_cards[i])) {
			if (!order_cards[i].is_active) {
				order_cards[i].card_y = card_display_y + (card_count * (card_height + card_spacing)) - scroll_y;
				card_count += 1;
			}
		}
	}
}