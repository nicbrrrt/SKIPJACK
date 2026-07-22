event_inherited();

if (variable_global_exists("is_paused") && global.is_paused) exit;
if (!instance_exists(obj_jack)) exit;
if (instance_exists(obj_textevent)) exit;

if (point_distance(x, y, obj_jack.x, obj_jack.y) < interaction_range) {
    if (keyboard_check_pressed(ord("E"))) {
        if (global.atbash_progress < 2) {
            create_textevent(
                ["You're not ready yet. Complete the practice session first."],
                [id]
            );
        } else if (global.atbash_progress >= 3) {
            create_textevent(
                ["You've already proven yourself in combat. Head to the final test!"],
                [id]
            );
        } else {
            var _te = create_textevent(
                ["Think you're ready for a real challenge? My shields and attacks are encrypted with Atbash. Decrypt them to fight back!"],
                [id]
            );
            _te.destroy_action = method(undefined, function() {
                instance_create_layer(0, 0, "Instances", obj_atbash_combat_gui);
            });
        }
    }
}
