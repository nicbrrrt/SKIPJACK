/// @description Statue System — Homeroom Statues, Mechanic Wall Telephone Orders (1-Workday Delivery),
/// 3-Pedestal Loadout, Cipher Trace Timers & End-of-Floor Corporate Paycheck helpers.
///
/// Statue IDs:
///   0 = Blind Watcher Bust   (-30% Security Bot vision cone)
///   1 = Chronos CPU Hourglass (+12s on every Cipher / Sever / Override timer)
///   2 = Copper Surge Totem    (first Anti-Tamper shock per floor is absorbed)

#macro STATUE_COUNT 3

// ---------------------------------------------------------------------------
/// @function scr_statue_ensure_globals()
/// @description Safe-init for every statue / paycheck global (in case a room is
///              launched directly without obj_game_init having run first).
// ---------------------------------------------------------------------------
function scr_statue_ensure_globals() {
    if (!variable_global_exists("player_cash"))        global.player_cash        = 250;
    if (!variable_global_exists("scrap_count"))        global.scrap_count        = 0;
    if (!variable_global_exists("rare_cores"))         global.rare_cores         = 0;
    if (!variable_global_exists("statues_owned"))      global.statues_owned      = [false, false, false];
    if (!variable_global_exists("statues_pending"))    global.statues_pending    = [false, false, false];
    if (!variable_global_exists("equipped_statues"))   global.equipped_statues   = [-1, -1, -1];
    if (!variable_global_exists("phone_ui_open"))      global.phone_ui_open      = false;
    if (!variable_global_exists("shelf_ui_open"))      global.shelf_ui_open      = false;
    if (!variable_global_exists("floor_cipher_fails")) global.floor_cipher_fails = 0;
    if (!variable_global_exists("floor_times_busted")) global.floor_times_busted = 0;
    if (!variable_global_exists("surge_shield_used"))  global.surge_shield_used  = false;
    if (!variable_global_exists("esc_block_frames"))   global.esc_block_frames   = 0;
}

// ---------------------------------------------------------------------------
/// @function scr_get_statue_catalog()
/// @description Returns the metadata for all statues (name, effect, order cost).
// ---------------------------------------------------------------------------
function scr_get_statue_catalog() {
    return [
        {
            sid:    0,
            name:   "Blind Watcher Bust",
            effect: "-30% Security Bot Vision Cone",
            detail: "Bot flashlight angle 64 -> 44 deg, range 94 -> 66 px",
            cash:   200,
            scrap:  3,
            cores:  1,
            col:    make_color_rgb(255, 150, 60)
        },
        {
            sid:    1,
            name:   "Chronos CPU Hourglass",
            effect: "+12s on All Cipher Timers",
            detail: "Door ciphers, Wrench Sever & Lockdown Override",
            cash:   200,
            scrap:  3,
            cores:  1,
            col:    make_color_rgb(255, 215, 70)
        },
        {
            sid:    2,
            name:   "Copper Surge Totem",
            effect: "Anti-Tamper Shield (1 per floor)",
            detail: "First wrong code / timeout while severing will NOT fry circuits",
            cash:   250,
            scrap:  4,
            cores:  1,
            col:    make_color_rgb(80, 225, 235)
        }
    ];
}

// ---------------------------------------------------------------------------
/// @function scr_has_active_statue(_sid)
/// @description True when the statue has been delivered AND is placed on one of
///              the 3 Homeroom pedestals.
// ---------------------------------------------------------------------------
function scr_has_active_statue(_sid) {
    if (!variable_global_exists("equipped_statues") || !variable_global_exists("statues_owned")) return false;
    if (_sid < 0 || _sid >= STATUE_COUNT) return false;
    if (!global.statues_owned[_sid]) return false;
    for (var _i = 0; _i < 3; _i++) {
        if (global.equipped_statues[_i] == _sid) return true;
    }
    return false;
}

