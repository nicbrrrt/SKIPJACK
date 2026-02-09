// --- Draw GUI Event of obj_codex_menu ---

// 1. THE FIX: Define these variables so the draw_text_ext can read them!
var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

// 2. DIM THE BACKGROUND
draw_set_alpha(0.7);
draw_set_color(c_black);
draw_rectangle(0, 0, gui_w, gui_h, false);
draw_set_alpha(1);

// 3. THE CODEX WINDOW
draw_set_color(c_dkgray);
draw_rectangle(gui_w * 0.1, gui_h * 0.1, gui_w * 0.9, gui_h * 0.9, false);
draw_set_color(c_lime); 
draw_rectangle(gui_w * 0.1, gui_h * 0.1, gui_w * 0.9, gui_h * 0.9, true);

// 4. PREPARE THE CONTENT
var _header = "--- CRYPTO-CODEX: MODULE 1 ---\n\n";
var _body = "";

// Check if Greg has done the Level 1 intro yet
if (global.level1_intro_done) {
    _body = "PHISHING: Deceptive emails/sites used to steal data.\n" +
            "SPYWARE: Software that tracks your activity in secret.\n" +
            "FIREWALLS: Barriers that filter network traffic.\n" +
            "BOTNET: A network of hijacked computers controlled as a group.";
} else {
    _body = "CAESAR CIPHER: A substitution cipher where letters are shifted.\n" +
            "Breado says: 'Check the shift value, Jack!'";
}

// 5. DRAW THE TEXT
draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_text(gui_w / 2, gui_h * 0.15, _header);

draw_set_halign(fa_left);
// Using the gui_w and gui_h we defined at the top
draw_text_ext(gui_w * 0.15, gui_h * 0.25, _body, 35, gui_w * 0.7);

// 6. FOOTER
draw_set_halign(fa_center);
draw_text(gui_w / 2, gui_h * 0.85, "Press 'C' to Close");