// --- Create Event for obj_ui_button ---
// Force GUI layer to match the window size exactly
var _w = window_get_width();
var _h = window_get_height();
display_set_gui_size(_w, _h);

// This ensures the button is at the absolute front of everything
depth = -15000; 

show_debug_message("!!! SYSTEM: Button exists. GUI Size: " + string(_w) + "x" + string(_h));