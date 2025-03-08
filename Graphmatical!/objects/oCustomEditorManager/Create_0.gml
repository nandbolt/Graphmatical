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
	
	#region Terminals
	
	var _terminalData = [];
	with (oTerminalGrapher)
	{
		// Calculate origin position
		var _offx = axesOffsetX, _offy = axesOffsetX;
		if (instance_exists(axes))
		{
			// Get axes origin
			_offx = (axes.x - x + x mod TILE_SIZE) / TILE_SIZE;
			_offy = (axes.y - y + y mod TILE_SIZE) / TILE_SIZE;
		}
		var _terminal =
		{
			x : x,
			y : y,
			offx : _offx,
			offy : _offy,
		}
		array_push(_terminalData, _terminal);
	}
	var _terminalDataString = json_stringify(_terminalData);
	_terminalDataString = string_replace_all(_terminalDataString, "\"", "$");
	
	#endregion
	
	#region Flags
	
	var _flagData = [];
	with (oFlag)
	{
		var _idx = 0;
		switch (object_index)
		{
			case oCheckFlag:
				_idx = 1;
				break;
			case oGoalFlag:
				_idx = 2;
				break;
		}
		var _flag =
		{
			x : x,
			y : y,
			type : _idx,
		}
		array_push(_flagData, _flag);
	}
	var _flagDataString = json_stringify(_flagData);
	_flagDataString = string_replace_all(_flagDataString, "\"", "$");
	
	#endregion
	
	#region Signs
	
	var _signData = [];
	with (oSign)
	{
		var _sign =
		{
			x : x,
			y : y,
			name : name,
			msg : text,
		}
		array_push(_signData, _sign);
	}
	var _signDataString = json_stringify(_signData);
	_signDataString = string_replace_all(_signDataString, "\"", "$");
	
	#endregion
	
	#region Spikes
	
	var _spikeData = [];
	with (oSpike)
	{
		var _spike =
		{
			x : x,
			y : y,
		}
		array_push(_spikeData, _spike);
	}
	var _spikeDataString = json_stringify(_spikeData);
	_spikeDataString = string_replace_all(_spikeDataString, "\"", "$");
	
	#endregion
	
	#region Ball Launcher
	
	var _launcherData = [];
	with (oBallLauncher)
	{
		var _launcher =
		{
			x : x,
			y : y,
			angle : image_angle,
		}
		array_push(_launcherData, _launcher);
	}
	var _launcherDataString = json_stringify(_launcherData);
	_launcherDataString = string_replace_all(_launcherDataString, "\"", "$");
	
	#endregion
	
	#region Spawn Points
	
	var _spawnData = [];
	with (oSpawnPoint)
	{
		var _type = 0;
		switch (object_index)
		{
			case oWalkerSpawnPoint:
				_type = 1;
				break;
			case oBallSpikeSpawnPoint:
				_type = 2;
				break;
		}
		var _sp =
		{
			x : x,
			y : y,
			type : _type,
			angle : image_angle,
		}
		array_push(_spawnData, _sp);
	}
	var _spawnDataString = json_stringify(_spawnData);
	_spawnDataString = string_replace_all(_spawnDataString, "\"", "$");
	
	#endregion
	
	// Open
	ini_open(fileName);
	
	// General info
	ini_write_string("gen", "name", global.currentLevelName);
	ini_write_string("gen", "creator", global.currentLevelCreator);
	
	// Save level json strings
	ini_write_string("objs", "tiles", _tileDataString);
	ini_write_string("objs", "graphs", _axesDataString);
	ini_write_string("objs", "terminals", _terminalDataString);
	ini_write_string("objs", "flags", _flagDataString);
	ini_write_string("objs", "signs", _signDataString);
	ini_write_string("objs", "spikes", _spikeDataString);
	ini_write_string("objs", "launchers", _launcherDataString);
	ini_write_string("objs", "spawns", _spawnDataString);
	
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