// --- obj_codex_manager Draw GUI ---

scr_init_cyber_glossary();
var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// ── 1. Homeroom HUD Button & Main Menu Demonstration Mode Button ──────────
if (!is_open) {
    if (room == rm_menu) {
        var _db_x1 = 18;
        var _db_y1 = 158;
        var _db_w  = 216;
        var _db_h  = 54;
        var _db_x2 = _db_x1 + _db_w;
        var _db_y2 = _db_y1 + _db_h;
        var _db_hov = (_mx >= _db_x1 && _mx <= _db_x2 && _my >= _db_y1 && _my <= _db_y2);
        var _db_on  = (variable_global_exists("demo_mode_active") && global.demo_mode_active);
        var _db_pls = 0.78 + 0.22 * sin(current_time / 240.0);

        draw_set_alpha(0.94);
        draw_set_color(_db_hov ? make_color_rgb(32, 64, 96) : make_color_rgb(12, 24, 42));
        draw_rectangle(_db_x1, _db_y1, _db_x2, _db_y2, false);
        draw_set_alpha(1.0);
        draw_set_color(_db_hov ? c_yellow : merge_color(make_color_rgb(255, 195, 45), c_aqua, 0.35 * _db_pls));
        draw_rectangle(_db_x1, _db_y1, _db_x2, _db_y2, true);
        draw_rectangle(_db_x1 + 2, _db_y1 + 2, _db_x2 - 2, _db_y2 - 2, true);

        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(_db_hov ? c_yellow : make_color_rgb(255, 225, 85));
        draw_text_transformed((_db_x1 + _db_x2) * 0.5, _db_y1 + 16, "[*] DEMONSTRATION MODE [D]", 0.72, 0.72, 0);
        draw_set_color(make_color_rgb(175, 230, 255));
        draw_text_transformed((_db_x1 + _db_x2) * 0.5, _db_y1 + 32, "7-Beat Live Presenter Guide & Unlocks", 0.54, 0.54, 0);
        draw_set_color(_db_on ? c_lime : make_color_rgb(145, 200, 230));
        draw_text_transformed((_db_x1 + _db_x2) * 0.5, _db_y1 + 45, _db_on ? "STATUS: ACTIVE (Click to Enter)" : "Click or Press [D] to Start Demo", 0.50, 0.50, 0);

        if (_db_hov && mouse_check_button_pressed(mb_left)) {
            scr_start_demonstration_mode();
            if (asset_get_type("snd_correct_ping") == asset_sound) audio_play_sound(snd_correct_ping, 10, false);
            room_goto(rm_cipher_select);
        }
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
    }

    if (room == rm_homeroom && !instance_exists(obj_textbox) && !instance_exists(obj_textevent)
     && !(variable_global_exists("is_paused") && global.is_paused)) {
        var _unlocked_n = scr_get_cyber_glossary_unlocked_count();
        var _total_n    = array_length(global.cyber_glossary);
        var _new_n      = variable_global_exists("codex_new_count") ? global.codex_new_count : 0;

        var _bx2 = _gw - 14;
        var _by1 = 12;
        var _bw  = 196;
        var _bh  = 28;
        var _bx1 = _bx2 - _bw;
        var _by2 = _by1 + _bh;
        var _hov = (_mx >= _bx1 && _mx <= _bx2 && _my >= _by1 && _my <= _by2);

        draw_set_alpha(0.90);
        draw_set_color(_hov ? make_color_rgb(24, 58, 92) : make_color_rgb(12, 24, 42));
        draw_rectangle(_bx1, _by1, _bx2, _by2, false);
        draw_set_alpha(1);
        draw_set_color(_hov ? c_yellow : make_color_rgb(80, 215, 255));
        draw_rectangle(_bx1, _by1, _bx2, _by2, true);

        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(_hov ? c_yellow : make_color_rgb(175, 235, 255));
        draw_text_transformed((_bx1 + _bx2) * 0.5, (_by1 + _by2) * 0.5, "[C] CYBER CODEX (" + string(_unlocked_n) + "/" + string(_total_n) + ")", 0.68, 0.68, 0);

        if (_new_n > 0) {
            var _nbx1 = _bx1 - 62;
            draw_set_color(make_color_rgb(70, 52, 10));
            draw_rectangle(_nbx1, _by1 + 3, _bx1 - 4, _by2 - 3, false);
            draw_set_color(make_color_rgb(255, 215, 65));
            draw_rectangle(_nbx1, _by1 + 3, _bx1 - 4, _by2 - 3, true);
            draw_text_transformed((_nbx1 + _bx1 - 4) * 0.5, (_by1 + _by2) * 0.5, "+" + string(_new_n) + " NEW!", 0.62, 0.62, 0);
        }

        if (_hov && mouse_check_button_pressed(mb_left)) {
            is_open        = true;
            global.codex_new_count = 0;
            content_scroll = 0;
            if (variable_global_exists("demo_mode_active") && global.demo_mode_active) {
                current_branch = 4; // CRYPTOGRAPHY
                sidebar_scroll = 0;
                var _b4_terms = get_branch_terms(4);
                for (var _b4i = 0; _b4i < array_length(_b4_terms); _b4i++) {
                    if (_b4_terms[_b4i].id == "symmetric_asymmetric") {
                        current_concept = _b4i;
                        break;
                    }
                }
            }
            if (instance_exists(obj_jack)) {
                obj_jack.isInCutscene = true;
                obj_jack.image_speed  = 0;
            }
            if (asset_get_type("snd_button_click") == asset_sound) audio_play_sound(snd_button_click, 6, false);
        }
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_white);
    }

    if (toast_timer > 0 && toast_msg != "") {
        var _ta = min(1, toast_timer / 25);
        draw_set_alpha(_ta * 0.90);
        draw_set_color(make_color_rgb(12, 22, 38));
        draw_rectangle(_gw * 0.5 - 245, 52, _gw * 0.5 + 245, 76, false);
        draw_set_alpha(_ta);
        draw_set_color(make_color_rgb(90, 210, 255));
        draw_rectangle(_gw * 0.5 - 245, 52, _gw * 0.5 + 245, 76, true);
        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text_transformed(_gw * 0.5, 64, toast_msg, 0.62, 0.62, 0);
        draw_set_alpha(1);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
    scr_draw_demo_teleprompter_hud(_gw, _gh);
    exit;
}

