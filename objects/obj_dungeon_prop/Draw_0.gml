/// @description obj_dungeon_prop — Draw Event
/// Draws corporate office props (visually distinguishing Clue Terminals from standard PCs),
/// chairs, scattered papers, stranded coworker NPCs, and hallway-wide laser security drones.

var _cx     = x + 8;
var _by     = y + 15;
var _lifted = (variable_global_exists("lockdown_lifted")     && global.lockdown_lifted)
           || (variable_global_exists("lockdown_overridden") && global.lockdown_overridden);
var _pwr_on = (variable_global_exists("power_restored")      && global.power_restored)
           || (variable_global_exists("lockdown_lifted")     && global.lockdown_lifted);

// Suspect desk nameplate (whodunit): lets the player match evidence to a desk
if (prop_type == TILE_PROP_PC && suspect_idx >= 0 && nameplate != "") {
    var _solved_np = (variable_global_exists("incident_solved") && global.incident_solved);
    var _is_cul    = (variable_global_exists("case_culprit_idx") && suspect_idx == global.case_culprit_idx);
    var _wrong_np  = (variable_global_exists("case_suspects") && variable_struct_exists(global.case_suspects[suspect_idx], "accused_wrong"));
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var _np_w = string_width(nameplate) * 0.5 + 4;
    draw_set_alpha(0.85);
    draw_set_color(make_color_rgb(14, 20, 30));
    draw_rectangle(_cx - _np_w, y - 12, _cx + _np_w, y - 3, false);
    draw_set_alpha(1.0);
    draw_set_color((_solved_np && _is_cul) ? c_lime : (_wrong_np ? make_color_rgb(120, 140, 150) : make_color_rgb(255, 180, 90)));
    draw_rectangle(_cx - _np_w, y - 12, _cx + _np_w, y - 3, true);
    draw_text_transformed(_cx, y - 7, nameplate, 0.5, 0.5, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1.0);
}

