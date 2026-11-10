// --- Step Event for obj_button_intern_duty ---
// Keyboard shortcut: Press 'I' to launch Intern Babysitting Duty mode directly

if (keyboard_check_pressed(ord("I"))) {
    if (instance_exists(obj_review_screen)) exit;
    if (instance_exists(obj_codex_manager) && obj_codex_manager.is_open) exit;

    if (audio_is_playing(snd_button_hover)) audio_stop_sound(snd_button_hover);
    audio_play_sound(snd_button_click, 10, false);

    global.intern_duty_flagged = true;
    global.dungeons_cleared    = 0;
    global.hr_scrap_count      = 4;

    global.cam_pan_phase   = "off";
    global.cam_pan_mode    = "";
    global.cam_pan_timer   = 0;
    global.cam_pan_targets = [];

    var _target_room = dungeon_test;
    var _spawn_x     = 320 + 20 * 16 + 8; // 648
    var _spawn_y     = 240 + 12 * 16 + 8; // 440

    if (instance_exists(obj_transition)) {
        obj_transition.target_room = _target_room;
        obj_transition.target_x    = _spawn_x;
        obj_transition.target_y    = _spawn_y;
        obj_transition.fade_mode   = "fading_out";
        obj_transition.fade_alpha  = 0;
    } else {
        var _t = instance_create_depth(0, 0, -9999, obj_transition);
        _t.target_room = _target_room;
        _t.target_x    = _spawn_x;
        _t.target_y    = _spawn_y;
        _t.fade_mode   = "fading_out";
        _t.fade_alpha  = 0;
    }
}
