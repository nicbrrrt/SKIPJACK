/// @description obj_dungeon_generator — Step Event
/// Tracks which room chunk the player (obj_jack) is currently inside
/// and smoothly updates the fog-of-war alpha for each room.
/// When Jack is in the Hallway (ROOM_HALLWAY), the entire connected Hallway Spine
/// lights up together while individual rooms remain darkened behind their doors!

if (!gen_complete) exit;

var _chunk_px = CHUNK_SIZE * TILE_SIZE; // 9 * 16 = 144 px per chunk

if (instance_exists(obj_jack)) {
    active_col = clamp(floor(obj_jack.x / _chunk_px), 0, LOGIC_GRID_W - 1);
    active_row = clamp(floor((obj_jack.y - 4) / _chunk_px), 0, LOGIC_GRID_H - 1);
}

var _in_hallway  = (logic_map[active_col][active_row] == ROOM_HALLWAY);
var _total_rooms = array_length(path_list);

for (var _i = 0; _i < _total_rooms; _i++) {
    var _c = path_list[_i][0];
    var _r = path_list[_i][1];
    var _rtype = logic_map[_c][_r];

    var _is_lit = (_c == active_col && _r == active_row) || (_in_hallway && _rtype == ROOM_HALLWAY);
    var _target_alpha = _is_lit ? 0.0 : 0.90;

    room_fog_alpha[_c][_r] = lerp(room_fog_alpha[_c][_r], _target_alpha, 0.22);

    if (abs(room_fog_alpha[_c][_r] - _target_alpha) < 0.01) {
        room_fog_alpha[_c][_r] = _target_alpha;
    }
}
