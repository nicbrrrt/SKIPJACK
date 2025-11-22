// --- Create Event for obj_button_master ---

// Stop the sprite from animating
image_speed = 0;
image_index = 0; // Start on Frame 0 (idle)

// Default text to draw on the button
button_text = ""; 

// The room this button will go to.
// -1 means "no room" (useful for the Quit button)
target_room = -1; 

// Set the font for the button text
draw_set_font(fnt_button); // Make sure you've created 'fnt_button'!
draw_set_halign(fa_center);
draw_set_valign(fa_middle);