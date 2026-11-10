/// @description obj_cipher_select — Create Event
/// 3-Chapter Dungeon Select Screen (1. Caesar -> 2. Vigenere -> 3. Atbash)
/// with interactive Floor / Phase Selector (1..10) for gameplay & panelist demos.

btn_w   = 380;
btn_h   = 44;
btn_gap = 10;
cx      = display_get_gui_width()  * 0.5;
cy_base = display_get_gui_height() * 0.5;

btn_x1 = cx - btn_w * 0.5;
btn_x2 = cx + btn_w * 0.5;

btn1_y = 92;                         // Chapter 1: Caesar Cipher
btn2_y = btn1_y + btn_h + btn_gap;   // Chapter 2: Vigenere Cipher
btn3_y = btn2_y + btn_h + btn_gap;   // Chapter 3: Atbash Cipher

caesar_hover   = false;
vigenere_hover = false;
atbash_hover   = false;

// Reset intern duty flag upon entering Chapter Select
global.intern_duty_flagged = false;

// Interactive Floor / Phase Selector (1..10)
selected_floor = variable_global_exists("chapter_floor") ? clamp(global.chapter_floor, 1, 10) : 1;

floor_prev_hover = false;
floor_next_hover = false;
preset_tut_hover = false;
preset_prc_hover = false;
preset_exm_hover = false;
demo_unlock_hover = false;

unlock_anim_timer = 0;
unlocking_cipher  = "";
if (variable_global_exists("newly_unlocked") && global.newly_unlocked != "" && global.newly_unlocked != "none") {
    unlocking_cipher      = global.newly_unlocked;
    global.newly_unlocked = "";
    unlock_anim_timer     = 90;
}
