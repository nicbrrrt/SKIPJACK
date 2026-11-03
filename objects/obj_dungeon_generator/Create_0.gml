/// @description obj_dungeon_generator — Create Event
/// Grid-walker dungeon generation algorithm.
///
/// FLOW:
///   1. Initialise a LOGIC_GRID_W x LOGIC_GRID_H grid filled with ROOM_NONE.
///   2. Place ROOM_START at the left-centre column (col 0, row mid).
///   3. Walk right/up/down (never left) placing ROOM_NORMAL rooms.
///   4. After MIN_PATH_LEN Normal rooms, allow ROOM_END to be placed.
///   5. End placement is forced once MAX_PATH_LEN Normal rooms are placed
///      OR when no forward move is available.
///   6. On completion, call scr_dungeon_spawn() to instantiate tiles.
///
/// BACKTRACKING:
///   If the walker gets stuck (all neighbours occupied / out of bounds),
///   it backtracks one step in path_list. If the full path_list is exhausted
///   during backtracking, the generator retries from scratch.
///
/// SAFETY:
///   GEN_MAX_ITER caps the total number of walker iterations to prevent
///   any potential infinite loop during development.
/// ---------------------------------------------------------------------------

// ---- Seed RNG so every generated dungeon floor is unique ----
randomize();

// ---- Roll a fresh Caesar shift key for this dungeon floor ----
global.dungeon_cipher_key     = scr_roll_cipher_key();
global.has_dungeon_cipher_key = false;
if (!variable_global_exists("dungeons_cleared")) {
    global.dungeons_cleared = 0;
}

// Ensure generator draws the room fog overlay above tiles/goal (20..50) and below Jack (-y)
visible = true;
depth   = 10;

// ---- Instance variables exposed for external read (e.g. spawner, debug) ----
logic_map      = [];    // 2D array [col][row] of ROOM_* constants
room_fog_alpha = [];    // 2D array [col][row] of fog alpha (0 = lit, 0.90 = darkened)
path_list      = [];    // Ordered array of [col, row] pairs
gen_complete   = false; // True once generation + spawning both finish
normal_count   = 0;     // Running count of ROOM_NORMAL rooms placed
active_col     = 0;     // Player's current room column
active_row     = 0;     // Player's current room row

// ---- Internal walker state ----
var _attempts = 0;      // Safety iteration counter

// ===========================================================================
// Step 1 — Initialise the logic map & fog alpha grid
// ===========================================================================
for (var _c = 0; _c < LOGIC_GRID_W; _c++) {
    logic_map[_c]      = [];
    room_fog_alpha[_c] = [];
    for (var _r = 0; _r < LOGIC_GRID_H; _r++) {
        logic_map[_c][_r]      = ROOM_NONE;
        room_fog_alpha[_c][_r] = 0.90;
    }
}

// ===========================================================================
// Step 2 — Place the Start room
// ===========================================================================
var _start_col = 0;
var _start_row = floor(LOGIC_GRID_H / 2);   // Vertical centre (row 5 on a 10-row grid)

logic_map[_start_col][_start_row]      = ROOM_START;
room_fog_alpha[_start_col][_start_row] = 0.0;
active_col = _start_col;
active_row = _start_row;
path_list[0] = [_start_col, _start_row];

show_debug_message(
    "[obj_dungeon_generator] Generation started. " +
    "Start room at (" + string(_start_col) + ", " + string(_start_row) + ")"
);

// ===========================================================================
// Step 3 — Grid walker loop
// ===========================================================================

// Direction vectors: RIGHT, DOWN, UP  (no LEFT — enforces forward progression)
// Each entry: [delta_col, delta_row]
var _directions = [
    [ 1,  0],   // RIGHT
    [ 0,  1],   // DOWN
    [ 0, -1],   // UP
];

var _finished   = false;
var _iter       = 0;

