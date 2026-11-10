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

/// @function scr_intern_get_scrap_difficulty()
/// Calculates difficulty scaling parameters for the Intern Babysitting Shift
/// based on the amount of company Scrap Jack severed / looted!
function scr_intern_get_scrap_difficulty() {
    var _scrap = 4;
    if (variable_global_exists("floor_scrap_collected") && global.floor_scrap_collected > 0) {
        _scrap = global.floor_scrap_collected;
    } else if (variable_global_exists("hr_scrap_count") && global.hr_scrap_count > 0) {
        _scrap = global.hr_scrap_count;
    }

    // Threat Tier (Level 1..4):
    // Level 1: Mild (4 - 5 scrap)
    // Level 2: Moderate (6 - 8 scrap)
    // Level 3: Severe (9 - 11 scrap)
    // Level 4: Extreme (12+ scrap)
    var _level = 1;
    var _tier_name = "MILD";
    var _tier_col = make_color_rgb(100, 240, 140); // Green

    if (_scrap >= 12) {
        _level = 4;
        _tier_name = "EXTREME";
        _tier_col = make_color_rgb(255, 70, 70); // Red
    } else if (_scrap >= 9) {
        _level = 3;
        _tier_name = "SEVERE";
        _tier_col = make_color_rgb(255, 140, 40); // Orange
    } else if (_scrap >= 6) {
        _level = 2;
        _tier_name = "MODERATE";
        _tier_col = make_color_rgb(255, 215, 60); // Yellow
    }

    // Continuous normalized factor: 0.0 at 4 scrap up to 1.0 at 12+ scrap
    var _t = clamp((_scrap - 4) / 8.0, 0.0, 1.0);

    return {
        scrap:           _scrap,
        level:           _level,
        tier_name:       _tier_name,
        tier_col:        _tier_col,
        factor:          _t,

        // 1. Attention Span & Restlessness (Boredom increment per frame)
        // Level 1: 0.045 - 0.085 (~26s desk sit)
        // Level 4: 0.090 - 0.170 (~10s desk sit)
        boredom_min:     lerp(0.045, 0.090, _t),
        boredom_max:     lerp(0.085, 0.170, _t),

        // 2. Grace Periods (Frames)
        // Initial shift calm: 5.0s (300) down to 1.0s (60)
        initial_grace:   round(lerp(300, 60, _t)),
        // Return-to-work grace: 10s (600) down to 4s (240)
        work_grace:      round(lerp(600, 240, _t)),
        // Vent crawling immunity: 20s (1200) down to 10s (600)
        vent_immunity:   round(lerp(1200, 600, _t)),

        // 3. Patience, Volatility & Tantrums
        // Hazard wobble countdown: 4.0s (240) down to 2.0s (120)
        hazard_wobble:   round(lerp(240, 120, _t)),
        // Pre-tantrum fuming warning window before full explosion: 3.0s (180) down to 1.5s (90)
        fuming_time:     round(lerp(180, 90, _t)),
        // Full tantrum duration: 2.5s (150) up to 4.0s (240)
        tantrum_duration: round(lerp(150, 240, _t)),
        // Tantrum flail damage to nearby interns: 15 up to 25
        tantrum_flail_dmg: round(lerp(15, 25, _t)),
        // Player stun duration if struck by tantrum: 1.2s (72) up to 2.0s (120)
        jack_stun_frames: round(lerp(72, 120, _t)),
        // Knockout wakeup delay before standing up in fuming state: 4.5s (270) down to 3.0s (180)
        knockout_wake_time: round(lerp(270, 180, _t)),
        // Green Room soothing duration: 15s (900) down to 9s (540)
        soothe_time:     round(lerp(900, 540, _t)),

        // 4. Observation Deck Panoramic Glass (Fragile: breaks in 3-5 hits!)
        // Max HP: 30 down to 24
        glass_max_hp:    round(lerp(30, 24, _t)),
        // Damage per hit: 6 up to 12
        glass_damage:    round(lerp(6, 12, _t)),
        // Hit cadence interval: 75 frames (~1.25s) down to 45 frames (~0.75s)
        glass_hit_cd:    round(lerp(75, 45, _t)),

        // 5. Intern Injury & Health Bleed
        // Slipping blunt trauma damage: 20 up to 35
        slip_damage:     round(lerp(20, 35, _t)),
        // Stuck in vent suffocation rate: ~6.0 HP/s (0.10) to ~13.2 HP/s (0.22)
        vent_intern_dmg: lerp(0.10, 0.22, _t),
        // Unconscious knockout HP bleed per frame: ~3.6 HP/s (0.06) to ~7.2 HP/s (0.12)
        ko_drain:        lerp(0.06, 0.12, _t),

        // 6. Ventilation Degradation & Facility Asphyxiation
        // Vent damage per frame from stuck intern: ~0.14 (~12s) to ~0.24 (~7s)
        vent_damage_rate: lerp(0.14, 0.24, _t),
        // Global floor oxygen drain per frame when all 3 vents down: ~0.09 (~18.5s) to ~0.13 (~12.8s)
        floor_o2_drain:   lerp(0.09, 0.13, _t)
    };
}