// ── 2. Full-Screen Homeroom Deep-Dive Codex Overlay ───────────────────────
draw_set_color(make_color_rgb(4, 8, 16));
draw_set_alpha(0.88);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

var _fx1 = max(24, _gw * 0.06);
var _fy1 = max(18, _gh * 0.06);
var _fx2 = _gw - _fx1;
var _fy2 = _gh - _fy1;
var _fw  = _fx2 - _fx1;

// Outer Window Frame
draw_set_color(make_color_rgb(10, 18, 30));
draw_rectangle(_fx1, _fy1, _fx2, _fy2, false);
draw_set_color(make_color_rgb(70, 200, 255));
draw_rectangle(_fx1, _fy1, _fx2, _fy2, true);

// Title Header
draw_set_font(fnt_dialogue);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(100, 225, 255));
draw_text_transformed(_fx1 + 14, _fy1 + 14, "HOMEROOM CYBERSECURITY CODEX  //  CATEGORIZED FIELD MANUAL", 0.74, 0.74, 0);

draw_set_halign(fa_right);
var _tot_u = scr_get_cyber_glossary_unlocked_count();
var _tot_a = array_length(global.cyber_glossary);
draw_set_color(make_color_rgb(255, 215, 75));
draw_text_transformed(_fx2 - 14, _fy1 + 14, "ARCHIVED: " + string(_tot_u) + " / " + string(_tot_a) + " CONCEPTS", 0.68, 0.68, 0);

// ── 2b. 5-Branch Skill Mastery Progress Bars ─────────────────────────────
scr_draw_cyber_mastery_bars(_fx1 + 8, _fy1 + 26, _fw - 16, 26, false);

