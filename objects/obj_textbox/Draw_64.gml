// --- Visual Novel Dialogue Screen (obj_textbox Draw GUI Event) ---

var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();
vn_stage_acc += 0.12;

var _is_cam_cutscene = instance_exists(obj_dungeon_generator)
    && variable_global_exists("cam_pan_phase")
    && (global.cam_pan_phase != "off");

// 1. Cinematic dimmed backdrop behind the Visual Novel stage
//    (When panning to a dungeon objective room, keep the upper viewport clear so the player can see the room!)
if (_is_cam_cutscene) {
    draw_set_alpha(0.14);
    draw_set_color(make_color_rgb(4, 7, 14));
    draw_rectangle(0, 0, _gui_w, vn_panel_y1 - 6, false);

    draw_set_alpha(0.76);
    draw_rectangle(0, vn_panel_y1 - 6, _gui_w, _gui_h, false);
} else {
    draw_set_alpha(0.72);
    draw_set_color(make_color_rgb(4, 7, 14));
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
}

// Subtle top letterbox bar for cinematic VN framing
draw_set_alpha(0.85);
draw_set_color(make_color_rgb(2, 4, 10));
draw_rectangle(0, 0, _gui_w, 22, false);
draw_set_alpha(0.45);
draw_set_color(make_color_rgb(45, 75, 115));
draw_line(0, 22, _gui_w, 22);

