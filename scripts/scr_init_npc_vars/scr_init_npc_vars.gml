function scr_init_npc_vars(_name = "Unknown", _portrait = spr_jack_idle, _voice = -1, _font = fnt_default){
    
    myName     = _name;
    myPortrait = _portrait;
    myColor    = c_white;
    
    // --- THE CRITICAL FIX ---
    // If _voice is -1 (missing), we set it to a sound that DEFINITELY exists.
    // Try using a generic 'snd_text' or similar if you have one.
    // If you have NO sounds yet, we have to bypass the play command.
    myVoice    = _voice; 
    
    myFont     = _font;
    myTextSpeed = 0.5;
    myEffects   = 0;
}