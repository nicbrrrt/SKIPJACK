// --- Draw GUI Event for your Checkbox Object ---

// --- 1. Define all our settings ---
var _text_string = "FULLSCREEN";
var _text_font = fnt_settings_large; // Use your big font
var _text_x_pos = x - 30; // The text ends 30px left of the box
var _text_y_pos = y;
var _padding = 5; // How much extra space for the background

// --- 2. Get the size of the text and sprite ---
draw_set_font(_text_font);
draw_set_halign(fa_right); // Set this now for width calculation
var _text_width = string_width(_text_string);
var _text_height = string_height(_text_string);

var _box_width = sprite_get_width(sprite_index);
var _box_height = sprite_get_height(sprite_index);

// Find the tallest part
var _total_height = max(_text_height, _box_height);

// --- 3. Define the background rectangle's area ---
// Top-left corner
var _bg_x1 = _text_x_pos - _text_width - _padding;
var _bg_y1 = y - (_total_height / 2) - _padding;

// Bottom-right corner
var _bg_x2 = x + (_box_width / 2) + _padding;
var _bg_y2 = y + (_total_height / 2) + _padding;

// --- 4. Draw the background ---
draw_set_alpha(0.6); // 60% opaque
draw_set_color(c_black);
draw_rectangle(_bg_x1, _bg_y1, _bg_x2, _bg_y2, false);
draw_set_alpha(1.0); // Reset alpha

// --- 5. Draw the Checkbox and Text (Your old code) ---

// Draw the checkbox
draw_self();

// Set up the font (already set, but good practice)
draw_set_font(_text_font);
draw_set_halign(fa_right);
draw_set_valign(fa_middle);

// Draw the outline
draw_set_color(c_black);
draw_text(_text_x_pos - 2, _text_y_pos, _text_string);
draw_text(_text_x_pos + 2, _text_y_pos, _text_string);
draw_text(_text_x_pos, _text_y_pos - 2, _text_string);
draw_text(_text_x_pos, _text_y_pos + 2, _text_string);

// Draw the main text
draw_set_color(c_white);
draw_text(_text_x_pos, _text_y_pos, _text_string);

// --- 6. Reset draw settings ---
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);