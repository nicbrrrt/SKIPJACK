// In o_transition's DRAW GUI Event

// Only draw the overlay if it's not fully invisible
if (fade_alpha > 0)
{
    // 1. Get the size of the screen
    var _w = display_get_gui_width();
    var _h = display_get_gui_height();
    
    // 2. Set the color and transparency (alpha)
    draw_set_color(c_black);
    draw_set_alpha(fade_alpha);
    
    // 3. Draw the black rectangle across the whole screen
    draw_rectangle(0, 0, _w, _h, false);
    
    // 4. IMPORTANT: Reset the alpha back to 1!
    draw_set_alpha(1); 
}