// --- Draw Event for obj_button_review ---

// Draw the placeholder sprite (handles idle/hover frame via parent)
draw_self();

// Overlay "REVIEW" text centered on the button
draw_set_font(fnt_button);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(x, y, "REVIEW");
