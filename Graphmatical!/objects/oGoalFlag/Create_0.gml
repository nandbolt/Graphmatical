// Inherit the parent event
event_inherited();

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

// Blend
image_blend = #59C135;