/// @description obj_dungeon_victory — Draw GUI Event
/// Renders the Extraction Elevator "Incident Debrief Report Card" in 640x360 GUI space.

if (variable_global_exists("is_paused") && global.is_paused) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _cx = _gw * 0.5;
var _cy = _gh * 0.5;

// Dark background backdrop
draw_set_alpha(screen_alpha * 0.92);
draw_set_color(make_color_rgb(6, 10, 20));
draw_rectangle(0, 0, _gw, _gh, false);

// Subtle background particles
for (var i = 0; i < array_length(stars); i++) {
    var _s     = stars[i];
    var _pulse = 0.5 + 0.5 * sin(anim_timer * _s.spd * 0.05 + _s.ang);
    draw_set_color(merge_color(c_navy, c_aqua, _pulse));
    draw_set_alpha(screen_alpha * _pulse * 0.45);
    draw_circle(_s.sx, _s.sy, _s.sz * _pulse, false);
}

draw_set_alpha(screen_alpha);

// Main Debrief Card Panel
var _pw = 580;
var _ph = 324;
var _x1 = _cx - _pw * 0.5;
var _y1 = _cy - _ph * 0.5;
var _x2 = _cx + _pw * 0.5;
var _y2 = _cy + _ph * 0.5;

draw_set_color(make_color_rgb(12, 18, 30));
draw_rectangle(_x1, _y1, _x2, _y2, false);
draw_set_color(c_aqua);
draw_rectangle(_x1, _y1, _x2, _y2, true);
draw_rectangle(_x1 + 3, _y1 + 3, _x2 - 3, _y2 - 3, true);

draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// 1. Header Banner
var _bob = sin(anim_timer * 0.06) * 1.5;
draw_set_color(c_aqua);
draw_text_transformed(_cx, _y1 + 22 + _bob, "SECTOR #" + string(cleared_count) + " CLEARED — INCIDENT DEBRIEF CARD", 1.15, 1.15, 0);

var _rank_str = (clues_total >= 2)
    ? ("INVESTIGATION RANK: S (Full Field Clues Gathered: " + string(clues_total) + ")")
    : ("INVESTIGATION RANK: A (Clues Gathered: " + string(clues_total) + ")");
draw_set_color(make_color_rgb(255, 215, 55));
draw_text_transformed(_cx, _y1 + 42, _rank_str, 0.85, 0.85, 0);

// 2. Section 1 — Cyber Threat Neutralized Box
draw_set_color(make_color_rgb(18, 28, 44));
draw_rectangle(_x1 + 16, _y1 + 56, _x2 - 16, _y1 + 162, false);
draw_set_color(make_color_rgb(65, 165, 215));
draw_rectangle(_x1 + 16, _y1 + 56, _x2 - 16, _y1 + 162, true);

draw_set_halign(fa_left);
draw_set_color(c_aqua);
draw_text_transformed(_x1 + 26, _y1 + 70, "1. THREAT NEUTRALIZED:  " + case_word + "  (" + case_title + ")", 0.92, 0.92, 0);

draw_set_color(c_white);
draw_text_ext_transformed(_x1 + 26, _y1 + 94, "WHAT IT IS: " + case_hint, 15, (_pw - 56) / 0.84, 0.84, 0.84, 0);

draw_set_color(c_lime);
draw_text_ext_transformed(_x1 + 26, _y1 + 132, case_takeaway, 15, (_pw - 56) / 0.84, 0.84, 0.84, 0);

// 3. Section 2 — Cryptography & Key Analysis Box
draw_set_color(make_color_rgb(22, 24, 42));
draw_rectangle(_x1 + 16, _y1 + 172, _x2 - 16, _y1 + 262, false);
draw_set_color(make_color_rgb(255, 195, 45));
draw_rectangle(_x1 + 16, _y1 + 172, _x2 - 16, _y1 + 262, true);

var _k_str = (floor_key > 0) ? ("+" + string(floor_key)) : string(floor_key);
draw_set_color(make_color_rgb(255, 210, 55));
draw_text_transformed(_x1 + 26, _y1 + 188, "2. CIPHER CRACKED:  CAESAR SHIFT CIPHER  (Floor Key: " + _k_str + ")", 0.92, 0.92, 0);

draw_set_color(make_color_rgb(215, 230, 250));
draw_text_ext_transformed(_x1 + 26, _y1 + 224, crypto_fact, 15, (_pw - 56) / 0.84, 0.84, 0.84, 0);

// 4. Action Prompts Footer
draw_set_halign(fa_center);
if (phase == "display" && phase_timer >= 20) {
    var _flash = (anim_timer mod 50) < 35;
    if (_flash) {
        draw_set_color(c_lime);
        draw_text_transformed(_cx, _y2 - 36, "[ PRESS E / ENTER FOR NEXT FLOOR ]", 0.98, 0.98, 0);
    }
    draw_set_color(make_color_rgb(165, 180, 200));
    draw_text_transformed(_cx, _y2 - 16, "[ ESC ] Return to Main Menu", 0.82, 0.82, 0);
} else if (phase == "fade_out") {
    draw_set_color(c_aqua);
    draw_text(_cx, _y2 - 26, "Ascending to next sector floor...");
}

// Reset draw state
draw_set_font(fnt_default);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
