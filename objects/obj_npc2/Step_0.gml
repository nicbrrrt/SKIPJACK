// --- Step Event for obj_npc2 ---

// Update depth every frame for correct sorting
depth = -y;

// --- ONLY run default "idle" logic if NOT in a cutscene ---
if (!isInCutscene)
{
    // This is the code that was causing the bug.
    // Now it will only run when the cutscene is over.
    if (sprite_index != spr_npc2_idle)
    {
        sprite_index = spr_npc2_idle;
    }
    
    // Set your default animation for when the NPC is just standing around
    anim_start_frame = 0; // Default "look right"
    anim_num_frames = 6;
    image_speed = 0.2; // Or your anim_speed
}


// --- This animation loop runs ALL THE TIME ---
// This part is dumb: it just plays whatever animation
// the code above (or the cutscene controller) told it to.
if (image_speed > 0) 
{
	if (image_index < anim_start_frame || image_index >= anim_start_frame + anim_num_frames)
	{
		image_index = anim_start_frame;
	}
	image_index = anim_start_frame + (image_index - anim_start_frame) % anim_num_frames;
}