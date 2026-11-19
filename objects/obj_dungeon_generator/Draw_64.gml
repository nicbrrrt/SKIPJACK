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

    // =========================================================
    // EXPERIMENTAL TOGGLES (Reversible)
    // =========================================================
    var _use_terminal_overlay = true; // Toggle for custom UI sprite overlays (spr_dungeon_terminal_ui / spr_dungeon_caseboard_ui)
    var _terminal_white_theme = true; // Toggle for Terminal Popups (Mode 0): solid white background, black text & 3x thick black boxes

    var _is_board = (variable_global_exists("pc_screen_mode") && global.pc_screen_mode >= 1 && global.pc_screen_mode <= 3);
    var _is_white = (_terminal_white_theme && !_is_board);

    var _col_grey_line = make_color_rgb(187, 187, 187); // #bbbbbb
    var _col_gold_top  = make_color_rgb(253, 207, 73);  // #fdcf49

    // Use spr_dungeon_caseboard_ui for case board, spr_dungeon_terminal_ui for terminal popups
    var _overlay_sprite = spr_dungeon_terminal_ui;
    if (_is_board && sprite_exists(spr_dungeon_caseboard_ui)) {
        _overlay_sprite = spr_dungeon_caseboard_ui;
    }
    var _has_overlay_sprite = (_use_terminal_overlay && sprite_exists(_overlay_sprite));

    var _mcx = _gui_w * 0.5;
    var _mcy = _has_overlay_sprite ? (_gui_h * 0.5) : (_gui_h * 0.47);
    var _mw  = _has_overlay_sprite ? 598 : (_is_board ? min(540, _gui_w - 36) : 410);
    var _mh  = _has_overlay_sprite ? 303 : (_is_board ? min(304, _gui_h - 40) : 204);
    var _mx1 = _mcx - _mw * 0.5;
    var _my1 = _mcy - _mh * 0.5;
    var _mx2 = _mcx + _mw * 0.5;
    var _my2 = _mcy + _mh * 0.5;

    // Monitor Stand & Outer Bezel (drawn only when not using custom sprite overlay)
    if (!_has_overlay_sprite) {
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
    }

    // Inner Screen Background (Solid white for Case Board and White Theme Popups)
    var _bg_col = (_is_board || _is_white) ? c_white : make_color_rgb(8, 18, 22);
    draw_set_color(_bg_col);
    if (_has_overlay_sprite) {
        // Extend slightly behind the sprite bezel to eliminate any seam gaps
        draw_rectangle(_mx1 - 10, _my1 - 10, _mx2 + 10, _my2 + 10, false);
    } else {
        draw_rectangle(_mx1, _my1, _mx2, _my2, false);
    }
    if (!_has_overlay_sprite) {
        draw_set_color((_is_board || _is_white) ? _col_grey_line : c_lime);
        if (_is_white) {
            for (var _th = 0; _th < 3; _th++) {
                draw_rectangle(_mx1 + _th, _my1 + _th, _mx2 - _th, _my2 - _th, true);
            }
        } else {
            draw_rectangle(_mx1, _my1, _mx2, _my2, true);
        }
    }

    // Top Section / Title Bar
    if (_is_board) {
        // Case Board top section: background #fdcf49 extended to fill gaps left by sprite
        draw_set_color(_col_gold_top);
        if (_has_overlay_sprite) {
            draw_rectangle(_mx1 - 10, _my1 - 10, _mx2 + 10, _my1 + 26, false);
            draw_set_color(_col_grey_line); // #bbbbbb divider line
            draw_line(_mx1 - 10, _my1 + 26, _mx2 + 10, _my1 + 26);
        } else {
            draw_rectangle(_mx1 + 1, _my1 + 1, _mx2 - 1, _my1 + 26, false);
            draw_set_color(_col_grey_line); // #bbbbbb divider line
            draw_line(_mx1, _my1 + 26, _mx2, _my1 + 26);
        }

        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(c_white); // CASE BOARD text in white
        draw_text(_mx1 + 10, _my1 + 14, global.pc_screen_title);

        // TAB TO CLOSE badge on top bar right in white
        draw_set_halign(fa_right);
        draw_set_color(c_white);
        draw_text_transformed(_mx2 - 30, _my1 + 14, global.pc_screen_badge, 0.80, 0.80, 0);

        // Close [X] button in top-right of screen in white
        var _bx1 = _mx2 - 22, _by1 = _my1 + 4, _bx2 = _mx2 - 4, _by2 = _my1 + 22;
        var _gmx = device_mouse_x_to_gui(0);
        var _gmy = device_mouse_y_to_gui(0);
        var _hover_x = point_in_rectangle(_gmx, _gmy, _bx1, _by1, _bx2, _by2);
        draw_set_color(_hover_x ? c_red : c_white);
        draw_rectangle(_bx1, _by1, _bx2, _by2, true);
        draw_set_halign(fa_center);
        draw_text((_bx1 + _bx2) * 0.5, (_by1 + _by2) * 0.5, "X");
    } else if (!_is_white) {
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
    } else {
        draw_set_color(c_white);
        draw_rectangle(_mx1 + 1, _my1 + 1, _mx2 - 1, _my1 + 24, false);
        draw_set_color(c_black);
        // 3x thicker divider line
        for (var _th = 0; _th < 3; _th++) {
            draw_line(_mx1, _my1 + 24 + _th, _mx2, _my1 + 24 + _th);
        }

        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(c_black);
        draw_text(_mx1 + 10, _my1 + 13, global.pc_screen_title);

        // Clue counter pill on top bar right
        draw_set_halign(fa_right);
        draw_set_color(c_black);
        draw_text_transformed(_mx2 - 30, _my1 + 13, global.pc_screen_badge, 0.80, 0.80, 0);

        // Close [X] button in top-right of screen
        var _bx1 = _mx2 - 22, _by1 = _my1 + 3, _bx2 = _mx2 - 4, _by2 = _my1 + 21;
        var _gmx = device_mouse_x_to_gui(0);
        var _gmy = device_mouse_y_to_gui(0);
        var _hover_x = point_in_rectangle(_gmx, _gmy, _bx1, _by1, _bx2, _by2);
        draw_set_color(_hover_x ? c_red : c_black);
        // 3x thicker box border around [X]
        for (var _th = 0; _th < 3; _th++) {
            draw_rectangle(_bx1 + _th, _by1 + _th, _bx2 - _th, _by2 - _th, true);
        }
        draw_set_halign(fa_center);
        draw_text((_bx1 + _bx2) * 0.5, (_by1 + _by2) * 0.5, "X");
    }

    // Subtle CRT horizontal scanlines (omitted in solid white theme and case board)
    if (!_is_white && !_is_board) {
        draw_set_alpha(0.06);
        draw_set_color(c_aqua);
        for (var _sy = _my1 + 28; _sy < _my2 - 4; _sy += 5) {
            draw_line(_mx1 + 2, _sy, _mx2 - 2, _sy);
        }
        draw_set_alpha(1.0);
    }

    var _case   = variable_global_exists("floor_case") ? global.floor_case : scr_get_floor_incident_case(0);
    var _mode   = variable_global_exists("pc_screen_mode") ? global.pc_screen_mode : 0;
    var _solved = (variable_global_exists("incident_solved") && global.incident_solved);

    if (variable_global_exists("pc_input_cooldown") && global.pc_input_cooldown > 0) {
        global.pc_input_cooldown--;
    }
    var _can_input = (!variable_global_exists("pc_input_cooldown") || global.pc_input_cooldown <= 0);
    var _min_ev    = min(2, variable_global_exists("evidence_needed") ? global.evidence_needed : 2);

    if (_mode == 3) {
        // =====================================================
        // CASE BOARD: suspects + resolution-safe scrollable evidence + ACCUSE button
        // =====================================================
        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        var _is_tutorial = (!variable_global_exists("chapter_floor") || global.chapter_floor <= 3);
        var _bd_y = _my1 + 36;
        draw_set_color(make_color_rgb(175, 125, 20));
        draw_text_transformed(_mx1 + 14, _bd_y, "SUSPECTS  (inspect their desks for Critical Lvl 3 Evidence)", 0.98, 0.98, 0);
        draw_text_transformed(_mx1 + 14.8, _bd_y, "SUSPECTS  (inspect their desks for Critical Lvl 3 Evidence)", 0.98, 0.98, 0);
        _bd_y += 16;

        var _bd_n = array_length(global.case_suspects);
        for (var _bs = 0; _bs < _bd_n; _bs++) {
            var _sp = global.case_suspects[_bs];
            var _wrong_acc = (variable_struct_exists(_sp, "accused_wrong") && _sp.accused_wrong);
            var _st_txt = _is_tutorial ? "UNKNOWN" : "SUSPECT";
            var _st_col = make_color_rgb(50, 60, 70);
            if (_is_tutorial) {
                if (_sp.status == 1) { _st_txt = "CLEARED";       _st_col = make_color_rgb(140, 145, 150); }
                if (_sp.status == 2) { _st_txt = "PRIME SUSPECT"; _st_col = make_color_rgb(215, 45, 45); }
            } else if (_wrong_acc) {
                _st_txt = "WRONG ACCUSATION";
                _st_col = make_color_rgb(140, 145, 150);
            }
            if (_solved && _bs == global.case_culprit_idx) { _st_txt = "PATIENT ZERO"; _st_col = make_color_rgb(20, 150, 40); }
            draw_set_color(_st_col);
            draw_text_transformed(_mx1 + 18, _bd_y, _sp.name + "  -  " + _sp.dept + "  [Desk " + _sp.nameplate + "]", 0.90, 0.90, 0);
            draw_text_transformed(_mx1 + 18.8, _bd_y, _sp.name + "  -  " + _sp.dept + "  [Desk " + _sp.nameplate + "]", 0.90, 0.90, 0);
            draw_set_halign(fa_right);
            draw_text_transformed(_mx2 - 14, _bd_y, _st_txt, 0.90, 0.90, 0);
            draw_text_transformed(_mx2 - 13.2, _bd_y, _st_txt, 0.90, 0.90, 0);
            draw_set_halign(fa_left);
            if (((_is_tutorial && _sp.status == 1) || (!_is_tutorial && _wrong_acc)) && !(_solved && _bs == global.case_culprit_idx)) {
                var _tw = string_width(_sp.name + "  -  " + _sp.dept + "  [Desk " + _sp.nameplate + "]") * 0.90;
                draw_set_color(_col_grey_line); // #bbbbbb strikethrough line
                draw_line(_mx1 + 18, _bd_y, _mx1 + 18 + _tw, _bd_y);
            }
            _bd_y += 16;
        }

        _bd_y += 4;
        draw_set_color(make_color_rgb(20, 95, 135));
        draw_text_transformed(_mx1 + 14, _bd_y, "EVIDENCE LOG  (" + string(global.evidence_found) + "/" + string(global.evidence_needed) + ")   [W/S or WHEEL to Scroll]", 0.98, 0.98, 0);
        draw_text_transformed(_mx1 + 14.8, _bd_y, "EVIDENCE LOG  (" + string(global.evidence_found) + "/" + string(global.evidence_needed) + ")   [W/S or WHEEL to Scroll]", 0.98, 0.98, 0);
        _bd_y += 14;

        // Scrollable Evidence Viewport (Item-Index Pagination — 100% resolution-independent, no gpu_set_scissor bug!)
        var _ev_x1 = _mx1 + 10;
        var _ev_y1 = _bd_y;
        var _ev_x2 = _mx2 - 10;
        var _ev_y2 = _my2 - 46;
        var _ev_w  = _ev_x2 - _ev_x1;
        var _ev_h  = max(40, _ev_y2 - _ev_y1);

        draw_set_color(make_color_rgb(250, 252, 253));
        draw_rectangle(_ev_x1, _ev_y1, _ev_x2, _ev_y2, false);
        draw_set_color(_col_grey_line); // #bbbbbb viewport outline
        draw_rectangle(_ev_x1, _ev_y1, _ev_x2, _ev_y2, true);

        var _ev_scale = 0.88;
        var _ev_sep   = 18;
        var _wrap_w   = (_ev_w - 24) / _ev_scale;
        var _bd_ne    = array_length(global.case_evidence);
        var _ev_texts = array_create(_bd_ne, "");
        var _ev_hs    = array_create(_bd_ne, 0);

        for (var _be = 0; _be < _bd_ne; _be++) {
            var _evi = global.case_evidence[_be];
            var _tier = variable_struct_exists(_evi, "tier") ? _evi.tier : 2;
            var _txt = _evi.found
                ? (string(_be + 1) + ". " + string_replace_all(_evi.text, "\n", " "))
                : (string(_be + 1) + ". [LVL " + string(_tier) + " LOCKED] ??? (Search " + (_tier == 3 ? "Suspect Desk Terminals" : "coworkers, memos & office PCs") + ")");
            _ev_texts[_be] = _txt;
            _ev_hs[_be]    = string_height_ext(_txt, _ev_sep, _wrap_w) * _ev_scale + 8;
        }

        if (!variable_global_exists("case_board_scroll")) global.case_board_scroll = 0;
        var _max_idx = max(0, _bd_ne - 1);
        if (mouse_wheel_up()   || keyboard_check_pressed(vk_up)   || keyboard_check_pressed(ord("W"))) {
            global.case_board_scroll = max(0, global.case_board_scroll - 1);
        }
        if (mouse_wheel_down() || keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
            global.case_board_scroll = min(_max_idx, global.case_board_scroll + 1);
        }
        global.case_board_scroll = clamp(global.case_board_scroll, 0, _max_idx);

        draw_set_valign(fa_top);
        draw_set_halign(fa_left);
        var _cy = _ev_y1 + 4;
        var _vis_count = 0;
        for (var _be2 = global.case_board_scroll; _be2 < _bd_ne; _be2++) {
            var _evi2 = global.case_evidence[_be2];
            var _ih   = _ev_hs[_be2];
            if (_vis_count > 0 && _cy + _ih > _ev_y2 - 3) break;

            draw_set_color((_be2 mod 2 == 0) ? make_color_rgb(240, 244, 248) : c_white);
            draw_rectangle(_ev_x1 + 3, _cy, _ev_x2 - 12, min(_ev_y2 - 2, _cy + _ih - 2), false);

            var _t_col = make_color_rgb(130, 140, 150);
            if (_evi2.found) {
                var _tr = variable_struct_exists(_evi2, "tier") ? _evi2.tier : 2;
                if (_tr == 1)      _t_col = make_color_rgb(170, 115, 0);   // Level 1: Warm Amber
                else if (_tr == 3) _t_col = make_color_rgb(15, 135, 45);    // Level 3: Critical Mint/Green
                else               _t_col = make_color_rgb(15, 95, 145);    // Level 2: Corroborating Navy
            }
            draw_set_color(_t_col);
            draw_text_ext_transformed(_ev_x1 + 7, _cy + 3, _ev_texts[_be2], _ev_sep, _wrap_w, _ev_scale, _ev_scale, 0);
            draw_text_ext_transformed(_ev_x1 + 7.8, _cy + 3, _ev_texts[_be2], _ev_sep, _wrap_w, _ev_scale, _ev_scale, 0);
            _cy += _ih + 2;
            _vis_count++;
        }

        // Scrollbar on right edge of viewport
        if (_bd_ne > _vis_count && _bd_ne > 1) {
            var _sb_x1 = _ev_x2 - 8;
            var _sb_x2 = _ev_x2 - 3;
            var _sb_y1 = _ev_y1 + 3;
            var _sb_y2 = _ev_y2 - 3;
            var _sb_h  = _sb_y2 - _sb_y1;
            var _thumb_h = max(14, _sb_h * (_vis_count / _bd_ne));
            var _thumb_y = _sb_y1 + (_sb_h - _thumb_h) * (global.case_board_scroll / max(1, _bd_ne - 1));
            draw_set_color(make_color_rgb(240, 240, 240));
            draw_rectangle(_sb_x1, _sb_y1, _sb_x2, _sb_y2, false);
            draw_set_color(_col_grey_line); // #bbbbbb scrollbar line
            draw_rectangle(_sb_x1, _sb_y1, _sb_x2, _sb_y2, true);
            draw_set_color(make_color_rgb(160, 160, 160));
            draw_rectangle(_sb_x1, _thumb_y, _sb_x2, _thumb_y + _thumb_h, false);
        }

        // Interactive [ACCUSE SUSPECT] Button directly on the Case Board
        var _crit_found = 0;
        for (var _cf = 0; _cf < _bd_ne; _cf++) {
            var _cevi = global.case_evidence[_cf];
            if (_cevi.found && variable_struct_exists(_cevi, "tier") && _cevi.tier == 3) {
                _crit_found++;
            }
        }
        var _ab_x1 = _mcx - 205;
        var _ab_y1 = _my2 - 42;
        var _ab_x2 = _mcx + 205;
        var _ab_y2 = _my2 - 20;
        var _can_accuse = (!_solved && global.evidence_found >= _min_ev && _crit_found >= 1);
        var _hover_acc  = point_in_rectangle(_gmx, _gmy, _ab_x1, _ab_y1, _ab_x2, _ab_y2);

        draw_set_color(_solved ? make_color_rgb(215, 245, 220) : (_can_accuse ? (_hover_acc ? make_color_rgb(45, 95, 125) : make_color_rgb(30, 70, 95)) : make_color_rgb(240, 242, 245)));
        draw_rectangle(_ab_x1, _ab_y1, _ab_x2, _ab_y2, false);
        draw_set_color(_solved ? make_color_rgb(20, 140, 40) : _col_grey_line); // #bbbbbb border line
        draw_rectangle(_ab_x1, _ab_y1, _ab_x2, _ab_y2, true);

        draw_set_valign(fa_middle);
        draw_set_halign(fa_center);
        var _btn_lbl = "";
        if (_solved) {
            _btn_lbl = "CASE SOLVED — PROCEED TO LOCKDOWN OVERRIDE";
            draw_set_color(make_color_rgb(20, 140, 40));
        } else if (_can_accuse) {
            _btn_lbl = "[E / ENTER / CLICK]  ACCUSE A SUSPECT";
            draw_set_color(c_white);
        } else if (_crit_found < 1) {
            _btn_lbl = "INSPECT A SUSPECT DESK FOR 1 [LVL 3: CRITICAL] CLUE";
            draw_set_color(make_color_rgb(160, 110, 0));
        } else {
            _btn_lbl = "GATHER " + string(_min_ev) + " CLUES TO ACCUSE (" + string(global.evidence_found) + "/" + string(_min_ev) + " FOUND)";
            draw_set_color(make_color_rgb(160, 110, 0));
        }
        draw_text_transformed(_mcx, (_ab_y1 + _ab_y2) * 0.5, _btn_lbl, 0.88, 0.88, 0);
        draw_text_transformed(_mcx + 0.8, (_ab_y1 + _ab_y2) * 0.5, _btn_lbl, 0.88, 0.88, 0);

        if (_can_accuse && _can_input && (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || (_hover_acc && mouse_check_button_pressed(mb_left)))) {
            audio_play_sound(snd_button_click, 6, false);
            global.pc_input_cooldown  = 10;
            global.pc_screen_select   = 0;
            global.pc_screen_feedback = "";
            if (variable_global_exists("case_culprit_confirmed") && global.case_culprit_confirmed) {
                global.pc_screen_mode  = 2;
                global.pc_screen_title = "CASE BOARD — IDENTIFY ATTACK VECTOR";
            } else {
                global.pc_screen_mode  = 1;
                global.pc_screen_title = "CASE BOARD — ACCUSE A SUSPECT";
            }
        }

        draw_set_color(make_color_rgb(110, 120, 130));
        draw_text_transformed(_mcx, _my2 - 10, "Wrong accusations: " + string(global.case_wrong_accusations) + "     [TAB / ESC] Close", 0.85, 0.85, 0);
        draw_text_transformed(_mcx + 0.8, _my2 - 10, "Wrong accusations: " + string(global.case_wrong_accusations) + "     [TAB / ESC] Close", 0.85, 0.85, 0);

    } else if (_mode == 1 || _mode == 2) {
        // =====================================================
        // CASE BOARD ACCUSATION FLOW: Pick Suspect (Mode 1) -> Pick Attack Vector (Mode 2)
        // =====================================================
        var _labels = [];
        var _desc   = "";
        var _bd_n2  = array_length(global.case_suspects);

        if (_mode == 1) {
            _desc = "WHOSE ACCIDENTAL SLIP-UP LET THE HACKERS IN? Select Patient Zero based on your Case Board evidence (" + string(global.evidence_found) + "/" + string(global.evidence_needed) + " clues):";
            for (var _s_i = 0; _s_i < _bd_n2; _s_i++) {
                var _s_obj = global.case_suspects[_s_i];
                var _w_tag = (variable_struct_exists(_s_obj, "accused_wrong") && _s_obj.accused_wrong) ? "  [RULED OUT]" : "";
                array_push(_labels, "SELECT: " + _s_obj.name + "  (" + _s_obj.dept + " - Desk " + _s_obj.nameplate + ")" + _w_tag);
            }
            array_push(_labels, "< Back to Case Board");
        } else {
            var _cul_obj = global.case_suspects[global.case_culprit_idx];
            _desc = "PATIENT ZERO IDENTIFIED: " + _cul_obj.name + " (Desk " + _cul_obj.nameplate + ")!\nNow select WHICH accidental slip-up / hazard caused the breach:";
            for (var _v_i = 0; _v_i < array_length(global.case_vectors); _v_i++) {
                array_push(_labels, global.case_vectors[_v_i]);
            }
            array_push(_labels, "< Back to Case Board");
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
        draw_set_color(make_color_rgb(40, 45, 55));
        draw_text_ext_transformed(_mcx, _my1 + 44, _desc, 15, (_mw - 30) / 0.95, 0.95, 0.95, 0);
        draw_text_ext_transformed(_mcx + 0.8, _my1 + 44, _desc, 15, (_mw - 30) / 0.95, 0.95, 0.95, 0);

        var _clicked_item = false;
        draw_set_halign(fa_left);
        for (var _ii = 0; _ii < _num_items; _ii++) {
            var _iy = _my1 + 76 + (_ii * 25);
            var _is_sel = (global.pc_screen_select == _ii);

            var _gmx2 = device_mouse_x_to_gui(0);
            var _gmy2 = device_mouse_y_to_gui(0);
            var _hover_item = point_in_rectangle(_gmx2, _gmy2, _mx1 + 14, _iy - 11, _mx2 - 14, _iy + 11);
            if (_hover_item && mouse_check_button_pressed(mb_left)) {
                global.pc_screen_select = _ii;
                _is_sel = true;
                _clicked_item = true;
            }

            draw_set_color(_is_sel ? make_color_rgb(230, 242, 252) : make_color_rgb(248, 249, 250));
            draw_rectangle(_mx1 + 14, _iy - 11, _mx2 - 14, _iy + 11, false);
            draw_set_color(_is_sel ? make_color_rgb(40, 120, 190) : _col_grey_line); // #bbbbbb
            draw_rectangle(_mx1 + 14, _iy - 11, _mx2 - 14, _iy + 11, true);
            draw_set_color(_is_sel ? make_color_rgb(10, 40, 80) : make_color_rgb(50, 60, 70));
            draw_text_transformed(_mx1 + 20, _iy + 1, (_is_sel ? "> " : "  ") + _labels[_ii], 0.90, 0.90, 0);
            draw_text_transformed(_mx1 + 20.8, _iy + 1, (_is_sel ? "> " : "  ") + _labels[_ii], 0.90, 0.90, 0);
        }

        var _trigger_flag = _can_input && (_clicked_item || keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space));
        if (_trigger_flag) {
            global.pc_input_cooldown = 10;
            if (global.pc_screen_select == _num_items - 1) {
                // "< Back to Case Board"
                audio_play_sound(snd_button_click, 5, false);
                global.pc_screen_mode  = 3;
                global.pc_screen_title = "CASE BOARD";
            } else if (_mode == 1) {
                var _acc_idx = global.pc_screen_select;
                var _acc_sus = global.case_suspects[_acc_idx];
                if (_acc_idx == global.case_culprit_idx) {
                    audio_play_sound(snd_correct_ping, 10, false);
                    global.case_culprit_confirmed = true;
                    global.pc_screen_mode         = 2;
                    global.pc_screen_select       = 0;
                    global.pc_screen_title        = "CASE BOARD — IDENTIFY ATTACK VECTOR";
                    global.pc_screen_feedback     = "CORRECT! " + _acc_sus.name + "'s workstation was Patient Zero. Now select the attack vector!";
                    global.pc_screen_feedback_col = c_lime;
                } else {
                    audio_play_sound(wrong1, 10, false);
                    global.case_wrong_accusations++;
                    global.scrap_count = max(0, global.scrap_count - 2);
                    _acc_sus.accused_wrong = true;
                    scr_case_recompute();
                    global.pc_screen_feedback     = "WRONG SUSPECT! " + _acc_sus.name + " had a verified alibi. (-2 SCRAP) Review your evidence!";
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
                    global.pc_screen_mode         = 3;
                    global.pc_screen_title        = "CASE BOARD — CASE CLOSED";
                    global.pc_screen_feedback     = "CASE SOLVED! +3 SCRAP. " + _case.kyle_debrief;
                    global.pc_screen_feedback_col = c_lime;
                    global.pc_screen_badge        = "OVERRIDE AUTHORIZED";
                } else {
                    audio_play_sound(wrong1, 8, false);
                    global.case_wrong_accusations++;
                    global.pc_screen_feedback     = "INCORRECT VECTOR! Check the [LVL 3: CRITICAL] forensic trace from the culprit's desk.";
                    global.pc_screen_feedback_col = make_color_rgb(255, 110, 95);
                }
            }
        }

        // Feedback / Educational debrief line
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var _fb_txt = (variable_global_exists("pc_screen_feedback") && global.pc_screen_feedback != "")
            ? global.pc_screen_feedback
            : (_mode == 2 ? "Select the attack method described in the culprit's Level 3 Critical Forensics." : "Select a suspect to accuse, or return to the Case Board.");
        var _fb_col = (variable_global_exists("pc_screen_feedback_col") && global.pc_screen_feedback != "") ? global.pc_screen_feedback_col : make_color_rgb(170, 115, 0);
        draw_set_color(_fb_col);
        draw_text_ext_transformed(_mcx, _my2 - 58, _fb_txt, 14, (_mw - 30) / 0.88, 0.88, 0.88, 0);
        draw_text_ext_transformed(_mcx + 0.8, _my2 - 58, _fb_txt, 14, (_mw - 30) / 0.88, 0.88, 0.88, 0);

        // Action prompt pill
        draw_set_color(c_white);
        draw_rectangle(_mcx - 180, _my2 - 38, _mcx + 180, _my2 - 20, false);
        draw_set_color(_col_grey_line); // #bbbbbb
        draw_rectangle(_mcx - 180, _my2 - 38, _mcx + 180, _my2 - 20, true);
        draw_set_color(make_color_rgb(30, 40, 50));
        draw_text_transformed(_mcx, _my2 - 29, "[W/S or CLICK] Select   [E / ENTER] Confirm", 0.88, 0.88, 0);
        draw_text_transformed(_mcx + 0.8, _my2 - 29, "[W/S or CLICK] Select   [E / ENTER] Confirm", 0.88, 0.88, 0);

    } else {
        // Centered Main Clue Box
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(_is_white ? c_black : c_white);
        var _clue_y = _has_overlay_sprite ? ((_my1 + 24 + _my2 - 54) * 0.5) : (_my1 + 92);
        draw_text_ext_transformed(_mcx, _clue_y, global.pc_screen_body, 18, (_mw - 48) / 0.82, 0.82, 0.82, 0);

        // Compact Radar Pill at bottom of monitor
        var _rx1 = _mcx - 135;
        var _ry1 = _my2 - 52;
        var _rx2 = _mcx + 135;
        var _ry2 = _my2 - 28;

        if (_is_white) {
            draw_set_color(c_white);
            draw_rectangle(_rx1, _ry1, _rx2, _ry2, false);
            draw_set_color(c_black);
            // 3x thicker box border around radar text
            for (var _th = 0; _th < 3; _th++) {
                draw_rectangle(_rx1 + _th, _ry1 + _th, _rx2 - _th, _ry2 - _th, true);
            }
            draw_text_transformed(_mcx, _my2 - 40, global.pc_screen_radar, 0.85, 0.85, 0);
        } else {
            draw_set_color(make_color_rgb(14, 30, 44));
            draw_rectangle(_rx1, _ry1, _rx2, _ry2, false);
            draw_set_color(c_aqua);
            draw_rectangle(_rx1, _ry1, _rx2, _ry2, true);
            draw_set_color(c_white);
            draw_text_transformed(_mcx, _my2 - 40, global.pc_screen_radar, 0.85, 0.85, 0);
        }
    }

    // Minimal close prompt (mode 3 draws its own combined footer)
    if (_mode != 3) {
        draw_set_color(_is_white ? c_black : make_color_rgb(150, 200, 175));
        draw_text_transformed(_mcx, _my2 - 13, "[ESC] Close", 0.80, 0.80, 0);
    }

    // Custom UI Sprite Overlay (spr_dungeon_caseboard_ui / spr_dungeon_terminal_ui) layered over the UI
    if (_has_overlay_sprite) {
        var _spr_w = sprite_get_width(_overlay_sprite);
        var _spr_h = sprite_get_height(_overlay_sprite);
        draw_sprite_ext(_overlay_sprite, 0, 0, 0, _gui_w / _spr_w, _gui_h / _spr_h, 0, c_white, 1.0);
    }

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
    global.pc_input_cooldown  = 8;
    global.pc_screen_mode     = 3;
    global.pc_screen_is_pz    = false;
    global.pc_screen_target   = noone;
    global.pc_screen_select   = 0;
    global.pc_screen_feedback = "";
    global.case_board_scroll  = 0;
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

