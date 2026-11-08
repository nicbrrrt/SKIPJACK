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
    depth = 22; // Beneath room fog overlay (depth 10) so NPCs in adjacent rooms stay hidden
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

    // --- Active Spam [E] Apprehend Struggle Minigame ---
    if (grapple_active) {
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

    if (!is_scrapped && !_lifted) {
        var _trigger_bot_capture = (grapple_meter <= 0.0 && zap_cd == 60);
        if (_trigger_bot_capture) {
            grapple_meter = 0.45;
        }

        if (!_trigger_bot_capture && instance_exists(obj_dungeon_generator) && variable_instance_exists(obj_dungeon_generator, "hallway_waypoints")) {
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

        // Raycast Flashlight Vision Check & Rear Stealth Ambush Check
        var _in_locker = (variable_global_exists("player_in_locker") && global.player_in_locker);
        if (!_in_locker && instance_exists(obj_jack) && instance_exists(obj_dungeon_generator)) {
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

            if (!_trigger_bot_capture && zap_cd <= 0 && _dist_to_jack <= _vis_range && obj_jack.bump_timer <= 0) {
                // Caught if inside the 64-degree (±32°) front flashlight beam (or bumping into its front arc)
                // AND there is no wall blocking line-of-sight!
                if (_ang_diff <= _vis_half || (_dist_to_jack < 10 && _ang_diff <= 45)) {
                    var _wall_hit = collision_line(_cx, _cy, _jx, _jy, obj_dungeon_wall, false, true);
                    if (_wall_hit == noone) {
                        _trigger_bot_capture = true;
                    }
                }
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

    // Safety net: if scrapping an unread Clue Terminal, auto-log its clue first so you never soft-lock the Key Vault!
    if (prop_type == TILE_PROP_PC && has_clue && !talked_once && !_lifted) {
        talked_once = true;
        if (!variable_global_exists("clues_found")) global.clues_found = 0;
        global.clues_found++;
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
        } else {
            global.override_ui_open   = true;
            global.override_timer_max = scr_get_cipher_timer_frames("sever");
            global.override_timer     = global.override_timer_max;
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

    var _is_new_clue = !talked_once && !_lifted && ((prop_type == TILE_PROP_PC && has_clue) || prop_type == TILE_PROP_PAPER || prop_type == TILE_PROP_NPC);
    talked_once = true;
    audio_play_sound(snd_button_click, 5, false);
    global.e_dialogue_intro_shown = true;

    var _clue_prefix = "";
    if (_is_new_clue) {
        if (!variable_global_exists("clues_found")) global.clues_found = 0;
        global.clues_found++;
        var _ping = audio_play_sound(snd_correct_ping, 6, false);
        audio_sound_gain(_ping, 0.45, 0);
        _clue_prefix = "[CLUE #" + string(global.clues_found) + " DISCOVERED] ";
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

    if (prop_type == TILE_PROP_PC && has_clue) {
        // Open the dedicated Computer Monitor Screen UI (with greyed-out background) instead of a dialogue box!
        if (is_holding_clue) {
            var _eq = variable_global_exists("holding_math_clue") ? global.holding_math_clue : "SHIFT KEY (X) = (3 * 3) - 6";
            global.pc_screen_open  = true;
            global.pc_screen_title = "HOLDING CELL TERMINAL";
            global.pc_screen_body  = "Solve for the cell door's Shift Key (X):\n\n" + _eq;
            global.pc_screen_radar = "+X = Shift UP   |   -X = Shift DOWN";
            global.pc_screen_badge = "CELL DOOR KEY CLUE";
        } else {
            var _logs = _case.pc_logs;
            var _log_line = _logs[log_variant mod array_length(_logs)];

            global.pc_screen_open  = true;
            global.pc_screen_title = "TERMINAL #" + string(log_variant + 1);
            global.pc_screen_body  = _lifted
                ? ("THREAT CLEARED: " + _case.word + "\n\n" + _case.takeaway)
                : _log_line;
            global.pc_screen_radar = _radar_hint;
            global.pc_screen_badge = "CLUES FOUND: " + string(global.clues_found) + " / " + string(global.clues_needed);
        }
    }
    else if (prop_type == TILE_PROP_PAPER) {
        if (is_holding_clue) {
            var _eq = variable_global_exists("holding_math_clue") ? global.holding_math_clue : "SHIFT KEY (X) = (3 * 3) - 6";
            create_textevent([
                "[SCRATCHPAD NOTE]: 'The brig door has its own Shift Key (X)! Solve this equation to escape:'",
                _eq + "   (Positive X = Shift UP, Negative X = Shift DOWN!)"
            ], [obj_jack.id, obj_jack.id]);
        } else {
            var _notes = _case.memo_notes;
            var _memo  = _notes[log_variant mod array_length(_notes)];
            create_textevent([
                _clue_prefix + _memo,
                "I'll keep '" + _case.word + "' in mind for the Gold Key Vault lock."
            ], [obj_jack.id, obj_jack.id]);
        }
    }
    else if (prop_type == TILE_PROP_NPC) {
        if (_lifted) {
            var _l1 = "";
            switch (npc_id) {
                case 0: _l1 = "The red lockdown alarms just shut off! You stopped the " + _case.word + " breach!"; break;
                case 1: _l1 = "The monitors stopped flashing red! " + _case.takeaway; break;
                case 2: _l1 = "All security grid locks on the elevator are green! Head to the Extraction Elevator!"; break;
                case 3: _l1 = "Network traffic is back to normal! That Caesar cipher stood no chance against you."; break;
                default: _l1 = "Power is restored across the floor! I owe you a coffee once we get out of here."; break;
            }
            create_textevent([
                _l1,
                "All clear—let's get to the Extraction Elevator and secure the building."
            ], [id, obj_jack.id]);
        } else {
            var _nclues = _case.npc_clues;
            var _npc_open  = _nclues[npc_id mod array_length(_nclues)];
            var _jack_line = variable_struct_exists(_case, "jack_reply") ? _case.jack_reply : ("So the security keyword for this floor is " + _case.word + "!");
            var _npc_close = _clue_prefix + "Use '" + _case.word + "' at the Key Vault! (" + _radar_hint + ")";
            create_textevent([
                _npc_open,
                _jack_line,
                _npc_close
            ], [id, obj_jack.id, id]);
        }
    }
    else if (prop_type == TILE_PROP_DRONE && _lifted) {
        create_textevent([
            "Unlocking the elevator door rebooted this rogue drone into sleep mode.",
            "Sweet dreams, little toaster!"
        ], [obj_jack.id, obj_jack.id]);
    }
}
