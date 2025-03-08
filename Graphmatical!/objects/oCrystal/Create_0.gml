// Inherit the parent event
event_inherited();

// Active
active = true;

// Power
residualPowerTime = 20;
powerSource = noone;
potentialSources = [oSpike, oBallSpike, oWalkerSpike];
powerCheckFrequency = 5;
powerRadius = 16;

///	@func	togglePower(on);
togglePower = function(_on)
{
	if (sprite_index == sCrystal && _on)
	{
		// Turn on
		sprite_index = sCrystalPowered;
		
		// On audio
		if (visibleToCamera(self.id)) audio_play_sound(sfxFlagActivated, 10, false);
	}
	else if (sprite_index == sCrystalPowered && !_on)
	{
		// Turn off
		sprite_index = sCrystal;
		
		// Off audio
		if (visibleToCamera(self.id)) audio_play_sound(sfxHurt, 10, false);
	}
}

///	@func	interactPressed();
interactPressed = function()
{
	// Toggle active
	active = !active;
	if (active) sprite_index = sCrystal;
	else sprite_index = sCrystalClosed;
	
	// Toggle sfx
	audio_play_sound(sfxButtonPressed, 2, false);
}

// Start check alarm
alarm[2] = powerCheckFrequency;