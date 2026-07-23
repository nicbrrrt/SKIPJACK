// --- User Event 0 (Interact) for par_npc ---

// Don't talk if dialogue is already open or we're in a cutscene
if (instance_exists(obj_textevent) || isInCutscene) 
{ 
    exit; 
}

// If an NPC implements its own custom interaction logic in Step_0, it might not have these defined.
if (!variable_instance_exists(id, "myInteractionDialogue") || !variable_instance_exists(id, "myInteractionSpeaker")) {
    exit;
}

// Create the dialogue!
// It will use the variables from whichever child NPC was interacted with.
create_textevent(myInteractionDialogue, myInteractionSpeaker);