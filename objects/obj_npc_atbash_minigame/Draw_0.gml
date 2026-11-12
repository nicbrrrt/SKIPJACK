// Floor contact shadow
if (sprite_index != -1) {
    draw_set_alpha(0.35);
    draw_set_color(c_black);
    var _cx = (bbox_left + bbox_right) * 0.5;
    var _hw = max(6, (bbox_right - bbox_left) * 0.38);
    draw_ellipse(_cx - _hw, bbox_bottom - 3, _cx + _hw, bbox_bottom + 2, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}

draw_self();

if (!instance_exists(obj_jack)) exit;
if (instance_exists(obj_textevent)) exit;
if (point_distance(x, y, obj_jack.x, obj_jack.y) >= 48) exit;

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_font(fnt_dialogue);
draw_text(x, y - 40, "[E] PRACTICE");
draw_set_halign(fa_left);
draw_set_valign(fa_top);
