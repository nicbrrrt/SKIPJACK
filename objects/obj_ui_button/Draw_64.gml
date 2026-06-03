// --- Draw GUI Event of obj_ui_button ---

if (room == rm_menu || room == rm_combat || room == rm_battle_scramble) exit;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

// --- CONTROLS REMINDER PANEL (right side, TAB to toggle) ---
if (variable_global_exists("controls_hint_unlocked") && global.controls_hint_unlocked) {
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var _panel_x = _gui_w - 148;
    var _panel_y = _gui_h * 0.42;
    var _line_h  = 16;
    var _scale   = 0.85;

    if (global.controls_hint_visible) {
        var _lines = [
            "CONTROLS",
            "WASD — Move",
            "E — Talk / Continue",
            "",
            "[TAB] Hide"
        ];

        var _max_w = 0;
        for (var _i = 0; _i < array_length(_lines); _i++) {
            _max_w = max(_max_w, string_width(_lines[_i]) * _scale);
        }

        var _box_w = _max_w + 16;
        var _box_h = _line_h * array_length(_lines) + 10;

        draw_set_color(c_black);
        draw_set_alpha(0.45);
        draw_rectangle(_panel_x - 6, _panel_y - 6, _panel_x + _box_w, _panel_y + _box_h, false);
        draw_set_alpha(1);

        for (var _j = 0; _j < array_length(_lines); _j++) {
            if (_lines[_j] == "") continue;
            if (_j == 0) draw_set_color(c_yellow);
            else if (_j == array_length(_lines) - 1) draw_set_color(c_ltgray);
            else draw_set_color(c_white);
            draw_text_transformed(_panel_x, _panel_y + _j * _line_h, _lines[_j], _scale, _scale, 0);
        }
    } else {
        // Collapsed tab — minimal reminder that TAB brings the panel back
        var _tab_x = _gui_w - 52;
        var _tab_y = _panel_y;
        draw_set_color(c_black);
        draw_set_alpha(0.4);
        draw_rectangle(_tab_x, _tab_y, _gui_w - 4, _tab_y + 36, false);
        draw_set_alpha(1);
        draw_set_color(c_ltgray);
        draw_text_transformed(_tab_x + 4, _tab_y + 4, "[TAB]", _scale, _scale, 0);
        draw_text_transformed(_tab_x + 4, _tab_y + 18, "Help", _scale, _scale, 0);
    }

    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// --- CODEX BUTTON (top-right, after full tutorial) ---
if (!global.tutorial_complete) exit;

draw_set_alpha(1);

var button_x = _gui_w - 60;
var button_y = 60;
var radius = 35;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
var _hover = (point_distance(_mx, _my, button_x, button_y) < radius);

draw_set_color(_hover ? c_dkgray : c_black);
draw_set_alpha(0.8);
draw_circle(button_x, button_y, radius, false);

draw_set_alpha(1);
draw_set_color(c_lime);
draw_circle(button_x, button_y, radius, true);

draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(_hover ? c_white : c_lime);
draw_text_transformed(button_x, button_y, "[ C ]", 1.5, 1.5, 0);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
