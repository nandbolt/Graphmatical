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