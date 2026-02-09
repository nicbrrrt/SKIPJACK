//STEP
// --- 1. Check if mouse is over the button ---
var _mouse_x = mouse_x;
var _mouse_y = mouse_y;
mouse_is_over = point_in_rectangle(_mouse_x, _mouse_y, x, y, x + box_width, y + box_height);

// --- 2. Check for FIRST click (Pressed) ---
// This happens ONCE when you first click
if (mouse_check_button_pressed(mb_left) && mouse_is_over)
{
    // 1. Change the number immediately
    obj_caesar_controller.current_shift += shift_direction;
    
    // 2. Set the initial delay timer
    hold_timer = hold_delay_time;
}
// --- 3. Check for HOLD (Held down) ---
// This happens EVERY FRAME while you hold the button
else if (mouse_check_button(mb_left) && mouse_is_over)
{
    // 1. Count down the timer
    hold_timer--;
    
    // 2. Check if the timer is up
    if (hold_timer <= 0)
    {
        // Timer is done, so scroll!
        // a. Change the number
        obj_caesar_controller.current_shift += shift_direction;
        
        // b. Reset the timer to the *fast* scroll speed
        hold_timer = scroll_speed_time;
    }
}
// --- 4. Check for RELEASE (Not held) ---
else
{
    // The mouse is not pressed, or not over us
    // Reset the timer
    hold_timer = 0;
}