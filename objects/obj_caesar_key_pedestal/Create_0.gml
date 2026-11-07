/// @description obj_caesar_key_pedestal — Create Event
/// Placed at the center of ROOM_CAESAR_KEY.
/// Opens the Chapter Key Calibration mini-lesson (Caesar Shift, Vigenere Keyword, or Atbash Mirror)
/// with Guided Hand-Holding on Tutorial Floors 1-3.

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

sample_plain_idx = irandom_range(6, 15);
last_floor_key   = -999;
last_vig_key     = "";
sample_plain     = "H";
sample_enc       = "E";
target_shift     = 3;
global.key_analyzer_open = false;
