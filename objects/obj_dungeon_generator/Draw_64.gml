/// @description obj_dungeon_generator — Draw GUI Event
/// Displays the Chapter & Floor Curriculum HUD, Key status, Floor Intent Banner,
/// and contextual [E] interaction prompts.

if (variable_instance_exists(id, "is_intern_mode") && is_intern_mode) exit;
if (!gen_complete) exit;
if (instance_exists(obj_dungeon_victory)
    || instance_exists(obj_dungeon_quiz)
    || instance_exists(obj_cipher)
    || instance_exists(obj_textbox)
    || (variable_global_exists("cam_pan_phase")     && global.cam_pan_phase != "off")
    || (variable_global_exists("key_analyzer_open") && global.key_analyzer_open)) exit;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// =========================================================
// WRENCH SABOTAGE / MAINFRAME SEVER ENCRYPTION UI
// =========================================================
if (variable_global_exists("scrap_ui_open") && global.scrap_ui_open) {
    scr_draw_scrap_sever_ui(_gui_w, _gui_h);
    draw_set_font(fnt_default);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    exit;
}

// =========================================================
// LOCKDOWN OVERRIDE CONSOLE UI (Option A2: Reverse-Shift Encrypt)
// =========================================================
if (variable_global_exists("override_ui_open") && global.override_ui_open) {
    scr_draw_override_console_ui(_gui_w, _gui_h);
    draw_set_font(fnt_default);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    exit;
}

// =========================================================
// POWER BREAKER PANEL UI (Option B1: 3-Fuse Shift Verification)
// =========================================================
if (variable_global_exists("breaker_ui_open") && global.breaker_ui_open) {
    scr_draw_power_breaker_ui(_gui_w, _gui_h);
    draw_set_font(fnt_default);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    exit;
}

