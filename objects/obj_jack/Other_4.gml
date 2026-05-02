// --- Room Start Event for obj_jack ---

// 1. RE-SCAN FOR COLLISION LAYER
// In every room, make sure your wall tile layer is named "Collision"
my_tilemap = layer_tilemap_get_id("Collision");

// 2. BACKGROUND MUSIC — play through cutscene lab and hallway without resetting
if (room == rm_cutscene_lab || room == rm_hallway) {
    if (!audio_is_playing(snd_generic_background_music)) {
        audio_play_sound(snd_generic_background_music, 10, true);
    }
} else {
    audio_stop_sound(snd_generic_background_music);
}

// 2. GREG TELEPORT LOGIC
if (room == rm_level_1) {
    if (variable_global_exists("target_x") && global.target_x != -1) {
        x = global.target_x;
        y = global.target_y;
        global.target_x = -1; 
    }
}