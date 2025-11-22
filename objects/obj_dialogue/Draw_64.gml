// --- 1. Define Your Assets ---
// Make sure these names match your assets in GameMaker
var _box_sprite = spr_dialogue_box;
var _box_font = fnt_dialogue;
var _text_padding = 20; // The empty space (in pixels) from the box edge
var _bottom_margin = 20; // How far the box sits from the bottom

// --- 2. Get Sprite & GUI Sizes ---
// Get the actual width and height of your dialogue box sprite
var _box_width = sprite_get_width(_box_sprite);
var _box_height = sprite_get_height(_box_sprite);

// Get the size of the screen
var _gui_width = display_get_gui_width();
var _gui_height = display_get_gui_height();

// --- 3. Calculate Box Position (Bottom Center) ---
// Center the box horizontally
var _box_x = (_gui_width / 2) - (_box_width / 2);
// Place the box near the bottom
var _box_y = _gui_height - _box_height - _bottom_margin;

// --- 4. Draw the Box Sprite ---
draw_sprite(_box_sprite, 0, _box_x, _box_y);

// --- 5. Draw the Text (Inside the Box) ---
// Set your font and alignment (always do this in Draw GUI)
draw_set_font(_box_font);
draw_set_valign(fa_top);
draw_set_halign(fa_left);
draw_set_color(c_white); // Default text color

// Calculate the final X and Y where the text will START drawing
var _text_x = _box_x + _text_padding;
var _text_y = _box_y + _text_padding;

// Calculate the maximum width the text can be before wrapping
var _text_max_width = _box_width - (_text_padding * 2);

// Draw the text (using the "string_to_draw" variable from your Step Event)
// This will now wrap inside your smaller box
draw_text_ext(
	_text_x,
	_text_y,
	string_to_draw, // This variable is set in the Step Event
	-1,             // Default line spacing
	_text_max_width // Max width to wrap
);