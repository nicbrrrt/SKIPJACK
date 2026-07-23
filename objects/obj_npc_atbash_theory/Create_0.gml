// --- Create Event for obj_npc_atbash_theory ---
// NPC 1: Teaches Atbash theory & history, shows mirror alphabet overlay

scr_init_npc_vars("Mirror", spr_lea_idle, snd_voice2, fnt_dialogue);

interaction_range = 48;
idle_facing       = "down";
idle_anim_acc     = 0;
isInCutscene      = false;
image_speed       = 0;
has_taught        = false;

depth = -y;
