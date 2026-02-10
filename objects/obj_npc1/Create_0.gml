// --- Create Event for obj_npc1 ---
myName = "Greg";
isChallenger = false;  
challenge_won = false; 
isInCutscene = false;

myPortrait = spr_npc1_portrait;
myVoice = snd_voice2; 
myFont = fnt_dialogue;

depth = -y;
persistent = false; // <--- CHANGE THIS TO FALSE
visible = true;

// Handle snapping if global targets exist
if (variable_global_exists("greg_target_x") && global.greg_target_x != -1) {
    x = global.greg_target_x;
    y = global.greg_target_y;
    global.greg_target_x = -1;
    global.greg_target_y = -1;
}

if (variable_global_exists("greg_defeated") && global.greg_defeated == true) {
    instance_destroy();
}