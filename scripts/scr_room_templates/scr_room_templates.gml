/// @description Room Templates — 9x9 tile arrays for each room type.
///
/// Tile legend:
///   TILE_FLOOR (0) = walkable floor
///   TILE_WALL  (1) = solid wall
///   TILE_DOOR  (2) = doorway / open gap in border wall
///
/// Array indexing: template[col][row], origin = top-left.
/// All templates share a 9-column x 9-row grid (CHUNK_SIZE x CHUNK_SIZE).
///
/// Door placement convention:
///   Top door    : col 4, row 0
///   Bottom door : col 4, row 8
///   Left door   : col 0, row 4
///   Right door  : col 8, row 4
/// ---------------------------------------------------------------------------


// ---------------------------------------------------------------------------
/// @function scr_template_start()
/// @description Returns the 9x9 template for the Start room.
///              All 4 outer borders are solid walls by default;
///              doorways are dynamically carved by scr_dungeon_spawn()
///              based on actual path connections.
// ---------------------------------------------------------------------------
function scr_template_start() {
    var t = [
        [1, 1, 1, 1, 1, 1, 1, 1, 1],  // row 0 — top wall
        [1, 0, 0, 0, 0, 0, 0, 0, 1],  // row 1
        [1, 0, 0, 0, 0, 0, 0, 0, 1],  // row 2
        [1, 0, 0, 0, 0, 0, 0, 0, 1],  // row 3
        [1, 0, 0, 0, 0, 0, 0, 0, 1],  // row 4 — open floor interior
        [1, 0, 0, 0, 0, 0, 0, 0, 1],  // row 5
        [1, 0, 0, 0, 0, 0, 0, 0, 1],  // row 6
        [1, 0, 0, 0, 0, 0, 0, 0, 1],  // row 7
        [1, 1, 1, 1, 1, 1, 1, 1, 1],  // row 8 — bottom wall
    ];
    return t;
}


// ---------------------------------------------------------------------------
/// @function scr_template_normal()
/// @description Returns the 9x9 template for a Normal traversal room.
///              Solid outer borders by default; interior pillars.
///              Doorways are dynamically carved by scr_dungeon_spawn().
// ---------------------------------------------------------------------------
function scr_template_normal() {
    var t = [
        [1, 1, 1, 1, 1, 1, 1, 1, 1],  // row 0 — top wall
        [1, 0, 0, 0, 0, 0, 0, 0, 1],  // row 1
        [1, 0, 1, 0, 0, 0, 1, 0, 1],  // row 2 — interior pillars at (2,2) and (6,2)
        [1, 0, 0, 0, 0, 0, 0, 0, 1],  // row 3
        [1, 0, 0, 0, 0, 0, 0, 0, 1],  // row 4 — open center aisle
        [1, 0, 0, 0, 0, 0, 0, 0, 1],  // row 5
        [1, 0, 1, 0, 0, 0, 1, 0, 1],  // row 6 — interior pillars at (2,6) and (6,6)
        [1, 0, 0, 0, 0, 0, 0, 0, 1],  // row 7
        [1, 1, 1, 1, 1, 1, 1, 1, 1],  // row 8 — bottom wall
    ];
    return t;
}


// ---------------------------------------------------------------------------
/// @function scr_template_end()
/// @description Returns the 9x9 template for the End (exit/boss) room.
///              Solid outer borders with structured boss arena layout.
///              The entry doorway is dynamically carved by scr_dungeon_spawn().
// ---------------------------------------------------------------------------
function scr_template_end() {
    var t = [
        [1, 1, 1, 1, 1, 1, 1, 1, 1],  // row 0 — top wall
        [1, 0, 0, 0, 0, 0, 0, 0, 1],  // row 1
        [1, 0, 1, 1, 0, 1, 1, 0, 1],  // row 2 — heavier interior structure
        [1, 0, 1, 0, 0, 0, 1, 0, 1],  // row 3
        [1, 0, 0, 0, 0, 0, 0, 0, 1],  // row 4 — open arena center
        [1, 0, 1, 0, 0, 0, 1, 0, 1],  // row 5
        [1, 0, 1, 1, 0, 1, 1, 0, 1],  // row 6
        [1, 0, 0, 0, 0, 0, 0, 0, 1],  // row 7
        [1, 1, 1, 1, 1, 1, 1, 1, 1],  // row 8 — bottom wall
    ];
    return t;
}


// ---------------------------------------------------------------------------
/// @function scr_get_template(room_type)
/// @param {real} room_type  One of: ROOM_START, ROOM_NORMAL, ROOM_END
/// @description Dispatcher — returns the correct 9x9 template array
///              for the given room type constant.
// ---------------------------------------------------------------------------
function scr_get_template(room_type) {
    switch (room_type) {
        case ROOM_START:  return scr_template_start();
        case ROOM_NORMAL: return scr_template_normal();
        case ROOM_END:    return scr_template_end();
        default:
            show_debug_message("[scr_get_template] WARNING: Unknown room type: " + string(room_type));
            return scr_template_normal(); // Fallback to Normal
    }
}