// ── 3. Five Cybersecurity Branch Tabs ────────────────────────────────────
var _tab_y1 = _fy1 + 56;
var _tab_h  = 26;
var _num    = array_length(tab_names);
var _tab_w  = _fw / _num;

for (var i = 0; i < _num; i++) {
    var _tx1 = _fx1 + i * _tab_w;
    var _tx2 = _tx1 + _tab_w;
    var _b_terms = get_branch_terms(i);
    var _b_u = 0;
    for (var _bi = 0; _bi < array_length(_b_terms); _bi++) {
        if (variable_struct_exists(global.codex_unlocked_terms, _b_terms[_bi].id)) _b_u++;
    }

    var _hov_t = (_mx >= _tx1 && _mx <= _tx2 && _my >= _tab_y1 && _my <= _tab_y1 + _tab_h);
    var _act_t = (i == current_branch);

    draw_set_color(_act_t ? make_color_rgb(20, 62, 88) : (_hov_t ? make_color_rgb(18, 40, 64) : make_color_rgb(12, 22, 36)));
    draw_rectangle(_tx1, _tab_y1, _tx2, _tab_y1 + _tab_h, false);
    draw_set_color(_act_t ? c_aqua : make_color_rgb(55, 110, 150));
    draw_rectangle(_tx1, _tab_y1, _tx2, _tab_y1 + _tab_h, true);

    draw_set_halign(fa_center);
    draw_set_color(_act_t ? c_white : make_color_rgb(165, 200, 225));
    draw_text_transformed((_tx1 + _tx2) * 0.5, _tab_y1 + 8, tab_names[i], 0.54, 0.54, 0);
    draw_set_color((_b_u == array_length(_b_terms)) ? c_lime : make_color_rgb(130, 185, 215));
    draw_text_transformed((_tx1 + _tx2) * 0.5, _tab_y1 + 20, string(_b_u) + "/" + string(array_length(_b_terms)), 0.50, 0.50, 0);

    if (_hov_t && mouse_check_button_pressed(mb_left) && i != current_branch) {
        current_branch  = i;
        current_concept = 0;
        content_scroll  = 0;
        sidebar_scroll  = 0;
        if (asset_get_type("snd_page_flip") == asset_sound) audio_play_sound(snd_page_flip, 10, false);
    }
}

// ── 4. Two-Column Body (Scrollable Left Sidebar + Linked Right Deep-Dive Pane)
var _body_y1 = _tab_y1 + _tab_h + 6;
var _body_y2 = _fy2 - 24;
var _side_w  = clamp(_fw * 0.31, 150, 230);
var _side_x1 = _fx1 + 8;
var _side_x2 = _side_x1 + _side_w;
var _pane_x1 = _side_x2 + 10;
var _pane_x2 = _fx2 - 8;
var _pane_w  = _pane_x2 - _pane_x1;

// Left Sidebar
draw_set_color(make_color_rgb(8, 14, 24));
draw_rectangle(_side_x1, _body_y1, _side_x2, _body_y2, false);
draw_set_color(make_color_rgb(45, 95, 135));
draw_rectangle(_side_x1, _body_y1, _side_x2, _body_y2, true);

var _terms = get_branch_terms(current_branch);
var _t_len = array_length(_terms);
current_concept = clamp(current_concept, 0, max(0, _t_len - 1));

var _avail_side_h = (_body_y2 - _body_y1) - 10;
var _row_step     = 25;
var _row_h        = 22;
var _max_vis      = max(1, floor(_avail_side_h / _row_step));
var _max_sscroll  = max(0, _t_len - _max_vis);

if (_mx >= _side_x1 && _mx <= _side_x2 && _my >= _body_y1 && _my <= _body_y2) {
    if (mouse_wheel_up())   sidebar_scroll = max(0, sidebar_scroll - 1);
    if (mouse_wheel_down()) sidebar_scroll = min(_max_sscroll, sidebar_scroll + 1);
}
if (current_concept < sidebar_scroll) sidebar_scroll = current_concept;
if (current_concept >= sidebar_scroll + _max_vis) sidebar_scroll = current_concept - _max_vis + 1;
sidebar_scroll = clamp(sidebar_scroll, 0, _max_sscroll);

