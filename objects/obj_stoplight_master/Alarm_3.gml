// --- Alarm 3 Event (Yellow -> Red) ---

// 1. Change back to the Red light (Frame 0)
image_index = 0;

// 2. Set Alarm 0 (Red Light Timer) to restart the entire cycle
alarm[0] = room_speed * 5;