// ---------------------------------------------------------------------------
/// @function scr_get_cipher_timer_frames(_kind)
/// @param {String} _kind "door" (4-letter door cipher) or "sever" (2-letter Sever / Override)
/// @description Base timers: door = 28s (40s on guided Tutorial Floors 1-3), sever = 20s.
///              Chronos CPU Hourglass adds +12s.
// ---------------------------------------------------------------------------
function scr_get_cipher_timer_frames(_kind) {
    var _curr = variable_global_exists("floor_curriculum") ? global.floor_curriculum : undefined;
    var _sec  = 20;
    if (_kind == "door") {
        _sec = (!is_undefined(_curr) && _curr.guided_ui) ? 40 : 28;
    }
    if (scr_has_active_statue(1)) _sec += 12;
    return _sec * game_get_speed(gamespeed_fps);
}

// ---------------------------------------------------------------------------
/// @function scr_draw_trace_timer(_cx, _y, _w, _frames, _max_frames)
/// @description Draws the Firewall Trace Timer bar (Cyan -> Amber -> flashing Red).
// ---------------------------------------------------------------------------
function scr_draw_trace_timer(_cx, _y, _w, _frames, _max_frames) {
    var _fps  = game_get_speed(gamespeed_fps);
    var _frac = clamp(_frames / max(1, _max_frames), 0, 1);
    var _secs = max(0, _frames) / _fps;
    var _x1   = _cx - _w * 0.5;

    var _col = c_aqua;
    if (_secs <= 10) _col = make_color_rgb(255, 190, 55);
    if (_secs <= 5)  _col = (current_time mod 300 < 160) ? make_color_rgb(255, 70, 70) : make_color_rgb(255, 170, 60);

    draw_set_alpha(0.92);
    draw_set_color(make_color_rgb(10, 14, 22));
    draw_rectangle(_x1 - 1, _y - 1, _x1 + _w + 1, _y + 9, false);
    draw_set_alpha(1.0);
    draw_set_color(_col);
    draw_rectangle(_x1, _y, _x1 + _w * _frac, _y + 8, false);
    draw_set_color(make_color_rgb(95, 120, 150));
    draw_rectangle(_x1 - 1, _y - 1, _x1 + _w + 1, _y + 9, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_black);
    draw_text_transformed(_cx + 1, _y + 5, "TRACE TIMER: " + string_format(_secs, 1, 1) + "s", 0.58, 0.58, 0);
    draw_set_color(c_white);
    draw_text_transformed(_cx, _y + 4, "TRACE TIMER: " + string_format(_secs, 1, 1) + "s", 0.58, 0.58, 0);
}

