// QTE configuration
pattern_length = irandom_range(3, 5); // 3-5 arrow sequence
pattern = array_create(pattern_length);
var dirs = [vk_up, vk_down, vk_left, vk_right];
var dir_labels = ["↑", "↓", "←", "→"]; // For display

// Generate random pattern
for (var i = 0; i < pattern_length; i++) {
    var dir_index = irandom_range(0, 3);
    pattern[i] = dirs[dir_index];
}

timer = room_speed * 4; // 4 seconds to complete
index = 0; // Current pattern step
active = true;

show_debug_message("QTE: Pattern length " + string(pattern_length));
show_debug_message("QTE: You have " + string(timer / room_speed) + " seconds!");