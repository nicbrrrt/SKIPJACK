draw_self();

if (!instance_exists(obj_jack)) exit;
if (instance_exists(obj_textevent)) exit;
if (point_distance(x, y, obj_jack.x, obj_jack.y) >= 48) exit;

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_font(fnt_dialogue);
draw_text(x, y - 40, "[E] CHALLENGE");
draw_set_halign(fa_left);
draw_set_valign(fa_top);
