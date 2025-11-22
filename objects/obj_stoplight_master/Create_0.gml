// --- Create Event for obj_stoplight_master ---

// 1. Stop the sprite from animating on its own
image_speed = 0;

// 2. Start on the Red light (Frame 0)
image_index = 0;

// 3. Set Alarm 0 to go off in 5 seconds.
// room_speed is 1 second, so "room_speed * 5" is 5 seconds.
// This is the "Red Light" timer.
alarm[0] = room_speed * 5; // You can change the '5'