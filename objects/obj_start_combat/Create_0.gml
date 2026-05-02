// obj_start_combat — Create Event
// Global safety init REMOVED (handled by obj_game_init).

var _portrait = spr_breado_portrait;
var _voice = snd_voice2;

var _font = asset_get_index("fnt_dialogue");
if (_font == -1) _font = -1;

scr_init_npc_vars("Breado", _portrait, _voice, _font);

interaction_range = 48;
active_dialogue   = false;

// battle_id is set in the Room Editor per-instance.
// If it wasn't set, give it a safe default.
if (!variable_instance_exists(id, "battle_id")) {
    battle_id = "none";
}

show_debug_message("BATTLE SETUP: Initialized with ID: " + string(battle_id));