/// @description obj_dungeon_generator — Step Event
/// Tracks which room chunk the player (obj_jack) is currently inside,
/// triggers guided camera pan cutscenes & mentor pop-up dialogues,
/// updates fog-of-war alpha, and reveals rooms on the Floor Blueprint Radar.

if (variable_instance_exists(id, "is_intern_mode") && is_intern_mode) exit;
if (!gen_complete) exit;

// Ensure Jack is snapped into ROOM_START even if inst_DT_JACK was created after obj_dungeon_generator
if (variable_instance_exists(id, "jack_spawn_snapped") && !jack_spawn_snapped && instance_exists(obj_jack)) {
    obj_jack.x = start_spawn_x;
    obj_jack.y = start_spawn_y;
    obj_jack.isInCutscene = false;
    jack_spawn_snapped = true;
}

// Reset non-hint terminal indicators to yellow once when Phase 2 (Investigation) begins
if (!variable_instance_exists(id, "phase2_pc_indicators_reset")) {
    phase2_pc_indicators_reset = false;
}
if (!phase2_pc_indicators_reset && variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key) {
    phase2_pc_indicators_reset = true;
    with (obj_dungeon_prop) {
        if (prop_type == TILE_PROP_PC && !is_vault_hint_pc && !is_holding_clue) {
            talked_once = false;
        }
    }
}

