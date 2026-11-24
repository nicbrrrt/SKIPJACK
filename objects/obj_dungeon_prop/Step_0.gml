/// @description obj_dungeon_prop — Step Event
/// Handles one-time initialization for NPCs/Drones, hallway centerline drone patrol & full-width scan,
/// and [E] player interactions with clue computers, memos, NPCs, and rebooted drones.

if (!init_done) {
    init_done = true;

    if (prop_type == TILE_PROP_NPC) {
        switch (npc_id) {
            case 0:
                myName     = "Greg (IT Helpdesk)";
                npc_spr    = spr_npc1_idle;
                myPortrait = spr_greg_portrait;
                myVoice    = snd_voice2;
                break;
            case 1:
                myName     = "Sarah (Junior Dev)";
                npc_spr    = spr_npc2_idle;
                myPortrait = spr_npc2_portrait;
                myVoice    = snd_voice1;
                break;
            case 2:
                myName     = "Kyle (Security Analyst)";
                npc_spr    = spr_kyle_idle;
                myPortrait = spr_kyle_portrait;
                myVoice    = snd_voice2;
                break;
            case 3:
                myName     = "Lea (Network Engineer)";
                npc_spr    = spr_lea_idle;
                myPortrait = spr_lea_portrait;
                myVoice    = snd_voice1;
                break;
            default:
                myName     = "David (SysAdmin)";
                npc_spr    = spr_david_idle;
                myPortrait = spr_david_portrait;
                myVoice    = snd_voice2;
                break;
        }
        myPortraitTalk = myPortrait;
    }
}

if (variable_global_exists("is_paused") && global.is_paused) exit;
if (scrap_pop_timer > 0) scrap_pop_timer--;

if (instance_exists(obj_textevent)
    || instance_exists(obj_textbox)
    || (variable_global_exists("cam_pan_phase")     && global.cam_pan_phase != "off")
    || (variable_global_exists("pc_screen_open")    && global.pc_screen_open)
    || (variable_global_exists("key_analyzer_open") && global.key_analyzer_open)
    || (variable_global_exists("override_ui_open")  && global.override_ui_open)
    || (variable_global_exists("breaker_ui_open")   && global.breaker_ui_open)
    || (variable_global_exists("scrap_ui_open")     && global.scrap_ui_open)
    || (variable_global_exists("sos_ui_open")       && global.sos_ui_open)
    || instance_exists(obj_cipher)
    || instance_exists(obj_dungeon_quiz)
    || instance_exists(obj_dungeon_victory))
{
    player_near      = false;
    can_sneak_ambush = false;
    exit;
}

var _lifted = (variable_global_exists("lockdown_lifted")     && global.lockdown_lifted)
           || (variable_global_exists("lockdown_overridden") && global.lockdown_overridden);
var _pwr_on = (variable_global_exists("power_restored")      && global.power_restored)
           || (variable_global_exists("lockdown_lifted")     && global.lockdown_lifted);

// ---------------------------------------------------------------------------
// 1. Stranded Coworker NPC Animation & Facing
// ---------------------------------------------------------------------------
if (prop_type == TILE_PROP_NPC) {
    var _row = (y div 16) mod 9;
    depth = 28 - _row; // Beneath room fog overlay (depth 10), Y-sorted with other props
    if (instance_exists(obj_jack)) {
        var _dx = obj_jack.x - (x + 8);
        var _dy = obj_jack.y - (y + 12);
        if (abs(_dx) > abs(_dy)) {
            idle_facing = (_dx > 0) ? "right" : "left";
        } else {
            idle_facing = (_dy > 0) ? "down" : "up";
        }
    }
    var _anim = scr_dir_idle_anim(npc_spr, idle_facing, idle_anim_acc, 0.10);
    npc_frame     = _anim[0];
    idle_anim_acc = _anim[1];
}

