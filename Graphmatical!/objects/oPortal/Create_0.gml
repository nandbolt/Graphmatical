// Inherit the parent event
event_inherited();

// Level
nextLevel = rHubLevel;

/// @func	interactPressed();
interactPressed = function()
{
	room_goto(nextLevel);
}