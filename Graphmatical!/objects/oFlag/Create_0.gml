// Inherit the parent event
event_inherited();

// Set to noninteractable
interactable = false;

// Sprites
spriteFlag = sCheckFlag;
spritePole = sCheckPole;

#region Functions

/// @func	onPlayerNear();
onPlayerNear = function()
{
	// World scope
	with (oWorld)
	{
		// If spawn point is different
		if (spawnPoint != other)
		{
			// Set previous spawn point to pole sprite
			spawnPoint.sprite_index = spawnPoint.spritePole;
		
			// Set spawn point
			spawnPoint = other;
		}
	}
	
	// Set sprite
	sprite_index = spriteFlag;
}

#endregion