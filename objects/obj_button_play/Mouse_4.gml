// Transitions to rm_cipher_select; cipher select handles save / new game.

if (instance_exists(obj_review_screen)) exit;
if (instance_exists(obj_codex_manager) && obj_codex_manager.is_open) exit;
if (instance_exists(obj_transition)) exit;

audio_stop_sound(snd_button_hover);
audio_play_sound(snd_button_click, 10, false);

var _t = instance_create_depth(0, 0, -9999, obj_transition);
_t.target_room = rm_cipher_select;
_t.fade_mode   = "fading_out";
_t.fade_alpha  = 0;
