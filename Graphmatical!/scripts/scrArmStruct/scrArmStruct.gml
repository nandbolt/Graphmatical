/// @func	Arm({real} rootx, {real} rooty, {real} rootArmLength, {real} elbowArmLength, {real} rootAngle, {real} elbowAngle);
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
	targetPosition = new Vector2();
	
	/// @func	moveRoot({real} x, {real} y);
	static moveRoot = function(_x, _y)
	{
		var _dx = _x - rootJoint.x, _dy = _y - rootJoint.y;
		rootJoint.x += _dx;
		rootJoint.y += _dy;
		elbowJoint.x += _dx;
		elbowJoint.y += _dy;
		handPosition.x += _dx;
		handPosition.y += _dy;
	}
	
	/// @func	moveTarget({real} x, {real} y);
	static moveTarget = function(_x, _y)
	{
		targetPosition.x = _x;
		targetPosition.y = _y;
	}
	
	/// @func	moveArm();
	static moveArm = function()
	{
		// Calculate target distance
		var _targetDistance = point_distance(rootJoint.x, rootJoint.y, targetPosition.x, targetPosition.y);
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
		elbowJoint.x = rootJoint.x + lengthdir_x(rootArmLength, rootAngle);
		elbowJoint.y = rootJoint.y + lengthdir_y(rootArmLength, rootAngle);
		handPosition.x = elbowJoint.x + lengthdir_x(elbowArmLength, rootAngle + elbowAngle);
		handPosition.y = elbowJoint.y + lengthdir_y(elbowArmLength, rootAngle + elbowAngle);
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
		draw_line(rootJoint.x - 1, rootJoint.y - 1, elbowJoint.x - 1, elbowJoint.y - 1);
		draw_line(elbowJoint.x - 1, elbowJoint.y - 1, handPosition.x - 1, handPosition.y - 1);
		//draw_sprite(sSquare, 0, targetPosition.x, targetPosition.y);
	}
}