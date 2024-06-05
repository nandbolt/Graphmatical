/// @func	visibleToCamera({id} inst);
function visibleToCamera(_inst)
{
	var _cx1 = camera_get_view_x(view_camera[0]);
	var _cy1 = camera_get_view_y(view_camera[0]);
	var _cx2 = _cx1 + camera_get_view_width(view_camera[0]);
	var _cy2 = _cy1 + camera_get_view_height(view_camera[0]);
	return _inst.bbox_left < _cx2 && _inst.bbox_right > _cx1 && _inst.bbox_top < _cy2 && _inst.bbox_bottom > _cy1;
}

/// @func	graphPointAbove({Struct.Equation} equation, {real} x, {real} y);
function graphPointAbove(_equation, _x, _y)
{
	// Get graph outputs
	var _axisY = yToAxisY(_equation.axes, _y), _graphY = _equation.evaluate(xToAxisX(_equation.axes, _x));
	
	// Return if original y is above graph evaluation
	if (is_string(_graphY)) return true;
	return _axisY > _graphY;
}

/// @func	graphVectorGroundCollision({Struct.Equation} equation, {real} x1, {real} y1, {real} x2, {real} y2);
function graphVectorGroundCollision(_equation, _x1, _y1, _x2, _y2)
{
	// Loop through domains
	for (var _i = 0; _i < array_length(_equation.xGraphPaths); _i++)
	{
		// Get domain
		var _domain = _equation.xGraphPaths[_i];
		
		// Continue if empty array
		if (array_length(_domain) == 0) continue;
		
		// Get bounds
		var _lowerBound = _domain[0], _upperBound = _domain[array_length(_domain)-1]
		
		// If either point is within the domain
		if ((_x1 >= _lowerBound && _x1 <= _upperBound) || (_x2 >= _lowerBound && _x2 <= _upperBound))
		{
			// Collision if starting point above and ending point below
			if (graphPointAbove(_equation, clamp(_x1, _lowerBound, _upperBound), _y1) && !graphPointAbove(_equation, clamp(_x2, _lowerBound, _upperBound), _y2)) return true;
		}
	}
	
	// No collision
	return false;
}

/// @func	graphTouching({Struct.Equation} equation, {id} inst);
function graphTouching(_equation, _inst)
{
	// Loop through domains
	for (var _i = 0; _i < array_length(_equation.xGraphPaths); _i++)
	{
		// Get domain
		var _domain = _equation.xGraphPaths[_i];
		
		// Continue if empty array
		if (array_length(_domain) == 0) continue;
		
		// Get bounds
		var _lowerBound = _domain[0], _upperBound = _domain[array_length(_domain)-1]
		
		// If within the domain
		if (_inst.bbox_right >= _lowerBound && _inst.bbox_left <= _upperBound)
		{
			var _aboveGraph = graphPointAbove(_equation, _inst.bbox_left, _inst.bbox_top);
			return (_aboveGraph != graphPointAbove(_equation, _inst.bbox_right, _inst.bbox_top) ||
					_aboveGraph != graphPointAbove(_equation, _inst.bbox_right, _inst.bbox_bottom) ||
					_aboveGraph != graphPointAbove(_equation, _inst.bbox_left, _inst.bbox_bottom));
		}
	}
}