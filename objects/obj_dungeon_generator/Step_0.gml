/// @description obj_dungeon_generator — Step Event
/// Tracks which room chunk the player (obj_jack) is currently inside,
/// triggers guided camera pan cutscenes & mentor pop-up dialogues,
/// updates fog-of-war alpha, and reveals rooms on the Floor Blueprint Radar.

if (!gen_complete) exit;

siren_timer++;
if (banner_timer > 0) banner_timer--;

var _any_ui_busy = instance_exists(obj_textbox)
    || instance_exists(obj_textevent)
    || (variable_global_exists("pc_screen_open")    && global.pc_screen_open)
    || (variable_global_exists("key_analyzer_open") && global.key_analyzer_open)
    || (variable_global_exists("override_ui_open")  && global.override_ui_open)
    || (variable_global_exists("breaker_ui_open")   && global.breaker_ui_open)
    || instance_exists(obj_cipher)
    || instance_exists(obj_dungeon_quiz)
    || instance_exists(obj_dungeon_victory);

var _pan_active = (variable_global_exists("cam_pan_phase") && global.cam_pan_phase != "off");

// Resolve coordinates of the 4 core facility objective rooms for camera pans
var _key_tx = instance_exists(obj_caesar_key_pedestal) ? obj_caesar_key_pedestal.x : (instance_exists(obj_jack) ? obj_jack.x : 72);
var _key_ty = instance_exists(obj_caesar_key_pedestal) ? obj_caesar_key_pedestal.y : (instance_exists(obj_jack) ? obj_jack.y : 72);

var _ovr_tx = (variable_global_exists("override_prop_inst") && instance_exists(global.override_prop_inst))
    ? (global.override_prop_inst.x + 8) : _key_tx;
var _ovr_ty = (variable_global_exists("override_prop_inst") && instance_exists(global.override_prop_inst))
    ? (global.override_prop_inst.y + 8) : _key_ty;

var _brk_tx = (variable_global_exists("breaker_prop_inst") && instance_exists(global.breaker_prop_inst))
    ? (global.breaker_prop_inst.x + 8) : _ovr_tx;
var _brk_ty = (variable_global_exists("breaker_prop_inst") && instance_exists(global.breaker_prop_inst))
    ? (global.breaker_prop_inst.y + 8) : _ovr_ty;

var _elv_tx = instance_exists(obj_dungeon_goal) ? obj_dungeon_goal.x : _brk_tx;
var _elv_ty = instance_exists(obj_dungeon_goal) ? obj_dungeon_goal.y : _brk_ty;

// ---------------------------------------------------------------------------
// 1. Opening Floor Camera Tour (Tutorial Floors 1-3 & Final Exam Floor 10)
// ---------------------------------------------------------------------------
if (intro_pending && siren_timer >= 12 && instance_exists(obj_jack) && !_any_ui_busy && !_pan_active) {
    intro_pending = false;
    var _m_lines  = curriculum.mentor_intro;

    if (curriculum.guided_ui) {
        // Guided Tutorial Floors (Floors 1-3): Pan across the key objective rooms as Kyle explains each step!
        var _lesson_intro = (array_length(_m_lines) > 0) ? _m_lines[0] : "Welcome to the floor! Let me show you how this sector works.";
        var _tour_lines = [
            _lesson_intro + " First, inspect Clue Terminals [E] and unlock this Gold Key Vault room to get the floor's Cipher Key!",
            "Second, take that Key to this Security Control Room, decode its lock, and press the Red Lockdown Override Button!",
            "Third, overriding the lockdown unseals this Power Breaker Room—flip the 2 matching fuses inside to restore floor power!",
            (global.chapter_floor == 3)
                ? "Finally, once power is back on, decode this Extraction Elevator! Watch out for the patrol drone—press [E] on blue Hallway Lockers to hide!"
                : "Finally, once power is back on, head to this Extraction Elevator and decode its lock to clear the floor!"
        ];
        var _tour_targets = [
            { tx: _key_tx, ty: _key_ty, label: "STEP 1: GOLD KEY VAULT ROOM",        sublabel: "Find Clues [E] -> Pass Quiz -> Calibrate Floor Key", col: make_color_rgb(255, 215, 55) },
            { tx: _ovr_tx, ty: _ovr_ty, label: "STEP 2: LOCKDOWN OVERRIDE ROOM",     sublabel: "Unlock Door -> Encrypt 2-Letter Override Signal",    col: make_color_rgb(255, 80, 95) },
            { tx: _brk_tx, ty: _brk_ty, label: "STEP 3: POWER BREAKER ROOM",         sublabel: "Unseals After Override -> Flip 2 Valid Fuses [ON]",  col: c_aqua },
            { tx: _elv_tx, ty: _elv_ty, label: "STEP 4: EXTRACTION ELEVATOR",        sublabel: "Online After Power Restored -> Decode to Clear!",   col: c_lime }
        ];
        scr_trigger_dungeon_camera_cutscene(_tour_lines, _tour_targets);
        _pan_active = true;
    } else if (array_length(_m_lines) > 0) {
        // Final Exam Floor 10 Briefing with Camera Pan from Key Vault to Extraction Elevator
        var _exam_targets = [
            { tx: _key_tx, ty: _key_ty, label: "FINAL EXAM: GOLD KEY VAULT",      sublabel: "Calibrate the Exam Cipher Key", col: make_color_rgb(255, 215, 55) },
            { tx: _elv_tx, ty: _elv_ty, label: "FINAL EXAM: EXTRACTION ELEVATOR", sublabel: "Complete Override + Power -> Crack 5-Letter Exam Lock!", col: c_lime }
        ];
        scr_trigger_dungeon_camera_cutscene(_m_lines, _exam_targets);
        _pan_active = true;
    }
}

