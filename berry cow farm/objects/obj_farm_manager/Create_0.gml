patches_map = ds_map_create();  // Key: "x,y", Value: patch data map
cows_list = ds_list_create();   // List of cow data maps
empty_cells_list = ds_list_create(); // Purchasable neighboring cells

autosave_period = 30; // in seconds

camera = view_camera[0];

// Game state variables
farm_level = 1;
farm_milk = 2000;
farm_money = 1000;
patch_size = 256; // Size of each patch in pixels
grid_origin_x = room_width / 2;  // Center the grid in the room
grid_origin_y = room_height / 2;

// Initialize session
//create_starting_farm(); // moved to load_farm_data and runs if save does not exist
load_farm_data();
show_debug_message("obj_farm_manager CREATE: called load_farm_data() ...");
show_debug_message("obj_farm_manager CREATE: game_save_id = "+game_save_id);

// ===== CORE SAVE/LOAD FUNCTIONS =====

function save_farm_data() {
	show_debug_message("obj_farm_manager CREATE: save_farm_data(): beginning save_farm_data");
    var save_data = ds_map_create();
	var save_file_path = game_save_id + "farm_save.json";
    
    // Basic farm info
    ds_map_add(save_data, "money", farm_money);
    ds_map_add(save_data, "level", farm_level);
	ds_map_add(save_data, "milk", farm_milk);
    ds_map_add(save_data, "last_save", date_current_datetime());
    
    #region Save patches as array
	var patches_array = [];
    var patch_key = ds_map_find_first(patches_map);
	var patch_index = 0;
    
    while (!is_undefined(patch_key)) {
        var patch_data = ds_map_find_value(patches_map, patch_key);
        var coords = split_coordinates(patch_key);
        
		// Find the patch instance at these coordinates
		var patch_inst = instance_position(
			grid_origin_x + (coords[0] * patch_size),
			grid_origin_y + (coords[1] * patch_size),
			obj_par_patch
		);
		show_debug_message("obj_farm_manager CREATE: save_farm_data(): Getting details for patch at "+string(coords[0])+","+string(coords[1])+":");
    
		// Get values from the patch instance (with fallback values if instance doesn't exist)
        var production_time_remaining = 0;
        var production_start_time = 0;
        var production_duration = 0;
        var ready_to_harvest = false;
    
		if (instance_exists(patch_inst)) {
		    production_time_remaining = patch_inst.production_time_remaining;
			production_start_time = patch_inst.production_start_time;
			production_duration = patch_inst.production_duration;
			ready_to_harvest = patch_inst.ready_to_harvest;
		}
		
		patches_array[patch_index] = {
            xpos: coords[0],
            ypos: coords[1],
			//world_x: grid_origin_x + (coords[0] * patch_size),
			//world_y: grid_origin_y + (coords[1] * patch_size),
            patch_type: ds_map_find_value(patch_data, "type"),
            patch_level: ds_map_find_value(patch_data, "level"),
			time_remaining: production_time_remaining,
			start_time: production_start_time,
			duration: production_duration,
			is_ready_to_harvest: ready_to_harvest,
        };
		show_debug_message("obj_farm_manager CREATE: save_farm_data(): Saved details: "+json_stringify(patches_array[patch_index]));
        patch_index++;
        patch_key = ds_map_find_next(patches_map, patch_key);
    }
    ds_map_add(save_data, "patches", patches_array);
	#endregion
    
    #region Save cows as array of structs
	var cows_array = [];
    for (var i = 0; i < ds_list_size(cows_list); i++) {
        var cow_data = ds_list_find_value(cows_list, i);
		
		// Create struct for each cow
        cows_array[i] = {
            cow_id: ds_map_find_value(cow_data, "id"),
            cow_type: ds_map_find_value(cow_data, "type"),
            cow_name: ds_map_find_value(cow_data, "name"),
            cow_mood: ds_map_find_value(cow_data, "mood"),
            patch_x: ds_map_find_value(cow_data, "patch_x"),
            patch_y: ds_map_find_value(cow_data, "patch_y"),
        };
        
        // Handle accessories if they exist
        if (ds_map_exists(cow_data, "accessories")) {
            var acc_list = ds_map_find_value(cow_data, "accessories");
            var acc_array = [];
            
            for (var j = 0; j < ds_list_size(acc_list); j++) {
                acc_array[j] = ds_list_find_value(acc_list, j);
            }
            
            cows_array[i].accessories = acc_array;
        }
    }
	ds_map_add(save_data, "cows", cows_array);
	#endregion
    
    // Convert to JSON and save
    var json_string = json_encode(save_data);
    var file = file_text_open_write(save_file_path);
    file_text_write_string(file, json_string);
    file_text_close(file);
    
    // Cleanup
    ds_map_destroy(save_data);
    show_debug_message("obj_farm_manager CREATE: save_farm_data(): Farm data saved successfully!");
}

