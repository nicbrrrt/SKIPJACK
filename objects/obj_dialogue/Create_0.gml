// --- Text to display ---
// This array will hold all the pages of text
text_to_show = [
	"This is the first page of dialogue. Hit 'E' to continue.",
	"This is the second page. You can add as many as you want!",
	"And this is the final page."
];

// --- Control Variables ---
page_number = 0;         // Which page we are currently reading
text_progress = 0;       // How much of the current page we've "typed out"
text_speed = 0.5;        // How many characters to "type" per frame
string_to_draw = "";          // The final, "typed out" string to draw

// --- Dialogue Box Properties ---
// Get the size of the sprite you're using
box_width = sprite_get_width(spr_dialogue_box);
box_height = sprite_get_height(spr_dialogue_box);

// Set up padding so the text doesn't touch the edges
padding = 10;

// Set the font
draw_set_font(fnt_dialogue);
draw_set_valign(fa_top);
draw_set_halign(fa_left);