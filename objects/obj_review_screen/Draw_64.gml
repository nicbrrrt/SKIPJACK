// --- obj_review_screen Draw GUI Event ---
// Draws either the main-tab selection list or the sub-tab content view.

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// ── Colour palette ────────────────────────────────────────────────────────────
var _col_overlay     = make_colour_rgb(20,  15,  28);
var _col_card_bg     = make_colour_rgb(245, 232, 210);
var _col_card_border = make_colour_rgb(180, 140, 80);
var _col_tab_active  = make_colour_rgb(255, 215, 140);
var _col_tab_hover   = make_colour_rgb(230, 195, 110);
var _col_tab_inact   = make_colour_rgb(195, 178, 155);
var _col_tab_txt_a   = make_colour_rgb(70,  40,  10);
var _col_tab_txt_i   = make_colour_rgb(110, 90,  65);
var _col_body        = make_colour_rgb(50,  35,  20);
var _col_attr        = make_colour_rgb(85,  140, 100);
var _col_hint        = make_colour_rgb(140, 105, 75);
var _col_divider     = make_colour_rgb(200, 175, 135);
var _col_back_hover  = make_colour_rgb(255, 200, 100);
var _col_back_norm   = make_colour_rgb(150, 120, 75);
var _col_sub_active  = make_colour_rgb(200, 160, 80);
var _col_sub_inact   = make_colour_rgb(175, 155, 125);
var _col_title_txt   = make_colour_rgb(70,  40,  10);

// ── Card layout ───────────────────────────────────────────────────────────────
var _card_w = _gw * 0.80;
var _card_h = _gh * 0.84;
var _card_x = (_gw - _card_w) / 2;
var _card_y = (_gh - _card_h) / 2;
var _pad    = 28;

// ── 1. Dimmed overlay ─────────────────────────────────────────────────────────
draw_set_color(_col_overlay);
draw_set_alpha(0.90);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

// ── 2. Card background ────────────────────────────────────────────────────────
draw_set_color(_col_card_bg);
draw_rectangle(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, false);
draw_set_color(_col_card_border);
draw_rectangle(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, true);

draw_set_font(fnt_dialogue);
draw_set_alpha(1);

// ─────────────────────────────────────────────────────────────────────────────
// VIEW MODE: "tabs"
// ─────────────────────────────────────────────────────────────────────────────
if (view_mode == "tabs") {

    // Title
    draw_set_color(_col_title_txt);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text_transformed(_gw / 2, _card_y + 12, "REVIEW MODE", 1.2, 1.2, 0);

    // Divider below title
    draw_set_color(_col_divider);
    draw_line(_card_x + _pad, _card_y + 36, _card_x + _card_w - _pad, _card_y + 36);

    // Tab list
    var _tab_cnt  = array_length(main_tabs);
    var _tab_h_px = 54;
    var _tab_gap  = 10;
    var _tab_w_px = _card_w - _pad * 2;
    var _tab_sy   = _card_y + 60;

    for (var i = 0; i < _tab_cnt; i++) {
        var _tab   = main_tabs[i];
        var _tx    = _card_x + _pad;
        var _ty    = _tab_sy + i * (_tab_h_px + _tab_gap);
        var _is_hov = (hovered_tab == i);

        // Tab card
        draw_set_color(_is_hov ? _col_tab_hover : _col_tab_inact);
        draw_rectangle(_tx, _ty, _tx + _tab_w_px, _ty + _tab_h_px, false);
        draw_set_color(_col_card_border);
        draw_rectangle(_tx, _ty, _tx + _tab_w_px, _ty + _tab_h_px, true);

        // Tab label
        draw_set_color(_is_hov ? _col_tab_txt_a : _col_tab_txt_i);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_text_transformed(_tx + 16, _ty + _tab_h_px / 2, _tab.label, 1.1, 1.1, 0);

        // NPC attribution (right-aligned, smaller)
        draw_set_color(_col_attr);
        draw_set_halign(fa_right);
        draw_text(_tx + _tab_w_px - 12, _ty + _tab_h_px / 2, "— " + _tab.npc);

        // Arrow indicator
        draw_set_color(_is_hov ? _col_tab_txt_a : _col_tab_inact);
        draw_set_halign(fa_right);
        draw_text(_tx + _tab_w_px - 100, _ty + _tab_h_px / 2, "▶");
    }

    // Bottom hint
    var _hint_y = _card_y + _card_h - 26;
    draw_set_color(_col_divider);
    draw_line(_card_x + _pad, _hint_y - 6, _card_x + _card_w - _pad, _hint_y - 6);
    draw_set_color(_col_hint);
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    draw_text(_card_x + _pad, _hint_y + 4, "Click a topic  |  ↑↓ Navigate  |  Enter Select");
    draw_set_halign(fa_right);
    draw_text(_card_x + _card_w - _pad, _hint_y + 4, "ESC  Close");
}

