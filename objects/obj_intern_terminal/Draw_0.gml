/// @description obj_intern_terminal ?" Draw Event
var _cx = x + 8;
var _cy = y + 8;

// Desk base
draw_set_alpha(0.92);
draw_set_color(is_fried ? make_color_rgb(45, 20, 20) : make_color_rgb(26, 32, 44));
draw_rectangle(x + 1, y + 4, x + 14, y + 15, false);
draw_set_color(is_fried ? c_red : make_color_rgb(55, 65, 85));
draw_rectangle(x + 1, y + 4, x + 14, y + 15, true);

// Monitor
var _tint = is_fried ? make_color_rgb(255, 90, 90) : c_white;
var _frame = is_fried ? 0 : (floor(current_time / 140 + terminal_index) mod max(1, sprite_get_number(spr_computer)));
draw_sprite_ext(spr_computer, _frame, _cx, y + 14, 0.75, 0.68, 0, _tint, 1.0);

// Sparks / smoke if fried
if (is_fried && (sparks_timer mod 16 < 8)) {
    draw_set_color(choose(c_yellow, c_orange, c_red));
    draw_circle(_cx + irandom_range(-5, 5), y + 4 + irandom_range(-3, 3), 1.5, false);
}

// Interaction prompt
if (near_player && is_fried) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_font(fnt_dialogue);
    draw_set_alpha(0.85);
    draw_set_color(c_black);
    draw_rectangle(_cx - 36, y - 14, _cx + 36, y - 2, false);
    draw_set_color(c_lime);
    draw_rectangle(_cx - 42, y - 14, _cx + 42, y - 2, true);
    draw_text_transformed(_cx, y - 3, "[E] REBOOT TERMINAL", 0.40, 0.40, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_font(fnt_default);
}

draw_set_alpha(1.0);
draw_set_color(c_white);
