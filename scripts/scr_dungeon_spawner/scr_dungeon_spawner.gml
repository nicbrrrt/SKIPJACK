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
/// @function scr_dungeon_spawn(logic_map, path_list)
/// @param {Array<Array<real>>} logic_map   The 2D grid of ROOM_* constants
/// @param {Array<Array<real>>} path_list   Ordered list of [col, row] pairs
/// @description Main spawner entry point. Iterates over every room in path_list,
///              retrieves its 9x9 template, and instantiates tile objects.
// ---------------------------------------------------------------------------
function scr_dungeon_spawn(logic_map, path_list) {

    var layer_name = "Instances"; // Must match an existing layer in the target room

    var path_len = array_length(path_list);

    show_debug_message("[scr_dungeon_spawn] Spawning " + string(path_len) + " rooms...");

    for (var p = 0; p < path_len; p++) {

        var logic_col = path_list[p][0];
        var logic_row = path_list[p][1];
        var room_type = logic_map[logic_col][logic_row];

        // Skip any slots that somehow ended up unoccupied (safety guard)
        if (room_type == ROOM_NONE) continue;

        // Retrieve the 9x9 tile template for this room type
        var template = scr_get_template(room_type);

        // Determine which neighboring rooms are connected to this room.
        // We check the consecutive path connections (where the player came from and where they go next).
        var has_top    = false;
        var has_bottom = false;
        var has_left   = false;
        var has_right  = false;

        // Check connection to previous room in the path
        if (p > 0) {
            var _pc = path_list[p - 1][0];
            var _pr = path_list[p - 1][1];
            if (_pc == logic_col && _pr == logic_row - 1) has_top    = true;
            if (_pc == logic_col && _pr == logic_row + 1) has_bottom = true;
            if (_pc == logic_col - 1 && _pr == logic_row) has_left   = true;
            if (_pc == logic_col + 1 && _pr == logic_row) has_right  = true;
        }

        // Check connection to next room in the path
        if (p < path_len - 1) {
            var _nc = path_list[p + 1][0];
            var _nr = path_list[p + 1][1];
            if (_nc == logic_col && _nr == logic_row - 1) has_top    = true;
            if (_nc == logic_col && _nr == logic_row + 1) has_bottom = true;
            if (_nc == logic_col - 1 && _nr == logic_row) has_left   = true;
            if (_nc == logic_col + 1 && _nr == logic_row) has_right  = true;
        }

        // Carve 3-tile-wide doorways (tiles 3, 4, 5) ONLY on borders that connect to a neighboring room;
        // any border facing empty space remains a 100% solid wall.
        for (var _d_idx = 3; _d_idx <= 5; _d_idx++) {
            template[0][_d_idx] = has_top    ? TILE_DOOR : TILE_WALL; // Top border center
            template[8][_d_idx] = has_bottom ? TILE_DOOR : TILE_WALL; // Bottom border center
            template[_d_idx][0] = has_left   ? TILE_DOOR : TILE_WALL; // Left border center
            template[_d_idx][8] = has_right  ? TILE_DOOR : TILE_WALL; // Right border center
        }

        // World-space top-left corner of this chunk (in pixels)
        var world_x = logic_col * (CHUNK_SIZE * TILE_SIZE);
        var world_y = logic_row * (CHUNK_SIZE * TILE_SIZE);

        show_debug_message(
            "[scr_dungeon_spawn] Room " + string(p) +
            " type=" + string(room_type) +
            " logic=(" + string(logic_col) + "," + string(logic_row) + ")" +
            " doors=[T:" + string(has_top) + " B:" + string(has_bottom) + " L:" + string(has_left) + " R:" + string(has_right) + "]"
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

        // Place the extraction goal beacon at the center of the End room
        if (room_type == ROOM_END) {
            instance_create_layer(center_x, center_y, layer_name, obj_dungeon_goal);
        }

    } // path index

    show_debug_message("[scr_dungeon_spawn] Spawning complete. Total rooms: " + string(path_len));
}