while (!_finished && _iter < GEN_MAX_ITER) {
    _iter++;
    _attempts++;

    var _path_len = array_length(path_list);

    // Grab current head of the path
    var _cur_col = path_list[_path_len - 1][0];
    var _cur_row = path_list[_path_len - 1][1];

    // -------------------------------------------------------------------
    // Check if End room can/must be placed now
    // -------------------------------------------------------------------
    var _can_place_end  = (normal_count >= MIN_PATH_LEN);
    var _must_place_end = (normal_count >= MAX_PATH_LEN);

    if (_must_place_end) {
        // Scan all neighbours for any empty slot to force the End room
        var _placed_end = false;
        for (var _d = 0; _d < array_length(_directions); _d++) {
            var _nc = _cur_col + _directions[_d][0];
            var _nr = _cur_row + _directions[_d][1];
            if (_nc >= 0 && _nc < LOGIC_GRID_W && _nr >= 0 && _nr < LOGIC_GRID_H) {
                if (logic_map[_nc][_nr] == ROOM_NONE) {
                    logic_map[_nc][_nr] = ROOM_END;
                    array_push(path_list, [_nc, _nr]);
                    show_debug_message(
                        "[obj_dungeon_generator] ROOM_END placed (forced) at (" +
                        string(_nc) + ", " + string(_nr) + ")"
                    );
                    _finished    = true;
                    _placed_end  = true;
                    break;
                }
            }
        }
        if (!_placed_end) {
            // Dead end with no room to place End — backtrack
            show_debug_message("[obj_dungeon_generator] Dead-end during forced End placement — backtracking.");
            if (array_length(path_list) > 1) {
                logic_map[_cur_col][_cur_row] = ROOM_NONE;
                array_delete(path_list, array_length(path_list) - 1, 1);
                normal_count = max(0, normal_count - 1);
            } else {
                // Complete failure — restart (re-run this event via a room restart or flag)
                show_debug_message("[obj_dungeon_generator] CRITICAL: Could not place End room. Generation failed.");
                _finished = true; // Exit loop; gen_complete stays false
            }
        }
        continue;
    }

    // -------------------------------------------------------------------
    // Shuffle directions (Fisher-Yates, 3 elements)
    // -------------------------------------------------------------------
    var _dirs = array_create(3);
    _dirs[0]  = _directions[0];
    _dirs[1]  = _directions[1];
    _dirs[2]  = _directions[2];

    // Swap [2] with random pick from [0..2]
    var _swap_idx = irandom(2);
    var _tmp = _dirs[2]; _dirs[2] = _dirs[_swap_idx]; _dirs[_swap_idx] = _tmp;
    // Swap [1] with random pick from [0..1]
    _swap_idx = irandom(1);
    _tmp = _dirs[1]; _dirs[1] = _dirs[_swap_idx]; _dirs[_swap_idx] = _tmp;

    // -------------------------------------------------------------------
    // Try each direction for a valid Normal or End move
    // -------------------------------------------------------------------
    var _moved = false;

    for (var _d = 0; _d < 3; _d++) {
        var _nc = _cur_col + _dirs[_d][0];
        var _nr = _cur_row + _dirs[_d][1];

        // Bounds check
        if (_nc < 0 || _nc >= LOGIC_GRID_W || _nr < 0 || _nr >= LOGIC_GRID_H) continue;

        // Must be unoccupied
        if (logic_map[_nc][_nr] != ROOM_NONE) continue;

        // ---- Attempt to place End room ----
        // (Only when we've met the minimum path length)
        if (_can_place_end && irandom(4) == 0) {   // ~20% chance to end early if eligible
            logic_map[_nc][_nr] = ROOM_END;
            array_push(path_list, [_nc, _nr]);
            show_debug_message(
                "[obj_dungeon_generator] ROOM_END placed (organic) at (" +
                string(_nc) + ", " + string(_nr) + ")"
            );
            _finished = true;
            _moved    = true;
            break;
        }

        // ---- Place a Normal room ----
        logic_map[_nc][_nr] = ROOM_NORMAL;
        array_push(path_list, [_nc, _nr]);
        normal_count++;
        show_debug_message(
            "[obj_dungeon_generator] ROOM_NORMAL #" + string(normal_count) +
            " at (" + string(_nc) + ", " + string(_nr) + ")"
        );
        _moved = true;
        break;
    }

    // -------------------------------------------------------------------
    // If no move was found, backtrack one step
    // -------------------------------------------------------------------
    if (!_moved && !_finished) {
        if (array_length(path_list) > 1) {
            show_debug_message("[obj_dungeon_generator] No valid move — backtracking from (" +
                string(_cur_col) + ", " + string(_cur_row) + ")");
            logic_map[_cur_col][_cur_row] = ROOM_NONE;
            array_delete(path_list, array_length(path_list) - 1, 1);
            normal_count = max(0, normal_count - 1);
        } else {
            // Start room is the only room left — nothing more to backtrack into
            show_debug_message("[obj_dungeon_generator] ERROR: Walker exhausted all paths from Start. Generation failed.");
            _finished = true;
        }
    }

} // end walker while-loop

// ===========================================================================
// Step 4 — Safety check & finalization
// ===========================================================================
if (_iter >= GEN_MAX_ITER) {
    show_debug_message("[obj_dungeon_generator] WARNING: Hit GEN_MAX_ITER (" +
        string(GEN_MAX_ITER) + ") — generation may be incomplete.");
}

