/// @description Room Templates — Corporate Building Lockdown layouts of varying sizes & shapes.
///
/// Tile legend:
///   TILE_VOID          (-1) = dark structural building mass outside smaller rooms/hallways
///   TILE_FLOOR          (0) = standard corporate tile floor
///   TILE_WALL           (1) = corporate interior wall
///   TILE_DOOR           (2) = open doorway threshold
///   TILE_LOCK_QUIZ      (3) = cybersecurity question locked door
///   TILE_LOCK_CAESAR    (4) = caesar cipher locked door
///   TILE_CARPET         (5) = corporate hallway / runner carpet
///   TILE_ELEVATOR_FLOOR (6) = brushed steel elevator cab floor
///   TILE_PROP_PC        (7) = computer desk terminal (solid prop)
///   TILE_PROP_CHAIR     (8) = office chair prop
///   TILE_PROP_BOARD     (9) = presentation board / monitor on wall
///   TILE_PROP_PAPER    (10) = scattered lockdown papers on floor
/// ---------------------------------------------------------------------------


// ---------------------------------------------------------------------------
/// @function scr_template_start()
/// @description 9x9 Corporate Security Reception Lobby (ROOM_START).
// ---------------------------------------------------------------------------
function scr_template_start() {
    return [
        [ 1,  1,  9,  1,  1,  1,  9,  1,  1],
        [ 1,  0,  0,  0,  5,  0,  0,  7,  1],
        [ 1,  7,  8,  0,  5,  0, 10,  0,  1],
        [ 1,  0,  0,  5,  5,  5,  0,  0,  1],
        [ 1,  5,  5,  5,  5,  5,  5,  5,  1],
        [ 1,  0,  0,  5,  5,  5,  0,  0,  1],
        [ 1,  0, 10,  0,  5,  0,  8,  7,  1],
        [ 1,  7,  0,  0,  5,  0,  0,  0,  1],
        [ 1,  1,  1,  1,  1,  1,  1,  1,  1],
    ];
}


// ---------------------------------------------------------------------------
/// @function scr_template_hallway()
/// @description Base 9x9 chunk for a narrow Corporate Hallway.
///              Starts with a 3x3 center hub; scr_carve_door_connections()
///              extends 3-tile-wide corridors to each connected border.
// ---------------------------------------------------------------------------
function scr_template_hallway() {
    return [
        [-1, -1, -1, -1, -1, -1, -1, -1, -1],
        [-1, -1, -1, -1, -1, -1, -1, -1, -1],
        [-1, -1,  1,  1,  1,  1,  1, -1, -1],
        [-1, -1,  1,  0,  5,  0,  1, -1, -1],
        [-1, -1,  1,  5,  5,  5,  1, -1, -1],
        [-1, -1,  1,  0,  5, 10,  1, -1, -1],
        [-1, -1,  1,  1,  1,  1,  1, -1, -1],
        [-1, -1, -1, -1, -1, -1, -1, -1, -1],
        [-1, -1, -1, -1, -1, -1, -1, -1, -1],
    ];
}


// ---------------------------------------------------------------------------
/// @function scr_template_compact_office()
/// @description 7x7 Compact IT Office / Security Closet inside the 9x9 chunk.
// ---------------------------------------------------------------------------
function scr_template_compact_office() {
    return [
        [-1, -1, -1, -1, -1, -1, -1, -1, -1],
        [-1,  1,  1,  1,  1,  1,  1,  1, -1],
        [-1,  1,  7,  0,  0,  0,  7,  1, -1],
        [-1,  1,  8,  0,  5,  0, 10,  1, -1],
        [-1,  1,  0,  5,  5,  5,  0,  1, -1],
        [-1,  1, 10,  0,  5,  0,  8,  1, -1],
        [-1,  1,  7,  0,  0,  0,  7,  1, -1],
        [-1,  1,  1,  1,  1,  1,  1,  1, -1],
        [-1, -1, -1, -1, -1, -1, -1, -1, -1],
    ];
}


