// Menu
currentMenu = undefined;

// Collisions
collisionMap = layer_tilemap_get_id("CollisionTiles");
worldMap = layer_tilemap_get_id("WorldTiles");

// Index
currentIdx = 1;
maxIdx = 8;
currentSprite = noone;
previousTile = 0;

#region Functions

/// @func	move({int} dx, {int} dy);
move = function(_dx, _dy)
{
	// Replace current tile to previous
	tilemap_set_at_pixel(worldMap, previousTile, x, y);
	
	// Move tiler
	x = clamp(x + _dx * TILE_SIZE, TILE_SIZE + HALF_TILE_SIZE, room_width - TILE_SIZE - HALF_TILE_SIZE);
	y = clamp(y + _dy * TILE_SIZE, TILE_SIZE + HALF_TILE_SIZE, room_height - TILE_SIZE - HALF_TILE_SIZE);
	
	// Replace previous tile and set tile
	previousTile = tilemap_get_at_pixel(worldMap, x, y);
	if (currentIdx < 3) tilemap_set_at_pixel(worldMap, currentIdx, x, y);
	else tilemap_set_at_pixel(worldMap, 0, x, y);
	
	// Move sound
	audio_play_sound(sfxButtonPressed, 2, false);
}

/// @func	toggleTile()
toggleTile = function()
{
	// If previous tile was a tile
	if (previousTile > 0)
	{
		// Remove floor tile
		tilemap_set_at_pixel(collisionMap, 0, x, y);
		tilemap_set_at_pixel(worldMap, 0, x, y);
		previousTile = 0;
	}
	else
	{
		// Get instance collisions
		var _interactable = instance_place(x, y, oInteractable);
		var _obstacle = instance_place(x, y, oObstacle);
		
		// If collision
		if (_interactable != noone) instance_destroy(_interactable);
		else if (_obstacle != noone) instance_destroy(_obstacle);
		else
		{
			// If trying to place something other than a tile
			if (currentIdx > 2)
			{
				// Place it
				var _obj = noone, _layerName = "Instances";
				if (currentIdx == 3) _obj = oSpawnFlag;
				else if (currentIdx == 4) _obj = oCheckFlag;
				else if (currentIdx == 5) _obj = oGoalFlag;
				else if (currentIdx == 6)
				{
					_obj = oSpike;
					_layerName = "MiddleBackgroundInstances";
				}
				else if (currentIdx == 7) _obj = oSign;
				else if (currentIdx == 8)
				{
					_obj = oBall;
					_layerName = "MiddleForegroundInstances";
				}
				if (_obj != noone) instance_create_layer(x, y, _layerName, _obj);
			}
			else
			{
				// Set current tile
				tilemap_set_at_pixel(worldMap, currentIdx, x, y);
				if (currentIdx == 1) tilemap_set_at_pixel(collisionMap, currentIdx, x, y);
				previousTile = currentIdx;
			}
		}
	}
	
	// Toggle sound
	audio_play_sound(sfxSignRead, 2, false);
}

/// @func	cycleIdx({int} idx);
cycleIdx = function(_idx)
{
	// Set index
	if (_idx > maxIdx) currentIdx = 1;
	else if (_idx < 1) currentIdx = maxIdx;
	else currentIdx = _idx;
	
	// Set tile if tile
	if (currentIdx < 3) tilemap_set_at_pixel(worldMap, currentIdx, x, y);
	else
	{
		// Remove tile if previous was 0
		if (previousTile == 0) tilemap_set_at_pixel(worldMap, 0, x, y);
		
		// Set sprite
		if (currentIdx == 3) currentSprite = sSpawnFlag;
		else if (currentIdx == 4) currentSprite = sCheckFlag;
		else if (currentIdx == 5) currentSprite = sGoalFlag;
		else if (currentIdx == 6) currentSprite = sSpike;
		else if (currentIdx == 7) currentSprite = sSign;
		else if (currentIdx == 8) currentSprite = sBall;
	}
	
	// Cycle sound
	audio_play_sound(sfxButtonPressed, 2, false);
}

#endregion

// Init first menu
currentMenu = new TilerMenu();

// Set position to grid
x = clamp(x - x mod TILE_SIZE + HALF_TILE_SIZE, TILE_SIZE + HALF_TILE_SIZE, room_width - TILE_SIZE - HALF_TILE_SIZE);
y = clamp(y - y mod TILE_SIZE + HALF_TILE_SIZE, TILE_SIZE + HALF_TILE_SIZE, room_height - TILE_SIZE - HALF_TILE_SIZE);

// Replace previous tile and set tile
previousTile = tilemap_get_at_pixel(worldMap, x, y);
tilemap_set_at_pixel(worldMap, currentIdx, x, y);

// Toggle grid
layer_set_visible("GridBackground", true);

// Open editor sfx
audio_play_sound(sfxOpenEditor, 2, false);