// ---------------------------------------------------------------------------
// 2. Roaming Rogue Security Drone — Patrols Centerline, Stealth Ambush & Capture
// ---------------------------------------------------------------------------
can_sneak_ambush = false;
if (prop_type == TILE_PROP_DRONE) {
    depth = -(y + 10); // Draws above room fog so you can see the drone & flashlight outside your doorway
    if (!is_scrapped) hover_t += 0.08;
    if (zap_cd > 0) zap_cd--;

    // --- Active Spam [E] Apprehend Struggle Minigame (disabled once lockdown is overridden) ---
    if (_lifted) {
        if (grapple_active) {
            grapple_active            = false;
            global.bot_grapple_active = false;
        }
        grapple_meter = 0.45;
    } else if (grapple_active) {
        global.bot_grapple_active = true;
        grapple_meter -= 0.0065;

        if (keyboard_check_pressed(ord("E")) || mouse_check_button_pressed(mb_right)) {
            grapple_meter          = min(1.0, grapple_meter + 0.16);
            global.cam_shake_timer = 4;
            global.cam_shake_mag   = 2;
            audio_play_sound(choose(select1, select2, select3), 8, false);
        }

        if (grapple_meter >= 1.0) {
            // Successfully apprehended the Security Bot! Open Sever Encryption UI!
            grapple_active            = false;
            global.bot_grapple_active = false;
            audio_play_sound(snd_correct_ping, 9, false);
            scr_open_scrap_sever_ui(id);
            exit;
        }

        if (grapple_meter <= 0.0) {
            // Bot broke free from grapple! Trigger capture & confiscate all Scrap!
            grapple_active            = false;
            global.bot_grapple_active = false;
            zap_cd                    = 60;
            // Force immediate capture below by setting _trigger_bot_capture = true
        } else {
            exit;
        }
    }

    if (!is_scrapped) {
        var _is_jammed = (variable_global_exists("drone_jammed_timer") && global.drone_jammed_timer > 0);
        if (_is_jammed) {
            patrol_vx = 0;
            patrol_vy = 0;
            can_sneak_ambush = true;
        }

        var _trigger_bot_capture = (!_lifted && grapple_meter <= 0.0 && zap_cd == 60);
        if (_trigger_bot_capture) {
            grapple_meter = 0.45;
        }

        if (!_trigger_bot_capture && !_is_jammed && instance_exists(obj_dungeon_generator) && variable_instance_exists(obj_dungeon_generator, "hallway_waypoints")) {
            var _wps = obj_dungeon_generator.hallway_waypoints;
            var _n_wp = array_length(_wps);
            if (_n_wp >= 2) {
                wp_index = clamp(wp_index, 0, _n_wp - 1);
                var _tx = _wps[wp_index][0];
                var _ty = _wps[wp_index][1];
                var _dist_wp = point_distance(x, y, _tx, _ty);
                var _spd = (variable_global_exists("floor_curriculum") && variable_struct_exists(global.floor_curriculum, "drone_speed"))
                    ? global.floor_curriculum.drone_speed
                    : 0.95;

                if (_dist_wp <= _spd) {
                    x = _tx;
                    y = _ty;
                    wp_index += wp_dir;
                    if (wp_index >= _n_wp) {
                        wp_index = _n_wp - 2;
                        wp_dir   = -1;
                    } else if (wp_index < 0) {
                        wp_index = 1;
                        wp_dir   = 1;
                    }
                } else {
                    var _pdir = point_direction(x, y, _tx, _ty);
                    patrol_vx = lengthdir_x(_spd, _pdir);
                    patrol_vy = lengthdir_y(_spd, _pdir);
                    x += patrol_vx;
                    y += patrol_vy;
                }
            }
        }

        // Raycast Flashlight Vision Check & Rear Stealth Ambush Check (only hostile before lockdown override!)
        var _in_locker = (variable_global_exists("player_in_locker") && global.player_in_locker);
        if (!_lifted && !_in_locker && instance_exists(obj_jack) && instance_exists(obj_dungeon_generator)) {
            var _cx = x + 8;
            var _cy = y + 8;
            var _jx = obj_jack.x;
            var _jy = obj_jack.y - 6;

            var _dist_to_jack = point_distance(_cx, _cy, _jx, _jy);
            var _base_dir     = point_direction(0, 0, patrol_vx, patrol_vy);
            var _scan_dir     = _base_dir + sin(hover_t * 0.90) * 18;
            var _ang_to_jack  = point_direction(_cx, _cy, _jx, _jy);
            var _ang_diff     = abs(angle_difference(_ang_to_jack, _scan_dir));

            // Check if Jack is sneaking behind/beside the bot outside its front vision cone!
            if (_dist_to_jack <= 28 && _ang_diff > 45) {
                var _wall_ambush = collision_line(_cx, _cy, _jx, _jy, obj_dungeon_wall, false, true);
                if (_wall_ambush == noone) {
                    can_sneak_ambush = true;
                }
            }

            // Blind Watcher Bust statue: -30% vision cone (64 -> 44 deg) and shorter flashlight range (92 -> 66 px)
            var _watcher   = scr_has_active_statue(0);
            var _vis_range = _watcher ? 66 : 92;
            var _vis_half  = _watcher ? 22 : 32;

            if (detect_ping_cd > 0) detect_ping_cd--;
            var _spotted_now = false;
            if (!_trigger_bot_capture && !_is_jammed && zap_cd <= 0 && _dist_to_jack <= _vis_range && obj_jack.bump_timer <= 0) {
                // Caught in cone if inside the 64-degree (±32°) front flashlight beam (or bumping front arc)
                // AND there is no wall blocking line-of-sight!
                if (_ang_diff <= _vis_half || (_dist_to_jack < 10 && _ang_diff <= 45)) {
                    var _wall_hit = collision_line(_cx, _cy, _jx, _jy, obj_dungeon_wall, false, true);
                    if (_wall_hit == noone) {
                        _spotted_now = true;
                    }
                }
            }

            if (_spotted_now) {
                if (detect_meter <= 0.02 && detect_ping_cd <= 0) {
                    detect_ping_cd = 30;
                    audio_play_sound(snd_button_hover, 8, false);
                }
                var _fps = max(1, game_get_speed(gamespeed_fps));
                var _fill_rate = 1.0 / (2.5 * _fps); // 2.5 seconds inside vision cone before capture
                detect_meter = min(1.0, detect_meter + _fill_rate);
                if (detect_meter >= 1.0) {
                    detect_meter = 0.0;
                    _trigger_bot_capture = true;
                }
            } else {
                detect_meter = max(0.0, detect_meter - 0.012); // Slow cooldown when out of sight
            }

            if (_trigger_bot_capture) {
                zap_cd = 60;

                // 1. Play capture alarm & screen shake
                global.cam_shake_timer = 14;
                global.cam_shake_mag   = 5;
                audio_play_sound(snd_error, 10, false);
                audio_play_sound(snd_select, 9, false);

                // 2. Confiscate ALL of Jack's carried Scrap!
                var _confiscated_scrap = variable_global_exists("scrap_count") ? global.scrap_count : 0;
                global.scrap_count = 0;
                global.floor_times_busted++;

                // Reboot scrapped standard office PCs on capture so player can never be soft-locked out of 2 Scrap for the Breaker!
                with (obj_dungeon_prop) {
                    if (prop_type == TILE_PROP_PC && !is_server_rack && !is_holding_clue) {
                        is_scrapped = false;
                        is_fried    = false;
                    }
                }

                // 3. Send Jack to the locked Security Holding Room (Brig)
                if (variable_global_exists("holding_room_x") && global.holding_room_x > 0) {
                    obj_jack.x            = global.holding_room_x;
                    obj_jack.y            = global.holding_room_y;
                    obj_jack.sprite_index = spr_jack_idle;
                    obj_jack.bump_timer   = 0;
                    obj_dungeon_generator.active_col = global.holding_room_col;
                    obj_dungeon_generator.active_row = global.holding_room_row;
                    obj_dungeon_generator.room_discovered[global.holding_room_col][global.holding_room_row] = 2;
                    scr_ensure_tutorial_flags();
                    if (!global.tut_seen_brig) {
                        global.tut_seen_brig   = true;
                        global.visual_tut_kind = "brig";
                    }
                }

                // 4. Rotate the Chapter Cipher Key to a new value & reset Key possession
                var _old_key = variable_global_exists("dungeon_cipher_key") ? global.dungeon_cipher_key : 1;
                var _new_key = scr_roll_cipher_key();
                var _guard   = 0;
                while (_new_key == _old_key && _guard < 20) {
                    _new_key = scr_roll_cipher_key();
                    _guard++;
                }
                global.dungeon_cipher_key     = _new_key;
                global.dungeon_vigenere_key   = scr_roll_vigenere_keyword(variable_global_exists("chapter_floor") ? global.chapter_floor : 4);
                global.has_dungeon_cipher_key = false;
                scr_roll_holding_key_and_equation();
                scr_init_facility_puzzles();

                with (obj_caesar_key_pedestal) {
                    collected = false;
                }

                // 5. Re-lock ALL Quiz and Cipher doors across the floor
                with (obj_door_quiz_lock) {
                    locked = true;
                    x      = draw_x;
                    y      = draw_y;
                }
                with (obj_door_caesar_lock) {
                    locked = true;
                    x      = draw_x;
                    y      = draw_y;
                }

                // 6. Notify the player in the Holding Cell (highlighting confiscated Scrap!)
                var _scrap_msg = (_confiscated_scrap > 0)
                    ? ("Worse—the bot confiscated all " + string(_confiscated_scrap) + " of my Scrap, re-locked the doors, and rotated the floor's Cipher Key!")
                    : "Worse—the lockdown protocol just re-locked all the doors, confiscated my Scrap pouch, and rotated the floor's Cipher Key!";
                global.e_dialogue_intro_shown = true;
                create_textevent([
                    "BUSTED! The security bot caught me and locked me in the Holding Cell!",
                    _scrap_msg,
                    "I need to check the terminal or note in this cell [E] for a math clue to crack the brig door!"
                ], [obj_jack.id, obj_jack.id, obj_jack.id]);
                exit;
            }
        }
    }
}

