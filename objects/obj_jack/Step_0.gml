// --- Top of Step Event for obj_jack ---
depth = -y;

// THE GHOST FIX: Hide Jack when in the combat room
if (room == rm_combat) {
    visible = false;
    exit; // Stop all logic while in battle
} else {
    visible = true;
}
// --------------------------------------

var can_move = true;

// ... (Rest of your existing code: isInCutscene check, keyboard input, etc.) ...

// Only run movement, collision, animation, and interaction code if NOT in a cutscene
// Freeze if in cutscene OR if a transition exists OR if battle is active
if (isInCutscene || instance_exists(obj_transition) || (instance_exists(obj_path) || instance_exists(obj_cipher) || instance_exists(obj_qte))) 
{
    // Optional: Stop animation so he doesn't "moonwalk"
    image_speed = 0; 
    image_index = 0; 
    
    exit; // Stop all movement code below
} 

{	
	// --- Player Interaction ---
	var _interact_key = keyboard_check_pressed(ord("E"));

	// Inside obj_jack Step Event -> Interaction section

	if (_interact_key)
	{
		var _npc = instance_nearest(x, y, par_npc);
    
    // Check if that NPC is valid AND close enough (24 pixels)
		if (_npc != noone && point_distance(x, y, _npc.x, _npc.y) < 24)
    {
        // CORRECT WAY: Use 'with' to make the NPC run the code
        with (_npc)
        {
            event_user(0); 
        }
    }
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

    // 3. These will hold our chosen animation
    var _target_anim_start;
    var _target_anim_frames = anim.frames_per_anim;

    // 4. --- LOGIC & MOVEMENT (FIXED WITH COLLISION) ---
    if (_is_moving)
    {
        sprite_index = spr_jack_walk;
        
        // Calculate final speeds (horizontal and vertical components)
        var _dir = point_direction(0, 0, _move_x_intent, _move_y_intent);
        var _hspd = lengthdir_x(move_speed, _dir);
        var _vspd = lengthdir_y(move_speed, _dir);

        // --- HORIZONTAL COLLISION ---
        // Assets checked: Tile Maps, obj_wall, and Tile Set ts_lab
        var _solid_assets_h = [my_tilemap, wall_layer_1, wall_layer_2, wall_layer_main, tilemap1, tilemap2, tilemap3, tilemap4, tilemap5, obj_wall]; 

        if (place_meeting(x + _hspd, y, _solid_assets_h))
        {
            while (!place_meeting(x + sign(_hspd), y, _solid_assets_h))
            {
                x += sign(_hspd);
            }
            _hspd = 0; // Stop movement
        }
        x += _hspd; // Apply remaining horizontal movement

        // --- VERTICAL COLLISION ---
        // Assets checked: Includes ts_lab now for consistency
        var _solid_assets_v = [my_tilemap, wall_layer_1, wall_layer_2, wall_layer_main, tilemap1, tilemap2, tilemap3, tilemap4, tilemap5, obj_wall]; // FIXED: Added ts_lab

        if (place_meeting(x, y + _vspd, _solid_assets_v))
        {
            while (!place_meeting(x, y + sign(_vspd), _solid_assets_v))
            {
                y += sign(_vspd);
            }
            _vspd = 0; // Stop movement
        }
        y += _vspd; // Apply remaining vertical movement

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
    else // --- WE ARE NOT MOVING (IDLE) ---
    {
        sprite_index = spr_jack_idle;
        
        // CHOOSE IDLE ANIMATION
        if (last_move_x > 0) // Right
        {
            _target_anim_start = anim.right_start;
        }
        else if (last_move_x < 0) // Left
        {
            _target_anim_start = anim.left_start;
        }
        else if (last_move_y > 0) // Down
        {
            _target_anim_start = anim.down_start;
        }
        else // Up
        {
            _target_anim_start = anim.up_start;
        }
    }

    // 5. --- APPLY ANIMATION SPEED & LOOP ---
    image_speed = anim_speed;

    // This logic is correct for fixing the frame "glitch"
    if (_target_anim_start != current_anim_start)
    {
        image_index = _target_anim_start;
    }
    else
    {
        image_index = _target_anim_start + (image_index - _target_anim_start) mod _target_anim_frames;
    }

    // Store the animation we're playing for the next frame
    current_anim_start = _target_anim_start;
    current_anim_frames = _target_anim_frames;
} // <--- Movement is now blocked outside this line