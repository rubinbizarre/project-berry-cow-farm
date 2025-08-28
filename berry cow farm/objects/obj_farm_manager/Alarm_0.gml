///@desc autosave

if (alarm[0] <= 0) {
    save_farm_data();
	show_debug_message("obj_farm_manager ALARM_0: called save_farm_data() ...");
    alarm[0] = game_get_speed(gamespeed_fps) * autosave_period; // Reset timer
	show_debug_message("obj_farm_manager ALARM_0: next autosave in "+string(autosave_period)+" seconds ...");
}