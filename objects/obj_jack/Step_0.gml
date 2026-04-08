// --- Top of Step Event for obj_jack ---
depth = -y;

// THE GHOST FIX: Hide Jack when in the combat room
if (room == rm_combat) {
    visible = false;
    exit; 
} else {
    visible = true;
}

// --- CUTSCENE / TRANSITION FREEZE ---
if (isInCutscene || instance_exists(obj_transition) || (instance_exists(obj_path) || instance_exists(obj_cipher) || instance_exists(obj_qte))) 
{
    image_speed = 0; 
    image_index = 0; 
    exit; 
} 

{	
    // --- Player Interaction ---
    var _interact_key = keyboard_check_pressed(ord("E"));

    if (_interact_key)
    {
        // Find the nearest interactable NPC.
        // We check par_npc children first, but also explicitly check
        // obj_clipper and obj_lea in case their parent isn't registered
        // (GameMaker sometimes caches old .yy parent relationships).
        var _best = noone;
        var _best_dist = 24; // interaction radius in pixels

        var _p = instance_nearest(x, y, par_npc);
        if (_p != noone) {
            var _d = point_distance(x, y, _p.x, _p.y);
            if (_d < _best_dist) { _best = _p; _best_dist = _d; }
        }

        var _c = instance_nearest(x, y, obj_clipper);
        if (_c != noone) {
            var _d = point_distance(x, y, _c.x, _c.y);
            if (_d < _best_dist) { _best = _c; _best_dist = _d; }
        }

        var _l = instance_nearest(x, y, obj_lea);
        if (_l != noone) {
            var _d = point_distance(x, y, _l.x, _l.y);
            if (_d < _best_dist) { _best = _l; _best_dist = _d; }
        }

        // DEBUG: remove once interaction is confirmed working
        show_debug_message("INTERACT: par_npc=" + string(_p) + " clipper=" + string(_c) + " lea=" + string(_l) + " chosen=" + string(_best));

        if (_best != noone) { with (_best) { event_user(0); } }
    }
	
    // 1. Get keyboard input
    var _key_right = keyboard_check(ord("D")) || keyboard_check(vk_right);
    var _key_left = keyboard_check(ord("A")) || keyboard_check(vk_left);
    var _key_up = keyboard_check(ord("W")) || keyboard_check(vk_up);
    var _key_down = keyboard_check(ord("S")) || keyboard_check(vk_down);

    // 2. Calculate movement intent
    var _move_x_intent = _key_right - _key_left; 
    var _move_y_intent = _key_down - _key_up; 
    var _is_moving = (_move_x_intent != 0 || _move_y_intent != 0);

    var _target_anim_start;
    var _target_anim_frames = anim.frames_per_anim;

    // 4. --- LOGIC & MOVEMENT (USING OBJ_BARRIER) ---
    if (_is_moving)
    {
        sprite_index = spr_jack_walk;
        
        var _dir = point_direction(0, 0, _move_x_intent, _move_y_intent);
        var _hspd = lengthdir_x(move_speed, _dir);
        var _vspd = lengthdir_y(move_speed, _dir);

        // --- HORIZONTAL COLLISION ---
        if (place_meeting(x + _hspd, y, obj_barrier))
        {
            while (!place_meeting(x + sign(_hspd), y, obj_barrier))
            {
                x += sign(_hspd);
            }
            _hspd = 0;
        }
        x += _hspd;

        // --- VERTICAL COLLISION ---
        if (place_meeting(x, y + _vspd, obj_barrier))
        {
            while (!place_meeting(x, y + sign(_vspd), obj_barrier))
            {
                y += sign(_vspd);
            }
            _vspd = 0;
        }
        y += _vspd;

        // CHOOSE WALK ANIMATION 
        if (_move_x_intent != 0)
        {
            last_move_x = _move_x_intent;
            last_move_y = 0;
            _target_anim_start = (_move_x_intent > 0) ? anim.right_start : anim.left_start;
        }
        else if (_move_y_intent != 0)
        {
            last_move_x = 0;
            last_move_y = _move_y_intent;
            _target_anim_start = (_move_y_intent > 0) ? anim.down_start : anim.up_start;
        }
        else
        {
            _target_anim_start = current_anim_start;
        }
    }
    else // --- IDLE ---
    {
        sprite_index = spr_jack_idle;
        
        if (last_move_x > 0) _target_anim_start = anim.right_start;
        else if (last_move_x < 0) _target_anim_start = anim.left_start;
        else if (last_move_y > 0) _target_anim_start = anim.down_start;
        else _target_anim_start = anim.up_start;
    }

    // 5. --- ANIMATION SYSTEM ---
    image_speed = anim_speed;

    if (_target_anim_start != current_anim_start)
    {
        image_index = _target_anim_start;
    }
    else
    {
        image_index = _target_anim_start + (image_index - _target_anim_start) mod _target_anim_frames;
    }

    current_anim_start = _target_anim_start;
    current_anim_frames = _target_anim_frames;
}