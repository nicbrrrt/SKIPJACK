// obj_camera — End Step Event
// Ensures the camera locks onto Jack's exact position after his Step movement completes,
// and applies screen shake when Jack bumps into a locked door.

if (!variable_global_exists("cam_shake_timer")) global.cam_shake_timer = 0;
if (!variable_global_exists("cam_shake_mag"))   global.cam_shake_mag   = 0;

var _shake_x = 0;
var _shake_y = 0;
if (global.cam_shake_timer > 0) {
    global.cam_shake_timer--;
    _shake_x = irandom_range(-global.cam_shake_mag, global.cam_shake_mag);
    _shake_y = irandom_range(-global.cam_shake_mag, global.cam_shake_mag);
}

if (global.cam_pan_phase == "off" && instance_exists(obj_jack)) {
    var _cam_hw   = global.cam_width  / 2;
    var _cam_hh   = global.cam_height / 2;
    var _target_x = obj_jack.x + _shake_x;
    var _target_y = (obj_jack.y - 12) + _shake_y;
    camera_set_view_pos(view_camera[0], _target_x - _cam_hw, _target_y - _cam_hh);
}
