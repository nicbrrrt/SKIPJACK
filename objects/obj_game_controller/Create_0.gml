// obj_game_controller — Create Event
// Instance-level variables only. ALL globals come from obj_game_init.

display_set_gui_size(640, 360);
randomize();

// Pause Menu State (instance vars, not global)
pause_menu_state          = "main";
hovered_button            = noone;
mouse_locked_until_release = false;
boss_pending_jrpg         = false;

// Spawn the persistent UI button if it doesn't exist
if (!instance_exists(obj_ui_button)) {
    instance_create_depth(0, 0, -10000, obj_ui_button);
}

// --- TOOLTIP SYSTEM (all gameplay rooms) ---
tip_texts = [
    "Tip: Press W, A, S, D to move around.",                            // [0] contextual: WASD
    "Tip: Reviewing the Codex will make quizzes easier.",               // [1] passive
    "Tip: The characters are nearby.",                                  // [2] contextual: searching
    "Tip: Press E near an NPC to talk to them.",                        // [3] contextual: proximity
    "Tip: Unlocking more characters gives you more data to review.",    // [4] passive
    "Tip: Learning how to shift letters will make battles easier."      // [5] passive
];
tip_index        = 0;
tip_state        = "idle";   // "idle" | "fade_in" | "show" | "fade_out"
tip_alpha        = 0;
tip_timer        = 0;
tip_current_text = "";       // actual string shown; set by passive or contextual trigger
tip_idle_frames  = 300;      // 5 s between passive tips
tip_fade_frames  = 40;       // ~0.67 s fade in/out
tip_show_frames  = 180;      // 3 s fully visible

// Contextual tracking
jack_last_x         = 0;
jack_last_y         = 0;
jack_idle_frames    = 0;
tip_ctxl_cooldown   = 0;     // frames before another contextual tip can fire
tip_shown_wasd      = false; // shown once per room visit
tip_shown_press_e   = false;
tip_shown_nearby    = false;