//draw_pie_slice(
//	display_get_gui_width()/5,
//	display_get_gui_height()/2,
//	100,
//	300,
//	0,
//	-90,
//	c_navy
//);

//draw_set_color(c_white);


//if (surface_exists(milk_surface))
//{
//    draw_surface(milk_surface, 200 - 80, 200 - 80); // center at (200,200)
//}

//// Optional: text in the donut hole
//draw_set_halign(fa_center);
//draw_set_valign(fa_middle);
//draw_set_color(c_white);
//draw_text(200, 200, string(milk_total) + "/" + "99999"); // string(max_capacity));


//// working
//var start_angle = -90;

//var angle_banana = 360 * (milk_banana / milk_total); // 360 * 0.5 = 180
//draw_pie_slice(200, view_get_hport(0)/2, 40, 80, start_angle, start_angle + angle_banana, c_yellow);
//start_angle += angle_banana;

//var angle_blackberry = 360 * (milk_blackberry / milk_total);
//draw_pie_slice(200, view_get_hport(0)/2, 40, 80, start_angle, start_angle + angle_blackberry, c_purple);

//draw_set_color(c_white);


if (surface_exists(milk_surface)) {
    draw_surface(milk_surface, 200 - milk_chart_r2, 200 - milk_chart_r2); // center on 200
}