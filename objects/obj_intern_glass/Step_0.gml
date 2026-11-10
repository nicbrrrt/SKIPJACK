/// @description obj_intern_glass — Step Event
near_player      = false;
is_repair_target = false;

var _cx = x + 8;
var _cy = y + 8;

if (hit_cooldown > 0) hit_cooldown--;
if (hit_anim > 0)     hit_anim--;

if (instance_exists(obj_jack)) {
    if (point_distance(_cx, _cy, obj_jack.x, obj_jack.y - 6) < 32) {
        near_player = true;
    }
}

// Single-target selection: only the single closest damaged pane to Jack is the active repair target!
if (near_player && !is_shattered && glass_hp < max_hp && instance_exists(obj_jack)) {
    var _closest_glass = noone;
    var _best_d = 999999;
    var _jx = obj_jack.x;
    var _jy = obj_jack.y - 6;
    with (obj_intern_glass) {
        if (!is_shattered && glass_hp < max_hp) {
            var _d = point_distance(x + 8, y + 8, _jx, _jy);
            if (_d < 32 && _d < _best_d) {
                _best_d = _d;
                _closest_glass = id;
            }
        }
    }
    is_repair_target = (_closest_glass == id);
}

// -----------------------------------------------------------------
// 1. PLAYER REINFORCE: LONG PRESS HOLD [E] (2 Seconds)
// -----------------------------------------------------------------
if (is_repair_target && !is_shattered && glass_hp < max_hp) {
    if (keyboard_check(ord("E"))) {
        hold_timer++;
        repair_spark_t++;

        // Audio feedback while welding / reinforcing
        if (repair_spark_t mod 25 == 0) {
            audio_play_sound(snd_button_hover, 10, false);
        }

        // Progressively restore glass HP as player holds [E] down
        glass_hp = min(max_hp, glass_hp + (max_hp / hold_max));

        if (hold_timer >= hold_max || glass_hp >= max_hp) {
            glass_hp   = max_hp;
            hold_timer = 0;
            audio_play_sound(snd_objective_complete, 10, false);
            audio_play_sound(snd_correct_ping, 10, false);

            // Shoo away any interns loitering or banging on the deck glass back to their desks!
            with (obj_intern) {
                if (scr_intern_get_room_at(x, y) == ROOM_INTERN_GLASS && (state == INTERN_STATE_MISCHIEF || state == INTERN_STATE_TANTRUM || state == INTERN_STATE_BORED)) {
                    scr_intern_send_to_work(id, 900);
                }
            }
        }
    } else {
        // Key released: decay hold timer
        hold_timer = max(0, hold_timer - 6);
    }
} else {
    hold_timer = 0;
}

// -----------------------------------------------------------------
// 2. INTERNS BANGING ON THE GLASS
// -----------------------------------------------------------------
if (!is_shattered) {
    var _banging = false;
    with (obj_intern) {
        if (state == INTERN_STATE_MISCHIEF || state == INTERN_STATE_TANTRUM) {
            if (point_distance(x, y, _cx, _cy) < 22) {
                _banging = true;
            }
        }
    }

    if (_banging && hit_cooldown <= 0) {
        var _diff    = scr_intern_get_scrap_difficulty();
        hit_cooldown = _diff.glass_hit_cd;
        glass_hp     = max(0, glass_hp - _diff.glass_damage);
        hit_anim     = 8;
        audio_play_sound(snd_button_hover, 10, false);

        if (glass_hp <= (max_hp * 0.25) && (alarm_get(0) mod 60 == 0)) {
            audio_play_sound(snd_error, 10, false);
        }
    }
}

// -----------------------------------------------------------------
// 3. SHATTER & FALL INTO THE VOID
// -----------------------------------------------------------------
if (glass_hp <= 0 && !is_shattered) {
    is_shattered = true;
    mask_index   = -1; // disable collision so breach is open!
    audio_play_sound(snd_attack_impact, 10, false);
    audio_play_sound(snd_die, 10, false);
    global.cam_shake_timer = 20;
    global.cam_shake_mag   = 7;

    // Any intern directly in front of this shattered window falls out!
    with (obj_intern) {
        if (state != INTERN_STATE_DEAD && state != INTERN_STATE_HELD) {
            if (point_distance(x, y, _cx, _cy) < 24) {
                state   = INTERN_STATE_DEAD;
                visible = false;
                global.interns_lost++;
                global.legal_fund = max(0, global.legal_fund - 150);
            }
        }
    }
}
