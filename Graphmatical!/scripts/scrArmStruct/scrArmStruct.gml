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
		//if (flippedArm)
		//{
		//	draw_sprite_ext(sDot, 0, rootJoint.x, rootJoint.y, rootArmLength, 1, rootAngle, c_aqua, 1);
		//	draw_sprite_ext(sDot, 0, elbowJoint.x, elbowJoint.y, elbowArmLength, 1, rootAngle + elbowAngle, c_yellow, 1);
		//}
		//else
		//{
		//	draw_sprite_ext(sDot, 0, rootJoint.x, rootJoint.y, rootArmLength, 1, rootAngle, c_aqua, 1);
		//	draw_sprite_ext(sDot, 0, elbowJoint.x, elbowJoint.y, elbowArmLength, 1, rootAngle + elbowAngle, c_yellow, 1);
		//}
		draw_set_color(c_red);
		draw_line(rootJoint.x - 1, rootJoint.y - 1, elbowJoint.x - 1, elbowJoint.y - 1);
		draw_line(elbowJoint.x - 1, elbowJoint.y - 1, handPosition.x - 1, handPosition.y - 1);
		draw_set_color(c_white);
		//draw_sprite(sDot, 0, elbowJoint.x-1, elbowJoint.y-1);
		//draw_set_color(c_lime);
		//draw_sprite(sDot, 0, targetPosition.x-1, targetPosition.y-1);
		//draw_set_color(c_white);
	}
}