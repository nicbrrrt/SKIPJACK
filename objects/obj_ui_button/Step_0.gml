// --- Step Event of obj_ui_button ---

// 1. EXIT IMMEDIATELY IF IN COMBAT
// This prevents the button from being clickable (and avoids conflicts with typing 'C')
if (room == rm_combat || room == rm_battle_scramble) exit;

// 2. ONLY RUN IF TUTORIAL IS COMPLETE
if (global.tutorial_complete) {
    
    // 3. DEFINE BUTTON POSITION (Crucial: these must be defined before use!)
    var gui_w = display_get_gui_width();
    var button_x = gui_w - 60;
    var button_y = 60;
    var range = 40; 

    // 4. GET MOUSE POSITION ON THE GUI LAYER
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    // 5. CLICK DETECTION
    if (mouse_check_button_pressed(mb_left)) {
        // Check if mouse is within 'range' of the button center
        if (point_distance(_mx, _my, button_x, button_y) < range) {
            
            // 6. TOGGLE THE CODEX VIA THE MANAGER
            if (instance_exists(obj_codex_manager) && !instance_exists(obj_textevent)) {
                with(obj_codex_manager) {
                    is_open = !is_open; // Flip the switch
                    
                    // Freeze/Unfreeze Jack
                    if (instance_exists(obj_jack)) {
                        obj_jack.isInCutscene = is_open;
                        obj_jack.image_speed = 0;
                    }
                }
                show_debug_message("SYSTEM: Codex toggled via Mouse Button.");
            }
        }
    }
}