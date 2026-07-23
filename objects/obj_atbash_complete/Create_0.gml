// --- Create Event for obj_caesar_complete ---
// Congratulations / credits screen shown after defeating the Caesar Cipher final boss.
// Displays a victory message, credits the NPCs met, and announces the Atbash unlock.

depth = -15000;

// Freeze player
if (instance_exists(obj_jack)) {
    obj_jack.isInCutscene = true;
}

// Phase state machine
phase       = "fade_in";   // "fade_in" | "title" | "credits" | "unlock" | "fade_out"
phase_timer = 0;
screen_alpha = 0;


// Credits data — the NPCs the player met during the Atbash module
credits = [
    { name: "The Theorist",   role: "Cryptography Theory" },
    { name: "The Specialist", role: "Practice Minigame" },
    { name: "The Sentry",     role: "Combat Instructor" },
    { name: "The Examiner",   role: "Final Evaluator" }
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
