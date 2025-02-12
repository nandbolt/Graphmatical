/*
The manager for custom levels when EDITING the level
*/

// Inherit the parent event
event_inherited();

/// @func	saveLevel();
saveLevel = function()
{
	#region Tiles
	
	var _gridWidth = ceil(room_width / TILE_SIZE) - 2;
	var _gridHeight = ceil(room_height / TILE_SIZE) - 2;
	var _tileData = array_create(_gridWidth * _gridHeight, 0);
	for (var _j = 0; _j < _gridHeight; _j++)
	{
		for (var _i = 0; _i < _gridWidth; _i++)
		{
			var _idx = _i + _j * _gridWidth;
			var _x = _i * TILE_SIZE + TILE_SIZE, _y = _j * TILE_SIZE + TILE_SIZE;
			_tileData[_idx] = tilemap_get_at_pixel(worldMap, _x, _y);
		}
	}
	var _tileDataString = json_stringify(_tileData);
	_tileDataString = string_replace_all(_tileDataString, ".0", "");
	
	#endregion
	
	#region Axes
	
	var _axesData = [];
	with (oAxes)
	{
		// Get equations
		var _equations = []
		for (var _i = 0; _i < array_length(equations); _i++)
		{
			array_push(_equations, equations[_i].expressionString);
		}
		
		// Create/push axes struct
		var _axes =
		{
			x : x,
			y : y,
			w : abs(upperDomain) + abs(lowerDomain),
			h : abs(upperRange) + abs(lowerRange),
			mat : material,
			eqs : _equations,
		}
		array_push(_axesData, _axes);
	}
	var _axesDataString = json_stringify(_axesData);
	_axesDataString = string_replace_all(_axesDataString, "\"", "$");
	
	#endregion
	
	// Open
	ini_open(fileName);
	
	// Save level json string
	ini_write_string("objs", "tiles", _tileDataString);
	ini_write_string("objs", "graphs", _axesDataString);
	
	// Close
	ini_close();
	
	// Print
	show_debug_message("Level saved!");
	
	// Make a sound
	audio_play_sound(sfxFlagActivated, 10, false);
}

// Setup global modes
with (oLevel)
{
	globalGraphing = true;
	globalTiling = true;
}