/// @description obj_dungeon_generator — Draw Event
/// Renders the Corporate Facility Lighting & Lockdown States:
///   - Red pulsing alarm wash & ceiling beacon stay active until Stage 2 (global.lockdown_overridden)
///   - Dark 56% power-outage blackout overlay stays active until Stage 3 (global.power_restored)
///   - Unvisited/inactive rooms remain shrouded under 0.88 fog-of-war until Stage 4 (global.lockdown_lifted)

if (variable_instance_exists(id, "is_intern_mode") && is_intern_mode) exit;
if (!gen_complete) exit;

var _chunk_px            = CHUNK_SIZE * TILE_SIZE; // 144 px per room
var _total_rooms         = array_length(path_list);
var _lockdown_overridden = (variable_global_exists("lockdown_overridden") && global.lockdown_overridden);
var _power_restored      = (variable_global_exists("power_restored")      && global.power_restored);
var _lockdown_lifted     = (variable_global_exists("lockdown_lifted")     && global.lockdown_lifted);

for (var _i = 0; _i < _total_rooms; _i++) {
    var _c = path_list[_i][0];
    var _r = path_list[_i][1];
    var _rtype = logic_map[_c][_r];

    var _x1 = _c * _chunk_px;
    var _y1 = _r * _chunk_px;
    var _x2 = _x1 + _chunk_px - 1;
    var _y2 = _y1 + _chunk_px - 1;

    var _alpha = room_fog_alpha[_c][_r];

    // Active / currently occupied room or hallway
    if (_alpha < 0.85) {
        var _vis = clamp(1.0 - _alpha, 0.0, 1.0);

        // 1. POWER-OUTAGE BLACKOUT OVERLAY (Turns OFF as soon as the Power Breaker Panel is restored!)
        if (!_power_restored && !_lockdown_lifted) {
            draw_set_alpha(_vis * 0.56);
            draw_set_color(make_color_rgb(3, 5, 12));
            draw_rectangle(_x1, _y1, _x2, _y2, false);
        }

        // 2. RED LOCKDOWN SIREN LIGHTS (Turns OFF when Lockdown is lifted!)
        if (!_lockdown_lifted) {
            // Center ceiling light for the room / hallway segment
            var _lx = _x1 + 72;
            var _ly = _y1 + 72;

            // Pulse that sweeps / pulses across chunks
            var _pulse = 0.5 + 0.5 * sin((current_time * 0.0035) + (_lx * 0.02) + (_ly * 0.02));

            // 3 Concentric Rings for Radial Gradient:
            // Outer ring: dark red, gentle ambient reach
            draw_set_alpha(_vis * (0.04 + 0.04 * _pulse));
            draw_set_color(make_color_rgb(140, 10, 20));
            draw_circle(_lx, _ly, 46, false);

            // Middle ring: medium red
            draw_set_alpha(_vis * (0.08 + 0.07 * _pulse));
            draw_set_color(make_color_rgb(215, 25, 35));
            draw_circle(_lx, _ly, 26, false);

            // Inner ring: lightest red glow
            draw_set_alpha(_vis * (0.16 + 0.12 * _pulse));
            draw_set_color(make_color_rgb(255, 90, 100));
            draw_circle(_lx, _ly, 10, false);

            // Center ceiling fixture diode / bulb
            draw_set_alpha(_vis * (0.45 + 0.45 * _pulse));
            draw_set_color(make_color_rgb(255, 210, 215));
            draw_circle(_lx, _ly, 2.5, false);
        } else {
            // Lockdown lifted: calm white/green ceiling indicator
            var _bx = _x1 + 72;
            var _by = _y1 + 72;
            draw_set_alpha(_vis * 0.35);
            draw_set_color(_power_restored ? c_lime : c_white);
            draw_circle(_bx, _by, 2.0, false);
        }

        // 3. Special room interior frame highlights (subtle)
        if (_rtype == ROOM_CAESAR_KEY) {
            draw_set_alpha(_vis * 0.22);
            draw_set_color(make_color_rgb(255, 195, 35));
            draw_rectangle(_x1 + 16, _y1 + 16, _x2 - 16, _y2 - 16, true);
        } else if (_rtype == ROOM_CAESAR_LOCKED) {
            draw_set_alpha(_vis * 0.22);
            draw_set_color(make_color_rgb(255, 65, 125));
            draw_rectangle(_x1 + 16, _y1 + 16, _x2 - 16, _y2 - 16, true);
        } else if (_rtype == ROOM_POWER) {
            draw_set_alpha(_vis * 0.22);
            draw_set_color(make_color_rgb(65, 215, 255));
            draw_rectangle(_x1 + 16, _y1 + 16, _x2 - 16, _y2 - 16, true);
        } else if (_rtype == ROOM_HOLDING) {
            draw_set_alpha(_vis * 0.25);
            draw_set_color(make_color_rgb(255, 120, 30));
            draw_rectangle(_x1 + 16, _y1 + 16, _x2 - 16, _y2 - 16, true);
        }
    }

    if (_alpha <= 0.01) continue;

    // Fog-of-war shroud over unlit rooms
    draw_set_alpha(_alpha);
    draw_set_color(make_color_rgb(3, 5, 10));
    draw_rectangle(_x1, _y1, _x2, _y2, false);
}

// Soft personal lantern aura around Jack while building power is still out
if (!_power_restored && !_lockdown_lifted && instance_exists(obj_jack) && obj_jack.visible) {
    draw_set_alpha(0.05);
    draw_set_color(make_color_rgb(160, 215, 255));
    draw_circle(obj_jack.x, obj_jack.y - 8, 26, false);
    draw_set_alpha(0.04);
    draw_circle(obj_jack.x, obj_jack.y - 8, 14, false);
}

draw_set_color(c_white);
draw_set_alpha(1.0);
