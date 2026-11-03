/// @description obj_caesar_key_pedestal — Create Event
/// Placed at the center of ROOM_CAESAR_KEY.
/// Opens the "Crack the Key" (Known-Plaintext Cryptanalysis) mini-lesson
/// so the player actively deduces the floor's Caesar Shift Key!

depth = 20; // Below room fog (10) and Jack (-y), above floor (50)

anim_timer    = 0;
collected     = false;
ui_open       = false;
player_near   = false;
dial_shift    = 0;
shake_timer   = 0;
status_msg    = "";
status_col    = c_white;
success_timer = 0;

// Pick a clean middle-of-the-alphabet letter (G..T) so shifting ±5 never wraps awkwardly during the intro lesson
sample_plain_idx = irandom_range(6, 19);
last_floor_key   = 0;
sample_plain     = "H";
sample_enc       = "E";
global.key_analyzer_open = false;
