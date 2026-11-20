// --- obj_review_screen Create Event ---
// Main-menu CODEX / modules browser (separate from in-game C-key codex).

display_set_gui_size(window_get_width(), window_get_height());

current_tab    = 0;
current_module = 0;
content_scroll = 0;

// Layout cache (filled by review_refresh_layout)
card_x = 0; card_y = 0; card_w = 0; card_h = 0;
tab_h = 42; tab_w = 0; tab_cnt = 0; tab_strip_y = 0;
pad = 28;
content_y1 = 0; content_y2 = 0; body_x = 0; body_y = 0; body_w = 0; body_h = 0;
hint_y = 0;

function review_refresh_layout() {
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    card_w = _gw * 0.82;
    card_h = _gh * 0.86;
    card_x = (_gw - card_w) * 0.5;
    card_y = (_gh - card_h) * 0.5;
    tab_cnt = array_length(tabs);
    tab_w   = card_w / tab_cnt;
    tab_strip_y = card_y + 30;
    hint_y      = card_y + card_h - 30;
    content_y1  = tab_strip_y + tab_h + 4;
    content_y2  = hint_y - 12;
    body_x      = card_x + pad;
    body_y      = content_y1 + 52;
    body_w      = card_w - pad * 2;
    body_h      = max(40, content_y2 - body_y);
}

function review_active_mod_count() {
    return array_length(tabs[current_tab].modules);
}

function review_active_mod() {
    var _mods = tabs[current_tab].modules;
    var _n = array_length(_mods);
    if (_n <= 0) return { title: "NO MODULES", content: "" };
    current_module = clamp(current_module, 0, _n - 1);
    return _mods[current_module];
}

function review_content_height(_text) {
    return string_height_ext(_text, 22, body_w);
}

function review_max_scroll(_text) {
    return max(0, review_content_height(_text) - body_h);
}

// Tab structure built from the shared 5-Branch Cybersecurity Glossary
scr_init_cyber_glossary();
tabs = [];
for (var _b = 0; _b < array_length(global.cyber_branch_names); _b++) {
    var _b_mods = [];
    for (var _g = 0; _g < array_length(global.cyber_glossary); _g++) {
        var _entry = global.cyber_glossary[_g];
        if (_entry.branch_idx == _b) {
            array_push(_b_mods, {
                title: _entry.term,
                content:
                    "QUICK SUMMARY\n" + _entry.short_def + "\n\n" +
                    "HOW IT WORKS IN DEPTH\n" + _entry.deep_how + "\n\n" +
                    "REAL-WORLD IMPACT\n" + _entry.deep_real + "\n\n" +
                    "DEFENSE & PREVENTION\n" + _entry.deep_defense
            });
        }
    }
    array_push(tabs, {
        label:   global.cyber_branch_names[_b],
        locked:  false,
        modules: _b_mods
    });
}

review_refresh_layout();