// ---------------------------------------------------------------------------
// 3. Check Proximity, [E] Interactions, Right-Click Wrench Scrapping & Bot Ambush
// ---------------------------------------------------------------------------
player_near = false;
if (!instance_exists(obj_jack)) exit;

// If Jack is currently hiding inside THIS locker, pressing [E] exits the locker!
if (prop_type == TILE_PROP_LOCKER && variable_global_exists("player_in_locker") && global.player_in_locker && global.active_locker_id == id) {
    player_near = true;
    if (keyboard_check_pressed(ord("E"))) {
        global.player_in_locker = false;
        global.active_locker_id = noone;
        obj_jack.visible        = true;
        audio_play_sound(snd_button_click, 5, false);
    }
    exit;
}

if (variable_global_exists("player_in_locker") && global.player_in_locker) exit;

// All unscrapped PCs (for Right-Click Wrench Scrapping or [E] Clue Inspection), Papers, NPCs,
// Lockers, Override/Breaker Consoles, and Ambushable/Powered-Down Drones can be interacted with!
var _can_inspect = (prop_type == TILE_PROP_PC && (!is_scrapped || has_clue))
                || (prop_type == TILE_PROP_PAPER)
                || (prop_type == TILE_PROP_NPC)
                || (prop_type == TILE_PROP_LOCKER)
                || (prop_type == TILE_PROP_OVERRIDE)
                || (prop_type == TILE_PROP_BREAKER)
                || (prop_type == TILE_PROP_DRONE && !is_scrapped && (_lifted || can_sneak_ambush));

if (!_can_inspect) exit;

var _interact_rad = (prop_type == TILE_PROP_DRONE) ? 28 : 22;
var _dist = point_distance(x + 8, y + 8, obj_jack.x, obj_jack.y - 6);
if (_dist < _interact_rad) {
    // Only highlight the closest inspectable prop to Jack
    var _closest = true;
    var _my_id = id;
    with (obj_dungeon_prop) {
        if (id != _my_id && player_near) {
            if (point_distance(x + 8, y + 8, obj_jack.x, obj_jack.y - 6) < _dist) {
                _closest = false;
            } else {
                player_near = false;
            }
        }
    }
    player_near = _closest;
}

