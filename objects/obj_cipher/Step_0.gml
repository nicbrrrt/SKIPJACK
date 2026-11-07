/// @description obj_cipher — Step Event
/// Handles slot navigation, letter shifting/typing, and answer validation
/// across Caesar, Vigenere, and Atbash locks.

if (variable_global_exists("is_paused") && global.is_paused) exit;

// In standalone (non-battle) mode, allow ESC to close the cipher overlay without opening Pause Menu
if (!instance_exists(obj_battle) && keyboard_check_pressed(vk_escape)) {
    global.esc_block_frames = 2;
    keyboard_clear(vk_escape);
    audio_play_sound(snd_button_click, 10, false);
    instance_destroy();
    exit;
}

// Move between slots with LEFT/RIGHT arrows
if (keyboard_check_pressed(vk_right)) {
    current_slot = min(current_slot + 1, letters_len - 1);
    audio_play_sound(select1, 10, false);
}
if (keyboard_check_pressed(vk_left)) {
    current_slot = max(current_slot - 1, 0);
    audio_play_sound(select1, 10, false);
}

// Change letters with UP/DOWN arrows
if (keyboard_check_pressed(vk_up)) {
    var _enc_ch  = string_char_at(encrypted, current_slot + 1);
    var _base_ch = (player_input[current_slot] == "") ? _enc_ch : player_input[current_slot];
    var new_index = (ord(_base_ch) - ord("A") + 1) mod 26;
    player_input[current_slot] = chr(ord("A") + new_index);
    audio_play_sound(choose(select1, select2, select3, select4, select5), 10, false);
}

if (keyboard_check_pressed(vk_down)) {
    var _enc_ch  = string_char_at(encrypted, current_slot + 1);
    var _base_ch = (player_input[current_slot] == "") ? _enc_ch : player_input[current_slot];
    var new_index = (ord(_base_ch) - ord("A") - 1 + 26) mod 26;
    player_input[current_slot] = chr(ord("A") + new_index);
    audio_play_sound(choose(select1, select2, select3, select4, select5), 10, false);
}

// Also allow direct A-Z typing
for (var k = ord("A"); k <= ord("Z"); k++) {
    if (keyboard_check_pressed(k)) {
        player_input[current_slot] = chr(k);
        audio_play_sound(select1, 8, false);
    }
}

// Submit with ENTER
if (keyboard_check_pressed(vk_enter)) {
    var answer = "";
    for (var i = 0; i < letters_len; i++) {
        answer += player_input[i];
    }

    if (answer == plaintext) {
        if (success_timer == 0) {
            text_color = c_lime;
            status_msg = is_final_exam ? "FINAL EXAM LOCK CRACKED!" : "ACCESS GRANTED";
            audio_play_sound(snd_player_packet_win, 10, false);
            success_timer = 60;
        }
    } else {
        shake_timer = 10;
        text_color  = c_red;

        var _correct_slots = 0;
        for (var _ci = 0; _ci < letters_len; _ci++) {
            if (player_input[_ci] == string_char_at(plaintext, _ci + 1)) {
                _correct_slots++;
            }
        }

        if (is_holding_lock) {
            if (_correct_slots > 0) {
                status_msg = string(_correct_slots) + "/" + string(letters_len) + " letters match!";
                text_color = c_orange;
            } else {
                status_msg = "Check the Math Equation in the Cell!";
            }
        } else if (!instance_exists(obj_battle) && !(variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key)) {
            status_msg = "Calibrate the Key in the Gold Vault first!";
        } else if (_correct_slots > 0) {
            status_msg = string(_correct_slots) + "/" + string(letters_len) + " letters match!";
            text_color = c_orange;
        } else if (chapter_mode == CHAPTER_VIGENERE) {
            status_msg = "Shift each slot by its Keyword letter (+0..+5)!";
        } else if (chapter_mode == CHAPTER_ATBASH) {
            status_msg = "Swap each letter with its Mirror opposite (A<->Z)!";
        } else {
            var _k_hint = (key > 0) ? ("+" + string(key)) : string(key);
            status_msg = "Shift each letter by " + _k_hint + "!";
        }

        audio_play_sound(wrong1, 10, false);
        if (instance_exists(obj_battle) && obj_battle.fight_anim == "idle") {
            with (obj_battle) {
                fight_anim  = "enemy_attack";
                fight_timer = 0;
            }
        }
    }
}

// Handle the Success Delay
if (success_timer > 0) {
    success_timer--;
    if (success_timer <= 0) {
        if (instance_exists(obj_battle)) {
            with (obj_battle) {
                fight_pending = (cipher_mode == "packet") ? "cipher_ok_packet" : "cipher_ok_first";
                if (fight_anim == "idle") {
                    fight_anim  = "player_attack";
                    fight_timer = 0;
                }
            }
        } else {
            var _tx = target_door_x;
            var _ty = target_door_y;
            var _unlocked_elevator = false;
            with (obj_door_caesar_lock) {
                if (point_distance(draw_x, draw_y, _tx, _ty) <= 64) {
                    if (is_elevator_door) {
                        _unlocked_elevator = true;
                    }
                    locked = false;
                    x      = -10000;
                    y      = -10000;
                }
            }
            if (!_unlocked_elevator && instance_exists(obj_dungeon_goal)) {
                if (point_distance(_tx, _ty, obj_dungeon_goal.x, obj_dungeon_goal.y) <= 110) {
                    _unlocked_elevator = true;
                }
            }
            if (_unlocked_elevator) {
                global.lockdown_lifted = true;
            }
        }
        instance_destroy();
    }
}

if (shake_timer > 0) shake_timer--;

// DEBUG: Press 'P' to auto-solve
if (keyboard_check_pressed(ord("P"))) {
    for (var i = 0; i < letters_len; i++) {
        player_input[i] = string_char_at(plaintext, i + 1);
    }
}
