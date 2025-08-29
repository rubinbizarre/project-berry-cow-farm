if (milk_total != milk_total_previous) or (!surface_exists(milk_surface)) {
	// make milk chart surface
    make_milk_chart(
		200,
		200,//view_get_hport(0)/2,
		milk_chart_r1,
		milk_chart_r2,
		[milk_banana, milk_blackberry, milk_blueberry, milk_raspberry, milk_strawberry],
		[c_yellow, c_purple, c_blue, c_fuchsia, c_red]
	);
	
    milk_total_previous = milk_total;
	
	show_debug_message("obj_farm_manager STEP: created new milk pie chart surface");
}

