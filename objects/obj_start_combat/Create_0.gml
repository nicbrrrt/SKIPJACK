// --- Create Event of obj_start_combat ---

// 1. SAFETY GLOBAL INITIALIZATION
if (!variable_global_exists("last_battle_id")) {
    global.last_battle_id = "none";
    global.battle_result = "none";
}

// 2. SAFE ASSET RETRIEVAL (Prevents "Variable Not Set" Crashes)
var _portrait = asset_get_index("spr_npc2_portrait");
if (_portrait == -1) _portrait = spr_npc2_portrait; // Fallback face

var _voice = asset_get_index("snd_voice_npc2");
if (_voice == -1) _voice = -1; // Fallback: No sound

var _font = asset_get_index("fnt_dialogue");
if (_font == -1) _font = -1; // Fallback: Default font

// 3. INITIALIZE NPC VARIABLES (Using your new script)
// Format: scr_init_npc_vars("Name", PortraitSprite, VoiceSound, FontAsset)
scr_init_npc_vars("Breado", _portrait, _voice, _font);

// 4. COMBAT & INTERACTION SETUP
interaction_range = 48;
active_dialogue = false; 

// 5. BATTLE ID LOGIC
// If we just came from a battle, keep the ID; otherwise, default to "none"
if (global.last_battle_id != "none") {
    battle_id = global.last_battle_id;
} else {
    battle_id = "none"; // Set this to "tutorial" in the Room Editor for the specific NPC
}

show_debug_message("BATTLE SETUP: Object initialized with ID: " + string(battle_id));