// 1. Draw Bright White Background
draw_set_color(c_white);
draw_rectangle(x, y, x + 64, y + 64, false); // Filled box

// 2. Draw Black Outline
draw_set_color(c_black);
draw_rectangle(x, y, x + 64, y + 64, true);  // Border

// 3. Draw Letter (Black Text)
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

if (variable_instance_exists(id, "fnt_dialogue")) draw_set_font(fnt_dialogue); 
else draw_set_font(-1);

draw_set_color(c_black);
// Draw in the center of the 64x64 box (32, 32)
draw_text_transformed(x + 32, y + 32, my_char, 2, 2, 0); 

// Reset
draw_set_color(c_white);