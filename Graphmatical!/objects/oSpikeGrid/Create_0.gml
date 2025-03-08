// Inherit the parent event
event_inherited();

// Choose random image index
image_index = irandom(image_number);

// State
active = false;

// Power
residualPowerTime = 30;
powerCheckFrequency = 15;

///	@func	toggleActive(on);
toggleActive = function(_on)
{
	// Active
	active = _on;
	
	// Sprites
	if (sprite_index == sSpikeGridUnpowered && _on)
	{
		// Turn on
		sprite_index = sSpikeGridPowered;
		
		// On audio
		if (visibleToCamera(self.id)) audio_play_sound(sfxHurt, 5, false);
	}
	else if (sprite_index == sSpikeGridPowered && !_on)
	{
		// Turn off
		sprite_index = sSpikeGridUnpowered;
		
		// Off audio
		if (visibleToCamera(self.id)) audio_play_sound(sfxHurt, 5, false);
	}
	
	// Alarm
	if (_on) alarm[0] = residualPowerTime;
}

// Start check alarm
alarm[1] = powerCheckFrequency;