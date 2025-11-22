depth = -99999;

// --- THIS IS THE LINE THAT FIXES YOUR CRASH ---
current_hint = 0; // Default to showing the 'Press E' hint
// ----------------------------------------------

// --- Text Content ---
hint_messages = [
    "Press 'E' to Continue...", // Hint 0
    "Use WASD or Arrows to Move" // Hint 1
];

// --- Control Variables ---
hint_font = fnt_dialogue; 
hint_color = c_yellow;

// --- Timer for the WASD hint ---
wasd_max_time = room_speed * 8; // 8 seconds
wasd_timer = wasd_max_time; 

// --- Grace Period ---
grace_period = 30;