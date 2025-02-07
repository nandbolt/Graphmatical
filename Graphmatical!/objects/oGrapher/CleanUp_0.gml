// Menu
if (currentMenu != undefined)
{
	currentMenu.cleanup();
	delete currentMenu;
}

// If not using a terminal
if (!instance_exists(currentTerminal))
{
	// Loop through axes
	with (oAxes)
	{
		// If has one equation
		if (array_length(equations) == 1)
		{
			// Destroy axes if that equation is empty
			var _isStruct = is_struct(equations[0])
			if (!_isStruct || (_isStruct && equations[0].isEmpty())) instance_destroy();
		}
	}
}

// Toggle grid
if (!instance_exists(oTiler)) layer_set_visible("GridBackground", false);