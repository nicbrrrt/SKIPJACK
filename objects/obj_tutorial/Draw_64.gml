draw_set_font(fnt_default);
var gw = display_get_gui_width();
var gh = display_get_gui_height();
var cx = gw / 2;
var cy = gh / 2;

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// ── PAGE 1: TEXT ──────────────────────────────────────────────────────────────
if (page == 1) {

    var _footer = (tutorial_image != -1) ? "[PRESS SPACE TO CONTINUE]" : "[PRESS SPACE TO START]";

    draw_set_alpha(0.9 * alpha);
    draw_set_color(c_black);
    draw_rectangle(cx - box_width/2, cy - box_height/2,
                   cx + box_width/2, cy + box_height/2, false);
    draw_set_color(c_lime);
    draw_rectangle(cx - box_width/2, cy - box_height/2,
                   cx + box_width/2, cy + box_height/2, true);

    draw_set_alpha(alpha);
    draw_set_color(c_lime);
    draw_text_transformed(cx, cy - 60, text_title, 1.5, 1.5, 0);

    draw_set_color(c_white);
    draw_text_ext(cx, cy, text_body, 20, box_width - 40);

    draw_set_color(c_gray);
    draw_text(cx, cy + 80, _footer);
}

// ── PAGE 2: IMAGE + CAPTION ───────────────────────────────────────────────────
else if (page == 2 && tutorial_image != -1) {

    var _pad    = 20;   // padding inside the box on all sides
    var _gap    = 10;   // space between image bottom and caption text
    var _foot_h = 24;   // height reserved for the footer line

    // Max display size — keeps the image inside a popup window, not full-screen
    var _max_iw = 360;
    var _max_ih = 180;

    // Scale image down to fit; never upscale beyond native size
    var _iw_raw = sprite_get_width(tutorial_image);
    var _ih_raw = sprite_get_height(tutorial_image);
    var _scale  = min(1.0, _max_iw / _iw_raw, _max_ih / _ih_raw);
    var _iw     = floor(_iw_raw * _scale);
    var _ih     = floor(_ih_raw * _scale);

    // Measure caption text height (wrap width = max of image width or 340 px)
    var _has_body = (variable_instance_exists(id, "tutorial_image_body")
                     && tutorial_image_body != "");
    var _tw_max   = max(_iw, 340);
    var _text_h   = 0;
    if (_has_body) {
        _text_h = string_height_ext(tutorial_image_body, -1, _tw_max) + _gap;
    }

    // Box dimensions proportional to content
    var _content_w = max(_iw, _tw_max);
    var _bw = _content_w + _pad * 2;
    var _bh = _pad + _ih + (_has_body ? _text_h : 0) + _foot_h + _pad;

    // Box
    draw_set_alpha(0.9 * alpha);
    draw_set_color(c_black);
    draw_rectangle(cx - _bw/2, cy - _bh/2,
                   cx + _bw/2, cy + _bh/2, false);
    draw_set_color(c_lime);
    draw_rectangle(cx - _bw/2, cy - _bh/2,
                   cx + _bw/2, cy + _bh/2, true);

    // Image — top-left corner is _pad pixels from the top of the box, horizontally centred
    // (assumes sprite origin is top-left 0,0; set in IDE if your sprite uses a different origin)
    draw_set_alpha(alpha);
    var _img_top = cy - _bh/2 + _pad;
    draw_sprite_ext(tutorial_image, 0,
                    cx - _iw/2, _img_top,
                    _scale, _scale, 0, c_white, alpha);

    // Caption text below the image
    if (_has_body) {
        draw_set_color(c_white);
        draw_set_valign(fa_top);
        draw_text_ext(cx, _img_top + _ih + _gap, tutorial_image_body, -1, _tw_max);
    }

    // Footer at the bottom of the box
    draw_set_color(c_gray);
    draw_set_valign(fa_bottom);
    draw_text(cx, cy + _bh/2 - 4, "[PRESS SPACE TO START]");
    draw_set_valign(fa_middle);
}

// Reset draw state
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
