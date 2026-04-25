// obj_tutorial_controller — Alarm 0 Event
// Fires Greg's intro greeting. Player must press E to advance it.

if (instance_exists(obj_npc1)) {
    var _greg = instance_find(obj_npc1, 0);
    create_textevent(
        ["Hi, I'm Greg! Press E to continue.",
         "Great! Pressing E lets you interact with the world, and talk to us."],
        [_greg, _greg]
    );
    first_dialogue_shown = true;
}
