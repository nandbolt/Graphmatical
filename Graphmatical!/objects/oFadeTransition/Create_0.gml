// Type
fadeToNextRoom = false;
nextRoom = -1;

// Fade
fadeStallTime = 30;
fadeTime = 60;

/// @func	setupFadeToNextRoom({room} nextRoom)
setupFadeToNextRoom = function(_room)
{
	fadeToNextRoom = true;
	nextRoom = _room;
}

// Start fade
alarm[0] = fadeTime + fadeStallTime;