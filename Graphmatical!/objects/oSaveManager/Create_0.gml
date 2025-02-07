/// @desc Event

#region Functions

/// @func	save();
save = function()
{
	// Open
	ini_open("save_1.sav");
	
	// Game manager
	ini_write_real("General", "tutorialComplete", oGameManager.tutorialComplete);
	
	// Close
	ini_close();
}

/// @func	load();
load = function()
{
	// Open
	ini_open("save_1.sav");
	
	// Game manager
	with (oGameManager)
	{
		tutorialComplete = ini_read_real("General", "tutorialComplete", false);
	}
	
	// Close
	ini_close();
}

#endregion