// Top-left Dynamic Quest & Status Box
draw_set_alpha(0.86);
draw_set_color(make_color_rgb(10, 14, 22));
draw_rectangle(8, 8, 286, 102, false);
draw_set_alpha(1.0);
draw_set_color(_phase_col);
draw_rectangle(8, 8, 286, 102, true);

// Line 1: Chapter, Floor X/10 & Phase Badge
draw_set_color(c_white);
draw_text_transformed(15, 18, "CH." + string(_ch_num) + " " + _ch_short + "  •  FLR " + string(_flr_num) + "/10", 0.82, 0.82, 0);
draw_set_halign(fa_right);
draw_set_color(_phase_col);
draw_text_transformed(280, 18, "[" + _curr.phase_name + "]", 0.76, 0.76, 0);
draw_set_halign(fa_left);

// Gather live quest state
var _has_key    = (variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key);
var _clues_cur  = variable_global_exists("clues_found")     ? global.clues_found     : 0;
var _ev_cur     = variable_global_exists("evidence_found")  ? global.evidence_found  : 0;
var _ev_req     = variable_global_exists("evidence_needed") ? global.evidence_needed : 0;
var _pz_solved  = (variable_global_exists("incident_solved")     && global.incident_solved);
var _ov_done    = (variable_global_exists("lockdown_overridden") && global.lockdown_overridden);
var _pwr_done   = (variable_global_exists("power_restored")      && global.power_restored);
var _gate_ev    = min(2, _ev_req);
var _crit_cnt   = 0;
if (variable_global_exists("case_evidence")) {
    for (var _ci = 0; _ci < array_length(global.case_evidence); _ci++) {
        var _ce = global.case_evidence[_ci];
        if (_ce.found && variable_struct_exists(_ce, "tier") && _ce.tier == 3) _crit_cnt++;
    }
}
var _ready_acc  = (!_pz_solved && _ev_cur >= _gate_ev && _crit_cnt >= 1);
var _all_ev     = (_ev_req > 0 && _ev_cur >= _ev_req);

