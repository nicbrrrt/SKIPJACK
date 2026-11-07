/// @description obj_dungeon_generator — Draw GUI Event
/// Displays the Chapter & Floor Curriculum HUD, Key status, Floor Intent Banner,
/// and contextual [E] interaction prompts.

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
    var _mw  = 410;
    var _mh  = 204;
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

    // Centered Main Clue Box
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text_ext(_mcx, _my1 + 92, global.pc_screen_body, 20, _mw - 48);

    // Compact Radar Pill at bottom of monitor
    draw_set_color(make_color_rgb(14, 30, 44));
    draw_rectangle(_mcx - 135, _my2 - 52, _mcx + 135, _my2 - 28, false);
    draw_set_color(c_aqua);
    draw_rectangle(_mcx - 135, _my2 - 52, _mcx + 135, _my2 - 28, true);
    draw_text_transformed(_mcx, _my2 - 40, global.pc_screen_radar, 0.85, 0.85, 0);

    // Minimal close prompt
    draw_set_color(make_color_rgb(150, 200, 175));
    draw_text_transformed(_mcx, _my2 - 13, "[ESC] Close", 0.80, 0.80, 0);

    if (keyboard_check_pressed(ord("X"))
        || keyboard_check_pressed(vk_escape)
        || (_hover_x && mouse_check_button_pressed(mb_left)))
    {
        if (keyboard_check_pressed(vk_escape)) {
            global.esc_block_frames = 2;
            keyboard_clear(vk_escape);
        }
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

// Top-left status bar
draw_set_alpha(0.82);
draw_set_color(make_color_rgb(10, 14, 22));
draw_rectangle(8, 8, 268, 78, false);
draw_set_alpha(1.0);
draw_set_color(_phase_col);
draw_rectangle(8, 8, 268, 78, true);

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

// Line 3: Incident Case Clue Tracker
var _clues_cur = variable_global_exists("clues_found")  ? global.clues_found  : 0;
var _clues_req = variable_global_exists("clues_needed") ? global.clues_needed : 2;
if (_clues_cur >= _clues_req) {
    draw_set_color(c_lime);
    draw_text_transformed(15, 50, "CLUES: " + string(_clues_cur) + "/" + string(_clues_req) + " [READY FOR VAULT!]", 0.84, 0.84, 0);
} else {
    draw_set_color(make_color_rgb(115, 220, 255));
    draw_text_transformed(15, 50, "CLUES: " + string(_clues_cur) + "/" + string(_clues_req) + " (Inspect PCs / NPCs)", 0.84, 0.84, 0);
}

// Line 4: 4-Stage Facility Recovery Checklist (1.KEY -> 2.OVERRIDE -> 3.POWER -> 4.ELEVATOR)
var _ov_done  = (variable_global_exists("lockdown_overridden") && global.lockdown_overridden);
var _pwr_done = (variable_global_exists("power_restored")      && global.power_restored);
var _s1_txt   = _has_key  ? "[x]1.KEY"      : "[ ]1.KEY";
var _s2_txt   = _ov_done  ? "[x]2.OVERRIDE" : "[ ]2.OVERRIDE";
var _s3_txt   = _pwr_done ? "[x]3.POWER"    : "[ ]3.POWER";
draw_set_color((_has_key && _ov_done && _pwr_done) ? c_lime : make_color_rgb(185, 210, 235));
draw_text_transformed(15, 66, _s1_txt + "  " + _s2_txt + "  " + _s3_txt, 0.72, 0.72, 0);

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
    var _map_x = 8;
    var _map_y = 84;
    var _cell_sz = 9;
    var _cell_step = 12;
    var _map_w = LOGIC_GRID_W * _cell_step + 12;
    var _map_h = LOGIC_GRID_H * _cell_step + 24;

    draw_set_alpha(0.76);
    draw_set_color(make_color_rgb(8, 13, 22));
    draw_rectangle(_map_x, _map_y, _map_x + _map_w, _map_y + _map_h, false);
    draw_set_alpha(0.90);
    draw_set_color(make_color_rgb(45, 110, 145));
    draw_rectangle(_map_x, _map_y, _map_x + _map_w, _map_y + _map_h, true);

    draw_set_color(make_color_rgb(120, 210, 245));
    draw_text(_map_x + 6, _map_y + 9, "BLUEPRINT RADAR");

    var _grid_ox = _map_x + 8;
    var _grid_oy = _map_y + 18;

    // 1. Draw Doorway Links between discovered rooms
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
                    draw_set_color(make_color_rgb(255, 75, 135));
                } else {
                    draw_set_color(make_color_rgb(75, 155, 190));
                }
                draw_set_alpha(0.85);
                draw_line_width(_lx1, _ly1, _lx2, _ly2, 2);
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
            if (player_near) {
                if (prop_type == TILE_PROP_NPC) {
                    _prompt = "[E] Talk to " + myName;
                    _pcol   = make_color_rgb(100, 235, 155);
                } else if (prop_type == TILE_PROP_PC) {
                    _prompt = "[E] Inspect Corporate Terminal";
                    _pcol   = c_aqua;
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
                    _prompt = _pwr_done ? "[E] Power Breaker Restored (Lights & Elevator Online)" : "[E] Inspect Floor Power Breaker Panel (3-Fuse Check)";
                    _pcol   = _pwr_done ? c_lime : c_aqua;
                } else if (prop_type == TILE_PROP_DRONE) {
                    _prompt = "[E] Inspect Rebooted Drone";
                    _pcol   = c_lime;
                }
                break;
            }
        }
    }

    if (_prompt != "") {
        draw_set_halign(fa_center);
        var _pw = string_width(_prompt) + 24;
        var _py = _gui_h - 26;
        draw_set_alpha(0.82);
        draw_set_color(make_color_rgb(10, 14, 22));
        draw_rectangle((_gui_w - _pw) * 0.5, _py - 12, (_gui_w + _pw) * 0.5, _py + 12, false);
        draw_set_alpha(1.0);
        draw_set_color(_pcol);
        draw_rectangle((_gui_w - _pw) * 0.5, _py - 12, (_gui_w + _pw) * 0.5, _py + 12, true);
        draw_text(_gui_w * 0.5, _py, _prompt);
    }
}

draw_set_font(fnt_default);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);
