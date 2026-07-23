scr_init_npc_vars("Examiner", spr_lea_idle, snd_voice2, fnt_dialogue);
interaction_range = 48;
idle_facing = "down";
idle_anim_acc = 0;
isInCutscene = false;
sprite_index = spr_lea_idle;
image_speed = 0;
depth = -y;
if (!variable_global_exists("vigenere_progress")) global.vigenere_progress = 0;
