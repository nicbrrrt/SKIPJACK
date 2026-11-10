/// @description obj_intern_ward_controller ?" Create Event
shift_timer_max = 180 * 60; // 3 minutes at 60 fps (10,800 frames)
shift_timer     = shift_timer_max;
shift_ended     = false;
shift_grade     = "A";
interns_saved   = 10;
interns_lost    = 0;
fried_count     = 0;
total_fines     = 0;

floor_oxygen        = 100.0;
asphyxiation_active = false;
asphyxiation_fail   = false;
hands_full_alert    = 0;

door_work       = noone;
door_storage    = noone;
door_green      = noone;
door_glass      = noone;
vent_work       = noone;
vent_storage    = noone;
vent_glass      = noone;
green_count     = 0;

intro_shown     = false;
alarm_siren     = 0;
global.player_has_mop    = false;
global.player_has_wrench = false;
threat_diff     = scr_intern_get_scrap_difficulty();

// Music: ensure intern babysitting minigame music plays
audio_stop_sound(corporate);
if (!audio_is_playing(snd_intern_minigame)) {
    var _bgm = audio_play_sound(snd_intern_minigame, 10, true);
    audio_sound_gain(_bgm, 0.75, 0);
}
if (!instance_exists(obj_music_controller)) {
    instance_create_depth(0, 0, 0, obj_music_controller);
}

// Reset camera pan state so camera centers cleanly on Jack in the ward
global.cam_pan_phase   = "off";
global.cam_pan_mode    = "";
global.cam_pan_timer   = 0;
global.cam_pan_targets = [];

// Dialogue speaker defaults (Kyle - Security Analyst / HR Compliance)
myName         = "Kyle (Security Analyst)";
myPortrait     = spr_kyle_portrait;
myPortraitTalk = spr_kyle_portrait;
myPortraitIdle = spr_kyle_portrait;
myVoice        = snd_voice2;
myFont         = fnt_dialogue;
