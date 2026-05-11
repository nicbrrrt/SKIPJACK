// --- Room Start Event for obj_jack ---

// 1. RE-SCAN FOR COLLISION LAYER
// In every room, make sure your wall tile layer is named "Collision"
my_tilemap = layer_tilemap_get_id("Collision");

// 2. BACKGROUND MUSIC — each zone has its own track; stop the other on entry
if (room == rm_cutscene_lab || room == rm_hallway) {
    audio_stop_sound(snd_rm_level_1_city_music);
    if (!audio_is_playing(snd_generic_background_music)) {
        audio_play_sound(snd_generic_background_music, 10, true);
    }
} else if (room == rm_level_1) {
    audio_stop_sound(snd_generic_background_music);
    if (!audio_is_playing(snd_rm_level_1_city_music)) {
        audio_play_sound(snd_rm_level_1_city_music, 10, true);
    }
} else {
    audio_stop_sound(snd_generic_background_music);
    audio_stop_sound(snd_rm_level_1_city_music);
}

// 2. GREG TELEPORT LOGIC
if (room == rm_level_1) {
    if (variable_global_exists("target_x") && global.target_x != -1) {
        x = global.target_x;
        y = global.target_y;
        global.target_x = -1; 
    }
}