// --- Create Event for obj_player ---

// --- SPRITES ---
// !!! REPLACE THESE with your *actual* sprite asset names
spr_idle = spr_player2_idle; // The sprite with your 1 front-facing idle anim
spr_walk = spr_player2_walk; // The sprite with your Left/Right walk anims

// --- ANIMATION ---
anim_speed = 0.2; // How fast animations play

// Store the player's last HORIZONTAL facing direction
// 1 = Right, -1 = Left
last_move_x = 1; // Default to facing right

// --- ANIMATION DATA ---
// Data for your WALKING sprite
anim_walk_data = {
    right_start: 0,    // Frames 0-5
    left_start: 6,     // Frames 6-11
    frames_per_anim: 6 // 6 frames in each anim
};

// Data for your IDLE sprite
anim_idle_data = {
    front_start: 0,    // Assuming your front idle starts at frame 0
    frames_per_anim: 6 // Assuming it's also 6 frames
};

// These variables will track our current animation
current_anim_start = anim_idle_data.front_start;
current_anim_frames = anim_idle_data.frames_per_anim;