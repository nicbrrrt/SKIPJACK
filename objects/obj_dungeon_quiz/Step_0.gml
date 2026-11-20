/// @description obj_dungeon_quiz — Step Event
/// Handles interactive option selection ([W/S], [UP/DOWN], [1/2/3], Mouse Click, [E/ENTER])
/// for the Key Vault "Spot the Cyber Red Flag" inspection challenge.

if (variable_global_exists("is_paused") && global.is_paused) exit;
if (scr_handle_term_popup_input()) exit;

if (shake_timer > 0) shake_timer--;

// Handle post-solve delay (allow E/Enter/Space/Click to advance early)
if (success_timer > 0) {
    success_timer--;
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("E")) || mouse_check_button_pressed(mb_left)) {
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
    global.esc_block_frames = 2;
    keyboard_clear(vk_escape);
    audio_play_sound(snd_button_click, 10, false);
    instance_destroy();
    exit;
}

// Keyboard navigation (W/S or Up/Down)
if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
    selected_option = (selected_option + 2) mod 3;
    audio_play_sound(snd_button_hover, 6, false);
}
if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
    selected_option = (selected_option + 1) mod 3;
    audio_play_sound(snd_button_hover, 6, false);
}

var _submit = false;

// Direct number shortcuts [1], [2], [3]
if (keyboard_check_pressed(ord("1"))) { selected_option = 0; _submit = true; }
if (keyboard_check_pressed(ord("2"))) { selected_option = 1; _submit = true; }
if (keyboard_check_pressed(ord("3"))) { selected_option = 2; _submit = true; }

// Confirm with E, Enter, or Space
if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
    _submit = true;
}

// Mouse hover & click on the 3 option cards (matching Draw_64 coordinates)
var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
var _cx    = _gui_w * 0.5;
var _cy    = _gui_h * 0.5;
var _pw    = 556;
var _ph    = 312;
var _x1    = _cx - (_pw * 0.5);
var _y1    = _cy - (_ph * 0.5);
var _x2    = _cx + (_pw * 0.5);
var _gmx   = device_mouse_x_to_gui(0);
var _gmy   = device_mouse_y_to_gui(0);

for (var _i = 0; _i < 3; _i++) {
    var _oy1 = _y1 + 148 + (_i * 38);
    var _oy2 = _oy1 + 32;
    if (point_in_rectangle(_gmx, _gmy, _x1 + 18, _oy1, _x2 - 18, _oy2)) {
        if (mouse_check_button_pressed(mb_left)) {
            selected_option = _i;
            _submit = true;
        }
    }
}

if (_submit) {
    var _is_corr = (selected_option == correct_option_idx);
    if (!variable_global_exists("floor_stat_vault_logged") || !global.floor_stat_vault_logged) {
        global.floor_stat_vault_logged = true;
        var _b_key = variable_global_exists("floor_branch_key") ? global.floor_branch_key : "social_eng";
        scr_record_cyber_stat(_b_key, _is_corr);
    }
    if (_is_corr) {
        status_msg    = "RED FLAG IDENTIFIED (" + target_word + ")!  " + explain_win;
        status_col    = c_lime;
        success_timer = 110;
        audio_play_sound(snd_correct_ping, 10, false);
    } else {
        shake_timer = 12;
        option_eliminated[selected_option] = true;
        var _clues_cur = variable_global_exists("clues_found") ? global.clues_found : 0;
        status_msg = (_clues_cur >= 1)
            ? "NOT A THREAT — Check the green Forensic Scanner hint above for the real red flag!"
            : "NOT A THREAT — Look closely at the suspicious log above (or inspect the Security Sector PC for a scan)!";
        status_col = make_color_rgb(255, 110, 95);
        audio_play_sound(wrong1, 10, false);
    }
}