// =========================================================
// DEDICATED COMPUTER MONITOR SCREEN OVERLAY (Clean & Minimal)
// =========================================================
if (variable_global_exists("pc_screen_open") && global.pc_screen_open) {
    draw_set_alpha(0.84);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1.0);

    var _mcx = _gui_w * 0.5;
    var _mcy = _gui_h * 0.47;
    var _is_board = (variable_global_exists("pc_screen_mode") && global.pc_screen_mode == 3);
    var _mw  = _is_board ? 500 : 410;
    var _mh  = _is_board ? 262 : 204;
    var _mx1 = _mcx - _mw * 0.5;
    var _my1 = _mcy - _mh * 0.5;
    var _mx2 = _mcx + _mw * 0.5;
    var _my2 = _mcy + _mh * 0.5;

    // Monitor Stand & Base
    draw_set_color(make_color_rgb(38, 44, 56));
    draw_rectangle(_mcx - 24, _my2, _mcx + 24, _my2 + 16, false);
    draw_rectangle(_mcx - 60, _my2 + 14, _mcx + 60, _my2 + 22, false);
    draw_set_color(make_color_rgb(75, 88, 110));
    draw_rectangle(_mcx - 60, _my2 + 14, _mcx + 60, _my2 + 22, true);

    // Outer Monitor Bezel
    draw_set_color(make_color_rgb(46, 54, 68));
    draw_roundrect(_mx1 - 8, _my1 - 8, _mx2 + 8, _my2 + 8, false);
    draw_set_color(make_color_rgb(105, 120, 145));
    draw_roundrect(_mx1 - 8, _my1 - 8, _mx2 + 8, _my2 + 8, true);

    // Power LED
    draw_set_color(c_lime);
    draw_circle(_mx2 - 6, _my2 + 4, 2, false);

    // Inner CRT Screen
    draw_set_color(make_color_rgb(8, 18, 22));
    draw_rectangle(_mx1, _my1, _mx2, _my2, false);
    draw_set_color(c_lime);
    draw_rectangle(_mx1, _my1, _mx2, _my2, true);

    // Top Terminal OS Title Bar
    draw_set_color(make_color_rgb(16, 48, 42));
    draw_rectangle(_mx1 + 1, _my1 + 1, _mx2 - 1, _my1 + 24, false);
    draw_set_color(c_lime);
    draw_line(_mx1, _my1 + 24, _mx2, _my1 + 24);

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(c_lime);
    draw_text(_mx1 + 10, _my1 + 13, global.pc_screen_title);

    // Clue counter pill on top bar right
    draw_set_halign(fa_right);
    draw_set_color(make_color_rgb(255, 210, 55));
    draw_text_transformed(_mx2 - 30, _my1 + 13, global.pc_screen_badge, 0.80, 0.80, 0);

    // Close [X] button in top-right of screen
    var _bx1 = _mx2 - 22, _by1 = _my1 + 3, _bx2 = _mx2 - 4, _by2 = _my1 + 21;
    var _gmx = device_mouse_x_to_gui(0);
    var _gmy = device_mouse_y_to_gui(0);
    var _hover_x = point_in_rectangle(_gmx, _gmy, _bx1, _by1, _bx2, _by2);
    draw_set_color(_hover_x ? c_red : c_lime);
    draw_rectangle(_bx1, _by1, _bx2, _by2, true);
    draw_set_halign(fa_center);
    draw_text((_bx1 + _bx2) * 0.5, (_by1 + _by2) * 0.5, "X");

    // Subtle CRT horizontal scanlines
    draw_set_alpha(0.06);
    draw_set_color(c_aqua);
    for (var _sy = _my1 + 28; _sy < _my2 - 4; _sy += 5) {
        draw_line(_mx1 + 2, _sy, _mx2 - 2, _sy);
    }
    draw_set_alpha(1.0);

    var _case   = variable_global_exists("floor_case") ? global.floor_case : scr_get_floor_incident_case(0);
    var _mode   = variable_global_exists("pc_screen_mode") ? global.pc_screen_mode : 0;
    var _solved = (variable_global_exists("incident_solved") && global.incident_solved);

    // Returning to the culprit's desk after a correct accusation resumes at the attack-vector question
    if (_mode == 1 && !_solved && variable_global_exists("case_culprit_confirmed") && global.case_culprit_confirmed
        && instance_exists(global.pc_screen_target) && global.pc_screen_target.suspect_idx == global.case_culprit_idx) {
        global.pc_screen_mode = 2;
        global.pc_screen_select = 0;
        _mode = 2;
    }

    if (_mode == 3) {
        // =====================================================
        // CASE BOARD: suspects + evidence trail
        // =====================================================
        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        var _bd_y = _my1 + 36;
        draw_set_color(make_color_rgb(255, 210, 55));
        draw_text_transformed(_mx1 + 12, _bd_y, "SUSPECTS  (accuse at their desk)", 0.76, 0.76, 0);
        _bd_y += 16;

        var _bd_n = array_length(global.case_suspects);
        for (var _bs = 0; _bs < _bd_n; _bs++) {
            var _sp = global.case_suspects[_bs];
            var _st_txt = "UNKNOWN";
            var _st_col = make_color_rgb(190, 205, 220);
            if (_sp.status == 1) { _st_txt = "CLEARED";       _st_col = make_color_rgb(120, 140, 150); }
            if (_sp.status == 2) { _st_txt = "PRIME SUSPECT"; _st_col = make_color_rgb(255, 95, 95); }
            if (_solved && _bs == global.case_culprit_idx) { _st_txt = "PATIENT ZERO"; _st_col = c_lime; }
            draw_set_color(_st_col);
            draw_text_transformed(_mx1 + 18, _bd_y, _sp.name + "  -  " + _sp.dept + "  [desk " + _sp.nameplate + "]", 0.70, 0.70, 0);
            draw_set_halign(fa_right);
            draw_text_transformed(_mx2 - 14, _bd_y, _st_txt, 0.70, 0.70, 0);
            draw_set_halign(fa_left);
            if (_sp.status == 1 && !(_solved && _bs == global.case_culprit_idx)) {
                var _tw = string_width(_sp.name + "  -  " + _sp.dept + "  [desk " + _sp.nameplate + "]") * 0.70;
                draw_line(_mx1 + 18, _bd_y, _mx1 + 18 + _tw, _bd_y);
            }
            _bd_y += 15;
        }

        _bd_y += 6;
        draw_set_color(make_color_rgb(115, 220, 255));
        draw_text_transformed(_mx1 + 12, _bd_y, "EVIDENCE  (" + string(global.evidence_found) + "/" + string(global.evidence_needed) + ")", 0.76, 0.76, 0);
        _bd_y += 15;

        var _bd_ne = array_length(global.case_evidence);
        for (var _be = 0; _be < _bd_ne; _be++) {
            var _evi = global.case_evidence[_be];
            if (_evi.found) {
                var _line = string_replace_all(_evi.text, "\n", " - ");
                if (string_length(_line) > 84) _line = string_copy(_line, 1, 82) + "..";
                draw_set_color(make_color_rgb(215, 235, 225));
                draw_text_transformed(_mx1 + 18, _bd_y, string(_be + 1) + ". " + _line, 0.62, 0.62, 0);
            } else {
                draw_set_color(make_color_rgb(95, 110, 125));
                draw_text_transformed(_mx1 + 18, _bd_y, string(_be + 1) + ". ??? (not found yet - search the offices, memos and coworkers)", 0.62, 0.62, 0);
            }
            _bd_y += 13;
        }

        draw_set_halign(fa_center);
        draw_set_color(make_color_rgb(150, 200, 175));
        draw_text_transformed(_mcx, _my2 - 25, "Wrong accusations: " + string(global.case_wrong_accusations) + "     [TAB] / [ESC] Close", 0.72, 0.72, 0);

    } else if (_mode == 1 || _mode == 2) {
        // =====================================================
        // SUSPECT DESK: ACCUSE -> pick the attack vector
        // =====================================================
        var _labels = [];
        var _desc   = "";
        var _tgt    = instance_exists(global.pc_screen_target) ? global.pc_screen_target : noone;
        var _tg_sus = (_tgt != noone && _tgt.suspect_idx >= 0) ? global.case_suspects[_tgt.suspect_idx] : noone;
        var _min_ev = min(2, global.evidence_needed);

        if (_mode == 1) {
            _desc = (_tg_sus != noone ? ("Desk of " + _tg_sus.name + "  (" + _tg_sus.dept + ")") : "Desk")
                + "\nEvidence on file: " + string(global.evidence_found) + "/" + string(global.evidence_needed);
            _labels = _solved ? ["CASE CLOSED - step away"] : [(_tg_sus != noone ? ("ACCUSE " + _tg_sus.name) : "ACCUSE"), "Step away"];
        } else {
            _desc   = "CORRECT SUSPECT! Now prove HOW they got in.\nWhich attack vector was used?";
            _labels = global.case_vectors;
        }
        var _num_items = array_length(_labels);

        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
            global.pc_screen_select = max(0, global.pc_screen_select - 1);
            audio_play_sound(select1, 6, false);
        }
        if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
            global.pc_screen_select = min(_num_items - 1, global.pc_screen_select + 1);
            audio_play_sound(select1, 6, false);
        }
        global.pc_screen_select = clamp(global.pc_screen_select, 0, _num_items - 1);

        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text_ext_transformed(_mcx, _my1 + 42, _desc, 14, (_mw - 30) / 0.78, 0.78, 0.78, 0);

        draw_set_halign(fa_left);
        for (var _ii = 0; _ii < _num_items; _ii++) {
            var _iy = _my1 + 72 + (_ii * 24);
            var _is_sel = (global.pc_screen_select == _ii);

            var _gmx2 = device_mouse_x_to_gui(0);
            var _gmy2 = device_mouse_y_to_gui(0);
            var _hover_item = point_in_rectangle(_gmx2, _gmy2, _mx1 + 10, _iy - 10, _mx2 - 10, _iy + 10);
            if (_hover_item && mouse_check_button_pressed(mb_left)) {
                global.pc_screen_select = _ii;
                _is_sel = true;
            }

            draw_set_color(_is_sel ? make_color_rgb(18, 45, 60) : make_color_rgb(12, 22, 28));
            draw_rectangle(_mx1 + 10, _iy - 10, _mx2 - 10, _iy + 10, false);
            draw_set_color(_is_sel ? c_aqua : make_color_rgb(60, 90, 110));
            draw_rectangle(_mx1 + 10, _iy - 10, _mx2 - 10, _iy + 10, true);
            draw_set_color(_is_sel ? c_white : make_color_rgb(180, 200, 215));
            draw_text_transformed(_mx1 + 16, _iy + 1, (_is_sel ? "> " : "  ") + _labels[_ii], 0.76, 0.76, 0);
        }

        // Decrement PC input cooldown so opening with [E] does not immediately trigger option 0 in the same frame!
        if (variable_global_exists("pc_input_cooldown") && global.pc_input_cooldown > 0) {
            global.pc_input_cooldown--;
        }

        var _can_input    = (!variable_global_exists("pc_input_cooldown") || global.pc_input_cooldown <= 0);
        var _trigger_flag = _can_input && (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space));
        if (_trigger_flag) {
            if (_mode == 1) {
                if (_solved || global.pc_screen_select == 1) {
                    global.pc_screen_open = false;
                    audio_play_sound(snd_button_click, 5, false);
                } else if (global.evidence_found < _min_ev) {
                    audio_play_sound(wrong1, 8, false);
                    global.pc_screen_feedback     = "Not enough evidence to accuse anyone yet! Gather more (" + string(global.evidence_found) + "/" + string(_min_ev) + ").";
                    global.pc_screen_feedback_col = make_color_rgb(255, 215, 60);
                } else if (_tgt != noone && _tgt.suspect_idx == global.case_culprit_idx) {
                    audio_play_sound(snd_correct_ping, 10, false);
                    global.case_culprit_confirmed = true;
                    global.pc_screen_mode         = 2;
                    global.pc_screen_select       = 0;
                    global.pc_screen_feedback     = "The evidence points here. This desk was the hacker's entry point!";
                    global.pc_screen_feedback_col = c_lime;
                    global.pc_screen_badge        = "PATIENT ZERO FOUND";
                } else {
                    audio_play_sound(wrong1, 10, false);
                    global.case_wrong_accusations++;
                    global.scrap_count = max(0, global.scrap_count - 2);
                    if (_tg_sus != noone) _tg_sus.accused_wrong = true;
                    scr_case_recompute();
                    global.pc_screen_feedback     = "WRONG PERSON! " + (_tg_sus != noone ? _tg_sus.name : "They") + " is innocent. -2 SCRAP. Re-check the Case Board [TAB].";
                    global.pc_screen_feedback_col = make_color_rgb(255, 110, 95);
                }
            } else {
                if (global.pc_screen_select == global.case_vector_correct) {
                    global.incident_solved        = true;
                    global.scrap_count           += 3;
                    global.floor_scrap_collected += 3;
                    global.hr_scrap_count        += 1;

                    var _scrap = global.hr_scrap_count;
                    var _is_compliant = (_scrap >= 4 && _scrap <= 6);
                    global.intern_duty_flagged = !_is_compliant;

                    audio_play_sound(snd_objective_complete, 10, false);
                    global.pc_screen_mode         = 1;
                    global.pc_screen_feedback     = "CASE SOLVED! +3 SCRAP. " + _case.kyle_debrief;
                    global.pc_screen_feedback_col = c_lime;
                    global.pc_screen_badge        = "CASE CLOSED [OVERRIDE AUTHORIZED]";
                } else {
                    audio_play_sound(wrong1, 8, false);
                    global.case_wrong_accusations++;
                    var _how_found = false;
                    for (var _hi = 0; _hi < array_length(global.case_evidence); _hi++) {
                        if (global.case_evidence[_hi].type == "how" && global.case_evidence[_hi].found) _how_found = true;
                    }
                    global.pc_screen_feedback     = _how_found
                        ? "NOT QUITE. Re-read the IT FORENSICS evidence on the Case Board [TAB]."
                        : "NOT QUITE. Find the IT FORENSICS evidence first - it shows how they got in!";
                    global.pc_screen_feedback_col = make_color_rgb(255, 110, 95);
                }
            }
        }

        // Feedback / Educational debrief line
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var _fb_txt = (variable_global_exists("pc_screen_feedback") && global.pc_screen_feedback != "")
            ? global.pc_screen_feedback
            : (_mode == 2 ? "Think about the technical trace you found." : "Use the Case Board [TAB] to decide who to accuse.");
        var _fb_col = (variable_global_exists("pc_screen_feedback_col") && global.pc_screen_feedback != "") ? global.pc_screen_feedback_col : make_color_rgb(255, 215, 60);
        draw_set_color(_fb_col);
        draw_text_ext_transformed(_mcx, _my1 + 146, _fb_txt, 12, (_mw - 30) / 0.68, 0.68, 0.68, 0);

        // Action prompt pill
        draw_set_color(make_color_rgb(14, 30, 44));
        draw_rectangle(_mcx - 155, _my2 - 40, _mcx + 155, _my2 - 22, false);
        draw_set_color(c_aqua);
        draw_rectangle(_mcx - 155, _my2 - 40, _mcx + 155, _my2 - 22, true);
        draw_set_color(c_white);
        draw_text_transformed(_mcx, _my2 - 31, "[W/S or ARROWS] Select   [E / ENTER] Confirm", 0.72, 0.72, 0);

    } else {
        // Centered Main Clue Box
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text_ext_transformed(_mcx, _my1 + 92, global.pc_screen_body, 18, (_mw - 48) / 0.82, 0.82, 0.82, 0);

        // Compact Radar Pill at bottom of monitor
        draw_set_color(make_color_rgb(14, 30, 44));
        draw_rectangle(_mcx - 135, _my2 - 52, _mcx + 135, _my2 - 28, false);
        draw_set_color(c_aqua);
        draw_rectangle(_mcx - 135, _my2 - 52, _mcx + 135, _my2 - 28, true);
        draw_text_transformed(_mcx, _my2 - 40, global.pc_screen_radar, 0.85, 0.85, 0);
    }

    // Minimal close prompt
    draw_set_color(make_color_rgb(150, 200, 175));
    draw_text_transformed(_mcx, _my2 - 13, "[ESC] Close", 0.80, 0.80, 0);

    if (keyboard_check_pressed(ord("X"))
        || keyboard_check_pressed(vk_escape)
        || (global.pc_screen_mode == 3 && keyboard_check_pressed(vk_tab))
        || (_hover_x && mouse_check_button_pressed(mb_left)))
    {
        if (keyboard_check_pressed(vk_escape)) {
            global.esc_block_frames = 2;
            keyboard_clear(vk_escape);
        }
        if (global.pc_screen_mode == 3) keyboard_clear(vk_tab);
        global.pc_screen_open = false;
        audio_play_sound(snd_button_click, 5, false);
    }

    draw_set_font(fnt_default);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    exit;
}

