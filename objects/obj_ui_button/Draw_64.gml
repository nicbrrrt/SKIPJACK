// --- Draw GUI Event of obj_ui_button ---

// 1. Only show if Breado has given the Codex
if (!global.tutorial_complete) exit;

draw_set_alpha(1);

// 2. POSITION & SETTINGS
var gui_w = display_get_gui_width();
var button_x = gui_w - 60; 
var button_y = 60;
var radius = 35; // Size of the background circle

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _hover = (point_distance(_mx, _my, button_x, button_y) < radius);

// --- DRAWING ---

// 3. BACKGROUND CIRCLE
// Dark circle normally, brighter if hovering
draw_set_color(_hover ? c_dkgray : c_black); 
draw_set_alpha(0.8); // Slightly see-through
draw_circle(button_x, button_y, radius, false);

// 4. BORDER CIRCLE (Neon Green outline)
draw_set_alpha(1);
draw_set_color(c_lime);
draw_circle(button_x, button_y, radius, true); // 'true' means outline only

// 5. DRAW THE TEXT
draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Text glows white on hover, green normally
draw_set_color(_hover ? c_white : c_lime);
draw_text_transformed(button_x, button_y, "[ C ]", 1.5, 1.5, 0);

// Reset alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);