// ---------------------------------------------------------------------------
/// @function scr_template_wide_office()
/// @description 9x7 Rectangular Corporate Briefing / Workroom.
// ---------------------------------------------------------------------------
function scr_template_wide_office() {
    return [
        [-1, -1, -1, -1, -1, -1, -1, -1, -1],
        [ 1,  1,  9,  1,  1,  1,  9,  1,  1],
        [ 1,  7,  0,  0,  5,  0,  0,  7,  1],
        [ 1,  8,  0,  5,  5,  5, 10,  8,  1],
        [ 1,  0,  5,  5,  5,  5,  5,  0,  1],
        [ 1, 10,  0,  5,  5,  5,  0,  0,  1],
        [ 1,  7,  8,  0,  5,  0,  8,  7,  1],
        [ 1,  1,  1,  1,  1,  1,  1,  1,  1],
        [-1, -1, -1, -1, -1, -1, -1, -1, -1],
    ];
}


// ---------------------------------------------------------------------------
/// @function scr_template_normal()
/// @description Full 9x9 Open-Plan Corporate Server / Cubicle Room.
// ---------------------------------------------------------------------------
function scr_template_normal() {
    return [
        [ 1,  1,  9,  1,  1,  1,  9,  1,  1],
        [ 1,  0,  0,  0,  5,  0,  0, 10,  1],
        [ 1,  0,  7,  0,  5,  0,  7,  0,  1],
        [ 1,  0,  8,  0,  5,  0,  8,  0,  1],
        [ 1,  5,  5,  5,  5,  5,  5,  5,  1],
        [ 1, 10,  0,  0,  5,  0,  0,  0,  1],
        [ 1,  0,  7,  0,  5,  0,  7,  0,  1],
        [ 1,  0,  8,  0,  5,  0,  8,  0,  1],
        [ 1,  1,  1,  1,  1,  1,  1,  1,  1],
    ];
}


// ---------------------------------------------------------------------------
/// @function scr_template_caesar_key()
/// @description 7x7 Reinforced IT Security Key Vault (ROOM_CAESAR_KEY).
// ---------------------------------------------------------------------------
function scr_template_caesar_key() {
    return [
        [-1, -1, -1, -1, -1, -1, -1, -1, -1],
        [-1,  1,  1,  1,  1,  1,  1,  1, -1],
        [-1,  1,  7,  0,  5,  0,  7,  1, -1],
        [-1,  1,  0,  5,  5,  5,  0,  1, -1],
        [-1,  1,  5,  5,  5,  5,  5,  1, -1],
        [-1,  1,  0,  5,  5,  5,  0,  1, -1],
        [-1,  1,  7,  0,  5,  0,  7,  1, -1],
        [-1,  1,  1,  1,  1,  1,  1,  1, -1],
        [-1, -1, -1, -1, -1, -1, -1, -1, -1],
    ];
}


// ---------------------------------------------------------------------------
/// @function scr_template_caesar_locked()
/// @description 9x9 High-Security Mainframe Server Room (ROOM_CAESAR_LOCKED).
// ---------------------------------------------------------------------------
function scr_template_caesar_locked() {
    return [
        [ 1,  1,  9,  1,  1,  1,  9,  1,  1],
        [ 1,  7,  0,  0,  5,  0,  0,  7,  1],
        [ 1,  0,  1,  0,  5,  0,  1,  0,  1],
        [ 1,  0,  7,  5,  5,  5,  7,  0,  1],
        [ 1,  5,  5,  5,  5,  5,  5,  5,  1],
        [ 1,  0,  7,  5,  5,  5,  7,  0,  1],
        [ 1,  0,  1,  0,  5,  0,  1,  0,  1],
        [ 1,  7, 10,  0,  5,  0,  0,  7,  1],
        [ 1,  1,  1,  1,  1,  1,  1,  1,  1],
    ];
}


// ---------------------------------------------------------------------------
/// @function scr_template_end()
/// @description 7x7 Corporate Extraction Elevator Shaft & Cab (ROOM_END).
// ---------------------------------------------------------------------------
function scr_template_end() {
    return [
        [-1, -1, -1, -1, -1, -1, -1, -1, -1],
        [-1,  1,  1,  1,  1,  1,  1,  1, -1],
        [-1,  1,  1,  6,  6,  6,  1,  1, -1],
        [-1,  1,  6,  6,  6,  6,  6,  1, -1],
        [-1,  1,  6,  6,  6,  6,  6,  1, -1],
        [-1,  1,  6,  6,  6,  6,  6,  1, -1],
        [-1,  1,  1,  6,  6,  6,  1,  1, -1],
        [-1,  1,  1,  1,  1,  1,  1,  1, -1],
        [-1, -1, -1, -1, -1, -1, -1, -1, -1],
    ];
}


