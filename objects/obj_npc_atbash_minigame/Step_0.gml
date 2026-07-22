event_inherited();

if (variable_global_exists("is_paused") && global.is_paused) exit;
if (!instance_exists(obj_jack)) exit;
if (instance_exists(obj_textevent)) exit;

if (point_distance(x, y, obj_jack.x, obj_jack.y) < interaction_range) {
    if (keyboard_check_pressed(ord("E"))) {
        if (global.atbash_progress < 1) {
            create_textevent(
                ["Hold on! You need to learn the theory first. Go talk to Mirror."],
                [id]
            );
        } else if (global.atbash_progress >= 2) {
            create_textevent(
                ["Nice work! You've already cleared the practice. Move on to the combat challenge!"],
                [id]
            );
        } else {
            var _te = create_textevent(
                ["Ready to practice? I'll give you two words to decode using the Atbash mirror. You'll have hints to help you!"],
                [id]
            );
            _te.destroy_action = method(undefined, function() {
                instance_create_layer(0, 0, "Instances", obj_atbash_board_gui);
            });
        }
    }
}
