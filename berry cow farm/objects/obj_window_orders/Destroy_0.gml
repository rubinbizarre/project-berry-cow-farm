// Inherit the parent event
event_inherited();

if (instance_exists(obj_card_order)) {
	instance_destroy(obj_card_order);
}
