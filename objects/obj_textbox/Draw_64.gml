// --- Updated obj_textbox Draw Event ---

//Draw textbox
// Scale sprite vertically to match the dynamic box height
var _sprite_h = sprite_get_height(dialogue_box);
var _yscale   = (_sprite_h > 0) ? (boxHeight / _sprite_h) : scale;
draw_sprite_ext(dialogue_box, 0, pos_x, pos_y, scale, _yscale, 0, c_white, 1);

// Advance typing + lip-sync counters first so portrait frame is current this frame
#region TYPE 0: TYPING UPDATE (runs before portrait draw)
if (type[page] == 0 and charCount < str_len and !pause) {
	var tsc2 = text_speed_c * 2;
	var txtspd = text_speed[page];
	if (text_speed_c + 1 < text_speed_al && charCount == txtspd[tsc2 + 2]) {
		text_speed_c++;
		tsc2 = text_speed_c * 2;
	}
	charCount += txtspd[tsc2 + 1];

	var ch = string_char_at(text_NE, floor(charCount));
	var audio_increment = 2;
	var _overlay_talk = (portrait_talk[page] != -1 && portrait_talk[page] != portrait[page]);

	switch (ch) {
		case " ": break;
		case ",":
		case ".":
			pause = true;
			alarm[1] = 10;
			break;
		case "?":
		case "!":
			pause = true;
			alarm[1] = 20;
			break;
		default:
			if (_overlay_talk && !pause) {
				portrait_talk_c += portrait_talk_s[page];
				var l = string_lower(ch);
				if (l == "a" or l == "e" or l == "i" or l == "o" or l == "u") {
					portrait_talk_c = open_mouth_frame;
					if (charCount > audio_c && audio_exists(voice[page])) {
						audio_play_sound(voice[page], 1, false);
						audio_c = charCount + audio_increment;
					}
				}
				if (portrait_talk_c >= portrait_talk_n[page]) { portrait_talk_c = 0; }
			} else if (charCount >= audio_c) {
				if (audio_exists(voice[page])) {
					audio_play_sound(voice[page], 1, false);
				}
				audio_c = charCount + audio_increment;
			}
			break;
	}
}
#endregion

#region Draw portrait
if (portrait[page] != -1) {
	var posx = pos_x - portraitWidth;
	var posy = pos_y;
	var _spr = portrait[page];
	var _frm = emotion[page];
	var _full_anim = (portrait_talk[page] != -1 && portrait_talk[page] == portrait[page]);
	var _overlay_talk = (portrait_talk[page] != -1 && portrait_talk[page] != portrait[page]);
	var _talking = (type[page] == 0 && charCount < str_len && !pause);
	var _waiting = (type[page] == 1 || charCount >= str_len);

	if (_full_anim && _talking) {
		_frm = floor(portrait_talk_c) mod portrait_talk_n[page];
	}

	var _frame_w = sprite_get_width(portrait_frame) * scale;
	var _frame_h = sprite_get_height(portrait_frame) * scale;

	// White fill behind portrait (sprites are transparent pixel art)
	var _inset = 3 * scale;
	draw_set_color(c_white);
	draw_set_alpha(1);
	draw_rectangle(posx + _inset, posy + _inset, posx + _frame_w - _inset, posy + _frame_h - _inset, false);

	// Scale portrait to fill the frame box (e.g. 32x32 art into 64x64 frame)
	var _spr_w = sprite_get_width(_spr);
	var _spr_h = sprite_get_height(_spr);
	var _pscale = min(_frame_w / _spr_w, _frame_h / _spr_h);
	var _draw_x = posx + (_frame_w - _spr_w * _pscale) * 0.5;
	var _draw_y = posy + (_frame_h - _spr_h * _pscale) * 0.5;

	draw_sprite_ext(_spr, _frm, _draw_x, _draw_y, _pscale, _pscale, 0, c_white, 1);

	if (_waiting && portrait_idle[page] != -1 && portrait_idle[page] != portrait[page]) {
		var _idle_spr = portrait_idle[page];
		var _idle_w = sprite_get_width(_idle_spr);
		var _idle_h = sprite_get_height(_idle_spr);
		var _idle_scale = min(_frame_w / _idle_w, _frame_h / _idle_h);
		var ix = posx + (_frame_w - _idle_w * _idle_scale) * 0.5;
		var iy = posy + (_frame_h - _idle_h * _idle_scale) * 0.5;
		if (portrait_idle_x[page] != -1) { ix += portrait_idle_x[page] * _idle_scale; }
		if (portrait_idle_y[page] != -1) { iy += portrait_idle_y[page] * _idle_scale; }
		draw_sprite_ext(_idle_spr, floor(portrait_idle_c), ix, iy, _idle_scale, _idle_scale, 0, c_white, 1);
	}

	if (_talking && _overlay_talk) {
		var _talk_spr = portrait_talk[page];
		var _talk_w = sprite_get_width(_talk_spr);
		var _talk_h = sprite_get_height(_talk_spr);
		var _talk_scale = min(_frame_w / _talk_w, _frame_h / _talk_h);
		var tx = posx + (_frame_w - _talk_w * _talk_scale) * 0.5;
		var ty = posy + (_frame_h - _talk_h * _talk_scale) * 0.5;
		if (portrait_talk_x[page] != -1) { tx += portrait_talk_x[page] * _talk_scale; }
		if (portrait_talk_y[page] != -1) { ty += portrait_talk_y[page] * _talk_scale; }
		draw_sprite_ext(_talk_spr, floor(portrait_talk_c), tx, ty, _talk_scale, _talk_scale, 0, c_white, 1);
	}

	draw_sprite_ext(portrait_frame, 0, posx, posy, scale, scale, 0, c_white, 1);
}
#endregion