var _vis_end = min(_t_len, sidebar_scroll + _max_vis);
for (var _ci = sidebar_scroll; _ci < _vis_end; _ci++) {
    var _item = _terms[_ci];
    var _is_u = variable_struct_exists(global.codex_unlocked_terms, _item.id);
    var _cy1  = _body_y1 + 5 + (_ci - sidebar_scroll) * _row_step;
    var _cy2  = _cy1 + _row_h;

    var _hov_c = (_mx >= _side_x1 + 4 && _mx <= _side_x2 - 4 && _my >= _cy1 && _my <= _cy2);
    var _sel_c = (_ci == current_concept);

    draw_set_color(_sel_c ? make_color_rgb(24, 68, 96) : (_hov_c ? make_color_rgb(18, 42, 62) : make_color_rgb(12, 22, 34)));
    draw_rectangle(_side_x1 + 4, _cy1, _side_x2 - 4, _cy2, false);
    draw_set_color(_sel_c ? c_aqua : (_is_u ? make_color_rgb(55, 130, 170) : make_color_rgb(50, 55, 65)));
    draw_rectangle(_side_x1 + 4, _cy1, _side_x2 - 4, _cy2, true);

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_color(_is_u ? (_sel_c ? c_white : make_color_rgb(175, 235, 255)) : make_color_rgb(115, 125, 140));
    var _lbl = _is_u ? ("[+] " + _item.term) : "[?] Undiscovered";
    draw_text_transformed(_side_x1 + 10, (_cy1 + _cy2) * 0.5, _lbl, 0.52, 0.52, 0);

    if (_hov_c && mouse_check_button_pressed(mb_left)) {
        current_concept = _ci;
        content_scroll  = 0;
        if (asset_get_type("snd_button_click") == asset_sound) audio_play_sound(snd_button_click, 6, false);
    }
}

if (_max_sscroll > 0) {
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_set_color(make_color_rgb(115, 180, 220));
    var _s_ind = (sidebar_scroll > 0 ? "^ " : "") + string(sidebar_scroll + 1) + "-" + string(_vis_end) + "/" + string(_t_len) + (_vis_end < _t_len ? " v" : "");
    draw_text_transformed(_side_x2 - 6, _body_y2 - 2, _s_ind, 0.46, 0.46, 0);
}

// Right Deep-Dive Pane
draw_set_color(make_color_rgb(12, 20, 34));
draw_rectangle(_pane_x1, _body_y1, _pane_x2, _body_y2, false);
draw_set_color(make_color_rgb(60, 145, 195));
draw_rectangle(_pane_x1, _body_y1, _pane_x2, _body_y2, true);

var _jump_target = undefined;

