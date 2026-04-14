// obj_camera — Step Event (Step_0)
// FIXED: Merged Step_2 into Step_0. Camera now follows obj_jack with edge clamping.
// ACTION: Delete Step_2 entirely.

camera_set_view_size(view_camera[0], global.cam_width, global.cam_height);

if (instance_exists(obj_jack)) {
    var _cam_hw = global.cam_width  / 2;
    var _cam_hh = global.cam_height / 2;

    var _target_x = clamp(obj_jack.x, _cam_hw, room_width  - _cam_hw);
    var _target_y = clamp(obj_jack.y, _cam_hh, room_height - _cam_hh);

    camera_set_view_pos(view_camera[0], _target_x - _cam_hw, _target_y - _cam_hh);
}