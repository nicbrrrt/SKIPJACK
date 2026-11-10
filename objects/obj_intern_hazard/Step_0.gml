/// @description obj_intern_hazard ?" Step Event
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

// Single-target selection: only the single closest interactable hazard to Jack responds to [E]!
var _can_act = (near_player && (is_wobbling || is_trapped || (is_fallen && (hazard_type == HAZARD_SHELF || hazard_type == HAZARD_WATER))));
if (_can_act && instance_exists(obj_jack)) {
    var _closest_haz = noone;
    var _best_d = 999999;
    var _jx = obj_jack.x;
    var _jy = obj_jack.y - 6;
    with (obj_intern_hazard) {
        if (near_player && (is_wobbling || is_trapped || (is_fallen && (hazard_type == HAZARD_SHELF || hazard_type == HAZARD_WATER)))) {
            var _d = point_distance(x + 8, y + 8, _jx, _jy);
            if (_d < _best_d) {
                _best_d = _d;
                _closest_haz = id;
            }
        }
    }
    is_interact_target = (_closest_haz == id);
}

// -----------------------------------------------------------------
// 1. WOBBLE TELEGRAPH STATE
// -----------------------------------------------------------------
if (is_wobbling && !is_fallen && !is_trapped) {
    // If player is actively tapping [E], buffer the countdown so it doesn't expire mid-spam
    if (wobble_fix_meter > 0) {
        wobble_timer = max(wobble_timer, 60);
    } else {
        wobble_timer--;
    }

    var _p = clamp(1.0 - (wobble_timer / wobble_max), 0.0, 1.0);
    // Frequency and amplitude ramp up over time!
    wobble_angle = sin(current_time / (70 - _p * 45)) * (2.5 + _p * 15);

    // Player reactions: Spam [E] to fix/steady!
    if (is_interact_target && keyboard_check_pressed(ord("E"))) {
        if (!variable_global_exists("e_interact_step") || global.e_interact_step != current_time) {
            global.e_interact_step = current_time;
            wobble_fix_meter += 0.28; // ~4 rapid taps of [E] to fix/steady!
            wobble_timer = max(wobble_timer, 60); // Keep timer buffered while actively tapping!
            audio_play_sound(snd_button_hover, 10, false);

            if (wobble_fix_meter >= 1.0) {
                // Successfully stabilized!
                is_wobbling      = false;
                wobble_angle     = 0;
                wobble_timer     = 0;
                wobble_fix_meter = 0.0;
                audio_play_sound(snd_correct_ping, 10, false);

                if (instance_exists(mischief_intern)) {
                    if (mischief_intern.state != INTERN_STATE_HELD && global.held_intern_inst != mischief_intern) {
                        scr_intern_send_to_work(mischief_intern, 900); // Scram back to desk with 15s grace!
                    }
                    mischief_intern = noone;
                }
                exit; // Successfully stabilized - do not run timeout destruction!
            }
        }
    } else {
        wobble_fix_meter = max(0.0, wobble_fix_meter - 0.005);
    }

    // Time ran out! The hazard falls over / triggers! (Only if STILL wobbling!)
    if (is_wobbling && wobble_timer <= 0) {
        is_wobbling      = false;
        wobble_angle     = 0;
        wobble_fix_meter = 0.0;

        if (hazard_type == HAZARD_SHELF) {
            is_fallen = true;
            global.cam_shake_timer = 15;
            global.cam_shake_mag   = 5;
            audio_play_sound(snd_attack_impact, 10, false);
            audio_play_sound(snd_hurt, 10, false);

            // Crush / knock out any nearby intern!
            with (obj_intern) {
                if (state != INTERN_STATE_DEAD && state != INTERN_STATE_HELD) {
                    if (point_distance(x, y, _cx, _cy) < 28) {
                        state = INTERN_STATE_KNOCKED_OUT;
                        knockout_timer = 1800;
                        audio_play_sound(snd_voice2, 10, false);
                    }
                }
            }
        }
        else if (hazard_type == HAZARD_LOCKER) {
            is_trapped     = true;
            trapped_timer  = 1500; // 25 seconds
            struggle_meter = 0;
            audio_play_sound(snd_attack_impact, 10, false);

            if (instance_exists(mischief_intern)) {
                trapped_intern = mischief_intern;
                trapped_intern.state = INTERN_STATE_TRAPPED; // Dedicated trapped state (pauses CPR & drain)
                trapped_intern.visible = false;
                trapped_intern.x = _cx;
                trapped_intern.y = _cy;
            }
        }
        else if (hazard_type == HAZARD_WATER) {
            is_fallen = true;
            global.cam_shake_timer = 12;
            global.cam_shake_mag   = 4;
            audio_play_sound(snd_hurt, 10, false);
            audio_play_sound(snd_attack_impact, 10, false);

            // Shoo away / send the mischievous intern back to desk
            if (instance_exists(mischief_intern)) {
                scr_intern_send_to_work(mischief_intern, 600);
                mischief_intern = noone;
            }

            // Spawn Spilled Water Puddle in the hallway corridor
            if (!instance_exists(obj_intern_puddle)) {
                var _puddle = instance_create_layer(_cx, y + 22, "Instances", obj_intern_puddle);
                _puddle.cooler_inst = id;
            }
        }
    }
}

