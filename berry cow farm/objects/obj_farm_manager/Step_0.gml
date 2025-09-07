if (milk_total != milk_total_previous) or (!surface_exists(milk_surface)) {
	// recreate milk chart surface when milk_total changes or surface doesn't exist
    make_milk_chart(
		200,
		200,//view_get_hport(0)/2,
		milk_chart_r1,
		milk_chart_r2,
		[milk_banana, milk_blackberry, milk_blueberry, milk_raspberry, milk_strawberry],
		[ #fedf6a, #d0b1eb, #927ddd, #f49bce, #d36b9b ]
	);
	
    milk_total_previous = milk_total;
	
	show_debug_message("obj_farm_manager STEP: created new milk pie chart surface");
}