siren_timer++;
if (banner_timer > 0) banner_timer--;
if (variable_global_exists("drone_jammed_timer") && global.drone_jammed_timer > 0) {
    global.drone_jammed_timer--;
}

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
        // Guided Tutorial Floors (Floors 1-3): 5-Stop Comprehensive Mechanics Tour
        var _lesson_intro = (array_length(_m_lines) > 0) ? _m_lines[0] : "Welcome to the floor! Let me show you how everything works.";
        var _tour_lines = [
            _lesson_intro + " Watch your Dynamic Quest Tracker in the top-left corner—it updates with your current goal at every phase! First, talk to coworkers with [E] ('Say Hello' -> 'Ask about...') and search the offices for the 1 unlocked Security Sector Terminal [E] holding the Key Vault hint.",
            "PHASE 1 — UNLOCK THE KEY VAULT: All regular computers are locked right now! Once you read the hint on the Security Sector Terminal [E], come to this Gold Key Vault room, pass the door quiz, and grab the floor's Cipher Key inside.",
            "PHASE 2 — DETECTIVE INVESTIGATION: Grabbing the Cipher Key unlocks all office computers and these Pink Encrypted Doors! Talk to coworkers [E] for Level 1 & 2 clues, and inspect Suspect Desks (with nameplates) [E] for Level 3 Critical Proof showing whose accidental slip-up let the hackers in!",
            "CASE BOARD [TAB] & WRENCH SCRAPPING [RMB]: Press [TAB] anytime to open your Case Board, scroll through your clues, and click 'ACCUSE A SUSPECT'! Also, Right-Click [RMB] (or press [R]) on terminals to Wrench Scrap—you need 2 Scrap to fix the Breaker, and you must finish in the GREEN ZONE (4 to 6 Scrap) on the bottom bar to avoid Intern Babysitting Duty!",
            "PHASE 3 & 4 — OVERRIDE, BREAKER & EXTRACTION: Solving the case on [TAB] unlocks the Red Lockdown Override Console! Hit the Override to disarm the patrol bots and unseal the Cyan Power Breaker Room, spend 2 Scrap to fix the 3 fuses, and escape via the Extraction Elevator! (Use blue Lockers [E] to hide from patrol bots, or sneak behind a bot and press [RMB] to scrap it!)"
        ];
        var _tour_targets = [
            { tx: _start_cx, ty: _start_cy, label: "PHASE 1: FIND SECURITY SECTOR PC",     sublabel: "Talk to NPCs [E] & Find the 1 Unlocked Security PC Hint!", col: c_white },
            { tx: _key_tx,   ty: _key_ty,   label: "PHASE 1B: GOLD KEY VAULT ROOM",         sublabel: "Use Security PC Hint -> Pass Door Quiz -> Grab Cipher Key",  col: make_color_rgb(255, 215, 55) },
            { tx: _enc_tx,   ty: _enc_ty,   label: "PHASE 2: DETECTIVE INVESTIGATION",      sublabel: "Check NPCs & Suspect Desks [E] -> Accuse on [TAB] Board!",   col: make_color_rgb(255, 80, 95) },
            { tx: _brk_tx,   ty: _brk_ty,   label: "SCRAP [RMB] & POWER BREAKER ROOM",      sublabel: "Right-Click [RMB] for 4-6 Scrap (Green Zone) & Fix Breaker", col: c_aqua },
            { tx: _start_cx, ty: _start_cy, label: "PHASE 3 & 4: OVERRIDE & EXTRACTION",    sublabel: "Solve Case [TAB] -> Hit Override -> Fix Breaker -> Elevator!", col: c_lime }
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

    // Count Level 3 Critical Proof clues found for Tutorial Milestone B2
    var _tut_ev_cur  = variable_global_exists("evidence_found")  ? global.evidence_found  : 0;
    var _tut_ev_req  = variable_global_exists("evidence_needed") ? global.evidence_needed : 2;
    var _tut_min_ev  = min(2, _tut_ev_req);
    var _tut_crit    = 0;
    if (variable_global_exists("case_evidence")) {
        for (var _tci = 0; _tci < array_length(global.case_evidence); _tci++) {
            var _tce = global.case_evidence[_tci];
            if (_tce.found && variable_struct_exists(_tce, "tier") && _tce.tier == 3) _tut_crit++;
        }
    }
    var _tut_ready_acc = (_tut_ev_cur >= _tut_min_ev && _tut_crit >= 1);
    var _tut_solved    = (variable_global_exists("incident_solved") && global.incident_solved);

    // Milestone A (Tutorial Floors 1-3): Security Sector PC Hint Found -> Pan to Gold Key Vault
    if (curriculum.guided_ui && !cutscene_clues_shown && global.clues_found >= global.clues_needed && !global.has_dungeon_cipher_key) {
        cutscene_clues_shown = true;
        scr_trigger_dungeon_camera_cutscene(
            ["You found the Key Vault hint on the Security Sector Terminal! Now head to the Gold Key Vault Room, pass the security quiz on its door, and grab the Floor Cipher Key inside!"],
            [{ tx: _key_tx, ty: _key_ty, label: "HINT FOUND! -> UNLOCK GOLD KEY VAULT", sublabel: "Pass the Door Quiz & Grab the Cipher Key [E]", col: make_color_rgb(255, 215, 55) }]
        );
        _pan_active = true;
    }
    // Milestone B (Tutorial Floors 1-3): Cipher Key Collected -> Teach Phase 2 Investigation & Wrench Scrapping!
    else if (curriculum.guided_ui && !cutscene_key_shown && global.has_dungeon_cipher_key && !global.lockdown_overridden) {
        cutscene_key_shown = true;
        var _jack_cx = obj_jack.x;
        var _jack_cy = obj_jack.y - 12;
        scr_trigger_dungeon_camera_cutscene(
            [
                "Awesome—grabbing the Cipher Key unlocked every office computer and lets you decode the Pink Encrypted Doors! Now PHASE 2 (THE INVESTIGATION) begins: talk to coworkers [E] ('Say Hello' -> 'Ask about...') for Level 1 & 2 clues, and inspect Suspect Desks (with nameplates) [E] for Level 3 Critical Proof!",
                "At the same time, Right-Click [RMB] (or press [R]) on terminals to Wrench Scrap! You need 2 Scrap to repair the Power Breaker later, and you MUST finish with 4 to 6 scrapped assets (the GREEN ZONE on your bottom Compliance Bar) or HR will send you to Intern Babysitting Duty!"
            ],
            [
                { tx: _jack_cx, ty: _jack_cy, label: "PHASE 2: INVESTIGATE COWORKERS & DESKS", sublabel: "Talk to NPCs [E] & Check Suspect Desks for Lvl 3 Proof!", col: make_color_rgb(255, 80, 95) },
                { tx: _jack_cx, ty: _jack_cy, label: "WRENCH SCRAP [RMB] -> GREEN ZONE (4-6)", sublabel: "Right-Click [RMB] Terminals -> Keep Bottom Bar in GREEN!", col: c_lime }
            ]
        );
        _pan_active = true;
    }
    // Milestone B2 (Tutorial Floors 1-3): Ready to Accuse (2+ Clues including 1 Level 3 Critical Proof) -> Teach [TAB] Case Board!
    else if (curriculum.guided_ui && !cutscene_ready_accuse_shown && global.has_dungeon_cipher_key && _tut_ready_acc && !_tut_solved) {
        cutscene_ready_accuse_shown = true;
        var _jack_cx2 = obj_jack.x;
        var _jack_cy2 = obj_jack.y - 12;
        scr_trigger_dungeon_camera_cutscene(
            ["You've found Level 3 Critical Proof! Press [TAB] right now to open your Case Board, use [W/S] or the Mouse Wheel to read your clues, and click 'ACCUSE A SUSPECT' to identify whose accidental slip-up caused the breach!"],
            [{ tx: _jack_cx2, ty: _jack_cy2, label: "READY TO ACCUSE! -> PRESS [TAB] CASE BOARD", sublabel: "Open [TAB] -> Click 'ACCUSE A SUSPECT' to Solve the Case!", col: make_color_rgb(135, 255, 165) }]
        );
        _pan_active = true;
    }
    // Milestone B3 (Tutorial Floors 1-3): Case Solved on [TAB] -> Pan to Lockdown Override Console!
    else if (curriculum.guided_ui && !cutscene_case_solved_shown && _tut_solved && !global.lockdown_overridden) {
        cutscene_case_solved_shown = true;
        scr_trigger_dungeon_camera_cutscene(
            ["Case solved! Identifying Patient Zero and their accidental slip-up just unlocked the Red Lockdown Override Console! Decode the Pink Encrypted Doors to find the Security Control Room and activate the Override Console [E]!"],
            [{ tx: _ovr_tx, ty: _ovr_ty, label: "CASE SOLVED! -> ACTIVATE LOCKDOWN OVERRIDE", sublabel: "Find the Security Control Room & Hit the Red Override [E]!", col: make_color_rgb(255, 95, 115) }]
        );
        _pan_active = true;
    }
    // Milestone C (ALL Floors 1-10): Lockdown Overridden -> Pan to Power Breaker Room (watch door unseal!)
    else if (!cutscene_override_shown && global.lockdown_overridden) {
        cutscene_override_shown = true;
        scr_trigger_dungeon_camera_cutscene(
            ["Lockdown overridden! The patrol bots are now harmless, and the Power Breaker Room door just unsealed—make sure you have at least 2 Scrap (Right-Click [RMB] on terminals) and head inside to fix the 3 fuses!"],
            [{ tx: _brk_tx, ty: _brk_ty, label: "LOCKDOWN OVERRIDDEN! -> BREAKER ROOM UNSEALED", sublabel: "Need 2 Scrap [RMB] -> Enter & Fix the 3 Breaker Fuses [E]!", col: c_aqua }]
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
                ["Floor power is 100% restored! Make sure your bottom Recovery Compliance Bar is in the GREEN ZONE (4 to 6 scrapped assets) so HR doesn't assign Intern Duty, then board the Extraction Elevator!"],
                [{ tx: _elv_tx, ty: _elv_ty, label: "POWER RESTORED! -> EXTRACTION ELEVATOR ONLINE", sublabel: "Check Green Zone (4-6 Scrap) & Board the Elevator!", col: c_lime }]
            );
        } else {
            var _p_tx = obj_jack.x;
            var _p_ty = obj_jack.y - 12;
            scr_trigger_dungeon_camera_cutscene(
                ["Floor power is 100% restored! Make sure your bottom Recovery Compliance Bar is in the GREEN ZONE (4 to 6 scrapped assets), then unlock the remaining Pink Encrypted Doors to find and board the Extraction Elevator!"],
                [{ tx: _p_tx, ty: _p_ty, label: "POWER RESTORED! -> FIND EXTRACTION ELEVATOR", sublabel: "Check Green Zone (4-6 Scrap) & Search Encrypted Doors [E]!", col: c_lime }]
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

    // Smooth fade in / persistent display / fade out for top-right Room Name Popup
    var _target_room = (variable_instance_exists(id, "room_names") && array_length(room_names) > active_col)
        ? room_names[active_col][active_row]
        : "";

    if (_target_room == "") {
        // In hallway or unassigned space -> fade out
        room_popup_alpha = max(0.0, room_popup_alpha - 0.07);
        if (room_popup_alpha <= 0.0) room_popup_text = "";
    } else if (room_popup_text == _target_room) {
        // Inside room -> fade in smoothly and persistently stay visible
        room_popup_alpha = min(1.0, room_popup_alpha + 0.08);
    } else if (room_popup_text == "") {
        // Entering a room from hallway
        room_popup_text  = _target_room;
        room_popup_alpha = min(1.0, room_popup_alpha + 0.08);
    } else {
        // Moving directly between two different named rooms -> cross-fade
        room_popup_alpha = max(0.0, room_popup_alpha - 0.08);
        if (room_popup_alpha <= 0.0) {
            room_popup_text = _target_room;
        }
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