/// @function scr_intern_room_has_active_mischief(_room_id)
/// Returns true if at least one intern in the room is actively engaged in disruption:
/// mischief with hazards, screaming in tantrum, fuming before tantrum, trapped under debris, or stuck in air vent.
function scr_intern_room_has_active_mischief(_room_id) {
    if (_room_id == ROOM_INTERN_NONE || _room_id == ROOM_INTERN_HALL) return false;
    var _has_mischief = false;
    with (obj_intern) {
        if (state == INTERN_STATE_DEAD) continue;
        if (scr_intern_get_room_at(x, y) == _room_id) {
            if (state == INTERN_STATE_MISCHIEF
             || state == INTERN_STATE_TANTRUM
             || state == INTERN_STATE_FUMING
             || state == INTERN_STATE_TRAPPED
             || state == INTERN_STATE_VENT_STUCK) {
                _has_mischief = true;
                break;
            }
        }
    }
    return _has_mischief;
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

    // Janitor Mop & Bucket Station (in Storage Room)
    var _mx = _ox + 23 * 16;
    var _my = _oy + 4 * 16;
    var _mop = instance_create_layer(_mx, _my, _layer, obj_intern_mop_station);

    // Mechanic Wrench Toolbox Station (in Storage Room)
    var _wrench_x  = _ox + 18 * 16;
    var _wrench_y  = _oy + 1 * 16;
    var _wrench_st = instance_create_layer(_wrench_x, _wrench_y, _layer, obj_intern_wrench_station);

    // Water Cooler Dispenser (Moved out to Central Hallway corridor!)
    var _wx = _ox + 24 * 16;
    var _wy = _oy + 11 * 16;
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

        // Threat-scaled attention span & snappy start grace periods:
        var _diff = scr_intern_get_scrap_difficulty();
        _baby.boredom_rate    = random_range(_diff.boredom_min, _diff.boredom_max);

        if (_i == 0) {
            // First intern gets restless almost immediately (~1.5s - 2.0s)
            _baby.boredom     = round(lerp(92, 98, _diff.factor));
            _baby.grace_timer = round(lerp(90, 30, _diff.factor));
        } else {
            _baby.boredom     = irandom_range(round(lerp(30, 45, _diff.factor)), round(lerp(60, 75, _diff.factor)));
            _baby.grace_timer = _diff.initial_grace;
        }

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

        // Apply threat-scaled calming grace cooldowns
        var _diff = scr_intern_get_scrap_difficulty();
        var _g_frames = (_grace_frames > 0) ? _grace_frames : _diff.work_grace;
        grace_timer   = _g_frames;
        vent_cooldown = _diff.vent_immunity;
        door_cooldown = max(240, round(_diff.vent_immunity * 0.4));
        boredom       = 0;
        boredom_rate  = random_range(_diff.boredom_min, _diff.boredom_max);
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
