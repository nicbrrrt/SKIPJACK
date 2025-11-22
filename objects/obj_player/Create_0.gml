// --- Create Event for obj_player ---

isInCutscene = false;
// --- SPRITES ---
// !!! REPLACE THESE with your *actual* sprite asset names
spr_idle = spr_player_idle; // Your 8-frame (4R/4L) idle sprite
spr_walk = spr_player_walk; // Your 8-frame (4R/4L) walk sprite

// --- ANIMATION ---
anim_speed = 0.2; // How fast animations play

// Store the player's last HORIZONTAL facing direction
// 1 = Right, -1 = Left
last_move_x = 1; // Default to facing right

// --- ANIMATION STARTING STATE ---
// We need to set the *initial* animation state
// Since we default to facing right (last_move_x = 1),
// we should start on the "right" animation frames.
//
// Your new layout:
// Frames 0-3: Right
// Frames 4-7: Left
// Frames per anim: 4

current_anim_start = 0; // Start at the "right" animation (frame 0)
current_anim_frames = 4; // All your animations are 4 frames long