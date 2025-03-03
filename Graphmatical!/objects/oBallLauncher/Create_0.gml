// Inherit the parent event
event_inherited();

// Launch
charge = 0;
maxCharge = 60;
charging = false;
maxLaunchStrength = 5;
minLaunchStrength = 1;

#region Functions

///	@func	interact();
interact = function()
{
	// Charge
	charging = true;
	charge = clamp(charge + 1, 0, maxCharge);
}

/// @func	interactReleased();
interactReleased = function()
{
	// Spawn ball
	var _launchStrength = lerp(minLaunchStrength, maxLaunchStrength, charge / maxCharge);
	var _dirX = lengthdir_x(1, image_angle), _dirY = lengthdir_y(1, image_angle);
	with (instance_create_layer(x + _dirX * 8, y + _dirY * 8, "MiddleForegroundInstances", oBall))
	{
		velocity.x = _dirX * _launchStrength;
		velocity.y = _dirY * _launchStrength;
	}
	
	// Ball launch sfx
	audio_play_sound(sfxButtonPressed, 5, false);
	
	// Release charge
	charging = false;
	charge = 0;
}

#endregion