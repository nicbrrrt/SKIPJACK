// Fade in
if (variable_global_exists("is_paused") && global.is_paused) exit;

if (alpha < 1) alpha += 0.1;

// Dismiss / advance page
if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {

    // If a page 2 image exists and we're still on page 1 — advance
    if (tutorial_image != -1 && page == 1) {
        page  = 2;
        alpha = 0; // reset fade so page 2 fades in cleanly
    }
    // Otherwise dismiss and spawn the minigame
    else {
        if (next_object != noone) {
            instance_create_layer(0, 0, "Instances", next_object);
        }
        instance_destroy();
    }
}
