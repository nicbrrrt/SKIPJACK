/// @description Intern Babysitting Ward Spawner & System Helpers
/// Generates the fixed 4-Room + Central Hallway facility for the Intern Babysitting shift:
///   1. Work Room (West): 10 Computer Desks & Chairs where 10 baby interns work
///   2. Central Hallway: Ventilated corridor connecting all rooms (safe fresh-air zone)
///   3. Storage Room (North-West): Shelves, Lockers & Water Cooler (wobble hazards)
///   4. Wellness Green Room (North-East): Chill sanctuary holding up to 4 interns (soothes tantrums)
///   5. Downsized Observation Deck (East): Compact panoramic bullpen with breakable glass overlooking city

/// @function scr_intern_get_room_at(_px, _py)
function scr_intern_get_room_at(_px, _py) {
    var _ox = 320;
    var _oy = 240;
    var _tx = floor((_px - _ox) / 16);
    var _ty = floor((_py - _oy) / 16);

    // Work Room (West) - interior cols 0..14, rows 6..17
    if (_tx >= 0 && _tx <= 14 && _ty >= 6 && _ty <= 17) return ROOM_INTERN_WORK;

    // Storage Room (North-West) - interior cols 17..24, rows 0..6
    if (_tx >= 17 && _tx <= 24 && _ty >= 0 && _ty <= 6) return ROOM_INTERN_STORAGE;

    // Wellness Green Room (North-East) - interior cols 26..33, rows 0..6
    if (_tx >= 26 && _tx <= 33 && _ty >= 0 && _ty <= 6) return ROOM_INTERN_GREEN;

    // Observation Deck Glass Room (East) - interior cols 35..41, rows 8..16
    if (_tx >= 35 && _tx <= 41 && _ty >= 8 && _ty <= 16) return ROOM_INTERN_GLASS;

    // Central Hallway Corridor, Door Thresholds & Branches
    if ((_tx >= 15 && _tx <= 34 && _ty >= 10 && _ty <= 15) ||
        (_tx >= 19 && _tx <= 21 && _ty >= 7 && _ty <= 11) ||
        (_tx >= 28 && _tx <= 30 && _ty >= 7 && _ty <= 11) ||
        (_tx == 15 && _ty == 12) || // Work Room Door threshold
        (_tx == 34 && _ty == 12)) { // Observation Deck Door threshold
        return ROOM_INTERN_HALL;
    }

    return ROOM_INTERN_NONE;
}

/// @function scr_intern_get_room_name(_room_id)
function scr_intern_get_room_name(_room_id) {
    switch (_room_id) {
        case ROOM_INTERN_WORK:    return "Terminal Work Room";
        case ROOM_INTERN_STORAGE: return "Supply Storage Room";
        case ROOM_INTERN_GREEN:   return "Wellness Green Room";
        case ROOM_INTERN_GLASS:   return "Observation Deck";
        case ROOM_INTERN_HALL:    return "Central Hallway (Fresh Air)";
        default:                  return "Corporate Ward";
    }
}

