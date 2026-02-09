// --- Create Event for obj_npc1 ---
myName = "Greg";
isChallenger = false;  // Starts as a normal NPC
challenge_won = false; 
isInCutscene = false;

myPortrait = spr_npc1_portrait;
myVoice = snd_voice2; 
myFont = fnt_dialogue;
myInteractionDialogue = ["Go down the hall and go to room 101"];
myInteractionSpeaker = [id]; 

depth = -y;
persistent = true; 
visible = true;

// If Greg was given a target position by the hallway Greg, move there immediately
if (variable_global_exists("greg_target_x") && global.greg_target_x != -1) {
    x = global.greg_target_x;
    y = global.greg_target_y;
    
    // Reset so it doesn't happen again by accident
    global.greg_target_x = -1;
    global.greg_target_y = -1;
}