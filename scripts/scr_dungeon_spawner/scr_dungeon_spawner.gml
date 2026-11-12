/// @description Dungeon Spawner — reads the logic map and instantiates tile objects.
///
/// This script translates the abstract logic map produced by obj_dungeon_generator
/// into real GameMaker object instances placed at world-space coordinates.
///
/// World-space formula:
///   chunk world origin  = logic_col * (CHUNK_SIZE * TILE_SIZE),
///                         logic_row * (CHUNK_SIZE * TILE_SIZE)
///   individual tile pos = chunk_origin + (tile_col * TILE_SIZE),
///                         chunk_origin + (tile_row * TILE_SIZE)
///
/// NOTE: obj_dungeon_wall is a dedicated dungeon wall object with spr_wall_tile.
///       obj_wall (the pre-existing project object) is left untouched.
///       obj_floor and obj_doorway are new bare-bones objects created alongside this system.
/// ---------------------------------------------------------------------------


// ---------------------------------------------------------------------------
/// @function scr_get_border_door_type(c1, r1, c2, r2, door_links)
/// @description Looks up whether (c1,r1) and (c2,r2) share an explicit connection
///              in door_links. Returns TILE_WALL if not connected, or
///              TILE_DOOR / TILE_HALL_OPEN / TILE_LOCK_QUIZ / TILE_LOCK_CAESAR.
// ---------------------------------------------------------------------------
function scr_get_border_door_type(c1, r1, c2, r2, door_links) {
    var _len = array_length(door_links);
    for (var _i = 0; _i < _len; _i++) {
        var _link = door_links[_i];
        var _ac   = _link[0];
        var _ar   = _link[1];
        var _bc   = _link[2];
        var _br   = _link[3];
        var _dt   = _link[4];

        if ((c1 == _ac && r1 == _ar && c2 == _bc && r2 == _br) ||
            (c2 == _ac && r2 == _ar && c1 == _bc && r1 == _br)) {
            return _dt;
        }
    }
    return TILE_WALL;
}


