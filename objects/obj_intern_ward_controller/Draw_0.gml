/// @description obj_intern_ward_controller — Draw Event
var _ox = 320;
var _oy = 240;

// -------------------------------------------------------------
// ROOM SIGNS & FLOOR MARKINGS
// -------------------------------------------------------------
draw_set_font(fnt_dialogue);
draw_set_alpha(0.65);
draw_set_halign(fa_center);

// Work Room sign on floor
draw_set_color(make_color_rgb(60, 140, 180));
draw_text_transformed(_ox + 8 * 16, _oy + 7 * 16 + 2, "[TERMINAL WORK BULLPEN]", 0.38, 0.38, 0);

// Storage Room sign on floor (centered in Storage Room cols 17..24)
draw_set_color(make_color_rgb(180, 140, 60));
draw_text_transformed(_ox + 20.5 * 16, _oy + 1 * 16 + 2, "[SUPPLY ARCHIVES & STORAGE]", 0.38, 0.38, 0);

// Wellness Green Room sign on floor (centered in Green Room cols 26..33)
draw_set_color(make_color_rgb(100, 220, 140));
draw_text_transformed(_ox + 29.5 * 16, _oy + 1 * 16 + 2, "[WELLNESS GREEN ROOM (4 SPOTS)]", 0.36, 0.36, 0);

// Glass Room sign on floor (centered in Observation Deck cols 35..40)
draw_set_color(c_aqua);
draw_text_transformed(_ox + 37.5 * 16, _oy + 9 * 16 + 2, "[PANORAMIC OBSERVATION DECK]", 0.38, 0.38, 0);

// -------------------------------------------------------------
// DRAW CARRIED JANITOR MOP OR WRENCH ON JACK
// -------------------------------------------------------------
if (instance_exists(obj_jack)) {
    var _jx = obj_jack.x;
    var _jy = obj_jack.y;

    if (variable_global_exists("player_has_mop") && global.player_has_mop) {
        // Wooden handle angled over Jack's shoulder
        draw_set_color(make_color_rgb(180, 130, 70));
        draw_line_width(_jx + 6, _jy - 16, _jx + 12, _jy + 6, 2);
        // Fluffy mop head
        draw_set_color(make_color_rgb(230, 240, 255));
        draw_circle(_jx + 12, _jy + 6, 3, false);
    }
    else if (variable_global_exists("player_has_wrench") && global.player_has_wrench) {
        // Heavy steel mechanic's wrench holstered at Jack's belt
        draw_set_color(make_color_rgb(210, 220, 230));
        draw_line_width(_jx + 8, _jy - 10, _jx + 13, _jy + 2, 2.5);
        // Chrome wrench jaw head
        draw_set_color(make_color_rgb(240, 245, 255));
        draw_circle(_jx + 8, _jy - 10, 2.5, false);
        draw_set_color(make_color_rgb(45, 55, 65));
        draw_circle(_jx + 8, _jy - 10, 1.2, false);
    }

    // Hands full overhead warning banner
    if (variable_instance_exists(id, "hands_full_alert") && hands_full_alert > 0) {
        hands_full_alert--;
        var _txt = (global.held_intern_inst != noone) ? "! HANDS FULL (PUT DOWN INTERN) !" : "! HANDS FULL (RETURN TOOL) !";
        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_set_color(c_black);
        draw_text_transformed(_jx + 1, _jy - 23, _txt, 0.36, 0.36, 0);
        draw_set_color((hands_full_alert mod 10 < 5) ? c_yellow : c_orange);
        draw_text_transformed(_jx, _jy - 24, _txt, 0.36, 0.36, 0);
    }

    // Jack Stun Effect & Alert
    if (variable_global_exists("jack_stun_timer") && global.jack_stun_timer > 0) {
        var _star_t = current_time * 0.008;
        for (var _si = 0; _si < 4; _si++) {
            var _ang = _star_t + _si * (2 * pi / 4);
            var _sx = _jx + cos(_ang) * 12;
            var _sy = (_jy - 26) + sin(_ang) * 5;
            draw_set_color(c_yellow);
            draw_text_transformed(_sx, _sy, "*", 0.65, 0.65, 0);
        }
        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        var _stuntxt = "! STUNNED (" + string(ceil(global.jack_stun_timer / 60)) + "s) !";
        draw_set_color(c_black);
        draw_text_transformed(_jx + 1, _jy - 31, _stuntxt, 0.36, 0.36, 0);
        draw_set_color((global.jack_stun_timer mod 12 < 6) ? c_yellow : c_white);
        draw_text_transformed(_jx, _jy - 32, _stuntxt, 0.36, 0.36, 0);
    }
    else if (variable_instance_exists(id, "tantrum_hit_alert") && tantrum_hit_alert > 0) {
        tantrum_hit_alert--;
        var _hit_txt = "! HIT BY TANTRUM !";
        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_set_color(c_black);
        draw_text_transformed(_jx + 1, _jy - 23, _hit_txt, 0.36, 0.36, 0);
        draw_set_color((tantrum_hit_alert mod 10 < 5) ? c_red : c_yellow);
        draw_text_transformed(_jx, _jy - 24, _hit_txt, 0.36, 0.36, 0);
    }
    else if (variable_instance_exists(id, "struggle_escape_alert") && struggle_escape_alert > 0) {
        struggle_escape_alert--;
        var _esc_txt = "! INTERN BROKE FREE !";
        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_set_color(c_black);
        draw_text_transformed(_jx + 1, _jy - 23, _esc_txt, 0.36, 0.36, 0);
        draw_set_color((struggle_escape_alert mod 10 < 5) ? c_red : c_orange);
        draw_text_transformed(_jx, _jy - 24, _esc_txt, 0.36, 0.36, 0);
    }
}

draw_set_halign(fa_left);
draw_set_font(fnt_default);
draw_set_alpha(1.0);
draw_set_color(c_white);
