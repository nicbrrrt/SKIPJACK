// --- Create Event for obj_jack ---

// Variable for cutscene logic
isInCutscene = false;

// --- COLLISION LAYERS ---
// 1. Define the new lab layers
wall_layer_1 = layer_tilemap_get_id("ts_lab2"); 
wall_layer_2 = layer_tilemap_get_id("ts_lab3"); 
wall_layer_main = layer_tilemap_get_id("ts_lab"); 

// 2. DEFINE THE MISSING VARIABLE (Your main walls)
// Make sure "Tiles_1" matches your actual layer name in the Room Editor!
my_tilemap = layer_tilemap_get_id("Buildings");
tilemap2 = layer_tilemap_get_id("Design");
tilemap1 = layer_tilemap_get_id("Lab");
tilemap3 = layer_tilemap_get_id("Lab2");
tilemap4 = layer_tilemap_get_id("Lab3");
tilemap5 = layer_tilemap_get_id("Lab4");

// Also keep your generic one if you use it elsewhere
// my_tilemap = layer_tilemap_get_id("Tiles_1");

// --- SPRITES ---
spr_idle = spr_jack_idle;
spr_walk = spr_jack_walk;

// --- MOVEMENT ---
move_speed = 2.5; 
anim_speed = 0.2; 

// --- STATE ---
// These MUST be here to save your direction
last_move_x = 0;
last_move_y = 1; // Default to facing down

// --- ANIMATION DATA (THIS IS THE FIX) ---
// Your old code almost certainly had a typo here.
// This is the correct data for your 24-frame, 6-frame-per-direction sprites.
anim = {
    down_start: 0,
    right_start: 6,
    up_start: 12,
    left_start: 19,  // <-- This was probably 12
    frames_per_anim: 6
};

// --- STARTING ANIMATION ---
current_anim_start = anim.down_start;
current_anim_frames = anim.frames_per_anim;

// --- SET SPRITE ---
sprite_index = spr_idle;
image_speed = anim_speed;

// --- DIALOGUE SYSTEM VARIABLES ---
myPortrait = spr_jack_portrait; // Change this to your actual portrait sprite!
myVoice = snd_voice1;             // Change to your voice sound (or set to noone)
myFont = fnt_dialogue; // Or whatever your font is named
myName = "Jack";                  // The name displayed in the text box