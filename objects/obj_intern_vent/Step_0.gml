/// @description obj_intern_vent — Step Event
if (cooldown > 0) cooldown--;

near_player        = false;
is_interact_target = false;

var _cx = x + 8;
var _cy = y + 8;

if (instance_exists(obj_jack)) {
    var _dist = point_distance(_cx, _cy, obj_jack.x, obj_jack.y - 6);
    if (_dist < 32) {
        near_player = true;
    }
}

// Single-target selection: only the single closest clogged vent to Jack responds to [E]!
if (near_player && is_clogged && instance_exists(obj_jack)) {
    var _closest_vent = noone;
    var _best_d = 999999;
    var _jx = obj_jack.x;
    var _jy = obj_jack.y - 6;
    with (obj_intern_vent) {
        if (near_player && is_clogged) {
            var _d = point_distance(x + 8, y + 8, _jx, _jy);
            if (_d < _best_d) {
                _best_d = _d;
                _closest_vent = id;
            }
        }
    }
    is_interact_target = (_closest_vent == id);
}

// Handle clogged vent state and player struggle rescue
if (is_clogged) {
    clog_timer++;

    // Safety: if stuck_intern instance was lost, reset vent
    if (stuck_intern != noone && !instance_exists(stuck_intern)) {
        stuck_intern  = noone;
        is_clogged    = false;
        struggle_pull = 0.0;
    }

    if (is_interact_target && keyboard_check_pressed(ord("E"))) {
        if (!variable_global_exists("e_interact_step") || global.e_interact_step != current_time) {
            global.e_interact_step = current_time;
            struggle_pull += 0.22; // ~5 rapid taps of [E] to pull intern free!
            audio_play_sound(snd_button_hover, 10, false);

            if (struggle_pull >= 1.0) {
                // Intern successfully freed from air vent!
                is_clogged    = false;
                struggle_pull = 0.0;
                cooldown      = 900; // 15 seconds vent immunity! No intern can crawl in!
                audio_play_sound(snd_objective_complete, 10, false);
                audio_play_sound(snd_voice1, 10, false);

                if (instance_exists(stuck_intern)) {
                    stuck_intern.visible = true;

                    // Place safely on floor at generous clearance in front of vent
                    if (room_assigned == ROOM_INTERN_GLASS) {
                        stuck_intern.x = x + 8;
                        stuck_intern.y = y - 28; // Clear safe distance South of North threshold
                    } else {
                        stuck_intern.x = x + 8;
                        stuck_intern.y = y + 28; // Clear safe distance South of North wall vent
                    }

                    // Check room oxygen at time of extraction
                    var _ctrl = instance_nearest(x, y, obj_intern_ward_controller);
                    var _o2 = 100;
                    if (_ctrl != noone) {
                        if (room_assigned == ROOM_INTERN_WORK)    _o2 = _ctrl.oxygen_work;
                        if (room_assigned == ROOM_INTERN_STORAGE) _o2 = _ctrl.oxygen_storage;
                        if (room_assigned == ROOM_INTERN_GLASS)   _o2 = _ctrl.oxygen_glass;
                    }

                    if (_o2 <= 0) {
                        stuck_intern.state          = INTERN_STATE_KNOCKED_OUT;
                        stuck_intern.knockout_timer = 1800;
                    } else {
                        // Send safely back to office desk with 15s grace period!
                        scr_intern_send_to_work(stuck_intern, 900);
                    }
                    stuck_intern = noone;
                }
            }
        }
    } else {
        // Slow struggle pull decay if player pauses tapping
        struggle_pull = max(0.0, struggle_pull - 0.005);
    }
} else {
    fan_rot += 12;
    breeze_timer++;
    struggle_pull = 0.0;
}
