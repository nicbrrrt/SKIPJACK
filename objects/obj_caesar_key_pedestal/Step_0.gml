/// @description obj_caesar_key_pedestal — Step Event
/// Collects the dungeon floor's Caesar cipher key when Jack touches or presses E near the pedestal.

anim_timer++;

if (!collected && instance_exists(obj_jack)) {
    var _dist = point_distance(obj_jack.x, obj_jack.y - 8, x, y);
    if (_dist < 18 || (_dist < 30 && keyboard_check_pressed(ord("E")))) {
        collected = true;
        global.has_dungeon_cipher_key = true;
        audio_play_sound(snd_objective_complete, 10, false);
    }
}
