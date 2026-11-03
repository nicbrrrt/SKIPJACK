/// @description obj_dungeon_generator — Step Event
/// Tracks which room chunk the player (obj_jack) is currently inside,
/// updates fog-of-war alpha, reveals rooms on the Floor Blueprint Radar,
/// and animates lockdown siren & floating ambient particles.

if (!gen_complete) exit;

siren_timer++;

var _chunk_px = CHUNK_SIZE * TILE_SIZE; // 9 * 16 = 144 px per chunk

if (instance_exists(obj_jack)) {
    var _new_col = clamp(floor(obj_jack.x / _chunk_px), 0, LOGIC_GRID_W - 1);
    var _new_row = clamp(floor((obj_jack.y - 4) / _chunk_px), 0, LOGIC_GRID_H - 1);

    // Play an electronic doorway sensor chime when stepping between a room and the hallway
    if (_new_col != active_col || _new_row != active_row) {
        var _old_type = logic_map[active_col][active_row];
        var _new_type = logic_map[_new_col][_new_row];
        if (!(_old_type == ROOM_HALLWAY && _new_type == ROOM_HALLWAY)) {
            var _door_snd = audio_play_sound(snd_button_hover, 2, false);
            audio_sound_gain(_door_snd, 0.45, 0);
            audio_sound_pitch(_door_snd, (_new_type == ROOM_HALLWAY) ? 0.95 : 1.20);
        }
        active_col = _new_col;
        active_row = _new_row;
    }
}

var _in_hallway      = (logic_map[active_col][active_row] == ROOM_HALLWAY);
var _lockdown_lifted = (variable_global_exists("lockdown_lifted") && global.lockdown_lifted);
var _total_rooms     = array_length(path_list);

for (var _i = 0; _i < _total_rooms; _i++) {
    var _c = path_list[_i][0];
    var _r = path_list[_i][1];
    var _rtype = logic_map[_c][_r];

    var _is_lit = _lockdown_lifted || (_c == active_col && _r == active_row) || (_in_hallway && _rtype == ROOM_HALLWAY);
    var _target_alpha = _is_lit ? 0.0 : 0.96;

    if (_is_lit) {
        room_discovered[_c][_r] = 2; // Visited / Lit
    }

    room_fog_alpha[_c][_r] = lerp(room_fog_alpha[_c][_r], _target_alpha, 0.22);

    if (abs(room_fog_alpha[_c][_r] - _target_alpha) < 0.01) {
        room_fog_alpha[_c][_r] = _target_alpha;
    }
}

// Reveal any room connected to a visited room as radar-detected (1) on the blueprint
var _link_len = array_length(door_links);
for (var _l = 0; _l < _link_len; _l++) {
    var _lnk = door_links[_l];
    var _c1 = _lnk[0], _r1 = _lnk[1];
    var _c2 = _lnk[2], _r2 = _lnk[3];
    if (room_discovered[_c1][_r1] == 2 && room_discovered[_c2][_r2] == 0) {
        room_discovered[_c2][_r2] = 1;
    }
    if (room_discovered[_c2][_r2] == 2 && room_discovered[_c1][_r1] == 0) {
        room_discovered[_c1][_r1] = 1;
    }
}
