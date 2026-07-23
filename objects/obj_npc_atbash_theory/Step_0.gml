event_inherited();

if (variable_global_exists("is_paused") && global.is_paused) exit;
if (!instance_exists(obj_jack)) exit;
if (instance_exists(obj_textevent)) exit;
if (obj_jack.isInCutscene) exit;

if (point_distance(x, y, obj_jack.x, obj_jack.y) < interaction_range) {
    if (keyboard_check_pressed(ord("E"))) {
        if (global.atbash_progress >= 1) {
            create_textevent(
                ["You've already learned the theory! Go practice with the next instructor."],
                [id]
            );
        } else {
            var _te = create_textevent(
                [
                    "Welcome! I'm here to teach you about the Atbash Cipher.",
                    "Atbash is one of the oldest known ciphers, originally used with the Hebrew alphabet.",
                    "It works like a mirror. Imagine folding the alphabet in half at the middle.",
                    "A becomes Z, B becomes Y, C becomes X... all the way to M becoming N.",
                    "The beauty of Atbash is that encoding and decoding are the SAME operation!",
                    "Let me show you the mirror reference chart..."
                ],
                [id, id, id, id, id, id]
            );
            _te.destroy_action = method(undefined, function() {
                instance_create_layer(0, 0, "Instances", obj_atbash_mirror_gui);
            });
        }
    }
}
