// --- Room Start Event for obj_jack ---

// 1. RE-SCAN FOR COLLISION LAYER
// In every room, make sure your wall tile layer is named "Collision"
my_tilemap = layer_tilemap_get_id("Collision");

// 2. BACKGROUND MUSIC — each zone has its own track; stop the other on entry
if (room == rm_cutscene_lab || room == rm_hallway || room == rm_homeroom) {
    audio_stop_sound(snd_rm_level_1_city_music);
    audio_stop_sound(corporate);
    audio_stop_sound(snd_intern_minigame);
    if (!audio_is_playing(snd_generic_background_music)) {
        audio_play_sound(snd_generic_background_music, 10, true);
    }
} else if (room == dungeon_test) {
    audio_stop_sound(snd_generic_background_music);
    audio_stop_sound(snd_rm_level_1_city_music);
    
    if (variable_global_exists("intern_duty_flagged") && global.intern_duty_flagged) {
        audio_stop_sound(corporate);
        if (!audio_is_playing(snd_intern_minigame)) {
            var _bgm = audio_play_sound(snd_intern_minigame, 10, true);
            audio_sound_gain(_bgm, 0.75, 0);
        }
        x = 320 + 20 * 16 + 8; // 648 (Central Hallway)
        y = 240 + 12 * 16 + 8; // 440
        visible      = true;
        isInCutscene = false;
        bump_timer   = 0;
        sprite_index = spr_jack_idle;
    } else {
        audio_stop_sound(snd_intern_minigame);
        if (!audio_is_playing(corporate)) {
            var _bgm = audio_play_sound(corporate, 10, true);
            audio_sound_gain(_bgm, 0.45, 0); // Lowered volume of corporate a tad bit
        }
    }
} else if (room == rm_level_1) {
    audio_stop_sound(snd_generic_background_music);
    audio_stop_sound(corporate);
    audio_stop_sound(snd_intern_minigame);
    if (!audio_is_playing(snd_rm_level_1_city_music)) {
        audio_play_sound(snd_rm_level_1_city_music, 10, true);
    }
} else {
    audio_stop_sound(snd_generic_background_music);
    audio_stop_sound(snd_rm_level_1_city_music);
    audio_stop_sound(corporate);
    audio_stop_sound(snd_intern_minigame);
}

// 3. HOMEROOM SPAWN & CAMERA SNAP
if (room == rm_homeroom) {
    x = 616;
    y = 336;
    visible      = true;
    isInCutscene = false;
    bump_timer   = 0;
    sprite_index = spr_jack_idle;

    // Reset camera pan state so camera centers cleanly on Jack in the homeroom
    global.cam_pan_phase   = "off";
    global.cam_pan_mode    = "";
    global.cam_pan_timer   = 0;
    global.cam_pan_targets = [];

    if (instance_exists(obj_camera)) {
        global.cam_width  = 320;
        global.cam_height = 180;
        camera_set_view_size(view_camera[0], 320, 180);
        camera_set_view_pos(view_camera[0], x - 160, (y - 12) - 90);
    }
}

// 4. GREG TELEPORT LOGIC
if (room == rm_level_1) {
    if (variable_global_exists("target_x") && global.target_x != -1) {
        x = global.target_x;
        y = global.target_y;
        global.target_x = -1; 
    }
}