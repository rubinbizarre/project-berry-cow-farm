if (!instance_exists(obj_cow_shadow)) {
	instance_create_depth(x, y-2, depth+1, obj_cow_shadow);
} else {
	obj_cow_shadow.x = x;
	obj_cow_shadow.y = y-2;
}