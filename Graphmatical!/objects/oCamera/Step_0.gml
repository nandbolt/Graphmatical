// Check if player exists
if (instance_exists(oPlayer))
{
	// Follow player
	var _x = clamp(oPlayer.x - halfCamWidth, 0, room_width - camWidth);
	var _y = clamp(oPlayer.y - halfCamHeight, 0, room_height - camHeight);
	camera_set_view_pos(view_camera[0], _x, _y);
}