/// @description par_npc — Draw Event
/// Renders standard floor contact shadow underneath the NPC

if (sprite_index != -1) {
    // Floor contact shadow
    draw_set_alpha(0.35);
    draw_set_color(c_black);
    // Draw an ellipse at feet level based on sprite bounding box
    var _cx = (bbox_left + bbox_right) * 0.5;
    var _hw = max(6, (bbox_right - bbox_left) * 0.38);
    var _by = bbox_bottom;
    draw_ellipse(_cx - _hw, _by - 3, _cx + _hw, _by + 2, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}

draw_self();
