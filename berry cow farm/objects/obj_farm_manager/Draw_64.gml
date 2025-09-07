#region //// draw milk surface moved to obj_gui_manager
//if (surface_exists(milk_surface)) and (milk_chart_active) {
//    // draw donut pie chart
//	draw_surface(milk_surface, 200 - milk_chart_r2, 200 - milk_chart_r2); // center on 200
	
//	// draw text info
//	var text_xscale = 0.8;
//	var text_yscale = 0.9;
//	var text_ypos = 400;
//	var milk_array = [milk_banana, milk_blackberry, milk_blueberry, milk_raspberry, milk_strawberry];
	
//	for (var i = 0; i < array_length(milk_array); i++) {
//		if (milk_array[i] > 0) {
//			var milk_amount = string(milk_array[i]);
//			var milk_type = "";
//			var milk_color = c_white;
//			switch (i) {
//				case 0: milk_type = "Banana"; milk_color = #fedf6a;
//				break;
//				case 1: milk_type = "Blackberry"; milk_color = #d0b1eb;
//				break;
//				case 2: milk_type = "Blueberry"; milk_color = #927ddd;
//				break;
//				case 3: milk_type = "Raspberry"; milk_color = #f49bce;
//				break;
//				case 4: milk_type = "Strawberry"; milk_color = #d36b9b;
//				break;
//			}
//			draw_set_color(milk_color);
//			draw_rectangle(140, text_ypos, 170, text_ypos + 30, false);
//			draw_set_color(c_white);
//			draw_text_ext_transformed(200, text_ypos, milk_type + "\n" + milk_amount, 50, 999, text_xscale, text_yscale, 0);
//			text_ypos += 120;
//		}
//	}
//}
#endregion