function load_farm_data() {
	var save_file_path = game_save_id + "farm_save.json";
	
	// if no save file exists, create starting farm, save, and go from there
    if (!file_exists(save_file_path)) {
        show_debug_message("obj_farm_manager CREATE: load_farm_data(): No save file found, creating new farm with create_starting_farm() ...");
        create_starting_farm();
		save_farm_data();
        return false;
    }
    
    var file = file_text_open_read(save_file_path);
	show_debug_message("obj_farm_manager CREATE: load_farm_data(): attempting to read farm_save.json ...");
    var json_string = file_text_read_string(file);
	show_debug_message("obj_farm_manager CREATE: load_farm_data(): farm_save.json stored in json_string");
    file_text_close(file);
    
	// Use json_parse instead of json_decode for proper struct support
	var save_data = json_parse(json_string);
	// assign save_data to global.save_data_local struct for later access
	global.save_data_local = save_data;
	// output debug message showing what save_data_local, thereby also save_data, contains
	show_debug_message(
		"//===============================================//\n"+
		"obj_farm_manager LOAD_FARM_DATA(): save_data_local:\n"+
		string(global.save_data_local)+"\n"+
		"//===============================================//\n"
	);
	
	// Check if JSON parsing failed
    //if (save_data == -1) {
	if (save_data == undefined) {
        show_debug_message("obj_farm_manager CREATE: load_farm_data(): Save file corrupted, creating new farm");
        create_starting_farm();
		save_farm_data();
        return false;
    }
    
    // Clear existing data
    clear_farm_data();
	show_debug_message("obj_farm_manager CREATE: load_farm_data(): called clear_farm_data() ...");
    
    // Load basic info
	farm_money = save_data.money;
	farm_level = save_data.level;
	farm_milk = save_data.milk;
	show_debug_message("obj_farm_manager CREATE: load_farm_data(): loaded farm_money: "+string(farm_money));
	show_debug_message("obj_farm_manager CREATE: load_farm_data(): loaded farm_level: "+string(farm_level));
	show_debug_message("obj_farm_manager CREATE: load_farm_data(): loaded farm_milk: "+string(farm_milk));
    
    #region Load patches from array
    var patches_array = save_data.patches;
	for (var i = 0; i < array_length(patches_array); i++) {
        var patch_struct = patches_array[i];
		
        var patch_inst = create_patch(
			patch_struct.xpos,
			patch_struct.ypos,
			patch_struct.patch_type,
			patch_struct.patch_level,
			patch_struct.start_time,
			patch_struct.time_remaining,
			patch_struct.duration,
			patch_struct.is_ready_to_harvest
		);
		
		//// Handle persistent timer data
	    //var patch_inst = instance_position(patch_struct.xpos, patch_struct.ypos, obj_par_patch);
	    //if (instance_exists(patch_inst)) and (patch_struct.time_remaining > 0) {
	    //    //// Load persistent timer data if it exists
	    //    //if (struct_exists(patch_struct, "production_start_time")) {
	    //    //    patch_inst.production_start_time = patch_struct.production_start_time;
	    //    //    patch_inst.production_duration = patch_struct.production_duration;
	    //    //    patch_inst.ready_to_harvest = patch_struct.ready_to_harvest;
	    //    //}
		//	//patch_inst.production_start_time = patch_struct.production_start_time;
	    //    //patch_inst.production_duration = patch_struct.production_duration;
	    //    //patch_inst.ready_to_harvest = patch_struct.ready_to_harvest;
	    //    // Resume production with correct timing
	    //    patch_inst.resume_production_after_load();
		//	show_debug_message("obj_farm_manager CREATE: load_farm_data(): Patch at "+string(patch_struct.xpos)+","+string(patch_struct.ypos)+" was told to resume production");
	    //}
		
		patch_inst.resume_production_after_load(patch_inst.id, patch_struct.time_remaining);
		
		show_debug_message("obj_farm_manager CREATE: load_farm_data(): loaded "+string(patch_struct.patch_type)+" patch at "+string(patch_struct.xpos)+","+string(patch_struct.ypos));
    }
	#endregion
    
    #region Load cows from array
    var cows_array = save_data.cows;
    for (var i = 0; i < array_length(cows_array); i++) {
        var cow_struct = cows_array[i];
        
        // Create cow data map from struct
        var cow_data = ds_map_create();
        ds_map_add(cow_data, "id", cow_struct.cow_id);
        ds_map_add(cow_data, "type", cow_struct.cow_type);
        ds_map_add(cow_data, "name", cow_struct.cow_name);
        ds_map_add(cow_data, "mood", cow_struct.cow_mood);
        ds_map_add(cow_data, "patch_x", cow_struct.patch_x);
        ds_map_add(cow_data, "patch_y", cow_struct.patch_y);
        
        // Handle accessories if they exist
        if (struct_exists(cow_struct, "accessories")) {
            var acc_list = ds_list_create();
            var acc_array = cow_struct.accessories;
            
            for (var j = 0; j < array_length(acc_array); j++) {
                ds_list_add(acc_list, acc_array[j]);
            }
            
            ds_map_add_list(cow_data, "accessories", acc_list);
        }
        
        ds_list_add(cows_list, cow_data);
        create_cow_object(cow_data);
    }
	#endregion
    
    // Update empty cells for expansion
    update_empty_cells();
    
    //// Cleanup
    //ds_map_destroy(save_data); // not needed ?
	
    show_debug_message("obj_farm_manager CREATE: load_farm_data(): Farm data loaded successfully!");
    return true;
}

