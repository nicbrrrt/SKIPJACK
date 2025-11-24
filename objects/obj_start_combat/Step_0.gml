// Check for E key press to start battle
if (visible && keyboard_check_pressed(ord("E"))) {
    var _player = instance_find(obj_jack, 0);
    
    // Check if player is close enough
    if (_player != noone && point_distance(x, y, _player.x, _player.y) < interaction_range) {
        show_debug_message("=== START COMBAT - E KEY PRESSED ===");
        visible = false;
        
        // Start battle
        with (obj_battle) {
            state = "PATH";
            cipher_key = 0;
            player_hp = 10;
            enemy_hp = 10;
            cipher_mode = "first";
        }
        instance_create_layer(0, 0, "Instances", obj_path);
    }
}