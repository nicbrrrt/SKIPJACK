/// @description obj_caesar_key_pedestal — Step Event
/// Handles opening and interacting with the "Crack the Key" Cryptanalysis mini-lesson.

anim_timer++;
if (shake_timer > 0) shake_timer--;

var _floor_key = variable_global_exists("dungeon_cipher_key") ? global.dungeon_cipher_key : 3;

// Refresh the intercepted sample letter pair whenever the floor key changes (e.g. after drone capture reset)
if (last_floor_key != _floor_key) {
    last_floor_key   = _floor_key;
    sample_plain_idx = irandom_range(6, 19);
    sample_plain     = chr(ord("A") + sample_plain_idx);
    sample_enc       = scr_caesar_encode(sample_plain, -_floor_key);
    dial_shift       = 0;
    status_msg       = "";
    success_timer    = 0;
}

if (variable_global_exists("is_paused") && global.is_paused) exit;

// --- 1. HANDLE ACTIVE CRYPTANALYSIS MINI-LESSON UI ---
if (ui_open) {
    global.key_analyzer_open = true;

    if (success_timer > 0) {
        success_timer--;
        if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
            success_timer = 0;
        }
        if (success_timer <= 0) {
            ui_open                  = false;
            global.key_analyzer_open = false;
        }
        exit;
    }

    // Allow ESC to close
    if (keyboard_check_pressed(vk_escape)) {
        global.esc_block_frames  = 2;
        keyboard_clear(vk_escape);
        ui_open                  = false;
        global.key_analyzer_open = false;
        audio_play_sound(snd_button_click, 10, false);
        exit;
    }

    // Slide the test shift dial (-6 .. +6) with LEFT/RIGHT or UP/DOWN arrows
    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("D")) || keyboard_check_pressed(ord("W"))) {
        dial_shift = clamp(dial_shift + 1, -6, 6);
        status_msg = "";
        audio_play_sound(choose(select1, select2, select3), 10, false);
    }
    if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(ord("S"))) {
        dial_shift = clamp(dial_shift - 1, -6, 6);
        status_msg = "";
        audio_play_sound(choose(select1, select2, select3), 10, false);
    }

    // Lock in the deduced Shift Key with ENTER
    if (keyboard_check_pressed(vk_enter)) {
        var _landed_ch = scr_caesar_encode(sample_enc, dial_shift);
        var _d_str     = (dial_shift > 0) ? ("+" + string(dial_shift)) : string(dial_shift);

        if (dial_shift == _floor_key) {
            collected                     = true;
            global.has_dungeon_cipher_key = true;
            status_msg                    = "KEY SAVED: SHIFT " + _d_str + "!";
            status_col                    = c_lime;
            success_timer                 = 70;
            audio_play_sound(snd_objective_complete, 10, false);
        } else {
            shake_timer = 10;
            status_col  = c_orange;
            status_msg  = "Lands on '" + _landed_ch + "' — align with '" + sample_plain + "'!";
            audio_play_sound(wrong1, 10, false);
        }
    }
    exit;
}

// --- 2. CHECK PROXIMITY IN WORLD SPACE TO OPEN MINI-LESSON ---
player_near = false;
if (!collected && instance_exists(obj_jack)) {
    var _dist = point_distance(obj_jack.x, obj_jack.y - 8, x, y);
    if (_dist < 26) {
        player_near = true;
        if (keyboard_check_pressed(ord("E"))) {
            ui_open                  = true;
            global.key_analyzer_open = true;
            dial_shift               = 0;
            status_msg               = "";
            audio_play_sound(snd_select, 10, false);
        }
    }
}
