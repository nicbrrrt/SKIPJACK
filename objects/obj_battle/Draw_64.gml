// --- Draw GUI Event of obj_battle ---

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// 1. POSITIONING
var player_x = gui_w * 0.15 + player_lunge;
var enemy_x  = gui_w * 0.85 + enemy_lunge;
var sprite_y = gui_h * 0.6;

// Only draw the fighters if there is NO tutorial on screen.
if (!instance_exists(obj_tutorial)) {

    // PLAYER (faces right toward enemy)
    if (sprite_exists(player_draw_spr)) {
        var _pcol = c_white;
        if (player_hurt_timer > 0 && player_hurt_timer mod 4 < 2) _pcol = c_red;
        draw_sprite_ext(player_draw_spr, player_draw_sub, player_x, sprite_y, 3, 3, 0, _pcol, 1);
    }

    // ENEMY (faces left toward player)
    var _espr = enemy_sprite;
    if (fight_anim == "enemy_attack" && enemy_attack_spr != enemy_sprite && sprite_exists(enemy_attack_spr)) {
        _espr = enemy_attack_spr;
    }
    if (sprite_exists(_espr)) {
        var _ecol = c_white;
        if (enemy_flash_timer > 0 && enemy_flash_timer mod 3 == 0) _ecol = c_red;
        draw_sprite_ext(_espr, enemy_draw_sub, enemy_x, sprite_y, 3, 3, 0, _ecol, 1);
    } else {
        draw_sprite_ext(spr_computer, 0, enemy_x, sprite_y, 3, 3, 0, c_white, 1);
    }
}

// 4. DRAW HUD 
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

draw_set_halign(fa_left);
draw_set_color(c_white);