#region Draw name and namebox
var cname = name[page];

if (cname != "None") {
	draw_sprite_ext(name_box, 0, name_box_x, name_box_y, scale, scale, 0, c_white, 1);
	c = name_col;
	draw_set_halign(fa_center);
	draw_set_font(name_font);
	draw_text_color(name_box_text_x, name_box_text_y, cname, c, c, c, c, 1);
	draw_set_halign(fa_left);
}
#endregion

draw_set_font(font[page]);

#region TYPE 1: DIALOGUE CHOICE
if (type[page] == 1) {
	var col = default_col;
	var tp = text[page];
	var tpl = array_length_1d(tp);
	var txtwidth = boxWidth - (2 * x_buffer);
	var cc = 1;
	var yy = pos_y + y_buffer;
	var xx = pos_x + x_buffer;
	var ii = 0;
	var iy = 0;

	repeat (tpl) {
		if (choice == ii) {
			col = chosen ? select_col : choice_col;
		} else {
			col = c_white;
		}

		var ctext = "* " + tp[ii];
		draw_text_ext_color(xx, yy + ((ii + iy) * stringHeight), ctext, stringHeight, txtwidth, col, col, col, col, 1);

		if (string_width(ctext) > txtwidth) { iy++; }
		ii++;
	}
}
#endregion

