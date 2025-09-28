#region handle claude button interaction (working) (commented)
//var gui_mouse_x = device_mouse_x_to_gui(0);
//var gui_mouse_y = device_mouse_y_to_gui(0);

//// Check if mouse is over button
//btn_patch.hovering = point_in_rectangle(
//	gui_mouse_x, gui_mouse_y, 
//    btn_patch.xpos, btn_patch.ypos, 
//    btn_patch.xpos + btn_patch.w, btn_patch.ypos + btn_patch.h
//);

//// Handle click
//if (btn_patch.hovering and mouse_check_button_pressed(mb_left)) {
//    btn_patch.pressed = true;
//    // Add your button action here
//    show_debug_message("Button clicked!");
//}

//// Reset pressed state when released
//if (mouse_check_button_released(mb_left)) and (btn_patch.pressed) {
//    btn_patch.pressed = false;
//}
//// Reset pressed state when not hovering over
//if (!btn_patch.hovering) and (btn_patch.pressed) {
//	btn_patch.pressed = false;
//}
#endregion

switch (room) {
	case rm_load: {
		if (keyboard_check_pressed(ord("1"))) {
			// create new save file
			room_goto(rm_main);
			if (instance_exists(obj_farm_manager)) {
				obj_farm_manager.create_starting_farm();
				obj_farm_manager.save_farm_data();
			}
		}
		if (keyboard_check_pressed(ord("2"))) {
			// attempt to load save file
			room_goto(rm_main);
			if (instance_exists(obj_farm_manager)) {
				obj_farm_manager.load_farm_data();
			}
		}
	} break;
	case rm_main: {
		// handle checking for clicks on world objects
		if (mouse_check_button_pressed(mb_left)) and (!obj_gui_manager.click_handled) {
		    click_handled = false;
    
		    // Sort world objects by depth (lower depth = drawn on top)
		    array_sort(world_objects, function(a, b) {
		        return a.depth - b.depth;
		    });
    
		    // Check each element in order
		    for (var i = 0; i < array_length(world_objects); i++) {
		        var element = world_objects[i];
				//show_debug_message("obj_gui_manager STEP: element = "+string(gui_elements[i]));
		        if (instance_exists(element)) and (element.visible) {
		            // Call the element's click check method
			        if (element.check_world_click()) {
			            click_handled = true;
						show_debug_message("obj_master STEP: click handled! "+string(element.id));
			            break; // Stop checking other elements
			        }
		        }
		    }
			//show_debug_message("obj_gui_manager STEP: reached end of click handle.");
		}
	} break;
}