// ---------------------------------------------------------------------------
/// @function scr_dungeon_spawn(logic_map, path_list)
/// @param {Array<Array<real>>} logic_map   The 2D grid of ROOM_* constants
/// @param {Array<Array<real>>} path_list   Ordered list of [col, row] pairs
/// @description Main spawner entry point. Iterates over every room in path_list,
///              retrieves its 9x9 template, and instantiates tile objects.
// ---------------------------------------------------------------------------
function scr_dungeon_spawn(logic_map, path_list) {

    var layer_name = "Instances"; // Must match an existing layer in the target room

    var path_len = array_length(path_list);
    var links    = variable_instance_exists(id, "door_links") ? door_links : [];
    var npc_seq  = 0;
    var hall_seq = 0;
    var pc_list  = [];

    show_debug_message("[scr_dungeon_spawn] Spawning " + string(path_len) + " rooms...");

    for (var p = 0; p < path_len; p++) {

        var logic_col = path_list[p][0];
        var logic_row = path_list[p][1];
        var room_type = logic_map[logic_col][logic_row];

        // Skip any slots that somehow ended up unoccupied (safety guard)
        if (room_type == ROOM_NONE) continue;

        // Retrieve the 9x9 tile template for this room type
        var template = scr_get_template(room_type);

        // Determine the door tile type (TILE_WALL, TILE_DOOR, TILE_HALL_OPEN, TILE_LOCK_QUIZ, TILE_LOCK_CAESAR)
        // for each of the 4 cardinal borders of this room using explicit door_links.
        var top_tile    = scr_get_border_door_type(logic_col, logic_row, logic_col,     logic_row - 1, links);
        var bottom_tile = scr_get_border_door_type(logic_col, logic_row, logic_col,     logic_row + 1, links);
        var left_tile   = scr_get_border_door_type(logic_col, logic_row, logic_col - 1, logic_row,     links);
        var right_tile  = scr_get_border_door_type(logic_col, logic_row, logic_col + 1, logic_row,     links);

        // Carve 3-tile-wide doorways (tiles 3, 4, 5) ONLY on borders that connect to a neighboring room,
        // and extend 3-tile walled vestibules inward for smaller rooms & hallways.
        template = scr_carve_door_connections(template, top_tile, bottom_tile, left_tile, right_tile);

        // World-space top-left corner of this chunk (in pixels)
        var world_x = logic_col * (CHUNK_SIZE * TILE_SIZE);
        var world_y = logic_row * (CHUNK_SIZE * TILE_SIZE);

        show_debug_message(
            "[scr_dungeon_spawn] Room " + string(p) +
            " type=" + string(room_type) +
            " logic=(" + string(logic_col) + "," + string(logic_row) + ")" +
            " doors=[T:" + string(top_tile) + " B:" + string(bottom_tile) + " L:" + string(left_tile) + " R:" + string(right_tile) + "]"
        );

        // Iterate every tile in the 9x9 grid (row-major for clarity)
        for (var tile_row = 0; tile_row < CHUNK_SIZE; tile_row++) {
            for (var tile_col = 0; tile_col < CHUNK_SIZE; tile_col++) {

                var tile_val = template[tile_row][tile_col];

                // Pixel position of this tile
                var px = world_x + (tile_col * TILE_SIZE);
                var py = world_y + (tile_row * TILE_SIZE);

                // Instantiate the matching object for this tile type
                switch (tile_val) {
                    case TILE_VOID:
                        var _vw = instance_create_layer(px, py, layer_name, obj_dungeon_wall);
                        _vw.depth      = 30;
                        _vw.wall_style = 1;
                        _vw.room_theme = room_type;
                        break;

                    case TILE_WALL:
                        var _w = instance_create_layer(px, py, layer_name, obj_dungeon_wall);
                        _w.depth      = 30;
                        _w.wall_style = 0;
                        _w.room_theme = room_type;
                        break;

                    case TILE_PROP_BOARD:
                        var _bw = instance_create_layer(px, py, layer_name, obj_dungeon_wall);
                        _bw.depth      = 30;
                        _bw.wall_style = 2;
                        _bw.room_theme = room_type;
                        break;

                    case TILE_FLOOR:
                        var _f = instance_create_layer(px, py, layer_name, obj_floor);
                        _f.depth       = 50;
                        _f.floor_style = 0;
                        _f.room_theme  = room_type;
                        break;

                    case TILE_CARPET:
                        var _cf0 = instance_create_layer(px, py, layer_name, obj_floor);
                        _cf0.depth       = 50;
                        _cf0.floor_style = 1;
                        _cf0.room_theme  = room_type;
                        break;

                    case TILE_ELEVATOR_FLOOR:
                        var _ef = instance_create_layer(px, py, layer_name, obj_floor);
                        _ef.depth       = 50;
                        _ef.floor_style = 2;
                        _ef.room_theme  = room_type;
                        break;

                    case TILE_PROP_PC:
                    case TILE_PROP_CHAIR:
                    case TILE_PROP_PAPER:
                    case TILE_PROP_OVERRIDE:
                    case TILE_PROP_BREAKER:
                        var _pf = instance_create_layer(px, py, layer_name, obj_floor);
                        _pf.depth       = 50;
                        _pf.floor_style = (tile_val == TILE_PROP_OVERRIDE || tile_val == TILE_PROP_BREAKER) ? 1 : 0;
                        _pf.room_theme  = room_type;
                        var _pr = instance_create_layer(px, py, layer_name, obj_dungeon_prop);
                        _pr.depth       = (tile_val == TILE_PROP_PAPER) ? 45 : (28 - tile_row);
                        _pr.prop_type   = tile_val;
                        if (tile_val == TILE_PROP_OVERRIDE) {
                            global.override_prop_inst = _pr;
                        } else if (tile_val == TILE_PROP_BREAKER) {
                            global.breaker_prop_inst = _pr;
                        } else if (room_type == ROOM_HOLDING) {
                            _pr.is_holding_clue = true;
                            if (tile_val == TILE_PROP_PC) {
                                _pr.has_clue = true;
                            }
                        } else if (tile_val == TILE_PROP_CHAIR) {
                            var _left_wall  = (tile_col > 0 && template[tile_row][tile_col - 1] == TILE_WALL);
                            var _right_wall = (tile_col < CHUNK_SIZE - 1 && template[tile_row][tile_col + 1] == TILE_WALL);
                            var _south_wall = (tile_row < CHUNK_SIZE - 1 && template[tile_row + 1][tile_col] == TILE_WALL);
                            var _north_wall = (tile_row > 0 && template[tile_row - 1][tile_col] == TILE_WALL);

                            if (_left_wall && !_right_wall) {
                                _pr.cabinet_variant = 1; // side_left
                            } else if (_right_wall && !_left_wall) {
                                _pr.cabinet_variant = 2; // side_right
                            } else if (_south_wall && !_north_wall) {
                                _pr.cabinet_variant = 3; // back
                            } else if (_north_wall && !_south_wall) {
                                _pr.cabinet_variant = 0; // front
                            } else {
                                _pr.cabinet_variant = (tile_row >= 4) ? 3 : 0;
                            }
                        } else if (tile_val == TILE_PROP_PC) {
                            var _in_enc = (room_type == ROOM_CAESAR_LOCKED) || (room_type == ROOM_NORMAL && instance_exists(obj_dungeon_generator)
                                && variable_instance_exists(obj_dungeon_generator, "room_is_encrypted")
                                && obj_dungeon_generator.room_is_encrypted[logic_col][logic_row]);
                            _pr.spawn_room_type = room_type;
                            _pr.spawn_in_enc    = _in_enc;
                            _pr.is_south_facing = (tile_row >= 4);
                            if (_in_enc) {
                                // Encrypted Security / Decoy Rooms contain High-Yield Prototype Servers
                                _pr.is_server_rack = true;
                            }
                            array_push(pc_list, _pr);
                        }
                        break;

                    case TILE_DOOR:
                        var _df = instance_create_layer(px, py, layer_name, obj_floor);
                        _df.depth       = 50;
                        _df.floor_style = 1;
                        _df.room_theme  = room_type;
                        var _d = instance_create_layer(px, py, layer_name, obj_doorway);
                        _d.depth         = 26;
                        _d.door_type     = "normal";
                        _d.is_locked     = false;
                        _d.starts_locked = false;
                        break;

                    case TILE_LOCK_QUIZ:
                        var _qf = instance_create_layer(px, py, layer_name, obj_floor);
                        _qf.depth       = 50;
                        _qf.floor_style = 1;
                        _qf.room_theme  = room_type;
                        var _qd = instance_create_layer(px, py, layer_name, obj_doorway);
                        _qd.depth         = 26;
                        _qd.door_type     = "quiz";
                        _qd.is_locked     = true;
                        _qd.starts_locked = true;
                        var _ql = instance_create_layer(px, py, layer_name, obj_door_quiz_lock);
                        _ql.depth        = 25;
                        _ql.doorway_inst = _qd;
                        _qd.lock_inst    = _ql;
                        break;

                    case TILE_LOCK_CAESAR:
                        var _cf = instance_create_layer(px, py, layer_name, obj_floor);
                        _cf.depth       = 50;
                        _cf.floor_style = 1;
                        _cf.room_theme  = room_type;
                        var _cd = instance_create_layer(px, py, layer_name, obj_doorway);
                        _cd.depth         = 26;
                        _cd.door_type     = (room_type == ROOM_POWER) ? "breaker" : ((room_type == ROOM_CAESAR_LOCKED) ? "lockdown" : "caesar");
                        _cd.is_locked     = true;
                        _cd.starts_locked = true;
                        var _cl = instance_create_layer(px, py, layer_name, obj_door_caesar_lock);
                        _cl.depth            = 25;
                        _cl.doorway_inst     = _cd;
                        _cd.lock_inst        = _cl;
                        _cl.is_elevator_door = (room_type == ROOM_END);
                        _cl.is_holding_door  = (room_type == ROOM_HOLDING);
                        _cl.is_breaker_door  = (room_type == ROOM_POWER);
                        _cl.is_lockdown_door = (room_type == ROOM_CAESAR_LOCKED);
                        break;

                    default:
                        show_debug_message(
                            "[scr_dungeon_spawn] WARNING: Unknown tile value " +
                            string(tile_val) + " at template[" +
                            string(tile_row) + "][" + string(tile_col) + "]"
                        );
                        break;
                }

            } // tile_col
        } // tile_row

        // Center pixel of this 9x9 room chunk (tile index 4 + half tile)
        var center_x = world_x + (floor(CHUNK_SIZE / 2) * TILE_SIZE) + (TILE_SIZE * 0.5);
        var center_y = world_y + (floor(CHUNK_SIZE / 2) * TILE_SIZE) + (TILE_SIZE * 0.5);

        // Place Jack at the center of the Start room on every new floor, plus a receptionist coworker NPC
        if (room_type == ROOM_START) {
            if (instance_exists(obj_jack)) {
                obj_jack.x = center_x;
                obj_jack.y = center_y;
                obj_jack.isInCutscene = false;
            }
            var _start_npc = instance_create_layer(world_x + 2 * TILE_SIZE, world_y + 2 * TILE_SIZE, layer_name, obj_dungeon_prop);
            _start_npc.prop_type      = TILE_PROP_NPC;
            _start_npc.npc_id         = 2; // Kyle (Security Analyst) acts as the Start Room Mentor!
            _start_npc.myName         = "Kyle (Security Analyst)";
            _start_npc.npc_spr        = spr_kyle_idle;
            _start_npc.myPortrait     = spr_kyle_portrait;
            _start_npc.myPortraitTalk = spr_kyle_portrait;
            _start_npc.myVoice        = snd_voice2;
            _start_npc.init_done      = true;
            global.floor_mentor_inst  = _start_npc;
            npc_seq++;
        }

        // Spawn a hacked security drone patrolling the exact centerline of the Hallway Spine (if enabled on this floor),
        // plus Security Lockers along the hallway walls so the player can hide from the drone's vision cone!
        if (room_type == ROOM_HALLWAY) {
            hall_seq++;
            var _spawn_drone = (variable_global_exists("floor_curriculum") && variable_struct_exists(global.floor_curriculum, "spawn_drone"))
                ? global.floor_curriculum.spawn_drone
                : true;
            if ((hall_seq == 2 || (hall_seq == 5 && variable_global_exists("chapter_floor") && global.chapter_floor >= 4)) && _spawn_drone) {
                var _hall_drone = instance_create_layer(world_x + 4 * TILE_SIZE, world_y + 4 * TILE_SIZE, layer_name, obj_dungeon_prop);
                _hall_drone.prop_type      = TILE_PROP_DRONE;
                _hall_drone.wp_index       = (hall_seq == 5) ? 4 : 1;
                _hall_drone.wp_dir         = (hall_seq == 5) ? -1 : 1;
                _hall_drone.myName         = "Security Drone";
                _hall_drone.myPortrait     = spr_jack_portrait;
                _hall_drone.myPortraitTalk = spr_jack_portrait;
                _hall_drone.init_done      = true;
            }

            // Place a Hiding Locker against a non-doorway wall of this hallway segment
            var _lx = world_x + 3 * TILE_SIZE;
            var _ly = world_y + 3 * TILE_SIZE;
            var _lvariant = 0;
            if (top_tile == TILE_WALL) {
                _lx = world_x + 4 * TILE_SIZE;
                _ly = world_y + 3 * TILE_SIZE;
                _lvariant = 0; // North wall: front door faces player
            } else if (bottom_tile == TILE_WALL) {
                _lx = world_x + 4 * TILE_SIZE;
                _ly = world_y + 5 * TILE_SIZE;
                _lvariant = 1; // South wall: side/back profile
            } else if (left_tile == TILE_WALL) {
                _lx = world_x + 3 * TILE_SIZE;
                _ly = world_y + 4 * TILE_SIZE;
                _lvariant = 1; // West wall: side profile
            } else if (right_tile == TILE_WALL) {
                _lx = world_x + 5 * TILE_SIZE;
                _ly = world_y + 4 * TILE_SIZE;
                _lvariant = 1; // East wall: side profile
            }
            var _locker = instance_create_layer(_lx, _ly, layer_name, obj_dungeon_prop);
            _locker.prop_type      = TILE_PROP_LOCKER;
            _locker.locker_variant = _lvariant;
            _locker.depth          = 26;
        }

        // Populate Normal Office rooms with stranded coworkers (safe from hallway drones)
        if (room_type == ROOM_NORMAL) {
            if ((npc_seq mod 2) == 0) {
                var _office_npc = instance_create_layer(world_x + 4 * TILE_SIZE, world_y + 4 * TILE_SIZE, layer_name, obj_dungeon_prop);
                _office_npc.prop_type = TILE_PROP_NPC;
                _office_npc.npc_id    = (npc_seq++) mod 5;
            } else {
                npc_seq++;
            }
        }

        // Place the Caesar Key Pedestal at the center of ROOM_CAESAR_KEY
        if (room_type == ROOM_CAESAR_KEY) {
            instance_create_layer(center_x, center_y, layer_name, obj_caesar_key_pedestal);
        }

        // Record the Security Holding Room coordinates (where drones send Jack if caught)
        if (room_type == ROOM_HOLDING) {
            global.holding_room_x   = center_x;
            global.holding_room_y   = center_y;
            global.holding_room_col = logic_col;
            global.holding_room_row = logic_row;
        }

        // Place the extraction goal beacon at the center of the End room
        if (room_type == ROOM_END) {
            instance_create_layer(center_x, center_y, layer_name, obj_dungeon_goal);
        }

    } // path index

    // =====================================================================
    // WHODUNIT PLACEMENT: suspect desks + evidence trail + IT help-desk tips
    // =====================================================================
    var _susp_n = variable_global_exists("case_suspects") ? array_length(global.case_suspects) : 0;
    var _ev_n   = variable_global_exists("case_evidence") ? array_length(global.case_evidence) : 0;

    if (_susp_n > 0) {
        // Split eligible PCs (ordinary offices only - never the Override/Breaker/Key/Elevator rooms)
        var _open_pool = [];
        var _enc_pool  = [];
        for (var _pi = 0; _pi < array_length(pc_list); _pi++) {
            var _cpc = pc_list[_pi];
            if (_cpc.spawn_room_type != ROOM_NORMAL) continue;
            if (_cpc.spawn_in_enc) array_push(_enc_pool, _cpc); else array_push(_open_pool, _cpc);
        }
        for (var _sh = 0; _sh < 2; _sh++) {
            var _arr = (_sh == 0) ? _open_pool : _enc_pool;
            for (var _a = array_length(_arr) - 1; _a > 0; _a--) {
                var _b = irandom(_a);
                var _t = _arr[_a];
                _arr[_a] = _arr[_b];
                _arr[_b] = _t;
            }
        }

        var _ov_x = (variable_global_exists("override_prop_inst") && instance_exists(global.override_prop_inst)) ? global.override_prop_inst.x : -9999;
        var _ov_y = (variable_global_exists("override_prop_inst") && instance_exists(global.override_prop_inst)) ? global.override_prop_inst.y : -9999;

        // Culprit's desk first: prefer a far-away encrypted room, never next to the Override console
        var _cul_i  = global.case_culprit_idx;
        var _cul_pc = scr_case_pick_pc(_enc_pool, _ov_x, _ov_y, 220);
        if (_cul_pc == noone) _cul_pc = scr_case_pick_pc(_open_pool, _ov_x, _ov_y, 220);
        var _desk_pcs = array_create(_susp_n, noone);
        _desk_pcs[_cul_i] = _cul_pc;

        // Innocent suspects: prefer open offices so the player can clear them early
        for (var _si = 0; _si < _susp_n; _si++) {
            if (_si == _cul_i) continue;
            var _ipc = scr_case_pick_pc(_open_pool, 0, 0, 0);
            if (_ipc == noone) _ipc = scr_case_pick_pc(_enc_pool, 0, 0, 0);
            _desk_pcs[_si] = _ipc;
        }

        var _desks_ok = true;
        for (var _si2 = 0; _si2 < _susp_n; _si2++) {
            var _dpc = _desk_pcs[_si2];
            if (_dpc == noone) { _desks_ok = false; continue; }
            _dpc.suspect_idx    = _si2;
            _dpc.nameplate      = global.case_suspects[_si2].nameplate;
            _dpc.has_clue       = true;
            _dpc.is_server_rack = false;
        }
        // Safety net: if the floor has too few PCs, auto-solve so the player is never soft-locked
        if (!_desks_ok) {
            global.incident_solved = true;
            global.case_culprit_confirmed = true;
            show_debug_message("[scr_dungeon_spawn] Not enough PCs for suspect desks; case auto-solved.");
        }

        // Gather NPC coworkers & memos that can deliver evidence (keeping enough as Key Vault IT tips)
        var _npcs   = [];
        var _papers = [];
        var _mentor = variable_global_exists("floor_mentor_inst") ? global.floor_mentor_inst : noone;
        with (obj_dungeon_prop) {
            if (is_holding_clue) continue;
            if (prop_type == TILE_PROP_NPC && id != _mentor) array_push(_npcs, id);
            if (prop_type == TILE_PROP_PAPER) array_push(_papers, id);
        }
        var _tips_needed = variable_global_exists("clues_needed") ? global.clues_needed : 2;

        // 1) Witness statements -> NPCs (while enough tip sources remain)
        var _placed = array_create(_ev_n, false);
        for (var _e = 0; _e < _ev_n; _e++) {
            if (global.case_evidence[_e].type != "witness") continue;
            if (array_length(_npcs) > 0 && (array_length(_npcs) - 1 + array_length(_papers)) >= _tips_needed) {
                var _wn = array_pop(_npcs);
                _wn.evidence_idx = _e;
                _placed[_e] = true;
            }
        }
        // 2) Everything else -> open-office terminals
        for (var _e2 = 0; _e2 < _ev_n; _e2++) {
            if (_placed[_e2]) continue;
            var _epc = scr_case_pick_pc(_open_pool, 0, 0, 0);
            if (_epc != noone) {
                _epc.evidence_idx = _e2;
                _epc.has_clue     = true;
                _placed[_e2]      = true;
            }
        }
        // 3) Overflow -> memos / NPCs (still leaving enough IT tips for the Key Vault)
        for (var _e3 = 0; _e3 < _ev_n; _e3++) {
            if (_placed[_e3]) continue;
            if (array_length(_papers) > 0 && (array_length(_papers) - 1 + array_length(_npcs)) >= _tips_needed) {
                var _pp = array_pop(_papers);
                _pp.evidence_idx = _e3;
                _placed[_e3] = true;
            } else if (array_length(_npcs) > 0 && (array_length(_npcs) - 1 + array_length(_papers)) >= _tips_needed) {
                var _nn = array_pop(_npcs);
                _nn.evidence_idx = _e3;
                _placed[_e3] = true;
            }
        }
        // 4) Still unplaced -> pre-filed in the case briefing so the case stays solvable
        for (var _e4 = 0; _e4 < _ev_n; _e4++) {
            if (!_placed[_e4]) {
                scr_log_evidence(_e4);
                show_debug_message("[scr_dungeon_spawn] Evidence " + string(_e4) + " pre-filed (no free prop).");
            }
        }

        // Key Vault IT tips = remaining memos + coworkers; never demand more than exist
        var _tips = array_length(_papers) + array_length(_npcs);
        if (variable_global_exists("clues_needed")) {
            global.clues_needed = min(global.clues_needed, _tips);
            if (_tips <= 0) global.clues_found = global.clues_needed;
        }
    }

    // Mark both sides of the Holding Room's doorway threshold as is_holding_door = true
    if (variable_global_exists("holding_room_x") && global.holding_room_x > 0) {
        var _hx = global.holding_room_x;
        var _hy = global.holding_room_y;
        with (obj_door_caesar_lock) {
            if (point_distance(draw_x + 8, draw_y + 8, _hx, _hy) <= 85) {
                is_holding_door = true;
            }
        }
    }

    // Mark both sides of the Power Breaker Room's doorway threshold as is_breaker_door = true
    if (variable_global_exists("breaker_prop_inst") && instance_exists(global.breaker_prop_inst)) {
        var _bx = global.breaker_prop_inst.x + 8;
        var _by = global.breaker_prop_inst.y + 8;
        with (obj_door_caesar_lock) {
            if (point_distance(draw_x + 8, draw_y + 8, _bx, _by) <= 85) {
                is_breaker_door = true;
                if (variable_instance_exists(id, "doorway_inst") && instance_exists(doorway_inst)) {
                    doorway_inst.door_type = "breaker";
                }
            }
        }
        with (obj_doorway) {
            if (point_distance(x + 8, y + 8, _bx, _by) <= 85) {
                door_type = "breaker";
            }
        }
    }

    // Mark both sides of the Security / Lockdown Room's doorway threshold as is_lockdown_door = true
    if (variable_global_exists("override_prop_inst") && instance_exists(global.override_prop_inst)) {
        var _ox = global.override_prop_inst.x + 8;
        var _oy = global.override_prop_inst.y + 8;
        with (obj_door_caesar_lock) {
            if (point_distance(draw_x + 8, draw_y + 8, _ox, _oy) <= 85) {
                is_lockdown_door = true;
                if (variable_instance_exists(id, "doorway_inst") && instance_exists(doorway_inst)) {
                    doorway_inst.door_type = "lockdown";
                }
            }
        }
        with (obj_doorway) {
            if (point_distance(x + 8, y + 8, _ox, _oy) <= 85) {
                door_type = "lockdown";
            }
        }
    }

    // Mark both sides of the Extraction Elevator Room's doorway threshold as is_elevator_door = true
    if (instance_exists(obj_dungeon_goal)) {
        var _gx = obj_dungeon_goal.x;
        var _gy = obj_dungeon_goal.y;
        with (obj_door_caesar_lock) {
            if (point_distance(draw_x + 8, draw_y + 8, _gx, _gy) <= 85) {
                is_elevator_door = true;
            }
        }
    }

    // Set south walls to depth = 18 so they overlap objects (depth 24) but stay behind lighting/shadow (depth 10)
    with (obj_dungeon_wall) {
        if (wall_style != 1) {
            var _floor_north = instance_position(x + 8, y - 8, obj_floor);
            var _floor_south = instance_position(x + 8, y + 24, obj_floor);
            if (_floor_north != noone && _floor_south == noone) {
                is_south_wall = true;
                depth = 18;
            }
        }
    }

    show_debug_message("[scr_dungeon_spawn] Spawning complete. Total rooms: " + string(path_len));
}
