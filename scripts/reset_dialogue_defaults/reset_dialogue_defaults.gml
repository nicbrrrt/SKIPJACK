///@description reset_dialogue_defaults
function reset_dialogue_defaults() {

	// --- RUNTIME VARIABLES (Fixes the "page not set" crash) ---
	page			= 0;		// Which line of text we are on
	charCount		= 0;		// How many letters drawn so far
	finished		= false;	// If the typing effect is done

	// --- CHOICE SYSTEM VARIABLES (New) ---
	options			= [];		// Array to hold choices
	current_option	= 0;		// Which choice is highlighted
	choice_active	= false;	// Is the menu currently open?

	// --- SETUP DEFAULTS (Your existing list) ---
	myTextbox		= noone;
	myText			= -1;
	mySpeaker		= -1;
	myEffects		= -1; // Changed to -1 (no effect) usually safer than 0
	myTextSpeed		= -1; // -1 lets the object choose the default speed
	myTypes			= -1;
	myNextLine		= 0;
	myScripts		= -1;
	myTextCol		= -1;
	myEmotion		= -1;
	myEmote			= -1;

}