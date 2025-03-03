// Inherit the parent event
event_inherited();

// Sprites
spriteFlag = sNoFlag;
spritePole = sNoFlag;

#region Functions

/// @func	onPlayerNear();
onPlayerNear = function()
{
	updateSpawnPoint();
	
	// Reset level
	with (oLevel)
	{
		levelComplete = false;
		startTime = current_time / 1000;
	}
}

#endregion

// Destroy other spawn flags
with (oSpawnFlag)
{
	if (id != other.id) instance_destroy();
}

// Show flag visible if editing level
if (instance_exists(oCustomEditorManager))
{
	with (oLevel)
	{
		moveSpawnPoint(other.x, other.y);
	}
}