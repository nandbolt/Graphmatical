/// @func	Vector2({real} x, {real} y);
/// @desc	A 2D vector with an x and y component.
function Vector2(_x=0, _y=0) constructor
{
	x = _x;
	y = _y;
	
	/// @func	set({real} x, {real} y);
	///	@desc	Sets the vector's components.
	static set = function(_x=0, _y=0)
	{
		x = _x;
		y = _y;
	}
	
	/// @func	setVector({Vector2} other);
	///	@desc	Sets the vector's components.
	static setVector = function(_other)
	{
		set(_other.x, _other.y);
	}
	
	/// @func	setNormal({real} x, {real} y);
	///	@desc	Sets the vector's components and normalizes it.
	static setNormal = function(_x, _y)
	{
		set(_x, _y);
		normalize();
	}
	
	/// @func	setNormalVector({Vector2} other);
	///	@desc	Sets the vector's components and normalizes it.
	static setNormalVector = function(_other)
	{
		setNormal(_other.x, _other.y);
	}
	
	/// @func	setLength({real} x, {real} y, {real} scalar);
	///	@desc	Sets the vector's components, normalizes and scales it.
	static setLength = function(_x, _y, _scalar)
	{
		setNormal(_x, _y);
		scale(_scalar);
	}
	
	/// @func	setLengthVector({Vector2} other, {real} scalar);
	///	@desc	Sets the vector's components, normalizes and scales it.
	static setLengthVector = function(_other, _scalar)
	{
		setLength(_other.x, _other.y, _scalar);
	}
	
	/// @func	add({real} x, {real} y);
	/// @desc	Adds to vector components.
	static add = function(_x, _y)
	{
		x += _x;
		y += _y;
	}
	
	/// @func	addVector({Vector2} other);
	/// @desc	Adds to vector components.
	static addVector = function(_other)
	{
		add(_other.x, _other.y);
	}
	
	/// @func	addResistance({real} rx, {real} ry);
	/// @desc	Adds a resistance to the vector, preventing an overshoot.
	static addResistance = function(_rx, _ry)
	{
		// Set to zero if resistance is bigger
		if (sqrt(_rx * _rx + _ry * _ry) > getLength()) set();
		// Else add resistance
		else add(_rx, _ry);
	}
	
	/// @func	addResistanceVector({Vector2} resistance);
	/// @desc	Adds a resistance to the vector, preventing an overshoot.
	static addResistanceVector = function(_resistance)
	{
		addResistance(_resistance.x, _resistance.y);
	}
	
	/// @func	isZero();
	///	@desc	Returns if the vector is zero in length.
	static isZero = function()
	{
		return (x == 0 && y == 0);
	}
	
	/// @func	scale({real} scalar);
	/// @desc	Multiplies each vector's components by the given scalar.
	static scale = function(_scalar)
	{
		x *= _scalar;
		y *= _scalar;
	}
	
	/// @func	getLength();
	/// @desc	Returns the vector's length using the Pythagorean theorem.
	static getLength = function()
	{
		return sqrt(x * x + y * y);
	}
	
	/// @func	normalize();
	/// @desc	Sets the vector's length to 1, or keeps it as a zero vector.
	static normalize = function()
	{
		// Return is zero vector
		if (x == 0 && y == 0) return;
		
		// Multiply by inverse length
		scale(1 / getLength());
	}
	
	/// @func	getAngleDegrees();
	/// @desc	Returns the angle (in degrees) of the vector using the point_direction function.
	static getAngleDegrees = function()
	{
		return point_direction(0, 0, x, y);
	}
	
	/// @func	rotateDegrees({real} angle);
	/// @desc	Rotates the vector by the given angle (in degrees).
	static rotateDegrees = function(_angle)
	{
		// Store length
		var _length = getLength();
		
		// Get new angle
		var _newAngle = getAngleDegrees() + _angle;
		
		// Set to new vector
		x = lengthdir_x(_length, _newAngle);
		y = lengthdir_y(_length, _newAngle);
	}
	
	/// @func	dotWithVector({Vector2} other);
	static dotWithVector = function(_other)
	{
		return x * _other.x + y * _other.y;
	}
	
	/// @func	toString();
	/// @desc	Returns the vector's x and y components as a string.
	static toString = function()
	{
		return "(" + string(x) + ", " + string(y) + ")";
	}
}