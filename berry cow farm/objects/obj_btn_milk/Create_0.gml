// Inherit the parent event
event_inherited();

gui_sprite = sprite_index;
gui_x = display_get_gui_width()/2 + 30;
gui_y = 22;

btn_is_toggle = true;

btn_scale = 0.75;

function handle_click() {
	btn_activated = !btn_activated;
	show_debug_message("obj_btn_patch_edit handle_click(): btn pressed!");
}