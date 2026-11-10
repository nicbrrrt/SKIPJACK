/// @description obj_intern_vent — Step Event
if (cooldown > 0) cooldown--;

near_player        = false;
is_interact_target = false;

var _cx = x + 8;
var _cy = y + 8;

if (instance_exists(obj_jack)) {
    var _dist = point_distance(_cx, _cy, obj_jack.x, obj_jack.y - 6);
    if (_dist < 32) {
        near_player = true;
    }
}

// Single-target selection: closest interactable vent (clogged OR damaged) to Jack responds to [E]!
if (near_player && instance_exists(obj_jack)) {
    var _is_actionable = (is_clogged || (vent_hp < 100 && stuck_intern == noone));
    if (_is_actionable) {
        var _closest_vent = noone;
        var _best_d = 999999;
        var _jx = obj_jack.x;
        var _jy = obj_jack.y - 6;
        with (obj_intern_vent) {
            if (near_player && (is_clogged || (vent_hp < 100 && stuck_intern == noone))) {
                var _d = point_distance(x + 8, y + 8, _jx, _jy);
                if (_d < _best_d) {
                    _best_d = _d;
                    _closest_vent = id;
                }
            }
        }
        is_interact_target = (_closest_vent == id);
    }
}

// Proximity capture: if an intern is right at the vent and eligible, get stuck!
if (!is_clogged && !is_down && vent_hp > 0 && cooldown <= 0 && stuck_intern == noone) {
    with (obj_intern) {
        if (state != INTERN_STATE_HELD && state != INTERN_STATE_DEAD && state != INTERN_STATE_TRAPPED && state != INTERN_STATE_SOOTHED && state != INTERN_STATE_VENT_STUCK) {
            if (vent_cooldown <= 0 && grace_timer <= 0) {
                if (point_distance(x, y, other.x + 8, other.y + 8) <= 26) {
                    other.is_clogged    = true;
                    other.stuck_intern  = id;
                    other.struggle_pull = 0.0;
                    state       = INTERN_STATE_VENT_STUCK;
                    visible     = false;
                    vent_target = noone;
                    audio_play_sound(snd_attack_impact, 10, false);
                    audio_play_sound(snd_voice2, 10, false);
                    break;
                }
            }
        }
    }
}

// Handle clogged vent state and player struggle rescue
if (is_clogged) {
    clog_timer++;

    // Frantic kicking intern damages the ventilation duct rapidly!
    var _diff = scr_intern_get_scrap_difficulty();
    var _dmg  = variable_struct_exists(_diff, "vent_damage_rate") ? _diff.vent_damage_rate : 0.18;
    vent_hp   = max(0, vent_hp - _dmg);

    // Stuck intern takes damage over time from suffocation / being squeezed in vent
    if (instance_exists(stuck_intern)) {
        var _intern_v_dmg = variable_struct_exists(_diff, "vent_intern_dmg") ? _diff.vent_intern_dmg : 0.15;
        stuck_intern.intern_hp = max(0, stuck_intern.intern_hp - _intern_v_dmg);
        if (stuck_intern.intern_hp <= 0 && stuck_intern.state != INTERN_STATE_DEAD) {
            stuck_intern.state = INTERN_STATE_DEAD;
            stuck_intern.visible = true;
            is_clogged = false;
            if (room_assigned == ROOM_INTERN_GLASS) {
                stuck_intern.x = x + 8;
                stuck_intern.y = y - 28;
            } else {
                stuck_intern.x = x + 8;
                stuck_intern.y = y + 28;
            }
            audio_play_sound(snd_error, 10, false);
            audio_play_sound(snd_hurt, 10, false);
            global.interns_lost++;
            global.legal_fund = max(0, global.legal_fund - 150);
            stuck_intern = noone;
        }
    }

    kick_impact_t++;
    if (kick_impact_t >= 35) {
        kick_impact_t = 0;
        audio_play_sound(snd_attack_impact, 10, false);
    }

    if (vent_hp <= 0 && !is_down) {
        vent_hp = 0;
        is_down = true;
        audio_play_sound(snd_error, 10, false);
    }

    // Safety: if stuck_intern instance was lost, reset vent
    if (stuck_intern != noone && !instance_exists(stuck_intern)) {
        stuck_intern  = noone;
        is_clogged    = false;
        struggle_pull = 0.0;
    }

    if (is_interact_target && keyboard_check_pressed(ord("E"))) {
        if (!variable_global_exists("e_interact_step") || global.e_interact_step != current_time) {
            global.e_interact_step = current_time;
            struggle_pull += 0.22; // ~5 rapid taps of [E] to pull intern free!
            audio_play_sound(snd_button_hover, 10, false);

            if (struggle_pull >= 1.0) {
                // Intern successfully freed from air vent!
                is_clogged    = false;
                struggle_pull = 0.0;
                cooldown      = 900; // 15 seconds vent immunity! No intern can crawl in!
                audio_play_sound(snd_objective_complete, 10, false);
                audio_play_sound(snd_voice1, 10, false);

                if (instance_exists(stuck_intern)) {
                    stuck_intern.visible = true;

                    // Place safely on floor at generous clearance in front of vent
                    if (room_assigned == ROOM_INTERN_GLASS) {
                        stuck_intern.x = x + 8;
                        stuck_intern.y = y - 28; // Clear safe distance South of North threshold
                    } else {
                        stuck_intern.x = x + 8;
                        stuck_intern.y = y + 28; // Clear safe distance South of North wall vent
                    }

                    // Check facility air at time of extraction
                    var _ctrl = instance_nearest(x, y, obj_intern_ward_controller);
                    var _o2 = 100;
                    if (_ctrl != noone && variable_instance_exists(_ctrl, "floor_oxygen")) {
                        _o2 = _ctrl.floor_oxygen;
                    }

                    if (_o2 <= 0) {
                        stuck_intern.state          = INTERN_STATE_KNOCKED_OUT;
                        stuck_intern.knockout_timer = 1800;
                    } else {
                        // Send safely back to office desk with 15s grace period!
                        scr_intern_send_to_work(stuck_intern, 900);
                    }
                    stuck_intern = noone;
                }
            }
        }
    } else {
        // Slow struggle pull decay if player pauses tapping
        struggle_pull = max(0.0, struggle_pull - 0.005);
    }
} else {
    // -------------------------------------------------------------
    // UNCLOGGED VENT: Wrench Repair & Operational State
    // -------------------------------------------------------------
    struggle_pull = 0.0;

    if (vent_hp > 0 && !is_down) {
        fan_rot += 12;
        breeze_timer++;
    }

    // Repair with Wrench: player holds [E] with wrench equipped
    if (vent_hp < 100 && stuck_intern == noone) {
        var _has_wrench = (variable_global_exists("player_has_wrench") && global.player_has_wrench);
        if (is_interact_target && _has_wrench && keyboard_check(ord("E"))) {
            vent_hp = min(100.0, vent_hp + 1.25); // ~1.33s of holding [E] to repair
            repair_snd_t++;
            if (repair_snd_t mod 12 == 0) {
                audio_play_sound(snd_moveselect, 10, false);
            }

            if (vent_hp >= 100.0) {
                vent_hp   = 100.0;
                is_down   = false;
                audio_play_sound(snd_correct_ping, 10, false);
                audio_play_sound(snd_objective_complete, 10, false);
            }
        }
    }
}