// ---------------------------------------------------------------------------
/// @function scr_draw_statue_sprite(_sid, _cx, _by, _s)
/// @description Procedural pixel-style art for each statue. (_cx,_by) = bottom-center.
// ---------------------------------------------------------------------------
function scr_draw_statue_sprite(_sid, _cx, _by, _s) {
    draw_set_alpha(1.0);
    var _steel  = make_color_rgb(150, 162, 182);
    var _dark   = make_color_rgb(34, 40, 54);
    var _brass  = make_color_rgb(214, 168, 70);
    var _copper = make_color_rgb(205, 112, 58);

    // Shared little plinth under every statue
    draw_set_color(make_color_rgb(88, 62, 40));
    draw_rectangle(_cx - 9 * _s, _by - 4 * _s, _cx + 9 * _s, _by, false);
    draw_set_color(_brass);
    draw_rectangle(_cx - 9 * _s, _by - 4 * _s, _cx + 9 * _s, _by - 3 * _s, false);

    if (_sid == 0) {
        // BLIND WATCHER BUST — radar dish head with a cracked red CCTV lens
        draw_set_color(_steel);
        draw_rectangle(_cx - 3 * _s, _by - 13 * _s, _cx + 3 * _s, _by - 4 * _s, false);
        draw_circle(_cx, _by - 18 * _s, 8 * _s, false);
        draw_set_color(_dark);
        draw_circle(_cx, _by - 18 * _s, 5.2 * _s, false);
        draw_set_color(make_color_rgb(255, 70, 60));
        draw_circle(_cx, _by - 18 * _s, 2.4 * _s, false);
        draw_set_color(c_white);
        draw_circle(_cx - 0.8 * _s, _by - 19 * _s, 0.8 * _s, false);
        draw_set_color(_steel);
        draw_line_width(_cx + 5 * _s, _by - 23 * _s, _cx + 10 * _s, _by - 29 * _s, max(1, _s * 0.8));
        draw_circle(_cx + 10 * _s, _by - 29 * _s, 1.2 * _s, false);
    } else if (_sid == 1) {
        // CHRONOS CPU HOURGLASS — golden heat-sink plates + sand
        draw_set_color(_brass);
        draw_rectangle(_cx - 8 * _s, _by - 30 * _s, _cx + 8 * _s, _by - 28 * _s, false);
        draw_rectangle(_cx - 8 * _s, _by - 6 * _s,  _cx + 8 * _s, _by - 4 * _s,  false);
        draw_set_color(make_color_rgb(70, 90, 120));
        draw_triangle(_cx - 7 * _s, _by - 28 * _s, _cx + 7 * _s, _by - 28 * _s, _cx, _by - 17 * _s, false);
        draw_triangle(_cx, _by - 17 * _s, _cx - 7 * _s, _by - 6 * _s, _cx + 7 * _s, _by - 6 * _s, false);
        draw_set_color(make_color_rgb(255, 200, 60));
        draw_triangle(_cx - 3.5 * _s, _by - 27 * _s, _cx + 3.5 * _s, _by - 27 * _s, _cx, _by - 21 * _s, false);
        draw_triangle(_cx, _by - 14 * _s, _cx - 5.5 * _s, _by - 7 * _s, _cx + 5.5 * _s, _by - 7 * _s, false);
        draw_line_width(_cx, _by - 20 * _s, _cx, _by - 15 * _s, max(1, _s * 0.6));
        draw_set_color(_brass);
        draw_line_width(_cx - 8 * _s, _by - 29 * _s, _cx - 8 * _s, _by - 5 * _s, max(1, _s * 0.8));
        draw_line_width(_cx + 8 * _s, _by - 29 * _s, _cx + 8 * _s, _by - 5 * _s, max(1, _s * 0.8));
    } else if (_sid == 2) {
        // COPPER SURGE TOTEM — stacked copper coils topped with a cyan spark
        for (var _k = 0; _k < 5; _k++) {
            draw_set_color((_k mod 2 == 0) ? _copper : make_color_rgb(150, 80, 40));
            draw_rectangle(_cx - (5 - _k * 0.4) * _s, _by - (9 + _k * 4) * _s, _cx + (5 - _k * 0.4) * _s, _by - (5 + _k * 4) * _s, false);
        }
        var _pulse = 0.5 + 0.5 * sin(current_time / 140);
        draw_set_color(make_color_rgb(80, 225, 235));
        draw_circle(_cx, _by - 29 * _s, (2.2 + _pulse * 1.2) * _s, false);
        draw_set_alpha(0.35);
        draw_circle(_cx, _by - 29 * _s, (4 + _pulse * 2) * _s, false);
        draw_set_alpha(1.0);
    }
    draw_set_color(c_white);
}

// ---------------------------------------------------------------------------
/// @function scr_order_statue(_sid)
/// @description Orders a statue from the Mechanic over the Wall Telephone.
///              Pays cash + scrap + cores up-front; delivers after 1 workday (1 floor).
/// @returns {String} Status message (starts with "OK:" on success).
// ---------------------------------------------------------------------------
function scr_order_statue(_sid) {
    var _cat = scr_get_statue_catalog()[_sid];
    if (global.statues_owned[_sid])   return "You already own the " + _cat.name + "!";
    if (global.statues_pending[_sid]) return "Burt is still building the " + _cat.name + "!";
    if (global.player_cash < _cat.cash)  return "Not enough cash! Need $" + string(_cat.cash) + " (finish a floor for a paycheck).";
    if (global.scrap_count < _cat.scrap) return "Not enough Scrap! Need " + string(_cat.scrap) + " Scrap.";
    if (global.rare_cores  < _cat.cores) return "Not enough Rare Cores! Need " + string(_cat.cores) + " (Bots & Decoy Servers drop them).";

    global.player_cash  -= _cat.cash;
    global.scrap_count  -= _cat.scrap;
    global.rare_cores   -= _cat.cores;
    global.statues_pending[_sid] = true;
    return "OK: Burt took the order! Delivery after 1 workday (1 floor).";
}

