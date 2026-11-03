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
if (instance_exists(obj_textevent)
    || (variable_global_exists("pc_screen_open") && global.pc_screen_open)
    || instance_exists(obj_cipher)
    || instance_exists(obj_dungeon_quiz)
    || instance_exists(obj_dungeon_victory))
{
    player_near = false;
    exit;
}

var _lifted = (variable_global_exists("lockdown_lifted") && global.lockdown_lifted);

// ---------------------------------------------------------------------------
// 1. Stranded Coworker NPC Animation & Facing
// ---------------------------------------------------------------------------
if (prop_type == TILE_PROP_NPC) {
    depth = -(y + 12);
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
// 2. Roaming Rogue Security Drone — Patrols Exact Centerline of Hallway Spine
// ---------------------------------------------------------------------------
if (prop_type == TILE_PROP_DRONE) {
    depth = -(y + 10);
    hover_t += 0.08;
    if (zap_cd > 0) zap_cd--;

    if (!_lifted) {
        if (instance_exists(obj_dungeon_generator) && variable_instance_exists(obj_dungeon_generator, "hallway_waypoints")) {
            var _wps = obj_dungeon_generator.hallway_waypoints;
            var _n_wp = array_length(_wps);
            if (_n_wp >= 2) {
                wp_index = clamp(wp_index, 0, _n_wp - 1);
                var _tx = _wps[wp_index][0];
                var _ty = _wps[wp_index][1];
                var _dist_wp = point_distance(x, y, _tx, _ty);
                var _spd = 0.95;

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

        // Raycast Flashlight Vision Check (Wraps around corners & stops at walls!)
        var _in_locker = (variable_global_exists("player_in_locker") && global.player_in_locker);
        if (!_in_locker && zap_cd <= 0 && instance_exists(obj_jack) && instance_exists(obj_dungeon_generator)) {
            var _cx = x + 8;
            var _cy = y + 8;
            var _jx = obj_jack.x;
            var _jy = obj_jack.y - 6;

            var _dist_to_jack = point_distance(_cx, _cy, _jx, _jy);
            if (_dist_to_jack <= 92 && obj_jack.bump_timer <= 0) {
                var _base_dir  = point_direction(0, 0, patrol_vx, patrol_vy);
                var _scan_dir  = _base_dir + sin(hover_t * 0.90) * 18;
                var _ang_diff  = abs(angle_difference(point_direction(_cx, _cy, _jx, _jy), _scan_dir));

                // Caught if inside the 64-degree (±32°) flashlight beam (or touching the drone)
                // AND there is no wall blocking line-of-sight!
                if (_ang_diff <= 32 || _dist_to_jack < 11) {
                    var _wall_hit = collision_line(_cx, _cy, _jx, _jy, obj_dungeon_wall, false, true);
                    if (_wall_hit == noone) {
                        zap_cd = 60;

                        // 1. Play capture alarm & screen shake (NO damage to Jack!)
                        global.cam_shake_timer = 14;
                        global.cam_shake_mag   = 5;
                        audio_play_sound(snd_error, 10, false);
                        audio_play_sound(snd_select, 9, false);

                        // 2. Send Jack to the locked Security Holding Room (Brig)
                        if (variable_global_exists("holding_room_x") && global.holding_room_x > 0) {
                            obj_jack.x            = global.holding_room_x;
                            obj_jack.y            = global.holding_room_y;
                            obj_jack.sprite_index = spr_jack_idle;
                            obj_jack.bump_timer   = 0;
                            obj_dungeon_generator.active_col = global.holding_room_col;
                            obj_dungeon_generator.active_row = global.holding_room_row;
                            obj_dungeon_generator.room_discovered[global.holding_room_col][global.holding_room_row] = 2;
                        }

                        // 3. Rotate the Caesar Shift Key to a new value & reset Key possession
                        var _old_key = variable_global_exists("dungeon_cipher_key") ? global.dungeon_cipher_key : 1;
                        var _new_key = scr_roll_cipher_key();
                        var _guard   = 0;
                        while (_new_key == _old_key && _guard < 20) {
                            _new_key = scr_roll_cipher_key();
                            _guard++;
                        }
                        global.dungeon_cipher_key     = _new_key;
                        global.has_dungeon_cipher_key = false;
                        scr_roll_holding_key_and_equation();

                        with (obj_caesar_key_pedestal) {
                            collected = false;
                        }

                        // 4. Re-lock ALL Quiz and Caesar doors across the floor
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

                        // 5. Notify the player in the Holding Cell
                        global.e_dialogue_intro_shown = true;
                        create_textevent([
                            "BUSTED! The security drone caught me in its flashlight beam and locked me inside the Security Holding Cell! Worse—the lockdown protocol re-locked all the doors and changed the floor's Caesar Key! I need to look around this cell [E] for a Math Equation clue to figure out the cell door's Shift Key!"
                        ], [obj_jack.id]);
                        exit;
                    }
                }
            }
        }
    }
}

// ---------------------------------------------------------------------------
// 3. Check Proximity & [E] Interaction for Inspectable Props & Hiding Lockers
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

// ONLY Clue Computers (has_clue == true), Papers, NPCs, Lockers, or Powered-Down Drones can be interacted with!
var _can_inspect = (prop_type == TILE_PROP_PC && has_clue)
                || (prop_type == TILE_PROP_PAPER)
                || (prop_type == TILE_PROP_NPC)
                || (prop_type == TILE_PROP_LOCKER)
                || (prop_type == TILE_PROP_DRONE && _lifted);

if (!_can_inspect) exit;

var _dist = point_distance(x + 8, y + 8, obj_jack.x, obj_jack.y - 6);
if (_dist < 22) {
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

if (player_near && keyboard_check_pressed(ord("E"))) {
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

    // Helper: compute compass direction to the Key Pedestal or Elevator Goal
    var _radar_hint = "";
    var _has_key = (variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key);
    if (!_has_key && instance_exists(obj_caesar_key_pedestal)) {
        var _dx = obj_caesar_key_pedestal.x - x;
        var _dy = obj_caesar_key_pedestal.y - y;
        var _vdir = (_dy < -40) ? "NORTH" : ((_dy > 40) ? "SOUTH" : "");
        var _hdir = (_dx < -40) ? "WEST"  : ((_dx > 40) ? "EAST"  : "");
        var _compass = (_vdir != "" && _hdir != "") ? (_vdir + "-" + _hdir) : (_vdir + _hdir);
        if (_compass == "") _compass = "NEARBY";
        _radar_hint = "RADAR SCAN: Gold Key Vault is " + _compass + " of this terminal.";
    } else if (instance_exists(obj_dungeon_goal)) {
        var _dx = obj_dungeon_goal.x - x;
        var _dy = obj_dungeon_goal.y - y;
        var _vdir = (_dy < -40) ? "NORTH" : ((_dy > 40) ? "SOUTH" : "");
        var _hdir = (_dx < -40) ? "WEST"  : ((_dx > 40) ? "EAST"  : "");
        var _compass = (_vdir != "" && _hdir != "") ? (_vdir + "-" + _hdir) : (_vdir + _hdir);
        if (_compass == "") _compass = "NEARBY";
        _radar_hint = "RADAR SCAN: Extraction Elevator is " + _compass + " of this terminal.";
    }

    if (prop_type == TILE_PROP_PC && has_clue) {
        // Open the dedicated Computer Monitor Screen UI (with greyed-out background) instead of a dialogue box!
        if (is_holding_clue) {
            var _eq = variable_global_exists("holding_math_clue") ? global.holding_math_clue : "SHIFT KEY (X) = (3 * 3) - 6";
            global.pc_screen_open  = true;
            global.pc_screen_title = "SKIPJACK_OS // HOLDING CELL OVERRIDE TERMINAL";
            global.pc_screen_body  = "[BRIG DOOR ENCRYPTION PUZZLE]\nThe Holding Cell door uses a separate Caesar Shift Key (X).\nSolve the equation below to find X, then shift each door letter by X:\n\n    " + _eq;
            global.pc_screen_radar = "TIP: Positive X = Shift UP/Forward   |   Negative X = Shift DOWN/Backward";
            global.pc_screen_badge = "HOLDING CELL ESCAPE EQUATION";
        } else {
            var _logs = _case.pc_logs;
            var _log_line = _logs[log_variant mod array_length(_logs)];

            global.pc_screen_open  = true;
            global.pc_screen_title = "SKIPJACK_OS // FORENSIC TERMINAL #" + string(log_variant + 1);
            global.pc_screen_body  = _lifted
                ? ("[WORKSTATION RESTORED]\nThreat '" + _case.word + "' neutralized.\n\n" + _case.takeaway)
                : _log_line;
            global.pc_screen_radar = _radar_hint;
            global.pc_screen_badge = _is_new_clue
                ? ("+1 CASE CLUE RECORDED (" + string(global.clues_found) + "/" + string(global.clues_needed) + ")")
                : ("CASE CLUE LOGGED (" + string(global.clues_found) + "/" + string(global.clues_needed) + ")");
        }
    }
    else if (prop_type == TILE_PROP_PAPER) {
        if (is_holding_clue) {
            var _eq = variable_global_exists("holding_math_clue") ? global.holding_math_clue : "SHIFT KEY (X) = (3 * 3) - 6";
            create_textevent([
                "[SCRATCHPAD NOTE ON CELL FLOOR]: 'The brig door has its own Caesar Shift Key (X)! Solve this equation to get out:   " + _eq + "   (Positive = Shift UP, Negative = Shift DOWN!)'"
            ], [obj_jack.id]);
        } else {
            var _notes = _case.memo_notes;
            var _memo  = _clue_prefix + _notes[log_variant mod array_length(_notes)];
            create_textevent([_memo], [obj_jack.id]);
        }
    }
    else if (prop_type == TILE_PROP_NPC) {
        var _line = "";
        if (_lifted) {
            switch (npc_id) {
                case 0: _line = "Whoa, the red lockdown alarms just shut off! You stopped the " + _case.word + " breach and unlocked the elevator! You're a legend, Jack!"; break;
                case 1: _line = "The monitors stopped flashing red! " + _case.takeaway; break;
                case 2: _line = "All security grid locks on the elevator are green! Hurry into the Extraction Elevator so we can clear the next floor!"; break;
                case 3: _line = "Network traffic is back to normal! That Caesar cipher stood no chance against you, Jack."; break;
                default: _line = "Power is restored across the whole floor! I owe you a coffee once we get out of this building."; break;
            }
        } else {
            var _nclues = _case.npc_clues;
            _line = _clue_prefix + _nclues[npc_id mod array_length(_nclues)] + " (" + _radar_hint + ")";
        }
        create_textevent([_line], [id]);
    }
    else if (prop_type == TILE_PROP_DRONE && _lifted) {
        create_textevent(["Looks like unlocking the elevator door rebooted this rogue security drone into sleep mode. Sweet dreams, little toaster!"], [obj_jack.id]);
    }
}