// Hide regular HUD while dialogue box is active so the greyed-out dialogue background is clean
if (instance_exists(obj_textbox) || instance_exists(obj_textevent)) exit;

// [TAB] opens the Case Board (suspects + evidence trail) from anywhere on the floor
if (keyboard_check_pressed(vk_tab)
    && variable_global_exists("case_suspects")
    && instance_exists(obj_jack)
    && !instance_exists(obj_dungeon_victory)
    && !instance_exists(obj_dungeon_quiz)
    && !instance_exists(obj_cipher)
    && !(variable_global_exists("is_paused") && global.is_paused)
    && !(variable_global_exists("player_in_locker") && global.player_in_locker)
    && !(variable_global_exists("bot_grapple_active") && global.bot_grapple_active))
{
    keyboard_clear(vk_tab);
    audio_play_sound(snd_button_click, 5, false);
    global.pc_screen_open     = true;
    global.pc_screen_mode     = 3;
    global.pc_screen_is_pz    = false;
    global.pc_screen_target   = noone;
    global.pc_screen_select   = 0;
    global.pc_screen_feedback = "";
    global.pc_screen_title    = "CASE BOARD";
    global.pc_screen_badge    = "TAB TO CLOSE";
    global.pc_screen_body     = "";
    global.pc_screen_radar    = "";
    exit;
}

