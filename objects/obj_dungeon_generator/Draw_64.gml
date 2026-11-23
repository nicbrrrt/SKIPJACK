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

    var _is_board = (variable_global_exists("pc_screen_mode") && global.pc_screen_mode >= 1 && global.pc_screen_mode <= 4);
    var _is_white = (_terminal_white_theme && !_is_board);

    var _col_board_line = make_color_rgb(226, 211, 134); // #e2d386
    var _col_grey_line  = _is_board ? _col_board_line : make_color_rgb(187, 187, 187); // #bbbbbb
    var _col_gold_top   = make_color_rgb(253, 207, 73);  // #fdcf49

    // Use spr_dungeon_caseboard_ui for case board, spr_dungeon_terminal_ui for terminal popups
    var _overlay_sprite = spr_dungeon_terminal_ui;
    if (_is_board && sprite_exists(spr_dungeon_caseboard_ui)) {
        _overlay_sprite = spr_dungeon_caseboard_ui;
    }
    var _has_overlay_sprite = (_use_terminal_overlay && sprite_exists(_overlay_sprite));

    var _mcx = _gui_w * 0.5;
    var _mcy = _has_overlay_sprite ? (_gui_h * 0.5) : (_gui_h * 0.47);
    var _mw  = _has_overlay_sprite ? (_is_board ? 542 : 598) : (_is_board ? min(540, _gui_w - 36) : 410);
    var _mh  = _has_overlay_sprite ? (_is_board ? 262 : 303) : (_is_board ? min(304, _gui_h - 40) : 204);
    var _mx1 = _mcx - _mw * 0.5;
    var _my1 = _has_overlay_sprite ? (_is_board ? 52 : (_mcy - _mh * 0.5)) : (_mcy - _mh * 0.5);
    var _mx2 = _mx1 + _mw;
    var _my2 = _my1 + _mh;

    var _gmx = device_mouse_x_to_gui(0);
    var _gmy = device_mouse_y_to_gui(0);
    var _hover_x = false;

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

    // Inner Screen Background Layer
    if (_is_board) {
        // spr_dungeon_caseboard_layer layered below caseboard_ui and text content
        if (sprite_exists(spr_dungeon_caseboard_layer)) {
            var _cbl_w = sprite_get_width(spr_dungeon_caseboard_layer);
            var _cbl_h = sprite_get_height(spr_dungeon_caseboard_layer);
            draw_sprite_ext(spr_dungeon_caseboard_layer, 0, 0, 0, _gui_w / _cbl_w, _gui_h / _cbl_h, 0, c_white, 1.0);
        }
        // Top header and solid background color made transparent/gone per user request
    } else if (sprite_exists(spr_dungeon_terminal_popup)) {
        // spr_dungeon_terminal_popup layered below spr_dungeon_terminal_ui and text content
        var _tp_w = sprite_get_width(spr_dungeon_terminal_popup);
        var _tp_h = sprite_get_height(spr_dungeon_terminal_popup);
        draw_sprite_ext(spr_dungeon_terminal_popup, 0, _mx1, _my1, _mw / _tp_w, _mh / _tp_h, 0, c_white, 1.0);
    } else {
        var _bg_col = _is_white ? c_white : make_color_rgb(8, 18, 22);
        draw_set_color(_bg_col);
        if (_has_overlay_sprite) {
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
    }

    // Top Section / Title Bar
    if (_is_board) {
        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(c_white); // CASE BOARD text in white
        draw_text(_mx1 + 10, _my1 + 14, global.pc_screen_title);

        // TAB TO CLOSE badge on top bar right in white
        draw_set_halign(fa_right);
        draw_set_color(c_white);
        draw_text(floor(_mx2 - 14), floor(_my1 + 14), global.pc_screen_badge);

        // Caseboard has no X button per user request (closed via TAB / ESC)
    } else if (!_is_white) {
        draw_set_color(make_color_rgb(16, 48, 42));
        draw_rectangle(_mx1 + 1, _my1 + 1, _mx2 - 1, _my1 + 24, false);
        draw_set_color(c_lime);
        draw_line(_mx1, _my1 + 24, _mx2, _my1 + 24);

        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(c_lime);
        draw_text(_mx1 + 10, _my1 + 17, global.pc_screen_title);

        // Close [X] button in top-right of screen (moved to the left, centered vertically)
        var _bx1 = _mx2 - 26, _by1 = _my1 + 8, _bx2 = _mx2 - 8, _by2 = _my1 + 26;
        _hover_x = point_in_rectangle(_gmx, _gmy, _bx1, _by1, _bx2, _by2);
        if (sprite_exists(spr_dungeon_terminal_x_button) && sprite_exists(spr_dungeon_terminal_x_button_hover)) {
            var _x_spr = _hover_x ? spr_dungeon_terminal_x_button_hover : spr_dungeon_terminal_x_button;
            var _xs_w  = sprite_get_width(_x_spr);
            var _xs_h  = sprite_get_height(_x_spr);
            draw_sprite_ext(_x_spr, 0, _bx1, _by1, (_bx2 - _bx1) / _xs_w, (_by2 - _by1) / _xs_h, 0, c_white, 1.0);
        } else {
            draw_set_color(_hover_x ? c_red : c_lime);
            draw_rectangle(_bx1, _by1, _bx2, _by2, true);
            draw_set_halign(fa_center);
            draw_text((_bx1 + _bx2) * 0.5, (_by1 + _by2) * 0.5, "X");
        }

        // Clue counter pill on top bar right (positioned to the left of [X] button, centered vertically)
        draw_set_halign(fa_right);
        draw_set_color(make_color_rgb(255, 210, 55));
        draw_text(floor(_bx1 - 8), floor(_my1 + 17), global.pc_screen_badge);
    } else {
        // For spr_dungeon_terminal_popup: background and divider lines are in the sprite, popup is simply text
        if (!sprite_exists(spr_dungeon_terminal_popup)) {
            draw_set_color(c_white);
            draw_rectangle(_mx1 + 1, _my1 + 1, _mx2 - 1, _my1 + 24, false);
            draw_set_color(c_black);
            // 3x thicker divider line
            for (var _th = 0; _th < 3; _th++) {
                draw_line(_mx1, _my1 + 24 + _th, _mx2, _my1 + 24 + _th);
            }
        }

        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(c_black);
        draw_text(_mx1 + 10, _my1 + 17, global.pc_screen_title);

        // Close [X] button in top-right of screen (centered vertically in header)
        var _bx1 = _mx2 - 26, _by1 = _my1 + 8, _bx2 = _mx2 - 8, _by2 = _my1 + 26;
        _hover_x = point_in_rectangle(_gmx, _gmy, _bx1, _by1, _bx2, _by2);
        if (sprite_exists(spr_dungeon_terminal_x_button) && sprite_exists(spr_dungeon_terminal_x_button_hover)) {
            var _x_spr = _hover_x ? spr_dungeon_terminal_x_button_hover : spr_dungeon_terminal_x_button;
            var _xs_w  = sprite_get_width(_x_spr);
            var _xs_h  = sprite_get_height(_x_spr);
            draw_sprite_ext(_x_spr, 0, _bx1, _by1, (_bx2 - _bx1) / _xs_w, (_by2 - _by1) / _xs_h, 0, c_white, 1.0);
        } else {
            draw_set_color(_hover_x ? c_red : c_black);
            // 3x thicker box border around [X]
            for (var _th = 0; _th < 3; _th++) {
                draw_rectangle(_bx1 + _th, _by1 + _th, _bx2 - _th, _by2 - _th, true);
            }
            draw_set_halign(fa_center);
            draw_text((_bx1 + _bx2) * 0.5, (_by1 + _by2) * 0.5, "X");
        }

        // Clue counter pill on top bar right (positioned to the left of [X] button, centered vertically)
        draw_set_halign(fa_right);
        draw_set_color(c_black);
        draw_text(floor(_bx1 - 8), floor(_my1 + 17), global.pc_screen_badge);
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
        var _bd_y = _my1 + 43;
        draw_set_color(make_color_rgb(175, 125, 20));
        draw_text(floor(_mx1 + 14), floor(_bd_y), "SUSPECTS  (inspect their desks for Critical Lvl 3 Evidence)");
        draw_text(floor(_mx1 + 15), floor(_bd_y), "SUSPECTS  (inspect their desks for Critical Lvl 3 Evidence)");
        _bd_y += 14;

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
            draw_text(floor(_mx1 + 18), floor(_bd_y), _sp.name + "  -  " + _sp.dept + "  [Desk " + _sp.nameplate + "]");
            draw_text(floor(_mx1 + 19), floor(_bd_y), _sp.name + "  -  " + _sp.dept + "  [Desk " + _sp.nameplate + "]");
            draw_set_halign(fa_right);
            draw_text(floor(_mx2 - 14), floor(_bd_y), _st_txt);
            draw_text(floor(_mx2 - 13), floor(_bd_y), _st_txt);
            draw_set_halign(fa_left);
            if (((_is_tutorial && _sp.status == 1) || (!_is_tutorial && _wrong_acc)) && !(_solved && _bs == global.case_culprit_idx)) {
                var _tw = string_width(_sp.name + "  -  " + _sp.dept + "  [Desk " + _sp.nameplate + "]");
                draw_set_color(_col_grey_line); // #e2d386 strikethrough line
                draw_line(floor(_mx1 + 18), floor(_bd_y), floor(_mx1 + 18 + _tw), floor(_bd_y));
            }
            _bd_y += 14;
        }

        _bd_y += 3;
        draw_set_color(make_color_rgb(20, 95, 135));
        draw_text(floor(_mx1 + 14), floor(_bd_y), "EVIDENCE LOG  (" + string(global.evidence_found) + "/" + string(global.evidence_needed) + ")   [W/S or WHEEL to Scroll]");
        draw_text(floor(_mx1 + 15), floor(_bd_y), "EVIDENCE LOG  (" + string(global.evidence_found) + "/" + string(global.evidence_needed) + ")   [W/S or WHEEL to Scroll]");
        _bd_y += 13;

        // Scrollable Evidence Viewport (Item-Index Pagination — 100% resolution-independent, no gpu_set_scissor bug!)
        var _ev_x1 = _mx1 + 10;
        var _ev_y1 = _bd_y;
        var _ev_x2 = _mx2 - 10;
        var _ev_y2 = _my2 - 40;
        var _ev_w  = _ev_x2 - _ev_x1;
        var _ev_h  = max(40, _ev_y2 - _ev_y1);

        draw_set_color(make_color_rgb(250, 252, 253));
        draw_rectangle(_ev_x1, _ev_y1, _ev_x2, _ev_y2, false);
        draw_set_color(_col_grey_line); // #e2d386 viewport outline
        draw_rectangle(_ev_x1, _ev_y1, _ev_x2, _ev_y2, true);

        var _ev_sep   = 14;
        var _wrap_w   = _ev_w - 24;
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
            _ev_hs[_be]    = string_height_ext(_txt, _ev_sep, _wrap_w) + 6;
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
            draw_text_ext(floor(_ev_x1 + 7), floor(_cy + 2), _ev_texts[_be2], _ev_sep, _wrap_w);
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
            draw_set_color(_col_grey_line); // #e2d386 scrollbar line
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
        var _ab_x1 = _mcx - 190;
        var _ab_y1 = _my2 - 36;
        var _ab_x2 = _mcx + 190;
        var _ab_y2 = _my2 - 18;
        var _can_accuse = (!_solved && global.evidence_found >= _min_ev && _crit_found >= 1);
        var _hover_acc  = point_in_rectangle(_gmx, _gmy, _ab_x1, _ab_y1, _ab_x2, _ab_y2);

        draw_set_color(_solved ? make_color_rgb(215, 245, 220) : (_can_accuse ? (_hover_acc ? make_color_rgb(45, 95, 125) : make_color_rgb(30, 70, 95)) : make_color_rgb(240, 242, 245)));
        draw_rectangle(_ab_x1, _ab_y1, _ab_x2, _ab_y2, false);
        draw_set_color(_solved ? make_color_rgb(20, 140, 40) : _col_grey_line); // #e2d386 border line
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
        draw_text(floor(_mcx), floor((_ab_y1 + _ab_y2) * 0.5), _btn_lbl);
        draw_text(floor(_mcx + 1), floor((_ab_y1 + _ab_y2) * 0.5), _btn_lbl);

        if (_can_accuse && _can_input && (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || (_hover_acc && mouse_check_button_pressed(mb_left)))) {
            audio_play_sound(snd_button_click, 6, false);
            global.pc_input_cooldown  = 10;
            global.pc_screen_select   = 0;
            global.pc_screen_feedback = "";
            if (variable_global_exists("case_vector_confirmed") && global.case_vector_confirmed) {
                global.pc_screen_mode  = 4;
                global.pc_screen_title = "CASE BOARD — STEP 3/3: PRESCRIBE SAFETY FIX";
            } else if (variable_global_exists("case_culprit_confirmed") && global.case_culprit_confirmed) {
                global.pc_screen_mode  = 2;
                global.pc_screen_title = "CASE BOARD — STEP 2/3: IDENTIFY ATTACK VECTOR";
            } else {
                global.pc_screen_mode  = 1;
                global.pc_screen_title = "CASE BOARD — STEP 1/3: ACCUSE A SUSPECT";
            }
        }

        draw_set_color(make_color_rgb(110, 120, 130));
        draw_text(floor(_mcx), floor(_my2 - 8), "Wrong accusations: " + string(global.case_wrong_accusations) + "     [TAB / ESC] Close");

    } else if (_mode == 1 || _mode == 2 || _mode == 4) {
        // =====================================================
        // CASE BOARD 3-STEP ACCUSATION FLOW:
        //   Mode 1 (Step 1/3): Pick Suspect (Patient Zero)
        //   Mode 2 (Step 2/3): Pick Accidental Slip-Up / Attack Vector
        //   Mode 4 (Step 3/3): Prescribe Cybersecurity Safety Fix / Prevention Rule
        // =====================================================
        var _labels = [];
        var _desc   = "";
        var _bd_n2  = array_length(global.case_suspects);

        if (_mode == 1) {
            _desc = "STEP 1/3 — WHOSE ACCIDENTAL SLIP-UP LET THE HACKERS IN? Select Patient Zero based on your Case Board evidence (" + string(global.evidence_found) + "/" + string(global.evidence_needed) + " clues):";
            for (var _s_i = 0; _s_i < _bd_n2; _s_i++) {
                var _s_obj = global.case_suspects[_s_i];
                var _w_tag = (variable_struct_exists(_s_obj, "accused_wrong") && _s_obj.accused_wrong) ? "  [RULED OUT]" : "";
                array_push(_labels, "SELECT: " + _s_obj.name + "  (" + _s_obj.dept + " - Desk " + _s_obj.nameplate + ")" + _w_tag);
            }
            array_push(_labels, "< Back to Case Board");
        } else if (_mode == 2) {
            var _cul_obj = global.case_suspects[global.case_culprit_idx];
            _desc = "STEP 2/3 — PATIENT ZERO IDENTIFIED: " + _cul_obj.name + " (Desk " + _cul_obj.nameplate + ")!\nNow select WHICH accidental slip-up / hazard caused the breach:";
            for (var _v_i = 0; _v_i < array_length(global.case_vectors); _v_i++) {
                array_push(_labels, global.case_vectors[_v_i]);
            }
            array_push(_labels, "< Back to Case Board");
        } else {
            var _cul_obj2 = global.case_suspects[global.case_culprit_idx];
            var _vec_str  = global.case_vectors[global.case_vector_correct];
            _desc = "STEP 3/3 — BREACH CONFIRMED: " + _cul_obj2.name + " -> " + _vec_str + "!\nNow select WHICH cybersecurity safety habit prevents this breach from happening again:";
            var _fix_arr = variable_global_exists("case_fixes") ? global.case_fixes : [_case.prevention_rule];
            for (var _f_i = 0; _f_i < array_length(_fix_arr); _f_i++) {
                array_push(_labels, _fix_arr[_f_i]);
            }
            array_push(_labels, "< Back to Case Board");
        }
        var _num_items = array_length(_labels);
        var _drawer_open = (_mode == 4 && variable_global_exists("policy_drawer_open") && global.policy_drawer_open);

        if (!_drawer_open) {
            if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
                global.pc_screen_select = max(0, global.pc_screen_select - 1);
                audio_play_sound(select1, 6, false);
            }
            if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
                global.pc_screen_select = min(_num_items - 1, global.pc_screen_select + 1);
                audio_play_sound(select1, 6, false);
            }
        }
        global.pc_screen_select = clamp(global.pc_screen_select, 0, _num_items - 1);

        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(40, 45, 55));
        draw_text_ext(floor(_mcx), floor(_my1 + 44), _desc, 14, _mw - 30);
        draw_text_ext(floor(_mcx + 1), floor(_my1 + 44), _desc, 14, _mw - 30);

        var _clicked_item = false;
        draw_set_halign(fa_left);
        var _item_scale = (_mode == 4) ? 0.72 : 0.90;
        var _row_step_cb = (_mode == 4) ? 23 : 25;
        var _row_top_cb  = (_mode == 4) ? (_my1 + 72) : (_my1 + 76);
        for (var _ii = 0; _ii < _num_items; _ii++) {
            var _iy = _row_top_cb + (_ii * _row_step_cb);
            var _is_sel = (global.pc_screen_select == _ii);

            var _gmx2 = device_mouse_x_to_gui(0);
            var _gmy2 = device_mouse_y_to_gui(0);
            var _hover_item = !_drawer_open && point_in_rectangle(_gmx2, _gmy2, _mx1 + 14, _iy - 10, _mx2 - 14, _iy + 10);
            if (_hover_item && mouse_check_button_pressed(mb_left)) {
                global.pc_screen_select = _ii;
                _is_sel = true;
                _clicked_item = true;
            }

            draw_set_color(_is_sel ? make_color_rgb(230, 242, 252) : make_color_rgb(248, 249, 250));
            draw_rectangle(_mx1 + 14, _iy - 10, _mx2 - 14, _iy + 10, false);
            draw_set_color(_is_sel ? make_color_rgb(40, 120, 190) : _col_grey_line); // #e2d386
            draw_rectangle(_mx1 + 14, _iy - 10, _mx2 - 14, _iy + 10, true);
            draw_set_color(_is_sel ? make_color_rgb(10, 40, 80) : make_color_rgb(50, 60, 70));
            if (_mode == 4) {
                draw_text_ext_transformed(_mx1 + 20, _iy + 1, (_is_sel ? "> " : "  ") + _labels[_ii], 12, (_mw - 48) / _item_scale, _item_scale, _item_scale, 0);
            } else {
                draw_text_ext(floor(_mx1 + 20), floor(_iy + 1), (_is_sel ? "> " : "  ") + _labels[_ii], 13, _mw - 48);
                if (_is_sel) draw_text_ext(floor(_mx1 + 21), floor(_iy + 1), (_is_sel ? "> " : "  ") + _labels[_ii], 13, _mw - 48);
            }
        }

        // Step 3 Required [+ ATTACH CODEX POLICY] Slot
        if (_mode == 4) {
            var _pol_y1 = _my1 + 165;
            var _pol_y2 = _my1 + 187;
            var _gmx_p  = device_mouse_x_to_gui(0);
            var _gmy_p  = device_mouse_y_to_gui(0);
            var _hov_p  = !_drawer_open && point_in_rectangle(_gmx_p, _gmy_p, _mx1 + 14, _pol_y1, _mx2 - 14, _pol_y2);
            var _cited  = variable_global_exists("case_cited_term") ? global.case_cited_term : undefined;
            var _has_c  = is_struct(_cited);

            draw_set_color(_has_c ? make_color_rgb(222, 248, 232) : (_hov_p ? make_color_rgb(230, 242, 255) : make_color_rgb(255, 246, 224)));
            draw_rectangle(_mx1 + 14, _pol_y1, _mx2 - 14, _pol_y2, false);
            draw_set_color(_has_c ? make_color_rgb(25, 145, 70) : (_hov_p ? make_color_rgb(35, 115, 195) : make_color_rgb(200, 140, 25)));
            draw_rectangle(_mx1 + 14, _pol_y1, _mx2 - 14, _pol_y2, true);

            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            draw_set_color(_has_c ? make_color_rgb(15, 95, 45) : make_color_rgb(135, 75, 10));
            var _pol_lbl = _has_c
                ? ("[CITED CODEX POLICY ✓]  " + _cited.term + "  (" + _cited.branch_name + ")   —   [P / Click] Change")
                : "[+ ATTACH CODEX POLICY]  (Required)  —  [P / Click] Cite Matching Codex Concept";
            draw_text_transformed(_mx1 + 22, (_pol_y1 + _pol_y2) * 0.5, _pol_lbl, 0.68, 0.68, 0);

            if (!_drawer_open && ((_hov_p && mouse_check_button_pressed(mb_left)) || keyboard_check_pressed(ord("P")))) {
                global.policy_drawer_open   = true;
                global.policy_drawer_sel    = 0;
                global.policy_drawer_scroll = 0;
                global.pc_input_cooldown    = 8;
                audio_play_sound(snd_button_click, 6, false);
            }
        }

        var _trigger_flag = !_drawer_open && _can_input && (_clicked_item || keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space));
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
                    global.pc_screen_title        = "CASE BOARD — STEP 2/3: IDENTIFY ATTACK VECTOR";
                    global.pc_screen_feedback     = "CORRECT! " + _acc_sus.name + "'s workstation was Patient Zero. Now select the attack vector!";
                    global.pc_screen_feedback_col = make_color_rgb(20, 140, 40);
                } else {
                    audio_play_sound(wrong1, 10, false);
                    global.case_wrong_accusations++;
                    global.scrap_count = max(0, global.scrap_count - 2);
                    _acc_sus.accused_wrong = true;
                    scr_case_recompute();
                    global.pc_screen_feedback = scr_apply_wrongful_audit_penalty(
                        _acc_sus,
                        "Falsely accused " + _acc_sus.name + " who had a verified alibi! (-2 SCRAP)"
                    );
                    global.pc_screen_feedback_col = make_color_rgb(210, 50, 45);
                }
            } else if (_mode == 2) {
                if (global.pc_screen_select == global.case_vector_correct) {
                    audio_play_sound(snd_correct_ping, 10, false);
                    global.case_vector_confirmed  = true;
                    global.pc_screen_mode         = 4;
                    global.pc_screen_select       = 0;
                    global.pc_screen_title        = "CASE BOARD — STEP 3/3: PRESCRIBE SAFETY FIX";
                    global.pc_screen_feedback     = "SLIP-UP CONFIRMED! Final step: choose the safety rule that prevents this breach!";
                    global.pc_screen_feedback_col = make_color_rgb(20, 140, 40);
                } else {
                    global.case_step2_first_try = false;
                    audio_play_sound(wrong1, 8, false);
                    global.case_wrong_accusations++;
                    global.pc_screen_feedback     = "INCORRECT VECTOR! Check the [LVL 3: CRITICAL] forensic trace from the culprit's desk.";
                    global.pc_screen_feedback_col = make_color_rgb(210, 50, 45);
                }
            } else if (_mode == 4) {
                var _corr_fix = variable_global_exists("case_fix_correct") ? global.case_fix_correct : 0;
                var _cidx_now = variable_global_exists("floor_case_index") ? global.floor_case_index : 0;
                var _cited_t  = variable_global_exists("case_cited_term")  ? global.case_cited_term  : undefined;
                var _cite_chk = scr_validate_case_policy_citation(_cited_t, _cidx_now);

                if (!_cite_chk.ok) {
                    audio_play_sound(wrong1, 8, false);
                    global.pc_screen_feedback     = _cite_chk.msg;
                    global.pc_screen_feedback_col = make_color_rgb(200, 100, 15);
                } else if (global.pc_screen_select == _corr_fix) {
                    if (!variable_global_exists("floor_stat_board_logged") || !global.floor_stat_board_logged) {
                        global.floor_stat_board_logged = true;
                        var _s2_ok = (!variable_global_exists("case_step2_first_try") || global.case_step2_first_try);
                        var _s3_ok = (!variable_global_exists("case_step3_first_try") || global.case_step3_first_try);
                        var _b_key = variable_global_exists("floor_branch_key") ? global.floor_branch_key : "social_eng";
                        scr_record_cyber_stat(_b_key, (_s2_ok && _s3_ok));
                    }
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
                    global.pc_screen_feedback     = "CASE SOLVED & SAFETY FIX LOGGED! +3 SCRAP. " + _case.kyle_debrief;
                    global.pc_screen_feedback_col = make_color_rgb(20, 140, 40);
                    global.pc_screen_badge        = "OVERRIDE AUTHORIZED";
                } else {
                    global.case_step3_first_try = false;
                    audio_play_sound(wrong1, 8, false);
                    global.pc_screen_feedback     = "UNSAFE PRACTICE! That wouldn't prevent this breach—choose the habit that directly fixes the slip-up!";
                    global.pc_screen_feedback_col = make_color_rgb(210, 50, 45);
                }
            }
        }

        // Persistent [KYLE] Contextual Briefing Pill (always visible above footer)
        var _kyle_tip = "KYLE: Match your Case Board clues & Level 3 Desk Proof to pick Patient Zero!";
        if (_mode == 2) _kyle_tip = "KYLE: Right suspect! Now pick the slip-up they made, then prescribe the Fix + Codex Policy!";
        if (_mode == 4) _kyle_tip = "KYLE: Select the preventive habit AND click [+ ATTACH CODEX POLICY] [P] to cite the Codex rule!";

        draw_set_color(make_color_rgb(14, 34, 56));
        draw_rectangle(_mx1 + 14, _my2 - 74, _mx2 - 14, _my2 - 58, false);
        draw_set_color(c_aqua);
        draw_rectangle(_mx1 + 14, _my2 - 74, _mx2 - 14, _my2 - 58, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var _kt_sc = min(0.60, (_mw - 38) / max(1, string_width(_kyle_tip)));
        draw_set_color(make_color_rgb(165, 235, 255));
        draw_text_transformed(_mcx, _my2 - 66, _kyle_tip, _kt_sc, _kt_sc, 0);

        // Feedback / Educational debrief line
        var _default_fb = "Select a suspect to accuse, or return to the Case Board.";
        if (_mode == 2) _default_fb = "Select the accidental slip-up from the culprit's Level 3 Critical Forensics.";
        if (_mode == 4) _default_fb = "Select the safety habit and attach a matching Codex Policy.";
        var _fb_txt = (variable_global_exists("pc_screen_feedback") && global.pc_screen_feedback != "")
            ? global.pc_screen_feedback
            : _default_fb;
        var _fb_col = (variable_global_exists("pc_screen_feedback_col") && global.pc_screen_feedback != "") ? global.pc_screen_feedback_col : make_color_rgb(170, 115, 0);
        draw_set_color(_fb_col);
        draw_text_ext_transformed(_mcx, _my2 - 48, _fb_txt, 12, (_mw - 30) / 0.72, 0.72, 0.72, 0);

        // Action prompt pill
        draw_set_color(c_white);
        draw_rectangle(_mcx - 180, _my2 - 38, _mcx + 180, _my2 - 20, false);
        draw_set_color(_col_grey_line); // #bbbbbb
        draw_rectangle(_mcx - 180, _my2 - 38, _mcx + 180, _my2 - 20, true);
        draw_set_color(make_color_rgb(30, 40, 50));
        draw_text(floor(_mcx), floor(_my2 - 29), (_mode == 4) ? "[W/S] Select Fix   [P / Click] Attach Policy   [E / ENTER] Submit" : "[W/S or CLICK] Select   [E / ENTER] Confirm");
        draw_text(floor(_mcx + 1), floor(_my2 - 29), (_mode == 4) ? "[W/S] Select Fix   [P / Click] Attach Policy   [E / ENTER] Submit" : "[W/S or CLICK] Select   [E / ENTER] Confirm");

        // Compact Policy Citation Drawer Overlay (Step 3)
        if (_mode == 4 && _drawer_open) {
            var _p_terms = scr_get_policy_drawer_terms();
            var _pt_cnt  = array_length(_p_terms);
            var _vis_max = 6;
            global.policy_drawer_sel = clamp(global.policy_drawer_sel, 0, max(0, _pt_cnt - 1));

            if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")) || mouse_wheel_up()) {
                global.policy_drawer_sel = max(0, global.policy_drawer_sel - 1);
                audio_play_sound(select1, 6, false);
            }
            if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S")) || mouse_wheel_down()) {
                global.policy_drawer_sel = min(max(0, _pt_cnt - 1), global.policy_drawer_sel + 1);
                audio_play_sound(select1, 6, false);
            }
            if (global.policy_drawer_sel < global.policy_drawer_scroll) global.policy_drawer_scroll = global.policy_drawer_sel;
            if (global.policy_drawer_sel >= global.policy_drawer_scroll + _vis_max) global.policy_drawer_scroll = global.policy_drawer_sel - _vis_max + 1;

            var _dw  = min(440, _mw - 40);
            var _dh  = 196;
            var _dx1 = _mcx - _dw * 0.5;
            var _dy1 = _mcy - _dh * 0.5;
            var _dx2 = _dx1 + _dw;
            var _dy2 = _dy1 + _dh;

            draw_set_alpha(0.65);
            draw_set_color(c_black);
            draw_rectangle(_mx1, _my1, _mx2, _my2, false);
            draw_set_alpha(1.0);

            draw_set_color(make_color_rgb(12, 22, 38));
            draw_rectangle(_dx1, _dy1, _dx2, _dy2, false);
            draw_set_color(make_color_rgb(80, 215, 255));
            draw_rectangle(_dx1, _dy1, _dx2, _dy2, true);

            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(make_color_rgb(130, 225, 255));
            draw_text_transformed(_mcx, _dy1 + 14, "ATTACH CODEX POLICY CITATION (" + string(_pt_cnt) + " AVAILABLE)", 0.72, 0.72, 0);

            var _d_clicked = false;
            var _gmx_d = device_mouse_x_to_gui(0);
            var _gmy_d = device_mouse_y_to_gui(0);
            for (var _di = 0; _di < min(_vis_max, _pt_cnt - global.policy_drawer_scroll); _di++) {
                var _idx  = global.policy_drawer_scroll + _di;
                var _dt   = _p_terms[_idx];
                var _ry1  = _dy1 + 28 + _di * 24;
                var _ry2  = _ry1 + 21;
                var _dsel = (_idx == global.policy_drawer_sel);
                var _dhov = point_in_rectangle(_gmx_d, _gmy_d, _dx1 + 10, _ry1, _dx2 - 10, _ry2);
                if (_dhov && mouse_check_button_pressed(mb_left)) {
                    global.policy_drawer_sel = _idx;
                    _dsel      = true;
                    _d_clicked = true;
                }

                draw_set_color(_dsel ? make_color_rgb(24, 68, 102) : (_dhov ? make_color_rgb(18, 42, 68) : make_color_rgb(16, 28, 46)));
                draw_rectangle(_dx1 + 10, _ry1, _dx2 - 10, _ry2, false);
                draw_set_color(_dsel ? c_aqua : make_color_rgb(55, 110, 150));
                draw_rectangle(_dx1 + 10, _ry1, _dx2 - 10, _ry2, true);

                var _is_sc = scr_is_term_scanned_on_floor(_dt.id);
                var _src_tag = _is_sc ? "[SCANNED ★]" : (variable_struct_exists(global.codex_unlocked_terms, _dt.id) ? "[ARCHIVED ✓]" : "[CODEX]");
                draw_set_halign(fa_left);
                draw_set_color(_dsel ? c_white : make_color_rgb(195, 225, 245));
                draw_text_transformed(_dx1 + 16, (_ry1 + _ry2) * 0.5, _dt.term + "  [" + _dt.branch_name + "]", 0.58, 0.58, 0);
                draw_set_halign(fa_right);
                draw_set_color(_is_sc ? make_color_rgb(255, 215, 75) : make_color_rgb(120, 230, 165));
                draw_text_transformed(_dx2 - 16, (_ry1 + _ry2) * 0.5, _src_tag, 0.52, 0.52, 0);
            }

            draw_set_halign(fa_center);
            draw_set_color(make_color_rgb(155, 200, 235));
            draw_text_transformed(_mcx, _dy2 - 12, "[W/S / Wheel] Browse   |   [E / ENTER / Click] Attach   |   [P / ESC] Cancel", 0.54, 0.54, 0);

            if (_can_input && (_d_clicked || keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))) {
                if (_pt_cnt > 0) {
                    global.case_cited_term    = _p_terms[global.policy_drawer_sel];
                    global.policy_drawer_open = false;
                    global.pc_input_cooldown  = 10;
                    keyboard_clear(ord("E"));
                    keyboard_clear(vk_enter);
                    keyboard_clear(vk_space);
                    audio_play_sound(snd_correct_ping, 8, false);
                }
            } else if (_can_input && (keyboard_check_pressed(ord("P")) || keyboard_check_pressed(vk_escape))) {
                if (keyboard_check_pressed(vk_escape)) {
                    global.esc_block_frames = 2;
                    keyboard_clear(vk_escape);
                }
                global.policy_drawer_open = false;
                global.pc_input_cooldown  = 10;
                audio_play_sound(snd_button_click, 6, false);
            }
        }

    } else if (_mode == 5) {
        // =====================================================
        // INTERACTIVE 3-ITEM SUSPECT WORKSTATION AUDIT (Mode 5)
        // Player inspects the 3 desktop items on this coworker's PC and either:
        //   - Flags the 1 risky cybersecurity slip-up (if Patient Zero's desk)
        //   - Verifies the workstation is CLEAN (if an innocent coworker's desk)
        // =====================================================
        var _s_idx = (variable_global_exists("pc_screen_suspect_idx") && global.pc_screen_suspect_idx >= 0)
            ? global.pc_screen_suspect_idx : 0;
        var _sp_obj = global.case_suspects[_s_idx];
        var _a_items = variable_struct_exists(_sp_obj, "audit_items") ? _sp_obj.audit_items : [];

        var _audit_labels = [];
        for (var _ai = 0; _ai < array_length(_a_items); _ai++) {
            array_push(_audit_labels, "[ITEM " + string(_ai + 1) + "]  " + _a_items[_ai].label);
        }
        array_push(_audit_labels, "[VERIFY CLEAN]  All 3 items follow safe cybersecurity habits (Log Alibi)");
        var _n_audit = array_length(_audit_labels);

        if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
            global.pc_screen_select = (global.pc_screen_select + _n_audit - 1) mod _n_audit;
            audio_play_sound(select1, 6, false);
        }
        if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
            global.pc_screen_select = (global.pc_screen_select + 1) mod _n_audit;
            audio_play_sound(select1, 6, false);
        }
        global.pc_screen_select = clamp(global.pc_screen_select, 0, _n_audit - 1);

        var _shortcut_trigger = false;
        if (_can_input) {
            if (keyboard_check_pressed(ord("1")) && _n_audit >= 1) { global.pc_screen_select = 0; _shortcut_trigger = true; }
            if (keyboard_check_pressed(ord("2")) && _n_audit >= 2) { global.pc_screen_select = 1; _shortcut_trigger = true; }
            if (keyboard_check_pressed(ord("3")) && _n_audit >= 3) { global.pc_screen_select = 2; _shortcut_trigger = true; }
            if (keyboard_check_pressed(ord("4")) && _n_audit >= 4) { global.pc_screen_select = 3; _shortcut_trigger = true; }
        }

        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(35, 45, 60));
        var _audit_hdr = "AUDIT " + string_upper(_sp_obj.name) + "'S COMPUTER: Inspect the 3 desktop items below.\nFlag the risky cybersecurity slip-up [1-3], or select [4] if all 3 items are safe!";
        draw_text_ext_transformed(_mcx, _my1 + 42, _audit_hdr, 14, (_mw - 32) / 0.78, 0.78, 0.78, 0);
        draw_text_ext_transformed(_mcx + 0.7, _my1 + 42, _audit_hdr, 14, (_mw - 32) / 0.78, 0.78, 0.78, 0);

        var _audit_clicked = false;
        draw_set_halign(fa_left);
        for (var _aj = 0; _aj < _n_audit; _aj++) {
            var _ay     = _my1 + 74 + (_aj * 28);
            var _asel   = (global.pc_screen_select == _aj);
            var _is_vfy = (_aj == _n_audit - 1);

            var _gmx_a = device_mouse_x_to_gui(0);
            var _gmy_a = device_mouse_y_to_gui(0);
            var _ahov  = point_in_rectangle(_gmx_a, _gmy_a, _mx1 + 14, _ay - 12, _mx2 - 14, _ay + 12);
            if (_ahov && mouse_check_button_pressed(mb_left)) {
                global.pc_screen_select = _aj;
                _asel          = true;
                _audit_clicked = true;
            }

            var _abg = _asel
                ? (_is_vfy ? make_color_rgb(220, 248, 228) : make_color_rgb(228, 240, 252))
                : make_color_rgb(246, 248, 250);
            var _abd = _asel
                ? (_is_vfy ? make_color_rgb(25, 145, 55) : make_color_rgb(35, 115, 185))
                : _col_grey_line;
            var _atx = _asel
                ? (_is_vfy ? make_color_rgb(10, 85, 30) : make_color_rgb(10, 40, 80))
                : make_color_rgb(45, 55, 65);

            draw_set_color(_abg);
            draw_rectangle(_mx1 + 14, _ay - 12, _mx2 - 14, _ay + 12, false);
            draw_set_color(_abd);
            draw_rectangle(_mx1 + 14, _ay - 12, _mx2 - 14, _ay + 12, true);
            draw_set_color(_atx);
            draw_text_ext_transformed(_mx1 + 20, _ay, (_asel ? "> " : "  ") + _audit_labels[_aj], 12, (_mw - 48) / 0.72, 0.72, 0.72, 0);
            draw_text_ext_transformed(_mx1 + 20.7, _ay, (_asel ? "> " : "  ") + _audit_labels[_aj], 12, (_mw - 48) / 0.72, 0.72, 0.72, 0);
        }

        // Handle audit selection confirmation
        if (_can_input && (_audit_clicked || _shortcut_trigger || keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space))) {
            global.pc_input_cooldown = 12;
            var _pick = global.pc_screen_select;
            var _t_prop = variable_global_exists("pc_screen_target") ? global.pc_screen_target : noone;

            if (_pick < array_length(_a_items)) {
                var _p_item   = _a_items[_pick];
                var _is_risky = variable_struct_exists(_p_item, "is_risky") ? _p_item.is_risky : _p_item.is_breach;
                var _fb_str   = variable_struct_exists(_p_item, "audit_feedback") ? _p_item.audit_feedback : _p_item.desc;

                if (_is_risky) {
                    // Player correctly spotted the risky slip-up on the Culprit's desktop!
                    _sp_obj.audit_done = true;
                    var _ev_logged = false;
                    if (instance_exists(_t_prop)) {
                        _t_prop.talked_once = true;
                        if (_t_prop.evidence_idx >= 0) _ev_logged = scr_log_evidence(_t_prop.evidence_idx);
                    }
                    audio_play_sound(snd_correct_ping, 10, false);
                    global.pc_screen_mode  = 0;
                    global.pc_screen_title = "BREACH EVIDENCE FLAGGED: DESK " + _sp_obj.nameplate;
                    global.pc_screen_body  = "[LVL 3: CRITICAL PROOF LOGGED!]\n" + _p_item.label + "\n\n" + _p_item.desc + "\n\nPress [TAB] to open the Case Board and ACCUSE a suspect!";
                    global.pc_screen_radar = "EVIDENCE " + string(global.evidence_found) + "/" + string(global.evidence_needed) + "   [TAB] ACCUSE ON BOARD";
                    global.pc_screen_badge = "LVL 3: CRITICAL";
                } else {
                    // Player flagged a safe item or Benign Red Herring!
                    audio_play_sound(wrong1, 8, false);
                    if (_sp_obj.is_culprit) {
                        global.pc_screen_feedback     = _fb_str;
                        global.pc_screen_feedback_col = make_color_rgb(185, 85, 15);
                    } else {
                        global.pc_screen_feedback = scr_apply_wrongful_audit_penalty(
                            _sp_obj,
                            _fb_str + " If all 3 items are safe, select [VERIFY CLEAN]!"
                        );
                        global.pc_screen_feedback_col = make_color_rgb(205, 45, 45);
                    }
                }
            } else {
                // Player selected [4] VERIFY WORKSTATION CLEAN
                if (!_sp_obj.is_culprit) {
                    // Correct! All 3 items on this innocent coworker's desktop follow safe habits
                    _sp_obj.audit_done = true;
                    if (instance_exists(_t_prop)) {
                        _t_prop.talked_once = true;
                        if (_t_prop.evidence_idx >= 0) scr_log_evidence(_t_prop.evidence_idx);
                    }
                    audio_play_sound(snd_correct_ping, 10, false);
                    global.pc_screen_mode  = 0;
                    global.pc_screen_title = "WORKSTATION CLEAN: DESK " + _sp_obj.nameplate;
                    global.pc_screen_body  = "[LVL 3: CRITICAL ALIBI LOGGED!]\n" + _sp_obj.name + " followed every cybersecurity safety rule (including properly handled security alerts/controls).\n\n->" + _sp_obj.name + " is CLEARED on your [TAB] Case Board!";
                    global.pc_screen_radar = "EVIDENCE " + string(global.evidence_found) + "/" + string(global.evidence_needed) + "   [TAB] CASE BOARD";
                    global.pc_screen_badge = "CLEARED (LVL 3)";
                } else {
                    // Wrong! This is the culprit's desk—one of the 3 items above is a breach!
                    audio_play_sound(wrong1, 8, false);
                    global.pc_screen_feedback = scr_apply_wrongful_audit_penalty(
                        _sp_obj,
                        "Audit Rejected — You marked a compromised workstation as clean! One of Items 1–3 is an active breach!"
                    );
                    global.pc_screen_feedback_col = make_color_rgb(205, 45, 45);
                }
            }
        }

        // Persistent [KYLE] Contextual Briefing Pill in Mode 5 (Workstation Audit)
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(14, 34, 56));
        draw_rectangle(_mx1 + 14, _my2 - 76, _mx2 - 14, _my2 - 62, false);
        draw_set_color(_is_white ? c_black : c_aqua);
        draw_rectangle(_mx1 + 14, _my2 - 76, _mx2 - 14, _my2 - 62, true);
        draw_set_color(make_color_rgb(165, 235, 255));
        draw_text_transformed(_mcx, _my2 - 69, "KYLE: Audit all 3 items—flag the 1 risky slip-up, or choose [VERIFY CLEAN] if all 3 are safe!", 0.62, 0.62, 0);

        // Bottom Feedback / Inspection Note (black text, moved up above the line)
        var _audit_fb = (variable_global_exists("pc_screen_feedback") && global.pc_screen_feedback != "")
            ? global.pc_screen_feedback
            : "Use [W/S], [1-4], or Click to inspect.";
        var _audit_fcol = (variable_global_exists("pc_screen_feedback_col") && global.pc_screen_feedback != "")
            ? global.pc_screen_feedback_col
            : c_black;
        draw_set_color(_audit_fcol);
        draw_text(floor(_mcx), floor(_my2 - 54), _audit_fb);

    } else {
        // Centered Main Clue Box
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(_is_white ? c_black : c_white);
        var _clue_y = _has_overlay_sprite ? ((_my1 + 24 + _my2 - 54) * 0.5) : (_my1 + 92);
        draw_text_ext_transformed(_mcx, _clue_y, global.pc_screen_body, 18, (_mw - 48) / 0.82, 0.82, 0.82, 0);

        // Compact Radar Pill at bottom of monitor (above the line)
        var _rx1 = _mcx - 135;
        var _ry1 = _my2 - 66;
        var _rx2 = _mcx + 135;
        var _ry2 = _my2 - 46;

        if (_is_white) {
            if (!sprite_exists(spr_dungeon_terminal_popup)) {
                draw_set_color(c_white);
                draw_rectangle(_rx1, _ry1, _rx2, _ry2, false);
                draw_set_color(c_black);
                // 3x thicker box border around radar text
                for (var _th = 0; _th < 3; _th++) {
                    draw_rectangle(_rx1 + _th, _ry1 + _th, _rx2 - _th, _ry2 - _th, true);
                }
            }
            draw_set_color(c_black);
            draw_text(floor(_mcx), floor(_my2 - 56), global.pc_screen_radar);
        } else {
            draw_set_color(make_color_rgb(14, 30, 44));
            draw_rectangle(_rx1, _ry1, _rx2, _ry2, false);
            draw_set_color(c_black);
            draw_rectangle(_rx1, _ry1, _rx2, _ry2, true);
            draw_set_color(c_black);
            draw_text(floor(_mcx), floor(_my2 - 56), global.pc_screen_radar);
        }
    }

    // Minimal close prompt (mode 3 draws its own combined footer)
    if (_mode != 3) {
        draw_set_color(c_black);
        draw_text(floor(_mcx), floor(_my2 - 24), "[ESC] Close");
    }

    // Custom UI Sprite Overlay (spr_dungeon_caseboard_ui / spr_dungeon_terminal_ui) layered over the UI
    if (_has_overlay_sprite) {
        var _spr_w = sprite_get_width(_overlay_sprite);
        var _spr_h = sprite_get_height(_overlay_sprite);
        draw_sprite_ext(_overlay_sprite, 0, 0, 0, _gui_w / _spr_w, _gui_h / _spr_h, 0, c_white, 1.0);
    }

    // Clickable Cyber Terms Bar below Monitor / Case Board + Quick-Definition Popup
    var _pc_scan = [global.pc_screen_title, global.pc_screen_body, global.pc_screen_feedback];
    if (_mode == 5 && variable_global_exists("pc_audit_suspect_idx") && global.pc_audit_suspect_idx >= 0 && global.pc_audit_suspect_idx < array_length(global.case_suspects)) {
        var _sa = global.case_suspects[global.pc_audit_suspect_idx];
        if (variable_struct_exists(_sa, "audit_items")) {
            for (var _ai = 0; _ai < array_length(_sa.audit_items); _ai++) {
                array_push(_pc_scan, _sa.audit_items[_ai].label + " " + _sa.audit_items[_ai].desc);
            }
        }
    } else if (_mode == 2 && variable_global_exists("case_vectors")) {
        for (var _vi = 0; _vi < array_length(global.case_vectors); _vi++) array_push(_pc_scan, global.case_vectors[_vi]);
    } else if (_mode == 4 && variable_global_exists("case_fixes")) {
        for (var _fi = 0; _fi < array_length(global.case_fixes); _fi++) array_push(_pc_scan, global.case_fixes[_fi]);
    } else if (_mode == 3 && variable_global_exists("case_evidence")) {
        for (var _ei = 0; _ei < array_length(global.case_evidence); _ei++) {
            if (global.case_evidence[_ei].found) array_push(_pc_scan, global.case_evidence[_ei].text);
        }
    }
    var _pc_terms = scr_scan_clickable_terms(_pc_scan, 5);
    if (array_length(_pc_terms) > 0) {
        var _bar_y = min(_my2 - 4, _gui_h - 48);
        scr_draw_clickable_term_bar(_mx1 + 12, _bar_y, _mw - 24, _pc_terms, "CLICK TERM TO DEFINE & ARCHIVE TO CODEX:", c_black);
    }
    var _popup_blocking = (variable_global_exists("active_term_popup") && global.active_term_popup != undefined)
                       || (variable_global_exists("term_popup_block_frames") && global.term_popup_block_frames > 0);
    scr_draw_term_quick_popup();

    if (!_popup_blocking && (keyboard_check_pressed(ord("X"))
        || keyboard_check_pressed(vk_escape)
        || (global.pc_screen_mode == 3 && keyboard_check_pressed(vk_tab))
        || (_hover_x && mouse_check_button_pressed(mb_left))))
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

