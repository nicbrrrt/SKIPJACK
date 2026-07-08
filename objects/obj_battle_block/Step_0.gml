if (variable_global_exists("is_paused") && global.is_paused) exit;

if (!instance_exists(obj_battle_scramble)) {
    instance_destroy();
    exit;
}

var _ctrl = obj_battle_scramble;
var _slowmo = (_ctrl.block_slowmo_timer > 0);
var _move_t = _slowmo ? 0.035 : 0.14;
var _life_step = _slowmo ? 0.4 : 1;

life_timer += _life_step;
gui_x += (target_gui_x - gui_x) * _move_t;
gui_y += (target_gui_y - gui_y) * _move_t;

var _key = ord(block_char);
if (keyboard_check_pressed(_key)) {
    parried = true;
    audio_play_sound(snd_correct_ping, 10, false);
    with (obj_battle_scramble) {
        battle_state = "player_input";
        orbit_countdown = orbit_countdown_max;
        block_slowmo_timer = 0;
        if (scramble_tutorial && tutorial_phase == 5) {
            tutorial_phase = 6;
            tutorial_start_dialogue([
                "Perfect! You parried the block attack.",
                "If you get hit, a hint letter appears in your answer.",
                "Now try it yourself — spell TRAIN! Press E to begin."
            ]);
        }
    }
    instance_destroy();
    exit;
}

var _hit_dist = _slowmo ? 14 : 18;
if (life_timer >= life_max || point_distance(gui_x, gui_y, target_gui_x, target_gui_y) < _hit_dist) {
    with (obj_battle_scramble) {
        apply_block_damage();
        if (battle_state != "lose") battle_state = "player_input";
        orbit_countdown = orbit_countdown_max;
        block_slowmo_timer = 0;
    }
    instance_destroy();
}
