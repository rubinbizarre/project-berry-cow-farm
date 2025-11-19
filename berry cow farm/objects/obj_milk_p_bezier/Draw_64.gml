

//// Optional slight scale-in/out
//var scale = lerp(0.6, 1, t);
var scale = 0.75; // same as obj_milk_button

// Draw sprite
draw_sprite_ext(sprite_index, 0, xpos, ypos, scale, scale, 0, c_white, 1);
