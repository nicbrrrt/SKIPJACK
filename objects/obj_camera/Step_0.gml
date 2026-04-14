// obj_camera — Step Event

camera_set_view_size(view_camera[0], global.cam_width, global.cam_height);

var _cam_hw = global.cam_width  / 2;
var _cam_hh = global.cam_height / 2;

// --- CAMERA PAN STATE MACHINE (boss spawn reveal) ---
if (global.cam_pan_phase != "off") {
    global.cam_pan_timer++;

    if (global.cam_pan_phase == "pan_out") {
        var _t  = min(global.cam_pan_timer / 90, 1);
        var _cx = lerp(global.cam_pan_from_x, global.cam_pan_to_x, _t);
        var _cy = lerp(global.cam_pan_from_y, global.cam_pan_to_y, _t);
        camera_set_view_pos(view_camera[0], _cx - _cam_hw, _cy - _cam_hh);
        if (global.cam_pan_timer >= 90) {
            global.cam_pan_phase = "hold";
            global.cam_pan_timer = 0;
        }
    }
    else if (global.cam_pan_phase == "hold") {
        camera_set_view_pos(view_camera[0], global.cam_pan_to_x - _cam_hw, global.cam_pan_to_y - _cam_hh);
        // Wait a few frames for the dialogue to open, then hold until it's dismissed
        if (global.cam_pan_timer > 10 && !instance_exists(obj_textevent)) {
            global.cam_pan_from_x = global.cam_pan_to_x;
            global.cam_pan_from_y = global.cam_pan_to_y;
            global.cam_pan_phase  = "pan_back";
            global.cam_pan_timer  = 0;
        }
    }
    else if (global.cam_pan_phase == "pan_back") {
        var _jack_x = instance_exists(obj_jack) ? clamp(obj_jack.x, _cam_hw, room_width  - _cam_hw) : global.cam_pan_from_x;
        var _jack_y = instance_exists(obj_jack) ? clamp(obj_jack.y, _cam_hh, room_height - _cam_hh) : global.cam_pan_from_y;
        var _t  = min(global.cam_pan_timer / 90, 1);
        var _cx = lerp(global.cam_pan_from_x, _jack_x, _t);
        var _cy = lerp(global.cam_pan_from_y, _jack_y, _t);
        camera_set_view_pos(view_camera[0], _cx - _cam_hw, _cy - _cam_hh);
        if (global.cam_pan_timer >= 90) {
            global.cam_pan_phase = "off";
            global.cam_pan_timer = 0;
        }
    }
    exit;
}

// --- NORMAL FOLLOW ---
if (instance_exists(obj_jack)) {
    var _target_x = clamp(obj_jack.x, _cam_hw, room_width  - _cam_hw);
    var _target_y = clamp(obj_jack.y, _cam_hh, room_height - _cam_hh);
    camera_set_view_pos(view_camera[0], _target_x - _cam_hw, _target_y - _cam_hh);
}
