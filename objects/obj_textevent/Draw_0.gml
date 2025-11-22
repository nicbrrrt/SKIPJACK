// DRAW EVENT (Not Draw GUI)
// This draws text directly in the game world at the player's feet.
// If you don't see this, the object truly does not exist.

if (instance_exists(obj_jack)) {
    draw_set_font(-1);
    draw_set_color(c_red);
    draw_set_halign(fa_center);
    
    draw_text(obj_jack.x, obj_jack.y - 50, "TEXT BOX IS HERE!");
    draw_text(obj_jack.x, obj_jack.y - 30, "Page: " + string(page));
}