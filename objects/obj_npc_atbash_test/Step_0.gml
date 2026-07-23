event_inherited();

if (variable_global_exists("is_paused") && global.is_paused) exit;
if (!instance_exists(obj_jack)) exit;
if (instance_exists(obj_textevent)) exit;
if (obj_jack.isInCutscene) exit;

if (point_distance(x, y, obj_jack.x, obj_jack.y) < interaction_range) {
    if (keyboard_check_pressed(ord("E"))) {
        if (global.atbash_progress < 3) {
            create_textevent(
                ["You need to complete the combat challenge first."],
                [id]
            );
        } else if (global.atbash_progress >= 4) {
            create_textevent(
                ["You've already passed the final test. The Atbash module is complete! Well done."],
                [id]
            );
        } else {
            var _te = create_textevent(
                ["This is the final evaluation. No hints, no help. Decode three words using pure Atbash knowledge. Good luck."],
                [id]
            );
            _te.destroy_action = method(undefined, function() {
                instance_create_layer(0, 0, "Instances", obj_atbash_test_gui);
            });
        }
    }
}