#region TYPE 0: NORMAL DIALOGUE
else {
	#region Setup Effects
	var col = default_col;
	var cc = 1;
	var yy = pos_y + y_buffer - scroll_y;
	var xx = pos_x + x_buffer;
	var cx = 0;
	var cy = 0;
	var by = 0;
	var bp_len = -1;
	var effect = 0;
	var next_space;
	var effects_c = 0;
	var text_col_c = 0;
	var bp_array = breakpoints;
	var txtwidth = boxWidth - (2 * x_buffer);

	if (bp_array != -1) {
		bp_len = array_length_1d(bp_array);
		next_space = breakpoints[by];
		by++;
	}

	t += 1;
	#endregion

	#region Draw Letters
	cy_max = 0;
	repeat (charCount) {
		letter = string_char_at(text_NE, cc);

		var ec2 = effects_c * 2;
		if (effects_c < effects_al && effects_p[ec2] == cc) {
			effects_c++;
			effect = effects_p[ec2 + 1];
		}

		var tc2 = text_col_c * 2;
		if (text_col_c < text_col_al && text_col_p[tc2] == cc) {
			text_col_c++;
			col = text_col_p[tc2 + 1];
		}

		if (bp_len != -1 && cc == next_space) {
			cy += 1;
			cx = 0;
			if (cy > cy_max) { cy_max = cy; }
			if (by < bp_len) {
				next_space = breakpoints[by];
				by++;
			}
		}

		var _draw_y = yy + (cy * stringHeight);
		draw_set_alpha((_draw_y >= pos_y + y_buffer && _draw_y < pos_y + boxHeight - y_buffer) ? 1 : 0);

		switch (effect) {
			case 0: draw_text_color(xx + (cx * charSize), yy + (cy * stringHeight), letter, col, col, col, col, 1); break;
			case 1: draw_text_color(xx + (cx * charSize) + random_range(-1, 1), yy + (cy * stringHeight) + random_range(-1, 1), letter, col, col, col, col, 1); break;
			case 2:
				var shift = sin((t + cc) * pi * freq / room_speed) * amplitude;
				draw_text_color(xx + (cx * charSize), yy + (cy * stringHeight) + shift, letter, col, col, col, col, 1);
				break;
			case 3:
				var c1 = make_colour_hsv(t + cc, 255, 255);
				var c2 = make_colour_hsv(t + cc + 34, 255, 255);
				draw_text_color(xx + (cx * charSize), yy + (cy * stringHeight), letter, c1, c1, c2, c2, 1);
				break;
			case 4:
				var so = t + cc;
				var shift = sin(so * pi * freq / room_speed) * amplitude;
				var c1 = make_colour_hsv(t + cc, 255, 255);
				var c2 = make_colour_hsv(t + cc + 45, 255, 255);
				draw_text_color(xx + (cx * charSize), yy + (cy * stringHeight) + shift, letter, c1, c1, c2, c2, 1);
				break;
			case 5:
				var so = t + cc;
				var shift = sin(so * pi * freq / room_speed);
				var mv = charSize / 2;
				draw_set_valign(fa_middle);
				draw_set_halign(fa_middle);
				draw_text_transformed_color(xx + (cx * charSize) + mv, yy + (cy * stringHeight) + (stringHeight / 2), letter, 1, 1, shift * 20, col, col, col, col, 1);
				draw_set_valign(fa_top);
				draw_set_halign(fa_left);
				break;
			case 6:
				var so = t + cc;
				var shift = abs(sin(so * pi * freq / room_speed));
				var mv = charSize / 2;
				draw_set_valign(fa_middle);
				draw_set_halign(fa_middle);
				draw_text_transformed_color(xx + (cx * charSize) + mv, yy + (cy * stringHeight) + (stringHeight / 2), letter, shift, shift, 0, col, col, col, col, 1);
				draw_set_valign(fa_top);
				draw_set_halign(fa_left);
				break;
			case 7:
				var so = t + cc;
				var shift = sin(so * pi * freq / room_speed);
				draw_text_color(xx + (cx * charSize), yy + (cy * stringHeight), letter, col, col, col, col, shift + random_range(-1, 1));
				break;
		}
		draw_set_alpha(1);
		cc += 1;
		cx += 1;
	}
	#endregion

	#region Draw "Finished" effect
	if (charCount >= str_len) {
		var shift = sin((t + cc) * pi * freq / room_speed) * amplitude;
		finishede_count += finishede_spd;
		if (finishede_count >= finishede_num) { finishede_count = 0; }
		draw_sprite(finished_effect, finishede_count, finishede_x + shift, finishede_y);
	}
	#endregion
}
#endregion

// On-screen reminder — right side of the dialogue box
var _pulse = 0.65 + sin(current_time / 200) * 0.35;
var _hint_x  = pos_x + boxWidth + (10 * scale);
var _hint_y  = pos_y + boxHeight * 0.5;
var _hint_str = "Press E\nto continue";
var _hint_sx = 0.9;
var _hint_sy = 0.9;

draw_set_font(fnt_dialogue);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_alpha(1);

// Thin 1px border (not a thick shadow copy)
draw_set_color(c_black);
for (var _d = 0; _d < 8; _d++) {
	var _ox = lengthdir_x(1, _d * 45);
	var _oy = lengthdir_y(1, _d * 45);
	draw_text_transformed(_hint_x + _ox, _hint_y + _oy, _hint_str, _hint_sx, _hint_sy, 0);
}

// Yellow fill — only this layer pulses
draw_set_color(c_yellow);
draw_set_alpha(_pulse);
draw_text_transformed(_hint_x, _hint_y, _hint_str, _hint_sx, _hint_sy, 0);

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
