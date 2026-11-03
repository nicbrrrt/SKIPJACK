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
                        var _pf = instance_create_layer(px, py, layer_name, obj_floor);
                        _pf.depth       = 50;
                        _pf.floor_style = 0;
                        _pf.room_theme  = room_type;
                        var _pr = instance_create_layer(px, py, layer_name, obj_dungeon_prop);
                        _pr.depth       = (tile_val == TILE_PROP_PAPER) ? 45 : 24;
                        _pr.prop_type   = tile_val;
                        break;

                    case TILE_DOOR:
                        var _df = instance_create_layer(px, py, layer_name, obj_floor);
                        _df.depth       = 50;
                        _df.floor_style = 1;
                        _df.room_theme  = room_type;
                        var _d = instance_create_layer(px, py, layer_name, obj_doorway);
                        _d.depth = 40;
                        break;

                    case TILE_LOCK_QUIZ:
                        var _qf = instance_create_layer(px, py, layer_name, obj_floor);
                        _qf.depth       = 50;
                        _qf.floor_style = 1;
                        _qf.room_theme  = room_type;
                        var _qd = instance_create_layer(px, py, layer_name, obj_doorway);
                        _qd.depth = 40;
                        var _ql = instance_create_layer(px, py, layer_name, obj_door_quiz_lock);
                        _ql.depth = 25;
                        break;

                    case TILE_LOCK_CAESAR:
                        var _cf = instance_create_layer(px, py, layer_name, obj_floor);
                        _cf.depth       = 50;
                        _cf.floor_style = 1;
                        _cf.room_theme  = room_type;
                        var _cd = instance_create_layer(px, py, layer_name, obj_doorway);
                        _cd.depth = 40;
                        var _cl = instance_create_layer(px, py, layer_name, obj_door_caesar_lock);
                        _cl.depth = 25;
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

        // Place Jack at the center of the Start room on every new floor
        if (room_type == ROOM_START) {
            if (instance_exists(obj_jack)) {
                obj_jack.x = center_x;
                obj_jack.y = center_y;
                obj_jack.isInCutscene = false;
            }
        }

        // Place the Caesar Key Pedestal at the center of ROOM_CAESAR_KEY
        if (room_type == ROOM_CAESAR_KEY) {
            instance_create_layer(center_x, center_y, layer_name, obj_caesar_key_pedestal);
        }

        // Place the extraction goal beacon at the center of the End room
        if (room_type == ROOM_END) {
            instance_create_layer(center_x, center_y, layer_name, obj_dungeon_goal);
        }

    } // path index

    show_debug_message("[scr_dungeon_spawn] Spawning complete. Total rooms: " + string(path_len));
}
