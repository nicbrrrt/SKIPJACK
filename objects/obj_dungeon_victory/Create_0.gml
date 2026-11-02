/// @description obj_dungeon_victory — Create Event
/// Victory screen overlay shown when the player reaches the End room goal.
/// Displays completion stats and generates the next dungeon on confirm.

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

// Decorative background particles (matching Skipjack's completion screen style)
stars = [];
for (var i = 0; i < 30; i++) {
    array_push(stars, {
        sx:  irandom(640),
        sy:  irandom(360),
        spd: 0.3 + random(0.7),
        sz:  1 + random(2),
        ang: random(360)
    });
}
