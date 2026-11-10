// obj_jack — Step Event
// FIXED: Removed duplicate E-key interaction block at bottom of file.
// FIXED: obj_camera conflict — camera2 Step was fighting this; delete obj_camera2.

depth = -y;

// Hide Jack in combat rooms
if (room == rm_combat || room == rm_battle_scramble) {
    visible = false;
    exit; 
} else {
    visible = true;
}

if (variable_global_exists("is_paused") && global.is_paused) {
    image_speed = 0;
    exit;
}

// Hidden inside a Hallway Security Locker (safe from drones; press [E] handled by obj_dungeon_prop)
if (variable_global_exists("player_in_locker") && global.player_in_locker) {
    visible     = false;
    image_speed = 0;
    exit;
}

// Freeze during cutscenes, transitions, or active minigames
if (isInCutscene
    || (variable_global_exists("cam_pan_phase")      && global.cam_pan_phase != "off")
    || (variable_global_exists("pc_screen_open")     && global.pc_screen_open)
    || (variable_global_exists("key_analyzer_open")  && global.key_analyzer_open)
    || (variable_global_exists("override_ui_open")   && global.override_ui_open)
    || (variable_global_exists("breaker_ui_open")    && global.breaker_ui_open)
    || (variable_global_exists("scrap_ui_open")      && global.scrap_ui_open)
    || (variable_global_exists("phone_ui_open")      && global.phone_ui_open)
    || (variable_global_exists("shelf_ui_open")      && global.shelf_ui_open)
    || (variable_global_exists("bot_grapple_active") && global.bot_grapple_active)
    || instance_exists(obj_transition)
    || instance_exists(obj_path)
    || instance_exists(obj_cipher)
    || instance_exists(obj_dungeon_quiz)
    || instance_exists(obj_qte)
    || instance_exists(obj_textevent)
    || instance_exists(obj_textbox)
    || instance_exists(obj_atbash_mirror_gui)
    || instance_exists(obj_atbash_board_gui)
    || instance_exists(obj_atbash_combat_gui)
    || instance_exists(obj_atbash_test_gui))
{
    image_speed = 0;
    image_index = 0;
    exit;
}

// --- INTERN TANTRUM STUN LOCK ---
if (variable_global_exists("jack_stun_timer") && global.jack_stun_timer > 0) {
    global.jack_stun_timer--;
    sprite_index = spr_jack_hurt;
    image_speed  = 0.2;
    if (variable_global_exists("jack_hit_cooldown") && global.jack_hit_cooldown > 0) {
        global.jack_hit_cooldown--;
    }
    exit;
}
if (variable_global_exists("jack_hit_cooldown") && global.jack_hit_cooldown > 0) {
    global.jack_hit_cooldown--;
}

// --- LOCKED DOOR BUMP / KNOCKBACK SEQUENCE ---
if (!variable_instance_exists(id, "bump_timer")) {
    bump_timer     = 0;
    bump_vx        = 0;
    bump_vy        = 0;
    bump_door_type = "";
}

