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
	show_debug_message("Editing existing axes!");
	changeMenu();
}

#endregion

// Set position to grid
x -= x mod TILE_SIZE;
y -= y mod TILE_SIZE;

// Init first menu
currentMenu = new GrapherInitMenu();