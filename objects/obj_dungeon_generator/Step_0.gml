/// @description obj_dungeon_generator — Step Event
/// Tracks which room chunk the player (obj_jack) is currently inside,
/// triggers guided camera pan cutscenes & mentor pop-up dialogues,
/// updates fog-of-war alpha, and reveals rooms on the Floor Blueprint Radar.

if (variable_instance_exists(id, "is_intern_mode") && is_intern_mode) exit;
if (!gen_complete) exit;

siren_timer++;
if (banner_timer > 0) banner_timer--;

var _any_ui_busy = instance_exists(obj_textbox)
    || instance_exists(obj_textevent)
    || (variable_global_exists("pc_screen_open")    && global.pc_screen_open)
    || (variable_global_exists("key_analyzer_open") && global.key_analyzer_open)
    || (variable_global_exists("override_ui_open")   && global.override_ui_open)
    || (variable_global_exists("breaker_ui_open")    && global.breaker_ui_open)
    || (variable_global_exists("scrap_ui_open")      && global.scrap_ui_open)
    || (variable_global_exists("bot_grapple_active") && global.bot_grapple_active)
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

    var _start_cx = instance_exists(obj_jack) ? obj_jack.x : 72;
    var _start_cy = instance_exists(obj_jack) ? (obj_jack.y - 12) : 72;

    // Find the first real pink encrypted door instance on this floor
    var _enc_tx = _key_tx;
    var _enc_ty = _key_ty;
    with (obj_door_caesar_lock) {
        if (!is_breaker_door && !is_holding_door) {
            _enc_tx = draw_x + 8;
            _enc_ty = draw_y + 8;
            break;
        }
    }

    if (curriculum.guided_ui) {
        // Guided Tutorial Floors (Floors 1-3):
        // Page 0: Camera stays on Jack & Kyle in the Start Room!
        // Page 1: Pan to Gold Key Vault
        // Page 2: Pan to real Pink Encrypted Door
        // Page 3: Pan to Cyan Power Breaker Room
        // Page 4: Pan back toward Jack & Kyle for Elevator / Drone wrap-up
        var _lesson_intro = (array_length(_m_lines) > 0) ? _m_lines[0] : "Welcome to the floor! Let me show you how this sector works.";
        var _tour_lines = [
            _lesson_intro + " Let's review our 4-step emergency recovery protocol for this sector.",
            "Step 1: Inspect Clue Terminals [E] in the offices to gather clues, then unlock this Gold Key Vault room to calibrate the floor's Cipher Key!",
            "Step 2: Use that Cipher Key to decode these Pink Encrypted Doors (shrouded in 100% black fog) to search the rooms and find the Lockdown Override Console!",
            "Step 3: Overriding the lockdown unseals this Cyan Power Breaker Room—head inside and flip the 2 matching fuses to restore facility power!",
            (global.chapter_floor == 3)
                ? "Finally, once power is restored, one of the encrypted doors leads to the Extraction Elevator to clear the floor! Watch out for the patrol drone—press [E] on blue Lockers to hide!"
                : "Finally, once power is restored, one of the encrypted doors leads to the Extraction Elevator to clear the floor!"
        ];
        var _tour_targets = [
            { tx: _start_cx, ty: _start_cy, label: "SECTOR BRIEFING",                     sublabel: "Kyle (Security Analyst)",                                  col: c_white },
            { tx: _key_tx,   ty: _key_ty,   label: "STEP 1: GOLD KEY VAULT ROOM",          sublabel: "Find Clues [E] -> Pass Door Quiz -> Calibrate Floor Key",  col: make_color_rgb(255, 215, 55) },
            { tx: _enc_tx,   ty: _enc_ty,   label: "STEP 2: SEARCH ENCRYPTED DOORS",       sublabel: "Unlock Pink Encrypted Doors [E] -> Find Lockdown Override", col: make_color_rgb(255, 80, 95) },
            { tx: _brk_tx,   ty: _brk_ty,   label: "STEP 3: POWER BREAKER ROOM",           sublabel: "Unseals After Override -> Flip 2 Valid Fuses [ON]",         col: c_aqua },
            { tx: _start_cx, ty: _start_cy, label: "STEP 4: EXTRACTION ELEVATOR SEARCH",   sublabel: "Explore Encrypted Doors to Find Elevator & Clear Sector!", col: c_lime }
        ];
        scr_trigger_dungeon_camera_cutscene(_tour_lines, _tour_targets);
        _pan_active = true;
    } else if (array_length(_m_lines) > 0) {
        // Final Exam Floor 10 Briefing: Start on Jack & Kyle, then pan to Key Vault
        var _exam_targets = [
            { tx: _start_cx, ty: _start_cy, label: "FINAL EXAM: SECTOR BRIEFING", sublabel: "Kyle (Security Analyst)",               col: c_white },
            { tx: _key_tx,   ty: _key_ty,   label: "FINAL EXAM: GOLD KEY VAULT",  sublabel: "Calibrate the Exam Cipher Key [5 Letters]", col: make_color_rgb(255, 215, 55) }
        ];
        scr_trigger_dungeon_camera_cutscene(_m_lines, _exam_targets);
        _pan_active = true;
    }
}

