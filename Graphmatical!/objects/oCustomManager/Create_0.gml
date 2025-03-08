/*
The manager for custom levels when PLAYING the level
*/

// Collisions
collisionMap = layer_tilemap_get_id("CollisionTiles");
worldMap = layer_tilemap_get_id("WorldTiles");

// File
fileName = "custom-level_" + string(global.customLevelIdx) + ".sav";

/// @func	loadLevel();
loadLevel = function()
{
	// Open
	ini_open(fileName);
	
	// General info
	global.currentLevelName = ini_read_string("gen", "name", "Custom Level");
	global.currentLevelCreator = ini_read_string("gen", "creator", "");
	
	#region Tiles
	
	var _gridWidth = ceil(room_width / TILE_SIZE) - 2;
	var _gridHeight = ceil(room_height / TILE_SIZE) - 2;
	var _tileDataString = ini_read_string("objs", "tiles", "");
	if (_tileDataString != "")
	{
		var _tileData = json_parse(_tileDataString);
		if (is_array(_tileData))
		{
			// Loop through tile grid
			for (var _j = 0; _j < _gridHeight; _j++)
			{
				for (var _i = 0; _i < _gridWidth; _i++)
				{
					var _idx = _i + _j * _gridWidth;
					var _x = _i * TILE_SIZE + TILE_SIZE, _y = _j * TILE_SIZE + TILE_SIZE;
					tilemap_set_at_pixel(worldMap, _tileData[_idx], _x, _y);
					if (_tileData[_idx] == 1) tilemap_set_at_pixel(collisionMap, _tileData[_idx], _x, _y);
					else if (_tileData[_idx] > 2 && _tileData[_idx] < 7)
					{
						// Sloped tile
						tilemap_set_at_pixel(collisionMap, 2, _x, _y);
						var _data = tilemap_get_at_pixel(collisionMap, _x, _y);
						if (_tileData[_idx] == 4 || _tileData[_idx] == 5) _data = tile_set_flip(_data, true);
						if (_tileData[_idx] == 4 || _tileData[_idx] == 6) _data = tile_set_mirror(_data, true);
						tilemap_set_at_pixel(collisionMap, _data, _x, _y);
					}
				}
			}
		}
	}
	
	#endregion
	
	#region Axes
	
	// Get axes data string
	var _axesDataString = ini_read_string("objs", "graphs", "");
	if (_axesDataString != "")
	{
		_axesDataString = string_replace_all(_axesDataString, "$", "\"");
		var _axesData = json_parse(_axesDataString);
		if (is_array(_axesData))
		{
			// Init all axes
			while (array_length(_axesData) > 0)
			{
				var _axes = array_pop(_axesData);
				if (is_struct(_axes))
				{
					with (instance_create_layer(_axes.x, _axes.y, "MiddleBackgroundInstances", oAxes))
					{
						// Set material
						material = _axes.mat;

						// Equations
						for (var _i = 0; _i < array_length(_axes.eqs); _i++)
						{
							equations[_i].set(_axes.eqs[_i]);
						}

						// Set size
						setAxesSize(_axes.w, _axes.h);

						// Regraph
						regraphEquations();
					}
				}
			}
		}
	}
	
	#endregion
	
	#region Terminals
	
	// Get terminal data string
	var _terminalDataString = ini_read_string("objs", "terminals", "");
	if (_terminalDataString != "")
	{
		_terminalDataString = string_replace_all(_terminalDataString, "$", "\"");
		var _terminalData = json_parse(_terminalDataString);
		if (is_array(_terminalData))
		{
			// Init all axes
			while (array_length(_terminalData) > 0)
			{
				var _terminal = array_pop(_terminalData);
				if (is_struct(_terminal))
				{
					with (instance_create_layer(_terminal.x, _terminal.y, "Instances", oTerminalGrapher))
					{
						// Set origin
						axesOffsetX = _terminal.offx;
						axesOffsetY = _terminal.offy;
						
						// Init
						initGraph();
					}
				}
			}
		}
	}
	
	#endregion
	
	#region Flags
	
	// Get flag data string
	var _flagDataString = ini_read_string("objs", "flags", "");
	if (_flagDataString != "")
	{
		_flagDataString = string_replace_all(_flagDataString, "$", "\"");
		var _flagData = json_parse(_flagDataString);
		if (is_array(_flagData))
		{
			// Init all axes
			while (array_length(_flagData) > 0)
			{
				var _flag = array_pop(_flagData);
				if (is_struct(_flag))
				{
					// Get flag object from type index
					var _obj = oCheckFlag;
					switch (_flag.type)
					{
						case 0:
							_obj = oSpawnFlag;
							break;
						case 2:
							_obj = oGoalFlag;
							break;
					}
					
					// Spawn/move flag
					if (_obj == oSpawnFlag)
					{
						// Move spawn point
						with (oLevel)
						{
							moveSpawnPoint(_flag.x, _flag.y);
						}
					}
					else instance_create_layer(_flag.x, _flag.y, "Instances", _obj);
				}
			}
		}
	}
	
	#endregion
	
	#region Signs
	
	// Get sign data string
	var _signDataString = ini_read_string("objs", "signs", "");
	if (_signDataString != "")
	{
		_signDataString = string_replace_all(_signDataString, "$", "\"");
		var _signData = json_parse(_signDataString);
		if (is_array(_signData))
		{
			// Init all axes
			while (array_length(_signData) > 0)
			{
				var _sign = array_pop(_signData);
				if (is_struct(_sign))
				{
					with (instance_create_layer(_sign.x, _sign.y, "Instances", oSign))
					{
						text = _sign.msg;
						name = _sign.name;
					}
				}
			}
		}
	}
	
	#endregion
	
	#region Spikes
	
	// Get sign data string
	var _spikeDataString = ini_read_string("objs", "spikes", "");
	if (_spikeDataString != "")
	{
		_spikeDataString = string_replace_all(_spikeDataString, "$", "\"");
		var _spikeData = json_parse(_spikeDataString);
		if (is_array(_spikeData))
		{
			// Init all axes
			while (array_length(_spikeData) > 0)
			{
				var _spike = array_pop(_spikeData);
				if (is_struct(_spike))
				{
					var _obj = oSpike;
					if (variable_struct_exists(_spike, "type") && _spike.type == 1) _obj = oSpikeGrid;
					instance_create_layer(_spike.x, _spike.y, "BackgroundInstances", _obj);
				}
			}
		}
	}
	
	#endregion
	
	#region Launchers
	
	// Get sign data string
	var _launcherDataString = ini_read_string("objs", "launchers", "");
	if (_launcherDataString != "")
	{
		_launcherDataString = string_replace_all(_launcherDataString, "$", "\"");
		var _launcherData = json_parse(_launcherDataString);
		if (is_array(_launcherData))
		{
			// Init all axes
			while (array_length(_launcherData) > 0)
			{
				var _launcher = array_pop(_launcherData);
				if (is_struct(_launcher))
				{
					with (instance_create_layer(_launcher.x, _launcher.y, "Instances", oBallLauncher))
					{
						image_angle = _launcher.angle;
					}
				}
			}
		}
	}
	
	#endregion
	
	#region Spawn Points
	
	// Get sign data string
	var _spawnDataString = ini_read_string("objs", "spawns", "");
	if (_spawnDataString != "")
	{
		_spawnDataString = string_replace_all(_spawnDataString, "$", "\"");
		var _spawnData = json_parse(_spawnDataString);
		if (is_array(_spawnData))
		{
			// Init all axes
			while (array_length(_spawnData) > 0)
			{
				var _sp = array_pop(_spawnData);
				if (is_struct(_sp))
				{
					var _obj = oBall;
					if (object_index == oCustomEditorManager)
					{
						// Spawn point
						_obj = oBallSpawnPoint;
						switch (_sp.type)
						{
							case 1:
								_obj = oWalkerSpawnPoint;
								break;
							case 2:
								_obj = oBallSpikeSpawnPoint;
								break;
							case 3:
								_obj = oWalkerSpikeSpawnPoint;
								break;
							case 4:
								_obj = oCubeSpawnPoint;
								break;
						}
					}
					else
					{
						// Actual object
						switch (_sp.type)
						{
							case 1:
								_obj = oWalker;
								break;
							case 2:
								_obj = oBallSpike;
								break;
							case 3:
								_obj = oWalkerSpike;
								break;
							case 4:
								_obj = oCube;
								break;
						}
					}
					with (instance_create_layer(_sp.x, _sp.y, "Instances", _obj))
					{
						imageAngle = _sp.angle;
					}
				}
			}
		}
	}
	
	#endregion
	
	#region Crystals
	
	// Get sign data string
	var _crystalDataString = ini_read_string("objs", "crystals", "");
	if (_crystalDataString != "")
	{
		_crystalDataString = string_replace_all(_crystalDataString, "$", "\"");
		var _crystalData = json_parse(_crystalDataString);
		if (is_array(_crystalData))
		{
			// Init all axes
			while (array_length(_crystalData) > 0)
			{
				var _crystal = array_pop(_crystalData);
				if (is_struct(_crystal))
				{
					with (instance_create_layer(_crystal.x, _crystal.y, "Instances", oCrystal))
					{
						active = _crystal.active;
					}
				}
			}
		}
	}
	
	#endregion
	
	// Close
	ini_close();
	
	// Print
	show_debug_message("Level loaded!");
}

// Setup global modes
with (oLevel)
{
	globalGraphing = false;
	globalTiling = false;
}