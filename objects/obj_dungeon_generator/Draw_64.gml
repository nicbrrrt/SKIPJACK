/// @description obj_dungeon_generator — Draw GUI Event
/// Displays the Dungeon Floor HUD, Caesar Key status, and contextual [E] interaction prompts.

if (!gen_complete) exit;
if (instance_exists(obj_dungeon_victory) || instance_exists(obj_dungeon_quiz) || instance_exists(obj_cipher)) exit;

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_set_font(fnt_dialogue);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

// Top-left status bar
draw_set_alpha(0.75);
draw_set_color(make_color_rgb(10, 14, 22));
draw_rectangle(8, 8, 250, 48, false);
draw_set_alpha(1.0);
draw_set_color(c_aqua);
draw_rectangle(8, 8, 250, 48, true);

var _floor_num = (variable_global_exists("dungeons_cleared") ? global.dungeons_cleared : 0) + 1;
draw_set_color(c_white);
draw_text(16, 18, "SECTOR FLOOR #" + string(_floor_num));

var _has_key = (variable_global_exists("has_dungeon_cipher_key") && global.has_dungeon_cipher_key);
if (_has_key) {
    var _k = global.dungeon_cipher_key;
    var _k_str = (_k > 0) ? ("+" + string(_k)) : string(_k);
    draw_set_color(c_lime);
    draw_text(16, 36, "CAESAR KEY: SHIFT " + _k_str);
} else {
    draw_set_color(make_color_rgb(255, 200, 50));
    draw_text(16, 36, "CAESAR KEY: NOT FOUND");
}

// Contextual bottom prompt when near a locked door or key pedestal
if (instance_exists(obj_jack)) {
    var _prompt = "";
    var _pcol   = c_white;

    // Check proximity to Quiz Lock Door
    with (obj_door_quiz_lock) {
        if (locked && point_distance(obj_jack.x, obj_jack.y - 8, draw_x + 8, draw_y + 8) < 28) {
            _prompt = "[E] Answer Cybersecurity Question (Unlock Key Vault)";
            _pcol   = make_color_rgb(255, 210, 55);
            break;
        }
    }

    // Check proximity to Caesar Cipher Lock Door
    if (_prompt == "") {
        with (obj_door_caesar_lock) {
            if (locked && point_distance(obj_jack.x, obj_jack.y - 8, draw_x + 8, draw_y + 8) < 28) {
                _prompt = _has_key
                    ? "[E] Decode Caesar Cipher Lock (Key: " + ((global.dungeon_cipher_key > 0) ? "+" : "") + string(global.dungeon_cipher_key) + ")"
                    : "[E] Inspect Caesar Lock (Key in Gold Vault Room)";
                _pcol = make_color_rgb(255, 95, 150);
                break;
            }
        }
    }

    if (_prompt != "") {
        draw_set_halign(fa_center);
        var _pw = string_width(_prompt) + 24;
        var _py = _gui_h - 26;
        draw_set_alpha(0.82);
        draw_set_color(make_color_rgb(10, 14, 22));
        draw_rectangle((_gui_w - _pw) * 0.5, _py - 12, (_gui_w + _pw) * 0.5, _py + 12, false);
        draw_set_alpha(1.0);
        draw_set_color(_pcol);
        draw_rectangle((_gui_w - _pw) * 0.5, _py - 12, (_gui_w + _pw) * 0.5, _py + 12, true);
        draw_text(_gui_w * 0.5, _py, _prompt);
    }
}

draw_set_font(fnt_default);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1.0);
