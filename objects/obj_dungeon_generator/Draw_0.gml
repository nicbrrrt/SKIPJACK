/// @description obj_dungeon_generator — Draw Event
/// Darkens / greys out all dungeon rooms except the room the player is currently in.

if (!gen_complete) exit;

var _chunk_px    = CHUNK_SIZE * TILE_SIZE; // 144 px per room
var _total_rooms = array_length(path_list);

for (var _i = 0; _i < _total_rooms; _i++) {
    var _c = path_list[_i][0];
    var _r = path_list[_i][1];

    var _alpha = room_fog_alpha[_c][_r];
    if (_alpha <= 0.01) continue;

    var _x1 = _c * _chunk_px;
    var _y1 = _r * _chunk_px;
    var _x2 = _x1 + _chunk_px - 1;
    var _y2 = _y1 + _chunk_px - 1;

    // Darkened slate shroud over inactive rooms
    draw_set_alpha(_alpha);
    draw_set_color(make_color_rgb(12, 14, 20));
    draw_rectangle(_x1, _y1, _x2, _y2, false);

    // Subtle muted grey inner tint so the room reads as greyed-out/inactive
    draw_set_alpha(_alpha * 0.25);
    draw_set_color(make_color_rgb(45, 52, 66));
    draw_rectangle(_x1 + 2, _y1 + 2, _x2 - 2, _y2 - 2, true);
}

draw_set_color(c_white);
draw_set_alpha(1.0);