// ===== PATCH MANAGEMENT =====

function create_patch(grid_x, grid_y, patch_type, patch_level, patch_start_time, patch_time_remaining, patch_duration, ready_to_harvest) {
	/*
	
	ds map patches_map stores key with patch data like so:
	
		patches_map
			0,0
				type: default
				level: 1
				world_x: 0
				world_y: 0
				max_cows: 2
				current_cows: 1
			1,0
				type: default
				level: 1
				etc.
			etc.
	
	each time you want to add information to patches_map, you need to
	
		1) create a ds map with ds_map_create to store the data (patch_data)
		2) add data to patch_data with ds_map_add such as type, level, etc.
		3) create the string key to store the patch data with inside patches_map (e.g. 0,0)
		4) use ds_map_add_map(patches_map, key, patch_data) to add the data!
	
	*/
	
    var patch_data = ds_map_create();
    ds_map_add(patch_data, "type", patch_type);
    ds_map_add(patch_data, "level", patch_level);
    ds_map_add(patch_data, "world_x", grid_origin_x + (grid_x * patch_size));
    ds_map_add(patch_data, "world_y", grid_origin_y + (grid_y * patch_size));
	ds_map_add(patch_data, "start_time", patch_start_time);
    ds_map_add(patch_data, "time_remaining", patch_time_remaining);
	ds_map_add(patch_data, "duration", patch_duration);
	ds_map_add(patch_data, "is_ready_to_harvest", ready_to_harvest);
	
    // Add patch-specific data
    switch(patch_type) {
        //case "barn":
        //    ds_map_add(patch_data, "max_cows", 2 + patch_level);
        //    ds_map_add(patch_data, "current_cows", 0);
        //    break;
        //case "farmhouse":
        //    ds_map_add(patch_data, "max_patches", 4 + (patch_level * 2));
        //    break;
        //case "woodland":
        //    ds_map_add(patch_data, "mood_bonus", 0.1 * patch_level);
        //    break;
		case "default": {
			ds_map_add(patch_data, "max_cows", 1 + patch_level);
			//ds_map_add(patch_data, "current_cows", count_cows_in_patch());
		} break;
    }
    
    var key = string(grid_x) + "," + string(grid_y);
    ds_map_add_map(patches_map, key, patch_data);
    
    // Create visual patch object
    var patch_obj = instance_create_layer(
        ds_map_find_value(patch_data, "world_x"),	// x
        ds_map_find_value(patch_data, "world_y"),	// y
        "Patches",									// layer
        get_patch_object(patch_type)				// obj
    );
    
    // Link patch object to data
    patch_obj.grid_x = grid_x;
    patch_obj.grid_y = grid_y;
    patch_obj.patch_data = patch_data;
    
    return patch_obj;
}

function get_patch_object(patch_type) {
    switch(patch_type) {
        case "Default": return obj_patch_default;
        //case "barn": return obj_patch_barn;
        //case "farmhouse": return obj_patch_farmhouse;
        //case "woodland": return obj_patch_woodland;
        default: return obj_patch_default;
    }
}

function can_purchase_patch(grid_x, grid_y) {
    var key = string(grid_x) + "," + string(grid_y);
    return !ds_map_exists(patches_map, key) && is_adjacent_to_farm(grid_x, grid_y);
}

