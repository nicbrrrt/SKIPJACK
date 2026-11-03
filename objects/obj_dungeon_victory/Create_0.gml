/// @description obj_dungeon_victory — Create Event
/// Extraction Elevator Incident Debrief Report Card shown when completing a dungeon floor.
/// Summarizes the Cybersecurity Attack Vector neutralized and Cryptography lesson learned.

depth = -15000;

// Freeze Jack while the victory screen is active
if (instance_exists(obj_jack)) {
    obj_jack.isInCutscene = true;
}

phase        = "fade_in"; // "fade_in" | "display" | "fade_out"
phase_timer  = 0;
anim_timer   = 0;
screen_alpha = 0;
next_action  = "next_dungeon"; // "next_dungeon" | "menu"

cleared_count = variable_global_exists("dungeons_cleared") ? global.dungeons_cleared : 1;
clues_total   = variable_global_exists("clues_found")      ? global.clues_found      : 0;
floor_key     = variable_global_exists("dungeon_cipher_key") ? global.dungeon_cipher_key : 3;

var _case = variable_global_exists("floor_case")
    ? global.floor_case
    : scr_get_floor_incident_case(0);

case_word     = _case.word;
case_title    = _case.title;
case_hint     = _case.hint;
case_takeaway = _case.takeaway;

// Rotating Cryptography / Cryptanalysis facts for the debrief card
var _crypto_facts = [
    "CRYPTO FACT: Because a Caesar Cipher has only 25 possible shift keys, any modern computer can brute-force all 25 possibilities in less than a microsecond!",
    "CRYPTO FACT: Matching one Encrypted letter to one known Plaintext letter (a 'Known-Plaintext Attack') immediately reveals the entire Caesar Shift Key!",
    "CRYPTO FACT: Even if you don't know the key, 'Frequency Analysis' breaks Caesar ciphers by checking which encrypted letter appears most often (usually 'E' in English)!",
    "CRYPTO FACT: Modern encryption (like AES-256) uses 2^256 possible keys instead of 25 — more keys than there are atoms in the observable universe!"
];
crypto_fact = _crypto_facts[(cleared_count - 1) mod array_length(_crypto_facts)];

// Decorative background particles
stars = [];
for (var i = 0; i < 24; i++) {
    array_push(stars, {
        sx:  irandom(640),
        sy:  irandom(360),
        spd: 0.3 + random(0.7),
        sz:  1 + random(2),
        ang: random(360)
    });
}
