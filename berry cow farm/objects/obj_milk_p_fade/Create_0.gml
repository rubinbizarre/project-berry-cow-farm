scale = 0.75;
alpha = 1;

//// push gui instance id to gui manager upon creation
//// for layered gui click handling purposes
//if (instance_exists(obj_gui_manager)) {
//	array_push(obj_gui_manager.gui_elements, id);
//}

// move above all buttons when created
with (obj_par_btns) {
	depth = other.depth + 1;
}