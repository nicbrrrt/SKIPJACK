/// @description obj_intern — Step Event
near_player = false;

if (grace_timer > 0) grace_timer--;
if (variable_instance_exists(id, "door_cooldown") && door_cooldown > 0) door_cooldown--;
if (variable_instance_exists(id, "vent_cooldown") && vent_cooldown > 0) vent_cooldown--;

// Held instance integrity failsafe: if recorded instance is gone or no longer held, clear lock
if (variable_global_exists("held_intern_inst") && global.held_intern_inst != noone) {
    if (!instance_exists(global.held_intern_inst) || global.held_intern_inst.state != INTERN_STATE_HELD) {
        global.held_intern_inst = noone;
    }
}

var _jx = instance_exists(obj_jack) ? obj_jack.x : 0;
var _jy = instance_exists(obj_jack) ? (obj_jack.y - 6) : 0;

if (instance_exists(obj_jack) && state != INTERN_STATE_DEAD && state != INTERN_STATE_TRAPPED && state != INTERN_STATE_SOOTHED && state != INTERN_STATE_VENT_STUCK) {
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
        global.held_intern_inst  = noone;
        global.intern_drop_frame = current_time; // Prevent any other intern picking up this frame!

        var _ox = 320;
        var _oy = 240;
        var _jack_tx = floor((obj_jack.x - _ox) / 16);
        var _jack_ty = floor((obj_jack.y - _oy) / 16);
        var _jack_rm = scr_intern_get_room_at(obj_jack.x, obj_jack.y);
        
        var _is_green_room = (_jack_rm == ROOM_INTERN_GREEN) || (_jack_tx >= 26 && _jack_tx <= 33 && _jack_ty >= 0 && _jack_ty <= 6);

        if (_is_green_room) {
            // Specific designated relaxation cushion spots in the Wellness Green Room
            var _spots = [
                [_ox + 28 * 16 + 8, _oy + 2 * 16 + 8], // Spot 0 (Top-Left)
                [_ox + 31 * 16 + 8, _oy + 2 * 16 + 8], // Spot 1 (Top-Right)
                [_ox + 28 * 16 + 8, _oy + 4 * 16 + 8], // Spot 2 (Bottom-Left)
                [_ox + 31 * 16 + 8, _oy + 4 * 16 + 8]  // Spot 3 (Bottom-Right)
            ];

            // Pick closest available relaxation spot
            var _best_spot = -1;
            var _min_dist  = 999999;

            for (var _s = 0; _s < 4; _s++) {
                var _sx = _spots[_s][0];
                var _sy = _spots[_s][1];
                var _occupied = false;
                with (obj_intern) {
                    if (id != other.id && state != INTERN_STATE_DEAD && point_distance(x, y, _sx, _sy) < 14) {
                        _occupied = true;
                        break;
                    }
                }
                if (!_occupied) {
                    var _d = point_distance(obj_jack.x, obj_jack.y, _sx, _sy);
                    if (_d < _min_dist) {
                        _min_dist = _d;
                        _best_spot = _s;
                    }
                }
            }

            if (_best_spot != -1) {
                x = _spots[_best_spot][0];
                y = _spots[_best_spot][1];
            } else {
                // All 4 spots occupied: place safely in center aisle
                x = _ox + 29.5 * 16;
                y = _oy + 3 * 16 + 8;
            }

            // Dropped in Wellness Green Room -> Soothing relaxation (15 seconds)!
            state        = INTERN_STATE_SOOTHED;
            soothe_timer = 900; // 15.0 seconds at 60 fps
            boredom      = 0;
            boredom_rate = random_range(0.045, 0.085);
            audio_play_sound(snd_correct_ping, 10, false);
            audio_play_sound(snd_voice1, 10, false);
        }
        else {
            // Safe drop in other rooms: test candidate positions to guarantee no wall clipping
            var _drop_x = obj_jack.x;
            var _drop_y = obj_jack.y;
            var _found_clearance = false;

            // Candidate positions around Jack: 4 cardinal directions and diagonals
            var _offsets = [
                [0, 12], [0, -12], [12, 0], [-12, 0],
                [8, 8], [-8, 8], [8, -8], [-8, -8]
            ];

            for (var _c = 0; _c < array_length(_offsets); _c++) {
                var _cx = obj_jack.x + _offsets[_c][0];
                var _cy = obj_jack.y + _offsets[_c][1];
                if (scr_intern_get_room_at(_cx, _cy) != ROOM_INTERN_NONE) {
                    if (collision_circle(_cx, _cy, 6, obj_dungeon_wall, false, true) == noone) {
                        _drop_x = _cx;
                        _drop_y = _cy;
                        _found_clearance = true;
                        break;
                    }
                }
            }

            // If no offset was clear, drop right at Jack's foot position
            if (!_found_clearance) {
                _drop_x = obj_jack.x;
                _drop_y = obj_jack.y;
            }

            x = _drop_x;
            y = _drop_y;

            // Failsafe safety push: if within 6px of ANY wall, push towards room center
            var _rm = scr_intern_get_room_at(x, y);
            var _safe_cx = 320 + 20 * 16 + 8; // Hallway center
            var _safe_cy = 240 + 12 * 16 + 8;
            if (_rm == ROOM_INTERN_WORK)    { _safe_cx = 320 + 8 * 16;  _safe_cy = 240 + 12 * 16; }
            if (_rm == ROOM_INTERN_STORAGE) { _safe_cx = 320 + 20 * 16; _safe_cy = 240 + 4 * 16; }
            if (_rm == ROOM_INTERN_GREEN)   { _safe_cx = 320 + 29.5 * 16; _safe_cy = 240 + 3 * 16 + 8; }
            if (_rm == ROOM_INTERN_GLASS)   { _safe_cx = 320 + 37.5 * 16; _safe_cy = 240 + 12 * 16; }

            for (var _p = 0; _p < 24; _p += 2) {
                if (collision_circle(x, y, 6, obj_dungeon_wall, false, true) == noone) break;
                var _pdir = point_direction(x, y, _safe_cx, _safe_cy);
                x += lengthdir_x(2, _pdir);
                y += lengthdir_y(2, _pdir);
            }

            if (_rm == ROOM_INTERN_WORK) {
                state         = INTERN_STATE_WORK;
                boredom       = 0;
                grace_timer   = 900;
                vent_cooldown = 1200;
                boredom_rate  = random_range(0.015, 0.045);
                audio_play_sound(snd_button_click, 10, false);
            } else {
                state = INTERN_STATE_BORED;
                scr_intern_send_to_work(id, 600);
            }
        }
    }
    else if (global.held_intern_inst == noone && (!variable_global_exists("intern_drop_frame") || global.intern_drop_frame != current_time) && near_player && state != INTERN_STATE_DEAD && state != INTERN_STATE_TRAPPED && state != INTERN_STATE_SOOTHED) {
        // Pick up intern!
        global.held_intern_inst = id;
        state = INTERN_STATE_HELD;
        
        // Detach immediately from any wobbling hazard
        if (mischief_target != noone && instance_exists(mischief_target)) {
            if (mischief_target.mischief_intern == id) {
                mischief_target.mischief_intern = noone;
            }
            mischief_target = noone;
        }
        with (obj_intern_hazard) {
            if (mischief_intern == other.id) {
                mischief_intern = noone;
            }
        }
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

// Stuck inside air vent: safely awaiting player pull rescue
if (state == INTERN_STATE_VENT_STUCK) {
    visible = false;
    exit;
}

// Wall collision failsafe: if ever overlapping a wall, gently push back into room
if (state != INTERN_STATE_HELD && state != INTERN_STATE_DEAD && state != INTERN_STATE_TRAPPED && state != INTERN_STATE_VENT_STUCK) {
    if (collision_circle(x, y, 4, obj_dungeon_wall, false, true) != noone) {
        var _rm = scr_intern_get_room_at(x, y);
        var _safe_cx = 320 + 20 * 16 + 8; // Hallway center
        var _safe_cy = 240 + 12 * 16 + 8;
        if (_rm == ROOM_INTERN_WORK)    { _safe_cx = 320 + 8 * 16;  _safe_cy = 240 + 12 * 16; }
        if (_rm == ROOM_INTERN_STORAGE) { _safe_cx = 320 + 20 * 16; _safe_cy = 240 + 4 * 16; }
        if (_rm == ROOM_INTERN_GREEN)   { _safe_cx = 320 + 29.5 * 16; _safe_cy = 240 + 3 * 16 + 8; }
        if (_rm == ROOM_INTERN_GLASS)   { _safe_cx = 320 + 37.5 * 16; _safe_cy = 240 + 12 * 16; }

        var _pdir = point_direction(x, y, _safe_cx, _safe_cy);
        x += lengthdir_x(2, _pdir);
        y += lengthdir_y(2, _pdir);
    }
}

// Calming trigger when entering the Green Room (only if agitated or placed by player, NOT when exiting to work!)
if (scr_intern_get_room_at(x, y) == ROOM_INTERN_GREEN && state != INTERN_STATE_SOOTHED && state != INTERN_STATE_KNOCKED_OUT && state != INTERN_STATE_SEEK_ROOM) {
    if (state == INTERN_STATE_MISCHIEF || state == INTERN_STATE_TANTRUM || state == INTERN_STATE_BORED) {
        state        = INTERN_STATE_SOOTHED;
        soothe_timer = 900; // 15 seconds!
        boredom      = 0;
        boredom_rate = random_range(0.045, 0.085);
        audio_play_sound(snd_voice1, 10, false);

        // Snap to nearest relaxation spot if close
        var _spots = [
            [320 + 28 * 16 + 8, 240 + 2 * 16 + 8],
            [320 + 31 * 16 + 8, 240 + 2 * 16 + 8],
            [320 + 28 * 16 + 8, 240 + 4 * 16 + 8],
            [320 + 31 * 16 + 8, 240 + 4 * 16 + 8]
        ];
        for (var _s = 0; _s < 4; _s++) {
            if (point_distance(x, y, _spots[_s][0], _spots[_s][1]) < 22) {
                x = _spots[_s][0];
                y = _spots[_s][1];
                break;
            }
        }
    }
}

// -------------------------------------------------------------
// AI STATE MACHINE
// -------------------------------------------------------------
// Doorway and corridor waypoint coordinates:
var _wp_work_in    = [544, 440]; // col 14, row 12 (Inside Work Room threshold)
var _wp_work       = [568, 440]; // col 15, row 12 (Work Room Door)
var _wp_work_hall  = [592, 440]; // col 17, row 12 (Hallway outside Work Room)

var _wp_junc_s     = [648, 440]; // col 20, row 12 (Hallway Storage junction)
var _wp_storage_cor= [648, 384]; // col 20, row 8  (Storage branch corridor)
var _wp_storage    = [648, 360]; // col 20, row 7  (Storage Room Door)
var _wp_storage_in = [648, 336]; // col 20, row 5  (Inside Storage Room threshold)

var _wp_junc_g     = [792, 440]; // col 29, row 12 (Hallway Green Room junction)
var _wp_green_cor  = [792, 384]; // col 29, row 8  (Green Room branch corridor)
var _wp_green      = [792, 360]; // col 29, row 7  (Green Room Door)
var _wp_green_in   = [792, 336]; // col 29, row 5  (Inside Green Room threshold)

var _wp_glass_hall = [848, 440]; // col 33, row 12 (Hallway outside Observation Deck)
var _wp_glass      = [872, 440]; // col 34, row 12 (Observation Deck Door)
var _wp_glass_in   = [896, 440]; // col 36, row 12 (Inside Observation Deck threshold)

switch (state) {
    case INTERN_STATE_WORK:
        // Sits at desk and types
        x = home_desk_x;
        y = home_desk_y;

        // Individualized, randomized boredom rate ONLY after grace timer expires!
        if (grace_timer <= 0) {
            boredom += boredom_rate;
            if (boredom >= 100) {
                state = INTERN_STATE_BORED;
                audio_play_sound(snd_voice1, 10, false);
            }
        } else {
            boredom = 0;
        }
        break;

    case INTERN_STATE_BORED:
        // If still under grace timer, return to desk and stay peaceful!
        if (grace_timer > 0) {
            scr_intern_send_to_work(id, grace_timer);
            break;
        }

        var _cur_rm = scr_intern_get_room_at(x, y);

        // 1. Check if intern wants to sneak into an air vent (~32% chance across ALL available vents in facility)
        vent_target = noone;
        if (vent_cooldown <= 0 && grace_timer <= 0 && irandom(99) < 32) {
            var _avail_vents = [];
            with (obj_intern_vent) {
                if (!is_clogged && cooldown <= 0 && stuck_intern == noone) {
                    array_push(_avail_vents, id);
                }
            }
            if (array_length(_avail_vents) > 0) {
                // Pick one (prefer vent in current room if available)
                var _chosen_vent = noone;
                for (var _vi = 0; _vi < array_length(_avail_vents); _vi++) {
                    if (_avail_vents[_vi].room_assigned == _cur_rm) {
                        _chosen_vent = _avail_vents[_vi];
                        break;
                    }
                }
                if (_chosen_vent == noone) {
                    _chosen_vent = _avail_vents[irandom(array_length(_avail_vents) - 1)];
                }

                vent_target = _chosen_vent;
                target_room = _chosen_vent.room_assigned;
                target_x    = _chosen_vent.x + 8;
                target_y    = (_chosen_vent.room_assigned == ROOM_INTERN_GLASS) ? (_chosen_vent.y - 10) : (_chosen_vent.y + 16);
            }
        }

        // 2. If not seeking a vent, pick standard mischievous destination:
        if (vent_target == noone) {
            var _roll = irandom(99);
            if (_roll < 45) {
                // Storage Room hazards (~45%)
                target_room = ROOM_INTERN_STORAGE;
                target_x    = 320 + irandom_range(18 * 16, 23 * 16);
                target_y    = 240 + irandom_range(2 * 16, 5 * 16);
            } else if (_roll < 90) {
                // Observation Deck panoramic glass (~45%)
                target_room = ROOM_INTERN_GLASS;
                target_x    = 320 + irandom_range(35 * 16, 40 * 16);
                target_y    = 240 + irandom_range(10 * 16, 14 * 16);
            } else {
                // Work Room wander (~10%)
                target_room = ROOM_INTERN_WORK;
                target_x    = 320 + irandom_range(3 * 16, 12 * 16);
                target_y    = 240 + irandom_range(9 * 16, 15 * 16);
            }
        }

        var _cur_rm = scr_intern_get_room_at(x, y);
        waypoints = [];

        if (_cur_rm == ROOM_INTERN_WORK) {
            if (target_room == ROOM_INTERN_STORAGE) {
                waypoints = [_wp_work_in, _wp_work, _wp_work_hall, _wp_junc_s, _wp_storage_cor, _wp_storage, _wp_storage_in, [target_x, target_y]];
            } else if (target_room == ROOM_INTERN_GLASS) {
                waypoints = [_wp_work_in, _wp_work, _wp_work_hall, _wp_glass_hall, _wp_glass, _wp_glass_in, [target_x, target_y]];
            } else {
                waypoints = [[target_x, target_y]];
            }
        }
        else if (_cur_rm == ROOM_INTERN_STORAGE) {
            if (target_room == ROOM_INTERN_WORK) {
                waypoints = [_wp_storage_in, _wp_storage, _wp_storage_cor, _wp_junc_s, _wp_work_hall, _wp_work, _wp_work_in, [target_x, target_y]];
            } else if (target_room == ROOM_INTERN_GLASS) {
                waypoints = [_wp_storage_in, _wp_storage, _wp_storage_cor, _wp_junc_s, _wp_glass_hall, _wp_glass, _wp_glass_in, [target_x, target_y]];
            } else {
                waypoints = [[target_x, target_y]];
            }
        }
        else if (_cur_rm == ROOM_INTERN_GLASS) {
            if (target_room == ROOM_INTERN_WORK) {
                waypoints = [_wp_glass_in, _wp_glass, _wp_glass_hall, _wp_work_hall, _wp_work, _wp_work_in, [target_x, target_y]];
            } else if (target_room == ROOM_INTERN_STORAGE) {
                waypoints = [_wp_glass_in, _wp_glass, _wp_glass_hall, _wp_junc_s, _wp_storage_cor, _wp_storage, _wp_storage_in, [target_x, target_y]];
            } else {
                waypoints = [[target_x, target_y]];
            }
        }
        else if (_cur_rm == ROOM_INTERN_GREEN) {
            // Intern placed in Green Room exiting towards target
            if (target_room == ROOM_INTERN_WORK) {
                waypoints = [_wp_green_in, _wp_green, _wp_green_cor, _wp_junc_g, _wp_junc_s, _wp_work_hall, _wp_work, _wp_work_in, [target_x, target_y]];
            } else if (target_room == ROOM_INTERN_STORAGE) {
                waypoints = [_wp_green_in, _wp_green, _wp_green_cor, _wp_junc_g, _wp_junc_s, _wp_storage_cor, _wp_storage, _wp_storage_in, [target_x, target_y]];
            } else if (target_room == ROOM_INTERN_GLASS) {
                waypoints = [_wp_green_in, _wp_green, _wp_green_cor, _wp_junc_g, _wp_glass_hall, _wp_glass, _wp_glass_in, [target_x, target_y]];
            } else {
                waypoints = [[target_x, target_y]];
            }
        }
        else {
            // In hallway
            if (target_room == ROOM_INTERN_STORAGE)      waypoints = [_wp_junc_s, _wp_storage_cor, _wp_storage, _wp_storage_in, [target_x, target_y]];
            else if (target_room == ROOM_INTERN_GLASS)   waypoints = [_wp_glass_hall, _wp_glass, _wp_glass_in, [target_x, target_y]];
            else                                         waypoints = [_wp_work_hall, _wp_work, _wp_work_in, [target_x, target_y]];
        }

        current_wp = 0;
        state = INTERN_STATE_SEEK_ROOM;
        break;

    case INTERN_STATE_SEEK_ROOM:
        // Follow waypoints cleanly through doorways
        walk_timer++;

        // Mischievous door slamming: only when running right through a doorway threshold and NOT in grace/cooldown!
        var _close_door = instance_nearest(x, y, obj_intern_door);
        if (_close_door != noone && !_close_door.is_locked && !_close_door.is_closed && _close_door.slam_cooldown <= 0) {
            if (grace_timer <= 0 && door_cooldown <= 0 && mischief_target == noone && point_distance(x, y, _close_door.x + 8, _close_door.y + 8) < 18) {
                if (irandom(60) == 0) {
                    _close_door.is_closed     = true;
                    _close_door.is_locked     = true;
                    _close_door.slam_cooldown = 400; // ~6.6s before door can be slammed again
                    door_cooldown             = 400; // Intern cannot slam another door for ~6.6s
                    audio_play_sound(snd_attack_impact, 10, false);
                }
            }
        }

        if (current_wp < array_length(waypoints)) {
            var _dest_x = waypoints[current_wp][0];
            var _dest_y = waypoints[current_wp][1];
            var _dir = point_direction(x, y, _dest_x, _dest_y);
            face_dir = _dir;

            var _vx = lengthdir_x(move_speed, _dir);
            var _vy = lengthdir_y(move_speed, _dir);

            var _nx = x + _vx;
            var _ny = y + _vy;

            // Foot-corner collision checks against solid walls (4px radius allows smooth doorway pass)
            var _hit_x = collision_circle(_nx, y, 4, obj_dungeon_wall, false, true) != noone;
            var _hit_y = collision_circle(x, _ny, 4, obj_dungeon_wall, false, true) != noone;

            if (!_hit_x) x += _vx;
            if (!_hit_y) y += _vy;

            if (point_distance(x, y, _dest_x, _dest_y) <= 6) {
                current_wp++;
                if (current_wp >= array_length(waypoints)) {
                    // 1. Did we specifically seek an air vent?
                    if (vent_target != noone && instance_exists(vent_target)) {
                        if (!vent_target.is_clogged && vent_target.cooldown <= 0 && vent_target.stuck_intern == noone) {
                            vent_target.is_clogged    = true;
                            vent_target.stuck_intern  = id;
                            vent_target.struggle_pull = 0.0;
                            state       = INTERN_STATE_VENT_STUCK;
                            visible     = false;
                            vent_target = noone;
                            audio_play_sound(snd_attack_impact, 10, false);
                            audio_play_sound(snd_voice2, 10, false);
                            break;
                        }
                        vent_target = noone;
                    }

                    // 2. Standard room transitions
                    if (target_room == ROOM_INTERN_WORK) {
                        state        = INTERN_STATE_WORK;
                        boredom      = 0;
                        boredom_rate = random_range(0.045, 0.085);
                    } else if (target_room == ROOM_INTERN_GREEN) {
                        state        = INTERN_STATE_SOOTHED;
                        soothe_timer = 900; // 15 seconds!
                        boredom      = 0;
                        boredom_rate = random_range(0.045, 0.085);
                        audio_play_sound(snd_voice1, 10, false);
                    } else {
                        state          = INTERN_STATE_MISCHIEF;
                        mischief_timer = 0;
                    }
                }
            }
        } else {
            // Already arrived / empty waypoint path
            if (vent_target != noone && instance_exists(vent_target)) {
                if (!vent_target.is_clogged && vent_target.cooldown <= 0 && vent_target.stuck_intern == noone) {
                    vent_target.is_clogged    = true;
                    vent_target.stuck_intern  = id;
                    vent_target.struggle_pull = 0.0;
                    state       = INTERN_STATE_VENT_STUCK;
                    visible     = false;
                    vent_target = noone;
                    audio_play_sound(snd_attack_impact, 10, false);
                    audio_play_sound(snd_voice2, 10, false);
                    break;
                }
                vent_target = noone;
            }

            if (target_room == ROOM_INTERN_WORK) {
                state        = INTERN_STATE_WORK;
                boredom      = 0;
                boredom_rate = random_range(0.045, 0.085);
            } else if (target_room == ROOM_INTERN_GREEN) {
                state        = INTERN_STATE_SOOTHED;
                soothe_timer = 900; // 15 seconds!
                boredom      = 0;
                boredom_rate = random_range(0.045, 0.085);
            } else {
                state          = INTERN_STATE_MISCHIEF;
                mischief_timer = 0;
            }
        }
        break;

    case INTERN_STATE_SOOTHED:
        // Relaxing in the Green Room for 15 seconds
        walk_timer++;
        soothe_timer--;
        boredom = 0;

        if (soothe_timer <= 0) {
            // Fully rested and calm after 15 seconds! Head straight back to work desk!
            audio_play_sound(snd_correct_ping, 10, false);
            target_room  = ROOM_INTERN_WORK;
            target_x     = home_desk_x;
            target_y     = home_desk_y;
            waypoints    = [_wp_green_in, _wp_green, _wp_green_cor, _wp_junc_g, _wp_junc_s, _wp_work_hall, _wp_work, _wp_work_in, [target_x, target_y]];
            current_wp   = 0;
            boredom_rate = random_range(0.045, 0.085); // Fresh randomized stamina!
            state        = INTERN_STATE_SEEK_ROOM;
        }
        break;

    case INTERN_STATE_MISCHIEF:
        mischief_timer++;
        var _cur_rm = scr_intern_get_room_at(x, y);

        // 1. If this intern is ALREADY engaged with a target, STAY COMMITTED to that 1 thing!
        if (mischief_target != noone) {
            if (instance_exists(mischief_target)) {
                if (mischief_target.is_wobbling) {
                    var _tdir = point_direction(x, y, mischief_target.x + 8, mischief_target.y + 8);
                    face_dir = _tdir;
                    if (point_distance(x, y, mischief_target.x + 8, mischief_target.y + 8) > 18) {
                        x += lengthdir_x(move_speed * 0.5, _tdir);
                        y += lengthdir_y(move_speed * 0.5, _tdir);
                    }
                    walk_timer += 2; // shaking tantrum animation
                    break; // Strictly do nothing else while shaking this hazard!
                } else {
                    // Target was stabilized or fell -> release commitment and return to desk with 15s grace!
                    mischief_target = noone;
                    mischief_timer  = 0;
                    scr_intern_send_to_work(id, 900);
                    break;
                }
            } else {
                mischief_target = noone;
            }
        }

        // If intern was recently calmed or on cooldown, don't initiate new mischief
        if (grace_timer > 0) {
            scr_intern_send_to_work(id, grace_timer);
            break;
        }

        // 2. Storage Room Mischief: Shake Shelf, Locker, or Water Cooler OR seek vent
        // Multiple hazards can be active in Storage simultaneously, but each intern only handles 1!
        if (_cur_rm == ROOM_INTERN_STORAGE) {
            // Vent check in storage: available only if vent and intern have NO cooldown
            var _mischief_vent = noone;
            with (obj_intern_vent) {
                if (room_assigned == _cur_rm && !is_clogged && cooldown <= 0 && stuck_intern == noone) {
                    _mischief_vent = id;
                    break;
                }
            }
            if (_mischief_vent != noone && mischief_target == noone && vent_cooldown <= 0 && grace_timer <= 0) {
                var _vd = point_distance(x, y, _mischief_vent.x + 8, _mischief_vent.y + 8);
                if (_vd <= 20) {
                    _mischief_vent.is_clogged    = true;
                    _mischief_vent.stuck_intern  = id;
                    _mischief_vent.struggle_pull = 0.0;
                    state       = INTERN_STATE_VENT_STUCK;
                    visible     = false;
                    vent_target = noone;
                    audio_play_sound(snd_attack_impact, 10, false);
                    audio_play_sound(snd_voice2, 10, false);
                    break;
                } else if (irandom(99) < 35) {
                    var _vdir = point_direction(x, y, _mischief_vent.x + 8, _mischief_vent.y + 8);
                    x += lengthdir_x(move_speed * 0.5, _vdir);
                    y += lengthdir_y(move_speed * 0.5, _vdir);
                    break;
                }
            }

            // Find closest available (not already wobbling / fallen / trapped) hazard
            var _best_haz = noone;
            var _best_d   = 36;
            with (obj_intern_hazard) {
                if (!is_wobbling && !is_fallen && !is_trapped && mischief_intern == noone) {
                    var _d = point_distance(other.x, other.y, x + 8, y + 8);
                    if (_d < _best_d) {
                        _best_d   = _d;
                        _best_haz = id;
                    }
                }
            }

            if (_best_haz != noone) {
                _best_haz.is_wobbling      = true;
                _best_haz.wobble_timer     = _best_haz.wobble_max;
                _best_haz.wobble_fix_meter = 0.0;
                _best_haz.mischief_intern  = id;
                mischief_target            = _best_haz;
                audio_play_sound(snd_voice2, 10, false);
                break; // This intern is now locked onto this specific hazard!
            }
        }
        // 3. Glass Room Mischief: Walk to panoramic glass to bang on it OR seek vent
        else if (_cur_rm == ROOM_INTERN_GLASS) {
            var _mischief_vent_g = noone;
            with (obj_intern_vent) {
                if (room_assigned == _cur_rm && !is_clogged && cooldown <= 0 && stuck_intern == noone) {
                    _mischief_vent_g = id;
                    break;
                }
            }
            if (_mischief_vent_g != noone && vent_cooldown <= 0 && grace_timer <= 0) {
                var _vd = point_distance(x, y, _mischief_vent_g.x + 8, _mischief_vent_g.y + 8);
                if (_vd <= 20) {
                    _mischief_vent_g.is_clogged    = true;
                    _mischief_vent_g.stuck_intern  = id;
                    _mischief_vent_g.struggle_pull = 0.0;
                    state       = INTERN_STATE_VENT_STUCK;
                    visible     = false;
                    vent_target = noone;
                    audio_play_sound(snd_attack_impact, 10, false);
                    audio_play_sound(snd_voice2, 10, false);
                    break;
                } else if (irandom(99) < 35) {
                    var _vdir = point_direction(x, y, _mischief_vent_g.x + 8, _mischief_vent_g.y + 8);
                    x += lengthdir_x(move_speed * 0.5, _vdir);
                    y += lengthdir_y(move_speed * 0.5, _vdir);
                    break;
                }
            }

            var _gls = instance_nearest(x, y, obj_intern_glass);
            if (_gls != noone && !_gls.is_shattered && point_distance(x, y, _gls.x + 8, _gls.y + 8) > 14) {
                var _gdir = point_direction(x, y, _gls.x + 8, _gls.y + 8);
                x += lengthdir_x(move_speed * 0.6, _gdir);
                y += lengthdir_y(move_speed * 0.6, _gdir);
            }
        }
        // 4. Work Room Mischief: Smash another PC or seek vent
        else if (_cur_rm == ROOM_INTERN_WORK) {
            var _mischief_vent_w = noone;
            with (obj_intern_vent) {
                if (room_assigned == _cur_rm && !is_clogged && cooldown <= 0 && stuck_intern == noone) {
                    _mischief_vent_w = id;
                    break;
                }
            }
            if (_mischief_vent_w != noone && vent_cooldown <= 0 && grace_timer <= 0) {
                var _vd = point_distance(x, y, _mischief_vent_w.x + 8, _mischief_vent_w.y + 8);
                if (_vd <= 20) {
                    _mischief_vent_w.is_clogged    = true;
                    _mischief_vent_w.stuck_intern  = id;
                    _mischief_vent_w.struggle_pull = 0.0;
                    state       = INTERN_STATE_VENT_STUCK;
                    visible     = false;
                    vent_target = noone;
                    audio_play_sound(snd_attack_impact, 10, false);
                    audio_play_sound(snd_voice2, 10, false);
                    break;
                } else if (irandom(99) < 35) {
                    var _vdir = point_direction(x, y, _mischief_vent_w.x + 8, _mischief_vent_w.y + 8);
                    x += lengthdir_x(move_speed * 0.5, _vdir);
                    y += lengthdir_y(move_speed * 0.5, _vdir);
                    break;
                }
            }

            var _trm = instance_nearest(x, y, obj_intern_terminal);
            if (_trm != noone && point_distance(x, y, _trm.x + 8, _trm.y + 8) < 20) {
                if (!_trm.is_fried && mischief_timer > 90) {
                    _trm.is_fried = true;
                    audio_play_sound(snd_attack_impact, 10, false);
                    scr_intern_send_to_work(id, 600);
                    break;
                }
            }
        }

        // Tantrum roll only if mischief prolonged and NOT engaged with a target
        if (mischief_target == noone && mischief_timer > 240) {
            state          = choose(INTERN_STATE_BORED, INTERN_STATE_TANTRUM);
            mischief_timer = 0;
        }
        break;

    case INTERN_STATE_TANTRUM:
        walk_timer += 2;
        mischief_timer++;
        if (mischief_timer mod 60 == 0) {
            audio_play_sound(snd_voice2, 10, false);
        }

        // Interns in tantrum slam doors ONLY when physically right at the doorway, not engaged in target!
        var _tantrum_door = instance_nearest(x, y, obj_intern_door);
        if (_tantrum_door != noone && !_tantrum_door.is_locked && !_tantrum_door.is_closed && _tantrum_door.slam_cooldown <= 0) {
            if (door_cooldown <= 0 && mischief_target == noone && point_distance(x, y, _tantrum_door.x + 8, _tantrum_door.y + 8) < 18) {
                if (irandom(40) == 0) {
                    _tantrum_door.is_closed     = true;
                    _tantrum_door.is_locked     = true;
                    _tantrum_door.slam_cooldown = 400;
                    door_cooldown               = 400;
                    audio_play_sound(snd_attack_impact, 10, false);
                }
            }
        }

        if (mischief_timer > 240) {
            state          = INTERN_STATE_BORED;
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
            if (!variable_global_exists("e_interact_step") || global.e_interact_step != current_time) {
                global.e_interact_step = current_time;
                revive_meter += 0.22;
                audio_play_sound(snd_button_hover, 10, false);
                if (revive_meter >= 1.0) {
                    revive_meter   = 0;
                    knockout_timer = 1800;
                    audio_play_sound(snd_objective_complete, 10, false);
                    audio_play_sound(snd_voice1, 10, false);
                    scr_intern_send_to_work(id, 900);
                }
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
