// obj_camera — Step Event

// Zoom in to a tighter 320x180 FOV inside the procedural dungeon (144x144 room chunks)
// and inside the cozy homeroom, while preserving the standard 640x360 view in overworld rooms.
if (instance_exists(obj_dungeon_generator) || room == rm_homeroom) {
    global.cam_width  = 320;
    global.cam_height = 180;
} else {
    global.cam_width  = 640;
    global.cam_height = 360;
}

camera_set_view_target(view_camera[0], noone);
camera_set_view_size(view_camera[0], global.cam_width, global.cam_height);

var _cam_hw = global.cam_width  / 2;
var _cam_hh = global.cam_height / 2;

// --- CAMERA PAN STATE MACHINE (Dungeon Objective Cutscenes & Boss Reveal) ---
if (global.cam_pan_phase != "off") {
    global.cam_pan_timer++;

    // 1. Dynamic Multi-Target Dungeon Camera Pan (syncs with Visual Novel dialogue pages!)
    if (variable_global_exists("cam_pan_mode") && global.cam_pan_mode == "dungeon_cutscene") {
        if (global.cam_pan_phase != "pan_back") {
            if (variable_global_exists("cam_pan_targets") && is_array(global.cam_pan_targets) && array_length(global.cam_pan_targets) > 0) {
                var _pg = 0;
                if (instance_exists(obj_textbox)) {
                    _pg = clamp(obj_textbox.page, 0, array_length(global.cam_pan_targets) - 1);
                }
                var _tgt = global.cam_pan_targets[_pg];
                global.cam_pan_to_x     = _tgt.tx;
                global.cam_pan_to_y     = _tgt.ty;
                global.cam_pan_label    = _tgt.label;
                global.cam_pan_sublabel = variable_struct_exists(_tgt, "sublabel") ? _tgt.sublabel : "";
                global.cam_pan_col      = variable_struct_exists(_tgt, "col")      ? _tgt.col      : c_aqua;
            }

            // Offset camera center +22px downward so the target room sits centered in the open window above the VN dialogue box
            var _goal_cx = global.cam_pan_to_x;
            var _goal_cy = global.cam_pan_to_y + 22;

            global.cam_pan_cur_x = lerp(global.cam_pan_cur_x, _goal_cx, 0.13);
            global.cam_pan_cur_y = lerp(global.cam_pan_cur_y, _goal_cy, 0.13);
            camera_set_view_pos(view_camera[0], global.cam_pan_cur_x - _cam_hw, global.cam_pan_cur_y - _cam_hh);

            if (global.cam_pan_timer > 8 && !instance_exists(obj_textevent) && !instance_exists(obj_textbox)) {
                global.cam_pan_from_x = global.cam_pan_cur_x;
                global.cam_pan_from_y = global.cam_pan_cur_y;
                global.cam_pan_phase  = "pan_back";
                global.cam_pan_timer  = 0;
            }
        } else {
            var _jack_x = instance_exists(obj_jack) ? obj_jack.x        : global.cam_pan_from_x;
            var _jack_y = instance_exists(obj_jack) ? (obj_jack.y - 12) : global.cam_pan_from_y;
            var _t      = min(global.cam_pan_timer / 30, 1);
            var _st     = _t * _t * (3 - 2 * _t); // Smoothstep return to Jack
            var _cx     = lerp(global.cam_pan_from_x, _jack_x, _st);
            var _cy     = lerp(global.cam_pan_from_y, _jack_y, _st);
            camera_set_view_pos(view_camera[0], _cx - _cam_hw, _cy - _cam_hh);
            if (global.cam_pan_timer >= 30) {
                global.cam_pan_phase   = "off";
                global.cam_pan_mode    = "";
                global.cam_pan_timer   = 0;
                global.cam_pan_targets = [];
            }
        }
        exit;
    }

    // 2. Standard Single-Target Camera Pan (Overworld / Boss Spawn Reveal)
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
        var _jack_x = instance_exists(obj_jack) ? obj_jack.x : global.cam_pan_from_x;
        var _jack_y = instance_exists(obj_jack) ? (obj_jack.y - 12) : global.cam_pan_from_y;
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

// --- NORMAL FOLLOW (Always centered on Jack) ---
if (instance_exists(obj_jack)) {
    var _target_x = obj_jack.x;
    var _target_y = obj_jack.y - 12; // Center on Jack's body (sprite is 32px tall with bottom-center origin)
    camera_set_view_pos(view_camera[0], _target_x - _cam_hw, _target_y - _cam_hh);
}