// ---------------------------------------------------------------------------
/// @function scr_carve_door_connections(t, top_tile, bottom_tile, left_tile, right_tile)
/// @description Carves 3-tile doorways at the outer borders and extends walled
///              corridors inward until they meet the room's walkable interior.
///              Allows rooms of any size (3x3 hallway hub, 7x7 vault/elevator,
///              9x7 office, 9x9 server room) to connect seamlessly.
// ---------------------------------------------------------------------------
function scr_carve_door_connections(t, top_tile, bottom_tile, left_tile, right_tile) {
    // --- TOP CONNECTION ---
    if (top_tile != TILE_WALL) {
        for (var _r = 0; _r <= 3; _r++) {
            if (t[_r][2] == TILE_VOID) t[_r][2] = TILE_WALL;
            if (t[_r][6] == TILE_VOID) t[_r][6] = TILE_WALL;
            for (var _c = 3; _c <= 5; _c++) {
                if (_r == 0 && top_tile != TILE_HALL_OPEN) t[_r][_c] = top_tile;
                else if (t[_r][_c] != TILE_ELEVATOR_FLOOR) t[_r][_c] = (_c == 4) ? TILE_CARPET : TILE_FLOOR;
            }
        }
    }

    // --- BOTTOM CONNECTION ---
    if (bottom_tile != TILE_WALL) {
        for (var _r = 5; _r <= 8; _r++) {
            if (t[_r][2] == TILE_VOID) t[_r][2] = TILE_WALL;
            if (t[_r][6] == TILE_VOID) t[_r][6] = TILE_WALL;
            for (var _c = 3; _c <= 5; _c++) {
                if (_r == 8 && bottom_tile != TILE_HALL_OPEN) t[_r][_c] = bottom_tile;
                else if (t[_r][_c] != TILE_ELEVATOR_FLOOR) t[_r][_c] = (_c == 4) ? TILE_CARPET : TILE_FLOOR;
            }
        }
    }

    // --- LEFT CONNECTION ---
    if (left_tile != TILE_WALL) {
        for (var _c = 0; _c <= 3; _c++) {
            if (t[2][_c] == TILE_VOID) t[2][_c] = TILE_WALL;
            if (t[6][_c] == TILE_VOID) t[6][_c] = TILE_WALL;
            for (var _r = 3; _r <= 5; _r++) {
                if (_c == 0 && left_tile != TILE_HALL_OPEN) t[_r][_c] = left_tile;
                else if (t[_r][_c] != TILE_ELEVATOR_FLOOR) t[_r][_c] = (_r == 4) ? TILE_CARPET : TILE_FLOOR;
            }
        }
    }

    // --- RIGHT CONNECTION ---
    if (right_tile != TILE_WALL) {
        for (var _c = 5; _c <= 8; _c++) {
            if (t[2][_c] == TILE_VOID) t[2][_c] = TILE_WALL;
            if (t[6][_c] == TILE_VOID) t[6][_c] = TILE_WALL;
            for (var _r = 3; _r <= 5; _r++) {
                if (_c == 8 && right_tile != TILE_HALL_OPEN) t[_r][_c] = right_tile;
                else if (t[_r][_c] != TILE_ELEVATOR_FLOOR) t[_r][_c] = (_r == 4) ? TILE_CARPET : TILE_FLOOR;
            }
        }
    }

    return t;
}


// ---------------------------------------------------------------------------
/// @function scr_get_template(room_type)
/// @description Returns a 9x9 template array for the given room type.
///              ROOM_HALLWAY returns the narrow 3-tile corridor template;
///              ROOM_NORMAL randomly selects between Compact Office (7x7),
///              Wide Briefing Room (9x7), and Full Server Room (9x9).
// ---------------------------------------------------------------------------
function scr_get_template(room_type) {
    switch (room_type) {
        case ROOM_START:         return scr_template_start();
        case ROOM_HALLWAY:       return scr_template_hallway();
        case ROOM_END:           return scr_template_end();
        case ROOM_CAESAR_KEY:    return scr_template_caesar_key();
        case ROOM_CAESAR_LOCKED: return scr_template_caesar_locked();
        case ROOM_HOLDING:       return scr_template_compact_office();
        case ROOM_NORMAL:
            var _roll = irandom(2);
            if (_roll == 0) return scr_template_compact_office();
            if (_roll == 1) return scr_template_wide_office();
            return scr_template_normal();
        default:
            return scr_template_normal();
    }
}
