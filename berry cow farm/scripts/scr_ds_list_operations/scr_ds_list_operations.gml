function ds_list_to_string(list) {
    var str = "[";
    for (var i = 0; i < ds_list_size(list); i++) {
        str += string(ds_list_find_value(list, i));
        if (i < ds_list_size(list) - 1) {
            str += ", ";
        }
    }
    str += "]";
    return str;
}

function ds_map_to_string(map) {
    var str = "{";
    var key = ds_map_find_first(map);
    var first = true;
    
    while (!is_undefined(key)) {
        if (!first) str += ", ";
        str += string(key) + ":" + string(ds_map_find_value(map, key));
        key = ds_map_find_next(map, key);
        first = false;
    }
    str += "}";
    return str;
}