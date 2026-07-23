// --- Draw GUI Event for obj_atbash_complete ---
if (variable_global_exists("is_paused") && global.is_paused) exit;

var _gw = 640;
var _gh = 360;
var cx  = _gw / 2;

// --- Background ---
draw_set_alpha(screen_alpha * 0.95);
draw_set_color(make_color_rgb(5, 5, 15));
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(screen_alpha);

// --- Decorative stars (all phases except boss_death) ---
if (phase != "boss_death") {
    for (var i = 0; i < array_length(stars); i++) {
        var _s = stars[i];
        var _pulse = 0.5 + 0.5 * sin(anim_timer * _s.spd * 0.05 + _s.ang);
        draw_set_color(merge_color(c_navy, c_aqua, _pulse));
        draw_set_alpha(screen_alpha * _pulse * 0.6);
        draw_circle(_s.sx, _s.sy, _s.sz * _pulse, false);
    }
    draw_set_alpha(screen_alpha);

    // Horizontal accent lines
    draw_set_color(make_color_rgb(40, 60, 100));
    var _line_w = 200 + sin(anim_timer * 0.02) * 30;
    draw_line_width(cx - _line_w, 60, cx + _line_w, 60, 1);
    draw_line_width(cx - _line_w, _gh - 60, cx + _line_w, _gh - 60, 1);
}

draw_set_font(fnt_dialogue);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

switch (phase) {
    case "fade_in":
    case "title":
        // --- CONGRATULATIONS ---
        var _bob = sin(anim_timer * 0.04) * 3;
        
        // Title glow
        draw_set_alpha(screen_alpha * 0.3);
        draw_set_color(c_aqua);
        draw_text(cx, 80 + _bob + 1, "MISSION COMPLETE");
        draw_text(cx, 80 + _bob - 1, "MISSION COMPLETE");
        draw_text(cx + 1, 80 + _bob, "MISSION COMPLETE");
        draw_text(cx - 1, 80 + _bob, "MISSION COMPLETE");
        
        draw_set_alpha(screen_alpha);
        draw_set_color(c_lime);
        draw_text(cx, 80 + _bob, "MISSION COMPLETE");

        draw_set_color(c_white);
        draw_text(cx, 130, "Atbash Cipher Module Cleared!");

        // Divider
        draw_set_color(c_lime);
        draw_line_width(cx - 100, 155, cx + 100, 155, 2);

        draw_set_color(make_color_rgb(150, 180, 220));
        draw_text(cx, 180, "You reversed the flow and secured the network.");
        draw_text(cx, 200, "The mirror cipher protocol has been fully breached.");

        // Flashing prompt
        if (phase == "title" && phase_timer > 120) {
            var _flash = (anim_timer mod 60) < 40;
            if (_flash) {
                draw_set_color(c_gray);
                draw_text(cx, 300, "Loading credits...");
            }
        }
        break;

    case "credits":
        // --- CREDITS ROLL ---
        draw_set_color(c_aqua);
        draw_text(cx, 50, "- AGENTS MET -");

        draw_set_color(c_gray);
        draw_line_width(cx - 80, 65, cx + 80, 65, 1);

        if (credit_index < array_length(credits)) {
            var _cr = credits[credit_index];
            
            draw_set_alpha(screen_alpha * credit_alpha);

            // Name (large, bright)
            draw_set_color(c_yellow);
            draw_text(cx, 150, _cr.name);

            // Role (smaller, dim)
            draw_set_color(make_color_rgb(160, 170, 190));
            draw_text(cx, 180, _cr.role);

            // Progress dots at bottom
            draw_set_alpha(screen_alpha);
            for (var i = 0; i < array_length(credits); i++) {
                var _dx = cx - (array_length(credits) * 10) / 2 + i * 10 + 5;
                draw_set_color(i <= credit_index ? c_lime : c_dkgray);
                draw_circle(_dx, 280, 3, i != credit_index);
            }
        }
        break;

    case "unlock":
        // --- UNLOCK REVEAL ---

        // White flash overlay
        if (unlock_flash > 0) {
            draw_set_alpha(unlock_flash * 0.6);
            draw_set_color(c_white);
            draw_rectangle(0, 0, _gw, _gh, false);
            draw_set_alpha(screen_alpha);
        }

        // Glow behind text
        draw_set_alpha(screen_alpha * 0.4);
        draw_set_color(c_lime);
        draw_circle(cx, 150, 80 * unlock_scale, false);
        draw_set_alpha(screen_alpha);

        // Title
        draw_set_color(c_lime);
        draw_text_transformed(cx, 90, "NEW MODULE UNLOCKED", unlock_scale, unlock_scale, 0);

        // Divider
        draw_set_color(c_yellow);
        draw_line_width(cx - 60 * unlock_scale, 115, cx + 60 * unlock_scale, 115, 2);

        // Module name
        draw_set_color(c_yellow);
        draw_text_transformed(cx, 150, "VIGENERE CIPHER", unlock_scale, unlock_scale, 0);

        // Description
        if (phase_timer > 30) {
            draw_set_color(make_color_rgb(180, 200, 220));
            draw_text(cx, 195, "A polyalphabetic cipher using a shifting keyword.");
            draw_text(cx, 215, "A new challenge awaits you, Agent.");
        }

        // Continue prompt (after animation)
        if (phase_timer >= 60) {
            var _bob2 = sin(anim_timer * 0.08) * 3;
            var _flash2 = (anim_timer mod 50) < 35;
            if (_flash2) {
                draw_set_color(c_lime);
                draw_text(cx, 300 + _bob2, "[ PRESS E TO CONTINUE ]");
            }
        }
        break;

    case "fade_out":
        // Just the fading background
        draw_set_color(c_white);
        draw_text(cx, 180, "Returning to base...");
        break;
}

// Reset draw state
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1.0);
