/// @desc	Init player

// States
canMove = true;

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
inputEditorPressed = false;

// Movement
runStrength = 0.2;

// Jumping
jumpForce = new Vector2();
jumpStrength = 3;
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
	jumpForce.x = 0;
	jumpForce.y = -jumpStrength;
	
	// Apply jump
	velocity.x += jumpForce.x;
	velocity.y += jumpForce.y;
	
	// Reset counters
	jumpBufferCounter = 0;
	coyoteBufferCounter = 0;
	grounded = false;
}

/// @func	resetMoveInputs();
resetMoveInputs = function()
{
	inputMove.x = 0;
	inputMove.y = 0;
	inputJump = false;
	inputJumpPressed = false;
	inputCrouch = false;
}

#endregion