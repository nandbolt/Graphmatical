// Move camera
if (instance_exists(oLevel))
{
	targetPosition.x = clamp(oLevel.spawnPoint.x - halfCamWidth, 0, room_width - camWidth);
	targetPosition.y = clamp(oLevel.spawnPoint.y - halfCamHeight, 0, room_height - camHeight);
	camera_set_view_pos(view_camera[0], targetPosition.x, targetPosition.y);
}