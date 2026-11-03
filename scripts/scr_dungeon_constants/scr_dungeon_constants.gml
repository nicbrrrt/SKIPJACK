/// @description Dungeon Generation — Global Constants
/// All dungeon system constants are defined here as macros.
/// Adjust TILE_SIZE to match your floor/wall sprite dimensions.

// ---------------------------------------------------------------------------
// Tile type identifiers (used inside 9x9 room template arrays)
// ---------------------------------------------------------------------------
#macro TILE_FLOOR       0   // Walkable floor cell
#macro TILE_WALL        1   // Solid wall cell
#macro TILE_DOOR        2   // Doorway / open gap in a border wall
#macro TILE_LOCK_QUIZ   3   // Doorway locked by a Cybersecurity Question
#macro TILE_LOCK_CAESAR 4   // Doorway locked by a Caesar Cipher encryption

// ---------------------------------------------------------------------------
// Logic-map room type identifiers (used in obj_dungeon_generator's grid)
// ---------------------------------------------------------------------------
#macro ROOM_NONE          -1  // Slot is unoccupied (default)
#macro ROOM_START          1  // The starting room
#macro ROOM_NORMAL         2  // A standard traversal room
#macro ROOM_END            3  // The exit/boss room
#macro ROOM_CAESAR_KEY     4  // Locked vault room containing the Caesar cipher key
#macro ROOM_CAESAR_LOCKED  5  // Room locked behind a Caesar cipher encrypted door

// ---------------------------------------------------------------------------
// Spatial configuration
// ---------------------------------------------------------------------------
#macro CHUNK_SIZE   9   // Tiles per room chunk (width AND height)
#macro TILE_SIZE    16  // Pixels per tile — matches spr_floor_tile / spr_wall_tile (16x16)

// ---------------------------------------------------------------------------
// Logic grid dimensions (number of room slots, not pixels)
// ---------------------------------------------------------------------------
#macro LOGIC_GRID_W 10  // Logic map width  in room-slots
#macro LOGIC_GRID_H 10  // Logic map height in room-slots

// ---------------------------------------------------------------------------
// Path-length constraints
// ---------------------------------------------------------------------------
#macro MIN_PATH_LEN 5   // Minimum Normal rooms before End is allowed to place
#macro MAX_PATH_LEN 12  // Maximum Normal rooms; End is forced after this count

// ---------------------------------------------------------------------------
// Safety: maximum walker iterations before a generation retry is triggered
// ---------------------------------------------------------------------------
#macro GEN_MAX_ITER 10000