// ─────────────────────────────────────────────────────────────────────────────
// VIEW MODE: "content"
// ─────────────────────────────────────────────────────────────────────────────
else if (view_mode == "content") {

    var _tab     = main_tabs[selected_tab];
    var _sub_arr = _tab.sub_tabs;
    var _sub_cnt = array_length(_sub_arr);

    // ── Back button ───────────────────────────────────────────────────────────
    var _back_col = hover_back ? _col_back_hover : _col_back_norm;
    draw_set_color(_back_col);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(_card_x + _pad, _card_y + 10, "◀  Back");

    // Topic title (centred)
    draw_set_color(_col_title_txt);
    draw_set_halign(fa_center);
    draw_text_transformed(_gw / 2, _card_y + 10, _tab.label, 1.1, 1.1, 0);

    // ── Sub-tab strip ─────────────────────────────────────────────────────────
    var _sub_h = 36;
    var _sub_w = (_card_w - _pad * 2) / _sub_cnt;
    var _sub_y = _card_y + 38;

    for (var i = 0; i < _sub_cnt; i++) {
        var _sx      = _card_x + _pad + i * _sub_w;
        var _is_act  = (i == current_sub);
        var _is_hov  = (hovered_sub == i);

        draw_set_color(_is_act ? _col_tab_active : (_is_hov ? _col_tab_hover : _col_sub_inact));
        draw_rectangle(_sx, _sub_y, _sx + _sub_w, _sub_y + _sub_h, false);
        draw_set_color(_col_card_border);
        draw_rectangle(_sx, _sub_y, _sx + _sub_w, _sub_y + _sub_h, true);

        draw_set_color(_is_act ? _col_tab_txt_a : _col_tab_txt_i);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        // Truncate label to fit
        var _lbl = _sub_arr[i].title;
        if (string_length(_lbl) > 18) _lbl = string_copy(_lbl, 1, 17) + "…";
        draw_text(_sx + _sub_w / 2, _sub_y + _sub_h / 2, _lbl);
    }

    // Divider below sub-tabs
    draw_set_color(_col_divider);
    draw_line(_card_x + _pad, _sub_y + _sub_h + 2,
              _card_x + _card_w - _pad, _sub_y + _sub_h + 2);

    // ── Content heading (full sub-tab title) ──────────────────────────────────
    var _cur_sub = _sub_arr[current_sub];
    var _head_y  = _sub_y + _sub_h + 10;

    draw_set_color(_col_title_txt);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text_transformed(_card_x + _pad, _head_y, _cur_sub.title, 1.05, 1.05, 0);

    // Attribution
    draw_set_color(_col_attr);
    draw_set_halign(fa_right);
    draw_text(_card_x + _card_w - _pad, _head_y, "As taught by " + _tab.npc);

    // Divider below heading
    var _body_top = _head_y + 24;
    draw_set_color(_col_divider);
    draw_line(_card_x + _pad, _body_top,
              _card_x + _card_w - _pad, _body_top);

    // ── Body text with scroll clipping ───────────────────────────────────────
    var _body_x   = _card_x + _pad;
    var _body_y   = _body_top + 6 - scroll_y;
    var _body_w   = _card_w - _pad * 2;
    var _clip_top = _body_top + 6;
    var _clip_bot = _card_y + _card_h - 36;

    // Soft clip: only draw lines that would appear within the window
    // (GameMaker 2024 doesn't support arbitrary scissor, so we use draw_set_gui_size
    //  cropping; instead just render and rely on card background to mask edges.
    //  For robust clipping we use a scissor rectangle.)
    gpu_set_scissor(_card_x + _pad - 2, _clip_top,
                    _card_w - _pad * 2 + 4, _clip_bot - _clip_top);

    draw_set_color(_col_body);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text_ext(_body_x, _body_y, _cur_sub.content, 22, _body_w);

    gpu_set_scissor_disabled();

    // ── Bottom hint bar ───────────────────────────────────────────────────────
    var _hint_y = _card_y + _card_h - 26;
    draw_set_color(_col_divider);
    draw_line(_card_x + _pad, _hint_y - 6, _card_x + _card_w - _pad, _hint_y - 6);

    draw_set_color(_col_hint);
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    draw_text(_card_x + _pad, _hint_y + 4, "◀▶  Switch sub-tabs  |  Scroll  Wheel  |  B  Back");
    draw_set_halign(fa_right);
    draw_text(_card_x + _card_w - _pad, _hint_y + 4, "ESC  Close");
}

// Reset draw state
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
