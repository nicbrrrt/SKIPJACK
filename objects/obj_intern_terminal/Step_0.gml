/// @description obj_intern_terminal ?" Step Event
near_player = false;

if (instance_exists(obj_jack)) {
    var _dist = point_distance(x + 8, y + 8, obj_jack.x, obj_jack.y - 6);
    if (_dist < 26) {
        near_player = true;
        if (is_fried && keyboard_check_pressed(ord("E"))) {
            is_fried = false;
            audio_play_sound(snd_correct_ping, 10, false);
        }
    }
}

if (is_fried) {
    sparks_timer++;
}
