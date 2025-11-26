// --- Create Event of obj_qte ---

// 1. SETUP GUI & POSITIONS
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// Start at Enemy Position (Right)
x = gui_w * 0.85; 
y = gui_h * 0.6;

// Target Player Position (Left)
target_x = gui_w * 0.15;
target_y = y;

// 2. SETUP QTE LOGIC
pattern_length = irandom_range(3, 5); 
pattern = array_create(pattern_length);
var dirs = [vk_up, vk_down, vk_left, vk_right];

for (var i = 0; i < pattern_length; i++) {
    pattern[i] = dirs[irandom(3)];
}

index = 0;
active = true;

// 3. TIMER & MOVEMENT
// We want the packet to travel the distance exactly as the timer runs out.
timer = room_speed * 4; // 4 seconds

var distance_to_travel = target_x - x;
hspeed = distance_to_travel / timer; // GameMaker engine moves 'x' automatically

show_debug_message("QTE: Projectile launched! Speed: " + string(hspeed));