// ---------------------------------------------------------------------------
// 2. Dynamic Milestone Camera Pans + Mentor VN Pop-Up Dialogues
// ---------------------------------------------------------------------------
if (!intro_pending && instance_exists(obj_jack) && !_any_ui_busy && !_pan_active) {
    // Milestone A (Tutorial Floors 1-3): All Clues Gathered -> Pan to Gold Key Vault
    if (curriculum.guided_ui && !cutscene_clues_shown && global.clues_found >= global.clues_needed && !global.has_dungeon_cipher_key) {
        cutscene_clues_shown = true;
        scr_trigger_dungeon_camera_cutscene(
            ["There we go—you've found the Cyber Clues! Now head to the Gold Key Vault Room, pass the security quiz on its door, and calibrate the Floor Key inside!"],
            [{ tx: _key_tx, ty: _key_ty, label: "CLUES GATHERED! -> UNLOCK GOLD KEY VAULT", sublabel: "Pass the Door Quiz & Calibrate the Floor Key [E]", col: make_color_rgb(255, 215, 55) }]
        );
        _pan_active = true;
    }
    // Milestone B (Tutorial Floors 1-3): Cipher Key Calibrated -> Pan to Lockdown Override Room
    else if (curriculum.guided_ui && !cutscene_key_shown && global.has_dungeon_cipher_key && !global.lockdown_overridden) {
        cutscene_key_shown = true;
        scr_trigger_dungeon_camera_cutscene(
            ["Great job calibrating the Floor Key! Next, head to the Security Control Room, unlock its door with the Key, and hit the Red Lockdown Override Button!"],
            [{ tx: _ovr_tx, ty: _ovr_ty, label: "KEY CALIBRATED! -> NEXT: OVERRIDE ROOM", sublabel: "Unlock Security Room & Encrypt Override Signal [E]", col: make_color_rgb(255, 80, 95) }]
        );
        _pan_active = true;
    }
    // Milestone C (ALL Floors 1-10): Lockdown Overridden -> Pan to Power Breaker Room (watch door unseal!)
    else if (!cutscene_override_shown && global.lockdown_overridden) {
        cutscene_override_shown = true;
        scr_trigger_dungeon_camera_cutscene(
            ["There we go, you've successfully overridden the lockdown protocol! The red alarms and patrol drones are offline, and the Power Breaker Room is now unsealed—head inside to restore floor power!"],
            [{ tx: _brk_tx, ty: _brk_ty, label: "LOCKDOWN OVERRIDDEN! -> BREAKER ROOM UNSEALED", sublabel: "Door Unsealed! Enter & Flip the Power Breaker Panel [E]", col: c_aqua }]
        );
        _pan_active = true;
    }
    // Milestone D (ALL Floors 1-10): Floor Power Restored -> Pan to Extraction Elevator
    else if (!cutscene_power_shown && global.power_restored) {
        cutscene_power_shown = true;
        scr_trigger_dungeon_camera_cutscene(
            ["There we go! You've brought power back to the floor! The building lights and Extraction Elevator are now online—head to the Elevator and decode its lock to clear the floor!"],
            [{ tx: _elv_tx, ty: _elv_ty, label: "POWER RESTORED! -> EXTRACTION ELEVATOR ONLINE", sublabel: "Elevator Powered Up! Decode the Door Lock to Exit [E]", col: c_lime }]
        );
        _pan_active = true;
    }
}

