// --- obj_codex_manager Draw GUI ---

if (!is_open) exit;

var _w = 640;
var _h = 360;

// ── 1. Background overlay ────────────────────────────────────────────────
draw_set_color(c_black);
draw_set_alpha(0.85);
draw_rectangle(0, 0, _w, _h, false);
draw_set_alpha(1);

// ── Layout constants ─────────────────────────────────────────────────────
var _fx1    = 120;  // frame left
var _fy1    = 60;   // frame top
var _fx2    = 520;  // frame right
var _fy2    = 300;  // frame bottom
var _tab_h  = 28;   // height of the tab header strip
var _num    = array_length(tab_names);
var _tab_w  = (_fx2 - _fx1) / _num;  // 100 px each tab

// ── 2. Tab header strip ──────────────────────────────────────────────────
for (var i = 0; i < _num; i++) {
    var _tx1 = _fx1 + i * _tab_w;
    var _tx2 = _tx1 + _tab_w;
    var _ty1 = _fy1;
    var _ty2 = _fy1 + _tab_h;
    var _tcx = _tx1 + _tab_w * 0.5;
    var _tcy = _ty1 + _tab_h * 0.5;

    if (tab_locked[i]) {
        // Locked: dark grey fill + dim border
        draw_set_color(c_dkgray); draw_set_alpha(0.2);
        draw_rectangle(_tx1, _ty1, _tx2, _ty2, false);
        draw_set_alpha(1);
        draw_set_color(c_dkgray);
        draw_rectangle(_tx1, _ty1, _tx2, _ty2, true);

        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_dkgray);
        draw_text_transformed(_tcx, _tcy - 5, tab_names[i], 0.70, 0.70, 0);
        draw_text_transformed(_tcx, _tcy + 7, "[LOCKED]",   0.62, 0.62, 0);

    } else if (i == current_tab) {
        // Active unlocked tab: lime highlight
        draw_set_color(c_lime); draw_set_alpha(0.22);
        draw_rectangle(_tx1, _ty1, _tx2, _ty2, false);
        draw_set_alpha(1);
        draw_set_color(c_lime);
        draw_rectangle(_tx1, _ty1, _tx2, _ty2, true);

        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_lime);
        draw_text_transformed(_tcx, _tcy, tab_names[i], 0.70, 0.70, 0);

    } else {
        // Inactive unlocked tab: faint border
        draw_set_color(c_lime); draw_set_alpha(0.08);
        draw_rectangle(_tx1, _ty1, _tx2, _ty2, false);
        draw_set_alpha(0.45);
        draw_set_color(c_lime);
        draw_rectangle(_tx1, _ty1, _tx2, _ty2, true);
        draw_set_alpha(1);

        draw_set_font(fnt_dialogue);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text_transformed(_tcx, _tcy, tab_names[i], 0.70, 0.70, 0);
    }
}

// ── 3. Content pane border (below tab strip) ─────────────────────────────
draw_set_color(c_lime);
draw_set_alpha(1);
draw_rectangle(_fx1, _fy1 + _tab_h, _fx2, _fy2, true);

// ── 4. Module content ────────────────────────────────────────────────────
var _tab_mods   = tab_modules[current_tab];
var _mod_count  = array_length(_tab_mods);
var _content_cx = (_fx1 + _fx2) * 0.5;  // 320
var _content_y  = _fy1 + _tab_h;        // top of content pane

if (_mod_count == 0) {
    draw_set_color(c_red);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text(_content_cx, _content_y + 20, "NO CONTENT AVAILABLE");
} else {
    current_module = clamp(current_module, 0, _mod_count - 1);
    var _mod = _tab_mods[current_module];

    // Module title (lime, 1.2x, centered)
    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_lime);
    draw_text_transformed(_content_cx, _content_y + 12, "--- " + _mod.title + " ---", 1.2, 1.2, 0);

    // Module body (white, left-aligned, word-wrapped)
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text_ext(_fx1 + 15, _content_y + 40, _mod.content, 30, (_fx2 - _fx1) - 30);

    // Navigation footer
    draw_set_halign(fa_center);
    draw_set_color(c_lime);
    draw_set_alpha(0.70);
    draw_text(_content_cx, _fy2 - 20, "Module " + string(current_module + 1) + " of " + string(_mod_count) + "   |   Scroll Wheel or Arrow Keys");
    draw_text(_content_cx, _fy2 -  7, "C or ESC to Close");
    draw_set_alpha(1);
}

// ── Reset draw state ─────────────────────────────────────────────────────
draw_set_halign(fa_left);
draw_set_valign(fa_top);
