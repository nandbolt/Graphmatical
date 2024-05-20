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
	// If has one equations
	if (array_length(equations) == 1)
	{
		// Destroy axes if that equation is empty
		var _isStruct = is_struct(equations[0])
		if (!_isStruct || (_isStruct && equations[0].isEmpty())) instance_destroy();
	}
}