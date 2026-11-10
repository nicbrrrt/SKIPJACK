/// @description obj_intern_ward_controller ?" Step Event
alarm_siren++;

// -------------------------------------------------------------
// 1. INTRO CUTSCENE DIALOGUE
// -------------------------------------------------------------
if (!intro_shown) {
    intro_shown = true;
    if (instance_exists(obj_jack)) {
        obj_jack.x = 320 + 20 * 16 + 8; // 648 (Central Hallway)
        obj_jack.y = 240 + 12 * 16 + 8; // 440
        obj_jack.visible = true;
        obj_jack.isInCutscene = false;
    }
    var _lines = [
        "HR AUDIT ALERT: Due to corporate assets dismantled on your last shift, you have been assigned to mandatory Intern Babysitting Duty!",
        "Kyle: Look at them, Jack... actual babies in business ties. Keep all 10 interns alive for this 3-minute shift to clear your HR debt!",
        "Kyle: Use [G] to pick up and place interns anywhere. We've added a Wellness Green Room (North-East) that holds up to 4 interns to soothe tantrums!",
        "Kyle: Spam [E] to steady wobbling lockers, unlock doors, and pull stuck interns from vents! Hold [E] for 5s to reinforce observation glass!"
    ];
    var _spk_arr = array_create(array_length(_lines), id);
    create_textevent(_lines, _spk_arr);
}

// -------------------------------------------------------------
// 2. CACHE DOOR & VENT INSTANCES
// -------------------------------------------------------------
if (!instance_exists(door_work) || !instance_exists(door_storage) || !instance_exists(door_green) || !instance_exists(door_glass)) {
    with (obj_intern_door) {
        if (room_assigned == ROOM_INTERN_WORK)    other.door_work    = id;
        if (room_assigned == ROOM_INTERN_STORAGE) other.door_storage = id;
        if (room_assigned == ROOM_INTERN_GREEN)   other.door_green   = id;
        if (room_assigned == ROOM_INTERN_GLASS)   other.door_glass   = id;
    }
}

if (!instance_exists(vent_work) || !instance_exists(vent_storage) || !instance_exists(vent_glass)) {
    with (obj_intern_vent) {
        if (room_assigned == ROOM_INTERN_WORK)    other.vent_work    = id;
        if (room_assigned == ROOM_INTERN_STORAGE) other.vent_storage = id;
        if (room_assigned == ROOM_INTERN_GLASS)   other.vent_glass   = id;
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

    // Return to Homeroom
    if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
        audio_play_sound(snd_button_click, 10, false);
        audio_stop_sound(snd_intern_minigame);
        global.held_intern_inst = noone;
        global.cam_pan_phase    = "off";
        global.cam_pan_mode     = "";
        global.cam_pan_timer    = 0;
        global.cam_pan_targets  = [];
        room_goto(rm_homeroom);
    }
    // Retry shift (playtesting shortcut)
    else if (keyboard_check_pressed(ord("R"))) {
        audio_play_sound(snd_button_click, 10, false);
        audio_stop_sound(snd_intern_minigame);
        global.held_intern_inst    = noone;
        global.cam_pan_phase       = "off";
        global.cam_pan_mode        = "";
        global.cam_pan_timer       = 0;
        global.cam_pan_targets     = [];
        global.intern_duty_flagged = true;
        room_restart();
    }
    // Return to Main Menu
    else if (keyboard_check_pressed(ord("M")) || keyboard_check_pressed(vk_escape)) {
        audio_play_sound(snd_button_click, 10, false);
        audio_stop_sound(snd_intern_minigame);
        global.held_intern_inst    = noone;
        global.cam_pan_phase       = "off";
        global.cam_pan_mode        = "";
        global.cam_pan_timer       = 0;
        global.cam_pan_targets     = [];
        global.intern_duty_flagged = false;
        room_goto(rm_menu);
    }
    exit;
}

