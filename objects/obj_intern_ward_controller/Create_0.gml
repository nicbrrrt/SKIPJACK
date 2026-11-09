/// @description obj_intern_ward_controller ?" Create Event
shift_timer_max = 180 * 60; // 3 minutes at 60 fps (10,800 frames)
shift_timer     = shift_timer_max;
shift_ended     = false;
shift_grade     = "A";
interns_saved   = 10;
interns_lost    = 0;
fried_count     = 0;
total_fines     = 0;

oxygen_work     = 100.0;
oxygen_storage  = 100.0;
oxygen_glass    = 100.0;

door_work       = noone;
door_storage    = noone;
door_green      = noone;
door_glass      = noone;
green_count     = 0;

intro_shown     = false;
alarm_siren     = 0;

// Music: ensure corporate music plays
if (!instance_exists(obj_music_controller)) {
    instance_create_depth(0, 0, 0, obj_music_controller);
}

// Dialogue speaker defaults (Kyle - Security Analyst / HR Compliance)
myName         = "Kyle (Security Analyst)";
myPortrait     = spr_kyle_portrait;
myPortraitTalk = spr_kyle_portrait;
myPortraitIdle = spr_kyle_portrait;
myVoice        = snd_voice2;
myFont         = fnt_dialogue;
