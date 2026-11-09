/// @description obj_intern_glass ?" Step Event
near_player = false;

var _cx = x + 8;
var _cy = y + 8;

if (hit_cooldown > 0) hit_cooldown--;
if (hit_anim > 0)     hit_anim--;

if (instance_exists(obj_jack)) {
    if (point_distance(_cx, _cy, obj_jack.x, obj_jack.y - 6) < 32) {
        near_player = true;
    }
}

// -----------------------------------------------------------------
// 1. PLAYER REPAIR / REINFORCE WITH [E]
// -----------------------------------------------------------------
if (near_player && !is_shattered && glass_hp < 100) {
    if (keyboard_check_pressed(ord("E"))) {
        glass_hp = min(100, glass_hp + 35);
        audio_play_sound(snd_correct_ping, 10, false);
    }
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
        hit_cooldown = 90; // ~1.5s between bangs per pane
        glass_hp = max(0, glass_hp - 4);
        hit_anim = 8;
        audio_play_sound(snd_button_hover, 10, false);

        if (glass_hp <= 25 && (alarm_get(0) mod 60 == 0)) {
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