/// @function scr_spawn_intern_ward()
function scr_spawn_intern_ward() {
    show_debug_message("[scr_spawn_intern_ward] Generating fixed 4-Room Intern Babysitting Ward...");

    var _layer = "Instances";
    var _ox    = 320;
    var _oy    = 240;

    // 1. Spawn Ward Controller
    var _ctrl = instance_create_layer(_ox, _oy, _layer, obj_intern_ward_controller);

    // Track grid for solid walls and floors (43 tiles wide x 19 tiles high)
    var _w = 43;
    var _h = 19;
    var _grid = array_create(_w);
    for (var _c = 0; _c < _w; _c++) {
        _grid[_c] = array_create(_h, -1); // -1 = none
    }

    // -------------------------------------------------------------
    // Define Floor tiles:
    // -------------------------------------------------------------
    // Work Room Interior floor (cols 1..14, rows 7..16)
    for (var _c = 1; _c <= 14; _c++) {
        for (var _r = 7; _r <= 16; _r++) {
            _grid[_c][_r] = 0; // standard floor
        }
    }
    _grid[15][12] = 5; // door threshold floor

    // Storage Room Interior floor (cols 18..23, rows 1..6)
    for (var _c = 18; _c <= 23; _c++) {
        for (var _r = 1; _r <= 6; _r++) {
            _grid[_c][_r] = 0;
        }
    }
    _grid[20][7] = 5; // door threshold floor

    // Wellness Green Room Interior floor (cols 27..32, rows 1..6) - Botanical carpet style 3!
    for (var _c = 27; _c <= 32; _c++) {
        for (var _r = 1; _r <= 6; _r++) {
            _grid[_c][_r] = 3; // style 3 = soothing sage green carpet
        }
    }
    _grid[29][7] = 5; // door threshold floor

    // Central Hallway corridor floor (cols 16..33, rows 11..14)
    for (var _c = 16; _c <= 33; _c++) {
        for (var _r = 11; _r <= 14; _r++) {
            _grid[_c][_r] = 5; // carpet / polished hallway
        }
    }
    // Hallway North branch into Storage (col 20, rows 8..10)
    for (var _r = 8; _r <= 10; _r++) {
        _grid[20][_r] = 5;
    }
    // Hallway North branch into Green Room (col 29, rows 8..10)
    for (var _r = 8; _r <= 10; _r++) {
        _grid[29][_r] = 5;
    }

    // Downsized Observation Deck Interior floor (cols 35..40, rows 9..15)
    for (var _c = 35; _c <= 40; _c++) {
        for (var _r = 9; _r <= 15; _r++) {
            _grid[_c][_r] = 5; // executive blue carpet
        }
    }
    _grid[34][12] = 5; // door threshold floor

    // -------------------------------------------------------------
    // Define Wall tiles (Flush against door jambs, ZERO gaps!):
    // -------------------------------------------------------------
    // Work Room outer borders:
    for (var _r = 6; _r <= 17; _r++) { _grid[0][_r] = 1; }
    for (var _c = 0; _c <= 15; _c++) { _grid[_c][6] = 1; _grid[_c][17] = 1; }
    // Work Room East wall (col 15): ONLY row 12 is the door!
    for (var _r = 6; _r <= 17; _r++) {
        if (_r != 12) { _grid[15][_r] = 1; }
    }

    // Storage Room borders (cols 17..24, rows 0..7):
    for (var _c = 17; _c <= 24; _c++) { _grid[_c][0] = 1; }
    for (var _r = 0; _r <= 7; _r++) { _grid[17][_r] = 1; _grid[24][_r] = 1; }
    // Storage South wall (row 7): ONLY col 20 is the door!
    for (var _c = 17; _c <= 24; _c++) {
        if (_c != 20) { _grid[_c][7] = 1; }
    }

    // Wellness Green Room borders (cols 26..33, rows 0..7):
    for (var _c = 26; _c <= 33; _c++) { _grid[_c][0] = 1; }
    for (var _r = 0; _r <= 7; _r++) { _grid[26][_r] = 1; _grid[33][_r] = 1; }
    // Green Room South wall (row 7): ONLY col 29 is the door!
    for (var _c = 26; _c <= 33; _c++) {
        if (_c != 29) { _grid[_c][7] = 1; }
    }

    // Hallway corridor boundaries & branch walls:
    for (var _c = 16; _c <= 19; _c++) { _grid[_c][10] = 1; }
    for (var _r = 8; _r <= 10; _r++) { _grid[19][_r] = 1; _grid[21][_r] = 1; }
    for (var _c = 21; _c <= 28; _c++) { _grid[_c][10] = 1; }
    for (var _r = 8; _r <= 10; _r++) { _grid[28][_r] = 1; _grid[30][_r] = 1; }
    for (var _c = 30; _c <= 33; _c++) { _grid[_c][10] = 1; }
    for (var _c = 15; _c <= 34; _c++) { _grid[_c][15] = 1; }

    // Observation Deck West wall (col 34, rows 8..16): ONLY row 12 is the door!
    for (var _r = 8; _r <= 16; _r++) {
        if (_r != 12) { _grid[34][_r] = 1; }
    }
    // Observation Deck South wall:
    for (var _c = 34; _c <= 41; _c++) { _grid[_c][16] = 1; }

    // -------------------------------------------------------------
    // Instantiate Floor & Wall Objects into Game World
    // -------------------------------------------------------------
    for (var _c = 0; _c < _w; _c++) {
        for (var _r = 0; _r < _h; _r++) {
            var _t = _grid[_c][_r];
            var _wx = _ox + _c * 16;
            var _wy = _oy + _r * 16;

            if (_t == 0 || _t == 3 || _t == 5) {
                var _flr = instance_create_layer(_wx, _wy, _layer, obj_floor);
                _flr.depth       = 50;
                _flr.floor_style = _t;
            } else if (_t == 1) {
                var _wll = instance_create_layer(_wx, _wy, _layer, obj_dungeon_wall);
                _wll.depth      = 30;
                _wll.wall_style = 0;
            }
        }
    }

    // -------------------------------------------------------------
    // 2. Downsized Observation Deck Glass Panes (North & East Walls)
    // -------------------------------------------------------------
    // North wall glass panes (cols 35..40, row 8) -> 6 panes
    for (var _c = 35; _c <= 40; _c++) {
        var _gx = _ox + _c * 16;
        var _gy = _oy + 8 * 16;
        var _g = instance_create_layer(_gx, _gy, _layer, obj_intern_glass);
        _g.is_north_wall = true;
    }
    // East wall glass panes (col 41, rows 8..15) -> 8 panes
    for (var _r = 8; _r <= 15; _r++) {
        var _gx = _ox + 41 * 16;
        var _gy = _oy + _r * 16;
        var _g = instance_create_layer(_gx, _gy, _layer, obj_intern_glass);
        _g.is_north_wall = false;
    }

    // -------------------------------------------------------------
    // 3. Functional Sliding Doors at the 4 Room Thresholds
    // -------------------------------------------------------------
    // Work Room Door (col 15, row 12)
    var _door_work = instance_create_layer(_ox + 15 * 16, _oy + 12 * 16, _layer, obj_intern_door);
    _door_work.room_assigned = ROOM_INTERN_WORK;
    _door_work.door_label    = "Work Room Air Door";

    // Storage Room Door (col 20, row 7)
    var _door_storage = instance_create_layer(_ox + 20 * 16, _oy + 7 * 16, _layer, obj_intern_door);
    _door_storage.room_assigned = ROOM_INTERN_STORAGE;
    _door_storage.door_label    = "Storage Vault Door";

    // Wellness Green Room Door (col 29, row 7)
    var _door_green = instance_create_layer(_ox + 29 * 16, _oy + 7 * 16, _layer, obj_intern_door);
    _door_green.room_assigned = ROOM_INTERN_GREEN;
    _door_green.door_label    = "Green Room Wellness Door";

    // Observation Deck Door (col 34, row 12)
    var _door_glass = instance_create_layer(_ox + 34 * 16, _oy + 12 * 16, _layer, obj_intern_door);
    _door_glass.room_assigned = ROOM_INTERN_GLASS;
    _door_glass.door_label    = "Observation Bullpen Door";

    // -------------------------------------------------------------
    // 4. Storage Room Wobble Hazards (Shelves, Lockers, Water Dispenser)
    // -------------------------------------------------------------
    // Heavy Metal Storage Shelves
    var _shelf_cols = [19, 22];
    for (var _si = 0; _si < array_length(_shelf_cols); _si++) {
        var _sx = _ox + _shelf_cols[_si] * 16;
        var _sy = _oy + 2 * 16;
        var _sh = instance_create_layer(_sx, _sy, _layer, obj_intern_hazard);
        _sh.hazard_type = HAZARD_SHELF;
    }

    // Supply Lockers
    var _locker_rows = [4, 5];
    for (var _li = 0; _li < array_length(_locker_rows); _li++) {
        var _lx = _ox + 18 * 16;
        var _ly = _oy + _locker_rows[_li] * 16;
        var _lk = instance_create_layer(_lx, _ly, _layer, obj_intern_hazard);
        _lk.hazard_type = HAZARD_LOCKER;
    }

    // Water Cooler Dispenser
    var _wx = _ox + 23 * 16;
    var _wy = _oy + 4 * 16;
    var _wc = instance_create_layer(_wx, _wy, _layer, obj_intern_hazard);
    _wc.hazard_type = HAZARD_WATER;

    // -------------------------------------------------------------
    // 5. Facility Air Ventilation Units (3 Rooms with Vents)
    // -------------------------------------------------------------
    // Work Room Vent (North wall, col 8, row 6)
    var _vent_work = instance_create_layer(_ox + 8 * 16, _oy + 6 * 16, _layer, obj_intern_vent);
    _vent_work.room_assigned = ROOM_INTERN_WORK;
    _vent_work.vent_label    = "Office Workroom Vent";

    // Storage Room Vent (North wall, col 21, row 0)
    var _vent_storage = instance_create_layer(_ox + 21 * 16, _oy + 0 * 16, _layer, obj_intern_vent);
    _vent_storage.room_assigned = ROOM_INTERN_STORAGE;
    _vent_storage.vent_label    = "Storage Vault Vent";

    // Observation Deck Vent (South wall, col 38, row 16)
    var _vent_glass = instance_create_layer(_ox + 38 * 16, _oy + 16 * 16, _layer, obj_intern_vent);
    _vent_glass.room_assigned = ROOM_INTERN_GLASS;
    _vent_glass.vent_label    = "Observation Bullpen Vent";

    // -------------------------------------------------------------
    // 6. Wellness Green Room Decor (4 Dedicated Relaxation Cushion Spots)
    // Relaxation cushions are rendered directly onto the botanical carpet tiles
    // at Spot 0 (28, 2), Spot 1 (31, 2), Spot 2 (28, 4), and Spot 3 (31, 4).
    // -------------------------------------------------------------

    // -------------------------------------------------------------
    // 7. Work Room: 10 Computer Desks & 10 Baby Interns!
    // -------------------------------------------------------------
    var _desk_cols = [3, 5, 7, 9, 11,   3, 5, 7, 9, 11];
    var _desk_rows = [8, 8, 8, 8,  8,  13, 13, 13, 13, 13];
    for (var _i = 0; _i < 10; _i++) {
        var _dx = _ox + _desk_cols[_i] * 16;
        var _dy = _oy + _desk_rows[_i] * 16;

        // Terminal object
        var _term = instance_create_layer(_dx, _dy, _layer, obj_intern_terminal);
        _term.terminal_index = _i;

        // Office Chair
        var _chair = instance_create_layer(_dx, _dy + 10, _layer, obj_dungeon_prop);
        _chair.prop_type = TILE_PROP_CHAIR;
        _chair.depth     = 28;

        // Baby Intern
        var _variant = (_i mod 5) + 1;
        var _baby = instance_create_layer(_dx + 8, _dy + 14, _layer, obj_intern);
        _baby.intern_id       = _i;
        _baby.intern_variant  = _variant;
        _baby.home_desk_x     = _dx + 8;
        _baby.home_desk_y     = _dy + 14;

        switch (_variant) {
            case 1: _baby.sprite_index = intern1; break;
            case 2: _baby.sprite_index = intern2; break;
            case 3: _baby.sprite_index = intern3; break;
            case 4: _baby.sprite_index = intern4; break;
            case 5: _baby.sprite_index = intern5; break;
            default: _baby.sprite_index = intern1; break;
        }

        // Dynamic individual focus & stamina (rapid chaotic escalation):
        if (_i == 0) {
            _baby.boredom      = 85;
            _baby.boredom_rate = random_range(0.080, 0.130); // restless in ~2-3s!
        } else if (_i == 1) {
            _baby.boredom      = 70;
            _baby.boredom_rate = random_range(0.070, 0.110); // restless in ~5s!
        } else if (_i <= 3) {
            _baby.boredom      = irandom_range(45, 60);
            _baby.boredom_rate = random_range(0.060, 0.095); // restless in ~8-12s!
        } else if (_i <= 5) {
            _baby.boredom      = irandom_range(25, 40);
            _baby.boredom_rate = random_range(0.050, 0.080); // restless in ~15-20s!
        } else {
            _baby.boredom      = irandom_range(10, 25);
            _baby.boredom_rate = random_range(0.045, 0.075); // restless in ~20-30s!
        }

        _baby.grace_timer     = 0;
        _baby.assigned_term   = _term;
        _term.assigned_intern = _baby;
    }

    // -------------------------------------------------------------
    // 7. Spawn Jack in the Central Hallway
    // -------------------------------------------------------------
    if (instance_exists(obj_jack)) {
        obj_jack.x = _ox + 20 * 16 + 8;
        obj_jack.y = _oy + 12 * 16 + 8;
        obj_jack.isInCutscene = false;
    }

    show_debug_message("[scr_spawn_intern_ward] Intern Babysitting Ward successfully spawned with 4 rooms, Green Room, and downsized deck!");
}