// Verify the last room in path_list is indeed ROOM_END
var _last_idx  = array_length(path_list) - 1;
var _last_type = logic_map[path_list[_last_idx][0]][path_list[_last_idx][1]];

if (_last_type == ROOM_END) {
    // ===========================================================================
    // Step 4b — Assign Caesar Cipher Special Rooms
    //   - ROOM_CAESAR_KEY: Locked by a Cybersecurity Question; contains Caesar Key.
    //     Branches off an early Normal room so the player can obtain the key first.
    //   - ROOM_CAESAR_LOCKED: Locked by a Caesar Cipher encryption; placed along
    //     the second half of the main path before ROOM_END.
    // ===========================================================================
    main_path_len   = array_length(path_list);
    key_room_parent = [-1, -1];
    key_room_pos    = [-1, -1];

    // 1. Convert 1-2 Normal rooms in the second half of the main path into ROOM_CAESAR_LOCKED
    var _mid_idx = max(2, floor(main_path_len / 2));
    var _locked_placed = 0;
    for (var _pi = _mid_idx; _pi < main_path_len - 1; _pi++) {
        var _rc = path_list[_pi][0];
        var _rr = path_list[_pi][1];
        if (logic_map[_rc][_rr] == ROOM_NORMAL) {
            logic_map[_rc][_rr] = ROOM_CAESAR_LOCKED;
            _locked_placed++;
            show_debug_message(
                "[obj_dungeon_generator] Placed ROOM_CAESAR_LOCKED at (" +
                string(_rc) + ", " + string(_rr) + ") [path index " + string(_pi) + "]"
            );
            // Place up to 2 Caesar-locked rooms (with at least 1 room gap if possible)
            if (_locked_placed >= 2) break;
            _pi++;
        }
    }

    // 2. Branch ROOM_CAESAR_KEY off an early room (before _mid_idx) so the key is reachable first
    var _all_4_dirs = [
        [ 0, -1], // UP
        [ 0,  1], // DOWN
        [-1,  0], // LEFT
        [ 1,  0], // RIGHT
    ];
    var _key_placed = false;

    for (var _pi = 1; _pi < _mid_idx && !_key_placed; _pi++) {
        var _pc = path_list[_pi][0];
        var _pr = path_list[_pi][1];
        for (var _d = 0; _d < 4; _d++) {
            var _kc = _pc + _all_4_dirs[_d][0];
            var _kr = _pr + _all_4_dirs[_d][1];
            if (_kc >= 0 && _kc < LOGIC_GRID_W && _kr >= 0 && _kr < LOGIC_GRID_H) {
                if (logic_map[_kc][_kr] == ROOM_NONE) {
                    logic_map[_kc][_kr] = ROOM_CAESAR_KEY;
                    key_room_parent     = [_pc, _pr];
                    key_room_pos        = [_kc, _kr];
                    array_push(path_list, [_kc, _kr]);
                    _key_placed = true;
                    show_debug_message(
                        "[obj_dungeon_generator] Placed ROOM_CAESAR_KEY branch at (" +
                        string(_kc) + ", " + string(_kr) + ") off parent (" +
                        string(_pc) + ", " + string(_pr) + ")"
                    );
                    break;
                }
            }
        }
    }

    // Fallback: if no side slot was free, convert path_list[1] into ROOM_CAESAR_KEY
    if (!_key_placed && main_path_len > 2) {
        var _fc = path_list[1][0];
        var _fr = path_list[1][1];
        logic_map[_fc][_fr] = ROOM_CAESAR_KEY;
        key_room_parent     = [path_list[0][0], path_list[0][1]];
        key_room_pos        = [_fc, _fr];
        show_debug_message(
            "[obj_dungeon_generator] Placed ROOM_CAESAR_KEY (fallback on path) at (" +
            string(_fc) + ", " + string(_fr) + ")"
        );
    }

    show_debug_message(
        "[obj_dungeon_generator] Generation SUCCESS. " +
        string(array_length(path_list)) + " rooms total. " +
        "Iterations: " + string(_iter)
    );
    gen_complete = true;

    // ===========================================================================
    // Step 5 — Invoke the spawner to build the physical dungeon
    // ===========================================================================
    scr_dungeon_spawn(logic_map, path_list);

} else {
    show_debug_message(
        "[obj_dungeon_generator] Generation INCOMPLETE — last room type is " +
        string(_last_type) + ". Spawner NOT called."
    );
}
