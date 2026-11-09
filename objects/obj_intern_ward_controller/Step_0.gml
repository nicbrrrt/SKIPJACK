/// @description obj_intern_ward_controller ?" Step Event
alarm_siren++;

// -------------------------------------------------------------
// 1. INTRO CUTSCENE DIALOGUE
// -------------------------------------------------------------
if (!intro_shown) {
    intro_shown = true;
    var _lines = [
        "HR AUDIT ALERT: Due to corporate assets dismantled on your last shift, you have been assigned to mandatory Intern Babysitting Duty!",
        "Kyle: Look at them, Jack... actual babies in business ties. Keep all 10 interns alive for this 3-minute shift to clear your HR debt!",
        "Kyle: Use [G] to pick up and place interns anywhere. We've added a Wellness Green Room (North-East) that holds up to 4 interns to soothe tantrums!",
        "Kyle: Steady wobbling shelves with [E], pry open jammed lockers, and don't let 5 interns lock themselves in a room or they'll breathe all the air!"
    ];
    var _spk_arr = array_create(array_length(_lines), id);
    create_textevent(_lines, _spk_arr);
}

// -------------------------------------------------------------
// 2. CACHE DOOR INSTANCES
// -------------------------------------------------------------
if (!instance_exists(door_work) || !instance_exists(door_storage) || !instance_exists(door_green) || !instance_exists(door_glass)) {
    with (obj_intern_door) {
        if (room_assigned == ROOM_INTERN_WORK)    other.door_work    = id;
        if (room_assigned == ROOM_INTERN_STORAGE) other.door_storage = id;
        if (room_assigned == ROOM_INTERN_GREEN)   other.door_green   = id;
        if (room_assigned == ROOM_INTERN_GLASS)   other.door_glass   = id;
    }
}

// Freeze during textboxes
if (instance_exists(obj_textbox) || instance_exists(obj_textevent)) exit;

// -------------------------------------------------------------
// 3. SHIFT REVIEW SCREEN (GAME OVER / SHIFT COMPLETE)
// -------------------------------------------------------------
if (shift_ended) {
    if (instance_exists(obj_jack)) {
        obj_jack.isInCutscene = true;
    }

    if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
        audio_play_sound(snd_button_click, 10, false);
        // Clean up global held intern state
        global.held_intern_inst = noone;

        // Reset camera pan state before homeroom
        global.cam_pan_phase   = "off";
        global.cam_pan_mode    = "";
        global.cam_pan_timer   = 0;
        global.cam_pan_targets = [];

        // Return directly to homeroom as requested
        room_goto(rm_homeroom);
    }
    exit;
}

// -------------------------------------------------------------
// 4. SHIFT TIMER COUNTDOWN
// -------------------------------------------------------------
shift_timer--;

// -------------------------------------------------------------
// 5. ROOM OXYGEN SIMULATION & DOOR SLAMMING
// -------------------------------------------------------------
var _work_count    = 0;
var _storage_count = 0;
var _green_count   = 0;
var _glass_count   = 0;
var _alive_count   = 0;

with (obj_intern) {
    if (state != INTERN_STATE_DEAD) {
        _alive_count++;
        var _rm = scr_intern_get_room_at(x, y);
        if (_rm == ROOM_INTERN_WORK)    _work_count++;
        if (_rm == ROOM_INTERN_STORAGE) _storage_count++;
        if (_rm == ROOM_INTERN_GREEN)   _green_count++;
        if (_rm == ROOM_INTERN_GLASS)   _glass_count++;
    }
}
green_count = _green_count;

// WORK ROOM OXYGEN:
var _work_closed = (instance_exists(door_work) && (door_work.is_closed || door_work.is_locked));
if (_work_closed) {
    if (_work_count >= 5) {
        oxygen_work = max(0, oxygen_work - 0.012 * _work_count);
        if (oxygen_work <= 0) {
            with (obj_intern) {
                if (state != INTERN_STATE_DEAD && state != INTERN_STATE_HELD && state != INTERN_STATE_TRAPPED && scr_intern_get_room_at(x, y) == ROOM_INTERN_WORK) {
                    if (state != INTERN_STATE_KNOCKED_OUT) knockout_timer = 1800;
                    state = INTERN_STATE_KNOCKED_OUT;
                }
            }
        }
    }
} else {
    oxygen_work = min(100.0, oxygen_work + 0.25);
    // Chance for interns to slam door if 5+ inside
    if (_work_count >= 5 && instance_exists(door_work) && door_work.slam_cooldown <= 0 && irandom(350) == 0) {
        door_work.is_closed     = true;
        door_work.is_locked     = true;
        door_work.slam_cooldown = 500;
        audio_play_sound(snd_attack_impact, 10, false);
    }
}