// Track & queue Milestone Completion Toast Banners (never drops overlapping milestones!)
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
    quest_toast_queue = [];
}
if (!ms_hint_done && _clues_cur >= 1 && !_has_key) {
    ms_hint_done = true;
    array_push(quest_toast_queue, {
        title: "FORENSIC SCANNER UPLOADED!",
        sub:   "Next Quest: Spot the Red Flag at the Gold Key Vault & grab the Cipher Key!",
        col:   make_color_rgb(255, 215, 65),
        dur:   180
    });
}
if (!ms_key_done && _has_key) {
    ms_key_done = true;
    array_push(quest_toast_queue, {
        title: "CIPHER KEY ACQUIRED — TERMINALS UNLOCKED!",
        sub:   "Next Quest: Inspect Suspect Desks & Coworkers to solve the breach!",
        col:   c_aqua,
        dur:   190
    });
}
if (!ms_ready_acc_done && _has_key && _ready_acc && !_pz_solved) {
    ms_ready_acc_done = true;
    array_push(quest_toast_queue, {
        title: "CRITICAL PROOF FOUND — READY TO ACCUSE!",
        sub:   "Press [TAB] to accuse a suspect now, or keep searching for all clues!",
        col:   make_color_rgb(135, 255, 165),
        dur:   180
    });
}
if (!ms_all_ev_done && _has_key && _all_ev && !_pz_solved) {
    ms_all_ev_done = true;
    array_push(quest_toast_queue, {
        title: "ALL EVIDENCE ACQUIRED (" + string(_ev_cur) + "/" + string(_ev_req) + ")!",
        sub:   "Open [TAB] Case Board to accuse Patient Zero & resolve the case!",
        col:   c_lime,
        dur:   200
    });
}
if (!ms_case_done && _pz_solved) {
    ms_case_done = true;
    array_push(quest_toast_queue, {
        title: "CASE SOLVED — LOCKDOWN OVERRIDE UNLOCKED!",
        sub:   "Next Quest: Head to the Security Control Room & hit the Override Console!",
        col:   c_lime,
        dur:   200
    });
}
if (!ms_ov_done && _ov_done) {
    ms_ov_done = true;
    array_push(quest_toast_queue, {
        title: "LOCKDOWN OVERRIDDEN — BREAKER ROOM OPEN!",
        sub:   "Next Quest: Fix the 3 fuses in the Electrical Breaker Room!",
        col:   make_color_rgb(255, 210, 60),
        dur:   190
    });
}
if (!ms_pwr_done && _pwr_done) {
    ms_pwr_done = true;
    array_push(quest_toast_queue, {
        title: "FLOOR POWER RESTORED — ELEVATOR UNLOCKED!",
        sub:   "Final Quest: Board the Extraction Elevator to complete the floor!",
        col:   c_lime,
        dur:   210
    });
}
if (quest_toast_timer <= 0 && array_length(quest_toast_queue) > 0) {
    var _next_q = quest_toast_queue[0];
    array_delete(quest_toast_queue, 0, 1);
    quest_toast_title = _next_q.title;
    quest_toast_sub   = _next_q.sub;
    quest_toast_col   = _next_q.col;
    quest_toast_timer = _next_q.dur;
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
    draw_text_transformed(_qcx, _qy1 + 13, "[+] " + quest_toast_title, 0.74, 0.74, 0);
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
    var _by2 = 62;
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
    draw_text_transformed(_bcx, _by1 + 30, _curr.objective_title, 0.78, 0.78, 0);
    if (variable_global_exists("floor_priority_tag") && global.floor_priority_tag != "") {
        draw_set_color(make_color_rgb(255, 215, 75));
        draw_text_transformed(_bcx, _by1 + 46, global.floor_priority_tag, 0.60, 0.60, 0);
    }
    draw_set_halign(fa_left);
    draw_set_alpha(1.0);
} else if (variable_global_exists("floor_priority_tag") && global.floor_priority_tag != "") {
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    var _p_colp = (variable_instance_exists(id, "hud_priority_collapsed") && hud_priority_collapsed);
    var _pt_txt = _p_colp ? "[+] PRIORITY" : ("[-] " + global.floor_priority_tag);
    var _pt_w   = string_width(_pt_txt) * 0.52 + 12;
    var _gmx_pt = device_mouse_x_to_gui(0);
    var _gmy_pt = device_mouse_y_to_gui(0);
    var _hov_pt = point_in_rectangle(_gmx_pt, _gmy_pt, 292, 8, 292 + _pt_w, 24);
    if (_hov_pt && mouse_check_button_pressed(mb_left)) {
        hud_priority_collapsed = !_p_colp;
        audio_play_sound(snd_button_click, 6, false);
    }
    draw_set_alpha(0.82);
    draw_set_color(_hov_pt ? make_color_rgb(24, 34, 54) : make_color_rgb(10, 16, 28));
    draw_rectangle(292, 8, 292 + _pt_w, 24, false);
    draw_set_alpha(0.92);
    draw_set_color(make_color_rgb(255, 205, 70));
    draw_rectangle(292, 8, 292 + _pt_w, 24, true);
    draw_text_transformed(298, 16, _pt_txt, 0.52, 0.52, 0);
    draw_set_alpha(1.0);
    draw_set_valign(fa_top);
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
// FLOOR BLUEPRINT RADAR (MINIMAP — Toggleable with [M]) + DIRECTIONAL GENTLE BOT PROXIMITY GLOW
// =========================================================
var _j_x = instance_exists(obj_jack) ? obj_jack.x : 0;
var _j_y = instance_exists(obj_jack) ? (obj_jack.y - 6) : 0;
var _ov_lifted = (variable_global_exists("lockdown_overridden") && global.lockdown_overridden);
var _jam_on    = (variable_global_exists("drone_jammed_timer") && global.drone_jammed_timer > 0);

// Gentle, photosensitivity-safe (~0.33 Hz) directional edge glow in the direction of nearby Security Bots
if (!_ov_lifted && !_jam_on && instance_exists(obj_jack)) {
    var _breathe = 0.88 + 0.12 * sin(current_time / 480.0);
    with (obj_dungeon_prop) {
        if (prop_type == TILE_PROP_DRONE && !is_scrapped) {
            var _bd = point_distance(_j_x, _j_y, x + 8, y + 8);
            if (_bd <= 210) {
                var _det     = variable_instance_exists(id, "detect_meter") ? detect_meter : 0.0;
                var _prox    = clamp(1.0 - (_bd / 210.0), 0.14, 1.0);
                var _base_a  = clamp((0.22 + _prox * 0.34 + _det * 0.16) * _breathe, 0, 0.68);
                var _dir     = point_direction(_j_x, _j_y, x + 8, y + 8);
                var _dx      = lengthdir_x(1, _dir);
                var _dy      = lengthdir_y(1, _dir);
                var _span_x  = _gui_w * 0.62;
                var _span_y  = _gui_h * 0.66;
                var _focal_x = clamp(_gui_w * (0.5 + _dx * 0.45), _span_x * 0.5, _gui_w - _span_x * 0.5);
                var _focal_y = clamp(_gui_h * (0.5 + _dy * 0.45), _span_y * 0.5, _gui_h - _span_y * 0.5);

                draw_set_color(make_color_rgb(245, 35, 45));
                for (var _band = 0; _band < 4; _band++) {
                    var _band_f = ((4 - _band) / 4.0) * 0.58;
                    var _d      = round(14 + _band * (12 + _prox * 14));

                    if (_dx > 0.15) {
                        var _w_r = _base_a * clamp(_dx, 0.35, 1.0);
                        draw_set_alpha(_w_r * _band_f);
                        draw_rectangle(_gui_w - _d, _focal_y - _span_y * 0.5, _gui_w, _focal_y + _span_y * 0.5, false);
                    } else if (_dx < -0.15) {
                        var _w_l = _base_a * clamp(-_dx, 0.35, 1.0);
                        draw_set_alpha(_w_l * _band_f);
                        draw_rectangle(0, _focal_y - _span_y * 0.5, _d, _focal_y + _span_y * 0.5, false);
                    }

                    if (_dy < -0.15) {
                        var _w_t = _base_a * clamp(-_dy, 0.35, 1.0);
                        draw_set_alpha(_w_t * _band_f);
                        draw_rectangle(_focal_x - _span_x * 0.5, 0, _focal_x + _span_x * 0.5, _d, false);
                    } else if (_dy > 0.15) {
                        var _w_b = _base_a * clamp(_dy, 0.35, 1.0);
                        draw_set_alpha(_w_b * _band_f);
                        draw_rectangle(_focal_x - _span_x * 0.5, _gui_h - _d, _focal_x + _span_x * 0.5, _gui_h, false);
                    }
                }
                draw_set_alpha(1.0);
            }
        }
    }
}

var _map_x     = 8;
var _map_y     = 106;
var _radar_on  = (variable_instance_exists(id, "radar_open") && radar_open);
var _next_hud_y = _map_y;

if (variable_instance_exists(id, "room_discovered")) {
    if (_radar_on) {
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
        draw_text_transformed(_map_x + 6, _map_y + 9, "BLUEPRINT RADAR [M]", 0.72, 0.72, 0);

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

    // 2b. Live Patrol Bot Blips + Facing Ticks on Blueprint Radar
    var _chunk_px_b = CHUNK_SIZE * TILE_SIZE;
    with (obj_dungeon_prop) {
        if (prop_type == TILE_PROP_DRONE && !is_scrapped) {
            var _bc = clamp(floor((x + 8) / _chunk_px_b), 0, LOGIC_GRID_W - 1);
            var _br = clamp(floor((y + 8) / _chunk_px_b), 0, LOGIC_GRID_H - 1);
            var _bpx = _grid_ox + _bc * _cell_step + _cell_sz * 0.5;
            var _bpy = _grid_oy + _br * _cell_step + _cell_sz * 0.5;
            var _bdir = point_direction(0, 0, patrol_vx, patrol_vy);

            var _bcol = _ov_lifted ? c_gray : (_jam_on ? c_aqua : make_color_rgb(255, 65, 75));
            var _bpulse = 0.65 + 0.35 * sin(current_time / 130);
            draw_set_alpha(_bpulse);
            draw_set_color(_bcol);
            draw_circle(_bpx, _bpy, 2.5, false);
            draw_line(_bpx, _bpy, _bpx + lengthdir_x(5, _bdir), _bpy + lengthdir_y(5, _bdir));
        }
    }
    draw_set_alpha(1.0);
    _next_hud_y = _map_y + _map_h + 6;
    } else {
        // Compact [M] RADAR Toggle Pill when Blueprint Radar is closed
        var _gmx_m = device_mouse_x_to_gui(0);
        var _gmy_m = device_mouse_y_to_gui(0);
        var _hov_m = point_in_rectangle(_gmx_m, _gmy_m, _map_x, _map_y, _map_x + 86, _map_y + 18);
        if (_hov_m && mouse_check_button_pressed(mb_left)) {
            radar_open = true;
            audio_play_sound(snd_button_click, 6, false);
        }
        draw_set_alpha(0.80);
        draw_set_color(_hov_m ? make_color_rgb(20, 42, 68) : make_color_rgb(8, 13, 22));
        draw_rectangle(_map_x, _map_y, _map_x + 86, _map_y + 18, false);
        draw_set_alpha(0.90);
        draw_set_color(make_color_rgb(65, 165, 215));
        draw_rectangle(_map_x, _map_y, _map_x + 86, _map_y + 18, true);
        draw_set_color(make_color_rgb(130, 220, 255));
        draw_text_transformed(_map_x + 6, _map_y + 9, "[M] RADAR", 0.62, 0.62, 0);
        _next_hud_y = _map_y + 24;
    }

    // 3. Collapsible Floor Salvage Tasks Card below Blueprint Radar / [M] Pill
    var _tk_colp = (variable_instance_exists(id, "hud_tasks_collapsed") && hud_tasks_collapsed);
    var _tk_y1   = _next_hud_y;
    var _tk_h    = _tk_colp ? 18 : 48;
    var _tk_y2   = _tk_y1 + _tk_h;
    var _tk_w    = 196;
    var _t1_done = (_hr_cur >= 4 && _hr_cur <= 6);
    var _t2_done = ((variable_global_exists("task_bots_scrapped") && global.task_bots_scrapped > 0)
                 || (variable_global_exists("task_servers_scrapped") && global.task_servers_scrapped > 0));

    var _gmx_tk = device_mouse_x_to_gui(0);
    var _gmy_tk = device_mouse_y_to_gui(0);
    var _hov_tk = point_in_rectangle(_gmx_tk, _gmy_tk, _map_x, _tk_y1, _map_x + _tk_w, _tk_y1 + 18);
    if (_hov_tk && mouse_check_button_pressed(mb_left)) {
        hud_tasks_collapsed = !_tk_colp;
        audio_play_sound(snd_button_click, 6, false);
    }

    draw_set_alpha(0.78);
    draw_set_color(make_color_rgb(8, 14, 22));
    draw_rectangle(_map_x, _tk_y1, _map_x + _tk_w, _tk_y2, false);
    draw_set_alpha(0.90);
    draw_set_color((_t1_done && _t2_done) ? c_lime : make_color_rgb(65, 130, 165));
    draw_rectangle(_map_x, _tk_y1, _map_x + _tk_w, _tk_y2, true);

    draw_set_color(make_color_rgb(255, 210, 65));
    draw_text_transformed(_map_x + 6, _tk_y1 + 9, (_tk_colp ? "[+] " : "[-] ") + "SALVAGE TASKS [V]", 0.64, 0.64, 0);

    if (!_tk_colp) {
        var _t1_label = (_t1_done ? "[x] " : "[ ] ") + "Corporate Recovery: Compliant (4-6 Pcs)";
        if (!_t1_done && _hr_cur > 6) {
            _t1_label = "[!] Over-Salvaged: " + string(_hr_cur) + " Pcs (Exceeded!)";
        }
        draw_set_color(_t1_done ? c_lime : (_hr_cur > 6 ? make_color_rgb(255, 100, 100) : make_color_rgb(190, 215, 235)));
        draw_text_transformed(_map_x + 6, _tk_y1 + 24, _t1_label, 0.64, 0.64, 0);

        draw_set_color(_t2_done ? c_lime : make_color_rgb(190, 215, 235));
        draw_text_transformed(_map_x + 6, _tk_y1 + 38, (_t2_done ? "[x] " : "[ ] ") + "Tactical Salvage: Scrap Bot or Server", 0.64, 0.64, 0);
    }
}
draw_set_alpha(1.0);

// Contextual bottom prompt when near a locked door or key pedestal
if (instance_exists(obj_jack)) {
    var _prompt = "";
    var _pcol   = c_white;

    with (obj_door_quiz_lock) {
        if (locked && point_distance(obj_jack.x, obj_jack.y - 8, draw_x + 8, draw_y + 8) < 28) {
            _prompt = "[E] Analyze Security Log & Spot the Red Flag (Unlock Key Vault)";
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
                } else if (is_elevator_door && !_pwr_done) {
                    _prompt = "[E] Elevator Offline — Restore Power at Breaker Room First!";
                    _pcol   = c_orange;
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

// Visual Mechanic Tutorial Overlay (queued after any active dialogue!)
if (variable_global_exists("visual_tut_kind") && global.visual_tut_kind != ""
    && !instance_exists(obj_textbox) && !instance_exists(obj_textevent)) {
    scr_draw_visual_mechanic_tutorial(global.visual_tut_kind, _gui_w, _gui_h);
}
