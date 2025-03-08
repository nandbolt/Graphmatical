// Menu
currentMenu = undefined;

// Collisions
collisionMap = layer_tilemap_get_id("CollisionTiles");
worldMap = layer_tilemap_get_id("WorldTiles");

// Index
currentIdx = 1;
currentSprite = noone;
previousTile = 0;
lastTileIdx = 6;
objectCount = 12;
maxIdx = lastTileIdx + objectCount;

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
	if (currentIdx <= lastTileIdx) tilemap_set_at_pixel(worldMap, currentIdx, x, y);
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
			if (currentIdx > lastTileIdx)
			{
				// Place it
				var _obj = noone, _layerName = "Instances";
				if (currentIdx == (lastTileIdx + 1)) _obj = oSpawnFlag;
				else if (currentIdx == (lastTileIdx + 2)) _obj = oCheckFlag;
				else if (currentIdx == (lastTileIdx + 3)) _obj = oGoalFlag;
				else if (currentIdx == (lastTileIdx + 4))
				{
					_obj = oSpike;
					_layerName = "MiddleBackgroundInstances";
				}
				else if (currentIdx == (lastTileIdx + 5)) _obj = oSign;
				else if (currentIdx == (lastTileIdx + 6))
				{
					_obj = oBallSpawnPoint;
					_layerName = "MiddleForegroundInstances";
				}
				else if (currentIdx == (lastTileIdx + 7)) _obj = oBallLauncher;
				else if (currentIdx == (lastTileIdx + 8)) _obj = oTerminalGrapher;
				else if (currentIdx == (lastTileIdx + 9)) _obj = oWalkerSpawnPoint;
				else if (currentIdx == (lastTileIdx + 10)) _obj = oBallSpikeSpawnPoint;
				else if (currentIdx == (lastTileIdx + 11)) _obj = oWalkerSpikeSpawnPoint;
				else if (currentIdx == (lastTileIdx + 12)) _obj = oCubeSpawnPoint;
				if (_obj != noone) instance_create_layer(x, y, _layerName, _obj);
			}
			else
			{
				// Set current tile
				tilemap_set_at_pixel(worldMap, currentIdx, x, y);
				if (currentIdx == 1) tilemap_set_at_pixel(collisionMap, currentIdx, x, y);
				else if (currentIdx > 2 && currentIdx < 7)
				{
					// Sloped tile
					tilemap_set_at_pixel(collisionMap, 2, x, y);
					var _data = tilemap_get_at_pixel(collisionMap, x, y);
					if (currentIdx == 4 || currentIdx == 5) _data = tile_set_flip(_data, true);
					if (currentIdx == 4 || currentIdx == 6) _data = tile_set_mirror(_data, true);
					tilemap_set_at_pixel(collisionMap, _data, x, y);
				}
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
	if (currentIdx <= lastTileIdx) tilemap_set_at_pixel(worldMap, currentIdx, x, y);
	else
	{
		// Remove tile if previous was 0
		if (previousTile == 0) tilemap_set_at_pixel(worldMap, 0, x, y);
		
		// Set sprite
		if (currentIdx == (lastTileIdx + 1)) currentSprite = sSpawnFlag;
		else if (currentIdx == (lastTileIdx + 2)) currentSprite = sCheckFlag;
		else if (currentIdx == (lastTileIdx + 3)) currentSprite = sGoalFlag;
		else if (currentIdx == (lastTileIdx + 4)) currentSprite = sSpike;
		else if (currentIdx == (lastTileIdx + 5)) currentSprite = sSign;
		else if (currentIdx == (lastTileIdx + 6)) currentSprite = sBall;
		else if (currentIdx == (lastTileIdx + 7)) currentSprite = sBallCannon;
		else if (currentIdx == (lastTileIdx + 8)) currentSprite = sTerminal;
		else if (currentIdx == (lastTileIdx + 9)) currentSprite = sWalker;
		else if (currentIdx == (lastTileIdx + 10)) currentSprite = sBallSpike;
		else if (currentIdx == (lastTileIdx + 11)) currentSprite = sWalkerSpike;
		else if (currentIdx == (lastTileIdx + 12)) currentSprite = sCube;
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