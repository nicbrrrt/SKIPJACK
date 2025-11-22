// --- Draw Event for your Checkbox Object ---

// 1. Draw the checkbox sprite
draw_self();

// 2. Set up font settings
// *** THIS IS THE ONLY CHANGE YOU NEED ***
draw_set_font(fnt_settings_large); // Use your new, bigger font!

// Align to the RIGHT, so the text *ends* to the left of the checkbox
draw_set_halign(fa_right); 
draw_set_valign(fa_middle);

// --- Define our text and position ---
var _text_string = "FULLSCREEN";
var _text_x = x - 30; // 30 pixels to the LEFT
var _text_y = y;

// --- 3. Draw the outline (draw 4 times in black) ---
draw_set_color(c_black);
draw_text(_text_x - 2, _text_y, _text_string); // Left
draw_text(_text_x + 2, _text_y, _text_string); // Right
draw_text(_text_x, _text_y - 2, _text_string); // Top
draw_text(_text_x, _text_y + 2, _text_string); // Bottom

// --- 4. Draw the main text (draw 1 time in white) ---
draw_set_color(c_white);
draw_text(_text_x, _text_y, _text_string);

// --- 5. Good practice: Reset alignment ---
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);