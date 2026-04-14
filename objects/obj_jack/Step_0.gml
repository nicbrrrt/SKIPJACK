// obj_jack — Step Event
// FIXED: Removed duplicate E-key interaction block at bottom of file.
// FIXED: obj_camera conflict — camera2 Step was fighting this; delete obj_camera2.

depth = -y;

// Hide Jack in combat room
if (room == rm_combat) {
    visible = false;
    exit; 
} else {
    visible = true;
}

// Freeze during cutscenes, transitions, or active minigames
if (isInCutscene
    || instance_exists(obj_transition)
    || instance_exists(obj_path)
    || instance_exists(obj_cipher)
    || instance_exists(obj_qte)
    || instance_exists(obj_textevent))
{
    image_speed = 0;
    image_index = 0;
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
var _key_right = keyboard_check(ord("D")) || keyboard_check(vk_right);
var _key_left  = keyboard_check(ord("A")) || keyboard_check(vk_left);
var _key_up    = keyboard_check(ord("W")) || keyboard_check(vk_up);
var _key_down  = keyboard_check(ord("S")) || keyboard_check(vk_down);

var _move_x_intent = _key_right - _key_left;
var _move_y_intent = _key_down  - _key_up;
var _is_moving     = (_move_x_intent != 0 || _move_y_intent != 0);

var _target_anim_start;
var _target_anim_frames = anim.frames_per_anim;

// --- MOVEMENT & ANIMATION ---
if (_is_moving) {
    sprite_index = spr_jack_walk;

    var _dir  = point_direction(0, 0, _move_x_intent, _move_y_intent);
    var _hspd = lengthdir_x(move_speed, _dir);
    var _vspd = lengthdir_y(move_speed, _dir);

    // Horizontal collision
    if (place_meeting(x + _hspd, y, obj_barrier)) {
        while (!place_meeting(x + sign(_hspd), y, obj_barrier)) x += sign(_hspd);
        _hspd = 0;
    }
    x += _hspd;

    // Vertical collision
    if (place_meeting(x, y + _vspd, obj_barrier)) {
        while (!place_meeting(x, y + sign(_vspd), obj_barrier)) y += sign(_vspd);
        _vspd = 0;
    }
    y += _vspd;

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
image_speed = anim_speed;
if (_target_anim_start != current_anim_start) {
    image_index = _target_anim_start;
} else {
    image_index = _target_anim_start + (image_index - _target_anim_start) mod _target_anim_frames;
}
current_anim_start  = _target_anim_start;
current_anim_frames = _target_anim_frames;