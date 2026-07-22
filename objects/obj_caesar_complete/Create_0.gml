// --- Create Event for obj_caesar_complete ---
// Congratulations / credits screen shown after defeating the Caesar Cipher final boss.
// Displays a victory message, credits the NPCs met, and announces the Atbash unlock.

depth = -15000;

// Freeze player
if (instance_exists(obj_jack)) {
    obj_jack.isInCutscene = true;
}

// Hide boss if still visible
var _boss = instance_find(obj_final_boss_placeholder, 0);
if (_boss != noone) {
    with (_boss) { visible = false; }
}

// Phase state machine
phase       = "boss_death";   // "boss_death" | "fade_in" | "title" | "credits" | "unlock" | "fade_out"
phase_timer = 0;
screen_alpha = 0;

// Boss death dialogue lines (moved from in-world dialogue to on-screen text)
boss_lines = [
    "Impossible... I am... the SKIPJACK protocol...",
    "You have... corrupted... my core...",
    "...SYSTEM TERMINATED."
];
boss_line_index = 0;
boss_line_alpha = 0;

// Credits data — the NPCs the player met during the Caesar module
credits = [
    { name: "Greg",    role: "Your mentor & guide" },
    { name: "David",   role: "Combat instructor" },
    { name: "Lea",     role: "Caesar Cipher teacher" },
    { name: "Clipper", role: "Cryptography specialist" },
    { name: "Kyle",    role: "Intel & reconnaissance" }
];
credit_index   = 0;
credit_timer   = 0;
credit_alpha   = 0;

// Unlock reveal
unlock_scale   = 0;
unlock_flash   = 0;

// Particle-like star positions (decorative)
stars = [];
for (var i = 0; i < 30; i++) {
    array_push(stars, {
        sx: irandom(640),
        sy: irandom(360),
        spd: 0.3 + random(0.7),
        sz: 1 + random(2),
        ang: random(360)
    });
}

anim_timer = 0;