if (_t_len > 0) {
    var _sel   = _terms[current_concept];
    var _sel_u = variable_struct_exists(global.codex_unlocked_terms, _sel.id);

    if (!_sel_u) {
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(255, 195, 80));
        draw_text_transformed((_pane_x1 + _pane_x2) * 0.5, (_body_y1 + _body_y2) * 0.5 - 16, "[?] UNDISCOVERED CYBERSECURITY CONCEPT", 0.85, 0.85, 0);
        draw_set_color(make_color_rgb(185, 205, 225));
        draw_text_ext_transformed((_pane_x1 + _pane_x2) * 0.5, (_body_y1 + _body_y2) * 0.5 + 16,
            "Encounter this concept in Intern Duty dialogue, Desk Audits, Key Vault logs, or the Case Board to automatically unlock this in-depth guide!",
            18, (_pane_w - 48) / 0.68, 0.68, 0.68, 0);
    } else {
        var _px     = _pane_x1 + 12;
        var _t_sc   = 0.58;
        var _l_sep  = 16;
        var _pw_txt = (_pane_w - 24) / _t_sc;

        var _related      = scr_get_related_terms_in_text(_sel, 5);
        var _has_related  = (array_length(_related) > 0);
        var _rel_bar_h    = _has_related ? 24 : 0;
        var _content_y2   = _body_y2 - _rel_bar_h - 4;

        // Pre-compute total height for exact scroll clamping using linked-text line wrapper
        var _sections = [
            { hdr: "1. QUICK DEFINITION",              col: make_color_rgb(255, 215, 75),  body: _sel.short_def },
            { hdr: "2. HOW IT WORKS IN DEPTH",         col: make_color_rgb(110, 225, 255), body: _sel.deep_how },
            { hdr: "3. REAL-WORLD IMPACT",             col: make_color_rgb(255, 145, 125), body: _sel.deep_real },
            { hdr: "4. DEFENSE & PREVENTION STANDARD", col: c_lime,                        body: _sel.deep_defense }
        ];
        var _total_h = 26;
        for (var _si = 0; _si < array_length(_sections); _si++) {
            _total_h += 13 + scr_measure_linked_cyber_text_h(_sections[_si].body, _l_sep, _pw_txt, _t_sc) + 7;
        }
        var _pane_inner_h = (_content_y2 - _body_y1) - 10;
        max_scroll_h   = max(0, _total_h - _pane_inner_h);
        content_scroll = clamp(content_scroll, 0, max_scroll_h);

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);

        var _py = _body_y1 + 8 - content_scroll;
        if (_py >= _body_y1 + 2 && _py <= _content_y2 - 18) {
            draw_set_color(c_aqua);
            draw_text_transformed(_px, _py, _sel.branch_name + "  >  " + _sel.term, 0.80, 0.80, 0);
        }

        // [< BACK] breadcrumb pill when navigated from a cross-link
        if (array_length(nav_history) > 0) {
            var _prev_entry = nav_history[array_length(nav_history) - 1];
            var _bk_lbl     = "< BACK: " + _prev_entry.label;
            var _bk_w       = min(180, string_width(_bk_lbl) * 0.52 + 14);
            var _bk_x2      = _pane_x2 - 8;
            var _bk_x1      = _bk_x2 - _bk_w;
            var _bk_y1      = _body_y1 + 6;
            var _bk_y2      = _bk_y1 + 18;
            var _bk_hov     = (_mx >= _bk_x1 && _mx <= _bk_x2 && _my >= _bk_y1 && _my <= _bk_y2);

            draw_set_color(_bk_hov ? make_color_rgb(35, 78, 112) : make_color_rgb(18, 38, 60));
            draw_rectangle(_bk_x1, _bk_y1, _bk_x2, _bk_y2, false);
            draw_set_color(_bk_hov ? c_yellow : c_aqua);
            draw_rectangle(_bk_x1, _bk_y1, _bk_x2, _bk_y2, true);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(_bk_hov ? c_yellow : c_white);
            draw_text_transformed((_bk_x1 + _bk_x2) * 0.5, (_bk_y1 + _bk_y2) * 0.5, _bk_lbl, 0.52, 0.52, 0);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);

            if (_bk_hov && mouse_check_button_pressed(mb_left)) {
                var _popped = array_pop(nav_history);
                current_branch  = _popped.branch;
                current_concept = _popped.concept;
                content_scroll  = 0;
                if (asset_get_type("snd_button_click") == asset_sound) audio_play_sound(snd_button_click, 6, false);
            }
        }
        _py += 22;

        for (var _sj = 0; _sj < array_length(_sections); _sj++) {
            var _sec   = _sections[_sj];
            var _sec_h = scr_measure_linked_cyber_text_h(_sec.body, _l_sep, _pw_txt, _t_sc);
            if (_py >= _body_y1 + 2 && _py <= _content_y2 - 14) {
                draw_set_color(_sec.col);
                draw_text_transformed(_px, _py, _sec.hdr, 0.60, 0.60, 0);
            }
            _py += 12;
            var _hit_t = scr_draw_linked_cyber_text(
                _px, _py, _sec.body, _l_sep, _pw_txt, _t_sc,
                make_color_rgb(225, 240, 252), _sel.id, true, _body_y1 + 2, _content_y2 - 2
            );
            if (is_struct(_hit_t) && _jump_target == undefined) {
                _jump_target = _hit_t;
            }
            _py += _sec_h + 7;
        }

        if (max_scroll_h > 0) {
            draw_set_halign(fa_right);
            draw_set_valign(fa_bottom);
            draw_set_color(make_color_rgb(130, 195, 235));
            draw_text_transformed(_pane_x2 - 8, _content_y2 - 2, "[Wheel] Scroll", 0.50, 0.50, 0);
        }

        // Bottom "LINKED CONCEPTS" quick-jump chip bar inside right pane
        if (_has_related) {
            var _ry1 = _body_y2 - 24;
            draw_set_color(make_color_rgb(16, 28, 46));
            draw_rectangle(_pane_x1 + 2, _ry1, _pane_x2 - 2, _body_y2 - 2, false);
            draw_set_color(make_color_rgb(45, 95, 135));
            draw_line(_pane_x1 + 2, _ry1, _pane_x2 - 2, _ry1);

            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            draw_set_color(make_color_rgb(140, 210, 245));
            draw_text_transformed(_pane_x1 + 8, _ry1 + 11, "LINKED:", 0.50, 0.50, 0);

            var _cx = _pane_x1 + 52;
            for (var _ri = 0; _ri < array_length(_related); _ri++) {
                var _rt   = _related[_ri];
                var _rlbl = "[" + _rt.term + "]";
                var _rw   = string_width(_rlbl) * 0.50 + 8;
                if (_cx + _rw > _pane_x2 - 6) break;
                var _rhov = (_mx >= _cx && _mx <= _cx + _rw && _my >= _ry1 + 3 && _my <= _body_y2 - 4);
                draw_set_color(_rhov ? make_color_rgb(28, 72, 105) : make_color_rgb(18, 40, 68));
                draw_rectangle(_cx, _ry1 + 3, _cx + _rw, _body_y2 - 4, false);
                draw_set_color(_rhov ? c_yellow : make_color_rgb(80, 200, 255));
                draw_rectangle(_cx, _ry1 + 3, _cx + _rw, _body_y2 - 4, true);
                draw_set_color(_rhov ? c_yellow : c_aqua);
                draw_text_transformed(_cx + 4, _ry1 + 11, _rlbl, 0.50, 0.50, 0);
                if (_rhov && mouse_check_button_pressed(mb_left) && _jump_target == undefined) {
                    _jump_target = _rt;
                }
                _cx += _rw + 5;
            }
        }
    }
}