// STORAGE ROOM OXYGEN:
var _storage_closed = (instance_exists(door_storage) && (door_storage.is_closed || door_storage.is_locked));
if (_storage_closed) {
    if (_storage_count >= 5) {
        oxygen_storage = max(0, oxygen_storage - 0.012 * _storage_count);
        if (oxygen_storage <= 0) {
            with (obj_intern) {
                if (state != INTERN_STATE_DEAD && state != INTERN_STATE_HELD && state != INTERN_STATE_TRAPPED && scr_intern_get_room_at(x, y) == ROOM_INTERN_STORAGE) {
                    if (state != INTERN_STATE_KNOCKED_OUT) knockout_timer = 1800;
                    state = INTERN_STATE_KNOCKED_OUT;
                }
            }
        }
    }
} else {
    oxygen_storage = min(100.0, oxygen_storage + 0.25);
    if (_storage_count >= 5 && instance_exists(door_storage) && door_storage.slam_cooldown <= 0 && irandom(350) == 0) {
        door_storage.is_closed     = true;
        door_storage.is_locked     = true;
        door_storage.slam_cooldown = 500;
        audio_play_sound(snd_attack_impact, 10, false);
    }
}

// GLASS ROOM OXYGEN:
var _glass_closed = (instance_exists(door_glass) && (door_glass.is_closed || door_glass.is_locked));
if (_glass_closed) {
    if (_glass_count >= 5) {
        oxygen_glass = max(0, oxygen_glass - 0.012 * _glass_count);
        if (oxygen_glass <= 0) {
            with (obj_intern) {
                if (state != INTERN_STATE_DEAD && state != INTERN_STATE_HELD && state != INTERN_STATE_TRAPPED && scr_intern_get_room_at(x, y) == ROOM_INTERN_GLASS) {
                    if (state != INTERN_STATE_KNOCKED_OUT) knockout_timer = 1800;
                    state = INTERN_STATE_KNOCKED_OUT;
                }
            }
        }
    }
} else {
    oxygen_glass = min(100.0, oxygen_glass + 0.25);
    if (_glass_count >= 5 && instance_exists(door_glass) && door_glass.slam_cooldown <= 0 && irandom(350) == 0) {
        door_glass.is_closed     = true;
        door_glass.is_locked     = true;
        door_glass.slam_cooldown = 500;
        audio_play_sound(snd_attack_impact, 10, false);
    }
}

// -------------------------------------------------------------
// 6. SHIFT COMPLETION TRIGGER
// -------------------------------------------------------------
if (shift_timer <= 0 || _alive_count == 0) {
    shift_ended = true;

    // Tally stats
    interns_lost  = 10 - _alive_count;
    interns_saved = _alive_count;

    fried_count = 0;
    with (obj_intern_terminal) {
        if (is_fried) other.fried_count++;
    }

    total_fines = (interns_lost * 150) + (fried_count * 30);
    global.legal_fund = max(0, global.legal_fund - total_fines);

    // Grade resolution
    if (interns_lost == 0) {
        shift_grade = "S";
    } else if (interns_lost == 1) {
        shift_grade = "A";
    } else if (interns_lost == 2) {
        shift_grade = "B";
    } else if (interns_lost == 3) {
        shift_grade = "C";
    } else {
        shift_grade = "F"; // 3+ lost: Failed!
    }

    // Success vs Failure outcomes
    if (shift_grade != "F") {
        // HR violation debt cleared!
        global.intern_duty_flagged = false;
        global.hr_scrap_count      = 0;
        audio_play_sound(snd_objective_complete, 10, false);
    } else {
        // Probation extended!
        global.intern_duty_flagged = true;
        audio_play_sound(snd_error, 10, false);
    }
}