// --- A. RIGHT-CLICK (or [R]) WITH WRENCH TO SCRAP TERMINAL OR BOT ---
var _wrench_pressed = mouse_check_button_pressed(mb_right) || keyboard_check_pressed(ord("R"));
if (player_near && _wrench_pressed && !is_scrapped && (prop_type == TILE_PROP_PC || prop_type == TILE_PROP_DRONE)) {
    if (is_holding_clue) {
        // Don't scrap the Holding Cell's math clue computer while locked in the brig!
        scrap_pop_timer = 85;
        scrap_pop_text  = "NEED THIS TERMINAL TO ESCAPE BRIG [E]!";
        audio_play_sound(wrong1, 6, false);
        exit;
    }
    if (prop_type == TILE_PROP_PC && variable_global_exists("sos_active") && global.sos_active
        && variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key
        && global.sos_phase >= 1 && global.sos_phase <= 3) {
        if (global.sos_phase == 1 && variable_global_exists("sos_target_pc") && global.sos_target_pc == id) {
            scrap_pop_timer = 85;
            scrap_pop_text  = "LIVE INFECTION! PRESS [E] FOR S.O.S. INTERCEPT!";
            audio_play_sound(wrong1, 6, false);
            exit;
        }
        if (variable_global_exists("case_culprit_idx") && suspect_idx == global.case_culprit_idx) {
            scrap_pop_timer = 85;
            scrap_pop_text  = "PATIENT ZERO HOST! PRESS [E] FOR S.O.S.!";
            audio_play_sound(wrong1, 6, false);
            exit;
        }
    }

    // If circuits were fried by Anti-Tamper on a previous wrong encryption, spend 1 Scrap to fix!
    if (is_fried) {
        var _cur_scrp = variable_global_exists("scrap_count") ? global.scrap_count : 0;
        if (_cur_scrp >= 1) {
            global.scrap_count -= 1;
            is_fried            = false;
            scrap_pop_timer     = 75;
            scrap_pop_text      = "-1 SCRAP (CIRCUITS REPAIRED!)";
            audio_play_sound(snd_correct_ping, 8, false);
            scr_open_scrap_sever_ui(id);
        } else {
            scrap_pop_timer = 95;
            scrap_pop_text  = "CIRCUITS FRIED! NEED 1 SCRAP TO FIX!";
            audio_play_sound(wrong1, 8, false);
        }
        exit;
    }

    // If this is a roaming Security Bot that is still active, start the Spam [E] Apprehend struggle first!
    if (prop_type == TILE_PROP_DRONE && !_lifted) {
        grapple_active            = true;
        grapple_meter             = 0.45;
        global.bot_grapple_active = true;
        audio_play_sound(snd_select, 8, false);
        exit;
    }

    // Safety net: if scrapping an unread evidence terminal, auto-log its evidence first so the case is never soft-locked!
    if (prop_type == TILE_PROP_PC && has_clue && !talked_once && !_lifted) {
        talked_once = true;
        if (evidence_idx >= 0) scr_log_evidence(evidence_idx);
    }

    audio_play_sound(snd_select, 8, false);
    scr_open_scrap_sever_ui(id);
    exit;
}

