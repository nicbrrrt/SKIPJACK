/// @description obj_intern_glass ?" Draw Event
var _cx = x + 8;
var _cy = y + 8;
var _shake_x = (hit_anim > 0) ? irandom_range(-1, 1) : 0;
var _shake_y = (hit_anim > 0) ? irandom_range(-1, 1) : 0;

if (is_shattered) {
    // Open shattered void breach
    draw_set_alpha(0.88);
    draw_set_color(make_color_rgb(10, 14, 24));
    draw_rectangle(x, y, x + 15, y + 15, false);

    // Jagged glass teeth
    draw_set_color(c_aqua);
    draw_triangle(x, y, x + 4, y + 5, x + 8, y, false);
    draw_triangle(x + 10, y, x + 13, y + 6, x + 15, y, false);
    draw_triangle(x, y + 15, x + 5, y + 11, x + 11, y + 15, false);

    // Hazard danger outline
    draw_set_color(c_red);
    draw_rectangle(x, y, x + 15, y + 15, true);
} else {
    // Translucent Sky Observation Glass Pane
    var _tint_col = (hit_anim > 0) ? make_color_rgb(255, 120, 120) : make_color_rgb(70, 160, 240);
    draw_set_alpha(0.55);
    draw_set_color(_tint_col);
    draw_rectangle(x + _shake_x, y + _shake_y, x + 15 + _shake_x, y + 15 + _shake_y, false);

    // Diagonal glass highlight glare
    draw_set_alpha(0.35);
    draw_set_color(c_white);
    draw_line(x + 2, y + 13, x + 13, y + 2);
    draw_line(x + 5, y + 14, x + 14, y + 5);

    // Steel frame border
    draw_set_alpha(0.85);
    draw_set_color(make_color_rgb(120, 140, 170));
    draw_rectangle(x, y, x + 15, y + 15, true);

    // Crack Overlays based on remaining HP
    if (glass_hp <= 75) {
        draw_set_alpha(0.95);
        var _crack_col = (glass_hp <= 25) ? (current_time mod 200 < 100 ? c_red : c_white) : c_white;
        draw_set_color(_crack_col);

        // Stage 1 hairline crack
        draw_line(_cx - 2, _cy - 5, _cx + 1, _cy + 1);
        draw_line(_cx + 1, _cy + 1, _cx - 3, _cy + 6);

        // Stage 2 spiderweb fractures
        if (glass_hp <= 50) {
            draw_line(_cx + 1, _cy + 1, _cx + 6, _cy - 2);
            draw_line(_cx + 1, _cy + 1, _cx + 5, _cy + 4);
            draw_line(_cx - 2, _cy - 5, _cx - 6, _cy - 3);
        }

        // Stage 3 critical fractures & warning beacon
        if (glass_hp <= 25) {
            draw_line(_cx + 6, _cy - 2, _cx + 7, _cy - 7);
            draw_line(_cx - 3, _cy + 6, _cx - 7, _cy + 7);
            draw_circle(_cx, _cy, 4, true);
        }
    }

    // -------------------------------------------------------------
    // Structural Health Bar (Appears when glass is damaged)
    // -------------------------------------------------------------
    if (glass_hp < 100) {
        var _bw   = 28;
        var _bh   = 4;
        var _bx1  = _cx - _bw * 0.5;
        var _by1  = y - 10;
        var _fill = clamp(glass_hp / max_hp, 0, 1);

        draw_set_alpha(0.92);
        draw_set_color(c_black);
        draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, false);

        var _hp_col = (glass_hp > 75) ? c_lime : ((glass_hp > 50) ? c_yellow : ((glass_hp > 25) ? c_orange : (current_time mod 200 < 100 ? c_red : c_white)));
        draw_set_color(_hp_col);
        draw_rectangle(_bx1, _by1, _bx1 + _bw * _fill, _by1 + _bh, false);
        draw_set_color(c_white);
        draw_rectangle(_bx1 - 1, _by1 - 1, _bx1 + _bw + 1, _by1 + _bh + 1, true);

        // Prompt to patch/reinforce when this is the single targeted pane
        if (is_repair_target) {
            var _hpct = clamp(hold_timer / hold_max, 0, 1);
            var _pw   = 36;
            var _ph   = 4;
            var _px   = _cx - _pw * 0.5;
            var _py   = _by1 - 12;

            draw_set_halign(fa_center);
            draw_set_valign(fa_bottom);
            draw_set_font(fnt_dialogue);
            draw_set_color((_hpct > 0) ? c_aqua : c_yellow);
            var _msg = (_hpct > 0) ? ("HOLD [E] REINFORCING (" + string(round(_hpct * 100)) + "%)") : "HOLD [E] REINFORCE (5s)";
            draw_text_transformed(_cx, _py - 2, _msg, 0.38, 0.38, 0);

            // Hold progress bar
            draw_set_alpha(0.95);
            draw_set_color(c_black);
            draw_rectangle(_px - 1, _py - 1, _px + _pw + 1, _py + _ph + 1, false);
            draw_set_color(merge_color(make_color_rgb(0, 180, 255), c_lime, _hpct));
            draw_rectangle(_px, _py, _px + _pw * _hpct, _py + _ph, false);
            draw_set_color(c_white);
            draw_rectangle(_px - 1, _py - 1, _px + _pw + 1, _py + _ph + 1, true);

            // Subtle welding sparks while holding [E]
            if (_hpct > 0 && (repair_spark_t mod 6 < 3)) {
                draw_set_color(c_yellow);
                draw_circle(_cx + irandom_range(-6, 6), _cy + irandom_range(-6, 6), 1.5, false);
            }

            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            draw_set_font(fnt_default);
        }
    }
}

draw_set_alpha(1.0);
draw_set_color(c_white);