// Draw Objective Room Callout Banner & Target Reticle during Dungeon Camera Pans
if (_is_cam_cutscene && variable_global_exists("cam_pan_label") && global.cam_pan_label != "") {
    var _pan_col = variable_global_exists("cam_pan_col") ? global.cam_pan_col : c_aqua;
    var _pan_sub = variable_global_exists("cam_pan_sublabel") ? global.cam_pan_sublabel : "";
    var _pulse_p = 0.5 + 0.5 * sin(current_time / 160);

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    var _bw = max(290, string_width(global.cam_pan_label) * 0.90 + 44);
    var _bh = (_pan_sub != "") ? 34 : 22;
    var _bx1 = (_gui_w * 0.5) - _bw * 0.5;
    var _by1 = 26;
    var _bx2 = (_gui_w * 0.5) + _bw * 0.5;
    var _by2 = _by1 + _bh;

    draw_set_alpha(0.92);
    draw_set_color(make_color_rgb(10, 16, 28));
    draw_rectangle(_bx1, _by1, _bx2, _by2, false);
    draw_set_alpha(0.95);
    draw_set_color(_pan_col);
    draw_rectangle(_bx1, _by1, _bx2, _by2, true);
    draw_rectangle(_bx1 + 2, _by1 + 2, _bx2 - 2, _by2 - 2, true);

    draw_set_alpha(1.0);
    draw_set_color(_pan_col);
    draw_text_transformed(_gui_w * 0.5, _by1 + 11, global.cam_pan_label, 0.86, 0.86, 0);

    if (_pan_sub != "") {
        draw_set_color(c_white);
        draw_text_transformed(_gui_w * 0.5, _by1 + 25, _pan_sub, 0.72, 0.72, 0);
    }

    // Pulsing target bracket & downward pointer over the focused room at viewport center
    var _ret_cx = _gui_w * 0.5;
    var _ret_cy = 136;
    var _ret_r  = 30 + _pulse_p * 5;
    var _bob_y  = sin(current_time / 150) * 3;

    draw_set_alpha(0.65 + _pulse_p * 0.30);
    draw_set_color(_pan_col);
    // Corner brackets around target object
    draw_line(_ret_cx - _ret_r, _ret_cy - _ret_r, _ret_cx - _ret_r + 10, _ret_cy - _ret_r);
    draw_line(_ret_cx - _ret_r, _ret_cy - _ret_r, _ret_cx - _ret_r, _ret_cy - _ret_r + 10);
    draw_line(_ret_cx + _ret_r, _ret_cy - _ret_r, _ret_cx + _ret_r - 10, _ret_cy - _ret_r);
    draw_line(_ret_cx + _ret_r, _ret_cy - _ret_r, _ret_cx + _ret_r, _ret_cy - _ret_r + 10);
    draw_line(_ret_cx - _ret_r, _ret_cy + _ret_r, _ret_cx - _ret_r + 10, _ret_cy + _ret_r);
    draw_line(_ret_cx - _ret_r, _ret_cy + _ret_r, _ret_cx - _ret_r, _ret_cy + _ret_r - 10);
    draw_line(_ret_cx + _ret_r, _ret_cy + _ret_r, _ret_cx + _ret_r - 10, _ret_cy + _ret_r);
    draw_line(_ret_cx + _ret_r, _ret_cy + _ret_r, _ret_cx + _ret_r, _ret_cy + _ret_r - 10);

    // Downward pointer arrow above target
    var _arr_y = _ret_cy - _ret_r - 6 + _bob_y;
    draw_triangle(_ret_cx - 6, _arr_y - 7, _ret_cx + 6, _arr_y - 7, _ret_cx, _arr_y, false);

    draw_set_alpha(1.0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Advance typing + lip-sync counters first so portrait & stage animations are current this frame
#region TYPE 0: TYPING UPDATE (runs before stage & portrait draw)
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

// ---------------------------------------------------------------------------
// 2. Determine Active Speaker & Resolve Visual Novel Stage Character Sprites
// ---------------------------------------------------------------------------
var _total_pages = array_length_1d(text);
var _cname       = name[page];
var _cur_spk     = speaker[page];
var _talking     = (type[page] == 0 && charCount < str_len && !pause);
var _waiting     = (type[page] == 1 || charCount >= str_len);

var _is_jack_speaking = (_cname == "Jack") || (instance_exists(_cur_spk) && _cur_spk.object_index == obj_jack);

// Search all pages of this dialogue for an NPC conversation partner (if any)
var _partner_idx  = -1;
if (!_is_jack_speaking) {
	_partner_idx = page;
} else {
	for (var _pi = 0; _pi < _total_pages; _pi++) {
		var _p_spk  = speaker[_pi];
		var _p_name = name[_pi];
		var _p_jack = (_p_name == "Jack") || (instance_exists(_p_spk) && _p_spk.object_index == obj_jack);
		if (!_p_jack && _p_name != "None") {
			_partner_idx = _pi;
			break;
		}
	}
}

var _partner_spr  = -1;
var _partner_name = "";
if (_partner_idx != -1) {
	_partner_name = name[_partner_idx];
	var _p_inst   = speaker[_partner_idx];
	var _p_port   = portrait[_partner_idx];

	if (instance_exists(_p_inst) && variable_instance_exists(_p_inst, "npc_spr") && _p_inst.npc_spr != -1) {
		_partner_spr = _p_inst.npc_spr;
	} else if (_p_port == spr_greg_portrait || _p_port == spr_npc1_portrait) {
		_partner_spr = spr_npc1_idle;
	} else if (_p_port == spr_npc2_portrait) {
		_partner_spr = spr_npc2_idle;
	} else if (_p_port == spr_kyle_portrait) {
		_partner_spr = spr_kyle_idle;
	} else if (_p_port == spr_lea_portrait) {
		_partner_spr = spr_lea_idle;
	} else if (_p_port == spr_david_portrait) {
		_partner_spr = spr_david_idle;
	} else if (_p_port == spr_clipper_portrait) {
		_partner_spr = spr_clipper_idle;
	} else if (instance_exists(_p_inst) && _p_inst.sprite_index != -1 && _p_inst.object_index != obj_dungeon_prop) {
		_partner_spr = _p_inst.sprite_index;
	}
}

// ---------------------------------------------------------------------------
// 3. Draw Large Visual Novel Character Sprites on Left & Right Stage
// ---------------------------------------------------------------------------
var _stage_feet_y = vn_panel_y1 + 4;
var _left_cx      = _is_cam_cutscene ? 68  : ((_partner_spr != -1) ? 148 : 136);
var _right_cx     = _is_cam_cutscene ? 572 : 492;
var _stage_mult   = _is_cam_cutscene ? 0.74 : 1.0;

// --- LEFT STAGE: JACK ---
var _jack_spr   = spr_jack_idle;
var _jack_scale = (_is_jack_speaking ? 4.8 : 4.1) * _stage_mult;
var _jack_col   = _is_jack_speaking ? c_white : make_color_rgb(105, 118, 142);
var _jack_alpha = _is_jack_speaking ? 1.0 : 0.82;
var _jack_bob   = (_is_jack_speaking && _talking) ? (abs(sin(current_time / 75)) * -4) : 0;

if (_is_jack_speaking) {
	// Soft cyan stage spotlight behind Jack when speaking
	draw_set_alpha(0.14);
	draw_set_color(c_aqua);
	draw_circle(_left_cx, _stage_feet_y - 52 * _stage_mult, 54 * _stage_mult, false);
}

var _j_anim  = scr_dir_idle_anim(_jack_spr, "down", vn_stage_acc, 0);
var _j_frame = _j_anim[0];
var _j_dx    = _left_cx - (sprite_get_width(_jack_spr) * 0.5 - sprite_get_xoffset(_jack_spr)) * _jack_scale;
var _j_dy    = scr_battle_sprite_feet_y(_jack_spr, _jack_scale, _stage_feet_y + _jack_bob);
draw_sprite_ext(_jack_spr, _j_frame, _j_dx, _j_dy, _jack_scale, _jack_scale, 0, _jack_col, _jack_alpha);

// --- RIGHT STAGE: CONVERSATION PARTNER NPC (if present) ---
if (_partner_spr != -1) {
	var _npc_speaking = !_is_jack_speaking;
	var _npc_scale    = (_npc_speaking ? 4.8 : 4.1) * _stage_mult;
	var _npc_col      = _npc_speaking ? c_white : make_color_rgb(105, 118, 142);
	var _npc_alpha    = _npc_speaking ? 1.0 : 0.82;
	var _npc_bob      = (_npc_speaking && _talking) ? (abs(sin(current_time / 75)) * -4) : 0;

	if (_npc_speaking) {
		// Soft amber/gold stage spotlight behind NPC when speaking
		draw_set_alpha(0.14);
		draw_set_color(make_color_rgb(255, 200, 55));
		draw_circle(_right_cx, _stage_feet_y - 52 * _stage_mult, 54 * _stage_mult, false);
	}

	var _n_anim  = scr_dir_idle_anim(_partner_spr, "down", vn_stage_acc, 0);
	var _n_frame = _n_anim[0];
	var _n_dx    = _right_cx - (sprite_get_width(_partner_spr) * 0.5 - sprite_get_xoffset(_partner_spr)) * _npc_scale;
	var _n_dy    = scr_battle_sprite_feet_y(_partner_spr, _npc_scale, _stage_feet_y + _npc_bob);
	draw_sprite_ext(_partner_spr, _n_frame, _n_dx, _n_dy, _npc_scale, _npc_scale, 0, _npc_col, _npc_alpha);
}

// ---------------------------------------------------------------------------
// 4. Draw Sleek Visual Novel Dialogue Panel & Speaker Nameplate Banner
// ---------------------------------------------------------------------------
var _accent_col = _is_jack_speaking ? c_aqua : make_color_rgb(255, 200, 55);

// Drop shadow under VN panel
draw_set_alpha(0.55);
draw_set_color(c_black);
draw_rectangle(vn_panel_x1 + 3, vn_panel_y1 + 3, vn_panel_x2 + 3, vn_panel_y2 + 3, false);

// Main dark slate VN dialogue box fill
draw_set_alpha(0.96);
draw_set_color(make_color_rgb(11, 16, 28));
draw_rectangle(vn_panel_x1, vn_panel_y1, vn_panel_x2, vn_panel_y2, false);

// Top accent bar & outer neon border
draw_set_alpha(0.90);
draw_set_color(_accent_col);
draw_rectangle(vn_panel_x1, vn_panel_y1, vn_panel_x2, vn_panel_y1 + 2, false);
draw_rectangle(vn_panel_x1, vn_panel_y1, vn_panel_x2, vn_panel_y2, true);

// Subtle inner frame
draw_set_alpha(0.28);
draw_set_color(_accent_col);
draw_rectangle(vn_panel_x1 + 3, vn_panel_y1 + 3, vn_panel_x2 - 3, vn_panel_y2 - 3, true);
draw_set_alpha(1.0);

// --- SPEAKER NAMEPLATE BANNER (Left-aligned for Jack, Right-aligned for NPC) ---
if (_cname != "None") {
	draw_set_font(name_font);
	var _nw   = clamp(string_width(_cname) + 28, 110, 250);
	var _nh   = 22;
	var _nx1  = _is_jack_speaking ? (vn_panel_x1 + 12) : (vn_panel_x2 - 12 - _nw);
	var _ny1  = vn_panel_y1 - _nh + 1;
	var _nx2  = _nx1 + _nw;
	var _ny2  = vn_panel_y1 + 1;

	draw_set_alpha(0.98);
	draw_set_color(make_color_rgb(16, 24, 42));
	draw_rectangle(_nx1, _ny1, _nx2, _ny2, false);

	draw_set_color(_accent_col);
	draw_rectangle(_nx1, _ny1, _nx2, _ny2, true);
	draw_rectangle(_nx1, _ny1, _nx1 + 4, _ny2, false);

	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_color(_is_jack_speaking ? c_aqua : make_color_rgb(255, 220, 90));
	draw_text((_nx1 + _nx2) * 0.5 + 2, (_ny1 + _ny2) * 0.5, _cname);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}

// ---------------------------------------------------------------------------
// 5. Draw Animated Portrait Mugshot Card Inside Left of VN Box
// ---------------------------------------------------------------------------
#region Draw portrait
var _spr = portrait[page];
if (_spr == -1 && _is_jack_speaking) {
	_spr = spr_jack_portrait;
}
if (_spr != -1) {
	var posx      = vn_panel_x1 + 12;
	var posy      = vn_panel_y1 + 14;
	var _frame_w  = 64;
	var _frame_h  = 64;
	var _frm      = emotion[page];
	var _full_anim    = (portrait_talk[page] != -1 && portrait_talk[page] == portrait[page]);
	var _overlay_talk = (portrait_talk[page] != -1 && portrait_talk[page] != portrait[page]);

	if (_full_anim && _talking) {
		_frm = floor(portrait_talk_c) mod portrait_talk_n[page];
	} else if (_spr == spr_jack_portrait && _talking) {
		_frm = floor(current_time / 70) mod sprite_get_number(spr_jack_portrait);
	}

	// Portrait card backing
	draw_set_color(make_color_rgb(235, 240, 248));
	draw_set_alpha(1);
	draw_rectangle(posx + 2, posy + 2, posx + _frame_w - 2, posy + _frame_h - 2, false);

	var _spr_w  = sprite_get_width(_spr);
	var _spr_h  = sprite_get_height(_spr);
	var _pscale = min(_frame_w / _spr_w, _frame_h / _spr_h);
	var _draw_x = posx + (_frame_w - _spr_w * _pscale) * 0.5;
	var _draw_y = posy + (_frame_h - _spr_h * _pscale) * 0.5;

	draw_sprite_ext(_spr, _frm, _draw_x, _draw_y, _pscale, _pscale, 0, c_white, 1);

	if (_waiting && portrait_idle[page] != -1 && portrait_idle[page] != portrait[page]) {
		var _idle_spr   = portrait_idle[page];
		var _idle_w     = sprite_get_width(_idle_spr);
		var _idle_h     = sprite_get_height(_idle_spr);
		var _idle_scale = min(_frame_w / _idle_w, _frame_h / _idle_h);
		var ix = posx + (_frame_w - _idle_w * _idle_scale) * 0.5;
		var iy = posy + (_frame_h - _idle_h * _idle_scale) * 0.5;
		if (portrait_idle_x[page] != -1) { ix += portrait_idle_x[page] * _idle_scale; }
		if (portrait_idle_y[page] != -1) { iy += portrait_idle_y[page] * _idle_scale; }
		draw_sprite_ext(_idle_spr, floor(portrait_idle_c), ix, iy, _idle_scale, _idle_scale, 0, c_white, 1);
	}

	if (_talking && _overlay_talk) {
		var _talk_spr   = portrait_talk[page];
		var _talk_w     = sprite_get_width(_talk_spr);
		var _talk_h     = sprite_get_height(_talk_spr);
		var _talk_scale = min(_frame_w / _talk_w, _frame_h / _talk_h);
		var tx = posx + (_frame_w - _talk_w * _talk_scale) * 0.5;
		var ty = posy + (_frame_h - _talk_h * _talk_scale) * 0.5;
		if (portrait_talk_x[page] != -1) { tx += portrait_talk_x[page] * _talk_scale; }
		if (portrait_talk_y[page] != -1) { ty += portrait_talk_y[page] * _talk_scale; }
		draw_sprite_ext(_talk_spr, floor(portrait_talk_c), tx, ty, _talk_scale, _talk_scale, 0, c_white, 1);
	}

	draw_set_color(_accent_col);
	draw_rectangle(posx, posy, posx + _frame_w, posy + _frame_h, true);
}
#endregion

draw_set_font(font[page]);
draw_set_color(c_white);

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
}
#endregion

// ---------------------------------------------------------------------------
// 6. Page Progress Indicator & Pulsing "[E] NEXT" Prompt Inside VN Box Footer
// ---------------------------------------------------------------------------
draw_set_font(fnt_dialogue);
draw_set_valign(fa_middle);

// Page indicator (e.g., "1 / 3") below the portrait card
if (_total_pages > 1) {
	draw_set_halign(fa_center);
	draw_set_alpha(0.70);
	draw_set_color(make_color_rgb(160, 180, 210));
	draw_text_transformed(vn_panel_x1 + 44, vn_panel_y1 + 92, string(page + 1) + " / " + string(_total_pages), 0.75, 0.75, 0);
}

// Pulsing [E] prompt inside bottom-right of VN box
var _pulse   = 0.65 + sin(current_time / 180) * 0.35;
var _is_last = (page + 1 >= _total_pages);
var _prompt  = (charCount < str_len) ? "[E] SKIP" : (_is_last ? "[E] DONE" : "[E] NEXT >");

draw_set_halign(fa_right);
draw_set_alpha(_pulse);
draw_set_color(_accent_col);
draw_text_transformed(vn_panel_x2 - 14, vn_panel_y2 - 12, _prompt, 0.80, 0.80, 0);

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
