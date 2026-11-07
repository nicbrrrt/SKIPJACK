/// @description obj_cipher — Create Event
/// Works in obj_battle (rm_combat) and standalone on dungeon Cipher doors
/// across Chapter 1 (Caesar), Chapter 2 (Vigenere), and Chapter 3 (Atbash),
/// with 3-tier curriculum scaffolding (Tutorial -> Practice -> Mastery / Final Exam).

depth = -15000;

target_door_x    = x;
target_door_y    = y;
is_holding_lock  = false;
is_elevator_lock = false;

// Check if this cipher lock belongs to the Security Holding Room (Brig) or Extraction Elevator
if (!instance_exists(obj_battle)) {
    if (instance_exists(obj_dungeon_generator)
        && obj_dungeon_generator.logic_map[obj_dungeon_generator.active_col][obj_dungeon_generator.active_row] == ROOM_HOLDING)
    {
        is_holding_lock = true;
    }
    var _tx = target_door_x;
    var _ty = target_door_y;
    with (obj_door_caesar_lock) {
        if (point_distance(draw_x, draw_y, _tx, _ty) <= 44) {
            if (is_holding_door)  other.is_holding_lock  = true;
            if (is_elevator_door) other.is_elevator_lock = true;
        }
    }
}

// Determine active Chapter Mode & Curriculum Scaffolding
var _curr = variable_global_exists("floor_curriculum")
    ? global.floor_curriculum
    : scr_get_floor_curriculum(1, 4);

guided_ui        = (!instance_exists(obj_battle) && !is_holding_lock && _curr.guided_ui);
hide_shift_match = (!instance_exists(obj_battle) && !is_holding_lock && _curr.hide_shift_match);
is_final_exam    = (!instance_exists(obj_battle) && !is_holding_lock && _curr.is_final_exam);

if (instance_exists(obj_battle) || is_holding_lock) {
    chapter_mode = CHAPTER_CAESAR;
} else {
    chapter_mode = variable_global_exists("dungeon_chapter") ? global.dungeon_chapter : CHAPTER_CAESAR;
}

// Resolve Key / Keyword
vigenere_key = variable_global_exists("dungeon_vigenere_key") ? global.dungeon_vigenere_key : "CAB";
if (instance_exists(obj_battle) && variable_instance_exists(obj_battle, "cipher_key")) {
    key = obj_battle.cipher_key;
} else if (is_holding_lock && variable_global_exists("holding_cipher_key")) {
    key = global.holding_cipher_key;
} else if (variable_global_exists("dungeon_cipher_key")) {
    key = global.dungeon_cipher_key;
} else {
    key = 3;
}

// Select Word Length (5 letters on Floor 10 Final Exam Elevator Door, 4 letters otherwise)
letters_len = (is_final_exam && is_elevator_lock) ? 5 : 4;

if (instance_exists(obj_battle)) {
    plaintext = scr_random_letters(letters_len);
} else if (letters_len == 5) {
    plaintext = choose("CYBER", "GUARD", "PATCH", "PROXY", "TOKEN", "CLOUD", "LOGIC", "AUDIT");
} else {
    plaintext = choose("DATA", "CODE", "LOCK", "BYTE", "HASH", "PORT", "NODE", "AUTH", "SAFE", "HOST", "PING", "ROOT");
}

// Encode Plaintext according to the active Chapter Cipher
slot_shifts = array_create(letters_len, 0);
if (chapter_mode == CHAPTER_VIGENERE) {
    // Encode with -shift so the player shifts FORWARD (+shift) by each keyword letter (A=0, B=+1, C=+2...)
    encrypted = scr_vigenere_decode(plaintext, vigenere_key);
    var _kw_len = string_length(vigenere_key);
    for (var _s = 0; _s < letters_len; _s++) {
        var _kch = string_char_at(vigenere_key, (_s mod _kw_len) + 1);
        slot_shifts[_s] = ord(_kch) - ord("A");
    }
} else if (chapter_mode == CHAPTER_ATBASH) {
    encrypted = scr_atbash_decode(plaintext);
} else {
    encrypted = scr_caesar_encode(plaintext, -key);
    for (var _s = 0; _s < letters_len; _s++) {
        slot_shifts[_s] = key;
    }
}

player_input = array_create(letters_len, "");
current_slot = 0;
font         = fnt_default;

// VISUAL FEEDBACK VARIABLES
shake_timer   = 0;
text_color    = c_white;
status_msg    = "";
success_timer = 0;

show_debug_message("CHEAT SHEET: Answer=" + string(plaintext) + " Enc=" + string(encrypted));

if (instance_exists(obj_battle)) {
    audio_play_sound(ms_start, 10, false);
} else {
    audio_play_sound(snd_select, 10, false);
}
