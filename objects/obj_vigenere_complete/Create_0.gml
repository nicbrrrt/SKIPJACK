// --- Create Event for obj_vigenere_complete ---
depth = -15000;

// Freeze player
if (instance_exists(obj_jack)) {
    obj_jack.isInCutscene = true;
}

// Phase state machine
phase       = "fade_in";   // "fade_in" | "title" | "credits" | "unlock" | "fade_out"
phase_timer = 0;
screen_alpha = 0;

// Credits data
credits = [
    { name: "Vigenere Theory",   role: "Cryptography Theory" },
    { name: "Coach", role: "Practice Minigame" },
    { name: "Examiner",   role: "Final Evaluator" }
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
