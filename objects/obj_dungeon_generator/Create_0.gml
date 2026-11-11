/// @description obj_dungeon_generator — Create Event
/// Curriculum-Driven Corporate Office Floor Generator (3 Chapters x 10 Floors):
///   - Floors 1-3: Guided Onboarding ("Hand-Holding" Tutorials; no drones on Flr 1-2)
///   - Floors 4-6: Core Duolingo-Style Practice
///   - Floors 7-9: Autonomous Mastery Practice (Training Wheels Off)
///   - Floor 10:   Chapter Final Exam

// ---- Seed RNG so every generated dungeon floor is unique ----
randomize();

// ---- Check if player is on Intern Babysitting Duty ----
is_intern_mode = (variable_global_exists("intern_duty_flagged") && global.intern_duty_flagged);
if (is_intern_mode) {
    visible      = false;
    gen_complete = true;
    scr_spawn_intern_ward();
    exit;
}

// Ensure music controller is active so dungeon BGM plays continuously across floors
if (!instance_exists(obj_music_controller)) {
    instance_create_depth(0, 0, 0, obj_music_controller);
}

// ---- Resolve Chapter (1..3) & Floor (1..10) Curriculum ----
if (!variable_global_exists("dungeon_chapter")) {
    global.dungeon_chapter = CHAPTER_CAESAR;
}
if (!variable_global_exists("chapter_floor")) {
    global.chapter_floor = 1;
}
global.chapter_floor    = clamp(global.chapter_floor, 1, CHAPTER_MAX_FLOORS);
global.dungeons_cleared = global.chapter_floor - 1;

curriculum              = scr_get_floor_curriculum(global.dungeon_chapter, global.chapter_floor);
global.floor_curriculum = curriculum;

// ---- Roll Chapter Cipher Key & Cyber Incident Case for this floor ----
global.dungeon_cipher_key     = scr_roll_cipher_key();
global.dungeon_vigenere_key   = scr_roll_vigenere_keyword(global.chapter_floor);
global.has_dungeon_cipher_key = false;
global.lockdown_overridden    = false;
global.power_restored         = false;
global.lockdown_lifted        = false;
global.elevator_room_found    = false;
global.override_ui_open       = false;
global.breaker_ui_open        = false;
global.override_prop_inst     = noone;
global.breaker_prop_inst      = noone;
global.cam_pan_phase          = "off";
global.cam_pan_mode           = "";
global.cam_pan_targets        = [];
scr_roll_holding_key_and_equation();
scr_init_facility_puzzles();
scr_init_floor_salvage_tasks();

// Floor 1 always teaches the Chapter's Cipher Keyword (Case 0: CAESAR / VIGENERE / ATBASH),
// and Floors 2..10 progress through Cases 1..9 so all 10 floors have a unique topic!
global.floor_case_index  = (global.chapter_floor - 1) mod 10;
global.floor_case        = scr_get_floor_incident_case(global.floor_case_index);
global.clues_found       = 0;
global.clues_needed      = curriculum.clues_needed;
scr_init_case_dossier(global.floor_case, global.chapter_floor);
global.pc_screen_open        = false;
global.pc_input_cooldown     = 0;
global.pc_screen_title       = "";
global.pc_screen_body    = "";
global.pc_screen_radar   = "";
global.pc_screen_badge   = "";
global.player_in_locker  = false;
global.active_locker_id  = noone;
global.holding_room_x    = 0;
global.holding_room_y    = 0;
global.holding_room_col  = 0;
global.holding_room_row  = 0;
global.floor_mentor_inst = noone;

// Ensure generator draws the room fog overlay above tiles/goal (20..50) and below Jack (-y)
visible = true;
depth   = 10;

