// Inherit the parent event
event_inherited();

if (btn_activated) {
	if (obj_farm_manager.milk_chart_active != 1) obj_farm_manager.milk_chart_active = 1;
} else {
	if (obj_farm_manager.milk_chart_active != 0) obj_farm_manager.milk_chart_active = 0;
}