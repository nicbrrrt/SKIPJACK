// --- Draw Event of obj_battle_button ---

// 1. SET SIZE (32x32 Total Size)
// We use 16 because it's the distance from center to edge (16+16=32)
var _size = 16; 

// 2. DRAW BOX (CENTERED on x,y)
// By using (x - size) and (x + size), the button centers perfectly on the orbit line.
draw_set_color(c_white);
draw_rectangle(x - _size, y - _size, x + _size, y + _size, false); // Fill

draw_set_color(c_black);
draw_rectangle(x - _size, y - _size, x + _size, y + _size, true);  // Border

// 3. DRAW TEXT (Centered and Smaller)
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (variable_instance_exists(id, "fnt_dialogue")) draw_set_font(fnt_dialogue); 
else draw_set_font(-1);

draw_set_color(c_black);
// Draw exactly at x,y (since the box is centered now)
// Scale 1.0 looks crisp and fits inside the 32px box.
draw_text_transformed(x, y, my_char, 1, 1, 0); 

// Reset
draw_set_color(c_white);