// ---- Instance variables exposed for spawner, HUD & fog system ----
logic_map         = [];    // 2D array [col][row] of ROOM_* constants
room_fog_alpha    = [];    // 2D array [col][row] of fog alpha (0 = lit, 0.88 = normal fog, 1.0 = encrypted opaque fog)
room_discovered   = [];    // 2D array [col][row]: 0 = hidden, 1 = radar-detected, 2 = visited
room_is_encrypted = [];    // 2D array [col][row]: true if guarded by an encrypted cipher door (100% opaque fog until visited)
path_list         = [];    // All active chunks [col, row] (hallways + rooms)
door_links        = [];    // Explicit doorway connections: [c1, r1, c2, r2, door_tile_type]
ambient_sparks    = [];    // Floating digital dust / spark particles in active room
siren_timer             = 0;
banner_timer            = 210;   // Shows the Floor Intent Banner for ~3.5 seconds
intro_pending           = (array_length(curriculum.mentor_intro) > 0);
cutscene_clues_shown    = false;
cutscene_key_shown      = false;
cutscene_override_shown = false;
cutscene_power_shown    = false;
gen_complete            = false;
active_col              = 0;
active_row              = 0;

// ===========================================================================
// Step 1 — Initialise the logic map & fog alpha grid
// ===========================================================================
for (var _c = 0; _c < LOGIC_GRID_W; _c++) {
    logic_map[_c]         = [];
    room_fog_alpha[_c]    = [];
    room_discovered[_c]   = [];
    room_is_encrypted[_c] = [];
    for (var _r = 0; _r < LOGIC_GRID_H; _r++) {
        logic_map[_c][_r]         = ROOM_NONE;
        room_fog_alpha[_c][_r]    = 0.88;
        room_discovered[_c][_r]   = 0;
        room_is_encrypted[_c][_r] = false;
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

var _hallway_spine   = [[_hc, _hr]];
var _target_hall_len = irandom_range(curriculum.hall_min, curriculum.hall_max);

// Walk the hallway spine (mostly RIGHT with occasional UP/DOWN turns, keeping room for side rooms)
for (var _s = 1; _s < _target_hall_len; _s++) {
    var _cand_dirs = [
        [ 1,  0],
        [ 1,  0],
        [ 0, -1],
        [ 0,  1],
    ];
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
        if (_nc >= 1 && _nc <= LOGIC_GRID_W - 3 && _nr >= 2 && _nr <= LOGIC_GRID_H - 3) {
            if (logic_map[_nc][_nr] == ROOM_NONE) {
                logic_map[_nc][_nr] = ROOM_HALLWAY;
                array_push(path_list, [_nc, _nr]);
                array_push(_hallway_spine, [_nc, _nr]);
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
// Step 3 — Sprout a Secondary Hallway Branch Wing for Larger Floor Layouts
// ===========================================================================
var _all_hall_chunks = [];
for (var _hi = 0; _hi < array_length(_hallway_spine); _hi++) {
    array_push(_all_hall_chunks, _hallway_spine[_hi]);
}

if (array_length(_hallway_spine) >= 4) {
    var _branch_idx = floor(array_length(_hallway_spine) * 0.5);
    var _bc = _hallway_spine[_branch_idx][0];
    var _br = _hallway_spine[_branch_idx][1];
    var _b_dirs = [[0, -1], [0, 1], [1, 0]];
    var _branch_len = irandom_range(2, 3);

    for (var _bs = 0; _bs < _branch_len; _bs++) {
        var _b_placed = false;
        for (var _bd = 0; _bd < array_length(_b_dirs); _bd++) {
            var _bnc = _bc + _b_dirs[_bd][0];
            var _bnr = _br + _b_dirs[_bd][1];
            if (_bnc >= 2 && _bnc <= LOGIC_GRID_W - 3 && _bnr >= 2 && _bnr <= LOGIC_GRID_H - 3) {
                if (logic_map[_bnc][_bnr] == ROOM_NONE) {
                    logic_map[_bnc][_bnr] = ROOM_HALLWAY;
                    array_push(path_list, [_bnc, _bnr]);
                    array_push(_all_hall_chunks, [_bnc, _bnr]);
                    array_push(door_links, [_bc, _br, _bnc, _bnr, TILE_HALL_OPEN]);
                    _bc = _bnc;
                    _br = _bnr;
                    _b_placed = true;
                    break;
                }
            }
        }
        if (!_b_placed) break;
    }
}

// ===========================================================================
// Step 4 — Branch Objective, Encrypted Decoy & Filler Rooms off the Hallways
// ===========================================================================
var _side_candidates = [];
var _all_4_dirs = [
    [ 0, -1],
    [ 0,  1],
    [-1,  0],
    [ 1,  0],
];

// Drone patrols the primary hallway spine
var _hall_len = array_length(_hallway_spine);
hallway_waypoints = [];
for (var _hi = 0; _hi < _hall_len; _hi++) {
    var _sc = _hallway_spine[_hi][0];
    var _sr = _hallway_spine[_hi][1];
    array_push(hallway_waypoints, [
        _sc * CHUNK_SIZE * TILE_SIZE + 4 * TILE_SIZE,
        _sr * CHUNK_SIZE * TILE_SIZE + 4 * TILE_SIZE
    ]);
}

// Gather side-room candidate slots around all hallway segments (main spine + branch wing)
for (var _hi = 0; _hi < array_length(_all_hall_chunks); _hi++) {
    var _sc = _all_hall_chunks[_hi][0];
    var _sr = _all_hall_chunks[_hi][1];

    for (var _d = 0; _d < 4; _d++) {
        var _rc = _sc + _all_4_dirs[_d][0];
        var _rr = _sr + _all_4_dirs[_d][1];
        if (_rc >= 0 && _rc < LOGIC_GRID_W && _rr >= 0 && _rr < LOGIC_GRID_H) {
            if (logic_map[_rc][_rr] == ROOM_NONE) {
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

// Shuffle _side_candidates so rooms (including the Elevator & Encrypted Decoys) are distributed
// unpredictably across the floor — preventing the player from beelining straight to the Elevator!
for (var _i = array_length(_side_candidates) - 1; _i > 0; _i--) {
    var _j = irandom(_i);
    var _tmp = _side_candidates[_i];
    _side_candidates[_i] = _side_candidates[_j];
    _side_candidates[_j] = _tmp;
}

var _enc_decoys_target = variable_struct_exists(curriculum, "encrypted_decoys") ? curriculum.encrypted_decoys : 2;
var _enc_decoys_placed = 0;
var _normal_room_slots = [];

var _max_side_rooms = min(array_length(_side_candidates), curriculum.side_rooms);
for (var _i = 0; _i < _max_side_rooms; _i++) {
    var _h_col = _side_candidates[_i][0];
    var _h_row = _side_candidates[_i][1];
    var _r_col = _side_candidates[_i][2];
    var _r_row = _side_candidates[_i][3];

    var _rtype        = ROOM_NORMAL;
    var _dtype        = TILE_DOOR;
    var _is_encrypted = false;

    if (_i == 0) {
        // Stage 1: Key Vault (locked by a Cybersecurity Question)
        _rtype = ROOM_CAESAR_KEY;
        _dtype = TILE_LOCK_QUIZ;
    } else if (_i == 1) {
        // Stage 2: Security Control Room (locked by an Encrypted Door, contains the Lockdown Override Console)
        _rtype        = ROOM_CAESAR_LOCKED;
        _dtype        = TILE_LOCK_CAESAR;
        _is_encrypted = true;
    } else if (_i == 2) {
        // Stage 3: Control Break / Electrical Breaker Room (sealed during lockdown; unlocks when Override Button is pressed!)
        _rtype = ROOM_POWER;
        _dtype = TILE_LOCK_CAESAR;
    } else if (_i == 3) {
        // Stage 4: Extraction Elevator Room (shuffled among the encrypted doors so player must explore encrypted rooms to find it!)
        _rtype        = ROOM_END;
        _dtype        = TILE_LOCK_CAESAR;
        _is_encrypted = true;
    } else if (_i == 4 && curriculum.spawn_drone) {
        // When drones are active (Floors 3..10), include the Security Holding Cell / Brig
        _rtype = ROOM_HOLDING;
        _dtype = TILE_LOCK_CAESAR;
    } else if (_enc_decoys_placed < _enc_decoys_target) {
        // Encrypted Decoy / Mystery Room (guarded by an identical Encrypted Door & 100% opaque fog!)
        _rtype        = ROOM_NORMAL;
        _dtype        = TILE_LOCK_CAESAR;
        _is_encrypted = true;
        _enc_decoys_placed++;
    } else {
        // Standard Open-Door Office / Filler Room
        _rtype = ROOM_NORMAL;
        _dtype = TILE_DOOR;
        array_push(_normal_room_slots, [_r_col, _r_row]);
    }

    logic_map[_r_col][_r_row]         = _rtype;
    room_is_encrypted[_r_col][_r_row] = _is_encrypted;
    room_fog_alpha[_r_col][_r_row]    = _is_encrypted ? 1.0 : 0.88;
    array_push(path_list, [_r_col, _r_row]);
    array_push(door_links, [_h_col, _h_row, _r_col, _r_row, _dtype]);
}

// ===========================================================================
// Step 5 — Multi-Chunk Long Rooms (TILE_ROOM_MERGE) & Filler Annex Extensions
// ===========================================================================
var _ext_target = variable_struct_exists(curriculum, "room_extensions") ? curriculum.room_extensions : 4;
var _ext_placed = 0;

for (var _ni = 0; _ni < array_length(_normal_room_slots) && _ext_placed < _ext_target; _ni++) {
    var _base_c = _normal_room_slots[_ni][0];
    var _base_r = _normal_room_slots[_ni][1];

    // Shuffle cardinal directions so long rooms extend both horizontally (18x9) and vertically (9x18)
    for (var _di = 3; _di > 0; _di--) {
        var _dj  = irandom(_di);
        var _dtmp = _all_4_dirs[_di];
        _all_4_dirs[_di] = _all_4_dirs[_dj];
        _all_4_dirs[_dj] = _dtmp;
    }

    for (var _d = 0; _d < 4; _d++) {
        var _ec = _base_c + _all_4_dirs[_d][0];
        var _er = _base_r + _all_4_dirs[_d][1];
        if (_ec >= 1 && _ec < LOGIC_GRID_W - 1 && _er >= 1 && _er < LOGIC_GRID_H - 1) {
            if (logic_map[_ec][_er] == ROOM_NONE) {
                logic_map[_ec][_er]         = ROOM_NORMAL;
                room_is_encrypted[_ec][_er] = false;
                room_fog_alpha[_ec][_er]    = 0.88;
                array_push(path_list, [_ec, _er]);

                // 70% chance to merge seamlessly into a 2-chunk Long Room (18x9 or 9x18),
                // 30% chance to connect via an interior doorway as a Filler Annex Room!
                var _link_type = (irandom(99) < 70) ? TILE_ROOM_MERGE : TILE_DOOR;
                array_push(door_links, [_base_c, _base_r, _ec, _er, _link_type]);
                array_push(_normal_room_slots, [_ec, _er]);
                _ext_placed++;
                break;
            }
        }
    }
}

gen_complete = true;
show_debug_message(
    "[obj_dungeon_generator] Ch." + string(global.dungeon_chapter) +
    " Floor " + string(global.chapter_floor) + "/10 (" + curriculum.phase_name + ") generated."
);

// ===========================================================================
// Step 5 — Invoke the spawner to build the physical dungeon
// ===========================================================================
scr_dungeon_spawn(logic_map, path_list);
