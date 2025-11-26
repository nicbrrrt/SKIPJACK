// Fade in effect
if (alpha < 1) alpha += 0.1;

// Input to Dismiss
if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
    
    // 1. Spawn the actual minigame now
    if (next_object != noone) {
        instance_create_layer(0, 0, "Instances", next_object);
    }
    
    // 2. Destroy this tutorial
    instance_destroy();
}