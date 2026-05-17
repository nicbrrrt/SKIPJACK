/// @description Stop JRPG Music and Reset Player
audio_stop_sound(snd_battle_music);
audio_stop_sound(snd_quiz_battle_boss_music);

// Also a safety check to make sure Jack is active when we return to the level
if (!instance_exists(obj_jack)) {
    instance_activate_object(obj_jack);
}