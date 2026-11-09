/// @description obj_intern_hazard ?" Step Event
near_player = false;

var _cx = x + 8;
var _cy = y + 8;

if (instance_exists(obj_jack)) {
    var _dist = point_distance(_cx, _cy, obj_jack.x, obj_jack.y - 6);
    if (_dist < 32) {
        near_player = true;
    }
}

// -----------------------------------------------------------------
// 1. WOBBLE TELEGRAPH STATE
// -----------------------------------------------------------------
if (is_wobbling && !is_fallen && !is_trapped) {
    wobble_timer--;
    var _p = clamp(1.0 - (wobble_timer / wobble_max), 0.0, 1.0);
    // Frequency and amplitude ramp up over time!
    wobble_angle = sin(current_time / (70 - _p * 45)) * (2.5 + _p * 15);

    // Player reactions: Press [E] to steady!
    if (near_player && keyboard_check_pressed(ord("E"))) {
        is_wobbling  = false;
        wobble_angle = 0;
        wobble_timer = 0;
        audio_play_sound(snd_correct_ping, 10, false);

        if (instance_exists(mischief_intern)) {
            mischief_intern.state = INTERN_STATE_BORED;
            mischief_intern.mischief_target = noone;
            mischief_intern.x += choose(-12, 12);
            mischief_intern = noone;
        }
    }
    // Time ran out! The hazard falls over / triggers!
    else if (wobble_timer <= 0) {
        is_wobbling = false;
        wobble_angle = 0;

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
            audio_play_sound(snd_hurt, 10, false);
            audio_play_sound(snd_attack_impact, 10, false);

            // Fry nearby terminals if any
            with (obj_intern_terminal) {
                if (point_distance(x, y, _cx, _cy) < 40) {
                    is_fried = true;
                }
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

    if (near_player && keyboard_check_pressed(ord("E"))) {
        struggle_meter += 0.25; // 4 quick taps to pry open
        audio_play_sound(snd_button_hover, 10, false);
        if (struggle_meter >= 1.0) {
            // Freed!
            is_trapped     = false;
            struggle_meter = 0;
            audio_play_sound(snd_objective_complete, 10, false);
            if (instance_exists(trapped_intern)) {
                trapped_intern.visible = true;
                trapped_intern.state   = INTERN_STATE_BORED;
                trapped_intern.x       = _cx;
                trapped_intern.y       = _cy + 14;
                trapped_intern         = noone;
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

// -----------------------------------------------------------------
// 3. FALLEN SHELF / WATER COOLER (Press [E] to lift back up)
// -----------------------------------------------------------------
if (is_fallen && near_player && keyboard_check_pressed(ord("E"))) {
    is_fallen = false;
    audio_play_sound(snd_correct_ping, 10, false);
}
