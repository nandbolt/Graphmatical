// Inherit the parent event
event_inherited();

// Rotation
rotates = true;

// Level
nextLevel = rHubLevel;
promptString = "Enter";

/// @func	interactPressed();
interactPressed = function()
{
	// Enter portal
	enter();
}

/// @func	enter();
enter = function()
{
	// Setup next room name
	global.currentLevelName = name;
	
	// Setup previous portal index if hub
	if (room == rHubLevel)
	{
		global.previousHubPortalIdx = -1;
		for (var _i = 0; _i < instance_number(oPortal); _i++)
		{
			var _inst = instance_find(oPortal, _i);
			if (instance_exists(_inst) && _inst.id == self.id)
			{
				global.previousHubPortalIdx = _i;
				break;
			}
		}
	}
	else if (room == rTutorialLevel)
	{
		// Tutorial complete
		oGameManager.tutorialComplete = true;
	}
	
	// Destroy player
	with (oPlayer)
	{
		emitBodyParticles();
		instance_destroy();
	}
	
	// Start fade transition
	with (instance_create_layer(0, 0, "Instances", oFadeTransition))
	{
		setupFadeToNextRoom(other.nextLevel);
	}
}