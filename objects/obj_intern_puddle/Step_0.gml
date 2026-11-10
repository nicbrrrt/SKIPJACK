/// @description obj_intern_puddle - Step Event
ripple_timer++;

// Check proximity to Jack
near_player = false;
if (instance_exists(obj_jack)) {
    var _d = point_distance(x, y, obj_jack.x, obj_jack.y);
    if (_d < 36) {
        near_player = true;
    }
}

// Mopping interaction
var _has_mop = (variable_global_exists("player_has_mop") && global.player_has_mop);

if (near_player && keyboard_check_pressed(ord("E"))) {
    // Single-target check: ensure Jack interacts with puddle if nearest
    if (!variable_global_exists("e_interact_step") || global.e_interact_step != current_time) {
        if (_has_mop) {
            global.e_interact_step = current_time;
            mop_meter += 0.25; // ~4-5 energetic presses to clean
            audio_play_sound(snd_button_hover, 10, false);
            audio_play_sound(snd_moveselect, 10, false); // whoosh / splash sound

            global.cam_shake_timer = 4;
            global.cam_shake_mag   = 1;

            if (mop_meter >= 1.0) {
                is_cleaned = true;
                audio_play_sound(snd_objective_complete, 10, false);
                instance_destroy();
                exit;
            }
        } else {
            // Player doesn't have mop!
            global.e_interact_step = current_time;
            audio_play_sound(snd_hurt, 10, false);
        }
    }
} else {
    // Gentle decay if player stops mopping halfway
    mop_meter = max(0.0, mop_meter - 0.004);
}
