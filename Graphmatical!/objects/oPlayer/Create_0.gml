// States
debugMode = global.debugMode;

// Rigid body
rbInit();

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

// Human joints
neckOffset = new Vector2(0, -4);
hipOffset = new Vector2(0, -1);
leftKneeOffset = new Vector2(-1, 2);
rightKneeOffset = new Vector2(1, 2);
leftFootOffset = new Vector2(-1, 6);
rightFootOffset = new Vector2(1, 6);
leftElbowOffset = new Vector2(-1, -3);
rightElbowOffset = new Vector2(1, -3);
leftHandOffset = new Vector2(-2, -1);
rightHandOffset = new Vector2(2, -1);

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

#endregion