// Track & trigger Milestone Completion Toast Banners
if (!variable_instance_exists(id, "ms_init")) {
    ms_init           = true;
    ms_hint_done      = false;
    ms_key_done       = false;
    ms_ready_acc_done = false;
    ms_all_ev_done    = false;
    ms_case_done      = false;
    ms_ov_done        = false;
    ms_pwr_done       = false;
    quest_toast_timer = 0;
    quest_toast_title = "";
    quest_toast_sub   = "";
    quest_toast_col   = c_lime;
}
if (!ms_hint_done && _clues_cur >= 1 && !_has_key) {
    ms_hint_done      = true;
    quest_toast_timer = 190;
    quest_toast_title = "KEY VAULT HINT FOUND!";
    quest_toast_sub   = "Next Quest: Unlock the Gold Key Vault door & grab the Cipher Key!";
    quest_toast_col   = make_color_rgb(255, 215, 65);
}
if (!ms_key_done && _has_key) {
    ms_key_done       = true;
    quest_toast_timer = 190;
    quest_toast_title = "CIPHER KEY ACQUIRED — TERMINALS UNLOCKED!";
    quest_toast_sub   = "Next Quest: Inspect Suspect Desks & Coworkers to solve the breach!";
    quest_toast_col   = c_aqua;
}
if (!ms_all_ev_done && _has_key && _all_ev && !_pz_solved) {
    ms_all_ev_done    = true;
    ms_ready_acc_done = true;
    quest_toast_timer = 210;
    quest_toast_title = "ALL EVIDENCE FOUND (" + string(_ev_cur) + "/" + string(_ev_req) + ")!";
    quest_toast_sub   = "Open [TAB] Case Board to accuse the culprit, then Override the Lockdown!";
    quest_toast_col   = c_lime;
} else if (!ms_ready_acc_done && _has_key && _ready_acc && !_pz_solved) {
    ms_ready_acc_done = true;
    quest_toast_timer = 190;
    quest_toast_title = "CRITICAL PROOF FOUND — READY TO ACCUSE!";
    quest_toast_sub   = "Press [TAB] to accuse a suspect now, or keep searching for all clues!";
    quest_toast_col   = make_color_rgb(135, 255, 165);
}
if (!ms_case_done && _pz_solved) {
    ms_case_done      = true;
    quest_toast_timer = 210;
    quest_toast_title = "CASE SOLVED — LOCKDOWN OVERRIDE UNLOCKED!";
    quest_toast_sub   = "Next Quest: Head to the Security Control Room & hit the Override Console!";
    quest_toast_col   = c_lime;
}
if (!ms_ov_done && _ov_done) {
    ms_ov_done        = true;
    quest_toast_timer = 190;
    quest_toast_title = "LOCKDOWN OVERRIDDEN — BREAKER ROOM OPEN!";
    quest_toast_sub   = "Next Quest: Fix the 3 fuses in the Electrical Breaker Room!";
    quest_toast_col   = make_color_rgb(255, 210, 60);
}
if (!ms_pwr_done && _pwr_done) {
    ms_pwr_done       = true;
    quest_toast_timer = 210;
    quest_toast_title = "FLOOR POWER RESTORED!";
    quest_toast_sub   = "Final Quest: Unlock & board the Extraction Elevator to complete the floor!";
    quest_toast_col   = c_lime;
}

