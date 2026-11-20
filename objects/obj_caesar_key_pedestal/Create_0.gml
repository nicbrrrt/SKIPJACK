/// @description obj_caesar_key_pedestal — Create Event
/// Placed at the center of ROOM_CAESAR_KEY.
/// Opens the Tiered Chapter Key Calibration mini-lesson across Floors 1-10.

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
demo_modal_open  = false;

// Tier 2 (Floors 4-6) Known-Plaintext Pair & Tier 3 (Floors 7-10) Brute-Force Word
kpt_words       = ["ADMIN", "LOGIN", "VAULT", "TOKEN", "PATCH", "CLOUD", "PROXY", "BADGE"];
kpt_plain_word  = "ADMIN";
kpt_cipher_word = "DGPLQ";

// Tier 3 (Floors 7-10) Atbash Corrupted Mirror Anchor Repair (A<->Z, E<->V, M<->N)
atbash_anchor_top    = ["A", "E", "M"];
atbash_anchor_target = ["Z", "V", "N"];
atbash_anchor_guess  = ["X", "T", "L"];
atbash_anchor_slot   = 0;

global.key_analyzer_open = false;
