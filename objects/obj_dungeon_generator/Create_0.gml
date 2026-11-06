/// @description obj_dungeon_generator — Create Event
/// Apartment / Corporate Office Floor Generator:
///   1. Places ROOM_START (Reception Lobby) at (0, 5).
///   2. Generates a connected Hallway Spine (ROOM_HALLWAY chunks) across the grid.
///   3. Places ROOM_END (Extraction Elevator) at the far end of the Hallway Spine
///      behind a Caesar Cipher Lock (TILE_LOCK_CAESAR).
///   4. Branches individual rooms off the sides of the Hallway Spine:
///        - 1 ROOM_CAESAR_KEY (locked by TILE_LOCK_QUIZ, contains Caesar Key)
///        - 1-2 ROOM_CAESAR_LOCKED (locked by TILE_LOCK_CAESAR)
///        - 3-5 ROOM_NORMAL (varied office/apartment rooms with TILE_DOOR)
///      Rooms only connect to the Hallway Spine (never directly to adjacent rooms).

// ---- Seed RNG so every generated dungeon floor is unique ----
randomize();

// Ensure music controller is active so dungeon BGM plays continuously across floors
if (!instance_exists(obj_music_controller)) {
    instance_create_depth(0, 0, 0, obj_music_controller);
}

// ---- Roll a fresh Caesar shift key & Cyber Incident Case for this dungeon floor ----
global.dungeon_cipher_key     = scr_roll_cipher_key();
global.has_dungeon_cipher_key = false;
global.lockdown_lifted        = false;
scr_roll_holding_key_and_equation();
if (!variable_global_exists("dungeons_cleared")) {
    global.dungeons_cleared = 0;
}
if (!variable_global_exists("case_start_offset")) {
    global.case_start_offset = irandom(6);
}
global.floor_case_index = (global.case_start_offset + global.dungeons_cleared) mod 7;
global.floor_case       = scr_get_floor_incident_case(global.floor_case_index);
global.clues_found      = 0;
global.clues_needed     = 2;
global.pc_screen_open   = false;
global.pc_screen_title  = "";
global.pc_screen_body   = "";
global.pc_screen_radar  = "";
global.pc_screen_badge  = "";
global.player_in_locker = false;
global.active_locker_id = noone;
global.holding_room_x   = 0;
global.holding_room_y   = 0;
global.holding_room_col = 0;
global.holding_room_row = 0;

// Ensure generator draws the room fog overlay above tiles/goal (20..50) and below Jack (-y)
visible = true;
depth   = 10;

// ---- Instance variables exposed for spawner & fog system ----
logic_map       = [];    // 2D array [col][row] of ROOM_* constants
room_fog_alpha  = [];    // 2D array [col][row] of fog alpha (0 = lit, 0.90 = darkened)
room_discovered = [];    // 2D array [col][row]: 0 = hidden, 1 = radar-detected, 2 = visited
path_list       = [];    // All active chunks [col, row] (hallways + rooms)
door_links      = [];    // Explicit doorway connections: [c1, r1, c2, r2, door_tile_type]
ambient_sparks  = [];    // Floating digital dust / spark particles in active room
siren_timer     = 0;
gen_complete    = false;
active_col      = 0;
active_row      = 0;

// ===========================================================================
// Step 1 — Initialise the logic map & fog alpha grid
// ===========================================================================
for (var _c = 0; _c < LOGIC_GRID_W; _c++) {
    logic_map[_c]       = [];
    room_fog_alpha[_c]  = [];
    room_discovered[_c] = [];
    for (var _r = 0; _r < LOGIC_GRID_H; _r++) {
        logic_map[_c][_r]       = ROOM_NONE;
        room_fog_alpha[_c][_r]  = 0.88;
        room_discovered[_c][_r] = 0;
    }
}

// Initialise floating ambient particles (local offsets within a 144x144 chunk)
for (var _p = 0; _p < 18; _p++) {
    array_push(ambient_sparks, {
        lx:  irandom_range(20, 124),
        ly:  irandom_range(20, 124),
        vx:  random_range(-0.25, 0.25),
        vy:  random_range(-0.45, -0.15),
        col: choose(c_aqua, make_color_rgb(255, 80, 95), make_color_rgb(255, 210, 60)),
        sz:  choose(1, 1.5)
    });
}

