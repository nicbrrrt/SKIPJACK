/// @description obj_intern_door ?" Step Event
anim_t++;
near_player = false;
var _cx = x + 8;
var _cy = y + 8;

if (slam_cooldown > 0) slam_cooldown--;

if (instance_exists(obj_jack)) {
    if (point_distance(_cx, _cy, obj_jack.x, obj_jack.y - 6) < 28) {
        near_player = true;
        if (keyboard_check_pressed(ord("E"))) {
            if (is_closed || is_locked) {
                is_closed     = false;
                is_locked     = false;
                slam_cooldown = 500;
                audio_play_sound(snd_button_click, 10, false);
            }
        }
    }
}

// -------------------------------------------------------------
// PHYSICAL DOOR BLOCKER MANAGEMENT
// -------------------------------------------------------------
if (is_closed || is_locked) {
    open_amt = lerp(open_amt, 0.0, 0.25);
    // Create wall blocker if not already present
    if (door_blocker == noone || !instance_exists(door_blocker)) {
        door_blocker = instance_create_layer(x, y, "Instances", obj_dungeon_wall);
        door_blocker.visible = false;
    }
} else {
    open_amt = lerp(open_amt, 1.0, 0.25);
    // Destroy wall blocker so Jack and interns can pass through freely!
    if (door_blocker != noone && instance_exists(door_blocker)) {
        instance_destroy(door_blocker);
        door_blocker = noone;
    }
}