// Perform cross-link jump if user clicked an inline highlighted term or a Linked Concept chip
if (is_struct(_jump_target)) {
    var _cur_list = get_branch_terms(current_branch);
    var _cur_lbl  = (_t_len > 0) ? _cur_list[current_concept].term : "Previous";
    array_push(nav_history, { branch: current_branch, concept: current_concept, label: _cur_lbl });
    scr_silent_archive_cyber_term(_jump_target);

    current_branch = _jump_target.branch_idx;
    var _dest_terms = get_branch_terms(current_branch);
    current_concept = 0;
    for (var _di = 0; _di < array_length(_dest_terms); _di++) {
        if (_dest_terms[_di].id == _jump_target.id) {
            current_concept = _di;
            break;
        }
    }
    content_scroll = 0;
    sidebar_scroll = max(0, current_concept - 3);
    if (asset_get_type("snd_button_click") == asset_sound) audio_play_sound(snd_button_click, 6, false);
}

// Footer Controls
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(150, 200, 235));
draw_text_transformed((_fx1 + _fx2) * 0.5, _fy2 - 12, "[A/D] Branch   |   [W/S] Concept   |   [Click Cyan Terms] Cross-Link   |   [Backspace] Back   |   [C/ESC] Close", 0.54, 0.54, 0);

scr_draw_demo_teleprompter_hud(_gw, _gh);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
