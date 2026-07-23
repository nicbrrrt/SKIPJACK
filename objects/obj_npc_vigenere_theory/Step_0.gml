event_inherited();
if (variable_global_exists("is_paused") && global.is_paused) exit;
if (!instance_exists(obj_jack)) exit;
if (instance_exists(obj_textevent)) exit;

if (point_distance(x, y, obj_jack.x, obj_jack.y) < interaction_range) {
    if (keyboard_check_pressed(ord("E"))) {
        if (global.vigenere_progress >= 1) {
            create_textevent(["You know the theory! Go try the practice board."], [id]);
        } else {
            var _te = create_textevent(
                [
                    "Welcome! Let's talk about the VigenÃ¨re Cipher.",
                    "Unlike Caesar which shifts everything by one number, VigenÃ¨re uses a KEYWORD.",
                    "Each letter of the keyword determines how much to shift the plaintext.",
                    "Let me show you a quick guide..."
                ],
                [id, id, id, id]
            );
            _te.destroy_action = method(undefined, function() {
                instance_create_layer(0, 0, "Instances", obj_vigenere_theory_gui);
            });
        }
    }
}