// ===========================================================================
// Step 2 — Place ROOM_START & build the Central Hallway Spine
// ===========================================================================
var _start_col = 0;
var _start_row = floor(LOGIC_GRID_H / 2); // (0, 5)

logic_map[_start_col][_start_row]       = ROOM_START;
room_fog_alpha[_start_col][_start_row]  = 0.0;
room_discovered[_start_col][_start_row] = 2;
active_col = _start_col;
active_row = _start_row;
array_push(path_list, [_start_col, _start_row]);

// First hallway segment directly to the right of Start Room at (1, 5)
var _hc = 1;
var _hr = _start_row;
logic_map[_hc][_hr] = ROOM_HALLWAY;
array_push(path_list, [_hc, _hr]);
array_push(door_links, [_start_col, _start_row, _hc, _hr, TILE_DOOR]);

var _hallway_spine = [[_hc, _hr]];
var _target_hall_len = irandom_range(4, 6);

// Walk the hallway spine (mostly RIGHT with occasional UP/DOWN turns, keeping room for side rooms)
for (var _s = 1; _s < _target_hall_len; _s++) {
    // Weight RIGHT higher so the hallway feels like a long building corridor
    var _cand_dirs = [
        [ 1,  0],
        [ 1,  0],
        [ 0, -1],
        [ 0,  1],
    ];
    // Shuffle candidate directions
    for (var _i = 3; _i > 0; _i--) {
        var _j = irandom(_i);
        var _tmp = _cand_dirs[_i];
        _cand_dirs[_i] = _cand_dirs[_j];
        _cand_dirs[_j] = _tmp;
    }

    var _placed_seg = false;
    for (var _d = 0; _d < 4; _d++) {
        var _nc = _hc + _cand_dirs[_d][0];
        var _nr = _hr + _cand_dirs[_d][1];
        // Keep hallway within rows 2..7 and cols 1..7 so side rooms always fit on the grid
        if (_nc >= 1 && _nc <= LOGIC_GRID_W - 3 && _nr >= 2 && _nr <= LOGIC_GRID_H - 3) {
            if (logic_map[_nc][_nr] == ROOM_NONE) {
                logic_map[_nc][_nr] = ROOM_HALLWAY;
                array_push(path_list, [_nc, _nr]);
                array_push(_hallway_spine, [_nc, _nr]);
                // Seamless open hallway connection between adjacent hallway segments
                array_push(door_links, [_hc, _hr, _nc, _nr, TILE_HALL_OPEN]);
                _hc = _nc;
                _hr = _nr;
                _placed_seg = true;
                break;
            }
        }
    }
    if (!_placed_seg) break;
}

// ===========================================================================
// Step 3 — Place ROOM_END (Extraction Elevator) at the end of the Hallway Spine
// ===========================================================================
var _end_dirs = [
    [ 1,  0], // Prefer placing the elevator straight ahead at the right end of the hall
    [ 0, -1],
    [ 0,  1],
    [-1,  0],
];
var _end_placed = false;
for (var _hi = array_length(_hallway_spine) - 1; _hi >= 0 && !_end_placed; _hi--) {
    var _ehc = _hallway_spine[_hi][0];
    var _ehr = _hallway_spine[_hi][1];
    for (var _d = 0; _d < 4; _d++) {
        var _ec = _ehc + _end_dirs[_d][0];
        var _er = _ehr + _end_dirs[_d][1];
        if (_ec >= 0 && _ec < LOGIC_GRID_W && _er >= 0 && _er < LOGIC_GRID_H) {
            if (logic_map[_ec][_er] == ROOM_NONE) {
                logic_map[_ec][_er] = ROOM_END;
                array_push(path_list, [_ec, _er]);
                // Guard the Elevator entrance with a Caesar Cipher Lock so the player must find the Key!
                array_push(door_links, [_ehc, _ehr, _ec, _er, TILE_LOCK_CAESAR]);
                _end_placed = true;
                break;
            }
        }
    }
}

