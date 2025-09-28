if (mouse_check_button_pressed(mb_left)) {
	//show_debug_message("obj_gui_manager STEP: beginning click handle ...");
    click_handled = false;
    
    // Sort GUI elements by depth (lower depth = drawn on top)
    array_sort(gui_elements, function(a, b) {
        return a.depth - b.depth;
    });
    
    // Check each element in order
    for (var i = 0; i < array_length(gui_elements); i++) {
        var element = gui_elements[i];
		//show_debug_message("obj_gui_manager STEP: element = "+string(gui_elements[i]));
        if (instance_exists(element)) and (element.visible) {
            // Call the element's click check method
	        if (element.check_gui_click()) {
	            click_handled = true;
				show_debug_message("obj_gui_manager STEP: click handled! "+string(element.id));
	            break; // Stop checking other elements
	        }
        }
    }
	
	if (!click_handled) {
		if (selected_patch_id != noone) {
			selected_patch_id = noone;
			show_debug_message("obj_gui_manager STEP: reset selected_patch_id to noone");
		}
	}
	//show_debug_message("obj_gui_manager STEP: reached end of click handle.");
}

if (instance_exists(obj_btn_milk)) {
	if (obj_btn_milk.btn_activated) {
		if (!instance_exists(obj_window_milk)) {
			var window = instance_create_layer(0, 0, "GUI", obj_window_milk);
			window.gui_x = last_window_milk_gui_x;
			window.gui_y = last_window_milk_gui_y;
		}
	} else {
		if (instance_exists(obj_window_milk)) {
			last_window_milk_gui_x = obj_window_milk.gui_x;
			last_window_milk_gui_y = obj_window_milk.gui_y;
			//show_debug_message("milk_gui_x: "+string(obj_window_milk.gui_x));
			//show_debug_message("milk_gui_y: "+string(obj_window_milk.gui_y));
			instance_destroy(obj_window_milk);
		}
	}
}

if (instance_exists(obj_btn_jobs)) {
	if (obj_btn_jobs.btn_activated) {
		if (!instance_exists(obj_window_jobs)) {
			var window = instance_create_layer(0, 0, "GUI", obj_window_jobs);
			window.gui_x = last_window_jobs_gui_x;
			window.gui_y = last_window_jobs_gui_y;
		}
	} else {
		if (instance_exists(obj_window_jobs)) {
			last_window_jobs_gui_x = obj_window_jobs.gui_x;
			last_window_jobs_gui_y = obj_window_jobs.gui_y;
			instance_destroy(obj_window_jobs);
		}
	}
}