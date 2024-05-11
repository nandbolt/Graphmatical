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

// Facing direction
if (velocity.x > 0) image_xscale = 1;
else if (velocity.x < 0) image_xscale = -1;

// Resolve animation state
if (grounded)
{
	if (abs(velocity.x) < 0.05)
	{
		if (inputCrouch)
		{
			// Crouch
			currentAnimationState = HumanAnimationState.CROUCH;
		}
		else
		{
			// Idle
			currentAnimationState = HumanAnimationState.IDLE;
			animationSpeed = 0.1;
		}
	}
	else
	{
		if (inputCrouch)
		{
			// Slide
			currentAnimationState = HumanAnimationState.SLIDE;
		}
		else
		{
			// Run
			currentAnimationState = HumanAnimationState.RUN;
			animationSpeed = 0.1;
		}
	}
}
else
{
	if (velocity.y > 0)
	{
		// Fall
		currentAnimationState = HumanAnimationState.FALL;
	}
	else
	{
		// Jump
		currentAnimationState = HumanAnimationState.JUMP;
	}
}

// Update animation counter
animationCounter += animationSpeed;

// Update targets
switch (currentAnimationState)
{
	case HumanAnimationState.IDLE:
		#region Idle
		// Facing direction
		if (image_xscale > 0)
		{
			// Arm targets
			rightArm.lerpTarget(x + 4, y-1, 0.2);
			leftArm.lerpTarget(x - 1, y, 0.2);
			
			// Orientation
			rightArm.flippedArm = false;
			leftArm.flippedArm = false;
			rightLeg.flippedArm = true;
			leftLeg.flippedArm = true;
		}
		else
		{
			// Arm targets
			rightArm.lerpTarget(x + 1, y, 0.2);
			leftArm.lerpTarget(x - 4, y-1, 0.2);
			
			// Orientation
			rightArm.flippedArm = true;
			leftArm.flippedArm = true;
			rightLeg.flippedArm = false;
			leftLeg.flippedArm = false;
		}
		
		// Leg targets
		rightLeg.targetPosition.y = lerp(rightLeg.targetPosition.y, bbox_bottom, 0.2);
		leftLeg.targetPosition.y = lerp(leftLeg.targetPosition.y, bbox_bottom, 0.2);
			
		// Neck + hip
		var _hover = sin(animationCounter) * 0.5;
		neckPosition.x = x;
		neckPosition.y = lerp(neckPosition.y, y - 4 + _hover, 0.5);
		hipPosition.x = x;
		hipPosition.y = lerp(hipPosition.y, y + _hover, 0.5);
		break;
		#endregion
	case HumanAnimationState.CROUCH:
		#region Crouch
		// Facing direction
		if (image_xscale > 0)
		{
			// Arm targets
			rightArm.lerpTarget(x + 1, y + 3, 0.2);
			leftArm.lerpTarget(x - 1, y + 3, 0.2);
			
			// Orientation
			rightArm.flippedArm = true;
			leftArm.flippedArm = false;
			rightLeg.flippedArm = true;
			leftLeg.flippedArm = false;
		}
		else
		{
			// Arm targets
			rightArm.lerpTarget(x + 1, y + 3, 0.2);
			leftArm.lerpTarget(x - 1, y + 3, 0.2);
			
			// Orientation
			rightArm.flippedArm = true;
			leftArm.flippedArm = false;
			rightLeg.flippedArm = true;
			leftLeg.flippedArm = false;
		}
		
		// Leg targets
		rightLeg.lerpTarget(x + 2, bbox_bottom, 0.2);
		leftLeg.lerpTarget(x - 2, bbox_bottom, 0.2);
			
		// Neck + hip
		neckPosition.x = x;
		neckPosition.y = lerp(neckPosition.y, y, 0.5);
		hipPosition.x = x;
		hipPosition.y = lerp(hipPosition.y, y + 4, 0.5);
		break;
		#endregion
	case HumanAnimationState.RUN:
		#region Run
		// Orientation
		if (image_xscale > 0)
		{
			rightArm.flippedArm = false;
			leftArm.flippedArm = false;
			rightLeg.flippedArm = true;
			leftLeg.flippedArm = true;
		}
		else
		{
			rightArm.flippedArm = true;
			leftArm.flippedArm = true;
			rightLeg.flippedArm = false;
			leftLeg.flippedArm = false;
		}
		
		// If right leg grounded
		var _tx = x, _ty = bbox_bottom;
		if (leftLeg.handPosition.y == bbox_bottom)
		{
			// If left leg too far
			if (point_distance(x, y, _tx, _ty) > leftLeg.rootArmLength + leftLeg.elbowArmLength)
			{
				// Plant right leg
				if (image_xscale > 0)
				{
					_tx = bbox_right + 2;
					_ty = bbox_bottom;
				}
				else
				{
					_tx = bbox_left - 2;
					_ty = bbox_bottom;
				}
			}
			
			// Move targets
			rightLeg.moveTarget(x + x - _tx, _ty - 1);
			leftLeg.moveTarget(_tx, _ty);
			rightArm.moveTarget(_tx, _ty - 6);
			leftArm.moveTarget(x + x - _tx, _ty - 7);
		}
		else
		{
			// Plant right leg
			_tx = rightLeg.targetPosition.x;
			_ty = bbox_bottom;
			
			// If right leg too far
			if (point_distance(x, y, _tx, _ty) > rightLeg.rootArmLength + rightLeg.elbowArmLength)
			{
				// Plant right leg
				if (image_xscale > 0)
				{
					_tx = bbox_right + 2;
					_ty = bbox_bottom;
				}
				else
				{
					_tx = bbox_left - 2;
					_ty = bbox_bottom;
				}
			}
			
			// Move targets
			rightLeg.moveTarget(_tx, _ty);
			leftLeg.moveTarget(x + x - _tx, _ty - 1);
			rightArm.moveTarget(x + x - _tx, _ty - 7);
			leftArm.moveTarget(_tx, _ty - 6);
		}
		
		// Neck + hip
		neckPosition.x = x;
		neckPosition.y = lerp(neckPosition.y, y - 4, 0.5);
		hipPosition.x = x;
		hipPosition.y = lerp(hipPosition.y, y, 0.5);
		break;
		#endregion
	case HumanAnimationState.SLIDE:
		#region Slide
		// Facing direction
		if (image_xscale > 0)
		{
			// Targets
			rightArm.moveTarget(x + 4, y + 3);
			leftArm.moveTarget(x - 2, y + 3);
			rightLeg.moveTarget(x + 8, bbox_bottom);
			leftLeg.moveTarget(x - 1, bbox_bottom);
			
			// Orientation
			rightArm.flippedArm = false;
			leftArm.flippedArm = false;
			rightLeg.flippedArm = true;
			leftLeg.flippedArm = false;
		}
		else
		{
			// Targets
			rightArm.moveTarget(x + 2, y + 3);
			leftArm.moveTarget(x - 4, y + 3);
			rightLeg.moveTarget(x + 1, bbox_bottom);
			leftLeg.moveTarget(x - 8, bbox_bottom);
			
			// Orientation
			rightArm.flippedArm = true;
			leftArm.flippedArm = true;
			rightLeg.flippedArm = true;
			leftLeg.flippedArm = false;
		}
			
		// Neck + hip
		neckPosition.x = x;
		neckPosition.y = lerp(neckPosition.y, y, 0.5);
		hipPosition.x = x;
		hipPosition.y = lerp(hipPosition.y, y + 4, 0.5);
		break;
		#endregion
	case HumanAnimationState.JUMP:
		#region Jump
		// Facing direction
		if (image_xscale > 0)
		{
			// Arm targets
			rightArm.moveTarget(x - 3, y + 1 - velocity.y);
			leftArm.moveTarget(x - 5, y - 1 - velocity.y);
			
			// Orientation
			rightArm.flippedArm = false;
			leftArm.flippedArm = false;
			rightLeg.flippedArm = true;
			leftLeg.flippedArm = true;
		}
		else
		{
			// Arm targets
			rightArm.moveTarget(x + 5, y - 1 - velocity.y);
			leftArm.moveTarget(x + 3, y + 1 - velocity.y);
			
			// Orientation
			rightArm.flippedArm = true;
			leftArm.flippedArm = true;
			rightLeg.flippedArm = false;
			leftLeg.flippedArm = false;
		}
		
		// Leg targets
		rightLeg.moveTarget(x - velocity.x + 2, bbox_bottom - velocity.y);
		leftLeg.moveTarget(x - velocity.x - 2, bbox_bottom - velocity.y);
			
		// Neck + hip
		neckPosition.x = x;
		neckPosition.y = lerp(neckPosition.y, y - 4, 0.75);
		hipPosition.x = x;
		hipPosition.y = lerp(hipPosition.y, y, 0.75);
		break;
		#endregion
	case HumanAnimationState.FALL:
		#region Fall
		// Y drag
		var _yDrag = clamp(velocity.y, 0, 1);
		
		// Facing direction
		if (image_xscale > 0)
		{
			// Arm targets
			rightArm.lerpTarget(x - 3, y + 1 - _yDrag, 0.5);
			leftArm.lerpTarget(x - 5, y - 1 - _yDrag, 0.5);
			
			// Orientation
			rightArm.flippedArm = false;
			leftArm.flippedArm = false;
			rightLeg.flippedArm = true;
			leftLeg.flippedArm = true;
		}
		else
		{
			// Arm targets
			rightArm.lerpTarget(x + 5, y - 1 - _yDrag, 0.5);
			leftArm.lerpTarget(x + 3, y + 1 - _yDrag, 0.5);
			
			// Orientation
			rightArm.flippedArm = true;
			leftArm.flippedArm = true;
			rightLeg.flippedArm = false;
			leftLeg.flippedArm = false;
		}
		
		// Leg targets
		rightLeg.lerpTarget(x + velocity.x + 2, bbox_bottom - _yDrag, 0.5);
		leftLeg.lerpTarget(x + velocity.x - 2, bbox_bottom - _yDrag, 0.5);
			
		// Neck + hip
		neckPosition.x = x;
		neckPosition.y = lerp(neckPosition.y, y - 4, 0.75);
		hipPosition.x = x;
		hipPosition.y = lerp(hipPosition.y, y, 0.75);
		break;
		#endregion
}

// Move roots
rightArm.moveRoot(neckPosition.x, neckPosition.y);
leftArm.moveRoot(neckPosition.x, neckPosition.y);
rightLeg.moveRoot(hipPosition.x, hipPosition.y);
leftLeg.moveRoot(hipPosition.x, hipPosition.y);

// Adjust target

// Move limbs
rightArm.moveArm();
leftArm.moveArm();
rightLeg.moveArm();
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