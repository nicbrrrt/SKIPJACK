// --- Draw Event of obj_npc1 ---

// HIDE RULE: If he is meant to be the challenger but tutorial isn't done, don't draw him.
if (isChallenger == true && global.tutorial_complete == false) {
    exit; 
}

// DRAW HIMSELF
draw_self(); 

// INTERACT PROMPT
if (instance_exists(obj_jack)) {
    var _dist = point_distance(x, y, obj_jack.x, obj_jack.y);
    if (_dist < 48 && !instance_exists(obj_textevent)) {
        draw_set_halign(fa_center);
        draw_set_font(fnt_dialogue);
        if (room == rm_tutorial_void) {
            draw_text_color(x, y - 40, "[E] TALK", c_black, c_black, c_black, c_black, 1);
        } else {
            draw_text_color(x, y - 40, "[E] CHALLENGE", c_yellow, c_yellow, c_white, c_white, 1);
        }
        draw_set_halign(fa_left);
    }
}