draw_set_font(fnt_dialogue);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

var _ch_num    = variable_global_exists("dungeon_chapter") ? global.dungeon_chapter : CHAPTER_CAESAR;
var _flr_num   = variable_global_exists("chapter_floor")   ? global.chapter_floor   : 1;
var _curr      = variable_instance_exists(id, "curriculum") ? curriculum : scr_get_floor_curriculum(_ch_num, _flr_num);
var _ch_short  = (_ch_num == CHAPTER_VIGENERE) ? "VIGENERE" : ((_ch_num == CHAPTER_ATBASH) ? "ATBASH" : "CAESAR");

// Phase badge color
var _phase_col = c_aqua;
if (_curr.phase_name == "PRACTICE")   _phase_col = make_color_rgb(255, 210, 55);
if (_curr.phase_name == "MASTERY")    _phase_col = make_color_rgb(255, 145, 50);
if (_curr.phase_name == "FINAL EXAM") _phase_col = make_color_rgb(255, 85, 160);

// Top-left status bar (expanded to show Wrench Scrap & HR 3-Property Limit)
draw_set_alpha(0.82);
draw_set_color(make_color_rgb(10, 14, 22));
draw_rectangle(8, 8, 268, 94, false);
draw_set_alpha(1.0);
draw_set_color(_phase_col);
draw_rectangle(8, 8, 268, 94, true);

// Line 1: Chapter, Floor X/10 & Phase Badge
draw_set_color(c_white);
draw_text_transformed(15, 18, "CH." + string(_ch_num) + " " + _ch_short + "  •  FLR " + string(_flr_num) + "/10", 0.84, 0.84, 0);
draw_set_halign(fa_right);
draw_set_color(_phase_col);
draw_text_transformed(262, 18, "[" + _curr.phase_name + "]", 0.78, 0.78, 0);
draw_set_halign(fa_left);

// Line 2: Chapter Cipher Key status
var _has_key = (variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key);
if (_has_key) {
    draw_set_color(c_lime);
    if (_ch_num == CHAPTER_VIGENERE) {
        var _vk = variable_global_exists("dungeon_vigenere_key") ? global.dungeon_vigenere_key : "CAB";
        draw_text_transformed(15, 34, "VIGENERE KEY:  " + _vk, 0.86, 0.86, 0);
    } else if (_ch_num == CHAPTER_ATBASH) {
        draw_text_transformed(15, 34, "ATBASH KEY:  MIRROR (A<->Z)", 0.86, 0.86, 0);
    } else {
        var _k = global.dungeon_cipher_key;
        var _k_str = (_k > 0) ? ("+" + string(_k)) : string(_k);
        draw_text_transformed(15, 34, "CAESAR KEY:  SHIFT " + _k_str, 0.86, 0.86, 0);
    }
} else {
    draw_set_color(make_color_rgb(255, 200, 50));
    draw_text_transformed(15, 34, _ch_short + " KEY:  LOCKED IN VAULT", 0.84, 0.84, 0);
}

// Line 3: 5-Step Whodunit Pipeline (evidence -> narrow suspects -> accuse -> override -> extract)
var _ev_cur    = variable_global_exists("evidence_found")  ? global.evidence_found  : 0;
var _ev_req    = variable_global_exists("evidence_needed") ? global.evidence_needed : 0;
var _pz_solved = variable_global_exists("incident_solved") && global.incident_solved;
var _ov_done   = (variable_global_exists("lockdown_overridden") && global.lockdown_overridden);
var _gate_ev   = min(2, _ev_req);
var _left_susp = 0;
if (variable_global_exists("case_suspects")) {
    for (var _ls = 0; _ls < array_length(global.case_suspects); _ls++) {
        if (global.case_suspects[_ls].status != 1) _left_susp++;
    }
}

