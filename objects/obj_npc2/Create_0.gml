// --- Interaction Dialogue ---
// Initialize the flag to control movement/actions during cutscenes
isInCutscene = false;

myInteractionDialogue = ["Use WASD to move and E for interact"];
myInteractionSpeaker = [self]; // 'self' means this NPC (obj_npc2)

// These variables tell the NPC which frames to play
anim_start_frame = 0; // Start at frame 0 (front idle)
anim_num_frames = 6;

// This makes the NPC sort correctly with the player
depth = -y;

myPortrait = spr_npc2_portrait;
myVoice = snd_voice2; // Or whatever your sound is named
myFont = fnt_dialogue; // Or whatever your font is named
myName = "Breado"; // Put their actual name here