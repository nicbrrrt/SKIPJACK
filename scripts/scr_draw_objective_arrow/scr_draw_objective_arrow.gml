/// @description Draws a floating arrow pointing toward the current objective target.
function scr_draw_objective_arrow() {

	if (!instance_exists(obj_jack)) exit;
	if (instance_exists(obj_textevent)) exit;
	if (variable_global_exists("is_paused") && global.is_paused) exit;

	var _target = scr_get_objective_target();
	if (_target == noone || !instance_exists(_target)) exit;

	var _dist = point_distance(obj_jack.x, obj_jack.y, _target.x, _target.y);
	if (_dist < 56) exit;

	var _dir = point_direction(obj_jack.x, obj_jack.y, _target.x, _target.y);
	var _bob = sin(current_time / 120) * 5;
	var _pulse = 0.85 + sin(current_time / 150) * 0.15;

	var _draw_x = obj_jack.x + lengthdir_x(40 + _bob, _dir);
	var _draw_y = obj_jack.y + lengthdir_y(40 + _bob, _dir) - 8;

	// If the target is off-camera, pin the arrow to the screen edge instead.
	if (view_enabled) {
		var _cam = view_camera[0];
		if (_cam != -1) {
			var _vx = camera_get_view_x(_cam);
			var _vy = camera_get_view_y(_cam);
			var _vw = camera_get_view_width(_cam);
			var _vh = camera_get_view_height(_cam);
			var _margin = 28;

			var _off_screen = (_target.x < _vx + _margin || _target.x > _vx + _vw - _margin
				|| _target.y < _vy + _margin || _target.y > _vy + _vh - _margin);

			if (_off_screen) {
				_draw_x = obj_jack.x;
				_draw_y = obj_jack.y;
				var _step = 6;
				var _max_steps = ceil(max(_vw, _vh) / _step);
				for (var _i = 0; _i < _max_steps; _i++) {
					_draw_x += lengthdir_x(_step, _dir);
					_draw_y += lengthdir_y(_step, _dir);
					if (_draw_x < _vx + _margin || _draw_x > _vx + _vw - _margin
						|| _draw_y < _vy + _margin || _draw_y > _vy + _vh - _margin)
						break;
				}
			}
		}
	}

	draw_sprite_ext(spr_arrow_up, 0, _draw_x, _draw_y, 1.2, 1.2, _dir - 90, c_lime, _pulse);
}
