/// @desc End Fade
if (fadeToNextRoom) room_goto(nextRoom);
else
{
	// Spawn player
	with (instance_create_layer(oLevel.spawnPoint.x, oLevel.spawnPoint.y, "ForegroundInstances", oPlayer))
	{
		emitBodyParticles();
	}
	
	// Destroy transition
	instance_destroy();
}