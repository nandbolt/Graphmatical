// Move camera
if (instance_exists(oSpawnFlag))
{
	targetPosition.x = clamp(oSpawnFlag.x - halfCamWidth, 0, room_width - camWidth);
	targetPosition.y = clamp(oSpawnFlag.y - halfCamHeight, 0, room_height - camHeight);
	camera_set_view_pos(view_camera[0], targetPosition.x, targetPosition.y);
}