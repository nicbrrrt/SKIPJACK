// --- Draw Event of obj_start_combat ---
if (!visible) exit;

draw_self();

if (!instance_exists(obj_jack)) exit;
if (instance_exists(obj_textevent)) exit;
if (obj_jack.isInCutscene) exit;

var _player = instance_find(obj_jack, 0);
if (_player == noone) exit;
if (point_distance(x, y, _player.x, _player.y) >= interaction_range) exit;

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_font(fnt_dialogue);
draw_text(x, y - 48, "[E] TALK");
draw_set_halign(fa_left);