if (bump_timer > 0) {
    bump_timer--;
    sprite_index = spr_jack_hurt;
    image_speed  = 0.25;

    // Slide Jack backward away from the locked door
    if (!place_meeting(x + bump_vx, y, obj_barrier) && !place_meeting(x + bump_vx, y, obj_dungeon_wall)) {
        x += bump_vx;
    }
    if (!place_meeting(x, y + bump_vy, obj_barrier) && !place_meeting(x, y + bump_vy, obj_dungeon_wall)) {
        y += bump_vy;
    }
    bump_vx *= 0.85;
    bump_vy *= 0.85;

    // When knockback finishes, trigger Jack's reaction dialogue box
    if (bump_timer <= 0) {
        sprite_index = spr_jack_idle;
        image_index  = current_anim_start;

        var _line = "";
        if (bump_door_type == "quiz") {
            _line = choose(
                "Ouch! I really need to stop running into doors... My skull is not a brute-force attack!",
                "Ow, my nose! That's what they call a HARD firewall. Maybe I should press [E] instead of using my face.",
                "BONK! Note to self: sprinting at 20 mph into a laser-locked door does NOT bypass the security question.",
                "Ugh, my head... I tried a 'head-on' cyberattack and the door won. Better press [E] like a normal person!",
                "Ow! Who put a door in the middle of this doorway?! Oh right, it's locked. Press [E], Jack, use your fingers, not your forehead.",
                "My last two brain cells just collided with that security grid. I better press [E] while I still remember what Phishing means!"
            );
        } else if (bump_door_type == "drone") {
            _line = choose(
                "BZZT! Ow! That rogue security drone just tased my funny bone! Not very funny!",
                "Ouch! Hey, watch the hair! Who programmed the office antivirus to zap the actual humans?!",
                "ZAP! Okay, I'm awake, I'm awake! Better steer clear of those red patrol drones until I unlock the elevator door!",
                "Ow! That floating malware toaster just gave me a static shock strong enough to charge my phone to 200%!"
            );
        } else {
            _line = choose(
                "Ouch! I really need to stop running into doors... Julius Caesar got stabbed 23 times, and I'm out here concussing myself on his cipher!",
                "BONK! Et tu, Door-te?! You can't just Shift-sprint through a Shift cipher! Press [E]!",
                "Ow, my forehead! That's a Caesar lock, not a 'seize-her-with-my-face' lock!",
                "Ugh... I came, I saw, I face-planted into a locked door. Veni, vidi, concussed.",
                "Wait, holding SHIFT makes me run faster, it doesn't SHIFT the alphabet on the door! I gotta press [E] for that!",
                "Ow! If I keep headbutting encrypted doors, my own brain is gonna need a decryption key."
            );
        }

        // Prevent duplicate Press E tutorial line inside dungeon bump reaction
        global.e_dialogue_intro_shown = true;
        create_textevent([_line], [id]);
    }
    exit;
}

// --- INTERACTION ---
if (keyboard_check_pressed(ord("E"))) {
    var _npc = instance_nearest(x, y, par_npc);
    if (_npc != noone && point_distance(x, y, _npc.x, _npc.y) < 48) {
        with (_npc) { event_user(0); }
    }
}

// --- INPUT ---
var _key_right    = keyboard_check(ord("D")) || keyboard_check(vk_right);
var _key_left     = keyboard_check(ord("A")) || keyboard_check(vk_left);
var _key_up       = keyboard_check(ord("W")) || keyboard_check(vk_up);
var _key_down     = keyboard_check(ord("S")) || keyboard_check(vk_down);
var _is_sprinting = keyboard_check(vk_shift);

var _move_x_intent = _key_right - _key_left;
var _move_y_intent = _key_down  - _key_up;
var _is_moving     = (_move_x_intent != 0 || _move_y_intent != 0);

var _cur_move_spd = _is_sprinting ? (variable_instance_exists(id, "sprint_speed") ? sprint_speed : 4.2) : move_speed;
if (variable_global_exists("held_intern_inst") && global.held_intern_inst != noone) {
    _cur_move_spd *= 0.82; // slightly slower while carrying a baby intern!
}
var _cur_anim_spd = (_is_moving && _is_sprinting) ? (anim_speed * 1.65) : anim_speed;

var _target_anim_start;
var _target_anim_frames = anim.frames_per_anim;

