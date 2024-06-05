// Inherit the parent event
event_inherited();

// Set to noninteractable
interactable = false;

// Sprites
spriteFlag = sCheckFlag;
spritePole = sCheckPole;

#region Functions

/// @func	updateSpawnPoint();
updateSpawnPoint = function()
{
	// World scope
	with (oLevel)
	{
		// If spawn point is different
		if (spawnPoint != other)
		{
			// Set previous spawn point to pole sprite
			spawnPoint.sprite_index = spawnPoint.spritePole;
		
			// Set spawn point
			spawnPoint = other;
			
			// Sound
			audio_play_sound(sfxFlagActivated, 2, false);
		}
	}
	
	// Set sprite
	sprite_index = spriteFlag;
}

/// @func	onPlayerNear();
onPlayerNear = function()
{
	updateSpawnPoint();
}

#endregion