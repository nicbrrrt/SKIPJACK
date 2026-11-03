/// @description obj_door_caesar_lock — Step Event
/// Press E when adjacent to open the Caesar Cipher Decoding UI (obj_cipher).

anim_t++;

if (!variable_instance_exists(id, "text_cooldown")) text_cooldown = 0;
if (instance_exists(obj_textevent)) {
    text_cooldown = 5;
    exit;
}
if (text_cooldown > 0) {
    text_cooldown--;
    exit;
}

if (locked && instance_exists(obj_jack)) {
    if (!instance_exists(obj_dungeon_quiz) && !instance_exists(obj_cipher) && !instance_exists(obj_dungeon_victory)) {
        if (point_distance(obj_jack.x, obj_jack.y - 8, draw_x + 8, draw_y + 8) < 28) {
            if (keyboard_check_pressed(ord("E"))) {
                instance_create_depth(draw_x, draw_y, -15000, obj_cipher);
            }
        }
    }
}
