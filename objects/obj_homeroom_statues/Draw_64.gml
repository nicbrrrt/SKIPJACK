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

draw_set_font(fnt_default);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
