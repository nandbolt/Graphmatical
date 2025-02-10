/*
The manager for custom levels when EDITING the level
*/

// Inherit the parent event
event_inherited();

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

// Setup global modes
with (oLevel)
{
	globalGraphing = true;
	globalTiling = true;
}