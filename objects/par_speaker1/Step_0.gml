// par_speaker1 — Step Event
// FIXED: Added instance_exists() guard (was crashing when playerobject was destroyed)
var dr = detection_radius;

if (!instance_exists(playerobject)) exit; // CRASH FIX: was missing this guard

if (point_in_rectangle(playerobject.x, playerobject.y, x-dr, y-dr, x+dr, y+dr)) {
    if (myTextbox != noone) { 
        if (!instance_exists(myTextbox)) { myTextbox = noone; exit; }
    }
    else if (keyboard_check_pressed(interact_key)) {
        if (instance_exists(obj_textbox)) { exit; }
        event_user(0);
        create_dialogue(myText, mySpeaker, myEffects, myTextSpeed, myTypes, myNextLine, myScripts, myTextCol, myEmotion, myEmote);
    }
} else {
    if (myTextbox != noone) {
        with(myTextbox) instance_destroy();
        myTextbox = noone;
    }
}