// Line 2: Chapter Cipher Key status
if (_has_key) {
    draw_set_color(c_lime);
    if (_ch_num == CHAPTER_VIGENERE) {
        var _vk = variable_global_exists("dungeon_vigenere_key") ? global.dungeon_vigenere_key : "CAB";
        draw_text_transformed(15, 33, "VIGENERE KEY:  " + _vk, 0.80, 0.80, 0);
    } else if (_ch_num == CHAPTER_ATBASH) {
        draw_text_transformed(15, 33, "ATBASH KEY:  MIRROR (A<->Z)", 0.80, 0.80, 0);
    } else {
        var _k = global.dungeon_cipher_key;
        var _k_str = (_k > 0) ? ("+" + string(_k)) : string(_k);
        draw_text_transformed(15, 33, "CAESAR KEY:  SHIFT " + _k_str, 0.80, 0.80, 0);
    }
} else {
    draw_set_color(make_color_rgb(255, 200, 50));
    draw_text_transformed(15, 33, _ch_short + " KEY:  LOCKED IN VAULT", 0.80, 0.80, 0);
}

// Lines 3 & 4: Dynamic Phase Quest Tracker (replaces static [ ]1.KEY [ ]2.OVERRIDE [ ]3.POWER)
var _q_line1 = "";
var _q_line2 = "";
var _q_col1  = c_white;
var _q_col2  = make_color_rgb(185, 215, 235);

