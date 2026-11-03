/// @description obj_dungeon_quiz — Create Event
/// Standalone Cybersecurity Incident Case Quiz UI (independent of JRPG combat).
/// Tests the player on the current floor's Cyber Incident Case (global.floor_case)
/// using clues gathered from coworkers, terminals, and memos across the offices.

depth = -15000;

target_door_x = x;
target_door_y = y;

var _case = variable_global_exists("floor_case")
    ? global.floor_case
    : scr_get_floor_incident_case(0);

target_word      = _case.word;
case_title       = _case.title;
current_scenario = _case.scenario;
current_hint     = _case.hint;
current_takeaway = _case.takeaway;
player_guess     = "";

// Build scrambled letter pool
letter_chars = [];
letter_used  = [];
var _len = string_length(target_word);
for (var _i = 1; _i <= _len; _i++) {
    array_push(letter_chars, string_char_at(target_word, _i));
    array_push(letter_used, false);
}

// Fisher-Yates shuffle
for (var _i = _len - 1; _i > 0; _i--) {
    var _j   = irandom(_i);
    var _tmp = letter_chars[_i];
    letter_chars[_i] = letter_chars[_j];
    letter_chars[_j] = _tmp;
}

// Track which scrambled index each character in player_guess came from
guess_indices = [];

shake_timer   = 0;
status_msg    = "";
status_col    = c_white;
success_timer = 0;

audio_play_sound(snd_select, 10, false);
show_debug_message("[obj_dungeon_quiz] Incident Case Quiz started. Answer: " + target_word);
