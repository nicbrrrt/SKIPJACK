// obj_camera — End Step Event
// Ensures the camera locks onto Jack's exact position after his Step movement completes.

if (global.cam_pan_phase == "off" && instance_exists(obj_jack)) {
    var _cam_hw   = global.cam_width  / 2;
    var _cam_hh   = global.cam_height / 2;
    var _target_x = obj_jack.x;
    var _target_y = obj_jack.y - 12;
    camera_set_view_pos(view_camera[0], _target_x - _cam_hw, _target_y - _cam_hh);
}