// ---------------------------------------------------------------------------
/// @function scr_deliver_pending_statues()
/// @description Called when a floor (workday) is completed. Moves every pending
///              statue to the Homeroom and returns an array of delivered names.
// ---------------------------------------------------------------------------
function scr_deliver_pending_statues() {
    var _delivered = [];
    var _cat = scr_get_statue_catalog();
    for (var _i = 0; _i < STATUE_COUNT; _i++) {
        if (global.statues_pending[_i]) {
            global.statues_pending[_i] = false;
            global.statues_owned[_i]   = true;
            array_push(_delivered, _cat[_i].name);
        }
    }
    return _delivered;
}

// ---------------------------------------------------------------------------
/// @function scr_calc_floor_paycheck(_task1, _task2, _hr_violation)
/// @description Itemized Corporate Paycheck from the Floor Performance Tracker.
/// @returns {Struct} hazard, speed, salvage, clean, fine, total, grade
// ---------------------------------------------------------------------------
function scr_calc_floor_paycheck(_task1, _task2, _hr_violation) {
    var _fails  = variable_global_exists("floor_cipher_fails") ? global.floor_cipher_fails : 0;
    var _busted = variable_global_exists("floor_times_busted") ? global.floor_times_busted : 0;

    var _hazard  = 150;
    var _speed   = max(0, 100 - 25 * _fails);
    var _salvage = (_task1 ? 100 : 0) + (_task2 ? 100 : 0);
    var _clean   = (_busted == 0) ? 100 : 0;
    var _fine    = _hr_violation ? -100 : 0;
    var _total   = max(0, _hazard + _speed + _salvage + _clean + _fine);

    var _grade = "C";
    if (_total >= 250) _grade = "B";
    if (_total >= 400) _grade = "A";
    if (_total >= 500) _grade = "S";

    return {
        hazard:  _hazard,
        speed:   _speed,
        salvage: _salvage,
        clean:   _clean,
        fine:    _fine,
        fails:   _fails,
        busted:  _busted,
        total:   _total,
        grade:   _grade
    };
}

// ---------------------------------------------------------------------------
/// @function scr_cycle_pedestal(_slot)
/// @description Cycles a pedestal slot through: empty -> each owned statue not
///              already on another pedestal -> empty.
// ---------------------------------------------------------------------------
function scr_cycle_pedestal(_slot) {
    var _next = global.equipped_statues[_slot];
    for (var _t = 0; _t < STATUE_COUNT + 2; _t++) {
        _next++;
        if (_next >= STATUE_COUNT) _next = -1;
        if (_next == -1) break;
        if (!global.statues_owned[_next]) continue;
        var _used = false;
        for (var _j = 0; _j < 3; _j++) {
            if (_j != _slot && global.equipped_statues[_j] == _next) _used = true;
        }
        if (!_used) break;
    }
    if (_next >= 0 && (!global.statues_owned[_next])) _next = -1;
    global.equipped_statues[_slot] = _next;
}

