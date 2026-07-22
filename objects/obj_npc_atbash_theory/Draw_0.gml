draw_self();

if (variable_global_exists("is_paused") && global.is_paused) exit;
if (!instance_exists(obj_jack)) exit;
if (instance_exists(obj_textevent)) exit;

if (point_distance(x, y, obj_jack.x, obj_jack.y) < interaction_range) {
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    draw_set_alpha(1);
    
    draw_text(x, bbox_top - 5, "[E] TALK");
    
    // Reset draw state
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
