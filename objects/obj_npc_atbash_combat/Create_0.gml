// --- Create Event for obj_npc_atbash_combat ---
// NPC 3: Launches JRPG-style Atbash combat quiz

scr_init_npc_vars("Sentry", spr_npc2_idle, snd_voice2, fnt_dialogue);

interaction_range = 48;
idle_facing       = "down";
idle_anim_acc     = 0;
isInCutscene      = false;
image_speed       = 0;

depth = -y;