// ---------------------------------------------------------------------------
/// @function scr_draw_mechanic_phone_ui(_gui_w, _gui_h)
/// @description Wall Telephone UI — call Burt (Facilities Mechanic) to order statues.
///              Draws AND handles input. Statues arrive after 1 workday (1 floor).
// ---------------------------------------------------------------------------
function scr_draw_mechanic_phone_ui(_gui_w, _gui_h) {
    if (!variable_global_exists("phone_sel"))  global.phone_sel = 0;
    if (!variable_global_exists("phone_msg"))  { global.phone_msg = ""; global.phone_col = c_white; }

    var _cat = scr_get_statue_catalog();
    var _cx  = _gui_w * 0.5;
    var _cy  = _gui_h * 0.5;
    var _pw  = 540;
    var _ph  = 300;
    var _x1  = _cx - _pw * 0.5;
    var _y1  = _cy - _ph * 0.5;
    var _x2  = _cx + _pw * 0.5;
    var _y2  = _cy + _ph * 0.5;

    draw_set_alpha(0.84);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(0.97);
    draw_set_color(make_color_rgb(34, 24, 18));
    draw_rectangle(_x1, _y1, _x2, _y2, false);
    draw_set_alpha(1.0);
    draw_set_color(make_color_rgb(235, 175, 85));
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    draw_rectangle(_x1 + 3, _y1 + 3, _x2 - 3, _y2 - 3, true);

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(make_color_rgb(255, 205, 110));
    draw_text_transformed(_cx, _y1 + 18, "WALL TELEPHONE  -  FACILITIES MECHANIC (BURT)", 1.0, 1.0, 0);
    draw_set_color(make_color_rgb(215, 195, 170));
    draw_text_transformed(_cx, _y1 + 36, "\"Yeah, I can weld ya a 'desk trophy'. Pay up front, it's ready after one workday.\"", 0.70, 0.70, 0);

    // Resource pill
    draw_set_color(make_color_rgb(20, 14, 10));
    draw_rectangle(_cx - 200, _y1 + 48, _cx + 200, _y1 + 68, false);
    draw_set_color(make_color_rgb(150, 110, 60));
    draw_rectangle(_cx - 200, _y1 + 48, _cx + 200, _y1 + 68, true);
    draw_set_color(c_lime);
    draw_text_transformed(_cx - 120, _y1 + 58, "CASH: $" + string(global.player_cash), 0.80, 0.80, 0);
    draw_set_color(c_aqua);
    draw_text_transformed(_cx, _y1 + 58, "SCRAP: " + string(global.scrap_count), 0.80, 0.80, 0);
    draw_set_color(make_color_rgb(235, 110, 255));
    draw_text_transformed(_cx + 110, _y1 + 58, "CORES: " + string(global.rare_cores), 0.80, 0.80, 0);

    // Statue rows
    for (var _i = 0; _i < STATUE_COUNT; _i++) {
        var _c   = _cat[_i];
        var _ry1 = _y1 + 78 + _i * 52;
        var _ry2 = _ry1 + 47;
        var _sel = (_i == global.phone_sel);

        draw_set_color(_sel ? make_color_rgb(58, 42, 28) : make_color_rgb(26, 19, 14));
        draw_rectangle(_x1 + 14, _ry1, _x2 - 14, _ry2, false);
        draw_set_color(_sel ? _c.col : make_color_rgb(95, 75, 55));
        draw_rectangle(_x1 + 14, _ry1, _x2 - 14, _ry2, true);

        scr_draw_statue_sprite(_i, _x1 + 46, _ry2 - 5, 0.95);

        draw_set_halign(fa_left);
        draw_set_color(_sel ? _c.col : c_white);
        draw_text_transformed(_x1 + 76, _ry1 + 11, string(_i + 1) + ". " + _c.name, 0.82, 0.82, 0);
        draw_set_color(make_color_rgb(205, 220, 235));
        draw_text_transformed(_x1 + 76, _ry1 + 25, _c.effect, 0.70, 0.70, 0);
        draw_set_color(make_color_rgb(165, 150, 130));
        draw_text_transformed(_x1 + 76, _ry1 + 37, "COST:  $" + string(_c.cash) + "   " + string(_c.scrap) + " Scrap   " + string(_c.cores) + " Core", 0.68, 0.68, 0);

        draw_set_halign(fa_right);
        if (global.statues_owned[_i]) {
            draw_set_color(c_lime);
            draw_text_transformed(_x2 - 24, _ry1 + 16, "DELIVERED", 0.78, 0.78, 0);
            draw_set_color(make_color_rgb(150, 190, 165));
            draw_text_transformed(_x2 - 24, _ry1 + 32, "(see Display Table)", 0.62, 0.62, 0);
        } else if (global.statues_pending[_i]) {
            draw_set_color(make_color_rgb(255, 200, 70));
            draw_text_transformed(_x2 - 24, _ry1 + 16, "IN FABRICATION", 0.78, 0.78, 0);
            draw_set_color(make_color_rgb(215, 185, 120));
            draw_text_transformed(_x2 - 24, _ry1 + 32, "arrives after 1 workday", 0.62, 0.62, 0);
        } else {
            var _afford = (global.player_cash >= _c.cash && global.scrap_count >= _c.scrap && global.rare_cores >= _c.cores);
            draw_set_color(_afford ? c_lime : make_color_rgb(200, 110, 100));
            draw_text_transformed(_x2 - 24, _ry1 + 16, _afford ? "[ENTER] ORDER" : "CAN'T AFFORD", 0.78, 0.78, 0);
        }
        draw_set_halign(fa_center);
    }

    if (global.phone_msg != "") {
        draw_set_color(global.phone_col);
        draw_text_transformed(_cx, _y2 - 34, global.phone_msg, 0.74, 0.74, 0);
    }
    draw_set_color(make_color_rgb(165, 150, 130));
    draw_text_transformed(_cx, _y2 - 14, "[UP/DOWN] Select   |   [ENTER] Place Order   |   [ESC] Hang Up", 0.76, 0.76, 0);

    // --- Input ---
    if (keyboard_check_pressed(vk_escape)) {
        global.esc_block_frames = 2;
        keyboard_clear(vk_escape);
        global.phone_ui_open = false;
        audio_play_sound(snd_button_click, 10, false);
        return;
    }
    if (keyboard_check_pressed(vk_up)) {
        global.phone_sel = (global.phone_sel + STATUE_COUNT - 1) mod STATUE_COUNT;
        global.phone_msg = "";
        audio_play_sound(select1, 10, false);
    }
    if (keyboard_check_pressed(vk_down)) {
        global.phone_sel = (global.phone_sel + 1) mod STATUE_COUNT;
        global.phone_msg = "";
        audio_play_sound(select1, 10, false);
    }
    if (keyboard_check_pressed(vk_enter)) {
        var _res = scr_order_statue(global.phone_sel);
        if (string_copy(_res, 1, 3) == "OK:") {
            global.phone_msg = string_delete(_res, 1, 4);
            global.phone_col = c_lime;
            audio_play_sound(snd_correct_ping, 10, false);
        } else {
            global.phone_msg = _res;
            global.phone_col = make_color_rgb(255, 130, 100);
            audio_play_sound(wrong1, 10, false);
        }
    }
}

