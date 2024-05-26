// Inherit the parent event
event_inherited();

// Set to noninteractable
interactable = false;

#region Functions

/// @func	onPlayerNear();
onPlayerNear = function()
{
	// Set spawn point
	with (oWorld)
	{
		spawnPoint = other;
	}
}

#endregion