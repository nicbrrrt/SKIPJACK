// obj_battle_intro — Create Event
// Breado's pre-battle explanation overlay.
// Spawned by obj_battle_scramble's Alarm_0 on the very first battle.
//
// Phases:
//   0  Dialogue: Breado explains the mini-game and HP
//   1  Codex: force-open the codex so the player sees the Battle Basics page
//   2  Wait for player to close the codex
//   3  Done — destroy self so the battle can start

depth = -20000;
phase = 0;

// Give this object Breado's identity so create_textevent uses his portrait/voice.
myName      = "Breado";
myPortrait  = spr_breado_portrait;
myVoice     = snd_voice2;
myFont      = fnt_dialogue;

// Add a Battle Basics module to the codex so it's available immediately.
if (instance_exists(obj_codex_manager)) {
    with (obj_codex_manager) {
        unlocked = true;
        add_module(
            "BATTLE BASICS",
            "HP (Hit Points)\n" +
            "HP represents your health in battle.\n" +
            "Your HP bar appears on the right; the enemy's is on the left.\n\n" +
            "Goal: Deplete the enemy's HP to zero before they deplete yours.\n\n" +
            "How to attack:\n" +
            "  - Read the hint to find the target word.\n" +
            "  - Click or type letters to spell the word.\n" +
            "  - A correct word deals damage to the enemy.\n" +
            "  - A wrong turn lets the enemy attack you.\n\n" +
            "Use Backspace to erase your last letter if you make a mistake.\n" +
            "Press C at any time outside of battle to re-open this Codex."
        );
    }
}
