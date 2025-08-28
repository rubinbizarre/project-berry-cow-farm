// Inherit the parent event
event_inherited();

sprite_idle = spr_cow_nana_idle;
sprite_walking = spr_cow_nana_walking;
sprite_sit = spr_cow_nana_sit;
sprite_rest = spr_cow_nana_rest;
sprite_stand = spr_cow_nana_stand;

// parameters used in determining how far the cow moves when walking
// ranges may be different for each cow, so they're here for individual tweaking
// as well as being initialised in obj_par_cow with default values
x_range_min = 20;
x_range_max = 40;
y_range_min = 20;
y_range_max = 40;

// save data:
cow_type = "Banana";
// should be overwritten by stored data:
cow_name = "Nana";
cow_mood = 0.8;