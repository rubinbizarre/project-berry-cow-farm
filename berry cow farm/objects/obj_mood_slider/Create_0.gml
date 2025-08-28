// if cow mood is longer than one decimal place, round to one decimal place & store separately
// this may be more useful just for obj_mood_slider
var cow_mood_processed = 0.0;
var rounded = round(global.tracked_cow.cow_mood * 10) / 10;

if (rounded == global.tracked_cow.cow_mood) {
	cow_mood_processed = global.tracked_cow.cow_mood;
} else {
	cow_mood_processed = rounded;
}
//// above if/else statement simplified:
//(rounded == global.tracked_cow.cow_mood) ? cow_mood_processed = global.tracked_cow.cow_mood : cow_mood_processed = rounded;

// if valid, assign correct frame to mood slider object
if (cow_mood_processed < 0) {
	image_index = 0;
	show_debug_message("obj_mood_slider CREATE: cow_mood_processed was less than 0!!! ("+string(cow_mood_processed)+") assigned frame 0");
} else if (cow_mood_processed > 10) {
	image_index = 10;
	show_debug_message("obj_mood_slider CREATE: cow_mood_processed was higher than 10! ("+string(cow_mood_processed)+") assigned frame 10");
} else {
	image_index = cow_mood_processed * 10; // 0.0 becomes 0, 0.1 becomes 1, 0.2 becomes 2, etc.
}