if (prop_type == TILE_PROP_PC) {
    // Check if terminal is on the south side of the room (facing north, showing back side to player)
    var _is_south = variable_instance_exists(id, "is_south_facing") ? is_south_facing : false;
    if (!_is_south) {
        var _has_south_wall = (position_meeting(x + 8, y + 24, obj_dungeon_wall) || !position_meeting(x + 8, y + 24, obj_floor));
        var _has_north_wall = position_meeting(x + 8, y - 8, obj_dungeon_wall);
        if (_has_south_wall && !_has_north_wall) {
            _is_south = true;
        }
    }

    var _desk_spr = _is_south ? (sprite_exists(spr_dungeon_desk_back) ? spr_dungeon_desk_back : spr_dungeon_desk) : spr_dungeon_desk;
    var _comp_spr = _is_south ? (sprite_exists(spr_computer_back) ? spr_computer_back : spr_computer) : spr_computer;

    var _use_desk_spr = sprite_exists(_desk_spr);
    var _desk_x = _use_desk_spr ? (_cx - (sprite_get_width(_desk_spr) * 0.5) + sprite_get_xoffset(_desk_spr)) : x;
    var _desk_y = _use_desk_spr ? ((y + 16) - 30 + sprite_get_yoffset(_desk_spr)) : y;
    var _comp_y = _use_desk_spr ? (_desk_y + 25) : (y + 11);

    if (is_scrapped) {
        // =========================================================
        // SCRAPPED / DISMANTLED TERMINAL CHASSIS
        // =========================================================
        if (_use_desk_spr) {
            draw_set_alpha(0.85);
            draw_sprite_ext(_desk_spr, 0, _desk_x, _desk_y, 1.0, 1.0, 0, make_color_rgb(110, 115, 125), 0.85);
            if (sprite_exists(spr_terminal_scrap)) {
                var _scx = _cx - (sprite_get_width(spr_terminal_scrap) * 0.5) + sprite_get_xoffset(spr_terminal_scrap);
                var _scy = _desk_y + 10 + sprite_get_yoffset(spr_terminal_scrap);
                draw_sprite_ext(spr_terminal_scrap, 0, _scx, _scy, 1.0, 1.0, 0, c_white, 1.0);
            }
        } else {
            draw_set_alpha(0.88);
            draw_set_color(make_color_rgb(20, 22, 28));
            draw_rectangle(x + 1, y + 4, x + 14, y + 14, false);
            draw_set_color(make_color_rgb(55, 60, 72));
            draw_rectangle(x + 1, y + 4, x + 14, y + 14, true);

            if (sprite_exists(spr_terminal_scrap)) {
                var _scx = _cx - (sprite_get_width(spr_terminal_scrap) * 0.5) + sprite_get_xoffset(spr_terminal_scrap);
                var _scy = y + 3 + sprite_get_yoffset(spr_terminal_scrap);
                draw_sprite_ext(spr_terminal_scrap, 0, _scx, _scy, 1.0, 1.0, 0, c_white, 1.0);
            } else {
                // Exposed copper & cyan wires on gutted desk
                draw_set_color(make_color_rgb(210, 120, 45));
                draw_line(x + 4, y + 8, x + 9, y + 11);
                draw_set_color(c_aqua);
                draw_point(x + 10, y + 7);
                draw_point(x + 6, y + 11);
            }
        }
    } else if (has_clue) {
        // =========================================================
        // CLUE TERMINAL (Visually distinct Gold/Cyan Forensic Desk)
        // =========================================================
        var _pulse = 0.5 + 0.5 * sin(current_time / 160 + x);

        // Subtle golden/emerald screen light pool on floor
        draw_set_alpha(0.06 + 0.04 * _pulse);
        draw_set_color(is_fried ? c_red : (talked_once ? c_lime : make_color_rgb(255, 210, 45)));
        draw_circle(_cx, y + 10, 11, false);

        if (_use_desk_spr) {
            draw_set_alpha(1.0);
            draw_sprite_ext(_desk_spr, 0, _desk_x, _desk_y, 1.0, 1.0, 0, make_color_rgb(255, 240, 200), 1.0);
        } else {
            // Forensic Gold-Trimmed Desk Base (Procedural Fallback)
            draw_set_alpha(0.95);
            draw_set_color(make_color_rgb(55, 45, 22));
            draw_rectangle(x, y + 3, x + 15, y + 15, false);
            draw_set_alpha(0.65);
            draw_set_color(is_fried ? c_red : (talked_once ? c_lime : make_color_rgb(255, 205, 40)));
            draw_rectangle(x, y + 3, x + 15, y + 15, true);
        }

        // Animated Computer Terminal at full 1.0 scale seated on the desk surface
        draw_set_alpha(1.0);
        var _frame = floor(current_time / 140 + sub_img) mod sprite_get_number(_comp_spr);
        var _tint  = is_fried ? make_color_rgb(255, 100, 100) : make_color_rgb(255, 250, 210);
        draw_sprite_ext(_comp_spr, _frame, _cx, _comp_y, 1.0, 1.0, 0, _tint, 1.0);

        // Subtle floating Clue Terminal indicator above monitor
        var _bob = sin(current_time / 170 + x) * 1.2;
        draw_set_alpha(0.38);
        draw_set_color(is_fried ? c_red : (talked_once ? c_lime : make_color_rgb(255, 205, 35)));
        draw_rectangle(_cx - 3, _comp_y - 34 + _bob, _cx + 3, _comp_y - 28 + _bob, false);
        draw_set_alpha(0.45);
        draw_set_color(c_black);
        draw_rectangle(_cx - 3, _comp_y - 34 + _bob, _cx + 3, _comp_y - 28 + _bob, true);
    } else if (is_server_rack) {
        // =========================================================
        // HIGH-YIELD PROTOTYPE SERVER TERMINAL (+3 Scrap in Encrypted Decoy Rooms!)
        // =========================================================
        var _spulse = 0.5 + 0.5 * sin(current_time / 140 + x);
        draw_set_alpha(0.10 + 0.05 * _spulse);
        draw_set_color(is_fried ? c_red : make_color_rgb(225, 85, 255));
        draw_circle(_cx, y + 10, 12, false);

        if (_use_desk_spr) {
            draw_set_alpha(1.0);
            draw_sprite_ext(_desk_spr, 0, _desk_x, _desk_y, 1.0, 1.0, 0, make_color_rgb(210, 180, 235), 1.0);
        } else {
            draw_set_alpha(0.95);
            draw_set_color(make_color_rgb(38, 20, 48));
            draw_rectangle(x, y + 3, x + 15, y + 15, false);
            draw_set_color(is_fried ? c_red : make_color_rgb(235, 110, 255));
            draw_rectangle(x, y + 3, x + 15, y + 15, true);
        }

        var _sframe = floor(current_time / 120 + sub_img) mod sprite_get_number(_comp_spr);
        var _stint  = is_fried ? make_color_rgb(255, 95, 95) : make_color_rgb(245, 195, 255);
        draw_sprite_ext(_comp_spr, _sframe, _cx, _comp_y, 1.0, 1.0, 0, _stint, 1.0);
    } else {
        // =========================================================
        // STANDARD CORPORATE PC (Right-Click with Wrench to Scrap!)
        // =========================================================
        draw_set_alpha(0.06);
        draw_set_color(is_fried ? c_red : make_color_rgb(65, 140, 180));
        draw_circle(_cx, y + 10, 9, false);

        if (_use_desk_spr) {
            draw_set_alpha(1.0);
            draw_sprite_ext(_desk_spr, 0, _desk_x, _desk_y, 1.0, 1.0, 0, c_white, 1.0);
        } else {
            // Standard Dark Slate Desk Base (Procedural Fallback)
            draw_set_alpha(0.90);
            draw_set_color(make_color_rgb(28, 34, 46));
            draw_rectangle(x + 1, y + 4, x + 14, y + 14, false);
            draw_set_color(is_fried ? c_red : make_color_rgb(55, 64, 82));
            draw_rectangle(x + 1, y + 4, x + 14, y + 14, true);
        }

        // Monitor seated on desk top at full 1.0 scale
        var _c_tint = is_fried ? make_color_rgb(255, 90, 90) : c_white;
        draw_sprite_ext(_comp_spr, 0, _cx, _comp_y, 1.0, 1.0, 0, _c_tint, 1.0);
    }

    // Draw sizzling red/orange sparks if Anti-Tamper fried the terminal's circuits!
    if (is_fried && !is_scrapped) {
        draw_set_alpha(0.85);
        draw_set_color((current_time mod 240 < 120) ? c_red : c_orange);
        var _sx1 = _cx + irandom_range(-4, 4);
        var _sy1 = y + 4 + irandom_range(-3, 3);
        draw_line(_sx1 - 2, _sy1, _sx1 + 2, _sy1);
        draw_line(_sx1, _sy1 - 2, _sx1, _sy1 + 2);
    }
}
else if (prop_type == TILE_PROP_CHAIR) {
    // Corporate Filing Cabinet (directional: front, back, side_left, side_right)
    var _variant = variable_instance_exists(id, "cabinet_variant") ? cabinet_variant : -1;

    if (_variant == -1) {
        // Dynamic detection based on adjacent walls & neighboring terminals
        var _has_west  = position_meeting(x - 8, y + 8, obj_dungeon_wall);
        var _has_east  = position_meeting(x + 24, y + 8, obj_dungeon_wall);
        var _has_south = position_meeting(x + 8, y + 24, obj_dungeon_wall);
        var _has_north = position_meeting(x + 8, y - 8, obj_dungeon_wall);

        // Check if placed beside an office terminal to match its orientation
        var _adj_pc = instance_position(x - 8, y + 8, obj_dungeon_prop);
        if (_adj_pc == noone || _adj_pc.prop_type != TILE_PROP_PC) _adj_pc = instance_position(x + 24, y + 8, obj_dungeon_prop);
        if (_adj_pc == noone || _adj_pc.prop_type != TILE_PROP_PC) _adj_pc = instance_position(x + 8, y - 8, obj_dungeon_prop);
        if (_adj_pc == noone || _adj_pc.prop_type != TILE_PROP_PC) _adj_pc = instance_position(x + 8, y + 24, obj_dungeon_prop);

        if (_has_west && !_has_east) {
            _variant = 1; // side_left (against West wall)
        } else if (_has_east && !_has_west) {
            _variant = 2; // side_right (against East wall)
        } else if (_adj_pc != noone && variable_instance_exists(_adj_pc, "is_south_facing")) {
            _variant = _adj_pc.is_south_facing ? 3 : 0; // Match adjacent terminal's south or north facing!
        } else if (_has_south && !_has_north) {
            _variant = 3; // back (against South wall)
        } else if (_has_north && !_has_south) {
            _variant = 0; // front (against North wall)
        } else {
            // General room position: south side of chunk vs north side of chunk
            var _chunk_row = (y div 16) mod CHUNK_SIZE;
            _variant = (_chunk_row >= 4) ? 3 : 0;
        }
    }

    var _cab_spr = spr_dungeon_cabinet;
    if (_variant == 1 && sprite_exists(spr_dungeon_cabinet_side_left)) {
        _cab_spr = spr_dungeon_cabinet_side_left;
    } else if (_variant == 2 && sprite_exists(spr_dungeon_cabinet_side_right)) {
        _cab_spr = spr_dungeon_cabinet_side_right;
    } else if (_variant == 3 && sprite_exists(spr_dungeon_cabinet_back)) {
        _cab_spr = spr_dungeon_cabinet_back;
    } else if (sprite_exists(spr_dungeon_cabinet)) {
        _cab_spr = spr_dungeon_cabinet;
    }

    // Position cabinet seated on the tile floor (16x32 sprite, bottom aligned to y+16)
    var _cab_x = _cx - (sprite_get_width(_cab_spr) * 0.5) + sprite_get_xoffset(_cab_spr);
    var _cab_y = (y + 16) - sprite_get_height(_cab_spr) + sprite_get_yoffset(_cab_spr);

    draw_set_alpha(1.0);
    draw_sprite_ext(_cab_spr, 0, _cab_x, _cab_y, 1.0, 1.0, 0, c_white, 1.0);
}
else if (prop_type == TILE_PROP_PAPER) {
    // Scattered Lockdown Papers on floor
    draw_sprite_ext(spr_paper, 0, _cx, y + 11, 0.75, 0.75, rot_angle, c_white, 0.9);
}
else if (prop_type == TILE_PROP_NPC) {
    // Subtle floor shadow under coworker NPC
    draw_set_alpha(0.35);
    draw_set_color(c_black);
    draw_ellipse(x + 2, y + 11, x + 14, y + 16, false);
    draw_set_alpha(1.0);

    // Draw Coworker NPC sprite (16x32 sheet)
    var _sy = scr_battle_sprite_feet_y(npc_spr, 1.0, y + 15);
    draw_sprite_ext(npc_spr, npc_frame, x, _sy, 1.0, 1.0, 0, c_white, 1.0);

    // Subtle floating status dot above NPC head
    var _bob = sin(current_time / 180 + x) * 1.2;
    if (!talked_once || _lifted) {
        draw_set_alpha(0.38);
        draw_set_color(_lifted ? c_lime : make_color_rgb(255, 215, 50));
        draw_circle(_cx, y - 16 + _bob, 2.5, false);
        draw_set_alpha(0.45);
        draw_set_color(c_black);
        draw_circle(_cx, y - 16 + _bob, 2.5, true);
    }
}
else if (prop_type == TILE_PROP_LOCKER) {
    // =========================================================
    // HIGH-CONTRAST HALLWAY SECURITY LOCKER (Easy to spot in blackout!)
    // =========================================================
    var _is_occupied = (variable_global_exists("player_in_locker") && global.player_in_locker && global.active_locker_id == id);

    // [EXPERIMENTAL] Toggle for using user-provided locker sprites
    // (Easily reversible: set to false to instantly fall back to the original procedural code!)
    var _use_new_locker_sprites = true;

    if (_use_new_locker_sprites && sprite_exists(spr_dungeon_locker) && sprite_exists(spr_dungeon_locker_hidden)) {
        // Drop shadow under locker base
        draw_set_alpha(0.35);
        draw_set_color(c_black);
        draw_ellipse(_cx - 8, y + 12, _cx + 8, y + 16, false);

        // Select sprite depending on locker variant and whether Jack is hidden inside:
        // locker_variant == 0: North wall (door faces player) -> spr_dungeon_locker / spr_dungeon_locker_hidden
        // locker_variant == 1: East, West, or South wall (door does not face player) -> spr_dungeon_locker_1 (normal & hidden)
        var _variant = variable_instance_exists(id, "locker_variant") ? locker_variant : 0;
        if (_variant == 0) {
            // Auto-detect wall orientation: if not against a north wall, but adjacent to south, west, or east walls
            var _has_north = position_meeting(x + 8, y - 8, obj_dungeon_wall);
            var _has_other = position_meeting(x + 8, y + 24, obj_dungeon_wall) || position_meeting(x - 8, y + 8, obj_dungeon_wall) || position_meeting(x + 24, y + 8, obj_dungeon_wall);
            if (!_has_north && _has_other) {
                _variant = 1;
            }
        }

        var _spr = _is_occupied ? spr_dungeon_locker_hidden : spr_dungeon_locker;
        if (_variant == 1) {
            if (sprite_exists(spr_dungeon_locker_1)) {
                _spr = spr_dungeon_locker_1;
            }
        }

        // Position the sprite centered horizontally on the 16px tile, with base resting at y+16
        var _draw_x = _cx - (sprite_get_width(_spr) * 0.5) + sprite_get_xoffset(_spr);
        var _draw_y = (y + 16) - sprite_get_height(_spr) + sprite_get_yoffset(_spr);

        draw_set_alpha(1.0);
        draw_sprite_ext(_spr, 0, _draw_x, _draw_y, 1.0, 1.0, 0, c_white, 1.0);
    } else {
        // =========================================================
        // ORIGINAL PROCEDURAL LOCKER (Fallback / Reversible)
        // =========================================================
        // Subtle floor light pool under locker
        draw_set_alpha(0.07);
        draw_set_color(_is_occupied ? c_lime : c_aqua);
        draw_circle(_cx, y + 8, 10, false);

        // Drop shadow under locker
        draw_set_alpha(0.55);
        draw_set_color(c_black);
        draw_rectangle(x, y - 8, x + 15, y + 15, false);

        // High-contrast Safety Amber / Cyan Steel Locker Cabinet
        draw_set_alpha(1.0);
        draw_set_color(_is_occupied ? make_color_rgb(20, 125, 145) : make_color_rgb(230, 155, 25));
        draw_rectangle(x + 1, y - 8, x + 14, y + 14, false);

        // Crisp bright neon frame & vertical door divider
        draw_set_color(_is_occupied ? c_lime : make_color_rgb(255, 235, 120));
        draw_rectangle(x + 1, y - 8, x + 14, y + 14, true);
        draw_line(x + 2, y - 4, x + 13, y - 4);

        // Glowing Top LED Beacon
        draw_set_color(_is_occupied ? c_lime : c_aqua);
        draw_circle(_cx, y - 6, 2, false);

        // Louvered air vents / Peephole visor slit
        if (_is_occupied) {
            draw_set_color(c_black);
            draw_rectangle(x + 3, y - 2, x + 12, y + 2, false);
            draw_set_color(c_lime);
            draw_point(x + 6, y);
            draw_point(x + 9, y);
        } else {
            draw_set_color(make_color_rgb(25, 30, 42));
            draw_rectangle(x + 4, y - 2, x + 11, y + 3, false);
            draw_set_color(make_color_rgb(255, 220, 95));
            draw_line(x + 4, y, x + 11, y);
        }

        // Bright White/Silver Locker Handle
        draw_set_color(c_white);
        draw_rectangle(x + 10, y + 6, x + 12, y + 10, false);
    }
}
else if (prop_type == TILE_PROP_OVERRIDE) {
    // =========================================================
    // RED LOCKDOWN OVERRIDE CONSOLE (Stage 2 Objective)
    // =========================================================
    var _pulse = 0.5 + 0.5 * sin(current_time / 160);

    // Subtle floor glow
    draw_set_alpha(0.08 + 0.04 * _pulse);
    draw_set_color(_lifted ? c_lime : make_color_rgb(255, 65, 85));
    draw_circle(_cx, y + 9, 12, false);

    // Steel Console Pedestal Base
    draw_set_alpha(0.95);
    draw_set_color(make_color_rgb(32, 24, 36));
    draw_rectangle(x + 1, y, x + 14, y + 14, false);
    draw_set_color(_lifted ? c_lime : make_color_rgb(255, 80, 105));
    draw_rectangle(x + 1, y, x + 14, y + 14, true);

    // Center Big Red Override Dome Button (Turns Emerald Green when overridden!)
    draw_set_color(_lifted ? c_lime : merge_color(make_color_rgb(220, 30, 50), make_color_rgb(255, 120, 130), _pulse));
    draw_circle(_cx, y + 6, 4, false);
    draw_set_color(c_white);
    draw_circle(_cx - 1, y + 5, 1, false);
}
else if (prop_type == TILE_PROP_BREAKER) {
    // =========================================================
    // HIGH-VOLTAGE POWER BREAKER PANEL (Stage 3 Objective)
    // =========================================================
    var _pulse = 0.5 + 0.5 * sin(current_time / 170);

    // Subtle electric floor glow
    draw_set_alpha(0.08 + 0.04 * _pulse);
    draw_set_color(_pwr_on ? c_lime : c_aqua);
    draw_circle(_cx, y + 9, 12, false);

    if (sprite_exists(spr_power_breaker_panel)) {
        var _bx = _cx - (sprite_get_width(spr_power_breaker_panel) * 0.5) + sprite_get_xoffset(spr_power_breaker_panel);
        var _by_draw = (y + 16) - sprite_get_height(spr_power_breaker_panel) + sprite_get_yoffset(spr_power_breaker_panel);
        draw_set_alpha(1.0);
        draw_sprite_ext(spr_power_breaker_panel, 0, _bx, _by_draw, 1.0, 1.0, 0, c_white, 1.0);

        // Power status indicator light
        draw_set_color(_pwr_on ? c_lime : ((current_time mod 240 < 120) ? c_red : c_yellow));
        draw_circle(_cx + 4, _by_draw + 5, 1.5, false);
    } else {
        // Industrial Breaker Cabinet Box (Procedural Fallback)
        draw_set_alpha(0.95);
        draw_set_color(make_color_rgb(22, 34, 48));
        draw_rectangle(x + 1, y - 2, x + 14, y + 14, false);
        draw_set_color(_pwr_on ? c_lime : c_aqua);
        draw_rectangle(x + 1, y - 2, x + 14, y + 14, true);

        // 3 Miniature Fuse Switch Bars inside cabinet
        for (var _fi = 0; _fi < 3; _fi++) {
            var _fy = y + 1 + _fi * 4;
            draw_set_color(_pwr_on ? c_lime : ((_fi == 1) ? make_color_rgb(255, 200, 50) : c_aqua));
            draw_rectangle(x + 4, _fy, x + 11, _fy + 2, false);
        }
    }
}
else if (prop_type == TILE_PROP_DRONE) {
    var _cy      = y + 8;
    var _hover_y = (_lifted || is_scrapped) ? 0 : (sin(hover_t) * 2.5);

    if (is_scrapped) {
        // Dismantled Security Bot Shell on the floor
        draw_set_alpha(0.40);
        draw_set_color(c_black);
        draw_ellipse(x + 2, y + 9, x + 14, y + 15, false);
        draw_set_alpha(0.85);
        draw_sprite_ext(drone_spr, 0, _cx, y + 9, 0.38, 0.32, 22, make_color_rgb(90, 95, 110), 0.85);
    } else {
        // =========================================================
        // REAL-TIME 2D RAYCAST FLASHLIGHT BEAM (Wraps around corners & walls!)
        // =========================================================
        if (!_lifted && !grapple_active) {
            var _is_jammed = (variable_global_exists("drone_jammed_timer") && global.drone_jammed_timer > 0);
            var _base_dir  = point_direction(0, 0, patrol_vx, patrol_vy);
            var _scan_dir  = _base_dir + sin(hover_t * 0.90) * 18;
            var _watcher   = scr_has_active_statue(0); // Blind Watcher Bust shrinks the beam
            var _max_dist  = _is_jammed ? 40 : (_watcher ? 66 : 94);
            var _half_fov  = _watcher ? 22 : 32;
            var _num_rays  = 24;

            // Subtle flashlight glow around the drone lens itself
            draw_set_alpha(_is_jammed ? 0.04 : 0.08);
            draw_set_color(_is_jammed ? c_aqua : make_color_rgb(255, 210, 120));
            draw_circle(_cx, _cy, 10, false);

            // Outer Raycast Flashlight Fan (clips against walls & spills into open doorway alcoves!)
            draw_primitive_begin(pr_trianglefan);
            var _fan_c1 = _is_jammed ? make_color_rgb(100, 160, 220) : make_color_rgb(255, 235, 165);
            var _fan_a1 = _is_jammed ? 0.20 : 0.42;
            var _fan_c2 = _is_jammed ? make_color_rgb(50, 80, 120)  : make_color_rgb(255, 65, 55);
            var _fan_a2 = _is_jammed ? 0.06 : 0.14;
            draw_vertex_color(_cx, _cy, _fan_c1, _fan_a1);

            for (var _ri = 0; _ri <= _num_rays; _ri++) {
                var _ang = (_scan_dir - _half_fov) + (_ri / _num_rays) * (_half_fov * 2);
                var _vx  = lengthdir_x(1, _ang);
                var _vy  = lengthdir_y(1, _ang);
                var _hit_d = _max_dist;

                for (var _d = 8; _d <= _max_dist; _d += 4) {
                    if (position_meeting(_cx + _vx * _d, _cy + _vy * _d, obj_dungeon_wall)) {
                        _hit_d = _d;
                        break;
                    }
                }

                var _rx = _cx + _vx * _hit_d;
                var _ry = _cy + _vy * _hit_d;
                draw_vertex_color(_rx, _ry, _fan_c2, _fan_a2);
            }
            draw_primitive_end();

            // Floating [JAMMED] indicator if frequency jammed
            if (_is_jammed) {
                draw_set_font(fnt_dialogue);
                draw_set_halign(fa_center);
                draw_set_valign(fa_bottom);
                draw_set_color(c_aqua);
                draw_text_transformed(_cx, y - 10, "[JAMMED]", 0.72, 0.72, 0);
            }
        } else {
            // Powered-down or Grappled standby ring
            draw_set_alpha(0.28);
            draw_set_color(grapple_active ? c_yellow : c_lime);
            draw_circle(_cx, y + 10, 9, false);
        }

        // Draw Rogue Virus / Security Drone sprite centered in the hallway
        var _dframe = _lifted ? 0 : (floor(current_time / 120) mod max(1, sprite_get_number(drone_spr)));
        var _dtint  = is_fried ? make_color_rgb(255, 95, 95) : (_lifted ? make_color_rgb(150, 220, 175) : c_white);
        var _gx_off = grapple_active ? irandom_range(-2, 2) : 0;
        var _gy_off = grapple_active ? irandom_range(-2, 2) : 0;
        draw_set_alpha(1.0);
        draw_sprite_ext(drone_spr, _dframe, _cx + _gx_off, y + 6 + _hover_y + _gy_off, 0.42, 0.42, 0, _dtint, 1.0);

        // =========================================================
        // SPAM [E] APPREHEND STRUGGLE BAR ABOVE SECURITY BOT
        // =========================================================
        if (grapple_active) {
            var _bw  = 38;
            var _bh  = 6;
            var _bx1 = _cx - _bw * 0.5;
            var _by1 = y - 22;
            var _fill = clamp(grapple_meter, 0, 1);

            draw_set_alpha(0.92);
            draw_set_color(c_black);
            draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, false);
            draw_set_color(merge_color(c_red, c_lime, _fill));
            draw_rectangle(_bx1, _by1, _bx1 + _bw * _fill, _by1 + _bh, false);
            draw_set_color(c_white);
            draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, true);
        }
    }
}

