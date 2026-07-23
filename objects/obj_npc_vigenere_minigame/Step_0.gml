event_inherited();
if (variable_global_exists("is_paused") && global.is_paused) exit;
if (!instance_exists(obj_jack)) exit;
if (instance_exists(obj_textevent)) exit;

if (point_distance(x, y, obj_jack.x, obj_jack.y) < interaction_range) {
    if (keyboard_check_pressed(ord("E"))) {
        if (global.vigenere_progress < 1) {
            create_textevent(["You need to learn the theory from the first instructor."], [id]);
        } else if (global.vigenere_progress >= 2) {
            create_textevent(["You've already passed practice! Go take the final test."], [id]);
        } else {
            var _te = create_textevent(["Ready to practice? I'll give you a keyword. Shift the letters backwards to decode!"], [id]);
            _te.destroy_action = method(undefined, function() {
                instance_create_layer(0, 0, "Instances", obj_vigenere_board_gui);
            });
        }
    }
}
