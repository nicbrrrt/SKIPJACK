/// @description obj_dungeon_victory — Draw GUI Event
/// Renders the cyber-styled Dungeon Cleared screen in 640x360 GUI space.

if (variable_global_exists("is_paused") && global.is_paused) exit;

var _gw = 640;
var _gh = 360;
var _cx = _gw / 2;

// Dark background backdrop
draw_set_alpha(screen_alpha * 0.92);
draw_set_color(make_color_rgb(6, 10, 22));
draw_rectangle(0, 0, _gw, _gh, false);

// Decorative pulsing cyber particles
for (var i = 0; i < array_length(stars); i++) {
    var _s     = stars[i];
    var _pulse = 0.5 + 0.5 * sin(anim_timer * _s.spd * 0.05 + _s.ang);
    draw_set_color(merge_color(c_navy, c_aqua, _pulse));
    draw_set_alpha(screen_alpha * _pulse * 0.6);
    draw_circle(_s.sx, _s.sy, _s.sz * _pulse, false);
}

draw_set_alpha(screen_alpha);

// Top & bottom horizontal accent lines
draw_set_color(make_color_rgb(40, 90, 140));
var _line_w = 210 + sin(anim_timer * 0.04) * 25;
draw_line_width(_cx - _line_w, 58, _cx + _line_w, 58, 2);
draw_line_width(_cx - _line_w, _gh - 58, _cx + _line_w, _gh - 58, 2);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Header banner
draw_set_font(fnt_dialogue);
var _bob = sin(anim_timer * 0.06) * 3;

draw_set_color(c_aqua);
draw_text_transformed(_cx, 110 + _bob, "SECTOR CLEARED!", 1.4, 1.4, 0);

// Subheader / Floor counter
draw_set_color(c_white);
draw_text(_cx, 165, "Dungeon Floor #" + string(cleared_count) + " Complete");

draw_set_color(make_color_rgb(150, 190, 220));
draw_text(_cx, 195, "Extraction beacon synchronized. Next sector ready.");

// Action prompts
if (phase == "display" && phase_timer >= 20) {
    var _flash = (anim_timer mod 50) < 35;
    if (_flash) {
        draw_set_color(c_lime);
        draw_text(_cx, 255, "[ PRESS E / ENTER FOR NEXT DUNGEON ]");
    }

    draw_set_color(c_gray);
    draw_text(_cx, 285, "[ ESC ] Return to Main Menu");
} else if (phase == "fade_out") {
    draw_set_color(c_aqua);
    draw_text(_cx, 260, "Generating next sector...");
}

// Reset draw state
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
