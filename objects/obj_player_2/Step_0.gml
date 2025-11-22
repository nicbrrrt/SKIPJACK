// --- Step Event for obj_player ---
depth = -y;
// 1. Set our walk speed
var _move_speed = 2.5; 

// 2. Get keyboard input (W, A, S, D and Arrow Keys)
var _key_right = keyboard_check(ord("D")) || keyboard_check(vk_right);
var _key_left = keyboard_check(ord("A")) || keyboard_check(vk_left);
var _key_up = keyboard_check(ord("W")) || keyboard_check(vk_up);
var _key_down = keyboard_check(ord("S")) || keyboard_check(vk_down);

// 3. Calculate horizontal & vertical "intent"
var _move_x_intent = _key_right - _key_left; 
var _move_y_intent = _key_down - _key_up; // We still need this for Y movement

// 4. Check if we are moving
var _is_moving = (_move_x_intent != 0 || _move_y_intent != 0);

// These will hold our chosen animation
var _target_anim_start;
var _target_anim_frames;


// 5. --- LOGIC ---
if (_is_moving)
{
    // --- SET SPRITE & ANIM ---
    sprite_index = spr_walk; // Use the walking sprite
    image_speed = anim_speed; // Play the animation
    
    // --- MOVEMENT & NEW COLLISION CODE ---
    var _dir = point_direction(0, 0, _move_x_intent, _move_y_intent);
    var _hspd = lengthdir_x(_move_speed, _dir);
    var _vspd = lengthdir_y(_move_speed, _dir);
    
    // Check for horizontal collision BEFORE moving
    if (!place_meeting(x + _hspd, y, obj_wall))
    {
        // No wall, so it's safe to move
        x = x + _hspd;
    }
    
    // Check for vertical collision BEFORE moving
    if (!place_meeting(x, y + _vspd, obj_wall))
    {
        // No wall, so it's safe to move
        y = y + _vspd;
    }
    // --- END of new collision code ---
    
    // --- CHOOSE ANIMATION (Left/Right ONLY) ---
    // This is the new part
    if (_move_x_intent != 0)
    {
        // If moving L/R, set the anim and store this as our last direction
        if (_move_x_intent > 0)
        {
            _target_anim_start = anim_walk_data.right_start;
            last_move_x = 1;
        }
        else
        {
            _target_anim_start = anim_walk_data.left_start;
            last_move_x = -1;
        }
    }
    else
    {
        // If *only* moving Up/Down, just use the last direction we faced
        if (last_move_x > 0)
        {
            _target_anim_start = anim_walk_data.right_start;
        }
        else
        {
            _target_anim_start = anim_walk_data.left_start;
        }
    }
    _target_anim_frames = anim_walk_data.frames_per_anim;
}
else // --- WE ARE NOT MOVING ---
{
    // --- SET SPRITE & ANIM ---
    sprite_index = spr_idle; // Use the idle sprite
    image_speed = anim_speed; // Play the animation
    
    // --- CHOOSE ANIMATION (Front ONLY) ---
    _target_anim_start = anim_idle_data.front_start;
    _target_anim_frames = anim_idle_data.frames_per_anim;
}

// 6. --- APPLY ANIMATION LOOP ---
// This code is unchanged and works perfectly.

// Check if we are on the wrong set of frames
if (image_index < _target_anim_start || image_index >= _target_anim_start + _target_anim_frames)
{
    // If we are, jump to the first frame of the correct animation
    image_index = _target_anim_start;
}

// This math-based loop keeps the animation in its range
image_index = _target_anim_start + (image_index - _target_anim_start) % _target_anim_frames;

// Store the animation we're playing for the next frame
current_anim_start = _target_anim_start;
current_anim_frames = _target_anim_frames;