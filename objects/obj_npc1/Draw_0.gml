// --- Draw Event of obj_npc1 ---

if (isChallenger == true && global.tutorial_complete == false) {
    exit;
}

draw_self();

if (!instance_exists(obj_jack)) exit;
if (instance_exists(obj_textevent)) exit;

var _dist = point_distance(x, y, obj_jack.x, obj_jack.y);
if (_dist >= 48) exit;

var _label = "";
if (room == rm_tutorial_void || !isChallenger) {
    _label = "[E] TALK";
} else {
    _label = "[E] CHALLENGE";
}

draw_set_halign(fa_center);
draw_set_font(fnt_dialogue);
if (room == rm_tutorial_void) {
    draw_text_color(x, y - 40, _label, c_black, c_black, c_black, c_black, 1);
} else if (isChallenger) {
    draw_text_color(x, y - 40, _label, c_yellow, c_yellow, c_white, c_white, 1);
} else {
    draw_text_color(x, y - 40, _label, c_white, c_white, c_white, c_white, 1);
}
draw_set_halign(fa_left);
