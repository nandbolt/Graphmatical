// Menu
if (currentMenu != undefined)
{
	currentMenu.cleanup();
	delete currentMenu;
}

// Toggle grid
if (!instance_exists(oGrapher)) layer_set_visible("GridBackground", false);

// Replace current tile to previous
tilemap_set_at_pixel(worldMap, previousTile, x, y);