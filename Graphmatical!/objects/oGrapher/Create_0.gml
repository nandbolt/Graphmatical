// State
currentState = GrapherState.INIT;

// Menu
currentMenu = undefined;

// Axes
currentAxes = noone;

#region Functions

/// @func	changeAxes({id} axes);
changeAxes = function(_axes)
{
	// Change axes
	currentAxes = _axes;
	x = currentAxes.x;
	y = currentAxes.y;
	
	// Recalculate options
	calculateAxesSelection();
}

/// @func	destroyAxes({id} axes);
destroyAxes = function(_axes)
{
	// If axes exists
	if (_axes)
	{
		// Destroy it
		instance_destroy(_axes);
	}
}

/// @func	calculateAxesSelection();
calculateAxesSelection = function()
{
	// Clear options
	with (currentMenu)
	{
		leftAxes = noone;
		rightAxes = noone;
		topAxes = noone;
		bottomAxes = noone;
	}
	
	// Init axes options + distances
	var _leftAxes = noone, _rightAxes = noone, _topAxes = noone, _bottomAxes = noone;
	var _leftDistance = 0, _rightDistance = 0, _topDistance = 0, _bottomDistance = 0;
	
	// Loop through axes
	with (oAxes)
	{
		// Calculate direction
		var _dx = x - other.x, _dy = y - other.y;
		var _distance = sqrt(_dx * _dx + _dy * _dy);
		if (_distance == 0) continue;
		
		// Check left option
		if (_dx < 0 && (_leftAxes == noone || _distance < _leftDistance))
		{
			_leftAxes = self;
			_leftDistance = _distance;
		}
		// Check right option
		if (_dx > 0 && (_rightAxes == noone || _distance < _rightDistance))
		{
			_rightAxes = self;
			_rightDistance = _distance;
		}
		// Check top option
		if (_dy < 0 && (_topAxes == noone || _distance < _topDistance))
		{
			_topAxes = self;
			_topDistance = _distance;
		}
		// Check bottom option
		if (_dy > 0 && (_bottomAxes == noone || _distance < _bottomDistance))
		{
			_bottomAxes = self;
			_bottomDistance = _distance;
		}
	}
	
	// Set options
	with (currentMenu)
	{
		leftAxes = _leftAxes;
		rightAxes = _rightAxes;
		topAxes = _topAxes;
		bottomAxes = _bottomAxes;
	}
}

/// @func	getFocusedEquationIndex();
getFocusedEquationIndex = function()
{
	// Menu scope
	with (currentMenu)
	{
		// Loop through textfield equations
		for (var _i = 0; _i < array_length(textfieldEquations); _i++)
		{
			// If textfield has focus
			if (textfieldEquations[_i].hasFocus()) return _i;
		}
	}
	return -1;
}

/// @func	moveAxes({int} dx, {int} dy);
moveAxes = function(_dx, _dy)
{
	// If axes exist
	if (instance_exists(currentAxes))
	{
		with (currentAxes)
		{
			// Move axes
			x = clamp(x + _dx * TILE_SIZE, 0, room_width);
			y = clamp(y + _dy * TILE_SIZE, 0, room_height);
			
			// Regraph
			regraphEquations();
		}
		
		// Move grapher
		x = currentAxes.x;
		y = currentAxes.y;
	}
}

/// @func	scaleAxes({int} dx, {int} dy);
scaleAxes = function(_dx, _dy)
{
	// If axes exist
	if (instance_exists(currentAxes))
	{
		with (currentAxes)
		{
			// Scale axes
			setAxesSize(upperDomain * 2 + 2 * _dx, upperRange * 2 + 2 * _dy);
			
			// Regraph
			regraphEquations();
		}
	}
}

#endregion

#region Button Functions

/// @func	createAxes();
createAxes = function()
{
	// If an axes exists
	if (instance_exists(oAxes))
	{
		// Get nearest axes, check if overlapping origin
		var _nearestAxes = instance_nearest(x, y, oAxes);
		if (point_distance(x, y, _nearestAxes.x, _nearestAxes.y) == 0)
		{
			// Error message
			currentMenu.errorMessage = "Overlapping axes! Try selecting it or moving the camera to a new tile.";
			return;
		}
	}
	
	// Create new axes
	currentAxes = instance_create_layer(x, y, "Instances", oAxes);
	
	// Change to grapher choose menu
	changeMenu(GrapherChooseMenu);
	
	// Recalculate options
	calculateAxesSelection();
}

/// @func	removeAxes();
removeAxes = function()
{
	// Destroy axes
	destroyAxes(currentAxes);
	
	// Exit menu
	changeMenu(GrapherInitMenu);
}

/// @func	selectAxes();
selectAxes = function()
{
	// If an axes exists
	if (instance_exists(oAxes))
	{
		// Find closest axes
		currentAxes = instance_nearest(x, y, oAxes);
		x = currentAxes.x;
		y = currentAxes.y;
		
		// Change to grapher choose menu
		changeMenu(GrapherChooseMenu);
		
		// Recalculate options
		calculateAxesSelection();
	}
	else
	{
		// Error message
		currentMenu.errorMessage = "No axes exist! Create one to select it.";
	}
}

/// @func	editAxes();
editAxes = function()
{
	changeMenu(GrapherEditMenu);
}

/// @func	addEquation();
addEquation = function()
{
	// If there is less than 8 equations
	if (array_length(oAxes.equations) < 8)
	{
		// Add equation to axes
		with (oAxes)
		{
			array_push(equations, new Equation(self));
		}
	
		// Add equation textfield to menu
		with (currentMenu)
		{
			addEquationTextfield();
		}
	}
}

/// @func	removeEquation();
removeEquation = function()
{
	// If there is more than 1 equation
	if (array_length(oAxes.equations) > 1)
	{
		// Remove equation from axes
		with (oAxes)
		{
			// Pop equation
			var _equation = array_pop(equations);
		
			// Cleanup equation
			_equation.cleanup();
			delete _equation;
		}
	
		// Remove equation textfield from menu
		with (currentMenu)
		{
			removeEquationTextfield();
		}
	}
}

/// @func	enterEquation();
enterEquation = function()
{
	// Init equation index
	var _eqIdx = getFocusedEquationIndex();
	var _eqString = currentMenu.textfieldEquations[_eqIdx].get();
	
	// Axes scope
	with (currentAxes)
	{
		// Get equation
		with (equations[_eqIdx])
		{
			// Set equation
			set(_eqString);
		}
	}
}

#endregion

// Set position to grid
x -= x mod TILE_SIZE;
y -= y mod TILE_SIZE;

// Init first menu
currentMenu = new GrapherInitMenu();