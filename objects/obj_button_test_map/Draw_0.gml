// --- Draw Event for obj_button_test_map ---

if (instance_exists(obj_review_screen)) exit;

draw_self();

draw_set_font(fnt_button);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);

// Origin of spr_setting is (500, 400) Bottom-Center
// So visual center is x, and y - (sprite_height * 0.5)
var _center_y = y - (sprite_get_height(sprite_index) * abs(image_yscale) * 0.5);
draw_text(x, _center_y, "TEST DUNGEON");
