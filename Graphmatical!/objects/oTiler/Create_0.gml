// Menu
currentMenu = undefined;

// Collisions
collisionMap = layer_tilemap_get_id("CollisionTiles");
worldMap = layer_tilemap_get_id("WorldTiles");

#region Functions

/// @func	move({int} dx, {int} dy);
move = function(_dx, _dy)
{
	// Move tiler
	x = clamp(x + _dx * TILE_SIZE, TILE_SIZE + HALF_TILE_SIZE, room_width - TILE_SIZE - HALF_TILE_SIZE);
	y = clamp(y + _dy * TILE_SIZE, TILE_SIZE + HALF_TILE_SIZE, room_height - TILE_SIZE - HALF_TILE_SIZE);
}

/// @func	toggleTile()
toggleTile = function()
{
	var _tile = tilemap_get_at_pixel(collisionMap, x, y);
	if (_tile == 0)
	{
		// Set floor tile
		tilemap_set_at_pixel(collisionMap, 1, x, y);
		tilemap_set_at_pixel(worldMap, 1, x, y);
	}
	else
	{
		// Remove floor tile
		tilemap_set_at_pixel(collisionMap, 0, x, y);
		tilemap_set_at_pixel(worldMap, 0, x, y);
	}
}

#endregion

// Init first menu
currentMenu = new TilerMenu();

// Set position to grid
x = clamp(x - x mod TILE_SIZE + HALF_TILE_SIZE, TILE_SIZE + HALF_TILE_SIZE, room_width - TILE_SIZE - HALF_TILE_SIZE);
y = clamp(y - y mod TILE_SIZE + HALF_TILE_SIZE, TILE_SIZE + HALF_TILE_SIZE, room_height - TILE_SIZE - HALF_TILE_SIZE);

// Toggle grid
layer_set_visible("GridBackground", true);