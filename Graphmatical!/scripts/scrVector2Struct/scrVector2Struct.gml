/// @func	Vector2({real} x, {real} y);
/// @desc	A 2D vector with an x and y component.
function Vector2(_x=0, _y=0) constructor
{
	x = _x;
	y = _y;
	
	/// @func	multiplyByScalar({real} scalar);
	/// @desc	Multiplies each vector's components by the given scalar.
	static multiplyByScalar = function(_scalar)
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
		multiplyByScalar(1 / getLength());
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
		// Return is zero vector
		if (x == 0 && y == 0) return;
		
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