var _chunk_px = CHUNK_SIZE * TILE_SIZE; // 9 * 16 = 144 px per chunk

if (instance_exists(obj_jack)) {
    var _new_col = clamp(floor(obj_jack.x / _chunk_px), 0, LOGIC_GRID_W - 1);
    var _new_row = clamp(floor((obj_jack.y - 4) / _chunk_px), 0, LOGIC_GRID_H - 1);

    // Play an electronic doorway sensor chime when stepping between a room and the hallway
    if (_new_col != active_col || _new_row != active_row) {
        var _old_type = logic_map[active_col][active_row];
        var _new_type = logic_map[_new_col][_new_row];
        if (!(_old_type == ROOM_HALLWAY && _new_type == ROOM_HALLWAY)) {
            var _door_snd = audio_play_sound(snd_button_hover, 2, false);
            audio_sound_gain(_door_snd, 0.45, 0);
            audio_sound_pitch(_door_snd, (_new_type == ROOM_HALLWAY) ? 0.95 : 1.20);
        }
        active_col = _new_col;
        active_row = _new_row;
    }
}

var _in_hallway      = (logic_map[active_col][active_row] == ROOM_HALLWAY);
var _lockdown_lifted = (variable_global_exists("lockdown_lifted") && global.lockdown_lifted);
var _total_rooms     = array_length(path_list);

// Determine camera pan target chunk so we illuminate the target room & its doorway during cutscenes!
var _pan_col = -1;
var _pan_row = -1;
if (_pan_active && variable_global_exists("cam_pan_to_x")) {
    _pan_col = clamp(floor(global.cam_pan_to_x / _chunk_px), 0, LOGIC_GRID_W - 1);
    _pan_row = clamp(floor(global.cam_pan_to_y / _chunk_px), 0, LOGIC_GRID_H - 1);
}

for (var _i = 0; _i < _total_rooms; _i++) {
    var _c = path_list[_i][0];
    var _r = path_list[_i][1];
    var _rtype = logic_map[_c][_r];

    var _is_pan_room = (_pan_active && ((_c == _pan_col && _r == _pan_row)
        || (_rtype == ROOM_HALLWAY && (abs(_c - _pan_col) + abs(_r - _pan_row) <= 1))));

    var _is_lit = _lockdown_lifted
        || (_c == active_col && _r == active_row)
        || (_in_hallway && _rtype == ROOM_HALLWAY)
        || _is_pan_room;
    var _target_alpha = _is_lit ? 0.0 : 0.88;

    if (_c == active_col && _r == active_row) {
        room_discovered[_c][_r] = 2; // Visited / Lit
    } else if (_is_pan_room && room_discovered[_c][_r] == 0) {
        room_discovered[_c][_r] = 1; // Revealed on Floor Blueprint Radar after camera pan!
    }

    room_fog_alpha[_c][_r] = lerp(room_fog_alpha[_c][_r], _target_alpha, 0.22);

    if (abs(room_fog_alpha[_c][_r] - _target_alpha) < 0.01) {
        room_fog_alpha[_c][_r] = _target_alpha;
    }
}

// Reveal any room connected to a visited room as radar-detected (1) on the blueprint
var _link_len = array_length(door_links);
for (var _l = 0; _l < _link_len; _l++) {
    var _lnk = door_links[_l];
    var _c1 = _lnk[0], _r1 = _lnk[1];
    var _c2 = _lnk[2], _r2 = _lnk[3];
    if (room_discovered[_c1][_r1] == 2 && room_discovered[_c2][_r2] == 0) {
        room_discovered[_c2][_r2] = 1;
    }
    if (room_discovered[_c2][_r2] == 2 && room_discovered[_c1][_r1] == 0) {
        room_discovered[_c1][_r1] = 1;
    }
}
