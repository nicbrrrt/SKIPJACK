/// @description obj_dungeon_prop — Draw Event
/// Draws corporate office props (visually distinguishing Clue Terminals from standard PCs),
/// chairs, scattered papers, stranded coworker NPCs, and hallway-wide laser security drones.

var _cx     = x + 8;
var _by     = y + 15;
var _lifted = (variable_global_exists("lockdown_lifted") && global.lockdown_lifted);

if (prop_type == TILE_PROP_PC) {
    if (has_clue) {
        // =========================================================
        // CLUE TERMINAL (Visually distinct Gold/Cyan Forensic Desk)
        // =========================================================
        var _pulse = 0.5 + 0.5 * sin(current_time / 160 + x);

        // Bright golden/emerald screen light pool on floor
        draw_set_alpha(0.22 + 0.12 * _pulse);
        draw_set_color(talked_once ? c_lime : make_color_rgb(255, 210, 45));
        draw_circle(_cx, y + 10, 14, false);

        // Forensic Gold-Trimmed Desk Base
        draw_set_alpha(0.98);
        draw_set_color(make_color_rgb(55, 45, 22));
        draw_rectangle(x, y + 3, x + 15, y + 15, false);
        draw_set_color(talked_once ? c_lime : make_color_rgb(255, 205, 40));
        draw_rectangle(x, y + 3, x + 15, y + 15, true);

        // Animated Computer Terminal with bright highlight tint
        var _frame = floor(current_time / 140 + sub_img) mod sprite_get_number(spr_computer);
        draw_sprite_ext(spr_computer, _frame, _cx, _by, 0.80, 0.70, 0, make_color_rgb(255, 250, 210), 1.0);

        // Floating bobbing Clue Terminal Beacon above monitor
        var _bob = sin(current_time / 170 + x) * 1.5;
        draw_set_alpha(0.92);
        draw_set_color(talked_once ? c_lime : make_color_rgb(255, 205, 35));
        draw_rectangle(_cx - 4, y - 12 + _bob, _cx + 4, y - 4 + _bob, false);
        draw_set_color(c_black);
        draw_rectangle(_cx - 4, y - 12 + _bob, _cx + 4, y - 4 + _bob, true);
    } else {
        // =========================================================
        // STANDARD DECORATIVE OFFICE PC (Muted, non-interactive)
        // =========================================================
        draw_set_alpha(0.06);
        draw_set_color(make_color_rgb(65, 140, 180));
        draw_circle(_cx, y + 10, 9, false);

        // Standard Dark Slate Desk Base
        draw_set_alpha(0.90);
        draw_set_color(make_color_rgb(28, 34, 46));
        draw_rectangle(x + 1, y + 4, x + 14, y + 14, false);
        draw_set_color(make_color_rgb(55, 64, 82));
        draw_rectangle(x + 1, y + 4, x + 14, y + 14, true);

        // Dimmed static/slow monitor
        draw_sprite_ext(spr_computer, 0, _cx, _by, 0.72, 0.62, 0, make_color_rgb(150, 160, 175), 0.90);
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

    // Floating status badge above NPC head (! when unvisited, green dot when all clear)
    var _bob = sin(current_time / 180 + x) * 1.5;
    if (!talked_once || _lifted) {
        draw_set_alpha(0.90);
        draw_set_color(_lifted ? c_lime : make_color_rgb(255, 215, 50));
        draw_circle(_cx, y - 16 + _bob, 3.5, false);
        draw_set_color(c_black);
        draw_circle(_cx, y - 16 + _bob, 3.5, true);
    }
}
else if (prop_type == TILE_PROP_LOCKER) {
    // =========================================================
    // HIGH-CONTRAST HALLWAY SECURITY LOCKER (Easy to spot in blackout!)
    // =========================================================
    var _is_occupied = (variable_global_exists("player_in_locker") && global.player_in_locker && global.active_locker_id == id);

    // Bright cyan/gold floor light pool so locker stands out from the floor
    draw_set_alpha(0.28);
    draw_set_color(_is_occupied ? c_lime : c_aqua);
    draw_circle(_cx, y + 8, 12, false);

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
else if (prop_type == TILE_PROP_DRONE) {
    var _cy      = y + 8;
    var _hover_y = _lifted ? 0 : (sin(hover_t) * 2.5);

    // =========================================================
    // REAL-TIME 2D RAYCAST FLASHLIGHT BEAM (Wraps around corners & walls!)
    // =========================================================
    if (!_lifted) {
        var _base_dir  = point_direction(0, 0, patrol_vx, patrol_vy);
        var _scan_dir  = _base_dir + sin(hover_t * 0.90) * 18;
        var _max_dist  = 94;
        var _half_fov  = 32;
        var _num_rays  = 24;

        // Soft flashlight glow around the drone lens itself
        draw_set_alpha(0.22);
        draw_set_color(make_color_rgb(255, 210, 120));
        draw_circle(_cx, _cy, 12, false);

        // Outer Raycast Flashlight Fan (clips against walls & spills into open doorway alcoves!)
        draw_primitive_begin(pr_trianglefan);
        draw_vertex_color(_cx, _cy, make_color_rgb(255, 235, 165), 0.42);

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
            draw_vertex_color(_rx, _ry, make_color_rgb(255, 65, 55), 0.14);
        }
        draw_primitive_end();
    } else {
        // Powered-down standby ring
        draw_set_alpha(0.25);
        draw_set_color(c_lime);
        draw_circle(_cx, y + 10, 9, false);
    }

    // Draw Rogue Virus / Security Drone sprite centered in the hallway
    var _dframe = _lifted ? 0 : (floor(current_time / 120) mod max(1, sprite_get_number(drone_spr)));
    var _dtint  = _lifted ? make_color_rgb(150, 220, 175) : c_white;
    draw_sprite_ext(drone_spr, _dframe, _cx, y + 6 + _hover_y, 0.42, 0.42, 0, _dtint, 1.0);
}

// Floating [E] indicator directly over the prop when Jack is within range
if (player_near) {
    var _ey = (prop_type == TILE_PROP_NPC) ? (y - 24) : (y - 16);
    draw_set_alpha(0.88);
    draw_set_color(make_color_rgb(10, 16, 26));
    draw_rectangle(_cx - 7, _ey - 5, _cx + 7, _ey + 5, false);
    draw_set_alpha(1.0);
    draw_set_color(c_aqua);
    draw_rectangle(_cx - 7, _ey - 5, _cx + 7, _ey + 5, true);
}

draw_set_color(c_white);
draw_set_alpha(1.0);