if (!_pz_solved && _ev_cur < _gate_ev) {
    draw_set_color(make_color_rgb(255, 215, 60));
    draw_text_transformed(15, 50, "CASE: 1. FIND EVIDENCE (" + string(_ev_cur) + "/" + string(_ev_req) + ")  [TAB] BOARD", 0.70, 0.70, 0);
} else if (!_pz_solved && _left_susp > 1) {
    draw_set_color(make_color_rgb(255, 160, 90));
    draw_text_transformed(15, 50, "CASE: 2. NARROW SUSPECTS (" + string(_left_susp) + " LEFT)  [TAB] BOARD", 0.70, 0.70, 0);
} else if (!_pz_solved) {
    draw_set_color(make_color_rgb(255, 115, 160));
    draw_text_transformed(15, 50, "CASE: 3. ACCUSE THE CULPRIT AT THEIR DESK", 0.70, 0.70, 0);
} else if (!_ov_done) {
    draw_set_color(make_color_rgb(255, 95, 115));
    draw_text_transformed(15, 50, "CASE: 4. OPERATE LOCKDOWN OVERRIDE TO DISARM BOTS", 0.68, 0.68, 0);
} else {
    draw_set_color(c_lime);
    draw_text_transformed(15, 50, "CASE: 5. PROCEED TO EXTRACTION ELEVATOR", 0.74, 0.74, 0);
}

// Line 4: 4-Stage Facility Recovery Checklist (1.KEY -> 2.OVERRIDE -> 3.POWER -> 4.ELEVATOR)
var _pwr_done = (variable_global_exists("power_restored") && global.power_restored);
var _s1_txt   = _has_key   ? "[x]1.KEY"      : "[ ]1.KEY";
var _s2_txt   = _ov_done   ? "[x]2.OVERRIDE" : "[ ]2.OVERRIDE";
var _s3_txt   = _pwr_done  ? "[x]3.POWER"    : "[ ]3.POWER";
draw_set_color((_has_key && _ov_done && _pwr_done) ? c_lime : make_color_rgb(185, 210, 235));
draw_text_transformed(15, 66, _s1_txt + "  " + _s2_txt + "  " + _s3_txt, 0.72, 0.72, 0);

// Line 5: Wrench Scrap Counter & Drone Jammer Status
var _scrp_cur = variable_global_exists("scrap_count")    ? global.scrap_count    : 0;
var _hr_cur   = variable_global_exists("hr_scrap_count") ? global.hr_scrap_count : 0;
var _jam_t    = variable_global_exists("drone_jammed_timer") ? global.drone_jammed_timer : 0;

draw_set_color(c_aqua);
draw_text_transformed(15, 82, "SCRAP: " + string(_scrp_cur), 0.78, 0.78, 0);

if (_jam_t > 0) {
    var _jam_sec = ceil(_jam_t / 60);
    draw_set_halign(fa_right);
    draw_set_color(c_lime);
    draw_text_transformed(262, 82, "DRONES JAMMED: " + string(_jam_sec) + "s", 0.76, 0.76, 0);
    draw_set_halign(fa_left);
}



// =========================================================
// FLOOR INTENT BANNER (Top-Right / Center-Right on Floor Start)
// =========================================================
if (banner_timer > 0) {
    var _b_alpha = clamp(banner_timer / 35, 0, 1);
    var _bx1 = 278;
    var _bx2 = _gui_w - 10;
    var _by1 = 8;
    var _by2 = 52;
    var _bcx = (_bx1 + _bx2) * 0.5;

    draw_set_alpha(_b_alpha * 0.90);
    draw_set_color(make_color_rgb(12, 18, 32));
    draw_rectangle(_bx1, _by1, _bx2, _by2, false);
    draw_set_alpha(_b_alpha);
    draw_set_color(_phase_col);
    draw_rectangle(_bx1, _by1, _bx2, _by2, true);

    draw_set_halign(fa_center);
    draw_set_color(_phase_col);
    draw_text_transformed(_bcx, _by1 + 13, "FLOOR " + string(_flr_num) + " / 10   " + _curr.phase_badge, 0.86, 0.86, 0);
    draw_set_color(c_white);
    draw_text_transformed(_bcx, _by1 + 31, _curr.objective_title, 0.78, 0.78, 0);
    draw_set_halign(fa_left);
    draw_set_alpha(1.0);
}

