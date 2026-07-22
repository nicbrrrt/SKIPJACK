// --- Create Event for obj_atbash_mirror_gui ---
// Alphabet mirror reference overlay (spawned after NPC 1 theory dialogue)

depth = -15000;

if (instance_exists(obj_jack)) {
    obj_jack.isInCutscene = true;
}

// Build alphabet arrays for display
alpha_top    = ["A","B","C","D","E","F","G","H","I","J","K","L","M"];
alpha_bottom = ["Z","Y","X","W","V","U","T","S","R","Q","P","O","N"];

// Animation timer for visual polish
anim_timer = 0;
