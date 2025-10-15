if (instance_exists(obj_window_orders)) and (obj_window_orders.visible) {
	update_hover_state();
	check_affordability();
}

//if (instance_exists(obj_window_orders)) {
//	card_x = obj_window_orders.gui_x + 20;
//	card_y = obj_window_orders.gui_y + 200;
//}