// --- obj_review_screen Draw GUI Event ---

review_refresh_layout();

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _col_overlay     = make_colour_rgb(20,  15,  28);
var _col_card_bg     = make_colour_rgb(245, 232, 210);
var _col_card_inner  = make_colour_rgb(252, 244, 230);
var _col_card_border = make_colour_rgb(180, 140,  80);
var _col_tab_active  = make_colour_rgb(255, 215, 140);
var _col_tab_inact   = make_colour_rgb(195, 178, 155);
var _col_tab_locked  = make_colour_rgb(155, 148, 140);
var _col_tab_txt_a   = make_colour_rgb(70,  40,  10);
var _col_tab_txt_i   = make_colour_rgb(110,  90,  65);
var _col_tab_txt_l   = make_colour_rgb(130, 120, 110);
var _col_body        = make_colour_rgb(50,  35,  20);
var _col_title       = make_colour_rgb(120,  75,  20);
var _col_hint        = make_colour_rgb(140, 105,  75);
var _col_divider     = make_colour_rgb(200, 175, 135);

// ── 1. Dimmed overlay ──────────────────────────────────────────────────────
draw_set_color(_col_overlay);
draw_set_alpha(0.90);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

// ── 2. Outer card ──────────────────────────────────────────────────────────
draw_set_color(_col_card_bg);
draw_rectangle(card_x, card_y, card_x + card_w, card_y + card_h, false);
draw_set_color(_col_card_border);
draw_rectangle(card_x, card_y, card_x + card_w, card_y + card_h, true);

// ── 3. Header title ────────────────────────────────────────────────────────
draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(_col_title);
draw_text(card_x + card_w * 0.5, card_y + 8, "CODEX — STUDY MODULES");

// ── 4. Tab strip ───────────────────────────────────────────────────────────
for (var i = 0; i < tab_cnt; i++) {
    var _tx = card_x + i * tab_w;
    var _is_locked = tabs[i].locked;
    var _is_active = (i == current_tab);

    if (_is_locked) {
        draw_set_color(_col_tab_locked);
        draw_set_alpha(0.55);
    } else if (_is_active) {
        draw_set_color(_col_tab_active);
        draw_set_alpha(1);
    } else {
        draw_set_color(_col_tab_inact);
        draw_set_alpha(1);
    }
    draw_rectangle(_tx, tab_strip_y, _tx + tab_w, tab_strip_y + tab_h, false);
    draw_set_alpha(1);

    draw_set_color(_col_card_border);
    draw_rectangle(_tx, tab_strip_y, _tx + tab_w, tab_strip_y + tab_h, true);

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    if (_is_locked) {
        draw_set_color(_col_tab_txt_l);
        draw_text(_tx + tab_w * 0.5, tab_strip_y + tab_h * 0.5 - 6, tabs[i].label);
        draw_text(_tx + tab_w * 0.5, tab_strip_y + tab_h * 0.5 + 8, "[LOCKED]");
    } else {
        draw_set_color(_is_active ? _col_tab_txt_a : _col_tab_txt_i);
        draw_text(_tx + tab_w * 0.5, tab_strip_y + tab_h * 0.5, tabs[i].label);
    }
}

// ── 5. Inner module panel (clips content) ───────────────────────────────────
draw_set_color(_col_card_inner);
draw_rectangle(card_x + 4, content_y1, card_x + card_w - 4, content_y2, false);
draw_set_color(_col_card_border);
draw_rectangle(card_x + 4, content_y1, card_x + card_w - 4, content_y2, true);

var _locked = tabs[current_tab].locked;

if (_locked) {
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_col_hint);
    draw_text(card_x + card_w * 0.5, (content_y1 + content_y2) * 0.5,
        "This module is locked.\nProgress in the story to unlock it.");
} else {
    var _mod       = review_active_mod();
    var _mod_count = review_active_mod_count();
    var _title_y   = content_y1 + 12;

    // Module title
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(_col_title);
    draw_text(card_x + card_w * 0.5, _title_y, "--- " + _mod.title + " ---");

    draw_set_color(_col_divider);
    draw_line(body_x, _title_y + 22, body_x + body_w, _title_y + 22);

    // Clipped body text
    var _scroll = clamp(content_scroll, 0, review_max_scroll(_mod.content));
    gpu_set_scissor(floor(body_x), floor(body_y), floor(body_w), floor(body_h));
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(_col_body);
    draw_text_ext(body_x, body_y - _scroll, _mod.content, 22, body_w);
    gpu_set_scissor(-1, -1, -1, -1);

    // Scroll hint when content overflows
    if (review_max_scroll(_mod.content) > 0) {
        draw_set_halign(fa_right);
        draw_set_valign(fa_top);
        draw_set_color(_col_hint);
        draw_text(body_x + body_w, body_y + 4, "[ scroll ]");
    }
}

// ── 6. Bottom hint bar ─────────────────────────────────────────────────────
draw_set_color(_col_divider);
draw_line(card_x + pad, hint_y - 6, card_x + card_w - pad, hint_y - 6);

draw_set_font(fnt_dialogue);
draw_set_valign(fa_bottom);
draw_set_color(_col_hint);

if (!_locked) {
    var _mod_count = review_active_mod_count();
    draw_set_halign(fa_left);
    draw_text(card_x + pad, hint_y + 4,
        "Module " + string(current_module + 1) + " of " + string(_mod_count) +
        "  |  Wheel / Up-Down to read");
}

draw_set_halign(fa_right);
draw_text(card_x + card_w - pad, hint_y + 4, "ESC  Close");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
