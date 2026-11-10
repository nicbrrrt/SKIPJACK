/// @description obj_intern_mop_station - Step Event
near_player = false;
if (instance_exists(obj_jack)) {
    if (point_distance(x + 8, y + 8, obj_jack.x, obj_jack.y) < 26) {
        near_player = true;
    }
}

if (near_player && keyboard_check_pressed(ord("E"))) {
    if (!variable_global_exists("e_interact_step") || global.e_interact_step != current_time) {
        global.e_interact_step = current_time;

        if (variable_global_exists("held_intern_inst") && global.held_intern_inst != noone) {
            // Cannot equip tool while carrying an intern!
            audio_play_sound(snd_error, 10, false);
            with (obj_intern_ward_controller) {
                hands_full_alert = 90;
            }
            exit;
        }

        if (!variable_global_exists("player_has_mop")) {
            global.player_has_mop = false;
        }

        if (!global.player_has_mop) {
            // Equip mop! Put away wrench if held
            global.player_has_mop    = true;
            global.player_has_wrench = false;
            audio_play_sound(snd_button_hover, 10, false);
            audio_play_sound(snd_objective_complete, 10, false);
        } else {
            // Return / put away mop
            global.player_has_mop = false;
            audio_play_sound(snd_button_hover, 10, false);
        }
    }
}
