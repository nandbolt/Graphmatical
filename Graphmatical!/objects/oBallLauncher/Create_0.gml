// Inherit the parent event
event_inherited();

#region Functions

/// @func	interact();
interactPressed = function()
{
	// Spawn ball
	with (instance_create_layer(x, y, "MiddleForegroundInstances", oBall))
	{
		velocity.y -= 5;
	}
	
	// Ball launch sfx
	audio_play_sound(sfxButtonPressed, 5, false);
}

#endregion