/// @description obj_caesar_key_pedestal — Step Event
/// Handles opening and interacting with the Chapter Key Calibration mini-lesson
/// for Chapter 1 (Caesar), Chapter 2 (Vigenere Keyword), and Chapter 3 (Atbash Mirror).

anim_timer++;
if (shake_timer > 0) shake_timer--;

var _ch        = variable_global_exists("dungeon_chapter")      ? global.dungeon_chapter      : CHAPTER_CAESAR;
var _floor_key = variable_global_exists("dungeon_cipher_key")   ? global.dungeon_cipher_key   : 3;
var _vig_key   = variable_global_exists("dungeon_vigenere_key") ? global.dungeon_vigenere_key : "CAB";

// Refresh the intercepted sample letter pair whenever the floor key / keyword changes
if (last_floor_key != _floor_key || last_vig_key != _vig_key) {
    last_floor_key = _floor_key;
    last_vig_key   = _vig_key;

    if (_ch == CHAPTER_VIGENERE) {
        // Calibrate using the 1st letter of the Vigenere Keyword (A=0 .. F=5)
        var _kw_ch       = string_char_at(_vig_key, 1);
        target_shift     = ord(_kw_ch) - ord("A");
        sample_plain_idx = irandom_range(6, 15);
        sample_plain     = chr(ord("A") + sample_plain_idx);
        sample_enc       = scr_caesar_encode(sample_plain, -target_shift);
        dial_shift       = 0;
    } else if (_ch == CHAPTER_ATBASH) {
        // Calibrate by reflecting a top-row letter (B..E, index 1..4) to its mirror opposite (Y..V)
        target_shift     = irandom_range(1, 4); // Steps inward from A / Z
        sample_enc       = chr(ord("A") + target_shift);
        sample_plain     = scr_atbash_decode(sample_enc);
        dial_shift       = 0;
    } else {
        target_shift     = _floor_key;
        sample_plain_idx = irandom_range(6, 18);
        sample_plain     = chr(ord("A") + sample_plain_idx);
        sample_enc       = scr_caesar_encode(sample_plain, -target_shift);
        dial_shift       = 0;
    }

    status_msg    = "";
    success_timer = 0;
}

if (variable_global_exists("is_paused") && global.is_paused) exit;

// --- 1. HANDLE ACTIVE KEY CALIBRATION UI ---
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

    // Allow ESC to close without opening Pause Menu
    if (keyboard_check_pressed(vk_escape)) {
        global.esc_block_frames  = 2;
        keyboard_clear(vk_escape);
        ui_open                  = false;
        global.key_analyzer_open = false;
        audio_play_sound(snd_button_click, 10, false);
        exit;
    }

    var _min_dial = (_ch == CHAPTER_CAESAR) ? -6 : 0;
    var _max_dial = (_ch == CHAPTER_CAESAR) ?  6 : 5;

    // Slide the test dial with LEFT/RIGHT or UP/DOWN arrows
    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("D")) || keyboard_check_pressed(ord("W"))) {
        dial_shift = clamp(dial_shift + 1, _min_dial, _max_dial);
        status_msg = "";
        audio_play_sound(choose(select1, select2, select3), 10, false);
    }
    if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(ord("S"))) {
        dial_shift = clamp(dial_shift - 1, _min_dial, _max_dial);
        status_msg = "";
        audio_play_sound(choose(select1, select2, select3), 10, false);
    }

    // Lock in the deduced Key with ENTER
    if (keyboard_check_pressed(vk_enter)) {
        var _landed_ch = (_ch == CHAPTER_ATBASH)
            ? chr(ord("Z") - dial_shift)
            : scr_caesar_encode(sample_enc, dial_shift);

        if (dial_shift == target_shift) {
            collected                     = true;
            global.has_dungeon_cipher_key = true;
            if (_ch == CHAPTER_VIGENERE) {
                status_msg = "KEYWORD SAVED: '" + _vig_key + "'!";
            } else if (_ch == CHAPTER_ATBASH) {
                status_msg = "MIRROR KEY SAVED (A <-> Z)!";
            } else {
                var _d_str = (dial_shift > 0) ? ("+" + string(dial_shift)) : string(dial_shift);
                status_msg = "KEY SAVED: SHIFT " + _d_str + "!";
            }
            status_col    = c_lime;
            success_timer = 70;
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
