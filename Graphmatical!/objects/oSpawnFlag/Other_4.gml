// Move camera
if (instance_exists(oCamera))
{
	with (oCamera)
	{
		targetPosition.x = clamp(other.x - halfCamWidth, 0, room_width - camWidth);
		targetPosition.y = clamp(other.y - halfCamHeight, 0, room_height - camHeight);
		camera_set_view_pos(view_camera[0], targetPosition.x, targetPosition.y);
	}
}