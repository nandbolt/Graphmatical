#macro DONT_INTERSECT 0
#macro DO_INTERSECT 1
#macro PARALLEL 2

/// @func	Line({real} x1, {real y1, {real} x2, {real} y2);
function Line(_x1=0, _y1=0, _x2=0, _y2=0) constructor
{
	// Points
	x1 = _x1;
	y1 = _y1;
	x2 = _x2;
	y2 = _y2;
	
	// Info
	angle = point_direction(x1, y1, x2, y2);
	length = point_distance(x1, y1, x2, y2);
	
	/// @func	set({real} x1, {real y1, {real} x2, {real} y2);
	static set = function(_x1, _y1, _x2, _y2)
	{
		// Points
		x1 = _x1;
		y1 = _y1;
		x2 = _x2;
		y2 = _y2;
	
		// Info
		angle = point_direction(x1, y1, x2, y2);
		length = point_distance(x1, y1, x2, y2);
	}
	
	/// @func	setRandom({real} xmin, {real ymin, {real} xmax, {real} ymax);
	static setRandom = function(_xmin, _ymin, _xmax, _ymax)
	{
		// Set
		set(random_range(_xmin, _xmax), random_range(_ymin, _ymax), random_range(_xmin, _xmax), random_range(_ymin, _ymax));
	}
	
	/// @func	draw({sprite} sprite, {int} subimage, {color} color, {real} alpha);
	static draw = function(_sprite=sDot, _subimage=0, _color=c_white, _alpha=1)
	{
		// Line
		draw_sprite_ext(_sprite, _subimage, x1, y1, length, 1, angle, _color, _alpha);
	}
	
	/// @func	lineIntersection({real} x3, {real y3, {real} x4, {real} y4, {Struct.Vector2} point);
	/// @desc	Returns if there is an intersection. If there is, it will update the given point.
	///			Based on Franklin Antonio's "Faster Line Segment Intersection" topic "in Graphics Gems III" book (http://www.graphicsgems.org/)
	static lineIntersection = function(_x3, _y3, _x4, _y4, _point=noone)
	{
		// Zero length
		if (length == 0 || (_x3 == _x4 && _y3 == _y4)) return noone;
		
		// Bounding box variables
		var _x1Low, _x1High, _y1Low, _y1High;
		
		// Calculate x differences
		var _ax = x2 - x1, _bx = _x3 - _x4;
		
		#region X Bbox Test
		
		// Set bounds
		if (_ax < 0)
		{
			_x1Low = x2;
			_x1High = x1;
		}
		else
		{
			_x1Low = x1;
			_x1High = x2;
		}
		
		// Check out of bounds
		if (_bx > 0)
		{
			if (_x1High < _x4 || _x3 < _x1Low) return DONT_INTERSECT;
		}
		else
		{
			if (_x1High < _x3 || _x4 < _x1Low) return DONT_INTERSECT;
		}
		
		#endregion
		
		// Calculate y differences
		var _ay = y2 - y1, _by = _y3 - _y4;
		
		#region Y Bbox Test
		
		// Set bounds
		if (_ay < 0)
		{
			_y1Low = y2;
			_y1High = y1;
		}
		else
		{
			_y1Low = y1;
			_y1High = y2;
		}
		
		// Check out of bounds
		if (_by > 0)
		{
			if (_y1High < _y4 || _y3 < _y1Low) return DONT_INTERSECT;
		}
		else
		{
			if (_y1High < _y3 || _y4 < _y1Low) return DONT_INTERSECT;
		}
		
		#endregion
		
		// Setup for numerator tests
		var _cx = x1 - _x3, _cy = y1 - _y3;
		
		// Both denominator
		var _denominator = _ay * _bx - _ax * _by;
		
		// Parallel
		if (_denominator == 0) return PARALLEL;
		
		// Alpha numerator
		var _alphaNumerator = _by * _cx - _bx * _cy;
		
		#region Alpha Numerator Test
		
		// Alpha test
		if (_denominator > 0)
		{
			if (_alphaNumerator < 0 || _alphaNumerator > _denominator) return DONT_INTERSECT;
		}
		else
		{
			if (_alphaNumerator > 0 || _alphaNumerator < _denominator) return DONT_INTERSECT;
		}
		
		#endregion
		
		// Beta numerator
		var _betaNumerator = _ax * _cy - _ay * _cx;
		
		#region Beta Numerator Test
		
		// Beta test
		if (_denominator > 0)
		{
			if (_betaNumerator < 0 || _betaNumerator > _denominator) return DONT_INTERSECT;
		}
		else
		{
			if (_betaNumerator > 0 || _betaNumerator < _denominator) return DONT_INTERSECT;
		}
		
		#endregion
		
		#region Calculate Intersection
		
		// If passed in a point
		if (is_struct(_point))
		{
			// X
			var _num = _alphaNumerator * _ax;
			var _offset = sign(_num) == sign(_denominator) ? _denominator * 0.5 : _denominator * -0.5;
			_point.x = x1 + (_num + _offset) / _denominator;
			
			// Y
			_num = _alphaNumerator * _ay;
			_offset = sign(_num) == sign(_denominator) ? _denominator * 0.5 : _denominator * -0.5;
			_point.y = y1 + (_num + _offset) / _denominator;
		}
		
		#endregion
		
		// Intersection
		return DO_INTERSECT;
	}
}