// ---------------------------------------------------------------------------
/// @function scr_draw_statue_shelf_ui(_gui_w, _gui_h)
/// @description Homeroom 3-Pedestal Display Table organizer. Draws AND handles input.
///              [LEFT/RIGHT] pick a pedestal, [ENTER] cycles which delivered statue sits on it.
// ---------------------------------------------------------------------------
function scr_draw_statue_shelf_ui(_gui_w, _gui_h) {
    if (!variable_global_exists("shelf_slot")) global.shelf_slot = 0;

    var _cat = scr_get_statue_catalog();
    var _cx  = _gui_w * 0.5;
    var _cy  = _gui_h * 0.5;
    var _pw  = 540;
    var _ph  = 300;
    var _x1  = _cx - _pw * 0.5;
    var _y1  = _cy - _ph * 0.5;
    var _x2  = _cx + _pw * 0.5;
    var _y2  = _cy + _ph * 0.5;

    draw_set_alpha(0.84);
    draw_set_color(c_black);
    draw_rectangle(0, 0, _gui_w, _gui_h, false);
    draw_set_alpha(0.97);
    draw_set_color(make_color_rgb(34, 24, 18));
    draw_rectangle(_x1, _y1, _x2, _y2, false);
    draw_set_alpha(1.0);
    draw_set_color(make_color_rgb(235, 175, 85));
    draw_rectangle(_x1, _y1, _x2, _y2, true);
    draw_rectangle(_x1 + 3, _y1 + 3, _x2 - 3, _y2 - 3, true);

    draw_set_font(fnt_dialogue);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(make_color_rgb(255, 205, 110));
    draw_text_transformed(_cx, _y1 + 18, "HOMEROOM DISPLAY TABLE  -  ACTIVE STATUES (3 PEDESTALS)", 1.0, 1.0, 0);

    // Three pedestal slots
    for (var _s = 0; _s < 3; _s++) {
        var _sx  = _cx + (_s - 1) * 150;
        var _sy1 = _y1 + 40;
        var _sy2 = _y1 + 128;
        var _sel = (_s == global.shelf_slot);
        var _sid = global.equipped_statues[_s];

        draw_set_color(_sel ? make_color_rgb(58, 42, 28) : make_color_rgb(26, 19, 14));
        draw_rectangle(_sx - 66, _sy1, _sx + 66, _sy2, false);
        draw_set_color(_sel ? c_yellow : make_color_rgb(110, 85, 60));
        draw_rectangle(_sx - 66, _sy1, _sx + 66, _sy2, true);
        if (_sel) draw_rectangle(_sx - 64, _sy1 + 2, _sx + 64, _sy2 - 2, true);

        draw_set_color(make_color_rgb(175, 150, 120));
        draw_text_transformed(_sx, _sy1 + 10, "PEDESTAL " + string(_s + 1), 0.72, 0.72, 0);

        if (_sid >= 0) {
            scr_draw_statue_sprite(_sid, _sx, _sy2 - 26, 1.6);
            draw_set_color(_cat[_sid].col);
            draw_text_transformed(_sx, _sy2 - 11, _cat[_sid].name, 0.66, 0.66, 0);
        } else {
            draw_set_color(make_color_rgb(120, 105, 90));
            draw_text_transformed(_sx, _sy1 + 48, "- EMPTY -", 0.80, 0.80, 0);
            draw_text_transformed(_sx, _sy1 + 64, "[ENTER] to place", 0.62, 0.62, 0);
        }
    }

    // Statue collection list
    draw_set_color(make_color_rgb(215, 195, 170));
    draw_text_transformed(_cx, _y1 + 142, "STATUE COLLECTION", 0.78, 0.78, 0);

    for (var _i = 0; _i < STATUE_COUNT; _i++) {
        var _c   = _cat[_i];
        var _ry  = _y1 + 160 + _i * 30;
        var _on  = scr_has_active_statue(_i);
        var _own = global.statues_owned[_i];

        draw_set_color(make_color_rgb(26, 19, 14));
        draw_rectangle(_x1 + 14, _ry, _x2 - 14, _ry + 26, false);
        draw_set_color(_own ? _c.col : make_color_rgb(70, 58, 46));
        draw_rectangle(_x1 + 14, _ry, _x2 - 14, _ry + 26, true);

        draw_set_halign(fa_left);
        if (_own) {
            draw_set_color(_c.col);
            draw_text_transformed(_x1 + 24, _ry + 9, _c.name, 0.76, 0.76, 0);
            draw_set_color(make_color_rgb(205, 220, 235));
            draw_text_transformed(_x1 + 24, _ry + 20, _c.effect, 0.62, 0.62, 0);
            draw_set_halign(fa_right);
            draw_set_color(_on ? c_lime : make_color_rgb(165, 150, 130));
            draw_text_transformed(_x2 - 24, _ry + 13, _on ? "ACTIVE" : "IN STORAGE", 0.74, 0.74, 0);
        } else {
            draw_set_color(make_color_rgb(120, 105, 90));
            draw_text_transformed(_x1 + 24, _ry + 9, "??? " + _c.name, 0.76, 0.76, 0);
            draw_set_halign(fa_right);
            draw_set_color(global.statues_pending[_i] ? make_color_rgb(255, 200, 70) : make_color_rgb(140, 120, 100));
            draw_text_transformed(_x2 - 24, _ry + 13, global.statues_pending[_i] ? "IN FABRICATION" : "NOT ORDERED (use the Wall Telephone)", 0.70, 0.70, 0);
        }
        draw_set_halign(fa_center);
    }

    draw_set_color(make_color_rgb(165, 150, 130));
    draw_text_transformed(_cx, _y2 - 12, "[LEFT/RIGHT] Pick Pedestal   |   [ENTER] Cycle Statue   |   [ESC] Close", 0.76, 0.76, 0);

    // --- Input ---
    if (keyboard_check_pressed(vk_escape)) {
        global.esc_block_frames = 2;
        keyboard_clear(vk_escape);
        global.shelf_ui_open = false;
        audio_play_sound(snd_button_click, 10, false);
        return;
    }
    if (keyboard_check_pressed(vk_right)) {
        global.shelf_slot = (global.shelf_slot + 1) mod 3;
        audio_play_sound(select1, 10, false);
    }
    if (keyboard_check_pressed(vk_left)) {
        global.shelf_slot = (global.shelf_slot + 2) mod 3;
        audio_play_sound(select1, 10, false);
    }
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
        scr_cycle_pedestal(global.shelf_slot);
        audio_play_sound(snd_select, 10, false);
    }
}
