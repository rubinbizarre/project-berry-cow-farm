// Inherit the parent event
event_inherited();

sprite_idle = spr_cow_bb_idle;
sprite_walking = spr_cow_bb_walking;
sprite_sit = spr_cow_bb_sit;
sprite_rest = spr_cow_bb_rest;
sprite_stand = spr_cow_bb_stand;

// parameters used in determining how far the cow moves when walking
// ranges may be different for each cow, so they're here for individual tweaking
// as well as being initialised in obj_par_cow with default values
x_range_min = 20;
x_range_max = 50;
y_range_min = 20;
y_range_max = 50;