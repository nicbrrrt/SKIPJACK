/// @description obj_caesar_key_pedestal — Step Event
/// Handles tiered cryptanalysis calibration across Floors 1-10 for Caesar, Vigenere, and Atbash.

anim_timer++;
if (shake_timer > 0) shake_timer--;

var _ch        = variable_global_exists("dungeon_chapter")      ? global.dungeon_chapter      : CHAPTER_CAESAR;
var _flr       = variable_global_exists("chapter_floor")        ? global.chapter_floor        : 1;
var _floor_key = variable_global_exists("dungeon_cipher_key")   ? global.dungeon_cipher_key   : 3;
var _vig_key   = variable_global_exists("dungeon_vigenere_key") ? global.dungeon_vigenere_key : "CAB";
var _tier      = (_flr <= 3) ? 1 : ((_flr <= 6) ? 2 : 3); // 1 = Guided (1-3), 2 = Known-Plaintext (4-6), 3 = Mastery/Exam (7-10)

// Refresh intercepted sample letter & word pair whenever floor key / keyword changes
if (last_floor_key != _floor_key || last_vig_key != _vig_key) {
    last_floor_key = _floor_key;
    last_vig_key   = _vig_key;

    kpt_plain_word = kpt_words[(_flr - 1) mod array_length(kpt_words)];

    if (_ch == CHAPTER_VIGENERE) {
        var _kw_ch      = string_char_at(_vig_key, 1);
        target_shift    = ord(_kw_ch) - ord("A");
        kpt_cipher_word = scr_vigenere_decode(kpt_plain_word, _vig_key);
        sample_plain    = string_char_at(kpt_plain_word, 1);
        sample_enc      = string_char_at(kpt_cipher_word, 1);
        dial_shift      = 0;
    } else if (_ch == CHAPTER_ATBASH) {
        target_shift        = irandom_range(1, 4);
        kpt_cipher_word     = scr_atbash_decode(kpt_plain_word);
        sample_enc          = chr(ord("A") + target_shift);
        sample_plain        = scr_atbash_decode(sample_enc);
        dial_shift          = 0;
        atbash_anchor_guess = ["X", "T", "L"];
        atbash_anchor_slot  = 0;
    } else {
        target_shift    = _floor_key;
        kpt_cipher_word = scr_caesar_encode(kpt_plain_word, -target_shift);
        sample_plain    = string_char_at(kpt_plain_word, 1);
        sample_enc      = string_char_at(kpt_cipher_word, 1);
        dial_shift      = 0;
    }

    status_msg    = "";
    success_timer = 0;
}

if (variable_global_exists("is_paused") && global.is_paused) exit;

