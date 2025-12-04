draw_set_halign(fa_center);
draw_set_valign(fa_middle);
if (variable_instance_exists(id, "fnt_dialogue")) draw_set_font(fnt_dialogue); 
else draw_set_font(-1);

// Shadow
draw_set_alpha(image_alpha);
draw_set_color(c_black);
draw_text_transformed(x + 2, y + 2, string(damage_amount), scale, scale, 0);

// Main Text
draw_set_color(color);
draw_text_transformed(x, y, string(damage_amount), scale, scale, 0);

// Reset
draw_set_color(c_white);
draw_set_alpha(1);