// Subtle floating [E] / [RMB] indicator directly over the prop when Jack is within range
if (player_near && !grapple_active) {
    var _ey = (prop_type == TILE_PROP_NPC) ? (y - 24) : (y - 16);
    draw_set_alpha(0.55);
    draw_set_color(make_color_rgb(10, 16, 26));
    draw_rectangle(_cx - 6, _ey - 4, _cx + 6, _ey + 4, false);
    draw_set_alpha(0.65);
    draw_set_color(is_fried ? c_orange : c_aqua);
    draw_rectangle(_cx - 6, _ey - 4, _cx + 6, _ey + 4, true);
}

// Floating world-space status text (+1 SCRAP, CIRCUITS FRIED, etc.)
if (scrap_pop_timer > 0 && scrap_pop_text != "") {
    var _p_alpha = clamp(scrap_pop_timer / 25, 0, 1);
    var _float_y = y - 18 - (1 - (scrap_pop_timer / 95)) * 10;
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(_p_alpha);
    draw_set_color(c_black);
    draw_text_transformed(_cx + 1, _float_y + 1, scrap_pop_text, 0.42, 0.42, 0);
    draw_set_color(is_fried ? make_color_rgb(255, 110, 75) : c_lime);
    draw_text_transformed(_cx, _float_y, scrap_pop_text, 0.42, 0.42, 0);
    draw_set_font(fnt_default);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

draw_set_color(c_white);
draw_set_alpha(1.0);