// =========================================================
// FLOOR BLUEPRINT RADAR (MINIMAP) — Below Top-Left HUD
// =========================================================
if (variable_instance_exists(id, "room_discovered")) {
    var _map_x     = 8;
    var _map_y     = 100;
    var _cell_sz   = 7;
    var _cell_step = 9;
    var _map_w     = LOGIC_GRID_W * _cell_step + 12;
    var _map_h     = LOGIC_GRID_H * _cell_step + 22;

    draw_set_alpha(0.76);
    draw_set_color(make_color_rgb(8, 13, 22));
    draw_rectangle(_map_x, _map_y, _map_x + _map_w, _map_y + _map_h, false);
    draw_set_alpha(0.90);
    draw_set_color(make_color_rgb(45, 110, 145));
    draw_rectangle(_map_x, _map_y, _map_x + _map_w, _map_y + _map_h, true);

    draw_set_color(make_color_rgb(120, 210, 245));
    draw_text_transformed(_map_x + 6, _map_y + 9, "BLUEPRINT RADAR", 0.78, 0.78, 0);

    var _grid_ox = _map_x + 7;
    var _grid_oy = _map_y + 17;

    // 1. Draw Doorway & Merged-Room Links between discovered rooms
    if (variable_instance_exists(id, "door_links")) {
        var _n_links = array_length(door_links);
        for (var _li = 0; _li < _n_links; _li++) {
            var _lk = door_links[_li];
            var _c1 = _lk[0], _r1 = _lk[1];
            var _c2 = _lk[2], _r2 = _lk[3];
            var _dtype = _lk[4];

            if (room_discovered[_c1][_r1] > 0 || room_discovered[_c2][_r2] > 0) {
                var _lx1 = _grid_ox + _c1 * _cell_step + _cell_sz * 0.5;
                var _ly1 = _grid_oy + _r1 * _cell_step + _cell_sz * 0.5;
                var _lx2 = _grid_ox + _c2 * _cell_step + _cell_sz * 0.5;
                var _ly2 = _grid_oy + _r2 * _cell_step + _cell_sz * 0.5;

                if (_dtype == TILE_LOCK_QUIZ) {
                    draw_set_color(make_color_rgb(255, 205, 45));
                } else if (_dtype == TILE_LOCK_CAESAR) {
                    var _is_brk = (logic_map[_c1][_r1] == ROOM_POWER || logic_map[_c2][_r2] == ROOM_POWER);
                    draw_set_color(_is_brk ? c_aqua : make_color_rgb(255, 75, 135));
                } else {
                    draw_set_color(make_color_rgb(75, 155, 190));
                }
                draw_set_alpha(0.85);
                var _lw = (_dtype == TILE_ROOM_MERGE) ? 4 : 2;
                draw_line_width(_lx1, _ly1, _lx2, _ly2, _lw);
            }
        }
    }

    // 2. Draw Discovered / Visited Room Cells
    for (var _c = 0; _c < LOGIC_GRID_W; _c++) {
        for (var _r = 0; _r < LOGIC_GRID_H; _r++) {
            var _disc = room_discovered[_c][_r];
            if (_disc <= 0) continue;

            var _rtype = logic_map[_c][_r];
            if (_rtype == ROOM_NONE) continue;

            var _rx1 = _grid_ox + _c * _cell_step;
            var _ry1 = _grid_oy + _r * _cell_step;
            var _rx2 = _rx1 + _cell_sz;
            var _ry2 = _ry1 + _cell_sz;

            if (_rtype == ROOM_HALLWAY) {
                _rx1 += 1; _ry1 += 1;
                _rx2 -= 1; _ry2 -= 1;
            }

            var _rcol = make_color_rgb(60, 140, 175);
            if (_rtype == ROOM_START)         _rcol = make_color_rgb(55, 205, 110);
            if (_rtype == ROOM_HALLWAY)       _rcol = make_color_rgb(75, 115, 155);
            if (_rtype == ROOM_NORMAL)        _rcol = make_color_rgb(55, 155, 185);
            if (_rtype == ROOM_CAESAR_KEY)    _rcol = make_color_rgb(255, 195, 40);
            if (_rtype == ROOM_CAESAR_LOCKED) _rcol = make_color_rgb(235, 65, 120);
            if (_rtype == ROOM_POWER)         _rcol = make_color_rgb(65, 215, 255);
            if (_rtype == ROOM_HOLDING)       _rcol = make_color_rgb(255, 130, 35);
            if (_rtype == ROOM_END)           _rcol = make_color_rgb(70, 245, 220);

            // All unvisited Encrypted-Door rooms display with the SAME magenta mystery color on the radar
            // so the player must unlock and enter them to discover which one is the Elevator Room!
            if (_disc < 2 && variable_instance_exists(id, "room_is_encrypted") && room_is_encrypted[_c][_r]) {
                _rcol = make_color_rgb(235, 65, 120);
            }

            if (_disc == 2) {
                draw_set_alpha(0.80);
                draw_set_color(_rcol);
                draw_rectangle(_rx1, _ry1, _rx2, _ry2, false);
                draw_set_alpha(1.0);
                draw_set_color(c_white);
                draw_rectangle(_rx1, _ry1, _rx2, _ry2, true);
            } else {
                draw_set_alpha(0.28);
                draw_set_color(_rcol);
                draw_rectangle(_rx1, _ry1, _rx2, _ry2, false);
                draw_set_alpha(0.85);
                draw_rectangle(_rx1, _ry1, _rx2, _ry2, true);
            }

            if (_c == active_col && _r == active_row) {
                var _px = (_rx1 + _rx2) * 0.5;
                var _py = (_ry1 + _ry2) * 0.5;
                draw_set_alpha(1.0);
                draw_set_color((current_time mod 500 < 300) ? c_white : c_yellow);
                draw_circle(_px, _py, 2, false);
            }
        }
    }

    // 3. Compact Floor Salvage Tasks Card below Blueprint Radar
    var _tk_y1   = _map_y + _map_h + 6;
    var _tk_y2   = _tk_y1 + 48;
    var _tk_w    = 196;
    var _t1_done = (_hr_cur >= 4 && _hr_cur <= 6);
    var _t2_done = ((variable_global_exists("task_bots_scrapped") && global.task_bots_scrapped > 0)
                 || (variable_global_exists("task_servers_scrapped") && global.task_servers_scrapped > 0));

    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(8, 14, 22));
    draw_rectangle(_map_x, _tk_y1, _map_x + _tk_w, _tk_y2, false);
    draw_set_alpha(0.90);
    draw_set_color((_t1_done && _t2_done) ? c_lime : make_color_rgb(65, 130, 165));
    draw_rectangle(_map_x, _tk_y1, _map_x + _tk_w, _tk_y2, true);

    draw_set_color(make_color_rgb(255, 210, 65));
    draw_text_transformed(_map_x + 6, _tk_y1 + 9, "SALVAGE TASKS [RMB=WRENCH]", 0.68, 0.68, 0);

    var _t1_label = (_t1_done ? "[x] " : "[ ] ") + "Corporate Recovery: Compliant (4-6 Pcs)";
    if (!_t1_done && _hr_cur > 6) {
        _t1_label = "[!] Over-Salvaged: " + string(_hr_cur) + " Pcs (Exceeded!)";
    }
    draw_set_color(_t1_done ? c_lime : (_hr_cur > 6 ? make_color_rgb(255, 100, 100) : make_color_rgb(190, 215, 235)));
    draw_text_transformed(_map_x + 6, _tk_y1 + 24, _t1_label, 0.64, 0.64, 0);

    draw_set_color(_t2_done ? c_lime : make_color_rgb(190, 215, 235));
    draw_text_transformed(_map_x + 6, _tk_y1 + 38, (_t2_done ? "[x] " : "[ ] ") + "Tactical Salvage: Scrap Bot or Server", 0.64, 0.64, 0);
}
draw_set_alpha(1.0);

