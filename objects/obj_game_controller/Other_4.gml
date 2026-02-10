// --- Room Start Event for obj_game_controller ---

if (room == rm_level_1) {
    // 1. CODEX UPDATE: Only do this once
    if (!global.level1_intro_done) {
        // Add new definitions to your codex system here
        // Example: ds_list_add(global.codex_list, "Phishing", "Spyware", "Botnets");
        
        // 2. TRIGGER THE INTRO DIALOGUE
        // We use a slight delay or find Greg to speak
        var _greg = instance_find(obj_npc1, 0);
        if (_greg != noone) {
            with (_greg) {
                create_textevent([
                    "Welcome to the streets, Jack.",
                    "The system out here is crawling with malware. It's dangerous.",
                    "I've updated your Codex with definitions for Phishing, Spyware, and Botnets.",
                    "Come find me when you're ready to clear the sector."
                ], [id, id, id, id]);
            }
        }
        global.level1_intro_done = true; // Lock this so it doesn't repeat
    }
}

// Keep your existing rm_battle_scramble logic below this...
if (room == rm_battle_scramble) {
    if (!instance_exists(obj_battle_scramble)) {
        instance_create_depth(0, 0, -10000, obj_battle_scramble);
    }
}