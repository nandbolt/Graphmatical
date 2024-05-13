// Check if player exists
if (instance_exists(oGrapher))
{
	// Set target to grapher
	targetPosition.x = clamp(oGrapher.x - halfCamWidth, 0, room_width - camWidth);
	targetPosition.y = clamp(oGrapher.y - halfCamHeight, 0, room_height - camHeight);
}
else if (instance_exists(oPlayer))
{
	// Set target to player
	targetPosition.x = clamp(oPlayer.x - halfCamWidth, 0, room_width - camWidth);
	targetPosition.y = clamp(oPlayer.y - halfCamHeight, 0, room_height - camHeight);
}

// Follow target
var _cx = lerp(camera_get_view_x(view_camera[0]), targetPosition.x, followAcceleration);
var _cy = lerp(camera_get_view_y(view_camera[0]), targetPosition.y, followAcceleration);
camera_set_view_pos(view_camera[0], _cx, _cy);