// Contextual bottom prompt when near a locked door or key pedestal
if (instance_exists(obj_jack)) {
    var _prompt = "";
    var _pcol   = c_white;

    with (obj_door_quiz_lock) {
        if (locked && point_distance(obj_jack.x, obj_jack.y - 8, draw_x + 8, draw_y + 8) < 28) {
            _prompt = "[E] Answer Cybersecurity Question (Unlock Key Vault)";
            _pcol   = make_color_rgb(255, 210, 55);
            break;
        }
    }

    if (_prompt == "") {
        with (obj_door_caesar_lock) {
            if (locked && point_distance(obj_jack.x, obj_jack.y - 8, draw_x + 8, draw_y + 8) < 28) {
                var _in_brig = (is_holding_door
                    && other.logic_map[other.active_col][other.active_row] == ROOM_HOLDING);
                if (_in_brig) {
                    _prompt = "[E] Decode Holding Cell Lock (Solve Cell Math Equation)";
                    _pcol   = make_color_rgb(255, 145, 45);
                } else if (is_breaker_door) {
                    _prompt = "[E] Breaker Room Sealed by Lockdown (Hit Override Button First!)";
                    _pcol   = c_aqua;
                } else {
                    _prompt = _has_key
                        ? ("[E] Decode " + _ch_short + " Lock")
                        : ("[E] Locked — Get Floor " + _ch_short + " Key from Gold Vault First!");
                    _pcol = _has_key ? make_color_rgb(255, 95, 150) : make_color_rgb(255, 165, 65);
                }
                break;
            }
        }
    }

    if (_prompt == "") {
        with (obj_caesar_key_pedestal) {
            if (!collected && player_near) {
                _prompt = "[E] Calibrate Floor " + _ch_short + " Key";
                _pcol   = make_color_rgb(255, 215, 50);
                break;
            }
        }
    }

    if (_prompt == "") {
        with (obj_dungeon_prop) {
            if (grapple_active) {
                _prompt = "[ SPAM E! ]  APPREHENDING SECURITY BOT — FILL THE METER TO SEVER UPLINK!";
                _pcol   = (current_time mod 240 < 120) ? c_yellow : c_lime;
                break;
            }
            if (player_near) {
                if (prop_type == TILE_PROP_NPC) {
                    _prompt = "[E] Talk to " + myName;
                    _pcol   = make_color_rgb(100, 235, 155);
                } else if (prop_type == TILE_PROP_PC) {
                    if (is_holding_clue) {
                        _prompt = "[E] Inspect Holding Cell Terminal";
                        _pcol   = c_aqua;
                    } else if (is_fried) {
                        _prompt = "[RMB / R] Fix Fried Circuits (-1 Scrap) & Wrench Scrap";
                        _pcol   = make_color_rgb(255, 130, 65);
                    } else if (has_clue && !is_scrapped) {
                        _prompt = (suspect_idx >= 0)
                            ? ("[E] Inspect Desk: " + nameplate + "   |   [RMB / R] Wrench Scrap (+1 Scrap)")
                            : "[E] Read Evidence   |   [RMB / R] Wrench Scrap (+1 Scrap)";
                        _pcol   = (suspect_idx >= 0) ? make_color_rgb(255, 150, 80) : c_aqua;
                    } else if (has_clue && is_scrapped) {
                        _prompt = (suspect_idx >= 0) ? ("[E] Inspect Desk: " + nameplate + " (Hardware Scrapped)") : "[E] Read Evidence (Hardware Scrapped)";
                        _pcol   = c_aqua;
                    } else if (is_server_rack) {
                        _prompt = "[RMB / R] Wrench Scrap Prototype Server (+3 Scrap, +1 Core!)";
                        _pcol   = make_color_rgb(235, 110, 255);
                    } else {
                        _prompt = "[RMB / R] Wrench Scrap Corporate Terminal (+1 Scrap)";
                        _pcol   = make_color_rgb(100, 235, 175);
                    }
                } else if (prop_type == TILE_PROP_PAPER) {
                    _prompt = "[E] Read Dropped Memo";
                    _pcol   = make_color_rgb(255, 220, 110);
                } else if (prop_type == TILE_PROP_LOCKER) {
                    var _in_lck = (variable_global_exists("player_in_locker") && global.player_in_locker);
                    _prompt = _in_lck ? "[E] Exit Security Locker (HIDDEN)" : "[E] Hide in Security Locker";
                    _pcol   = _in_lck ? c_lime : c_aqua;
                } else if (prop_type == TILE_PROP_OVERRIDE) {
                    _prompt = _ov_done ? "[E] Lockdown Override Active (Alarms & Drones Off)" : "[E] Use Lockdown Override Console (Encrypt 2-Letter Signal)";
                    _pcol   = _ov_done ? c_lime : make_color_rgb(255, 95, 115);
                } else if (prop_type == TILE_PROP_BREAKER) {
                    var _brk_rep = (variable_global_exists("breaker_repaired") && global.breaker_repaired);
                    _prompt = _pwr_done
                        ? "[E] Power Breaker Restored (Lights & Elevator Online)"
                        : (_brk_rep ? "[E] Inspect Floor Power Breaker Panel (3-Fuse Check)" : "[E] Repair Fried Power Breaker (Requires 2 Scrap)");
                    _pcol   = _pwr_done ? c_lime : c_aqua;
                } else if (prop_type == TILE_PROP_DRONE) {
                    if (is_fried) {
                        _prompt = "[E / RMB] Fix Bot Circuits (-1 Scrap) & Wrench Scrap (+3 Scrap!)";
                        _pcol   = make_color_rgb(255, 130, 65);
                    } else if (can_sneak_ambush && !_ov_done) {
                        _prompt = "[E] SNEAK AMBUSH SECURITY BOT! (Spam [E] -> +3 Scrap, +1 Core!)";
                        _pcol   = make_color_rgb(255, 215, 55);
                    } else {
                        _prompt = "[E] Inspect Sleeping Bot   |   [RMB / R] Wrench Scrap Bot (+3 Scrap)";
                        _pcol   = c_lime;
                    }
                }
                break;
            }
        }
    }

    if (_prompt != "") {
        draw_set_halign(fa_center);
        var _pw = string_width(_prompt) + 24;
        var _py = _gui_h - 52;
        draw_set_alpha(0.82);
        draw_set_color(make_color_rgb(10, 14, 22));
        draw_rectangle((_gui_w - _pw) * 0.5, _py - 12, (_gui_w + _pw) * 0.5, _py + 12, false);
        draw_set_alpha(1.0);
        draw_set_color(_pcol);
        draw_rectangle((_gui_w - _pw) * 0.5, _py - 12, (_gui_w + _pw) * 0.5, _py + 12, true);
        draw_text(_gui_w * 0.5, _py, _prompt);
    }
}

