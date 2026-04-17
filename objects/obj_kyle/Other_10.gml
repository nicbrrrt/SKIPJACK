// User Event 0 — Kyle's interaction handler
if (instance_exists(obj_textevent) || gui_open) exit;

// STATE: Lesson already done — let the player re-read the panel any time
if (global.kyle_lesson_done) {
    gui_open = true;
    if (instance_exists(obj_jack)) obj_jack.isInCutscene = true;
    exit;
}

// STATE: First interaction — show intro, then GUI opens via Step_0
if (!showed_intro) {
    create_textevent([
        "Hey! I'm Kyle. You must be Jack.",
        "I've been asked to get you up to speed on the Caesar Cipher.",
        "It's the foundation of everything we do here.",
        "Take a look at my notes."
    ], [id, id, id, id]);
    showed_intro = true;
    global.quest_talk_to_kyle = false;
    exit;
}

// STATE: Intro shown but panel not yet opened (edge case — force-open it)
gui_open = true;
if (instance_exists(obj_jack)) obj_jack.isInCutscene = true;
