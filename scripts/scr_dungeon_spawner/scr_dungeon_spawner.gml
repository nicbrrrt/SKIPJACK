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
                        _pr.depth       = (tile_val == TILE_PROP_PAPER) ? 45 : 24;
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
                        } else if (tile_val == TILE_PROP_PC) {
                            if (room_type == ROOM_NORMAL && instance_exists(obj_dungeon_generator)
                                && variable_instance_exists(obj_dungeon_generator, "room_is_encrypted")
                                && obj_dungeon_generator.room_is_encrypted[logic_col][logic_row])
                            {
                                // Encrypted Decoy Rooms contain High-Yield Prototype Servers (+3 Scrap, +1 Rare Core)!
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
                        _d.depth            = 26;
                        _d.has_lock_overlay = false;
                        break;

                    case TILE_LOCK_QUIZ:
                        var _qf = instance_create_layer(px, py, layer_name, obj_floor);
                        _qf.depth       = 50;
                        _qf.floor_style = 1;
                        _qf.room_theme  = room_type;
                        var _qd = instance_create_layer(px, py, layer_name, obj_doorway);
                        _qd.depth            = 40;
                        _qd.has_lock_overlay = true;
                        var _ql = instance_create_layer(px, py, layer_name, obj_door_quiz_lock);
                        _ql.depth = 25;
                        break;

                    case TILE_LOCK_CAESAR:
                        var _cf = instance_create_layer(px, py, layer_name, obj_floor);
                        _cf.depth       = 50;
                        _cf.floor_style = 1;
                        _cf.room_theme  = room_type;
                        var _cd = instance_create_layer(px, py, layer_name, obj_doorway);
                        _cd.depth            = 40;
                        _cd.has_lock_overlay = true;
                        var _cl = instance_create_layer(px, py, layer_name, obj_door_caesar_lock);
                        _cl.depth            = 25;
                        _cl.is_elevator_door = (room_type == ROOM_END);
                        _cl.is_holding_door  = (room_type == ROOM_HOLDING);
                        _cl.is_breaker_door  = (room_type == ROOM_POWER);
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
            if (top_tile == TILE_WALL) {
                _lx = world_x + 4 * TILE_SIZE;
                _ly = world_y + 3 * TILE_SIZE;
            } else if (bottom_tile == TILE_WALL) {
                _lx = world_x + 4 * TILE_SIZE;
                _ly = world_y + 5 * TILE_SIZE;
            } else if (left_tile == TILE_WALL) {
                _lx = world_x + 3 * TILE_SIZE;
                _ly = world_y + 4 * TILE_SIZE;
            } else if (right_tile == TILE_WALL) {
                _lx = world_x + 5 * TILE_SIZE;
                _ly = world_y + 4 * TILE_SIZE;
            }
            var _locker = instance_create_layer(_lx, _ly, layer_name, obj_dungeon_prop);
            _locker.prop_type = TILE_PROP_LOCKER;
            _locker.depth     = 26;
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

    // Select ONLY 2 specific computers across the floor to hold Case Clues
    var _num_pcs = array_length(pc_list);
    if (_num_pcs > 0) {
        // Shuffle pc_list
        for (var _pi = _num_pcs - 1; _pi > 0; _pi--) {
            var _pj  = irandom(_pi);
            var _tmp = pc_list[_pi];
            pc_list[_pi] = pc_list[_pj];
            pc_list[_pj] = _tmp;
        }
        var _clue_pc_count = min(2, _num_pcs);
        for (var _ci = 0; _ci < _clue_pc_count; _ci++) {
            pc_list[_ci].has_clue    = true;
            pc_list[_ci].log_variant = _ci;
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

    show_debug_message("[scr_dungeon_spawn] Spawning complete. Total rooms: " + string(path_len));
}
