if (variable_global_exists("is_paused") && global.is_paused) exit;

// In standalone (non-battle) mode, allow ESC to close the cipher overlay
if (!instance_exists(obj_battle) && keyboard_check_pressed(vk_escape)) {
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

// Change letters with UP/DOWN arrows (starts from the slot's encrypted letter so each tap shifts ±1!)
if (keyboard_check_pressed(vk_up)) {
    var _enc_ch = string_char_at(encrypted, current_slot + 1);
    var _base_ch = (player_input[current_slot] == "") ? _enc_ch : player_input[current_slot];
    var new_index = (ord(_base_ch) - ord("A") + 1) mod 26;
    player_input[current_slot] = chr(ord("A") + new_index);
    audio_play_sound(choose(select1, select2, select3, select4, select5), 10, false);
    show_debug_message("CIPHER: Slot " + string(current_slot) + " changed to: " + player_input[current_slot]);
}

if (keyboard_check_pressed(vk_down)) {
    var _enc_ch = string_char_at(encrypted, current_slot + 1);
    var _base_ch = (player_input[current_slot] == "") ? _enc_ch : player_input[current_slot];
    var new_index = (ord(_base_ch) - ord("A") - 1 + 26) mod 26;
    player_input[current_slot] = chr(ord("A") + new_index);
    audio_play_sound(choose(select1, select2, select3, select4, select5), 10, false);
    show_debug_message("CIPHER: Slot " + string(current_slot) + " changed to: " + player_input[current_slot]);
}

// Also allow direct A-Z typing
for (var k = ord("A"); k <= ord("Z"); k++) {
    if (keyboard_check_pressed(k)) {
        player_input[current_slot] = chr(k);
    }
}

// Submit with ENTER
if (keyboard_check_pressed(vk_enter)) {
    var answer = "";
    for (var i = 0; i < letters_len; i++) {
        answer += player_input[i];
    }
    
    if (answer == plaintext) {
        // --- SUCCESS SEQUENCE ---
        if (success_timer == 0) { // Only trigger once
            text_color = c_lime;
            status_msg = "ACCESS GRANTED";
            audio_play_sound(snd_player_packet_win, 10, false);
            success_timer = 60; // Wait 1 second (60 frames) before closing
        }
    } else {
        // --- SMART COACHING FAILURE SEQUENCE ---
        shake_timer = 10;
        text_color  = c_red;

        var _wrong_dir_word = scr_caesar_encode(encrypted, -key);
        var _correct_slots  = 0;
        for (var _ci = 0; _ci < letters_len; _ci++) {
            if (player_input[_ci] == string_char_at(plaintext, _ci + 1)) {
                _correct_slots++;
            }
        }

        if (is_holding_lock) {
            if (_correct_slots > 0) {
                status_msg = "ALMOST! " + string(_correct_slots) + "/4 letters match! Check the Math Equation in the Holding Cell!";
                text_color = c_orange;
            } else {
                status_msg = "INCORRECT: Solve the Math Equation on the Cell Terminal/Note to find the Shift Key!";
            }
        } else if (!instance_exists(obj_battle) && !(variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key)) {
            status_msg = "NO KEY: Unlock the Gold Key Vault first to find the Shift Key!";
        } else if (answer == _wrong_dir_word) {
            var _k_dir = (key > 0) ? ("+" + string(key) + " (UP/RIGHT)") : (string(key) + " (DOWN/LEFT)");
            status_msg = "WRONG DIRECTION! You shifted opposite — shift by " + _k_dir + "!";
            text_color = c_orange;
        } else if (_correct_slots > 0) {
            status_msg = "ALMOST! " + string(_correct_slots) + "/" + string(letters_len) + " letters match! Check each slot's shift offset.";
            text_color = c_orange;
        } else {
            var _k_hint = (key > 0) ? ("+" + string(key)) : string(key);
            status_msg = "INCORRECT: Shift each Encrypted letter by " + _k_hint + " on the A-Z strip!";
        }

        audio_play_sound(wrong1, 10, false);
        if (instance_exists(obj_battle) && obj_battle.fight_anim == "idle") {
            with (obj_battle) {
                fight_anim = "enemy_attack";
                fight_timer = 0;
            }
        }
    }
}

// Handle the Success Delay
if (success_timer > 0) {
    success_timer--;
    if (success_timer <= 0) {
        show_debug_message("CIPHER SUCCESS!");
        if (instance_exists(obj_battle)) {
            with (obj_battle) {
                fight_pending = (cipher_mode == "packet") ? "cipher_ok_packet" : "cipher_ok_first";
                if (fight_anim == "idle") {
                    fight_anim = "player_attack";
                    fight_timer = 0;
                }
            }
        } else {
            // Standalone dungeon mode: unlock the Caesar-locked doorway that triggered this puzzle
            var _tx = target_door_x;
            var _ty = target_door_y;
            var _unlocked_elevator = false;
            with (obj_door_caesar_lock) {
                if (point_distance(draw_x, draw_y, _tx, _ty) <= 64) {
                    if (is_elevator_door) {
                        _unlocked_elevator = true;
                    }
                    locked = false;
                    x = -10000;
                    y = -10000;
                }
            }
            // Also check distance to extraction elevator goal as a fallback
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

// Reduce shake over time
if (shake_timer > 0) shake_timer--;

// DEBUG: Press 'P' to auto-solve (Only for testing!)
if (keyboard_check_pressed(ord("P"))) {
    for (var i = 0; i < letters_len; i++) {
        player_input[i] = string_char_at(plaintext, i + 1);
    }
    show_debug_message("DEBUG: Cipher auto-filled.");
}
