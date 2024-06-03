/// @func	Arm(rootx, rooty, rootArmLength, elbowArmLength, rootAngle, elbowAngle);
/// @arg	{Real}	rootx			The root x position.
/// @arg	{Real}	rooty			The root y position.
/// @arg	{Real}	rootArmLength	The length from the root to the elbow.
/// @arg	{Real}	elbowArmLength	The length from the elbow to the hand.
/// @arg	{Real}	rootAngle		The angle from the root to the elbow.
/// @arg	{Real}	elbowAngle		The angle from the elbow to the hand (relative).
/// @desc	An inverse kinematic arm. The root == shoulder. The elbow angle is relative to the root's angle.
function Arm(_rootx, _rooty, _rootArmLength, _elbowArmLength, _rootAngle, _elbowAngle) constructor
{
	// Arms
	rootArmLength = _rootArmLength;
	elbowArmLength = _elbowArmLength;
	
	// Angles
	rootAngle = _rootAngle;
	elbowAngle = _elbowAngle;
	flippedArm = false;
	
	// Joints
	rootJoint = new Vector2(_rootx, _rooty);
	elbowJoint = new Vector2(_rootx + lengthdir_x(rootArmLength, rootAngle), _rooty + lengthdir_y(rootArmLength, rootAngle));
	handPosition = new Vector2(elbowJoint.x + lengthdir_x(elbowArmLength, rootAngle + elbowAngle), elbowJoint.y + lengthdir_y(elbowArmLength, rootAngle + elbowAngle));
	
	// Target
	targetPosition = new Vector2(handPosition.x, handPosition.y);
	
	// Color
	color = c_white;
	
	/// @func	moveRoot({real} x, {real} y);
	static moveRoot = function(_x, _y)
	{
		var _dx = _x - rootJoint.x, _dy = _y - rootJoint.y;
		rootJoint.add(_dx, _dy);
		elbowJoint.add(_dx, _dy);
		handPosition.add(_dx, _dy);
	}
	
	/// @func	moveTarget({real} x, {real} y);
	static moveTarget = function(_x, _y)
	{
		targetPosition.set(_x, _y);
	}
	
	/// @func	lerpTarget({real} x, {real} y, {real} amount);
	static lerpTarget = function(_x, _y, _amount)
	{
		moveTarget(lerp(targetPosition.x, _x, _amount), lerp(targetPosition.y, _y, _amount));
	}
	
	/// @func	moveArm();
	static moveArm = function()
	{
		// Calculate target distance
		var _targetDistance = point_distance(rootJoint.x, rootJoint.y, targetPosition.x, targetPosition.y);
		if (_targetDistance == 0) _targetDistance = 0.01;
		var _targetAngle = point_direction(rootJoint.x, rootJoint.y, targetPosition.x, targetPosition.y);
		
		// Set angles as the same if target is too far
		if (_targetDistance > rootArmLength + elbowArmLength)
		{
			// Set angles
			rootAngle = _targetAngle;
			elbowAngle = 0;
		}
		else
		{
			// Calculate angles
			var _cosAngle0 = ((_targetDistance * _targetDistance) + (rootArmLength * rootArmLength) - (elbowArmLength * elbowArmLength)) /
				(2 * _targetDistance * rootArmLength);
			var _angle0 = radtodeg(arccos(_cosAngle0));
			var _cosAngle1 = ((elbowArmLength * elbowArmLength) + (rootArmLength * rootArmLength) - (_targetDistance * _targetDistance)) /
				(2 * elbowArmLength * rootArmLength);
			var _angle1 = radtodeg(arccos(_cosAngle1));
			
			// Set angles
			rootAngle = _targetAngle - _angle0;
			elbowAngle = 180 - _angle1;
			if (flippedArm)
			{
				rootAngle = 2 * _targetAngle - rootAngle;
				elbowAngle *= -1;
			}
			
		}
		
		// Calculate joint positions
		elbowJoint.set(rootJoint.x + lengthdir_x(rootArmLength, rootAngle), rootJoint.y + lengthdir_y(rootArmLength, rootAngle));
		handPosition.set(elbowJoint.x + lengthdir_x(elbowArmLength, rootAngle + elbowAngle), elbowJoint.y + lengthdir_y(elbowArmLength, rootAngle + elbowAngle));
	}
	
	/// @func	cleanup();
	static cleanup = function()
	{
		delete rootJoint;
		delete elbowJoint;
		delete handPosition;
		delete targetPosition;
	}
	
	/// @func	draw();
	static draw = function()
	{
		// Arm 
		draw_sprite_ext(sSquare, 0, rootJoint.x, rootJoint.y, rootArmLength * 0.5, 0.5, rootAngle, color, 1);
		draw_sprite_ext(sSquare, 0, elbowJoint.x, elbowJoint.y, elbowArmLength * 0.5, 0.5, rootAngle + elbowAngle, color, 1);
	}
	
	/// @func	drawDebug();
	static drawDebug = function()
	{
		// Bones
		draw_set_color(c_red);
		draw_line(rootJoint.x - 1, rootJoint.y - 1, elbowJoint.x - 1, elbowJoint.y - 1);
		draw_set_color(c_orange);
		draw_line(elbowJoint.x - 1, elbowJoint.y - 1, handPosition.x - 1, handPosition.y - 1);
		
		// Targets
		draw_sprite_ext(sSquareCenter, 0, targetPosition.x, targetPosition.y, 0.5, 0.5, 0, c_red, 1);
		draw_set_color(c_white);
	}
}