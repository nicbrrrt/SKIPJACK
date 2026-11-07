/// @description obj_doorway — Step Event
/// Smoothly slides the automatic office door panels open when Jack walks near the doorway.

anim_t++;

if (has_lock_overlay) exit;

var _target_open = 0.0;
if (instance_exists(obj_jack)) {
    var _dist = point_distance(obj_jack.x, obj_jack.y - 8, x + 8, y + 8);
    if (_dist < 30) {
        _target_open = 1.0;
    }
}

open_amt = lerp(open_amt, _target_open, 0.22);
if (abs(open_amt - _target_open) < 0.01) {
    open_amt = _target_open;
}
