// Inherit the parent event
event_inherited();

// Custom index
customIdx = 1;
name = "Custom Level " + string(customIdx);
nextLevel = rEmptyLevel;

/// @func	interactPressed();
interactPressed = function()
{
	// Check edit vs. play
	if (keyboard_check(vk_shift)) global.editMode = true;
	else global.editMode = false;
	
	// Set custom level idx
	global.customLevelIdx = customIdx;
	
	// Enter portal
	enter();
}

/// @func	changeCustomIndex({int} idx);
changeCustomIndex = function(_idx)
{
	customIdx = _idx;
	name = "Custom Level " + string(customIdx);
}