if (!_has_key) {
    // PHASE 1 QUEST: Unlock the Key Vault
    _q_line1 = (_clues_cur >= 1)
        ? "[x] QUEST 1A: Found Hint on Security PC"
        : "[>] QUEST 1A: Find Hint on Security PC";
    _q_col1  = (_clues_cur >= 1) ? c_lime : make_color_rgb(255, 215, 60);
    _q_line2 = (_clues_cur >= 1)
        ? "[!] QUEST 1B: Get the Key in the Key Vault!"
        : "[ ] QUEST 1B: Get the Key in the Key Vault";
    _q_col2  = (_clues_cur >= 1) ? c_aqua : make_color_rgb(150, 170, 190);
} else if (!_pz_solved) {
    // PHASE 2 QUEST: Investigate & Accuse on Case Board [TAB]
    if (_all_ev) {
        _q_line1 = "[x] ALL EVIDENCE FOUND (" + string(_ev_cur) + "/" + string(_ev_req) + ")!";
        _q_col1  = c_lime;
        _q_line2 = "[!] QUEST: Accuse on [TAB] -> Override Lockdown!";
        _q_col2  = make_color_rgb(255, 220, 75);
    } else if (_ready_acc) {
        _q_line1 = "[x] Clues: " + string(_ev_cur) + "/" + string(_ev_req) + " (Lvl 3 Proof Found!)";
        _q_col1  = make_color_rgb(135, 255, 165);
        _q_line2 = "[!] QUEST: Press [TAB] to Accuse Suspect!";
        _q_col2  = make_color_rgb(255, 215, 60);
    } else {
        _q_line1 = "[>] QUEST 2A: Find Clues (" + string(_ev_cur) + "/" + string(_ev_req) + ") & Lvl 3 Proof (" + string(_crit_cnt) + "/1)";
        _q_col1  = make_color_rgb(255, 215, 60);
        _q_line2 = "[ ] QUEST 2B: Accuse Culprit on [TAB] Board";
        _q_col2  = make_color_rgb(150, 170, 190);
    }
} else if (!_pwr_done) {
    // PHASE 3 QUEST: Override Lockdown & Fix Breaker
    _q_line1 = _ov_done
        ? "[x] QUEST 3A: Lockdown Override Activated"
        : "[!] QUEST 3A: Override the Lockdown Console!";
    _q_col1  = _ov_done ? c_lime : make_color_rgb(255, 110, 130);
    _q_line2 = _ov_done
        ? "[!] QUEST 3B: Fix Breaker in Breaker Room!"
        : "[ ] QUEST 3B: Fix Breaker in Breaker Room";
    _q_col2  = _ov_done ? make_color_rgb(255, 215, 60) : make_color_rgb(150, 170, 190);
} else {
    // PHASE 4 QUEST: Escape via Extraction Elevator
    _q_line1 = "[x] ALL FLOOR SYSTEMS RESTORED!";
    _q_col1  = c_lime;
    _q_line2 = "[!] FINAL QUEST: Leave via Extraction Elevator!";
    _q_col2  = c_aqua;
}

