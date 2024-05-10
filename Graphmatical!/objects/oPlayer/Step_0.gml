// Update inputs
inputMove.x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
inputMove.y = keyboard_check(ord("S")) - keyboard_check(ord("W"));
inputJump = keyboard_check(vk_space);
inputJumpPressed = keyboard_check_pressed(vk_space);
inputCrouch = keyboard_check(ord("S"));

// Apply x velocity
var _xStrength = runStrength;
if (!grounded) _xStrength = driftStrength;
else if (inputCrouch) _xStrength = 0;
velocity.x += inputMove.x * _xStrength;

// Resistances
if (inputCrouch) groundConstant = slideGroundConstant;
else groundConstant = runGroundConstant;

#region Jump

// Set coyote jump
if (!grounded) coyoteBufferCounter = clamp(coyoteBufferCounter-1, 0, coyoteBuffer);
else coyoteBufferCounter = coyoteBuffer;

// Set jump buffer
if (inputJumpPressed && !inputCrouch) jumpBufferCounter = jumpBuffer;
else jumpBufferCounter = clamp(jumpBufferCounter-1, 0, jumpBuffer);

// Jump if initiated
if (jumpBufferCounter > 0 && (normal.x != 0 || normal.y != 0 || coyoteBufferCounter > 0)) jump();
else if (!grounded && !inputJump && velocity.y < 0) velocity.y += smallJumpStrength;

#endregion

// Rigid body
rbUpdate();

#region Animations

// Update image xscale based on x velocity
if (inputMove.x > 0) image_xscale = 1;
else image_xscale = -1;

// Neck
neckPosition.x = x + velocity.x;
neckPosition.y = y - 4 + velocity.y;

// Hip
hipPosition.x = x;
hipPosition.y = y - 1;

// Arm stride
if (grounded) armStrideCounter += abs(velocity.x) * 4;
if (velocity.x > 0)
{
	rightArm.flippedArm = false;
	leftArm.flippedArm = false;
	rightLeg.flippedArm = true;
	leftLeg.flippedArm = true;
}
else if (velocity.x < 0)
{
	rightArm.flippedArm = true;
	leftArm.flippedArm = true;
	rightLeg.flippedArm = false;
	leftLeg.flippedArm = false;
}
var _lerpAmount = clamp(abs(velocity.x), 0, 1);

// Right arm
rightArm.moveRoot(neckPosition.x, neckPosition.y);
rightArm.moveTarget(x + lerp(0, dsin(armStrideCounter) * 4 * sign(velocity.x), _lerpAmount) + velocity.x, y - clamp(abs(velocity.x), 0, 2));
rightArm.moveArm();

// Left arm
leftArm.moveRoot(neckPosition.x, neckPosition.y);
leftArm.moveTarget(x + lerp(0, dsin(armStrideCounter+180) * 4 * sign(velocity.x), _lerpAmount) + velocity.x, y - clamp(abs(velocity.x), 0, 2));
leftArm.moveArm();

// Right leg
rightLeg.moveRoot(hipPosition.x, hipPosition.y);
rightLeg.moveTarget(x + lerp(0, dsin(armStrideCounter) * 4 * sign(velocity.x), _lerpAmount), bbox_bottom);
rightLeg.moveArm();

// Left leg
leftLeg.moveRoot(hipPosition.x, hipPosition.y);
leftLeg.moveTarget(x + lerp(0, dsin(armStrideCounter+180) * 4 * sign(velocity.x), _lerpAmount), bbox_bottom);
leftLeg.moveArm();

//// If airborne
//if (!grounded)
//{
//	// If moving up
//	if (velocity.y < 0)
//	{
//		// Center jump
//		if (abs(velocity.x) < 0.5) sprite_index = sHumanJumpCenter;
//		// Jump
//		else sprite_index = sHumanJump;
//	}
//	// Fall
//	else sprite_index = sHumanFall;
//}
//else
//{
//	// If crouch input
//	if (inputCrouch)
//	{
//		// Crouch
//		if (abs(velocity.x) < 0.05) sprite_index = sHumanCrouch;
//		// Slide
//		else sprite_index = sHumanSlide;
//	}
//	// Run
//	else if (inputMove.x != 0) sprite_index = sHumanRun;
//	// Idle
//	else sprite_index = sHumanIdle;
//}

#endregion