// --- Draw Event for obj_button_intern_duty ---

if (instance_exists(obj_review_screen)) exit;
if (instance_exists(obj_codex_manager) && obj_codex_manager.is_open) exit;

draw_self();

var _center_y   = y - (sprite_get_height(sprite_index) * abs(image_yscale) * 0.5);
var _is_hovered = (image_index == 1);

draw_set_font(fnt_button);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var _txt_col = _is_hovered ? c_yellow : make_color_rgb(255, 215, 120);

// Shadow
draw_set_color(c_black);
draw_text(x + 2, _center_y - 4, "INTERN DUTY");

// Main text
draw_set_color(_txt_col);
draw_text(x, _center_y - 6, "INTERN DUTY");

// Sub-label showing test info & shortcut key
var _scrap_num = variable_global_exists("hr_scrap_count") ? global.hr_scrap_count : 4;
var _sub_label = "[ PLAYTEST (I) | " + string(_scrap_num) + " SCRAP (R-CLICK) ]";

draw_set_font(fnt_dialogue);
draw_set_color(c_black);
draw_text(x + 1, _center_y + 15, _sub_label);

draw_set_color(_is_hovered ? c_white : make_color_rgb(180, 220, 255));
draw_text(x, _center_y + 14, _sub_label);

// Reset draw state
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
