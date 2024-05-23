// Menu
if (currentMenu != undefined)
{
	currentMenu.cleanup();
	delete currentMenu;
}

// Toggle grid
if (!instance_exists(oGrapher)) layer_set_visible("GridBackground", false);