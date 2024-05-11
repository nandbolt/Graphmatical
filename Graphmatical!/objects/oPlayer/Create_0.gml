// States
debugMode = global.debugMode;

// Rigid body
rbInit();
//airConstant = 0.1;
//gravityStrength = 0.001;

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

// Arms
neckPosition = new Vector2(x, y - 4);
hipPosition = new Vector2(x, y);
rightArm = new Arm(neckPosition.x, neckPosition.y, 3, 3, -30, 30);
leftArm = new Arm(neckPosition.x, neckPosition.y, 3, 3, 210, 30);
rightLeg = new Arm(hipPosition.x, hipPosition.y, 4, 4, -45, -45);
leftLeg = new Arm(hipPosition.x, hipPosition.y, 4, 4, -90, -45);
rightLeg.flippedArm = true;
leftLeg.flippedArm = true;

// Animation states
currentAnimationState = HumanAnimationState.IDLE;
animationCounter = 0;
animationSpeed = 0.1;

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