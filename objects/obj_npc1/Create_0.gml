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