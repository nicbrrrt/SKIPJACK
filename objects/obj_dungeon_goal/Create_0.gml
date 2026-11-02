/// @description obj_dungeon_goal — Create Event
/// Placed in the center of the End room (ROOM_END).
/// Touching this beacon triggers the victory screen and generates the next dungeon.

depth = 20; // Draws above floor tiles (50) and below Jack (-y)

// Scale the 32x32 spr_goal mask down to 16x16 (1 tile)
image_xscale = 0.5;
image_yscale = 0.5;

anim_timer = 0;
triggered  = false;

if (!variable_global_exists("dungeons_cleared")) {
    global.dungeons_cleared = 0;
}
