/// @description obj_intern ?" Step Event
near_player = false;

var _jx = instance_exists(obj_jack) ? obj_jack.x : 0;
var _jy = instance_exists(obj_jack) ? (obj_jack.y - 6) : 0;

if (instance_exists(obj_jack) && state != INTERN_STATE_DEAD && state != INTERN_STATE_TRAPPED) {
    if (point_distance(x, y, _jx, _jy) < 26) {
        near_player = true;
    }
}

// -----------------------------------------------------------------
// GRAB & PLACE MECHANIC ([G] KEY)
// -----------------------------------------------------------------
if (keyboard_check_pressed(ord("G")) && instance_exists(obj_jack)) {
    if (state == INTERN_STATE_HELD && global.held_intern_inst == id) {
        // Place / Drop intern
        global.held_intern_inst = noone;
        x = obj_jack.x;
        y = obj_jack.y + 12;

        var _rm = scr_intern_get_room_at(x, y);
        if (_rm == ROOM_INTERN_WORK) {
            // Calm down and return to work!
            state        = INTERN_STATE_WORK;
            boredom      = 0;
            boredom_rate = random_range(0.015, 0.045);
            audio_play_sound(snd_button_click, 10, false);
        } else if (_rm == ROOM_INTERN_GREEN) {
            // Dropped in Wellness Green Room -> Soothing relaxation (4 seconds)!
            state        = INTERN_STATE_SOOTHED;
            soothe_timer = 240; // 4.0 seconds at 60 fps
            boredom      = 0;
            boredom_rate = random_range(0.015, 0.045);
            audio_play_sound(snd_correct_ping, 10, false);
            audio_play_sound(snd_voice1, 10, false);
        } else {
            state   = INTERN_STATE_BORED;
            audio_play_sound(snd_voice1, 10, false);
        }
    }
    else if (global.held_intern_inst == noone && near_player && state != INTERN_STATE_DEAD && state != INTERN_STATE_TRAPPED) {
        // Pick up intern!
        global.held_intern_inst = id;
        state = INTERN_STATE_HELD;
        mischief_target = noone;
        audio_play_sound(snd_select, 10, false);
    }
}

// Held by player: tracks Jack's overhead position
if (state == INTERN_STATE_HELD) {
    if (instance_exists(obj_jack)) {
        x = obj_jack.x;
        y = obj_jack.y - 18;
        depth = obj_jack.depth - 5;
    }
    exit;
}

// Dead state: no processing
if (state == INTERN_STATE_DEAD) {
    exit;
}

// Trapped inside locker: safely awaiting player struggle rescue
if (state == INTERN_STATE_TRAPPED) {
    exit;
}

// Calming trigger when entering the Green Room (only if agitated or targeting green room, NOT when exiting to work!)
if (scr_intern_get_room_at(x, y) == ROOM_INTERN_GREEN && state != INTERN_STATE_SOOTHED && state != INTERN_STATE_KNOCKED_OUT) {
    if (state == INTERN_STATE_MISCHIEF || state == INTERN_STATE_TANTRUM || (state == INTERN_STATE_BORED && target_room == ROOM_INTERN_GREEN)) {
        state        = INTERN_STATE_SOOTHED;
        soothe_timer = 240; // 4 seconds!
        boredom      = 0;
        boredom_rate = random_range(0.015, 0.045);
        audio_play_sound(snd_voice1, 10, false);
    }
}

// -------------------------------------------------------------
// AI STATE MACHINE
// -------------------------------------------------------------
// Waypoint coordinates:
var _wp_work    = [568, 440]; // col 15, row 12 doorway
var _wp_junc_s  = [648, 440]; // Hallway junction for Storage
var _wp_storage = [648, 360]; // col 20, row 7 doorway
var _wp_junc_g  = [792, 440]; // Hallway junction for Green Room
var _wp_green   = [792, 360]; // col 29, row 7 doorway
var _wp_glass   = [872, 440]; // col 34, row 12 doorway

