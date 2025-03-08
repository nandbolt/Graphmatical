// Inherit the parent event
event_inherited();

// Launch
charge = 0;
maxCharge = 60;
charging = false;
maxLaunchStrength = 5;
minLaunchStrength = 1;

// Load
loadedSprite = -1;
loadOffsetLength = 8;
loadOffset = new Vector2(loadOffsetLength, 0);

#region Functions

///	@func	interact();
interact = function()
{
	// Return if not loaded
	if (loadedSprite == -1) return;
	
	// Charge
	charging = true;
	charge = clamp(charge + 1, 0, maxCharge);
}

/// @func	interactReleased();
interactReleased = function()
{
	// Return if not loaded
	if (loadedSprite == -1) return;
	
	// Get load object
	var _obj = oBall;
	switch (loadedSprite)
	{
		case sBallSpike:
			_obj = oBallSpike;
			break;
		case sWalker:
			_obj = oWalker;
			break;
		case sWalkerSide:
			_obj = oWalker;
			break;
		case sWalkerSpike:
			_obj = oWalkerSpike;
			break;
		case sWalkerSpikeSide:
			_obj = oWalkerSpike;
			break;
	}
	
	// Spawn ball
	var _launchStrength = lerp(minLaunchStrength, maxLaunchStrength, charge / maxCharge);
	with (instance_create_layer(x + loadOffset.x, y + loadOffset.y, "MiddleForegroundInstances", _obj))
	{
		velocity.x = other.loadOffset.x * _launchStrength / other.loadOffsetLength;
		velocity.y = other.loadOffset.y * _launchStrength / other.loadOffsetLength;
	}
	
	// Ball launch sfx
	audio_play_sound(sfxButtonPressed, 5, false);
	
	// Release charge
	charging = false;
	charge = 0;
	loadedSprite = -1;
	sprite_index = sBallCannon;
}

///	@func	loadCannon(inst);
loadCannon = function(_inst)
{
	// Return if already loaded
	if (loadedSprite != -1) return;
	
	// Set loaded sprite
	loadedSprite = _inst.sprite_index;
	sprite_index = sBallCannonLoaded;
	
	// Load sfx
	if (visibleToCamera(self.id)) audio_play_sound(sfxButtonPressed, 5, false);
	
	// Destroy instance
	if (_inst.object_index == oPlayer) loadedSprite = sNoFlag;
	else instance_destroy(_inst);
}

#endregion