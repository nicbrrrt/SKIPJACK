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
    if (is_scrapped) {
        // =========================================================
        // SCRAPPED / DISMANTLED TERMINAL CHASSIS
        // =========================================================
        draw_set_alpha(0.88);
        draw_set_color(make_color_rgb(20, 22, 28));
        draw_rectangle(x + 1, y + 4, x + 14, y + 14, false);
        draw_set_color(make_color_rgb(55, 60, 72));
        draw_rectangle(x + 1, y + 4, x + 14, y + 14, true);

        // Exposed copper & cyan wires on gutted desk
        draw_set_color(make_color_rgb(210, 120, 45));
        draw_line(x + 4, y + 8, x + 9, y + 11);
        draw_set_color(c_aqua);
        draw_point(x + 10, y + 7);
        draw_point(x + 6, y + 11);
    } else if (has_clue) {
        // =========================================================
        // CLUE TERMINAL (Visually distinct Gold/Cyan Forensic Desk)
        // =========================================================
        var _pulse = 0.5 + 0.5 * sin(current_time / 160 + x);

        // Subtle golden/emerald screen light pool on floor
        draw_set_alpha(0.06 + 0.04 * _pulse);
        draw_set_color(is_fried ? c_red : (talked_once ? c_lime : make_color_rgb(255, 210, 45)));
        draw_circle(_cx, y + 10, 11, false);

        // Forensic Gold-Trimmed Desk Base
        draw_set_alpha(0.95);
        draw_set_color(make_color_rgb(55, 45, 22));
        draw_rectangle(x, y + 3, x + 15, y + 15, false);
        draw_set_alpha(0.65);
        draw_set_color(is_fried ? c_red : (talked_once ? c_lime : make_color_rgb(255, 205, 40)));
        draw_rectangle(x, y + 3, x + 15, y + 15, true);

        // Animated Computer Terminal with highlight tint
        draw_set_alpha(1.0);
        var _frame = floor(current_time / 140 + sub_img) mod sprite_get_number(spr_computer);
        var _tint  = is_fried ? make_color_rgb(255, 100, 100) : make_color_rgb(255, 250, 210);
        draw_sprite_ext(spr_computer, _frame, _cx, _by, 0.80, 0.70, 0, _tint, 1.0);

        // Subtle floating Clue Terminal indicator above monitor
        var _bob = sin(current_time / 170 + x) * 1.2;
        draw_set_alpha(0.38);
        draw_set_color(is_fried ? c_red : (talked_once ? c_lime : make_color_rgb(255, 205, 35)));
        draw_rectangle(_cx - 3, y - 11 + _bob, _cx + 3, y - 5 + _bob, false);
        draw_set_alpha(0.45);
        draw_set_color(c_black);
        draw_rectangle(_cx - 3, y - 11 + _bob, _cx + 3, y - 5 + _bob, true);
    } else if (is_server_rack) {
        // =========================================================
        // HIGH-YIELD PROTOTYPE SERVER TERMINAL (+3 Scrap in Encrypted Decoy Rooms!)
        // =========================================================
        var _spulse = 0.5 + 0.5 * sin(current_time / 140 + x);
        draw_set_alpha(0.10 + 0.05 * _spulse);
        draw_set_color(is_fried ? c_red : make_color_rgb(225, 85, 255));
        draw_circle(_cx, y + 10, 12, false);

        draw_set_alpha(0.95);
        draw_set_color(make_color_rgb(38, 20, 48));
        draw_rectangle(x, y + 3, x + 15, y + 15, false);
        draw_set_color(is_fried ? c_red : make_color_rgb(235, 110, 255));
        draw_rectangle(x, y + 3, x + 15, y + 15, true);

        var _sframe = floor(current_time / 120 + sub_img) mod sprite_get_number(spr_computer);
        var _stint  = is_fried ? make_color_rgb(255, 95, 95) : make_color_rgb(245, 195, 255);
        draw_sprite_ext(spr_computer, _sframe, _cx, _by, 0.80, 0.72, 0, _stint, 1.0);
    } else {
        // =========================================================
        // STANDARD CORPORATE PC (Right-Click with Wrench to Scrap!)
        // =========================================================
        draw_set_alpha(0.06);
        draw_set_color(is_fried ? c_red : make_color_rgb(65, 140, 180));
        draw_circle(_cx, y + 10, 9, false);

        // Standard Dark Slate Desk Base
        draw_set_alpha(0.90);
        draw_set_color(make_color_rgb(28, 34, 46));
        draw_rectangle(x + 1, y + 4, x + 14, y + 14, false);
        draw_set_color(is_fried ? c_red : make_color_rgb(55, 64, 82));
        draw_rectangle(x + 1, y + 4, x + 14, y + 14, true);

        // Monitor
        var _c_tint = is_fried ? make_color_rgb(255, 90, 90) : make_color_rgb(165, 180, 195);
        draw_sprite_ext(spr_computer, 0, _cx, _by, 0.72, 0.62, 0, _c_tint, 0.92);
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
    // Office Chair (spr_class_chair has bottom-center origin)
    draw_sprite_ext(spr_class_chair, 0, _cx, _by, 0.65, 0.45, 0, c_white, 1.0);
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

    // Industrial Breaker Cabinet Box
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
