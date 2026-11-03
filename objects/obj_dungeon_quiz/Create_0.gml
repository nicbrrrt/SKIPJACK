/// @description obj_dungeon_quiz — Create Event
/// Standalone Cybersecurity Word-Scramble Quiz UI (independent of JRPG combat).
/// Used to unlock the Caesar Key Vault room (obj_door_quiz_lock).

depth = -15000;

target_door_x = x;
target_door_y = y;

questions = [
    { word: "TROJAN",   hint: "Malware disguised as real software." },
    { word: "PHISHING", hint: "Fraudulent emails stealing sensitive data." },
    { word: "FIREWALL", hint: "Network security traffic monitor." },
    { word: "BOTNET",   hint: "Network of infected computers." },
    { word: "SPYWARE",  hint: "Software that gathers info without consent." },
    { word: "MALWARE",  hint: "Software designed to harm or exploit a system." },
    { word: "CAESAR",   hint: "Cipher that shifts each letter by a fixed number." }
];

var _idx     = irandom(array_length(questions) - 1);
target_word  = questions[_idx].word;
current_hint = questions[_idx].hint;
player_guess = "";

// Build scrambled letter pool
letter_chars = [];
letter_used  = [];
var _len = string_length(target_word);
for (var _i = 1; _i <= _len; _i++) {
    array_push(letter_chars, string_char_at(target_word, _i));
    array_push(letter_used, false);
}

// Fisher-Yates shuffle (ensure it's not identical to target_word)
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

audio_play_sound(ms_start, 10, false);
show_debug_message("[obj_dungeon_quiz] Question started. Answer: " + target_word);
