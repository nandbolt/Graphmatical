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
	
	// Return if editing
	if (global.editMode) return;
	
	// Complete level
	with (oLevel)
	{
		completeLevel();
	}
}

#endregion