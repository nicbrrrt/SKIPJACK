// obj_game_controller — Create Event
// Instance-level variables only. ALL globals come from obj_game_init.
if (instance_number(object_index) > 1) {
    instance_destroy();
    exit;
}

display_set_gui_size(640, 360);
randomize();

// Pause Menu State (instance vars, not global)
pause_menu_state          = "main";
pause_event_soft          = false;
hovered_button            = noone;
mouse_locked_until_release = false;
boss_pending_jrpg         = false;
boss_pending_menu_return  = false;

function ensure_game_controller() {
    if (!instance_exists(obj_game_controller)) {
        instance_create_depth(0, 0, 0, obj_game_controller);
    }
}

function is_special_event_active() {
    if (room == rm_battle_scramble || room == rm_combat) return true;
    if (instance_exists(obj_battle)) return true;
    if (instance_exists(obj_path)) return true;
    if (instance_exists(obj_cipher)) return true;
    if (instance_exists(obj_qte)) return true;
    return false;
}

function open_pause_settings() {
    if (!instance_exists(obj_settings_ui)) {
        var _ui = instance_create_depth(0, 0, -9998, obj_settings_ui);
        _ui.settings_pause_mode = true;
    }
    pause_menu_state = "settings_ui";
    mouse_locked_until_release = true;
}

function pause_game() {
    global.is_paused = true;
    pause_menu_state = "main";
    mouse_locked_until_release = true;
    audio_pause_all();
    pause_event_soft = is_special_event_active();

    // Event rooms: freeze via global.is_paused only — do NOT deactivate instances
    // (deactivate/reactivate was breaking quiz & minigame resume)
    if (!pause_event_soft) {
        instance_deactivate_all(true);
        instance_activate_object(id);
    }
}

function unpause_game() {
    var _was_soft = pause_event_soft;
    global.is_paused = false;
    pause_event_soft = false;
    audio_resume_all();

    if (_was_soft) {
        if (room == rm_battle_scramble || room == rm_combat) {
            if (instance_exists(obj_jack)) instance_deactivate_object(obj_jack);
        }
    } else {
        instance_activate_all();
    }
}

// Spawn the persistent UI button if it doesn't exist
if (!instance_exists(obj_ui_button)) {
    instance_create_depth(0, 0, -10000, obj_ui_button);
}

// --- TOOLTIP SYSTEM (all gameplay rooms) ---
tip_texts = [
    "Tip: Press W, A, S, D to move around.",                                    // [0] contextual: WASD
    "Tip: Reviewing the Codex will make quizzes easier.",                        // [1] passive
    "Tip: The characters are nearby, explore a bit to find them.",               // [2] contextual: searching
    "Tip: Press E near an NPC to talk to them.",                                 // [3] contextual: proximity
    "Tip: Unlocking more characters gives you more data to review.",             // [4] passive
    "Tip: Learning how to shift letters will make battles easier.",              // [5] passive
    "Tip: There are objects you can inspect that can give more answers.",        // [6] passive
    "Tip: It's worth checking the exclamation points around the level."         // [7] passive
];
tip_index        = 0;
tip_state        = "idle";   // "idle" | "fade_in" | "show" | "fade_out"
tip_alpha        = 0;
tip_timer        = 0;
tip_current_text = "";       // actual string shown; set by passive or contextual trigger
tip_idle_frames  = 300;      // 5 s between passive tips
tip_fade_frames  = 40;       // ~0.67 s fade in/out
tip_show_frames  = 180;      // 3 s fully visible

// Secondary objective flash timer (counts down after all objects inspected)
inspect_flash_timer = 0;

// Contextual tracking
jack_last_x         = 0;
jack_last_y         = 0;
jack_idle_frames    = 0;
tip_ctxl_cooldown   = 0;     // frames before another contextual tip can fire
tip_shown_wasd      = false; // shown once per room visit
tip_shown_press_e   = false;
tip_shown_nearby    = false;

// --- Intro Overlay System ---
room_intro_active = false;
room_intro_cipher = "";
room_intro_desc = "";
room_intro_fade = 0;
room_intro_timer = 0;