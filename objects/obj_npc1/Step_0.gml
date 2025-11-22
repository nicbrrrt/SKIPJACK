// --- Step Event for obj_npc1 (and obj_npc2) ---

// Update depth every frame for correct sorting
depth = -y;

// --- FIX FOR "STOPS FOR A BIT" BUG ---
// This code assumes the NPC is always idle and just
// needs to animate. It sets the sprite ONCE.

if (sprite_index != spr_npc1_idle) // <-- THIS IS THE FIX
{
	sprite_index = spr_npc1_idle;
}

// Now that we know the sprite is correct, we can
// safely set the speed and let the loop logic run.
image_speed = 0.2; // Or your anim_speed variable


// --- ANIMATION LOOP LOGIC (The code you posted) ---
// This code "locks" the animation to the frames set by your variables
if (image_speed > 0) 
{
	// Check if we are on the wrong set of frames
	if (image_index < anim_start_frame || image_index >= anim_start_frame + anim_num_frames)
	{
		// If we are, jump to the first frame of the correct animation
		image_index = anim_start_frame;
	}

	// This math-based loop keeps the animation in its range
	image_index = anim_start_frame + (image_index - anim_start_frame) % anim_num_frames;
}