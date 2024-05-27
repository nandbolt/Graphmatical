// Inherit the parent event
event_inherited();

// Sprites
spriteFlag = sSpawnFlag;
spritePole = sSpawnPole;

#region Functions

/// @func	onPlayerNear();
onPlayerNear = function()
{
	updateSpawnPoint();
	
	// Reset level
	with (oWorld)
	{
		levelComplete = false;
		startTime = current_time / 1000;
	}
}

#endregion