// Inherit the parent event
event_inherited();

// Sprites
spriteFlag = sGoalFlag;
spritePole = sGoalPole;

#region Functions

/// @func	onPlayerNear();
onPlayerNear = function()
{
	updateSpawnPoint();
	
	// Complete level
	with (oLevel)
	{
		completeLevel();
	}
}

#endregion