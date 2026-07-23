// --- Create Event for obj_atbash_combat_gui ---
// Self-contained JRPG mock battle with Atbash decryption

depth = -10000;

if (instance_exists(obj_jack)) {
    instance_deactivate_object(obj_jack);
}

// HP system
player_hp = 10;
enemy_hp  = 10;

// Word generation
word_bank = ["CAT", "KEY", "DOG", "SUN", "MAP", "RED", "FLY", "BOX", "PEN", "JAM"];

function generate_round() {
    plaintext = word_bank[irandom(array_length(word_bank) - 1)];
    encrypted = scr_atbash_decode(plaintext);
    letters_len = string_length(plaintext);
    player_input = array_create(letters_len, "");
    current_slot = 0;
}

// Combat phases
phase = "shield"; // "shield" | "attack"
generate_round();

// Animation state
fight_anim       = "idle";
fight_timer      = 0;
player_lunge     = 0;
enemy_lunge      = 0;
enemy_flash_timer = 0;
player_hurt_timer = 0;

// Feedback
shake_timer   = 0;
status_msg    = "";
text_color    = c_white;
success_timer = 0;
result_pending = "";

anim_timer = 0;

// Tutorial state
tutorial_active = false;
tutorial_phase = 0;
tutorial_timer = 0;
tutorial_auto_idx = 0;
tutorial_dialogue_pending = false;

if (variable_global_exists("atbash_combat_tutorial_done") && !global.atbash_combat_tutorial_done) {
    tutorial_active = true;
    myName = "Lea";
    myPortrait = spr_lea_portrait;
    myVoice = snd_voice1;
    myFont = fnt_dialogue;
    
    plaintext = "CAT";
    encrypted = scr_atbash_decode(plaintext);
    letters_len = string_length(plaintext);
    player_input = array_create(letters_len, "");
    current_slot = 0;
}
