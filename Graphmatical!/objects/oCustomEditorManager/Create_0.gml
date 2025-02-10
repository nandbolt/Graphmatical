/*
The manager for custom levels when EDITING the level
*/

// File
fileName = "custom-level_" + string(global.customLevelIdx) + ".sav";

/// @func	saveLevel();
saveLevel = function()
{
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
	show_debug_message("json: " + _axesDataString);
	
	#endregion
	
	// Open
	ini_open(fileName);
	
	// Save level json string
	ini_write_string("objs", "graphs", _axesDataString);
	
	// Close
	ini_close();
}

/// @func	loadLevel();
loadLevel = function()
{
	// Open
	ini_open(fileName);
	
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
}

// Setup global modes
with (oLevel)
{
	globalGraphing = true;
	globalTiling = true;
}

// Load level
loadLevel();