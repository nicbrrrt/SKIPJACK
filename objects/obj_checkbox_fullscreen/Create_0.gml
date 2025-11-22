// 1. Stop the sprite from animating
image_speed = 0;

// 2. Check the window's *current* state (true=1, false=0)
var _is_full = window_get_fullscreen(); 

// 3. Set our sprite to match! (Frame 1 if full, Frame 0 if not)
image_index = _is_full;