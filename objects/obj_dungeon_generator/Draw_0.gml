/// @description obj_dungeon_generator — Draw Event
/// Darkens / greys out all dungeon rooms except the room the player is currently in,
/// and highlights special room types (ROOM_CAESAR_KEY, ROOM_CAESAR_LOCKED).

if (!gen_complete) exit;

var _chunk_px    = CHUNK_SIZE * TILE_SIZE; // 144 px per room
var _total_rooms = array_length(path_list);

for (var _i = 0; _i < _total_rooms; _i++) {
    var _c = path_list[_i][0];
    var _r = path_list[_i][1];
    var _rtype = logic_map[_c][_r];

    var _x1 = _c * _chunk_px;
    var _y1 = _r * _chunk_px;
    var _x2 = _x1 + _chunk_px - 1;
    var _y2 = _y1 + _chunk_px - 1;

    var _alpha = room_fog_alpha[_c][_r];

    // If this room is currently active/visible, draw a subtle themed interior frame for special rooms
    if (_alpha < 0.5) {
        if (_rtype == ROOM_CAESAR_KEY) {
            draw_set_alpha((1.0 - _alpha) * 0.45);
            draw_set_color(make_color_rgb(255, 195, 35));
            draw_rectangle(_x1 + 16, _y1 + 16, _x2 - 16, _y2 - 16, true);
        } else if (_rtype == ROOM_CAESAR_LOCKED) {
            draw_set_alpha((1.0 - _alpha) * 0.45);
            draw_set_color(make_color_rgb(255, 65, 125));
            draw_rectangle(_x1 + 16, _y1 + 16, _x2 - 16, _y2 - 16, true);
        }
    }

    if (_alpha <= 0.01) continue;

    // Darkened slate shroud over inactive rooms
    draw_set_alpha(_alpha);
    draw_set_color(make_color_rgb(12, 14, 20));
    draw_rectangle(_x1, _y1, _x2, _y2, false);

    // Subtle muted border tint on shrouded rooms (color-coded slightly for special rooms)
    draw_set_alpha(_alpha * 0.30);
    if (_rtype == ROOM_CAESAR_KEY) {
        draw_set_color(make_color_rgb(120, 95, 30));
    } else if (_rtype == ROOM_CAESAR_LOCKED) {
        draw_set_color(make_color_rgb(120, 35, 65));
    } else {
        draw_set_color(make_color_rgb(45, 52, 66));
    }
    draw_rectangle(_x1 + 2, _y1 + 2, _x2 - 2, _y2 - 2, true);
}

draw_set_color(c_white);
draw_set_alpha(1.0);
