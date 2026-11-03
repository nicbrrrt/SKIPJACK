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
/// @function scr_get_border_door_type(c1, r1, c2, r2, logic_map, path_list, main_len, key_parent, key_pos)
/// @description Returns TILE_WALL if (c1,r1) and (c2,r2) are not connected,
///              or TILE_DOOR / TILE_LOCK_QUIZ / TILE_LOCK_CAESAR if connected.
// ---------------------------------------------------------------------------
function scr_get_border_door_type(c1, r1, c2, r2, logic_map, path_list, main_len, key_parent, key_pos) {
    // 1. Check if this border connects the Key Room and its parent room
    var _is_key_conn = (
        (c1 == key_parent[0] && r1 == key_parent[1] && c2 == key_pos[0] && r2 == key_pos[1]) ||
        (c2 == key_parent[0] && r2 == key_parent[1] && c1 == key_pos[0] && r1 == key_pos[1])
    );
    if (_is_key_conn) {
        return TILE_LOCK_QUIZ;
    }

    // 2. Check if (c1,r1) and (c2,r2) are consecutive steps along the main path
    for (var _i = 0; _i < main_len - 1; _i++) {
        var _ac = path_list[_i][0];
        var _ar = path_list[_i][1];
        var _bc = path_list[_i + 1][0];
        var _br = path_list[_i + 1][1];

        if ((c1 == _ac && r1 == _ar && c2 == _bc && r2 == _br) ||
            (c2 == _ac && r2 == _ar && c1 == _bc && r1 == _br)) {
            // If the forward room (_bc, _br) is ROOM_CAESAR_LOCKED, lock this doorway with a Caesar lock
            if (logic_map[_bc][_br] == ROOM_CAESAR_LOCKED) {
                return TILE_LOCK_CAESAR;
            }
            if (logic_map[_bc][_br] == ROOM_CAESAR_KEY) {
                return TILE_LOCK_QUIZ;
            }
            return TILE_DOOR;
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

    var path_len   = array_length(path_list);
    var main_len   = variable_instance_exists(id, "main_path_len")   ? main_path_len   : path_len;
    var key_parent = variable_instance_exists(id, "key_room_parent") ? key_room_parent : [-1, -1];
    var key_pos    = variable_instance_exists(id, "key_room_pos")    ? key_room_pos    : [-1, -1];

    show_debug_message("[scr_dungeon_spawn] Spawning " + string(path_len) + " rooms...");

    for (var p = 0; p < path_len; p++) {

        var logic_col = path_list[p][0];
        var logic_row = path_list[p][1];
        var room_type = logic_map[logic_col][logic_row];

        // Skip any slots that somehow ended up unoccupied (safety guard)
        if (room_type == ROOM_NONE) continue;

        // Retrieve the 9x9 tile template for this room type
        var template = scr_get_template(room_type);

        // Determine the door tile type (TILE_WALL, TILE_DOOR, TILE_LOCK_QUIZ, TILE_LOCK_CAESAR)
        // for each of the 4 cardinal borders of this room.
        var top_tile    = scr_get_border_door_type(logic_col, logic_row, logic_col,     logic_row - 1, logic_map, path_list, main_len, key_parent, key_pos);
        var bottom_tile = scr_get_border_door_type(logic_col, logic_row, logic_col,     logic_row + 1, logic_map, path_list, main_len, key_parent, key_pos);
        var left_tile   = scr_get_border_door_type(logic_col, logic_row, logic_col - 1, logic_row,     logic_map, path_list, main_len, key_parent, key_pos);
        var right_tile  = scr_get_border_door_type(logic_col, logic_row, logic_col + 1, logic_row,     logic_map, path_list, main_len, key_parent, key_pos);

        // Carve 3-tile-wide doorways (tiles 3, 4, 5) ONLY on borders that connect to a neighboring room;
        // any border facing empty space remains a 100% solid wall.
        for (var _d_idx = 3; _d_idx <= 5; _d_idx++) {
            template[0][_d_idx] = top_tile;    // Top border center
            template[8][_d_idx] = bottom_tile; // Bottom border center
            template[_d_idx][0] = left_tile;   // Left border center
            template[_d_idx][8] = right_tile;  // Right border center
        }

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
                    case TILE_WALL:
                        var _w = instance_create_layer(px, py, layer_name, obj_dungeon_wall);
                        _w.depth = 30;
                        break;

                    case TILE_FLOOR:
                        var _f = instance_create_layer(px, py, layer_name, obj_floor);
                        _f.depth = 50;
                        break;

                    case TILE_DOOR:
                        var _df = instance_create_layer(px, py, layer_name, obj_floor);
                        _df.depth = 50;
                        var _d = instance_create_layer(px, py, layer_name, obj_doorway);
                        _d.depth = 40;
                        break;

                    case TILE_LOCK_QUIZ:
                        var _qf = instance_create_layer(px, py, layer_name, obj_floor);
                        _qf.depth = 50;
                        var _qd = instance_create_layer(px, py, layer_name, obj_doorway);
                        _qd.depth = 40;
                        var _ql = instance_create_layer(px, py, layer_name, obj_door_quiz_lock);
                        _ql.depth = 25;
                        break;

                    case TILE_LOCK_CAESAR:
                        var _cf = instance_create_layer(px, py, layer_name, obj_floor);
                        _cf.depth = 50;
                        var _cd = instance_create_layer(px, py, layer_name, obj_doorway);
                        _cd.depth = 40;
                        var _cl = instance_create_layer(px, py, layer_name, obj_door_caesar_lock);
                        _cl.depth = 25;
                        break;

                    default:
                        // Unknown tile value — log and skip (do not crash)
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
