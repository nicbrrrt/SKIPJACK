// --- Draw Event of obj_npc1 ---

if (isChallenger == true && global.tutorial_complete == false) {
    exit;
}

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
