/*
The manager for custom levels when PLAYING the level
*/

// File
fileName = "custom-level_" + string(global.customLevelIdx) + ".sav";

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
	globalGraphing = false;
	globalTiling = false;
}