// Inherit the parent event
event_inherited();

gui_sprite = spr_btn_jobs;
gui_x = display_get_gui_width() - (sprite_width + 20);
gui_y = display_get_gui_height() - (sprite_height + 20)*2;

btn_is_toggle = true;

function handle_click() {
	btn_pressed = true;
	show_debug_message("obj_btn_jobs handle_click(): btn pressed!");
}