draw_set_color(_q_col1);
draw_text_transformed(15, 50, _q_line1, 0.68, 0.68, 0);
draw_set_color(_q_col2);
draw_text_transformed(15, 66, _q_line2, 0.68, 0.68, 0);

// Line 5: Wrench Scrap Counter & Drone Jammer Status
var _scrp_cur = variable_global_exists("scrap_count")    ? global.scrap_count    : 0;
var _hr_cur   = variable_global_exists("hr_scrap_count") ? global.hr_scrap_count : 0;
var _jam_t    = variable_global_exists("drone_jammed_timer") ? global.drone_jammed_timer : 0;

draw_set_color(c_aqua);
draw_text_transformed(15, 84, "SCRAP: " + string(_scrp_cur), 0.76, 0.76, 0);

if (_jam_t > 0) {
    var _jam_sec = ceil(_jam_t / 60);
    draw_set_halign(fa_right);
    draw_set_color(c_lime);
    draw_text_transformed(280, 84, "DRONES JAMMED: " + string(_jam_sec) + "s", 0.72, 0.72, 0);
    draw_set_halign(fa_left);
}

// =========================================================
// MILESTONE COMPLETION TOAST BANNER (Pops up when completing steps!)
// =========================================================
if (quest_toast_timer > 0) {
    quest_toast_timer--;
    var _qt_a = clamp(quest_toast_timer / 30, 0, 1);
    var _qx1  = 292;
    var _qx2  = _gui_w - 10;
    var _qy1  = 56;
    var _qy2  = 98;
    var _qcx  = (_qx1 + _qx2) * 0.5;

    draw_set_alpha(_qt_a * 0.94);
    draw_set_color(make_color_rgb(10, 22, 28));
    draw_rectangle(_qx1, _qy1, _qx2, _qy2, false);
    draw_set_alpha(_qt_a);
    draw_set_color(quest_toast_col);
    draw_rectangle(_qx1, _qy1, _qx2, _qy2, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(quest_toast_col);
    draw_text_transformed(_qcx, _qy1 + 13, "[✓] " + quest_toast_title, 0.74, 0.74, 0);
    draw_set_color(c_white);
    draw_text_transformed(_qcx, _qy1 + 29, quest_toast_sub, 0.64, 0.64, 0);
    draw_set_halign(fa_left);
    draw_set_alpha(1.0);
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
// ROOM NAME POPUP BANNER (Top-Right, Persistent in Room)
// =========================================================
if (variable_instance_exists(id, "room_popup_alpha") && room_popup_alpha > 0 && room_popup_text != "") {
    draw_set_font(fnt_dialogue);
    var _scale = 0.74;
    var _str_w = string_width(room_popup_text) * _scale;
    var _pad_x = 12;
    var _box_w = ceil(_str_w + (_pad_x * 2));
    var _box_h = 22;

    var _rx2 = _gui_w - 14;
    var _rx1 = round(_rx2 - _box_w);
    var _ry1 = (banner_timer > 0) ? 58 : 12;
    var _ry2 = _ry1 + _box_h;

    draw_set_alpha(room_popup_alpha);
    draw_set_color(c_white);
    draw_rectangle(_rx1, _ry1, _rx2, _ry2, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed((_rx1 + _rx2) * 0.5, (_ry1 + _ry2) * 0.5, room_popup_text, _scale, _scale, 0);

    draw_set_alpha(1.0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
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
