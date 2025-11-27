// Move between slots with LEFT/RIGHT arrows
if (keyboard_check_pressed(vk_right)) {
    current_slot = min(current_slot + 1, letters_len - 1);
}
if (keyboard_check_pressed(vk_left)) {
    current_slot = max(current_slot - 1, 0);
}

// Change letters with UP/DOWN arrows
// Change letters with UP/DOWN arrows
if (keyboard_check_pressed(vk_up)) {
    if (player_input[current_slot] == "") {
        player_input[current_slot] = "A";
    } else {
        var current_char = player_input[current_slot];
        var new_index = (ord(current_char) - ord("A") + 1) mod 26;
        player_input[current_slot] = chr(ord("A") + new_index);
    }
    show_debug_message("CIPHER: Slot " + string(current_slot) + " changed to: " + player_input[current_slot]);
}

if (keyboard_check_pressed(vk_down)) {
    if (player_input[current_slot] == "") {
        player_input[current_slot] = "A";
    } else {
        var current_char = player_input[current_slot];
        var new_index = (ord(current_char) - ord("A") - 1 + 26) mod 26;
        player_input[current_slot] = chr(ord("A") + new_index);
    }
    show_debug_message("CIPHER: Slot " + string(current_slot) + " changed to: " + player_input[current_slot]);
}

// Also allow direct A-Z typing
for (var k = ord("A"); k <= ord("Z"); k++) {
    if (keyboard_check_pressed(k)) {
        player_input[current_slot] = chr(k);
    }
}

// Submit with ENTER
if (keyboard_check_pressed(vk_enter)) {
    var answer = "";
    for (var i = 0; i < letters_len; i++) {
        answer += player_input[i];
    }
    
    if (answer == plaintext) {
        // --- SUCCESS SEQUENCE ---
        if (success_timer == 0) { // Only trigger once
            text_color = c_lime;
            status_msg = "ACCESS GRANTED";
            // audio_play_sound(snd_success, 1, false); // Optional sound
            success_timer = 60; // Wait 1 second (60 frames) before closing
        }
    } else {
        // --- FAILURE SEQUENCE ---
        shake_timer = 10; // Shake for 10 frames
        text_color = c_red;
        status_msg = "ERROR: INVALID KEY";
        // audio_play_sound(snd_error, 1, false); // Optional sound
    }
}

// Handle the Success Delay
if (success_timer > 0) {
    success_timer--;
    if (success_timer <= 0) {
        // ACTUALLY FINISH THE GAME NOW
        show_debug_message("CIPHER SUCCESS!");
        with (obj_battle) event_user(1);
        instance_destroy();
    }
}

// Reduce shake over time
if (shake_timer > 0) shake_timer--;