function is_adjacent_to_farm(grid_x, grid_y) {
    // Check if at least one neighboring cell has a patch
    var neighbors = [
        string(grid_x - 1) + "," + string(grid_y),
        string(grid_x + 1) + "," + string(grid_y),
        string(grid_x) + "," + string(grid_y - 1),
        string(grid_x) + "," + string(grid_y + 1)
    ];
    
    for (var i = 0; i < array_length(neighbors); i++) {
        if (ds_map_exists(patches_map, neighbors[i])) {
            return true;
        }
    }
    return false;
}

function update_empty_cells() {
    ds_list_clear(empty_cells_list);
    
    #region Check all existing patches for empty neighbors
    var patch_key = ds_map_find_first(patches_map);
    while (!is_undefined(patch_key)) {
        var coords = split_coordinates(patch_key);
        var gx = coords[0];
        var gy = coords[1];
        
        // Check 4 adjacent cells
        var adjacent_cells = [
            [gx - 1, gy], [gx + 1, gy], [gx, gy - 1], [gx, gy + 1]
        ];
        
        for (var i = 0; i < array_length(adjacent_cells); i++) {
            var check_x = adjacent_cells[i][0];
            var check_y = adjacent_cells[i][1];
            
            if (can_purchase_patch(check_x, check_y)) {
                var cell_data = ds_map_create();
                ds_map_add(cell_data, "grid_x", check_x);
                ds_map_add(cell_data, "grid_y", check_y);
                ds_map_add(cell_data, "world_x", grid_origin_x + (check_x * patch_size));
                ds_map_add(cell_data, "world_y", grid_origin_y + (check_y * patch_size));
                
                // Avoid duplicates
                var already_exists = false;
                for (var j = 0; j < ds_list_size(empty_cells_list); j++) {
                    var existing = ds_list_find_value(empty_cells_list, j);
                    if (ds_map_find_value(existing, "grid_x") == check_x && 
                        ds_map_find_value(existing, "grid_y") == check_y) {
                        already_exists = true;
                        break;
                    }
                }
                
                if (!already_exists) {
                    ds_list_add(empty_cells_list, cell_data);
                }
            }
        }
        
        patch_key = ds_map_find_next(patches_map, patch_key);
    }
	#endregion
    
    #region Create visual empty cell objects
    with (obj_patch_empty) {
        instance_destroy();
    }
    
    for (var i = 0; i < ds_list_size(empty_cells_list); i++) {
        var cell_data = ds_list_find_value(empty_cells_list, i);
        var empty_obj = instance_create_layer(
            ds_map_find_value(cell_data, "world_x"),
            ds_map_find_value(cell_data, "world_y"),
            "Patches",
            obj_patch_empty
        );
        empty_obj.cell_data = cell_data;
    }
	#endregion
	
	show_debug_message("obj_farm_manager CREATE: update_empty_cells(): reached end");
}

// ===== COW MANAGEMENT =====

function create_cow_from_save_data(cow_save) {
    var cow_data = ds_map_create();
    ds_map_add(cow_data, "id", ds_map_find_value(cow_save, "id"));
    ds_map_add(cow_data, "type", ds_map_find_value(cow_save, "type"));
    ds_map_add(cow_data, "name", ds_map_find_value(cow_save, "name"));
    ds_map_add(cow_data, "mood", ds_map_find_value(cow_save, "mood"));
    ds_map_add(cow_data, "patch_x", ds_map_find_value(cow_save, "patch_x"));
    ds_map_add(cow_data, "patch_y", ds_map_find_value(cow_save, "patch_y"));
    ds_map_add(cow_data, "last_milked", ds_map_find_value(cow_save, "last_milked"));
    
    // Handle accessories
    if (ds_map_exists(cow_save, "accessories")) {
        var acc_list = ds_list_create();
        ds_list_copy(acc_list, ds_map_find_value(cow_save, "accessories"));
        ds_map_add_list(cow_data, "accessories", acc_list);
    }
    
    ds_list_add(cows_list, cow_data);
	show_debug_message("obj_farm_manager CREATE: create_cow_from_save_data(): "+string(ds_map_find_value(cow_save, "id"))+" cow data retrieved");
    
    // Create visual cow object
    var cow_obj = create_cow_object(cow_data);
	show_debug_message("obj_farm_manager CREATE: create_cow_from_save_data(): called create_cow_object() with cow data ...");
    return cow_obj;
}

