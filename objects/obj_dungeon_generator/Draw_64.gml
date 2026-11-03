/// @description obj_dungeon_generator — Draw GUI Event
/// Displays the Dungeon Floor HUD, Caesar Key status, and contextual [E] interaction prompts.

if (!gen_complete) exit;
if (instance_exists(obj_dungeon_victory)
    || instance_exists(obj_dungeon_quiz)
    || instance_exists(obj_cipher)
    || (variable_global_exists("key_analyzer_open") && global.key_analyzer_open)) exit;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// =========================================================
// DEDICATED COMPUTER MONITOR SCREEN OVERLAY
// =========================================================
if (variable_global_exists("pc_screen_open") && global.pc_screen_open) {
    // 1. Grey out / darken the background
    draw_set_alpha(0.84);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(1.0);

    var _mcx = _gui_w * 0.5;
    var _mcy = _gui_h * 0.47;
    var _mw  = 490;
    var _mh  = 248;
    var _mx1 = _mcx - _mw * 0.5;
    var _my1 = _mcy - _mh * 0.5;
    var _mx2 = _mcx + _mw * 0.5;
    var _my2 = _mcy + _mh * 0.5;

    // 2. Monitor Stand & Base at bottom
    draw_set_color(make_color_rgb(38, 44, 56));
    draw_rectangle(_mcx - 26, _my2, _mcx + 26, _my2 + 18, false);
    draw_rectangle(_mcx - 70, _my2 + 16, _mcx + 70, _my2 + 24, false);
    draw_set_color(make_color_rgb(75, 88, 110));
    draw_rectangle(_mcx - 70, _my2 + 16, _mcx + 70, _my2 + 24, true);

    // 3. Outer Monitor Plastic Bezel
    draw_set_color(make_color_rgb(46, 54, 68));
    draw_roundrect(_mx1 - 10, _my1 - 10, _mx2 + 10, _my2 + 10, false);
    draw_set_color(make_color_rgb(105, 120, 145));
    draw_roundrect(_mx1 - 10, _my1 - 10, _mx2 + 10, _my2 + 10, true);

    // Power LED on bottom-right bezel
    draw_set_color(c_lime);
    draw_circle(_mx2 - 8, _my2 + 5, 2.5, false);

    // 4. Inner CRT / LCD Terminal Screen
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
    draw_set_alpha(0.08);
    draw_set_color(c_aqua);
    for (var _sy = _my1 + 28; _sy < _my2 - 4; _sy += 4) {
        draw_line(_mx1 + 2, _sy, _mx2 - 2, _sy);
    }
    draw_set_alpha(1.0);

    // Case Clue Recorded Badge
    draw_set_halign(fa_center);
    draw_set_color(make_color_rgb(18, 42, 32));
    draw_rectangle(_mx1 + 16, _my1 + 32, _mx2 - 16, _my1 + 54, false);
    draw_set_color(make_color_rgb(255, 210, 55));
    draw_rectangle(_mx1 + 16, _my1 + 32, _mx2 - 16, _my1 + 54, true);
    draw_text(_mcx, _my1 + 43, global.pc_screen_badge);

    // Main Forensic Log Content Box
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_text_ext(_mx1 + 20, _my1 + 66, global.pc_screen_body, 18, _mw - 40);

    // Radar Direction Readout Box at bottom of monitor
    draw_set_color(make_color_rgb(14, 30, 44));
    draw_rectangle(_mx1 + 16, _my2 - 58, _mx2 - 16, _my2 - 30, false);
    draw_set_color(c_aqua);
    draw_rectangle(_mx1 + 16, _my2 - 58, _mx2 - 16, _my2 - 30, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(_mcx, _my2 - 44, global.pc_screen_radar, 0.90, 0.90, 0);

    // Close instruction footer
    draw_set_color(make_color_rgb(160, 225, 190));
    draw_text_transformed(_mcx, _my2 - 14, "Press [X] or [ESC] to Close Monitor", 0.85, 0.85, 0);

    // Close controls (X, ESC, or clicking [X])
    if (keyboard_check_pressed(ord("X"))
        || keyboard_check_pressed(vk_escape)
        || (_hover_x && mouse_check_button_pressed(mb_left)))
    {
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

// Top-left status bar
draw_set_alpha(0.80);
draw_set_color(make_color_rgb(10, 14, 22));
draw_rectangle(8, 8, 260, 78, false);
draw_set_alpha(1.0);
draw_set_color(c_aqua);
draw_rectangle(8, 8, 260, 78, true);

var _floor_num = (variable_global_exists("dungeons_cleared") ? global.dungeons_cleared : 0) + 1;
draw_set_color(c_white);
draw_text(16, 18, "SECTOR FLOOR #" + string(_floor_num));

// Blinking Lockdown Alert indicator (turns into green [ALL CLEAR] when elevator door is unlocked)
if (variable_global_exists("lockdown_lifted") && global.lockdown_lifted) {
    draw_set_color(c_lime);
    draw_text(142, 18, "[ALL CLEAR]");
} else {
    var _siren_blink = (0.5 + 0.5 * sin(current_time / 220));
    draw_set_color(merge_color(make_color_rgb(180, 40, 55), make_color_rgb(255, 75, 90), _siren_blink));
    draw_text(142, 18, "[LOCKDOWN]");
}

var _has_key = (variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key);
if (_has_key) {
    var _k = global.dungeon_cipher_key;
    var _k_str = (_k > 0) ? ("+" + string(_k)) : string(_k);
    draw_set_color(c_lime);
    draw_text(16, 34, "CAESAR KEY: SHIFT " + _k_str);
} else {
    draw_set_color(make_color_rgb(255, 200, 50));
    draw_text(16, 34, "CAESAR KEY: NOT FOUND");
}

// Incident Case Clue Tracker
var _clues_cur = variable_global_exists("clues_found")  ? global.clues_found  : 0;
var _clues_req = variable_global_exists("clues_needed") ? global.clues_needed : 2;
if (_clues_cur >= _clues_req) {
    draw_set_color(c_lime);
    draw_text(16, 50, "CASE CLUES: " + string(_clues_cur) + "/" + string(_clues_req) + " [READY FOR QUIZ!]");
} else {
    draw_set_color(make_color_rgb(115, 220, 255));
    draw_text(16, 50, "CASE CLUES: " + string(_clues_cur) + "/" + string(_clues_req) + " (Inspect PCs/NPCs)");
}

draw_set_color(make_color_rgb(145, 175, 205));
draw_text(16, 66, "[SHIFT] Sprint   [E] Investigate");

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

    // Radar Panel Background
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

            // Hallways render slightly slimmer on the blueprint
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
            if (_rtype == ROOM_HOLDING)       _rcol = make_color_rgb(255, 130, 35);
            if (_rtype == ROOM_END)           _rcol = make_color_rgb(70, 245, 220);

            if (_disc == 2) {
                // Visited room: solid fill + crisp border
                draw_set_alpha(0.80);
                draw_set_color(_rcol);
                draw_rectangle(_rx1, _ry1, _rx2, _ry2, false);
                draw_set_alpha(1.0);
                draw_set_color(c_white);
                draw_rectangle(_rx1, _ry1, _rx2, _ry2, true);
            } else {
                // Radar-detected unvisited room: dim blueprint fill + colored outline
                draw_set_alpha(0.28);
                draw_set_color(_rcol);
                draw_rectangle(_rx1, _ry1, _rx2, _ry2, false);
                draw_set_alpha(0.85);
                draw_rectangle(_rx1, _ry1, _rx2, _ry2, true);
            }

            // Player's current room indicator (blinking white beacon)
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

    // Check proximity to Quiz Lock Door
    with (obj_door_quiz_lock) {
        if (locked && point_distance(obj_jack.x, obj_jack.y - 8, draw_x + 8, draw_y + 8) < 28) {
            _prompt = "[E] Answer Cybersecurity Question (Unlock Key Vault)";
            _pcol   = make_color_rgb(255, 210, 55);
            break;
        }
    }

    // Check proximity to Caesar Cipher Lock Door
    if (_prompt == "") {
        with (obj_door_caesar_lock) {
            if (locked && point_distance(obj_jack.x, obj_jack.y - 8, draw_x + 8, draw_y + 8) < 28) {
                if (is_holding_door) {
                    _prompt = "[E] Decode Holding Cell Lock (Solve Cell Math Equation for Key!)";
                    _pcol   = make_color_rgb(255, 145, 45);
                } else {
                    _prompt = _has_key
                        ? "[E] Decode Caesar Cipher Lock (Key: " + ((global.dungeon_cipher_key > 0) ? "+" : "") + string(global.dungeon_cipher_key) + ")"
                        : "[E] Inspect Caesar Lock (Key in Gold Vault Room)";
                    _pcol = make_color_rgb(255, 95, 150);
                }
                break;
            }
        }
    }

    // Check proximity to Caesar Key Pedestal (Cryptanalysis Mini-Lesson)
    if (_prompt == "") {
        with (obj_caesar_key_pedestal) {
            if (!collected && player_near) {
                _prompt = "[E] Analyze Intercepted Key Sample (Crack Floor Caesar Key)";
                _pcol   = make_color_rgb(255, 215, 50);
                break;
            }
        }
    }

    // Check proximity to interactive props (Terminals, Memos, Stranded Coworker NPCs, Rebooted Drones)
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
                    _prompt = _in_lck ? "[E] Exit Security Locker (HIDDEN FROM DRONES)" : "[E] Hide in Security Locker";
                    _pcol   = _in_lck ? c_lime : c_aqua;
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