switch (state) {
    case INTERN_STATE_WORK:
        // Sits at desk and types
        x = home_desk_x;
        y = home_desk_y;

        // Individualized, randomized boredom rate!
        boredom += boredom_rate;
        if (boredom >= 100) {
            state = INTERN_STATE_BORED;
            audio_play_sound(snd_voice1, 10, false);
        }
        break;

    case INTERN_STATE_BORED:
        // Equal opportunity room selection
        var _green_count = 0;
        with (obj_intern) {
            if (state != INTERN_STATE_DEAD && scr_intern_get_room_at(x, y) == ROOM_INTERN_GREEN) _green_count++;
        }

        var _roll = irandom(99);
        if (_green_count < 4 && _roll < 22) {
            // Green Room chill lounge (~22%)
            target_room = ROOM_INTERN_GREEN;
            target_x    = 320 + irandom_range(27 * 16, 32 * 16);
            target_y    = 240 + irandom_range(2 * 16, 5 * 16);
        } else if (_roll < 55) {
            // Storage Room hazards (~33%)
            target_room = ROOM_INTERN_STORAGE;
            target_x    = 320 + irandom_range(18 * 16, 23 * 16);
            target_y    = 240 + irandom_range(2 * 16, 5 * 16);
        } else if (_roll < 88) {
            // Observation Deck panoramic glass (~33%)
            target_room = ROOM_INTERN_GLASS;
            target_x    = 320 + irandom_range(35 * 16, 40 * 16);
            target_y    = 240 + irandom_range(10 * 16, 14 * 16);
        } else {
            // Work Room (~12%)
            target_room = ROOM_INTERN_WORK;
            target_x    = 320 + irandom_range(3 * 16, 12 * 16);
            target_y    = 240 + irandom_range(9 * 16, 15 * 16);
        }

        var _cur_rm = scr_intern_get_room_at(x, y);
        waypoints = [];

        if (_cur_rm == ROOM_INTERN_WORK) {
            if (target_room == ROOM_INTERN_STORAGE) {
                waypoints = [_wp_work, _wp_junc_s, _wp_storage, [target_x, target_y]];
            } else if (target_room == ROOM_INTERN_GREEN) {
                waypoints = [_wp_work, _wp_junc_g, _wp_green, [target_x, target_y]];
            } else if (target_room == ROOM_INTERN_GLASS) {
                waypoints = [_wp_work, _wp_glass, [target_x, target_y]];
            } else {
                waypoints = [[target_x, target_y]];
            }
        }
        else if (_cur_rm == ROOM_INTERN_STORAGE) {
            if (target_room == ROOM_INTERN_WORK) {
                waypoints = [_wp_storage, _wp_junc_s, _wp_work, [target_x, target_y]];
            } else if (target_room == ROOM_INTERN_GREEN) {
                waypoints = [_wp_storage, _wp_junc_s, _wp_junc_g, _wp_green, [target_x, target_y]];
            } else if (target_room == ROOM_INTERN_GLASS) {
                waypoints = [_wp_storage, _wp_junc_s, _wp_glass, [target_x, target_y]];
            } else {
                waypoints = [[target_x, target_y]];
            }
        }
        else if (_cur_rm == ROOM_INTERN_GREEN) {
            if (target_room == ROOM_INTERN_WORK) {
                waypoints = [_wp_green, _wp_junc_g, _wp_junc_s, _wp_work, [target_x, target_y]];
            } else if (target_room == ROOM_INTERN_STORAGE) {
                waypoints = [_wp_green, _wp_junc_g, _wp_junc_s, _wp_storage, [target_x, target_y]];
            } else if (target_room == ROOM_INTERN_GLASS) {
                waypoints = [_wp_green, _wp_junc_g, _wp_glass, [target_x, target_y]];
            } else {
                waypoints = [[target_x, target_y]];
            }
        }
        else if (_cur_rm == ROOM_INTERN_GLASS) {
            if (target_room == ROOM_INTERN_WORK) {
                waypoints = [_wp_glass, _wp_work, [target_x, target_y]];
            } else if (target_room == ROOM_INTERN_STORAGE) {
                waypoints = [_wp_glass, _wp_junc_s, _wp_storage, [target_x, target_y]];
            } else if (target_room == ROOM_INTERN_GREEN) {
                waypoints = [_wp_glass, _wp_junc_g, _wp_green, [target_x, target_y]];
            } else {
                waypoints = [[target_x, target_y]];
            }
        }
        else {
            // In hallway
            if (target_room == ROOM_INTERN_STORAGE)      waypoints = [_wp_junc_s, _wp_storage, [target_x, target_y]];
            else if (target_room == ROOM_INTERN_GREEN)   waypoints = [_wp_junc_g, _wp_green, [target_x, target_y]];
            else if (target_room == ROOM_INTERN_GLASS)   waypoints = [_wp_glass, [target_x, target_y]];
            else                                         waypoints = [_wp_work, [target_x, target_y]];
        }

        current_wp = 0;
        state = INTERN_STATE_SEEK_ROOM;
        break;

    case INTERN_STATE_SEEK_ROOM:
        // Follow waypoints cleanly through doorways
        walk_timer++;
        if (current_wp < array_length(waypoints)) {
            var _dest_x = waypoints[current_wp][0];
            var _dest_y = waypoints[current_wp][1];
            var _dir = point_direction(x, y, _dest_x, _dest_y);
            face_dir = _dir;

            var _vx = lengthdir_x(move_speed, _dir);
            var _vy = lengthdir_y(move_speed, _dir);

            var _nx = x + _vx;
            var _ny = y + _vy;

            // Foot-corner collision checks against solid walls
            var _hit_x = position_meeting(_nx - 4, y, obj_dungeon_wall) || position_meeting(_nx + 4, y, obj_dungeon_wall);
            var _hit_y = position_meeting(x, _ny - 3, obj_dungeon_wall) || position_meeting(x, _ny + 3, obj_dungeon_wall);

            if (!_hit_x) x += _vx;
            if (!_hit_y) y += _vy;

            if (point_distance(x, y, _dest_x, _dest_y) < 12) {
                current_wp++;
                if (current_wp >= array_length(waypoints)) {
                    if (target_room == ROOM_INTERN_WORK) {
                        state        = INTERN_STATE_WORK;
                        boredom      = 0;
                        boredom_rate = random_range(0.015, 0.045);
                    } else if (target_room == ROOM_INTERN_GREEN) {
                        state        = INTERN_STATE_SOOTHED;
                        soothe_timer = 240; // 4 seconds!
                        boredom      = 0;
                        boredom_rate = random_range(0.015, 0.045);
                        audio_play_sound(snd_voice1, 10, false);
                    } else {
                        state          = INTERN_STATE_MISCHIEF;
                        mischief_timer = 0;
                    }
                }
            }
        } else {
            if (target_room == ROOM_INTERN_WORK) {
                state        = INTERN_STATE_WORK;
                boredom      = 0;
                boredom_rate = random_range(0.015, 0.045);
            } else if (target_room == ROOM_INTERN_GREEN) {
                state        = INTERN_STATE_SOOTHED;
                soothe_timer = 240; // 4 seconds!
                boredom      = 0;
                boredom_rate = random_range(0.015, 0.045);
            } else {
                state          = INTERN_STATE_MISCHIEF;
                mischief_timer = 0;
            }
        }
        break;

    case INTERN_STATE_SOOTHED:
        // Relaxing in the Green Room for 4 seconds
        walk_timer++;
        soothe_timer--;
        boredom = 0;

        if (soothe_timer <= 0) {
            // Fully rested and calm after 4 seconds! Head straight back to work desk!
            audio_play_sound(snd_correct_ping, 10, false);
            target_room  = ROOM_INTERN_WORK;
            target_x     = home_desk_x;
            target_y     = home_desk_y;
            waypoints    = [_wp_green, _wp_junc_g, _wp_junc_s, _wp_work, [target_x, target_y]];
            current_wp   = 0;
            boredom_rate = random_range(0.015, 0.045); // Fresh randomized stamina!
            state        = INTERN_STATE_SEEK_ROOM;
        }
        break;

    case INTERN_STATE_MISCHIEF:
        mischief_timer++;
        var _cur_rm = scr_intern_get_room_at(x, y);

        // 1. Storage Room Mischief: Shake Shelf, Locker, or Water Cooler
        if (_cur_rm == ROOM_INTERN_STORAGE) {
            var _haz = instance_nearest(x, y, obj_intern_hazard);
            if (_haz != noone && point_distance(x, y, _haz.x + 8, _haz.y + 8) < 30) {
                if (!_haz.is_wobbling && !_haz.is_fallen && !_haz.is_trapped) {
                    _haz.is_wobbling     = true;
                    _haz.wobble_timer    = _haz.wobble_max;
                    _haz.mischief_intern = id;
                    mischief_target      = _haz;
                }
            }
        }
        // 2. Glass Room Mischief: Walk to panoramic glass to bang on it!
        else if (_cur_rm == ROOM_INTERN_GLASS) {
            var _gls = instance_nearest(x, y, obj_intern_glass);
            if (_gls != noone && point_distance(x, y, _gls.x + 8, _gls.y + 8) > 14) {
                var _gdir = point_direction(x, y, _gls.x + 8, _gls.y + 8);
                x += lengthdir_x(0.6, _gdir);
                y += lengthdir_y(0.6, _gdir);
            }
        }
        // 3. Work Room Mischief: Smash another PC
        else if (_cur_rm == ROOM_INTERN_WORK) {
            var _trm = instance_nearest(x, y, obj_intern_terminal);
            if (_trm != noone && point_distance(x, y, _trm.x + 8, _trm.y + 8) < 20) {
                if (!_trm.is_fried && mischief_timer > 180) {
                    _trm.is_fried = true;
                    audio_play_sound(snd_attack_impact, 10, false);
                    state = INTERN_STATE_BORED;
                }
            }
        }

        // Tantrum roll if mischief prolonged
        if (mischief_timer > 400) {
            state = choose(INTERN_STATE_BORED, INTERN_STATE_TANTRUM);
            mischief_timer = 0;
        }
        break;

    case INTERN_STATE_TANTRUM:
        walk_timer += 2;
        mischief_timer++;
        if (mischief_timer mod 60 == 0) {
            audio_play_sound(snd_voice2, 10, false);
        }
        if (mischief_timer > 240) {
            state = INTERN_STATE_BORED;
            mischief_timer = 0;
        }
        break;

    case INTERN_STATE_KNOCKED_OUT:
        // Unconscious from suffocation or falling shelf
        knockout_timer--;
        revive_meter = max(0, revive_meter - 0.007);

        // Fresh air revival: if in hallway, recovers slowly
        if (scr_intern_get_room_at(x, y) == ROOM_INTERN_HALL) {
            knockout_timer = min(1800, knockout_timer + 3);
        }

        // SINGLE-TARGET CPR: Only the closest knocked-out intern to Jack responds!
        var _closest_ko = noone;
        var _best_d = 9999;
        with (obj_intern) {
            if (state == INTERN_STATE_KNOCKED_OUT) {
                var _d = point_distance(x, y, _jx, _jy);
                if (_d < _best_d) {
                    _best_d = _d;
                    _closest_ko = id;
                }
            }
        }
        is_cpr_target = (_closest_ko == id);

        if (is_cpr_target && near_player && keyboard_check_pressed(ord("E"))) {
            revive_meter += 0.22;
            audio_play_sound(snd_button_hover, 10, false);
            if (revive_meter >= 1.0) {
                state          = INTERN_STATE_BORED;
                revive_meter   = 0;
                knockout_timer = 1800;
                audio_play_sound(snd_objective_complete, 10, false);
                audio_play_sound(snd_voice1, 10, false);
            }
        }

        // Suffocation fatality!
        if (knockout_timer <= 0) {
            state = INTERN_STATE_DEAD;
            global.interns_lost++;
            global.legal_fund = max(0, global.legal_fund - 150);
            audio_play_sound(snd_die, 10, false);
        }
        break;
}