// =========================================================
// CORPORATE COMPLIANCE SCRAP METER (RDR2 Honor-Style Gauge)
// Positioned at Bottom-Center of Screen
// =========================================================
var _mc_w = 260;
var _mc_x1 = (_gui_w - _mc_w) * 0.5;
var _mc_x2 = _mc_x1 + _mc_w;
var _mc_y1 = _gui_h - 38;
var _mc_y2 = _gui_h - 4;

draw_set_alpha(0.85);
draw_set_color(make_color_rgb(10, 14, 22));
draw_rectangle(_mc_x1, _mc_y1, _mc_x2, _mc_y2, false);
draw_set_alpha(1.0);
draw_set_color(make_color_rgb(45, 65, 90));
draw_rectangle(_mc_x1, _mc_y1, _mc_x2, _mc_y2, true);

// Header line
draw_set_halign(fa_left);
draw_set_color(make_color_rgb(175, 205, 230));
draw_text_transformed(_mc_x1 + 10, _mc_y1 + 7, "RECOVERY COMPLIANCE", 0.70, 0.70, 0);

draw_set_halign(fa_right);
draw_set_color(c_aqua);
draw_text_transformed(_mc_x2 - 10, _mc_y1 + 7, "HARVEST: " + string(_hr_cur) + " Pcs", 0.70, 0.70, 0);
draw_set_halign(fa_left);

// The Symmetrical Meter Bar (Width = 236px, centered inside the box)
var _bx = floor((_gui_w - 236) * 0.5);
var _by = _mc_y1 + 14;
var _bh = 7;

// Segments: Black (24px) | Red (32px) | Yellow (24px) | GREEN (76px) | Yellow (24px) | Red (32px) | Black (24px)
draw_set_color(make_color_rgb(35, 40, 50));   draw_rectangle(_bx,       _by, _bx + 24,  _by + _bh, false); // Black 0
draw_set_color(make_color_rgb(220, 50, 50));  draw_rectangle(_bx + 24,  _by, _bx + 56,  _by + _bh, false); // Red 1-2
draw_set_color(make_color_rgb(240, 200, 35)); draw_rectangle(_bx + 56,  _by, _bx + 80,  _by + _bh, false); // Yellow 3
draw_set_color(make_color_rgb(45, 215, 85));  draw_rectangle(_bx + 80,  _by, _bx + 156, _by + _bh, false); // GREEN 4-6
draw_set_color(make_color_rgb(240, 200, 35)); draw_rectangle(_bx + 156, _by, _bx + 180, _by + _bh, false); // Yellow 7-8
draw_set_color(make_color_rgb(220, 50, 50));  draw_rectangle(_bx + 180, _by, _bx + 212, _by + _bh, false); // Red 9-11
draw_set_color(make_color_rgb(35, 40, 50));   draw_rectangle(_bx + 212, _by, _bx + 236, _by + _bh, false); // Black 12+

// Outer border of bar
draw_set_color(c_white);
draw_rectangle(_bx, _by, _bx + 236, _by + _bh, true);

// Calculate Needle X based on _hr_cur
var _needle_x = _bx;
if (_hr_cur <= 0) {
    _needle_x = _bx + 12;
} else if (_hr_cur <= 2) {
    _needle_x = _bx + 24 + ((_hr_cur - 1) / 1.0) * 32;
} else if (_hr_cur == 3) {
    _needle_x = _bx + 68;
} else if (_hr_cur <= 6) {
    _needle_x = _bx + 80 + ((_hr_cur - 4) / 2.0) * 76;
} else if (_hr_cur <= 8) {
    _needle_x = _bx + 156 + ((_hr_cur - 7) / 1.0) * 24;
} else if (_hr_cur <= 11) {
    _needle_x = _bx + 180 + ((_hr_cur - 9) / 2.0) * 32;
} else {
    _needle_x = _bx + 224;
}

// Draw needle triangle
draw_set_color(c_white);
draw_triangle(_needle_x - 3, _by - 4, _needle_x + 3, _by - 4, _needle_x, _by, false);
draw_set_color(c_black);
draw_triangle(_needle_x - 3, _by - 4, _needle_x + 3, _by - 4, _needle_x, _by, true);

// Status Badge below bar
var _stat_txt = "";
var _stat_col = c_white;
if (_hr_cur >= 4 && _hr_cur <= 6) {
    _stat_txt = "STATUS: COMPLIANT [NO INTERN DUTY]";
    _stat_col = c_lime;
} else if (_hr_cur == 3) {
    _stat_txt = "STATUS: MINOR DEFICIT [EASY DUTY]";
    _stat_col = make_color_rgb(255, 215, 60);
} else if (_hr_cur >= 1 && _hr_cur <= 2) {
    _stat_txt = "STATUS: SEVERE DEFICIT [MEDIUM DUTY]";
    _stat_col = make_color_rgb(255, 140, 40);
} else if (_hr_cur == 0) {
    _stat_txt = "STATUS: CRITICAL NEGLIGENCE [CHAOS DUTY]";
    _stat_col = make_color_rgb(255, 75, 75);
} else if (_hr_cur >= 7 && _hr_cur <= 8) {
    _stat_txt = "STATUS: MINOR OVERFLOW [EASY DUTY]";
    _stat_col = make_color_rgb(255, 215, 60);
} else if (_hr_cur >= 9 && _hr_cur <= 11) {
    _stat_txt = "STATUS: HAZARDOUS OVERFLOW [MEDIUM DUTY]";
    _stat_col = make_color_rgb(255, 140, 40);
} else {
    _stat_txt = "STATUS: BIOHAZARD OVERLOAD [CHAOS DUTY]";
    _stat_col = make_color_rgb(255, 75, 75);
}

draw_set_halign(fa_center);
draw_set_color(_stat_col);
draw_text_transformed(_gui_w * 0.5, _mc_y1 + 27, _stat_txt, 0.65, 0.65, 0);
draw_set_halign(fa_left);

draw_set_font(fnt_default);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);
