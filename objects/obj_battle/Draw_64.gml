// --- Draw GUI Event of obj_battle ---

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// 1. POSITIONING
var player_x = gui_w * 0.15;
var enemy_x = gui_w * 0.85;
var sprite_y = gui_h * 0.6;


// --- VISIBILITY CHECK (THE NEW FIX) ---
// Only draw the fighters if there is NO tutorial on screen.
if (!instance_exists(obj_tutorial)) {

    // 2. DRAW PLAYER
    if (sprite_exists(spr_jack_idle)) {
        draw_sprite_ext(spr_jack_idle, 0, player_x, sprite_y, 3, 3, 0, c_white, 1);
    }

    // 3. DRAW ENEMY
    if (variable_instance_exists(id, "spr_npc2_idle") || sprite_exists(spr_npc2_idle)) {
        draw_sprite_ext(spr_npc2_idle, 0, enemy_x, sprite_y, 3, 3, 0, c_white, 1);
    } else {
        // Fallback
        draw_sprite_ext(spr_computer, 0, enemy_x, sprite_y, 3, 3, 0, c_white, 1);
    }
}

// 4. DRAW HUD 
// (We keep this OUTSIDE the 'if' check so you can still see HP while reading the tutorial)
draw_set_font(fnt_default);
draw_set_color(c_white); 

// PLAYER HUD (Top Left)
draw_set_halign(fa_left);
draw_text(20, 20, "PLAYER");
draw_set_color(c_lime);
draw_text(20, 40, "HP: " + string(player_hp));

// ENEMY HUD (Top Right)
draw_set_halign(fa_right);
draw_set_color(c_white);
draw_text(gui_w - 20, 20, "ENEMY");
draw_set_color(c_red);
draw_text(gui_w - 20, 40, "HP: " + string(enemy_hp));

// RESET ALIGNMENT
draw_set_halign(fa_left);
draw_set_color(c_white);