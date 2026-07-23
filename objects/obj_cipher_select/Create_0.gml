// Button layout — all values sized for 640x360 GUI space
btn_w   = 240;
btn_h   = 40;
btn_gap = 12;
cx      = display_get_gui_width()  / 2;
cy_base = display_get_gui_height() / 2;

btn_x1 = cx - btn_w / 2;
btn_x2 = cx + btn_w / 2;

btn1_y = cy_base + 30;                       // Caesar Cipher
btn2_y = btn1_y + btn_h + btn_gap;           // Atbash Cipher
btn3_y = btn2_y + btn_h + btn_gap;           // Vigenère Cipher

caesar_hover = false;
atbash_hover = false;
vigenere_hover = false;

unlock_anim_timer = 0;
unlocking_cipher = "";
if (variable_global_exists("newly_unlocked") && global.newly_unlocked != "" && global.newly_unlocked != "none") {
    unlocking_cipher = global.newly_unlocked;
    global.newly_unlocked = "";
    unlock_anim_timer = 120;
}
