// obj_final_boss_placeholder — Step Event
event_inherited(); // par_npc: depth = -y

// --- FINAL BOSS DEFEATED STATE ---
if (global.final_boss_defeated) {
    visible = true;
    image_alpha = 1;
    image_xscale = 1;
    image_yscale = 1;
    sprite_index = spr_boss_dead;
    image_speed = 0.1;
    exit;
}

// --- SPAWN ANIMATION STATE MACHINE ---
if (spawn_phase == "waiting") {
    if (global.boss_spawned) {
        spawn_phase = "spawn_anim";
        spawn_timer = 0;
        sprite_index = spr_boss_idle;
        image_speed = 0.15;
    }
    exit;
}

if (spawn_phase == "spawn_anim") {
    spawn_timer++;
    visible = true;

    // Phase A (frames 0-30): flicker + appear small
    if (spawn_timer <= 30) {
        image_alpha  = (spawn_timer mod 6 < 3) ? 0 : 1;
        image_xscale = 0.1;
        image_yscale = 0.1;
    }
    // Phase B (frames 31-90): scale up from 0.1 to 1.0
    else if (spawn_timer <= 90) {
        image_alpha  = 1;
        var _t       = (spawn_timer - 30) / 60;
        image_xscale = lerp(0.1, 1.0, _t);
        image_yscale = lerp(0.1, 1.0, _t);
    }
    else {
        image_alpha  = 1;
        image_xscale = 1;
        image_yscale = 1;
        spawn_phase  = "done";
    }
    exit;
}

// --- NORMAL IDLE (spawn_phase == "done") ---
if (spawn_phase == "done") {
    visible = true;
    image_alpha  = 1;
    image_xscale = 1;
    image_yscale = 1;
    sprite_index = spr_boss_idle;
    image_speed  = 0.15;
}
