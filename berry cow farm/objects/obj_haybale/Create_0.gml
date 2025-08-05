depth = -y;
var _haybale_depth = depth;

with instance_create_layer(x, y, "Instances", obj_haybale_shadow) {
	depth = _haybale_depth + 1;
}