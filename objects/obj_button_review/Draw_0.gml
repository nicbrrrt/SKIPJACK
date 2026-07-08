// --- Draw Event for obj_button_review ---
// Hex frame on the right; CODEX label sits below it.

if (instance_exists(obj_review_screen)) exit;

draw_self();
draw_set_font(fnt_button);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);

var _half_h = sprite_get_height(sprite_index) * abs(image_yscale) * 0.5;
draw_text(x, y + _half_h + 8, "CODEX");
