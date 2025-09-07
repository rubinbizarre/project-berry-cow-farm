// Button properties
btn_pressed = false;
btn_hover = false;
btn_activated = false; // toggle
btn_is_toggle = false;
btn_at_hover = noone;

gui_sprite = spr_collision;
gui_x = 20;
gui_y = 20;

// push gui instance id to gui manager upon creation
// for layered gui click handling purposes
if (instance_exists(obj_gui_manager)) {
	array_push(obj_gui_manager.gui_elements, id);
}

function check_gui_click() {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    if (point_in_rectangle(mx, my, gui_x, gui_y, gui_x + sprite_get_width(gui_sprite), gui_y + sprite_get_height(gui_sprite))) {
        handle_click();
		//show_debug_message("obj_par_btns check_gui_click(): "+string(id)+" called handle_click()");
        return true;
    }
	//show_debug_message("obj_par_btns check_gui_click(): "+string(id)+" did not call handle_click()");
    return false;
}