// -----------------------------------------------------------------
// 2. TRAPPED IN LOCKER (Spam [E] struggle to rescue!)
// -----------------------------------------------------------------
if (is_trapped) {
    trapped_timer--;
    struggle_meter = max(0, struggle_meter - 0.005); // gentle decay

    if (is_interact_target && keyboard_check_pressed(ord("E"))) {
        if (!variable_global_exists("e_interact_step") || global.e_interact_step != current_time) {
            global.e_interact_step = current_time;
            struggle_meter += 0.22; // ~5 rapid taps to pry open locker!
            audio_play_sound(snd_button_hover, 10, false);
            if (struggle_meter >= 1.0) {
                // Freed!
                is_trapped     = false;
                struggle_meter = 0;
                audio_play_sound(snd_objective_complete, 10, false);
                if (instance_exists(trapped_intern)) {
                    trapped_intern.visible = true;
                    trapped_intern.x       = _cx;
                    trapped_intern.y       = _cy + 18;
                    scr_intern_send_to_work(trapped_intern, 900); // Scram back to desk with 15s grace!
                    trapped_intern         = noone;
                }
            }
        }
    }

    // Claustrophobia fatality ONLY if player neglects locker until timer hits 0
    if (trapped_timer <= 0 && is_trapped) {
        is_trapped = false;
        if (instance_exists(trapped_intern)) {
            trapped_intern.visible = true;
            trapped_intern.state   = INTERN_STATE_DEAD;
            trapped_intern         = noone;
            global.interns_lost++;
            global.legal_fund = max(0, global.legal_fund - 150);
            audio_play_sound(snd_die, 10, false);
        }
    }
}

// -------------------------------------------------------------
// 3. FALLEN SHELF / WATER COOLER (Spam [E] to lift back up)
// -------------------------------------------------------------
if (is_fallen && (hazard_type == HAZARD_SHELF || hazard_type == HAZARD_WATER)) {
    struggle_meter = max(0.0, struggle_meter - 0.005);

    if (is_interact_target && keyboard_check_pressed(ord("E"))) {
        if (!variable_global_exists("e_interact_step") || global.e_interact_step != current_time) {
            global.e_interact_step = current_time;
            struggle_meter += 0.28; // ~4 rapid taps to lift
            audio_play_sound(snd_button_hover, 10, false);
            if (struggle_meter >= 1.0) {
                is_fallen      = false;
                struggle_meter = 0.0;
                audio_play_sound(snd_objective_complete, 10, false);
            }
        }
    }
}