// Development quick-restart anytime during shift: Ctrl + R
if (keyboard_check(vk_control) && keyboard_check_pressed(ord("R"))) {
    audio_play_sound(snd_button_click, 10, false);
    global.held_intern_inst    = noone;
    global.cam_pan_phase       = "off";
    global.cam_pan_mode        = "";
    global.cam_pan_timer       = 0;
    global.cam_pan_targets     = [];
    global.intern_duty_flagged = true;
    room_restart();
    exit;
}

// -------------------------------------------------------------
// 4. SHIFT TIMER COUNTDOWN
// -------------------------------------------------------------
shift_timer--;

// -------------------------------------------------------------
// 5. AIR VENT OXYGEN SIMULATION & DOOR SLAMMING
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

// 1. WORK ROOM (OFFICE) OXYGEN & VENT
var _work_clogged   = (instance_exists(vent_work) && vent_work.is_clogged);
var _work_door_open = (instance_exists(door_work) && !door_work.is_closed && !door_work.is_locked);

if (_work_clogged) {
    var _loss = _work_door_open ? 0.03 : 0.08;
    oxygen_work = max(0, oxygen_work - _loss);
    if (oxygen_work <= 0) {
        with (obj_intern) {
            if (state != INTERN_STATE_DEAD && state != INTERN_STATE_HELD && state != INTERN_STATE_TRAPPED && scr_intern_get_room_at(x, y) == ROOM_INTERN_WORK) {
                if (state != INTERN_STATE_KNOCKED_OUT && state != INTERN_STATE_VENT_STUCK) {
                    knockout_timer = 1800;
                    state = INTERN_STATE_KNOCKED_OUT;
                    audio_play_sound(snd_die, 10, false);
                }
            }
        }
    }
} else {
    oxygen_work = min(100.0, oxygen_work + (_work_door_open ? 0.50 : 0.35));
}

// 2. STORAGE ROOM OXYGEN & VENT
var _storage_clogged   = (instance_exists(vent_storage) && vent_storage.is_clogged);
var _storage_door_open = (instance_exists(door_storage) && !door_storage.is_closed && !door_storage.is_locked);

if (_storage_clogged) {
    var _loss = _storage_door_open ? 0.03 : 0.08;
    oxygen_storage = max(0, oxygen_storage - _loss);
    if (oxygen_storage <= 0) {
        with (obj_intern) {
            if (state != INTERN_STATE_DEAD && state != INTERN_STATE_HELD && state != INTERN_STATE_TRAPPED && scr_intern_get_room_at(x, y) == ROOM_INTERN_STORAGE) {
                if (state != INTERN_STATE_KNOCKED_OUT && state != INTERN_STATE_VENT_STUCK) {
                    knockout_timer = 1800;
                    state = INTERN_STATE_KNOCKED_OUT;
                    audio_play_sound(snd_die, 10, false);
                }
            }
        }
    }
} else {
    oxygen_storage = min(100.0, oxygen_storage + (_storage_door_open ? 0.50 : 0.35));
}

// 3. OBSERVATION DECK OXYGEN & VENT
var _glass_clogged   = (instance_exists(vent_glass) && vent_glass.is_clogged);
var _glass_door_open = (instance_exists(door_glass) && !door_glass.is_closed && !door_glass.is_locked);

if (_glass_clogged) {
    var _loss = _glass_door_open ? 0.03 : 0.08;
    oxygen_glass = max(0, oxygen_glass - _loss);
    if (oxygen_glass <= 0) {
        with (obj_intern) {
            if (state != INTERN_STATE_DEAD && state != INTERN_STATE_HELD && state != INTERN_STATE_TRAPPED && scr_intern_get_room_at(x, y) == ROOM_INTERN_GLASS) {
                if (state != INTERN_STATE_KNOCKED_OUT && state != INTERN_STATE_VENT_STUCK) {
                    knockout_timer = 1800;
                    state = INTERN_STATE_KNOCKED_OUT;
                    audio_play_sound(snd_die, 10, false);
                }
            }
        }
    }
} else {
    oxygen_glass = min(100.0, oxygen_glass + (_glass_door_open ? 0.50 : 0.35));
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
