// Menu
currentMenu = undefined;

#region Button Functions

/// @func	restart();
restart = function()
{
	room_restart();
}

/// @func	backToHub();
backToHub = function()
{
	global.currentLevelName = "Hub";
	if (room == rTutorialLevel) oGameManager.tutorialComplete = true;	// Not really, but prevents spawning back here
	room_goto(rHubLevel);
}

/// @func	quitGame();
quitGame = function()
{
	game_end();
}

#endregion

// Init first menu
currentMenu = new EndMenu();