// --- B. [E] KEY INTERACTION (Clues, Lockers, Consoles & Sneak Bot Apprehension!) ---
if (player_near && keyboard_check_pressed(ord("E"))) {
    // Sneak behind a Roaming Security Bot + Press [E] -> Apprehend (Spam [E] struggle)!
    if (prop_type == TILE_PROP_DRONE && !is_scrapped) {
        if (is_fried) {
            var _cur_s = variable_global_exists("scrap_count") ? global.scrap_count : 0;
            if (_cur_s >= 1) {
                global.scrap_count -= 1;
                is_fried            = false;
                scrap_pop_timer     = 75;
                scrap_pop_text      = "-1 SCRAP (BOT CIRCUITS FIXED!)";
                audio_play_sound(snd_correct_ping, 8, false);
                scr_open_scrap_sever_ui(id);
            } else {
                scrap_pop_timer = 95;
                scrap_pop_text  = "BOT FRIED! NEED 1 SCRAP TO FIX!";
                audio_play_sound(wrong1, 8, false);
            }
            exit;
        }
        if (!_lifted && can_sneak_ambush) {
            grapple_active            = true;
            grapple_meter             = 0.45;
            global.bot_grapple_active = true;
            audio_play_sound(snd_select, 8, false);
            exit;
        }
    }

    // Floor 10 Final Exam S.O.S. (Save Our System) Live Outbreak Terminal Interactions
    var _sos_on = (variable_global_exists("sos_active") && global.sos_active
                && variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key
                && !is_holding_clue && !is_vault_hint_pc);
    if (prop_type == TILE_PROP_PC && _sos_on && global.sos_phase >= 1 && global.sos_phase <= 3) {
        keyboard_clear(ord("E"));
        if (global.sos_phase == 1) {
            if (variable_global_exists("sos_target_pc") && global.sos_target_pc == id) {
                scr_open_sos_ui(1, id);
                exit;
            } else if (variable_instance_exists(id, "sos_locked_infected") && sos_locked_infected) {
                scrap_pop_timer = 110;
                scrap_pop_text  = "VIRUS HOPPED TO: " + string_upper(global.sos_target_room_name) + "!";
                audio_play_sound(wrong1, 6, false);
                exit;
            } else {
                scrap_pop_timer = 110;
                scrap_pop_text  = "S.O.S. TRACE -> " + string_upper(global.sos_target_room_name) + " (" + string(global.sos_catches) + "/3)";
                audio_play_sound(snd_button_hover, 6, false);
                exit;
            }
        } else if (global.sos_phase == 2) {
            scr_open_sos_ui(2, id);
            exit;
        } else if (global.sos_phase == 3) {
            if (variable_global_exists("case_culprit_idx") && suspect_idx == global.case_culprit_idx) {
                scr_open_sos_ui(3, id);
                exit;
            } else {
                var _pz_s = global.case_suspects[global.case_culprit_idx];
                scrap_pop_timer = 115;
                scrap_pop_text  = "GO TO PATIENT ZERO: DESK " + _pz_s.nameplate + " (" + _pz_s.name + ")!";
                audio_play_sound(snd_button_hover, 6, false);
                exit;
            }
        }
    }

    // If player presses [E] on a standard non-clue PC, remind them to Right-Click with Wrench to scrap!
    if (prop_type == TILE_PROP_PC && !has_clue) {
        if (!is_scrapped) {
            scrap_pop_timer = 85;
            scrap_pop_text  = is_fried ? "RIGHT-CLICK [RMB] TO FIX (-1 SCRAP)" : "RIGHT-CLICK [RMB] TO WRENCH SCRAP!";
            audio_play_sound(snd_button_hover, 5, false);
        }
        exit;
    }
    // Entering a Security Hiding Locker
    if (prop_type == TILE_PROP_LOCKER) {
        global.player_in_locker = true;
        global.active_locker_id = id;
        obj_jack.x              = x + 8;
        obj_jack.y              = y + 12;
        obj_jack.visible        = false;
        audio_play_sound(snd_button_click, 5, false);
        exit;
    }

    // Interacting with the Red Lockdown Override Console (Stage 2)
    if (prop_type == TILE_PROP_OVERRIDE) {
        audio_play_sound(snd_select, 8, false);
        if (variable_global_exists("lockdown_overridden") && global.lockdown_overridden) {
            global.e_dialogue_intro_shown = true;
            create_textevent([
                "The Lockdown Override is already active—the red sirens and hallway security drones are shut down!",
                "Next: head to the Power Control Room and flip the Breaker Panel to restore floor power."
            ], [obj_jack.id, obj_jack.id]);
        } else if (!variable_global_exists("incident_solved") || !global.incident_solved) {
            audio_play_sound(wrong1, 8, false);
            global.e_dialogue_intro_shown = true;
            create_textevent([
                "EMERGENCY OVERRIDE LOCKED — INCIDENT REPORT REQUIRED!",
                "Facility safety protocols prevent overriding security grids until the breach is traced to its source.",
                "Gather evidence from the offices, narrow down the suspects on the Case Board [TAB], then accuse the culprit at their desk!"
            ], [obj_jack.id, obj_jack.id, obj_jack.id]);
        } else {
            keyboard_clear(ord("E"));
            global.override_input_cooldown = 4;
            global.override_ui_open        = true;
            global.override_timer_max      = scr_get_cipher_timer_frames("sever");
            global.override_timer          = global.override_timer_max;
        }
        exit;
    }

    // Interacting with the High-Voltage Power Breaker Panel (Stage 3)
    if (prop_type == TILE_PROP_BREAKER) {
        audio_play_sound(snd_select, 8, false);
        if (variable_global_exists("power_restored") && global.power_restored) {
            global.e_dialogue_intro_shown = true;
            create_textevent([
                "Floor power is restored! The office lights and Extraction Elevator are back online.",
                "Now I just need to make sure Lockdown Override is engaged and unlock the Extraction Elevator!"
            ], [obj_jack.id, obj_jack.id]);
        } else {
            global.breaker_ui_open = true;
        }
        exit;
    }

    audio_play_sound(snd_button_click, 5, false);
    global.e_dialogue_intro_shown = true;
    if (prop_type != TILE_PROP_NPC && prop_type != TILE_PROP_PC) {
        talked_once = true;
    }

    var _case = variable_global_exists("floor_case") ? global.floor_case : scr_get_floor_incident_case(0);

    // Helper: compute compass direction to the next active facility objective (Key Vault -> Override -> Breaker -> Elevator)
    var _radar_hint = "";
    var _has_key = (variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key);
    var _ov_done = (variable_global_exists("lockdown_overridden")    && global.lockdown_overridden);
    var _pw_done = (variable_global_exists("power_restored")         && global.power_restored);

    var _target_inst = noone;
    var _target_lbl  = "ELEVATOR";
    if (!_has_key && instance_exists(obj_caesar_key_pedestal)) {
        _target_inst = obj_caesar_key_pedestal;
        _target_lbl  = "KEY VAULT";
    } else if (_ov_done && !_pw_done && variable_global_exists("breaker_prop_inst") && instance_exists(global.breaker_prop_inst)) {
        _target_inst = global.breaker_prop_inst;
        _target_lbl  = "BREAKER ROOM";
    } else {
        _radar_hint = "NEXT: SEARCH ENCRYPTED DOORS";
    }

    if (_target_inst != noone) {
        var _dx = _target_inst.x - x;
        var _dy = _target_inst.y - y;
        var _vdir = (_dy < -40) ? "NORTH" : ((_dy > 40) ? "SOUTH" : "");
        var _hdir = (_dx < -40) ? "WEST"  : ((_dx > 40) ? "EAST"  : "");
        var _compass = (_vdir != "" && _hdir != "") ? (_vdir + "-" + _hdir) : (_vdir + _hdir);
        if (_compass == "") _compass = "NEARBY";
        _radar_hint = _target_lbl + ": " + _compass;
    }

    if (prop_type == TILE_PROP_PC) {
        audio_play_sound(snd_button_click, 5, false);
        keyboard_clear(ord("E"));
        global.pc_screen_open     = true;
        global.pc_input_cooldown  = 12;
        global.pc_screen_is_pz    = false;
        global.pc_screen_mode     = 0;
        global.pc_screen_target   = id;
        global.pc_screen_select   = 0;
        global.pc_screen_feedback = "";

        if (is_holding_clue) {
            talked_once = true;
            var _eq = variable_global_exists("holding_math_clue") ? global.holding_math_clue : "SHIFT KEY (X) = (3 * 3) - 6";
            global.pc_screen_title = "HOLDING CELL TERMINAL";
            global.pc_screen_body  = "Solve for the cell door's Shift Key (X):\n\n" + _eq;
            global.pc_screen_radar = "+X = Shift UP   |   -X = Shift DOWN";
            global.pc_screen_badge = "CELL DOOR KEY CLUE";
        } else if (is_vault_hint_pc) {
            // Dedicated Security Sector PC holding the Key Vault Cipher Hint (stays green once read!)
            talked_once = true;
            if (!variable_global_exists("clues_found")) global.clues_found = 0;
            if (global.clues_found < 1) {
                global.clues_found = 1;
                var _vping = audio_play_sound(snd_correct_ping, 6, false);
                audio_sound_gain(_vping, 0.45, 0);
            }
            var _plogs = _case.pc_logs;
            var _plog  = _plogs[log_variant mod array_length(_plogs)];
            if (variable_struct_exists(_case, "vault_challenge")) {
                _plog = _case.vault_challenge.scanner_note + "\n\nTHREAT CATEGORY:  " + _case.word + " (" + _case.title + ")";
            }
            if (variable_global_exists("dungeon_chapter") && global.dungeon_chapter == CHAPTER_VIGENERE
                && variable_global_exists("dungeon_vigenere_key")) {
                _plog += "\n[PHASE 1 CRYPTO INTEL] Intercepted Vigenere Keyword: '" + global.dungeon_vigenere_key + "'";
            }
            global.pc_screen_title = "SECURITY SECTOR TERMINAL";
            global.pc_screen_body  = _plog + "\n\n[FORENSIC SCANNER UPLOADED TO KEY VAULT]";
            global.pc_screen_radar = _radar_hint;
            global.pc_screen_badge = "KEY VAULT HINT";
        } else if (!_has_key) {
            // Phase 1 Lock: all non-hint terminals stay locked (and keep yellow indicator) until the Key Vault Cipher Key is obtained!
            audio_play_sound(wrong1, 6, false);
            global.pc_screen_title = "TERMINAL LOCKED — CIPHER KEY REQUIRED";
            global.pc_screen_body  = "WORKSTATION ENCRYPTED BY FLOOR LOCKDOWN.\n\nLocate the Security Sector Terminal for the vault hint, then unlock the Gold Key Vault and retrieve the Cipher Key first!";
            global.pc_screen_radar = _radar_hint;
            global.pc_screen_badge = "KEY REQUIRED";
        } else if (suspect_idx >= 0) {
            var _sp           = global.case_suspects[suspect_idx];
            var _already_done = (evidence_idx >= 0 && global.case_evidence[evidence_idx].found)
                             || (variable_struct_exists(_sp, "audit_done") && _sp.audit_done);

            if (!_already_done) {
                // Interactive 3-Item Workstation Audit (Mode 5): Player inspects the 3 desktop items & flags the breach (or verifies clean)!
                global.pc_screen_mode        = 5;
                global.pc_screen_suspect_idx = suspect_idx;
                global.pc_screen_select      = 0;
                global.pc_screen_feedback    = "";
                global.pc_screen_title       = "WORKSTATION AUDIT: DESK " + nameplate + "  [" + _sp.dept + "]";
                global.pc_screen_badge       = "AUDIT 3 ITEMS";
            } else {
                talked_once = true;
                var _s_txt = (evidence_idx >= 0)
                    ? global.case_evidence[evidence_idx].text
                    : ("[LVL 3: CRITICAL] Desk " + nameplate + " (" + _sp.name + ") workstation audit complete.");
                global.pc_screen_title = "SUSPECT DESK: " + nameplate + "  [" + _sp.dept + "]";
                global.pc_screen_body  = _s_txt + "\n\n(Workstation audit complete — recorded on Case Board.)\nPress [TAB] to open the Case Board and ACCUSE a suspect.";
                global.pc_screen_radar = "EVIDENCE " + string(global.evidence_found) + "/" + string(global.evidence_needed) + "   [TAB] ACCUSE ON BOARD";
                global.pc_screen_badge = "LVL 3: CRITICAL";
            }
        } else if (evidence_idx >= 0) {
            // Evidence terminal: Level 1 / Level 2 proof
            talked_once = true;
            var _ev_new = scr_log_evidence(evidence_idx);
            var _evd    = global.case_evidence[evidence_idx];
            if (_ev_new) {
                var _ep = audio_play_sound(snd_correct_ping, 6, false);
                audio_sound_gain(_ep, 0.45, 0);
            }
            var _t_lvl = variable_struct_exists(_evd, "tier") ? _evd.tier : 2;
            global.pc_screen_title = "FORENSIC TERMINAL  [LEVEL " + string(_t_lvl) + "]";
            global.pc_screen_body  = _evd.text + "\n\n" + (_ev_new ? "NEW EVIDENCE ADDED TO CASE BOARD." : "(Already on the Case Board.)") + "\nOpen the Case Board with [TAB].";
            global.pc_screen_radar = "EVIDENCE " + string(global.evidence_found) + "/" + string(global.evidence_needed) + "   [TAB] CASE BOARD";
            global.pc_screen_badge = "LVL " + string(_t_lvl) + " CLUE";
        } else {
            // Ordinary coworker workstation (flavor only)
            talked_once = true;
            var _flav = [
                "Q3 sales slides, a half-written email, and a coffee order.\n\nNothing about the breach here.",
                "A spreadsheet of office snack votes.\n\nNothing about the breach here.",
                "Unread newsletters and a sticky note: 'change password someday'.\n\nNothing about the breach here."
            ];
            global.pc_screen_title = "WORKSTATION: Corporate Terminal";
            global.pc_screen_body  = _flav[log_variant mod 3];
            global.pc_screen_radar = _radar_hint;
            global.pc_screen_badge = "NO EVIDENCE";
        }
        exit;
    }
    else if (prop_type == TILE_PROP_PAPER) {
        if (is_holding_clue) {
            var _eq = variable_global_exists("holding_math_clue") ? global.holding_math_clue : "SHIFT KEY (X) = (3 * 3) - 6";
            create_textevent([
                "[SCRATCHPAD NOTE]: 'The brig door has its own Shift Key (X)! Solve this equation to escape:'",
                _eq + "   (Positive X = Shift UP, Negative X = Shift DOWN!)"
            ], [obj_jack.id, obj_jack.id]);
        } else if (evidence_idx >= 0) {
            var _pe_new = scr_log_evidence(evidence_idx);
            if (_pe_new) {
                var _pep = audio_play_sound(snd_correct_ping, 6, false);
                audio_sound_gain(_pep, 0.45, 0);
            }
            create_textevent([
                (_pe_new ? "[EVIDENCE LOGGED] " : "[ALREADY ON CASE BOARD] ") + global.case_evidence[evidence_idx].text,
                "Noted. [TAB] opens the Case Board (" + string(global.evidence_found) + "/" + string(global.evidence_needed) + " pieces)."
            ], [obj_jack.id, obj_jack.id]);
        } else {
            var _memo_flav = [
                "[OFFICE MEMO]: 'Please stop leaving half-empty mugs in the conference room sink.'",
                "[STICKY NOTE]: 'Remember to check suspect workstations and interview coworkers for breach clues!'"
            ];
            create_textevent([
                _memo_flav[log_variant mod 2]
            ], [obj_jack.id]);
        }
    }
    else if (prop_type == TILE_PROP_NPC) {
        keyboard_clear(ord("E"));
        var _mentor      = variable_global_exists("floor_mentor_inst") ? global.floor_mentor_inst : noone;
        var _is_mentor   = (id == _mentor);
        var _case_solved = (variable_global_exists("incident_solved") && global.incident_solved);
        var _greet       = "";
        var _ask_opt     = "";
        var _npc_ans     = "";
        var _jack_ack    = "";

        // =================================================================
        // PHASE 1: Finding the Security Sector PC Hint & Unlocking Key Vault
        // =================================================================
        if (!_has_key) {
            if (_is_mentor) {
                _greet    = "Jack! Every workstation on this floor is locked down until you retrieve the Cipher Key from the Gold Key Vault.";
                _ask_opt  = "Ask where to find the Key Vault hint...";
                _npc_ans  = "The Key Vault password hint is stored on the dedicated Security Sector Terminal in one of the open offices. Find that PC first, then unlock the Gold Key Vault! (" + _radar_hint + ")";
                _jack_ack = "Got it—I'll find the Security Sector Terminal and unlock the Key Vault first!";
            } else {
                var _p1_greets = [
                    "Hey Jack! My terminal is completely locked out—it's asking for the floor's Cipher Key!",
                    "Jack! None of the office PCs will let us log in while the Gold Key Vault is still sealed.",
                    "Thank goodness you're here! We're trying to figure out the password for the Key Vault door."
                ];
                var _p1_ans = [
                    "All the regular workstations are locked until you get the Cipher Key from the Key Vault! Look for the Security Sector Terminal in the offices—it has the hint for the Key Vault door. (" + _radar_hint + ")",
                    "I heard the Security Sector PC is the only terminal still unlocked right now. Check it to get the Key Vault hint, then come talk to us once you have the Cipher Key!",
                    "Once you unlock the Key Vault using the hint on the Security Sector PC, the workstation locks will lift and we can help you investigate who caused the breach!"
                ];
                _greet    = _p1_greets[npc_id mod 3];
                _ask_opt  = "Ask about the Key Vault hint...";
                _npc_ans  = _p1_ans[npc_id mod 3];
                if (variable_global_exists("dungeon_chapter") && global.dungeon_chapter == CHAPTER_VIGENERE
                    && variable_global_exists("chapter_floor") && global.chapter_floor >= 7
                    && variable_global_exists("dungeon_vigenere_key")) {
                    _npc_ans += " (P.S. Before my terminal locked, I saw the Vigenere Keyword: '" + global.dungeon_vigenere_key + "'!)";
                }
                _jack_ack = "Thanks—I'll track down the Security Sector PC and get the Key Vault open first.";
            }
        }
        // =================================================================
        // PHASE 2: Whodunit Investigation (Have Key, Case Not Yet Solved)
        // =================================================================
        else if (!_case_solved) {
            if (_is_mentor) {
                _greet    = "Nice work getting the Cipher Key, Jack! Now we need to find out who triggered this breach.";
                _ask_opt  = "Ask about the investigation...";
                _npc_ans  = "With the Cipher Key in hand, the office terminals are unlocked! Interview the coworkers, inspect the Suspect Desk Terminals for Level 3 Critical Evidence, and accuse the culprit on your Case Board [TAB].";
                _jack_ack = "On it—I'll gather the evidence and make my accusation on the Case Board [TAB]!";
            } else if (evidence_idx >= 0) {
                var _ev_item = global.case_evidence[evidence_idx];
                var _ev_tier = variable_struct_exists(_ev_item, "tier") ? _ev_item.tier : 2;
                _greet = (_ev_tier == 1)
                    ? "Hey Jack... now that you have the Cipher Key, let me tell you what I noticed before the lockdown."
                    : "Jack! You're investigating the breach, right? I have key witness information about one of the suspects.";
                _ask_opt  = (_ev_tier == 1) ? "Ask if they noticed anything..." : "Ask for their witness testimony...";
                _npc_ans  = variable_struct_exists(_ev_item, "npc_speech") ? _ev_item.npc_speech : _ev_item.text;
                _jack_ack = "Thanks—I'll add that to the Case Board [TAB].";
            } else {
                var _unaware_greets = [
                    "Oh, hey Jack! You got the Cipher Key? I'm still trying to make sense of this whole investigation.",
                    "Hi Jack... everyone's whispering about who caused the security breach on this floor.",
                    "Hey! Are you interviewing people for the breach investigation?"
                ];
                var _unaware_ans = [
                    "Honestly, I had my headphones on the whole time. I didn't see what happened—maybe check the suspect desks?",
                    "I've been stuck in here sorting invoices since morning. Try asking some of the other coworkers or checking [TAB] once you have more clues!",
                    "I really don't know anything about the hack! All I know is the suspect desks have nameplates on them—try inspecting their PCs."
                ];
                _greet    = _unaware_greets[npc_id mod 3];
                _ask_opt  = "Ask about the investigation...";
                _npc_ans  = _unaware_ans[npc_id mod 3];
                _jack_ack = "No worries—I'll check with the other coworkers and inspect the suspect terminals.";
            }
        }
        // =================================================================
        // PHASE 3: Case Solved -> Override Console & Breaker Room Repair
        // =================================================================
        else if (!_pw_done && !_lifted) {
            if (_is_mentor) {
                _greet    = "You nailed the culprit, Jack! The incident report is verified, so we can finally restore the floor.";
                _ask_opt  = "Ask about restoring the floor...";
                _npc_ans  = !_ov_done
                    ? ("First, head into the encrypted Security Control Room and activate the Red Lockdown Override Console to disarm the patrol bots and unseal the Breaker Room! (" + _radar_hint + ")")
                    : ("The Lockdown Override is active! Now head to the Electrical Breaker Room and calibrate the 3 fuses on the Power Breaker Panel to bring the floor's power back online! (" + _radar_hint + ")");
                _jack_ack = !_ov_done
                    ? "Got it—heading to the Lockdown Override Console first, then the Breaker Room!"
                    : "Heading straight to the Breaker Room to restore floor power!";
            } else {
                var _p3_greets = [
                    "Jack! Word just spread that you solved the case and identified Patient Zero!",
                    "Hey Jack! The emergency lights are still flickering—are we close to getting the power back?",
                    "Awesome detective work, Jack! Now we just need the building systems restored so we can evacuate."
                ];
                var _p3_ans = !_ov_done
                    ? "Since you solved the case, the Lockdown Override Console is unlocked! Hit the Override first so the Electrical Breaker Room unseals, then fix the breaker! (" + _radar_hint + ")"
                    : "The security bots just powered down! All that's left is flipping the fuses on the Power Breaker Panel in the Breaker Room so the lights and elevator come back on! (" + _radar_hint + ")";
                _greet    = _p3_greets[npc_id mod 3];
                _ask_opt  = "Ask about the Breaker Room...";
                _npc_ans  = _p3_ans;
                _jack_ack = "Almost there—I'll get the Breaker Room online right away!";
            }
        }
        // =================================================================
        // PHASE 4: Power Restored -> Head to the Extraction Elevator!
        // =================================================================
        else {
            talked_once = true;
            if (_is_mentor) {
                _greet    = "Floor power is 100% restored and the lockdown is lifted! Outstanding work today, Jack.";
                _ask_opt  = "Ask about extraction...";
                _npc_ans  = _case.kyle_debrief + " The Extraction Elevator is powered up—unlock its door and head on up! (" + _radar_hint + ")";
                _jack_ack = "All clear—heading to the Extraction Elevator now!";
            } else {
                var _p4_greets = [
                    "The office lights and A/C are finally back on! You saved the whole floor, Jack!",
                    "Hey Jack! The red lockdown alarms stopped and power is completely restored!",
                    "We're free! The elevator grid just came back online!"
                ];
                var _p4_ans = [
                    "You solved the " + _case.word + " case and fixed the breaker! The Extraction Elevator is waiting for you—go on and head out! (" + _radar_hint + ")",
                    "Power is back across the entire sector! " + _case.takeaway + " Head to the Extraction Elevator whenever you're ready!",
                    "All security locks on the Extraction Elevator are ready for you. I owe you a coffee once we're out of here!"
                ];
                _greet    = _p4_greets[npc_id mod 3];
                _ask_opt  = "Ask about leaving the floor...";
                _npc_ans  = _p4_ans[npc_id mod 3];
                _jack_ack = "Glad everyone's safe—I'm heading to the Extraction Elevator now!";
            }
        }

        // 7-Page Branching Dialogue across all 4 phases:
        // 0: ["Say Hello"] -> 1: NPC Greeting -> 2: ["Ask about...", "Leave"] -> 3: NPC Info -> 4: Jack Note -> 5: ["Leave"] -> 6: "Goodbye!"
        var _texts = [
            ["Say Hello"],
            _greet,
            [_ask_opt, "Leave"],
            _npc_ans,
            _jack_ack,
            ["Leave"],
            "Goodbye! Stay safe in here."
        ];
        var _speakers  = [obj_jack.id, id, obj_jack.id, id, obj_jack.id, obj_jack.id, obj_jack.id];
        var _effects   = [0, 0, 0, 0, 0, 0, 0];
        var _speeds    = [0, 0, 0, 0, 0, 0, 0];
        var _types     = [1, 0, 1, 0, 0, 1, 0];
        var _nextlines = [[1], 2, [3, 6], 4, 5, [6], -1];
        var _scripts   = [-1, -1, [[scr_npc_commit_clue, id], -1], -1, -1, -1, -1];

        create_dialogue(_texts, _speakers, _effects, _speeds, _types, _nextlines, _scripts);
    }
    else if (prop_type == TILE_PROP_DRONE && _lifted) {
        create_textevent([
            "Unlocking the elevator door rebooted this rogue drone into sleep mode.",
            "Sweet dreams, little toaster!"
        ], [obj_jack.id, obj_jack.id]);
    }
}
