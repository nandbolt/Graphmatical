// Rigid body
rbInit();
//airConstant = 2;
//gravityStrength = 0.001;

// IKH
ikhInit();

// Inputs
inputMove = new Vector2();
inputJump = false;
inputJumpPressed = false;
inputCrouch = false;

// Movement
runStrength = 0.2;

// Jumping
jumpForce = new Vector2();
jumpStrength = 3;
wallJumpStrength = 2;
driftStrength = 0.05;
jumpBuffer = 10;
jumpBufferCounter = 0;
coyoteBuffer = 10;
coyoteBufferCounter = 0;
smallJumpStrength = 0.1;

// Resistances
runGroundConstant = 0.15;
slideGroundConstant = 0.02;

#region Functions

/// @func	jump();
jump = function()
{
	// Calculate jump
	var _jumpStrength = jumpStrength;
	if (grounded || coyoteBufferCounter > 0)
	{
		// Ground jump
		jumpForce.x = normal.x;
		jumpForce.y = normal.y;
	}
	else
	{
		// Wall/cieling jump
		_jumpStrength = wallJumpStrength;
		jumpForce.x = normal.x;
		if (inputMove.x != normal.x && inputMove.x != 0) jumpForce.y = normal.y - 1;
		else jumpForce.y = normal.y + inputMove.y;
	}
	jumpForce.normalize();
	jumpForce.multiplyByScalar(_jumpStrength);
	
	// Apply jump
	velocity.x += jumpForce.x;
	velocity.y += jumpForce.y;
	
	// Reset counters
	jumpBufferCounter = 0;
	coyoteBufferCounter = 0;
	grounded = false;
}

/// @func	onPassableFloor();
/// @desc	Returns if on a floor that can be passed through using the jump button.
onPassableFloor = function()
{
	return false;
}

#endregion