function create_cow_object(cow_data) {
    var patch_x = ds_map_find_value(cow_data, "patch_x");
    var patch_y = ds_map_find_value(cow_data, "patch_y");
    var patch_key = string(patch_x) + "," + string(patch_y); // e.g. 0,0
    var patch_data = ds_map_find_value(patches_map, patch_key);
    
    var world_x = ds_map_find_value(patch_data, "world_x");
    var world_y = ds_map_find_value(patch_data, "world_y");
    
    var cow_obj = instance_create_layer(
        world_x + random_range(-100, 100), // Random area around patch centre, not too close to edge
        world_y + random_range(-100, 100),
        "Instances",
        get_cow_object_from_type(ds_map_find_value(cow_data, "type"))
    );
    
    //cow_obj.cow_data = cow_data;
   
    show_debug_message("obj_farm_manager CREATE: create_cow_object(): "+string(cow_obj)+" cow added to farm");
    return cow_obj;
}

function get_cow_object_from_type(cow_type) {
    switch(cow_type) {
		case "Blackberry": return obj_cow_bb;
		case "Banana": return obj_cow_nana;
        //case "strawberry": return obj_cow_strawberry;
        //case "chocolate": return obj_cow_chocolate;
        //case "vanilla": return obj_cow_vanilla;
        //case "blueberry": return obj_cow_blueberry;
        default: return obj_cow_bb;
    }
}

// ===== UTILITY FUNCTIONS =====

function split_coordinates(coord_string) {
    var comma_pos = string_pos(",", coord_string);
    var x_str = string_copy(coord_string, 1, comma_pos - 1);
    var y_str = string_copy(coord_string, comma_pos + 1, string_length(coord_string));
    return [real(x_str), real(y_str)];
}

function create_starting_farm() {
    clear_farm_data();
    var patch_obj_1 = create_patch(0, 0, "Default", 1, 0, 0, 0, 0); // populates patches_map ds map
	var patch_obj_2 = create_patch(1, 0, "Default", 1, 0, 0, 0, 0);
    update_empty_cells();
	
	// add first cow:
	var cow_data = ds_map_create();
    ds_map_add(cow_data, "type", "Blackberry");
    ds_map_add(cow_data, "name", "BB");
    ds_map_add(cow_data, "mood", 0.5);
    ds_map_add(cow_data, "patch_x", 0);
    ds_map_add(cow_data, "patch_y", 0);
	var cow_obj = create_cow_object(cow_data);
	ds_map_add(cow_data, "id", cow_obj.id);
	ds_list_add(cows_list, cow_data);
	
	// add second cow:
	var cow_data_2 = ds_map_create();
	ds_map_add(cow_data_2, "type", "Banana");
	ds_map_add(cow_data_2, "name", "Nana");
	ds_map_add(cow_data_2, "mood", 0.8);
	ds_map_add(cow_data_2, "patch_x", 0);
	ds_map_add(cow_data_2, "patch_y", 0);
	var cow_obj_2 = create_cow_object(cow_data_2);
	ds_map_add(cow_data_2, "id", cow_obj_2.id);
	ds_list_add(cows_list, cow_data_2);
	
	// update patches current cow count
	patch_obj_1.start_patch_time();
	patch_obj_2.start_patch_time();
	
	show_debug_message("obj_farm_manager CREATE: create_starting_farm(): reached end");
}

function clear_farm_data() {
    // Clear all visual objects
    with (obj_par_patch) instance_destroy();
    with (obj_par_cow) instance_destroy();
    with (obj_patch_empty) instance_destroy();
    
    // Clear data structures
    var patch_key = ds_map_find_first(patches_map);
    while (!is_undefined(patch_key)) {
        var patch_data = ds_map_find_value(patches_map, patch_key);
        ds_map_destroy(patch_data);
        patch_key = ds_map_find_next(patches_map, patch_key);
    }
    ds_map_clear(patches_map);
    
    for (var i = 0; i < ds_list_size(cows_list); i++) {
        var cow_data = ds_list_find_value(cows_list, i);
        if (ds_map_exists(cow_data, "accessories")) {
            ds_list_destroy(ds_map_find_value(cow_data, "accessories"));
        }
        ds_map_destroy(cow_data);
    }
    ds_list_clear(cows_list);
    
    for (var i = 0; i < ds_list_size(empty_cells_list); i++) {
        var cell_data = ds_list_find_value(empty_cells_list, i);
        ds_map_destroy(cell_data);
    }
    ds_list_clear(empty_cells_list);
	
	show_debug_message("obj_farm_manager CREATE: clear_farm_data(): reached end of clear_farm_data()");
}

//// initiate autosave cycle after autosave period
//alarm[0] = game_get_speed(gamespeed_fps) * autosave_period;

// Clean up on game end
function cleanup_farm_manager() {
    clear_farm_data();
    ds_map_destroy(patches_map);
    ds_list_destroy(cows_list);
    ds_list_destroy(empty_cells_list);
}