/// @function scr_intern_send_to_work(_inst, _grace_frames)
/// Sends an intern back to their office desk with full pathfinding and grace cooldowns!
function scr_intern_send_to_work(_inst, _grace_frames) {
    if (!instance_exists(_inst)) return;
    with (_inst) {
        if (state == INTERN_STATE_DEAD) return;

        // Clear any vent targeting
        vent_target = noone;

        // Detach immediately from any active hazard
        if (mischief_target != noone && instance_exists(mischief_target)) {
            if (mischief_target.mischief_intern == id) {
                mischief_target.mischief_intern = noone;
            }
            mischief_target = noone;
        }

        // Apply generous calming grace cooldowns
        grace_timer   = _grace_frames; // Peaceful work grace timer (e.g. 900 = 15s)
        vent_cooldown = 1800;          // 30 seconds immunity from vent crawling!
        door_cooldown = 600;           // 10 seconds door locking cooldown
        boredom       = 0;
        target_room   = ROOM_INTERN_WORK;
        target_x      = home_desk_x;
        target_y      = home_desk_y;

        // Doorway and corridor waypoint coordinates:
        var _wp_work_in    = [544, 440];
        var _wp_work       = [568, 440];
        var _wp_work_hall  = [592, 440];
        var _wp_junc_s     = [648, 440];
        var _wp_storage_cor= [648, 384];
        var _wp_storage    = [648, 360];
        var _wp_storage_in = [648, 336];
        var _wp_junc_g     = [792, 440];
        var _wp_green_cor  = [792, 384];
        var _wp_green      = [792, 360];
        var _wp_green_in   = [792, 336];
        var _wp_glass_hall = [848, 440];
        var _wp_glass      = [872, 440];
        var _wp_glass_in   = [896, 440];

        var _cur_rm = scr_intern_get_room_at(x, y);

        if (_cur_rm == ROOM_INTERN_STORAGE) {
            waypoints = [_wp_storage_in, _wp_storage, _wp_storage_cor, _wp_junc_s, _wp_work_hall, _wp_work, _wp_work_in, [target_x, target_y]];
        } else if (_cur_rm == ROOM_INTERN_GLASS) {
            waypoints = [_wp_glass_in, _wp_glass, _wp_glass_hall, _wp_work_hall, _wp_work, _wp_work_in, [target_x, target_y]];
        } else if (_cur_rm == ROOM_INTERN_GREEN) {
            waypoints = [_wp_green_in, _wp_green, _wp_green_cor, _wp_junc_g, _wp_junc_s, _wp_work_hall, _wp_work, _wp_work_in, [target_x, target_y]];
        } else if (_cur_rm == ROOM_INTERN_WORK) {
            waypoints = [[target_x, target_y]];
        } else {
            waypoints = [_wp_work_hall, _wp_work, _wp_work_in, [target_x, target_y]];
        }

        current_wp = 0;
        state      = INTERN_STATE_SEEK_ROOM;
        audio_play_sound(snd_voice1, 10, false);
    }
}
