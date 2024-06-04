/// @desc	Init player

// States
canMove = true;

// Rigid body
rbInit();

// IKH
ikhInit();

// Inputs
inputMove = new Vector2();
inputJump = false;
inputJumpPressed = false;
inputCrouch = false;

// Movement
runStrength = 0.15;

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
runGroundConstant = 0.1;
slideGroundConstant = 0.02;

// Editor
inputEditorPressed = false;
currentEditor = oGrapher;

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
	
	// Jump sfx
	audio_play_sound(sfxJump, 2, false);
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

/// @func	die();
die = function()
{
	// Respawn
	with (oWorld)
	{
		respawnPlayer();
	}

	// Hurt sound
	audio_play_sound(sfxHurt, 2, false);

	// Destroy self
	instance_destroy();
}

#endregion