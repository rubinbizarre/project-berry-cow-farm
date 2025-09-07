gui_sprite = spr_window_milk;
gui_x = 40;
gui_y = 120;

cancel_sprite = spr_btn_cancel;
cancel_subimage = 0;
cancel_corner_offset = 34;
//cancel_x = window_x + sprite_get_width(window_sprite) - sprite_get_width(cancel_sprite) - cancel_corner_offset;
//cancel_y = window_y + cancel_corner_offset;

window_hover = false;
window_pressed = false;
window_released = false;
window_dragging = false;

cancel_hover = false;
cancel_pressed = false;

mouse_prev_x = 0;
mouse_prev_y = 0;
mouse_offset_x = 0;
mouse_offset_y = 0;

// for determining window on top (future?)
//window_active = false; //noone; 

// move below all buttons when created
with (obj_par_btns) {
	depth = other.depth - 1;
}

// push gui instance id to gui manager upon creation
// for layered gui click handling purposes
if (instance_exists(obj_gui_manager)) {
	array_push(obj_gui_manager.gui_elements, id);
}

function check_gui_click() {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    //if (point_in_rectangle(mx, my, x, y, x + sprite_get_width(sprite_index), y + sprite_get_height(sprite_index))) {
	//if (point_in_rectangle(mx, my, btn_x, btn_y, btn_x + sprite_get_width(btn_sprite), btn_y + sprite_get_height(btn_sprite))) {
	if (point_in_rectangle(mx, my, gui_x, gui_y, gui_x + sprite_get_width(gui_sprite), gui_y + sprite_get_height(gui_sprite))) {
        handle_click();
		//show_debug_message("obj_par_window check_gui_click(): "+string(id)+" called handle_click()");
        return true;
    }
	
	//show_debug_message("obj_par_window check_gui_click(): "+string(id)+" did not call handle_click()");
    return false;
}