// ===========================================================================
// Step 4 — Branch Apartment / Office Rooms off the sides of the Hallway Spine
// ===========================================================================
var _side_candidates = []; // Each entry: [hall_col, hall_row, room_col, room_row]
var _all_4_dirs = [
    [ 0, -1], // Top side of hallway
    [ 0,  1], // Bottom side of hallway
    [-1,  0], // Left side of hallway
    [ 1,  0], // Right side of hallway
];

var _hall_len = array_length(_hallway_spine);
hallway_waypoints = [];
for (var _hi = 0; _hi < _hall_len; _hi++) {
    var _sc = _hallway_spine[_hi][0];
    var _sr = _hallway_spine[_hi][1];
    // Store exact center-tile top-left (tile 4,4 = +64,+64 so +8,+8 is exact chunk center 72,72)
    array_push(hallway_waypoints, [
        _sc * CHUNK_SIZE * TILE_SIZE + 4 * TILE_SIZE,
        _sr * CHUNK_SIZE * TILE_SIZE + 4 * TILE_SIZE
    ]);

    for (var _d = 0; _d < 4; _d++) {
        var _rc = _sc + _all_4_dirs[_d][0];
        var _rr = _sr + _all_4_dirs[_d][1];
        if (_rc >= 0 && _rc < LOGIC_GRID_W && _rr >= 0 && _rr < LOGIC_GRID_H) {
            if (logic_map[_rc][_rr] == ROOM_NONE) {
                // Temporarily mark reserved so we don't add duplicates to _side_candidates
                logic_map[_rc][_rr] = -2;
                array_push(_side_candidates, [_sc, _sr, _rc, _rr]);
            }
        }
    }
}

// Reset temporary -2 markers back to ROOM_NONE
for (var _i = 0; _i < array_length(_side_candidates); _i++) {
    var _rc = _side_candidates[_i][2];
    var _rr = _side_candidates[_i][3];
    logic_map[_rc][_rr] = ROOM_NONE;
}

// Shuffle _side_candidates so rooms are distributed organically along the hallway
for (var _i = array_length(_side_candidates) - 1; _i > 0; _i--) {
    var _j = irandom(_i);
    var _tmp = _side_candidates[_i];
    _side_candidates[_i] = _side_candidates[_j];
    _side_candidates[_j] = _tmp;
}

var _max_side_rooms = min(array_length(_side_candidates), irandom_range(5, 7));
for (var _i = 0; _i < _max_side_rooms; _i++) {
    var _h_col = _side_candidates[_i][0];
    var _h_row = _side_candidates[_i][1];
    var _r_col = _side_candidates[_i][2];
    var _r_row = _side_candidates[_i][3];

    var _rtype = ROOM_NORMAL;
    var _dtype = TILE_DOOR;

    if (_i == 0) {
        // First side room is ALWAYS the Caesar Key Vault (locked by a Cybersecurity Question)
        _rtype = ROOM_CAESAR_KEY;
        _dtype = TILE_LOCK_QUIZ;
    } else if (_i == 1) {
        // Second side room is the Security Holding Cell / Brig (locked by its own Caesar Cipher key!)
        _rtype = ROOM_HOLDING;
        _dtype = TILE_LOCK_CAESAR;
    } else if (_i == 2) {
        // Third side room is a Caesar Cipher-Locked Mainframe Room
        _rtype = ROOM_CAESAR_LOCKED;
        _dtype = TILE_LOCK_CAESAR;
    }

    logic_map[_r_col][_r_row] = _rtype;
    array_push(path_list, [_r_col, _r_row]);
    // Connect this room ONLY to its hallway segment (never to adjacent rooms!)
    array_push(door_links, [_h_col, _h_row, _r_col, _r_row, _dtype]);
}

gen_complete = true;
show_debug_message(
    "[obj_dungeon_generator] Apartment/Office Hallway Floor generated: " +
    string(_hall_len) + " hallway segments, " +
    string(_max_side_rooms) + " side rooms + Start + Elevator."
);

// ===========================================================================
// Step 5 — Invoke the spawner to build the physical dungeon
// ===========================================================================
scr_dungeon_spawn(logic_map, path_list);
