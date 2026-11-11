/// @description obj_doorway — Draw Event
/// Renders a Corporate Automatic Sliding Door matching the visual style of the facility's locked doors.
/// Uses a brushed steel frame, sliding door leaves, and a green/teal "UNLOCKED" status indicator.

if (has_lock_overlay) {
    // Locked doors (obj_door_quiz_lock / obj_door_caesar_lock) render their own security gate on top
    exit;
}

// Check chunk fog alpha so doorways in unlit rooms/hallways stay completely dimmed under shadow!
var _chunk_c = x div 144;
var _chunk_r = y div 144;
var _fog = 0.0;

if (instance_exists(obj_dungeon_generator) && variable_instance_exists(obj_dungeon_generator, "room_fog_alpha")) {
    if (_chunk_c >= 0 && _chunk_c < LOGIC_GRID_W && _chunk_r >= 0 && _chunk_r < LOGIC_GRID_H) {
        if (is_array(obj_dungeon_generator.room_fog_alpha) && array_length(obj_dungeon_generator.room_fog_alpha) > _chunk_c) {
            _fog = obj_dungeon_generator.room_fog_alpha[_chunk_c][_chunk_r];
        }
    }
}

var _vis = clamp((0.85 - _fog) / 0.85, 0.0, 1.0);
if (_vis <= 0.01) {
    exit;
}

var _x1 = x;
var _y1 = y;
var _x2 = _x1 + 15;
var _y2 = _y1 + 15;

// 1. Brushed steel threshold plate beneath the door
draw_set_alpha(0.55 * _vis);
draw_set_color(make_color_rgb(24, 34, 48));
draw_rectangle(_x1, _y1, _x2, _y2, false);
draw_set_alpha(0.45 * _vis);
draw_set_color(make_color_rgb(65, 95, 130));
draw_rectangle(_x1, _y1, _x2, _y2, true);

// 2. Sliding door leaves (retract toward the edges as open_amt -> 1.0)
var _slide = round(open_amt * 6);
var _leaf_w = 7 - _slide;

if (_leaf_w > 0) {
    var _pulse = 0.5 + 0.5 * sin(anim_t * 0.08);

    // Left & Right sliding steel/glass door leaves
    draw_set_alpha(0.90 * _vis);
    draw_set_color(make_color_rgb(22, 36, 54));
    draw_rectangle(_x1 + 1, _y1 + 2, _x1 + _leaf_w, _y2 - 2, false);
    draw_rectangle(_x2 - _leaf_w, _y1 + 2, _x2 - 1, _y2 - 2, false);

    // Metallic door frame & horizontal reinforcement rails (matches Key Vault / Breaker door style)
    draw_set_alpha((0.85 + _pulse * 0.15) * _vis);
    draw_set_color(make_color_rgb(75, 165, 215));
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    draw_line(_x1 + 1, _y1 + 6, _x1 + _leaf_w, _y1 + 6);
    draw_line(_x1 + 1, _y1 + 9, _x1 + _leaf_w, _y1 + 9);
    draw_line(_x2 - _leaf_w, _y1 + 6, _x2 - 1, _y1 + 6);
    draw_line(_x2 - _leaf_w, _y1 + 9, _x2 - 1, _y1 + 9);

    // Center seam & green/teal "UNLOCKED OFFICE DOOR" status LED node when closed
    if (_slide <= 2) {
        draw_set_color(make_color_rgb(40, 65, 90));
        draw_line(_x1 + 8, _y1 + 2, _x1 + 8, _y2 - 2);

        draw_set_color(make_color_rgb(75, 240, 155));
        draw_rectangle(_x1 + 6, _y1 + 5, _x1 + 9, _y1 + 10, false);
    }
} else {
    // Fully open doorway: glowing green sensor side jambs
    draw_set_alpha(0.75 * _vis);
    draw_set_color(make_color_rgb(75, 240, 155));
    draw_rectangle(_x1, _y1 + 1, _x1 + 1, _y2 - 1, false);
    draw_rectangle(_x2 - 1, _y1 + 1, _x2, _y2 - 1, false);
}

draw_set_color(c_white);
draw_set_alpha(1.0);
