// obj_hall_tutorial — Draw GUI Event
// Draws context-sensitive prompts overlaid on the game screen.

var _gw = display_get_gui_width();   // 640
var _gh = display_get_gui_height();  // 360

draw_set_font(fnt_dialogue);
draw_set_alpha(1);

// ── Phases 1-2: Giant pulsing "PRESS E TO CONTINUE" prompt ───────────────────
if (phase == 1 || phase == 2) {
    var _alpha = 0.70 + sin(degtorad(e_pulse)) * 0.30;

    var _bw = 360;
    var _bh = 52;
    var _bx = (_gw - _bw) / 2;
    var _by = _gh - 74;

    // Dark backing
    draw_set_alpha(_alpha * 0.92);
    draw_set_color(make_colour_rgb(8, 8, 30));
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

    // Bright border
    draw_set_alpha(_alpha);
    draw_set_color(c_yellow);
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);

    // Bold label — scale up 1.25x so it's impossible to miss
    draw_set_alpha(1);
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(_gw / 2, _by + _bh / 2,
        ">>>  [ E ]  =  CONTINUE DIALOGUE  <<<", 1.15, 1.15, 0);

    draw_set_alpha(1);
}

// ── Phase 3: WASD key tracker ────────────────────────────────────────────────
if (phase == 3) {
    var _col_done   = make_colour_rgb(80,  220, 80);
    var _col_todo   = make_colour_rgb(200, 200, 200);
    var _col_bg     = make_colour_rgb(8,   8,   30);
    var _col_border = make_colour_rgb(100, 160, 255);

    var _ks  = 38;  // key box size
    var _gap = 6;
    var _cx  = _gw / 2;
    var _ty  = 20;

    // Header
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_text(_cx, _ty, "Press each movement key to learn movement!");

    // Key layout: W on top, A S D below
    var _keys = [
        { label: "W", px: _cx,              py: _ty + 22,              done: w_pressed },
        { label: "A", px: _cx - _ks - _gap, py: _ty + 22 + _ks + _gap, done: a_pressed },
        { label: "S", px: _cx,              py: _ty + 22 + _ks + _gap, done: s_pressed },
        { label: "D", px: _cx + _ks + _gap, py: _ty + 22 + _ks + _gap, done: d_pressed },
    ];

    for (var i = 0; i < 4; i++) {
        var _k  = _keys[i];
        var _bx = _k.px - _ks / 2;
        var _by = _k.py;

        // Background
        draw_set_alpha(0.88);
        draw_set_color(_col_bg);
        draw_rectangle(_bx, _by, _bx + _ks, _by + _ks, false);

        // Border (green if done, blue if not)
        draw_set_alpha(1);
        draw_set_color(_k.done ? _col_done : _col_border);
        draw_rectangle(_bx, _by, _bx + _ks, _by + _ks, true);

        // Label
        draw_set_color(_k.done ? _col_done : _col_todo);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text_transformed(_k.px, _by + _ks / 2, _k.label, 1.3, 1.3, 0);
    }
}

// ── Phases 4-6: "Walk to Greg and press E" reminder ─────────────────────────
if (phase == 5 || phase == 6) {
    var _bw = 370;
    var _bh = 46;
    var _bx = (_gw - _bw) / 2;
    var _by = _gh - 62;

    draw_set_alpha(0.90);
    draw_set_color(make_colour_rgb(8, 8, 30));
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);

    draw_set_alpha(1);
    draw_set_color(make_colour_rgb(100, 210, 255));
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, true);

    draw_set_color(make_colour_rgb(120, 230, 255));
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_gw / 2, _by + _bh / 2, "Walk to Greg and press  [ E ]  to talk!");
}

// Reset draw state
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
