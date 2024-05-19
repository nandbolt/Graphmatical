// Menu
if (currentMenu != undefined)
{
	currentMenu.cleanup();
	delete currentMenu;
}

// Maps
ds_map_destroy(precedenceMap);

// Loop through axes
with (oAxes)
{
	// If has no equations
	if (array_length(equations) == 1 && array_length(equations[0].expressionTokens) == 0)
	{
		// Destroy axes
		instance_destroy();
	}
}