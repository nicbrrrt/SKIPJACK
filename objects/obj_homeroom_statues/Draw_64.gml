/// @description obj_homeroom_statues — Draw GUI Event
/// Wall Telephone UI, Display Table organizer UI, interaction prompts and a small wallet HUD.

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

if (variable_global_exists("is_paused") && global.is_paused) exit;

if (global.phone_ui_open) {
    scr_draw_mechanic_phone_ui(_gw, _gh);
} else if (global.shelf_ui_open) {
    scr_draw_statue_shelf_ui(_gw, _gh);
} else if (!instance_exists(obj_textevent) && !instance_exists(obj_textbox)) {
    // Wallet HUD (top-left)
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_set_alpha(0.82);
    draw_set_color(make_color_rgb(10, 14, 22));
    draw_rectangle(8, 8, 214, 30, false);
    draw_set_alpha(1.0);
    draw_set_color(make_color_rgb(235, 175, 85));
    draw_rectangle(8, 8, 214, 30, true);
    draw_set_color(c_lime);
    draw_text_transformed(14, 19, "$" + string(global.player_cash), 0.78, 0.78, 0);
    draw_set_color(c_aqua);
    draw_text_transformed(84, 19, "SCRAP " + string(global.scrap_count), 0.78, 0.78, 0);
    draw_set_color(make_color_rgb(235, 110, 255));
    draw_text_transformed(152, 19, "CORES " + string(global.rare_cores), 0.78, 0.78, 0);

    // Interaction prompt
    var _prompt = "";
    var _pcol   = c_white;
    if (near_phone) {
        _prompt = "[E] Call the Mechanic (Wall Telephone)";
        _pcol   = make_color_rgb(255, 205, 110);
    } else if (near_table) {
        _prompt = "[E] Arrange Statues (3 Pedestals)";
        _pcol   = make_color_rgb(255, 205, 110);
    } else if (near_exit) {
        _prompt = "[E] Leave Homeroom (Chapter Select)";
        _pcol   = c_aqua;
    }

    if (_prompt != "") {
        draw_set_halign(fa_center);
        var _pw = string_width(_prompt) + 24;
        var _py = _gh - 26;
        draw_set_alpha(0.82);
        draw_set_color(make_color_rgb(10, 14, 22));
        draw_rectangle((_gw - _pw) * 0.5, _py - 12, (_gw + _pw) * 0.5, _py + 12, false);
        draw_set_alpha(1.0);
        draw_set_color(_pcol);
        draw_rectangle((_gw - _pw) * 0.5, _py - 12, (_gw + _pw) * 0.5, _py + 12, true);
        draw_text(_gw * 0.5, _py, _prompt);
    }
}

// First-Visit 3-Step Homeroom Visual Spotlight Tour (Codex, Wall Telephone, Statues)
if (variable_instance_exists(id, "homeroom_tour_step") && homeroom_tour_step >= 0 && !(instance_exists(obj_codex_manager) && obj_codex_manager.is_open)) {
    var _ht_titles = [
        "HOMEROOM GUIDE (1/3): [C] CYBERSECURITY CODEX",
        "HOMEROOM GUIDE (2/3): WALL TELEPHONE (ORDER STATUES)",
        "HOMEROOM GUIDE (3/3): 3-PEDESTAL STATUE TABLE"
    ];
    var _ht_bodies = [
        "Click [C] CYBER CODEX in the top-right to read in-depth definitions of every [? Term] you collected and view your 5-Branch Mastery Bars!",
        "Walk to the Wall Telephone on the north wall [E] to spend your Paycheck ($) on Statues from Burt!",
        "Place delivered Statues on the 3 Pedestals [E] to unlock passive floor buffs (narrower bot cones, longer timers, and surge shields)!"
    ];
    var _ht_hx1 = [_gw - 214, _gw * 0.5 + 36, _gw * 0.5 - 32];
    var _ht_hy1 = [10, 82, 118];
    var _ht_hx2 = [_gw - 10, _gw * 0.5 + 106, _gw * 0.5 + 56];
    var _ht_hy2 = [44, 134, 178];

    var _st = homeroom_tour_step;
    draw_set_alpha(0.60);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gw, _gh, false);
    draw_set_alpha(1.0);
    draw_set_color(c_yellow);
    draw_rectangle(_ht_hx1[_st], _ht_hy1[_st], _ht_hx2[_st], _ht_hy2[_st], true);
    draw_rectangle(_ht_hx1[_st] + 2, _ht_hy1[_st] + 2, _ht_hx2[_st] - 2, _ht_hy2[_st] - 2, true);

    var _cx = _gw * 0.5;
    var _cy = _gh - 66;
    draw_set_color(make_color_rgb(12, 20, 36));
    draw_rectangle(_cx - 240, _cy - 34, _cx + 240, _cy + 34, false);
    draw_set_color(c_aqua);
    draw_rectangle(_cx - 240, _cy - 34, _cx + 240, _cy + 34, true);

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_yellow);
    draw_text_transformed(_cx, _cy - 20, _ht_titles[_st], 0.72, 0.72, 0);
    draw_set_color(c_white);
    draw_text_ext_transformed(_cx, _cy + 2, _ht_bodies[_st], 13, 456 / 0.62, 0.62, 0.62, 0);
    draw_set_color(c_lime);
    draw_text_transformed(_cx, _cy + 24, (_st < 2) ? "[E / CLICK] Next >" : "[E / CLICK] Finish Tour", 0.64, 0.64, 0);
}

draw_set_font(fnt_default);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
