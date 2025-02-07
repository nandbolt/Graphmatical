// Menu
currentMenu = undefined;

#region Functions

#endregion

#region Button Functions

/// @func	resume();
resume = function()
{
	// If player exists
	if (instance_exists(oPlayer))
	{
		with (oPlayer)
		{
			// Allow movement
			canMove = true;
		
			// Set current editor
			currentEditor = oPauser;
		}
	}
		
	// Close editor sfx
	audio_play_sound(sfxOpenEditor, 2, false);
	
	// Destroy editor
	instance_destroy();
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
currentMenu = new PauserMenu();

// Set position to grid
x = clamp(x - x mod TILE_SIZE + HALF_TILE_SIZE, TILE_SIZE + HALF_TILE_SIZE, room_width - TILE_SIZE - HALF_TILE_SIZE);
y = clamp(y - y mod TILE_SIZE + HALF_TILE_SIZE, TILE_SIZE + HALF_TILE_SIZE, room_height - TILE_SIZE - HALF_TILE_SIZE);

// Open editor sfx
audio_play_sound(sfxOpenEditor, 2, false);