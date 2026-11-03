/// @description obj_dungeon_quiz — Step Event
/// Handles letter typing, backspace, answer verification, and unlocking obj_door_quiz_lock.

if (variable_global_exists("is_paused") && global.is_paused) exit;

if (shake_timer > 0) shake_timer--;

// Handle post-solve delay (allow Enter/Space to advance early)
if (success_timer > 0) {
    success_timer--;
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
        success_timer = 0;
    }
    if (success_timer <= 0) {
        var _tx = target_door_x;
        var _ty = target_door_y;
        with (obj_door_quiz_lock) {
            if (point_distance(draw_x, draw_y, _tx, _ty) <= 64) {
                locked = false;
                x = -10000;
                y = -10000;
            }
        }
        instance_destroy();
    }
    exit;
}

// Allow Escape to cancel and step away from the door
if (keyboard_check_pressed(vk_escape)) {
    audio_play_sound(snd_button_click, 10, false);
    instance_destroy();
    exit;
}

var _len = array_length(letter_chars);

// Backspace: remove last typed letter
if (keyboard_check_pressed(vk_backspace)) {
    var _glen = string_length(player_guess);
    if (_glen > 0) {
        var _pop_idx = guess_indices[_glen - 1];
        letter_used[_pop_idx] = false;
        array_delete(guess_indices, _glen - 1, 1);
        player_guess = string_delete(player_guess, _glen, 1);
        status_msg = "";
        audio_play_sound(snd_button_click, 10, false);
    }
}

// Typing A-Z: pick from available scrambled letters
for (var _k = ord("A"); _k <= ord("Z"); _k++) {
    if (keyboard_check_pressed(_k)) {
        var _typed = chr(_k);
        var _found = -1;
        for (var _i = 0; _i < _len; _i++) {
            if (!letter_used[_i] && letter_chars[_i] == _typed) {
                _found = _i;
                break;
            }
        }
        if (_found != -1) {
            letter_used[_found] = true;
            array_push(guess_indices, _found);
            player_guess += _typed;
            status_msg = "";
            audio_play_sound(snd_button_click, 10, false);
        } else {
            shake_timer = 6;
            audio_play_sound(wrong1, 10, false);
        }
    }
}

// Auto-verify once all letters are entered
if (string_length(player_guess) == _len) {
    if (player_guess == target_word) {
        status_msg    = "CORRECT! KEY VAULT UNLOCKED";
        status_col    = c_lime;
        success_timer = 100;
        audio_play_sound(snd_correct_ping, 10, false);
    } else {
        shake_timer  = 12;
        status_msg   = "INCORRECT — TRY AGAIN";
        status_col   = c_red;
        player_guess = "";
        guess_indices = [];
        for (var _i = 0; _i < _len; _i++) {
            letter_used[_i] = false;
        }
        audio_play_sound(wrong1, 10, false);
    }
}
