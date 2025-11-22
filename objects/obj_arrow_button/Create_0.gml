
// Visuals
box_width = 50;
box_height = 50;

// --- NEW CODE FOR HOLD & SCROLL ---
// How long to wait before scrolling (e.g., 0.5 seconds)
hold_delay_time = 0.5 * room_speed;

// How fast to scroll after the delay (e.g., 0.1 seconds)
scroll_speed_time = 0.1 * room_speed;

// This is our current timer
hold_timer = 0;

// This tracks if the mouse is over the button
mouse_is_over = false;