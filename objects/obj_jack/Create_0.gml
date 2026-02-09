// --- Create Event for obj_jack ---

isInCutscene = false;

// --- MOVEMENT SETTINGS ---
move_speed = 2.5; 
anim_speed = 0.2; 

// --- STATE ---
last_move_x = 0;
last_move_y = 1; // Default to facing down

// --- ANIMATION DATA ---
anim = {
    down_start: 0,
    right_start: 6,
    up_start: 12,
    left_start: 18,  // Cleaned up for standard 6-frame sets
    frames_per_anim: 6
};

current_anim_start = anim.down_start;
current_anim_frames = anim.frames_per_anim;

// --- INITIAL SPRITE ---
sprite_index = spr_jack_idle;
image_speed = anim_speed;

// --- DYNAMIC COLLISION INIT ---
// We initialize this to -1; the Room Start event below will find the real one.
my_tilemap = -1; 

// --- DIALOGUE SYSTEM ---
myPortrait = spr_jack_portrait;
myVoice = snd_voice1;
myFont = fnt_dialogue;
myName = "Jack";