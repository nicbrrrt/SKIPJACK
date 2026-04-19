// --- obj_review_screen Draw GUI Event ---
// Cozy, warm-toned full-screen overlay with tab navigation.

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// ── Color palette ──────────────────────────────────────────────────────────
var _col_overlay     = make_colour_rgb(20,  15,  28);   // deep warm dark
var _col_card_bg     = make_colour_rgb(245, 232, 210);  // parchment cream
var _col_card_border = make_colour_rgb(180, 140, 80);   // warm gold
var _col_tab_active  = make_colour_rgb(255, 215, 140);  // amber
var _col_tab_inact   = make_colour_rgb(195, 178, 155);  // muted tan
var _col_tab_txt_a   = make_colour_rgb(70,  40,  10);   // dark brown (active)
var _col_tab_txt_i   = make_colour_rgb(110, 90,  65);   // medium brown (inactive)
var _col_body        = make_colour_rgb(50,  35,  20);   // dark warm brown
var _col_attr        = make_colour_rgb(85,  140, 100);  // sage green
var _col_hint        = make_colour_rgb(140, 105, 75);   // muted terracotta
var _col_divider     = make_colour_rgb(200, 175, 135);  // light gold divider

// ── Layout ─────────────────────────────────────────────────────────────────
var _card_w  = _gw * 0.80;
var _card_h  = _gh * 0.84;
var _card_x  = (_gw - _card_w) / 2;
var _card_y  = (_gh - _card_h) / 2;

var _pad     = 28;          // inner padding
var _tab_h   = 42;          // height of each tab button
var _tab_cnt = array_length(tabs);
var _tab_w   = _card_w / _tab_cnt;

// ── 1. Dimmed overlay ──────────────────────────────────────────────────────
draw_set_color(_col_overlay);
draw_set_alpha(0.90);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

// ── 2. Card background ─────────────────────────────────────────────────────
draw_set_color(_col_card_bg);
draw_rectangle(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, false);

// ── 3. Gold border ─────────────────────────────────────────────────────────
draw_set_color(_col_card_border);
draw_rectangle(_card_x, _card_y, _card_x + _card_w, _card_y + _card_h, true);

// ── 4. Tab strip ───────────────────────────────────────────────────────────
for (var i = 0; i < _tab_cnt; i++) {
    var _tx = _card_x + i * _tab_w;
    var _ty = _card_y;

    // Tab background
    draw_set_color((i == current_tab) ? _col_tab_active : _col_tab_inact);
    draw_rectangle(_tx, _ty, _tx + _tab_w, _ty + _tab_h, false);

    // Tab border (gold outline on active, subtle on inactive)
    draw_set_color(_col_card_border);
    draw_rectangle(_tx, _ty, _tx + _tab_w, _ty + _tab_h, true);

    // Tab label
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color((i == current_tab) ? _col_tab_txt_a : _col_tab_txt_i);
    draw_text(_tx + _tab_w / 2, _ty + _tab_h / 2, tabs[i].label);
}

// ── 5. Divider line under tab strip ────────────────────────────────────────
draw_set_color(_col_divider);
draw_line(_card_x + 2, _card_y + _tab_h, _card_x + _card_w - 2, _card_y + _tab_h);

// ── 6. NPC attribution line ────────────────────────────────────────────────
var _attr_y = _card_y + _tab_h + 14;
draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(_col_attr);
draw_text(_card_x + _card_w / 2, _attr_y, "As taught by " + tabs[current_tab].npc);

// Subtle divider below attribution
draw_set_color(_col_divider);
draw_line(_card_x + _pad * 2, _attr_y + 20, _card_x + _card_w - _pad * 2, _attr_y + 20);

// ── 7. Body text ───────────────────────────────────────────────────────────
var _body_x  = _card_x + _pad;
var _body_y  = _attr_y + 30;
var _body_w  = _card_w - _pad * 2;
// Reserve space for the bottom hint bar (~30px)
var _body_h  = (_card_y + _card_h) - _body_y - 36;

draw_set_font(fnt_dialogue);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(_col_body);
draw_text_ext(_body_x, _body_y, tabs[current_tab].content, 22, _body_w);

// ── 8. Bottom hint bar ─────────────────────────────────────────────────────
var _hint_y = _card_y + _card_h - 26;

// Divider above hints
draw_set_color(_col_divider);
draw_line(_card_x + _pad, _hint_y - 6, _card_x + _card_w - _pad, _hint_y - 6);

draw_set_font(fnt_dialogue);
draw_set_halign(fa_left);
draw_set_valign(fa_bottom);
draw_set_color(_col_hint);
draw_text(_card_x + _pad, _hint_y + 4, "< >  Switch tabs");

draw_set_halign(fa_right);
draw_text(_card_x + _card_w - _pad, _hint_y + 4, "ESC  Close");

// Reset alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
