// obj_tutorial_controller — Alarm 0 Event
// Fires Greg's welcome intro. Player presses E to advance each line.

if (instance_exists(obj_npc1)) {
    var _greg = instance_find(obj_npc1, 0);
    create_textevent(
        [
            "Welcome to SKIPJACK!",
            "SKIPJACK is a 2D top-down adventure built around cryptography.",
            "You'll explore, talk to people, and learn to crack ciphers — then use what you learn to push back against digital threats.",
            "Press E to continue through dialogue, just like you're doing right now."
        ],
        [_greg, _greg, _greg, _greg]
    );
    first_dialogue_shown = true;
}
