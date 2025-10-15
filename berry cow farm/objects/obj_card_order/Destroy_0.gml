// leave from gui manager's list when destroyed
var index = array_get_index(obj_gui_manager.gui_elements, id);
if (index >= 0) {
	array_delete(obj_gui_manager.gui_elements, index, 1);
	show_debug_message("obj_card_order: unregistered "+string(id)+" from GUI manager");
}