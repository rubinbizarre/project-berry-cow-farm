// Clamp t to avoid weird values
var tt = clamp(t, 0, 1);

// Linear interpolation along the line
var xpos = lerp(start_x, end_x, tt);
var ypos = lerp(start_y, end_y, tt);

//// Scale sprite slightly over time
//var sc = lerp(scale_start, scale_end, tt);
var sc = 0.75;

// Draw sprite
draw_sprite_ext(sprite_index, 0, xpos, ypos, sc, sc, 0, c_white, 1);
