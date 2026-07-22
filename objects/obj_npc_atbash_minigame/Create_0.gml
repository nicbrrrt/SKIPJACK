// --- Create Event for obj_npc_atbash_minigame ---
// NPC 2: Launches guided Atbash practice minigame

scr_init_npc_vars("Coach", spr_npc2_idle, snd_voice2, fnt_dialogue);

interaction_range = 48;
idle_facing       = "down";
idle_anim_acc     = 0;
isInCutscene      = false;
image_speed       = 0;

depth = -y;
