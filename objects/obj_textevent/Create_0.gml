// Existing variables... (myText, mySpeaker, etc.)

// --- CHOICE SYSTEM ADDITIONS ---
options = [];           // Array to hold choices like ["Answer A", "Answer B"]
current_option = 0;     // Which option is highlighted (0 = top, 1 = bottom)
choice_active = false;  // Are we currently picking an option?

//-----------Customise (FOR USER)
myVoice			= snd_voice2;
myTextCol		= c_white;
myPortrait		= -1;
myFont			= fnt_dialogue;
myName			= "Jack";

//-----------Setup (LEAVE THIS STUFF)
myTextbox   = noone;
reset_dialogue_defaults();