// --- MOVEMENT & ANIMATION ---
if (_is_moving) {
    sprite_index = spr_jack_walk;

    var _dir  = point_direction(0, 0, _move_x_intent, _move_y_intent);
    var _hspd = lengthdir_x(_cur_move_spd, _dir);
    var _vspd = lengthdir_y(_cur_move_spd, _dir);

    // Only bonk / knock back into a locked door when running into it at full sprint!
    if (_is_sprinting) {
        var _hit_quiz   = place_meeting(x + _hspd, y + _vspd, obj_door_quiz_lock);
        var _hit_caesar = place_meeting(x + _hspd, y + _vspd, obj_door_caesar_lock);
        if (_hit_quiz || _hit_caesar) {
            bump_timer     = 18;
            bump_vx        = -_move_x_intent * 2.5;
            bump_vy        = -_move_y_intent * 2.5;
            bump_door_type = _hit_quiz ? "quiz" : "caesar";
            sprite_index   = spr_jack_hurt;
            image_index    = 0;

            global.cam_shake_timer = 14;
            global.cam_shake_mag   = 5;
            audio_play_sound(snd_attack_impact, 10, false);
            audio_play_sound(snd_hurt, 10, false);
            exit;
        }
    }

    // Horizontal collision (with corner-slide assist for smooth doorway traversal)
    if (place_meeting(x + _hspd, y, obj_barrier) || place_meeting(x + _hspd, y, obj_dungeon_wall)) {
        if (_vspd == 0) {
            for (var _nudge = 1; _nudge <= 8; _nudge++) {
                if (!place_meeting(x + _hspd, y - _nudge, obj_barrier) && !place_meeting(x + _hspd, y - _nudge, obj_dungeon_wall)) {
                    y -= min(move_speed, _nudge);
                    break;
                }
                if (!place_meeting(x + _hspd, y + _nudge, obj_barrier) && !place_meeting(x + _hspd, y + _nudge, obj_dungeon_wall)) {
                    y += min(move_speed, _nudge);
                    break;
                }
            }
        }
        if (place_meeting(x + _hspd, y, obj_barrier) || place_meeting(x + _hspd, y, obj_dungeon_wall)) {
            while (!place_meeting(x + sign(_hspd), y, obj_barrier) && !place_meeting(x + sign(_hspd), y, obj_dungeon_wall)) x += sign(_hspd);
            _hspd = 0;
        }
    }
    x += _hspd;

    // Vertical collision (with corner-slide assist for smooth doorway traversal)
    if (place_meeting(x, y + _vspd, obj_barrier) || place_meeting(x, y + _vspd, obj_dungeon_wall)) {
        if (_hspd == 0) {
            for (var _nudge = 1; _nudge <= 8; _nudge++) {
                if (!place_meeting(x - _nudge, y + _vspd, obj_barrier) && !place_meeting(x - _nudge, y + _vspd, obj_dungeon_wall)) {
                    x -= min(move_speed, _nudge);
                    break;
                }
                if (!place_meeting(x + _nudge, y + _vspd, obj_barrier) && !place_meeting(x + _nudge, y + _vspd, obj_dungeon_wall)) {
                    x += min(move_speed, _nudge);
                    break;
                }
            }
        }
        if (place_meeting(x, y + _vspd, obj_barrier) || place_meeting(x, y + _vspd, obj_dungeon_wall)) {
            while (!place_meeting(x, y + sign(_vspd), obj_barrier) && !place_meeting(x, y + sign(_vspd), obj_dungeon_wall)) y += sign(_vspd);
            _vspd = 0;
        }
    }
    y += _vspd;

    // Subtle pitch-varied footstep SFX (faster cadence when sprinting)
    if (_hspd != 0 || _vspd != 0) {
        if (!variable_instance_exists(id, "step_sfx_timer")) step_sfx_timer = 0;
        step_sfx_timer++;
        var _step_interval = _is_sprinting ? 9 : 14;
        if (step_sfx_timer >= _step_interval) {
            step_sfx_timer = 0;
            var _step_snd = audio_play_sound(snd_moveselect, 1, false);
            audio_sound_gain(_step_snd, _is_sprinting ? 0.28 : 0.20, 0);
            audio_sound_pitch(_step_snd, random_range(0.85, 1.15));
        }
    }

    // Choose walk animation
    if (_move_x_intent != 0) {
        last_move_x = _move_x_intent;
        last_move_y = 0;
        _target_anim_start = (_move_x_intent > 0) ? anim.right_start : anim.left_start;
    } else {
        last_move_x = 0;
        last_move_y = _move_y_intent;
        _target_anim_start = (_move_y_intent > 0) ? anim.down_start : anim.up_start;
    }
} else {
    // Idle
    sprite_index = spr_jack_idle;
    if      (last_move_x > 0)  _target_anim_start = anim.right_start;
    else if (last_move_x < 0)  _target_anim_start = anim.left_start;
    else if (last_move_y > 0)  _target_anim_start = anim.down_start;
    else                        _target_anim_start = anim.up_start;
}

// --- ANIMATION LOOP ---
image_speed = _cur_anim_spd;
if (_target_anim_start != current_anim_start) {
    image_index = _target_anim_start;
} else {
    image_index = _target_anim_start + (image_index - _target_anim_start) mod _target_anim_frames;
}
current_anim_start  = _target_anim_start;
current_anim_frames = _target_anim_frames;