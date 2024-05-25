// Init target
var _target = noone;
if (instance_exists(oGrapher)) _target = oGrapher;
else if (instance_exists(oTiler)) _target = oTiler;
else if (instance_exists(oPlayer)) _target = oPlayer;

// If target exists
if (_target != noone && instance_exists(_target))
{
	// Set target to player
	targetPosition.x = clamp(_target.x - halfCamWidth, 0, room_width - camWidth);
	targetPosition.y = clamp(_target.y - halfCamHeight, 0, room_height - camHeight);
}

// Follow target
var _cx = lerp(camera_get_view_x(view_camera[0]), targetPosition.x, followAcceleration);
var _cy = lerp(camera_get_view_y(view_camera[0]), targetPosition.y, followAcceleration);
camera_set_view_pos(view_camera[0], _cx, _cy);

// Move background
//layer_x(background, _cx);
//layer_y(background, _cy);