// ---------------------------------------------------------------------------
// 2. Dynamic Milestone Camera Pans + Mentor VN Pop-Up Dialogues
// ---------------------------------------------------------------------------
if (!intro_pending && instance_exists(obj_jack) && !_any_ui_busy && !_pan_active) {
    var _chunk_sz = CHUNK_SIZE * TILE_SIZE;
    var _elv_c    = clamp(floor(_elv_tx / _chunk_sz), 0, LOGIC_GRID_W - 1);
    var _elv_r    = clamp(floor(_elv_ty / _chunk_sz), 0, LOGIC_GRID_H - 1);
    var _elv_disc = (room_discovered[_elv_c][_elv_r] == 2) || (variable_global_exists("elevator_room_found") && global.elevator_room_found);

    // Milestone A (Tutorial Floors 1-3): All Clues Gathered -> Pan to Gold Key Vault
    if (curriculum.guided_ui && !cutscene_clues_shown && global.clues_found >= global.clues_needed && !global.has_dungeon_cipher_key) {
        cutscene_clues_shown = true;
        scr_trigger_dungeon_camera_cutscene(
            ["There we go—you've found the Cyber Clues! Now head to the Gold Key Vault Room, pass the security quiz on its door, and calibrate the Floor Key inside!"],
            [{ tx: _key_tx, ty: _key_ty, label: "CLUES GATHERED! -> UNLOCK GOLD KEY VAULT", sublabel: "Pass the Door Quiz & Calibrate the Floor Key [E]", col: make_color_rgb(255, 215, 55) }]
        );
        _pan_active = true;
    }
    // Milestone B (Tutorial Floors 1-3): Cipher Key Calibrated -> Prompt player to search the Encrypted Doors
    else if (curriculum.guided_ui && !cutscene_key_shown && global.has_dungeon_cipher_key && !global.lockdown_overridden) {
        cutscene_key_shown = true;
        var _jack_cx = obj_jack.x;
        var _jack_cy = obj_jack.y - 12;
        scr_trigger_dungeon_camera_cutscene(
            ["Great job calibrating the Floor Key! Now you can decode the Pink Encrypted Doors in the hallway—unlock and explore the encrypted rooms to find the Red Lockdown Override Console!"],
            [{ tx: _jack_cx, ty: _jack_cy, label: "KEY CALIBRATED! -> SEARCH ENCRYPTED DOORS", sublabel: "Decode Pink Encrypted Doors [E] to Find Lockdown Override!", col: make_color_rgb(255, 80, 95) }]
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
    // Milestone D (ALL Floors 1-10): Floor Power Restored -> Pan to Elevator ONLY if already discovered; otherwise keep it hidden!
    else if (!cutscene_power_shown && global.power_restored) {
        cutscene_power_shown = true;
        if (_elv_disc) {
            // Player already found the Elevator Room earlier while exploring encrypted doors -> lift lockdown & pan to it!
            global.lockdown_lifted = true;
            scr_trigger_dungeon_camera_cutscene(
                ["There we go! You've brought power back to the floor! The Extraction Elevator you discovered earlier is now online—head inside the Elevator to clear the floor!"],
                [{ tx: _elv_tx, ty: _elv_ty, label: "POWER RESTORED! -> EXTRACTION ELEVATOR ONLINE", sublabel: "Elevator Powered Up! Head Inside to Clear the Floor", col: c_lime }]
            );
        } else {
            var _p_tx = obj_jack.x;
            var _p_ty = obj_jack.y - 12;
            scr_trigger_dungeon_camera_cutscene(
                ["There we go! You've brought power back to the floor! The Extraction Elevator is now online behind one of the Pink Encrypted Doors—decode and explore the encrypted rooms to find the Elevator!"],
                [{ tx: _p_tx, ty: _p_ty, label: "POWER RESTORED! -> SEARCH ENCRYPTED DOORS", sublabel: "Unlock the Remaining Encrypted Doors [E] to Find the Elevator!", col: c_lime }]
            );
        }
        _pan_active = true;
    }
}

var _chunk_px = CHUNK_SIZE * TILE_SIZE; // 9 * 16 = 144 px per chunk

if (instance_exists(obj_jack)) {
    var _new_col = clamp(floor(obj_jack.x / _chunk_px), 0, LOGIC_GRID_W - 1);
    var _new_row = clamp(floor((obj_jack.y - 4) / _chunk_px), 0, LOGIC_GRID_H - 1);

    // Play an electronic doorway sensor chime when stepping between a room and the hallway
    // (Skip doorway chime if stepping between two seamlessly merged chunks of a long room!)
    if (_new_col != active_col || _new_row != active_row) {
        var _old_type   = logic_map[active_col][active_row];
        var _new_type   = logic_map[_new_col][_new_row];
        var _border_lnk = scr_get_border_door_type(active_col, active_row, _new_col, _new_row, door_links);
        if (!(_old_type == ROOM_HALLWAY && _new_type == ROOM_HALLWAY) && _border_lnk != TILE_ROOM_MERGE) {
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

    // Check if this chunk is seamlessly merged (TILE_ROOM_MERGE) with the player's current active chunk
    var _is_merged_with_active = (scr_get_border_door_type(_c, _r, active_col, active_row, door_links) == TILE_ROOM_MERGE);

    // Note: Unvisited Encrypted-Door rooms stay shrouded even if global.lockdown_lifted is true until visited!
    var _is_encrypted = room_is_encrypted[_c][_r];
    var _is_lit = (_c == active_col && _r == active_row)
        || _is_merged_with_active
        || (_in_hallway && _rtype == ROOM_HALLWAY)
        || _is_pan_room
        || (_lockdown_lifted && (!_is_encrypted || room_discovered[_c][_r] == 2));

    // ONLY Encrypted-Door rooms (Elevator Room, Override Room, Encrypted Decoy Rooms) use 100% opaque fog (1.0)!
    // Once visited (room_discovered == 2), rooms are no longer shrouded in 100% black fog!
    var _unlit_fog    = (_is_encrypted && room_discovered[_c][_r] < 2) ? 1.0 : 0.88;
    var _target_alpha = _is_lit ? 0.0 : _unlit_fog;

    if ((_c == active_col && _r == active_row) || _is_merged_with_active) {
        room_discovered[_c][_r]   = 2; // Visited / Lit
        room_is_encrypted[_c][_r] = false;
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
