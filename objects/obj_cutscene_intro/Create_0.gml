// --- CUTSCENE SEQUENCE ---
sequence_step = 0;
timer = 0;

// --- CHOICE SYSTEM VARIABLES ---
// This variable is watched by the Step Event.
// -1 = No choice made yet.
// 0, 1, 2 = Choice made (updated by obj_textevent).
choice_result = -1; 

// Helper variables (Optional, but good to have initialized)
choice_active = false;
choice_options = [];

// --- PRESS HINTS ---
// Stores the ID of any tutorial popups so we can delete them later
press_e_hint_id = noone;

// --- SAFETY: FORCE GUI SIZE (Optional but recommended) ---
// This ensures text draws correctly on screen if you haven't set it elsewhere
// display_set_gui_size(camera_get_view_width(view_camera[0]), camera_get_view_height(view_camera[0]));