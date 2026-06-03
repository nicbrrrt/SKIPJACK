var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// Dim backdrop so the panel reads clearly over the room art
draw_set_alpha(0.55);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

// Main panel
draw_set_color(c_black);
draw_set_alpha(0.75);
draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, false);
draw_set_alpha(1);
draw_set_color(c_white);
draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, true);

// Title
draw_set_font(fnt_title);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_text(_gw * 0.5, panel_y + 28, "SETTINGS");
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// --- Back button ---
draw_set_font(fnt_button);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(hover_back ? c_yellow : c_white);
draw_rectangle(back_x1, back_y1, back_x2, back_y2, true);
draw_set_color(c_black);
draw_rectangle(back_x1, back_y1, back_x2, back_y2, false);
draw_set_color(hover_back ? c_yellow : c_white);
draw_text((back_x1 + back_x2) * 0.5, (back_y1 + back_y2) * 0.5, "BACK");
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// --- Volume row ---
draw_set_font(fnt_button);
draw_set_color(c_white);
draw_text(row_label_x, vol_row_y - 10, "VOLUME");

var _fill_w = (slider_x2 - slider_x1) * global.game_volume;
draw_set_color(c_dkgray);
draw_rectangle(slider_x1, slider_y, slider_x2, slider_y + slider_h, false);
draw_set_color(hover_vol || dragging_volume ? c_yellow : c_lime);
draw_rectangle(slider_x1, slider_y, slider_x1 + _fill_w, slider_y + slider_h, false);
draw_set_color(c_white);
draw_rectangle(slider_x1, slider_y, slider_x2, slider_y + slider_h, true);

var _knob_x = slider_x1 + _fill_w;
draw_set_color(c_white);
draw_circle(_knob_x, slider_y + slider_h * 0.5, 7, false);

draw_set_halign(fa_right);
draw_text(slider_x2 + 44, vol_row_y - 10, string(round(global.game_volume * 100)) + "%");
draw_set_halign(fa_left);

// --- Fullscreen row ---
draw_set_color(c_white);
draw_text(row_label_x, fs_row_y - 10, "FULLSCREEN");

var _cb_frame = fullscreen_on ? 1 : 0;
draw_sprite(spr_checkbox, _cb_frame, checkbox_x, checkbox_y);
if (hover_fs) {
    draw_set_color(c_yellow);
    draw_set_alpha(0.35);
    draw_circle(checkbox_x, checkbox_y, 22, false);
    draw_set_alpha(1);
}

draw_set_color(c_ltgray);
draw_text(checkbox_x + 28, fs_row_y - 10, fullscreen_on ? "On" : "Off");

draw_set_color(c_white);
