// leave from gui manager's list when destroyed
var index = array_get_index(obj_master.world_objects, id);
if (index >= 0) array_delete(obj_master.world_objects, index, 1);