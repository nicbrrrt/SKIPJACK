event_inherited();
if (variable_global_exists("is_paused") && global.is_paused) exit;
if (!instance_exists(obj_jack)) exit;
if (instance_exists(obj_textevent)) exit;

if (point_distance(x, y, obj_jack.x, obj_jack.y) < interaction_range) {
    if (keyboard_check_pressed(ord("E"))) {
        if (global.vigenere_progress < 2) {
            create_textevent(["You aren't ready for the final evaluation yet. Go practice."], [id]);
        } else if (global.vigenere_progress >= 3) {
            create_textevent(["You have mastered the VigenÃ¨re cipher. Excellent work!"], [id]);
        } else {
            var _te = create_textevent(["This is the final test. Three words to decode. Let's see what you can do."], [id]);
            _te.destroy_action = method(undefined, function() {
                instance_create_layer(0, 0, "Instances", obj_vigenere_test_gui);
            });
        }
    }
}