// --- 1. HANDLE ACTIVE KEY CALIBRATION UI ---
if (ui_open) {
    global.key_analyzer_open = true;

    var _guided_ped = (_tier == 1);

    // Handle the "How to Calibrate" Visual Demonstration Card on Tutorial Floors 1-3
    if (variable_instance_exists(id, "demo_modal_open") && demo_modal_open) {
        if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)
            || keyboard_check_pressed(vk_tab) || keyboard_check_pressed(vk_escape) || mouse_check_button_pressed(mb_left))
        {
            if (keyboard_check_pressed(vk_escape)) {
                global.esc_block_frames = 2;
                keyboard_clear(vk_escape);
            }
            if (keyboard_check_pressed(vk_tab)) keyboard_clear(vk_tab);
            demo_modal_open = false;
            audio_play_sound(snd_button_click, 8, false);
        }
        exit;
    }

    if (_guided_ped && keyboard_check_pressed(vk_tab)) {
        keyboard_clear(vk_tab);
        demo_modal_open = true;
        audio_play_sound(snd_select, 8, false);
        exit;
    }

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

    // Tier 3 Atbash Mode (Floors 7-10): Repair 3 Corrupted Mirror Anchors (A<->Z, E<->V, M<->N)
    if (_ch == CHAPTER_ATBASH && _tier == 3) {
        if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
            atbash_anchor_slot = (atbash_anchor_slot + 1) mod 3;
            status_msg = "";
            audio_play_sound(select1, 8, false);
        }
        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) {
            atbash_anchor_slot = (atbash_anchor_slot + 2) mod 3;
            status_msg = "";
            audio_play_sound(select1, 8, false);
        }
        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
            var _cur_c = ord(atbash_anchor_guess[atbash_anchor_slot]) - ord("A");
            atbash_anchor_guess[atbash_anchor_slot] = chr(ord("A") + ((_cur_c + 1) mod 26));
            status_msg = "";
            audio_play_sound(choose(select1, select2, select3), 10, false);
        }
        if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
            var _cur_c2 = ord(atbash_anchor_guess[atbash_anchor_slot]) - ord("A");
            atbash_anchor_guess[atbash_anchor_slot] = chr(ord("A") + ((_cur_c2 + 25) mod 26));
            status_msg = "";
            audio_play_sound(choose(select1, select2, select3), 10, false);
        }
        if (keyboard_check(vk_control) && keyboard_check_pressed(ord("P"))) {
            atbash_anchor_guess = ["Z", "V", "N"];
            dial_shift          = target_shift;
            status_msg          = "";
            audio_play_sound(snd_correct_ping, 8, false);
        }
        if (keyboard_check_pressed(vk_enter)) {
            var _all_anchors_ok = (atbash_anchor_guess[0] == "Z" && atbash_anchor_guess[1] == "V" && atbash_anchor_guess[2] == "N");
            if (_all_anchors_ok) {
                collected                     = true;
                global.has_dungeon_cipher_key = true;
                status_msg                    = "MIRROR ANCHORS REPAIRED & KEY SAVED (A<->Z, E<->V, M<->N)!";
                status_col                    = c_lime;
                success_timer                 = 70;
                audio_play_sound(snd_objective_complete, 10, false);
            } else {
                shake_timer = 10;
                status_col  = c_orange;
                status_msg  = "Anchor mismatch! Check the Mirror Bar: A(1st)<->Z(26th), E(5th)<->V(22nd), M(13th)<->N(14th)!";
                audio_play_sound(wrong1, 10, false);
            }
        }
        exit;
    }

    var _min_dial = (_ch == CHAPTER_CAESAR) ? ((_tier == 3) ? -12 : -6) : 0;
    var _max_dial = (_ch == CHAPTER_CAESAR) ? ((_tier == 3) ?  13 :  6) : ((_ch == CHAPTER_VIGENERE && _tier == 3) ? 25 : 5);

    // Slide the test dial with LEFT/RIGHT or UP/DOWN arrows (wraps on Tier 3 Quick-Cycle Dial)
    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("D")) || keyboard_check_pressed(ord("W"))) {
        if (_tier == 3 && _ch == CHAPTER_CAESAR) {
            dial_shift = (dial_shift >= _max_dial) ? _min_dial : (dial_shift + 1);
        } else {
            dial_shift = clamp(dial_shift + 1, _min_dial, _max_dial);
        }
        status_msg = "";
        audio_play_sound(choose(select1, select2, select3), 10, false);
    }
    if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("A")) || keyboard_check_pressed(ord("S"))) {
        if (_tier == 3 && _ch == CHAPTER_CAESAR) {
            dial_shift = (dial_shift <= _min_dial) ? _max_dial : (dial_shift - 1);
        } else {
            dial_shift = clamp(dial_shift - 1, _min_dial, _max_dial);
        }
        status_msg = "";
        audio_play_sound(choose(select1, select2, select3), 10, false);
    }

    // DEMO SHORTCUT: Press Ctrl + P to snap dial directly to target_shift
    if (keyboard_check(vk_control) && keyboard_check_pressed(ord("P"))) {
        dial_shift = target_shift;
        status_msg = "";
        audio_play_sound(snd_correct_ping, 8, false);
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
                status_msg = "KEY SAVED: SHIFT " + _d_str + "  ('" + kpt_cipher_word + "' -> '" + kpt_plain_word + "')!";
            }
            status_col    = c_lime;
            success_timer = 70;
            audio_play_sound(snd_objective_complete, 10, false);
        } else {
            shake_timer = 10;
            status_col  = c_orange;
            if (_tier == 3 && _ch == CHAPTER_CAESAR) {
                var _try_word = scr_caesar_encode(kpt_cipher_word, dial_shift);
                status_msg = "'" + _try_word + "' is not a valid word — keep cycling [LEFT/RIGHT] until a real English word appears!";
            } else {
                status_msg = "Lands on '" + _landed_ch + "' — align with '" + sample_plain + "'!";
            }
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
            var _g_ped = (_tier == 1);
            var _seen_key = "tut_demo_pedestal_ch" + string(_ch);
            if (_g_ped && (!variable_global_exists(_seen_key) || !variable_global_get(_seen_key))) {
                variable_global_set(_seen_key, true);
                demo_modal_open = true;
            } else {
                demo_modal_open = false;
            }
            audio_play_sound(snd_select, 10, false);
        }
    }
}
