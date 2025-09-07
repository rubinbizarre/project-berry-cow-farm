// Inherit the parent event
event_inherited();

gui_sprite = sprite_index;
gui_x = display_get_gui_width() - (sprite_width + 20);
gui_y = 20;
btn_is_toggle = true;

function handle_click() {
	btn_pressed = true;
	show_debug_message("obj_btn_patch_edit handle_click(): btn pressed!");
}