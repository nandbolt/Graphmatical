/// @func BEVector2({real} x, {real} y);
/// @desc A 2D vector used by the Box Engine. Becomes a zero vector if no input is given.
function BEVector2(_x=0, _y=0) constructor
{
	x = _x;
	y = _y;
	
	#region Setters/Getters
	
	// Set or get only.
	
	/// @func	getX();
	static getX = function(){ return x; }
	
	/// @func	setX({real} x);
	static setX = function(_x=0){ x = _x; }
	
	/// @func	getY();
	static getY = function(){ return y; }
	
	/// @func	setY({real} y);
	static setY = function(_y=0){ y = _y; }
	
	/// @func	set({real} x, {real} y);
	static set = function(_x=0, _y=0)
	{
		x = _x;
		y = _y;
	}
	
	/// @func	setVector({Struct.BEVector2} v);
	static setVector = function(_v)
	{
		x = _v.x;
		y = _v.y;
	}
	
	/// @func	getCopy();
	static	getCopy = function(){ return new BEVector2(x, y); }
	
	#endregion
	
	#region Properties
	
	// These functions return a property of the vector.
	
	/// @func	magnitude();
	/// @desc	Returns the length of the vector.
	static magnitude = function(){ return point_distance(0, 0, x, y); }
	
	/// @func	squareMagnitude();
	/// @desc	Returns the squared length of the vector.
	static squareMagnitude = function(){ return x * x + y * y; }
	
	/// @func	angleDegrees();
	/// @desc	Returns the angle of the vector in degrees (right = 0, down = 90, left = 180, up = 270);
	static angleDegrees = function(){ return point_direction(0, 0, x, y); }
	
	/// @func	toString();
	/// @dessc	Returns the string representation of the vector.
	static toString = function(){ return "(" + string(x) + "," + string(y) + ")"; }
	
	#endregion
	
	#region Applied Operations
	
	// These functions apply an operation to the vector.
	
	/// @func	invert();
	/// @desc	Flips the vector.
	static invert = function()
	{
		x = -x;
		y = -y;
	}
	
	/// @func	scale({real} scalar);
	/// @desc	Multiplies the vector's components by the given scalar.
	static scale = function(_scalar)
	{
		x *= _scalar;
		y *= _scalar;
	}
	
	/// @func	normalize();
	/// @desc	Sets the vector's length to 1, or leaves it as a zero vector.
	static normalize = function()
	{
		// Get length
		var _len = magnitude();
		
		// Normalize (divide vector by length) if not a zero vector
		if (_len > 0) scale(1 / _len);
	}
	
	/// @func	add({real} x, {real} y);
	/// @desc	Adds a vector to the vector.
	static add = function(_x, _y)
	{
		x += _x;
		y += _y;
	}
	
	/// @func	addVector({Struct.BEVector2} v);
	/// @desc	Adds a vector to the vector.
	static addVector = function(_v)
	{
		x += _v.x;
		y += _v.y;
	}
	
	/// @func	subtractVector({Struct.BEVector2} v);
	/// @desc	Subtracts a vector from the vector.
	static subtractVector = function(_v)
	{
		x -= _v.x;
		y -= _v.y;
	}
	
	/// @func	addScaled({real} x, {real} y, {real} scalar);
	/// @desc	Adds a scaled vector to the vector.
	static addScaled = function(_x, _y, _scalar)
	{
		x += _x * _scalar;
		y += _y * _scalar;
	}
	
	/// @func	addScaledVector({Struct.BEVector2} v, {real} scalar);
	/// @desc	Adds a scaled vector to the vector.
	static addScaledVector = function(_v, _scalar)
	{
		x += _v.x * _scalar;
		y += _v.y * _scalar;
	}
	
	#endregion
	
	#region Output Operations
	
	// These function output something after an operation (leaving the vector unchanged).
	
	/// @func	dotProduct({real} x, {real} y);
	/// @desc	Returns the dot product (x1 * x2 + y1 * y2) between two vectors.
	static dotProduct = function(_x, _y){ return dot_product(x, y, _x, _y); }
	
	/// @func	dotProductVector({Struct.BEVector2} v);
	/// @desc	Returns the dot product (x1 * x2 + y1 * y2) between two vectors.
	static dotProductVector = function(_v){ return dot_product(x, y, _v.x, _v.y); }
	
	/// @func	getScaled({real} scalar);
	/// @desc	Returns a scaled version of the vector.
	static getScaled = function(_scalar){ return new BEVector2(x * _scalar, y * _scalar); }
	
	/// @func	getSum({real} x, {real} y);
	/// @desc	Returns the sum of the vectors.
	static getSum = function(_x, _y){ return new BEVector2(x + _x, y + _y); }
	
	/// @func	getSumVector({Struct.BEVector2} v);
	/// @desc	Returns the sum of the vectors.
	static getSumVector = function(_v){ return new BEVector2(x + _v.x, y + _v.y); }
	
	#endregion
}