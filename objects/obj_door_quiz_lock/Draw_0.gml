/// @description obj_door_quiz_lock — Draw Event
/// Renders an amber/gold cybersecurity-locked barrier tile.

// Check chunk fog alpha so door lock in unlit rooms/hallways stays completely dimmed under shadow!
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

var _x1 = draw_x;
var _y1 = draw_y;
var _x2 = _x1 + 15;
var _y2 = _y1 + 15;

if (locked) {
    var _pulse = 0.5 + 0.5 * sin(anim_t * 0.12);

    // Dark amber gate fill
    draw_set_alpha(0.92);
    draw_set_color(make_color_rgb(55, 38, 10));
    draw_rectangle(_x1, _y1, _x2, _y2, false);

    // Glowing gold security bars
    draw_set_alpha(0.85 + _pulse * 0.15);
    draw_set_color(make_color_rgb(255, 195, 35));
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    draw_line(_x1 + 2, _y1 + 7, _x2 - 2, _y1 + 7);
    draw_line(_x1 + 2, _y1 + 9, _x2 - 2, _y1 + 9);

    // Center lock node
    draw_set_color(make_color_rgb(255, 240, 120));
    draw_rectangle(_x1 + 6, _y1 + 5, _x1 + 9, _y1 + 10, false);
} else {
    // Unlocked threshold indicator
    draw_set_alpha(0.35);
    draw_set_color(c_lime);
    draw_rectangle(_x1 + 1, _y1 + 1, _x2 - 1, _y2 - 1, true);
}

draw_set_color(c_white);
draw_set_alpha(1.0);
