// --- Mouse Left Pressed Event for obj_button_review ---

audio_stop_sound(snd_button_hover);
audio_play_sound(snd_button_click, 10, false);

// Destroy any stale instance before opening a fresh one
if (instance_exists(obj_review_screen))
    instance_destroy(obj_review_screen);

instance_create_layer(0, 0, "Instances", obj_review_screen);
