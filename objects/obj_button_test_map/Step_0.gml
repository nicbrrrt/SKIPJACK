// --- Step Event for obj_button_test_map ---
// Keyboard shortcut: Press 'T' to launch dungeon_test directly

if (keyboard_check_pressed(ord("T"))) {
    if (instance_exists(obj_review_screen)) exit;
    if (instance_exists(obj_codex_manager) && obj_codex_manager.is_open) exit;

    if (audio_is_playing(snd_button_hover)) audio_stop_sound(snd_button_hover);
    audio_play_sound(snd_button_click, 10, false);

    global.dungeons_cleared    = 0;
    global.intern_duty_flagged = false;

    if (instance_exists(obj_transition)) {
        obj_transition.target_room = dungeon_test;
        obj_transition.target_x    = 72;
        obj_transition.target_y    = 784;
        obj_transition.fade_mode   = "fading_out";
        obj_transition.fade_alpha  = 0;
    } else {
        var _t = instance_create_depth(0, 0, -9999, obj_transition);
        _t.target_room = dungeon_test;
        _t.target_x    = 72;
        _t.target_y    = 784;
        _t.fade_mode   = "fading_out";
        _t.fade_alpha  = 0;
    }
}
