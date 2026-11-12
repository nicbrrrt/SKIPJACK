/// @description obj_doorway — Step Event
/// Smoothly slides the automatic office door panels open when Jack walks near an unlocked doorway.

anim_t++;

// Dynamically locate and bind to any lock instance placed at this doorway
if (lock_inst == noone || !instance_exists(lock_inst)) {
    var _c = instance_place(x, y, obj_door_caesar_lock);
    if (_c == noone) _c = instance_nearest(x + 8, y + 8, obj_door_caesar_lock);
    if (_c != noone && point_distance(x, y, _c.draw_x, _c.draw_y) < 4) {
        lock_inst = _c;
        _c.doorway_inst = id;
    } else {
        var _q = instance_place(x, y, obj_door_quiz_lock);
        if (_q == noone) _q = instance_nearest(x + 8, y + 8, obj_door_quiz_lock);
        if (_q != noone && point_distance(x, y, _q.draw_x, _q.draw_y) < 4) {
            lock_inst = _q;
            _q.doorway_inst = id;
        }
    }
}

// Sync locked state and door category from bound lock instance
if (instance_exists(lock_inst)) {
    is_locked = lock_inst.locked;
    if (is_locked) {
        starts_locked = true;
    }
    if (variable_instance_exists(lock_inst, "is_breaker_door") && lock_inst.is_breaker_door) {
        door_type = "breaker";
    } else if (variable_instance_exists(lock_inst, "is_lockdown_door") && lock_inst.is_lockdown_door) {
        door_type = "lockdown";
    }
}

var _target_open = 0.0;
// Only slide open when Jack is near AND the door is unlocked
if (!is_locked && instance_exists(obj_jack)) {
    var _dist = point_distance(obj_jack.x, obj_jack.y - 8, x + 8, y + 8);
    if (_dist < 30) {
        _target_open = 1.0;
    }
}

open_amt = lerp(open_amt, _target_open, 0.22);
if (abs(open_amt - _target_open) < 0.01) {
    open_amt = _target_open;
}
