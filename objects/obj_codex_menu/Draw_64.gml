// --- Draw GUI Event of obj_codex_menu ---
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// 1. DIM THE BACKGROUND
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(0, 0, gui_w, gui_h, false);
draw_set_alpha(1);

// 2. THE CODEX WINDOW
draw_set_color(c_dkgray);
draw_rectangle(gui_w * 0.1, gui_h * 0.1, gui_w * 0.9, gui_h * 0.9, false);
draw_set_color(c_lime); // Cyberpunk Green Border
draw_rectangle(gui_w * 0.1, gui_h * 0.1, gui_w * 0.9, gui_h * 0.9, true);

// 3. THE TEXT CONTENT
draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_text(gui_w / 2, gui_h * 0.15, "--- CRYPTO-CODEX: MODULE 1 ---");

draw_set_halign(fa_left);
var _content = "CAESAR CIPHER BASICS:\n\n- A substitution cipher where letters are shifted.\n- Common in early security testing.\n- Look for frequency patterns to decrypt.\n\nBreado says: 'Don't overthink it, Jack!'";
draw_text_ext(gui_w * 0.15, gui_h * 0.25, _content, 35, gui_w * 0.7);

// 4. FOOTER
draw_set_halign(fa_center);
draw_text(gui_w / 2, gui_h * 0.85, "Press 'C' to Close");