// Menu
if (currentMenu != undefined)
{
	currentMenu.cleanup();
	delete currentMenu;
}

// Maps
ds_map_destroy(precedenceMap);