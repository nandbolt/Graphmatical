/// @func	ikhInit();
///	@desc	Inits an inverse kinematic human. This assumes it is also a rigid body, too.
function ikhInit()
{
	// Animation states
	currentAnimationState = HumanAnimationState.IDLE;
	currentAnimationFunc = ikhAnimIdle;
	animationCounter = 0;
	animationSpeed = 0.1;
	
	// Root positions
	neckPosition = new Vector2(x, y - 4);
	hipPosition = new Vector2(x, y);
	
	// Arms
	rightArm = new Arm(neckPosition.x, neckPosition.y, 3, 3, -30, 30);
	leftArm = new Arm(neckPosition.x, neckPosition.y, 3, 3, 210, 30);
	leftArm.color = #b3b9d1;
	
	// Legs
	rightLeg = new Arm(hipPosition.x, hipPosition.y, 4, 4, -45, -45);
	leftLeg = new Arm(hipPosition.x, hipPosition.y, 4, 4, -90, -45);
	rightLeg.flippedArm = true;
	leftLeg.flippedArm = true;
	leftLeg.color = #b3b9d1;
}

/// @func	ikhCleanup();
function ikhCleanup()
{
	// Vectors
	delete neckPosition;
	delete hipPosition;
	
	// Arms
	rightArm.cleanup();
	leftArm.cleanup();
	rightLeg.cleanup();
	leftLeg.cleanup();
}

/// @func	ikhUpdate();
function ikhUpdate()
{
	// Facing direction
	if (velocity.x > 0) image_xscale = 1;
	else if (velocity.x < 0) image_xscale = -1;

	// Update animation state
	ikhUpdateAnimState();

	// Update animation counter
	animationCounter += animationSpeed;
	
	// Run animation
	currentAnimationFunc();

	// Move roots
	rightArm.moveRoot(neckPosition.x, neckPosition.y);
	leftArm.moveRoot(neckPosition.x, neckPosition.y);
	rightLeg.moveRoot(hipPosition.x, hipPosition.y);
	leftLeg.moveRoot(hipPosition.x, hipPosition.y);

	// Move limbs
	rightArm.moveArm();
	leftArm.moveArm();
	rightLeg.moveArm();
	leftLeg.moveArm();
}

/// @func	ikhDraw();
function ikhDraw()
{
	// Head
	draw_sprite(sHumanHead, 0, neckPosition.x, neckPosition.y);
	
	// If looking right
	if (image_xscale > 0)
	{
		// Left side is back
		leftArm.color = #b3b9d1;
		leftLeg.color = #b3b9d1;
		leftArm.draw();
		leftLeg.draw();
	}
	else
	{
		// Right side is back
		rightArm.color = #b3b9d1;
		rightLeg.color = #b3b9d1;
		rightArm.draw();
		rightLeg.draw();
	}

	// Body
	var _bodyLength = point_distance(neckPosition.x, neckPosition.y, hipPosition.x, hipPosition.y);
	var _bodyAngle = point_direction(neckPosition.x, neckPosition.y, hipPosition.x, hipPosition.y);
	draw_sprite_ext(sSquare, 0, neckPosition.x, neckPosition.y, _bodyLength * 0.5, 0.5, _bodyAngle, #dae0ea, 1);
	
	// If looking right
	if (image_xscale > 0)
	{
		// Left side is front
		rightArm.color = c_white;
		rightLeg.color = c_white;
		rightLeg.draw();
		rightArm.draw();
	}
	else
	{
		// Right side is front
		leftArm.color = c_white;
		leftLeg.color = c_white;
		leftLeg.draw();
		leftArm.draw();
	}
}

/// @func	ikhDrawDebug();
function ikhDrawDebug()
{
	// Bones
	rightLeg.drawDebug();
	rightArm.drawDebug();
	leftLeg.drawDebug();
	leftArm.drawDebug();
}

/// @func	ikhUpdateAnimState();
/// @desc	Updates the current animation state.
function ikhUpdateAnimState()
{
	if (grounded)
	{
		if (abs(velocity.x) < 0.05)
		{
			if (inputCrouch)
			{
				// Crouch
				currentAnimationState = HumanAnimationState.CROUCH;
				currentAnimationFunc = ikhAnimCrouch;
			}
			else
			{
				// Idle
				currentAnimationState = HumanAnimationState.IDLE;
				animationSpeed = 0.1;
				currentAnimationFunc = ikhAnimIdle;
			}
		}
		else
		{
			if (inputCrouch)
			{
				// Slide
				currentAnimationState = HumanAnimationState.SLIDE;
				currentAnimationFunc = ikhAnimSlide;
			}
			else
			{
				// Run
				currentAnimationState = HumanAnimationState.RUN;
				animationSpeed = 0.1;
				currentAnimationFunc = ikhAnimRun;
			}
		}
	}
	else
	{
		if (velocity.y > 0)
		{
			// Fall
			currentAnimationState = HumanAnimationState.FALL;
			currentAnimationFunc = ikhAnimFall;
		}
		else
		{
			// Jump
			currentAnimationState = HumanAnimationState.JUMP;
			currentAnimationFunc = ikhAnimJump;
		}
	}
}

/// @func	ikhAnimIdle();
/// @desc	Runs the idling animation (grounded, speed approx. zero).
function ikhAnimIdle()
{
	// Facing direction
	if (image_xscale > 0)
	{
		// Arm targets
		leftArm.lerpTarget(x + 4, y-1, 0.2);
		rightArm.lerpTarget(x - 1, y, 0.2);
			
		// Orientation
		rightArm.flippedArm = false;
		leftArm.flippedArm = false;
		rightLeg.flippedArm = true;
		leftLeg.flippedArm = true;
	}
	else
	{
		// Arm targets
		leftArm.lerpTarget(x + 1, y, 0.2);
		rightArm.lerpTarget(x - 4, y-1, 0.2);
			
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
}

/// @func	ikhAnimCrouch();
/// @desc	Runs the crouching animation (grounded, speed approx. zero, input crouch).
function ikhAnimCrouch()
{
	// Facing direction
	if (image_xscale > 0)
	{
		// Arm targets
		leftArm.lerpTarget(x + 4, y + 1, 0.2);
		rightArm.lerpTarget(x - 1, y + 3, 0.2);
			
		// Orientation
		rightArm.flippedArm = false;
		leftArm.flippedArm = false;
		rightLeg.flippedArm = true;
		leftLeg.flippedArm = true;
	}
	else
	{
		// Arm targets
		leftArm.lerpTarget(x + 1, y + 3, 0.2);
		rightArm.lerpTarget(x - 4, y + 1, 0.2);
			
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
	neckPosition.y = lerp(neckPosition.y, y + _hover, 0.5);
	hipPosition.x = x;
	hipPosition.y = lerp(hipPosition.y, y + 4 + _hover, 0.5);
}

/// @func	ikhAnimRun();
/// @desc	Runs the running animation (grounded, speed > zero).
function ikhAnimRun()
{
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
		
	// If left leg grounded
	if (leftLeg.handPosition.y == bbox_bottom)
	{
		// Plant left leg
		var _tx = leftLeg.targetPosition.x;
		var _ty = bbox_bottom;
			
		// If left leg too far
		if (point_distance(x, y, _tx, _ty) > leftLeg.rootArmLength + leftLeg.elbowArmLength)
		{
			// If moving right
			if (image_xscale > 0)
			{
				// Plant right leg forward right
				_tx = bbox_right + 3;
				_ty = bbox_bottom;
			}
			else
			{
				// Plant right leg forward left
				_tx = bbox_left - 3;
				_ty = bbox_bottom;
			}
				
			// Get target displacement
			var _tdx = x - _tx;
			
			// Move leg targets
			rightLeg.moveTarget(_tx, _ty);
			leftLeg.moveTarget(x + _tdx, _ty - 2);
			
			// Move arm targets
			rightArm.lerpTarget(_tx, _ty - 8 + _tdx * 0.1, 0.8);
			leftArm.lerpTarget(x + _tdx, _ty - 7 - _tdx * 0.1, 0.8);
		}
		else
		{
			// Get target displacement
			var _tdx = x - _tx;
			
			// Move leg targets
			rightLeg.moveTarget(x + _tdx, _ty - 2);
			leftLeg.moveTarget(_tx, _ty);
			
			// Move arm targets
			rightArm.lerpTarget(_tx, _ty - 8 + _tdx * 0.1, 0.8);
			leftArm.lerpTarget(x + _tdx, _ty - 7 - _tdx * 0.1, 0.8);
		}
	}
	else
	{
		// Plant right leg
		var _tx = rightLeg.targetPosition.x;
		var _ty = bbox_bottom;
			
		// If right leg too far (e.g. behind)
		if (point_distance(x, y, _tx, _ty) > rightLeg.rootArmLength + rightLeg.elbowArmLength)
		{
			// If moving right
			if (image_xscale > 0)
			{
				// Plant left leg forward right
				_tx = bbox_right + 3;
				_ty = bbox_bottom;
			}
			else
			{
				// Plant left leg forward left
				_tx = bbox_left - 3;
				_ty = bbox_bottom;
			}
				
			// Get target displacement
			var _tdx = x - _tx;
			
			// Move leg targets
			rightLeg.moveTarget(x + _tdx, _ty - 2);
			leftLeg.moveTarget(_tx, _ty);
			
			// Move arm targets
			rightArm.lerpTarget(x + _tdx, _ty - 7 - _tdx * 0.1, 0.8);
			leftArm.lerpTarget(_tx, _ty - 8 + _tdx * 0.1, 0.8);
		}
		else
		{
			// Get target displacement
			var _tdx = x - _tx;
			
			// Move leg targets
			rightLeg.moveTarget(_tx, _ty);
			leftLeg.moveTarget(x + _tdx, _ty - 2);
			
			// Move arm targets
			rightArm.lerpTarget(x + _tdx, _ty - 7 - _tdx * 0.1, 0.8);
			leftArm.lerpTarget(_tx, _ty - 8 + _tdx * 0.1, 0.8);
		}
	}
		
	// Neck + hip
	neckPosition.x = x;
	neckPosition.y = lerp(neckPosition.y, y - 4, 0.5);
	hipPosition.x = x;
	hipPosition.y = lerp(hipPosition.y, y, 0.5);
}

/// @func	ikhAnimSlide();
/// @desc	Runs the sliding animation (grounded, speed > zero, input crouch).
function ikhAnimSlide()
{
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
}

/// @func	ikhAnimJump();
/// @desc	Runs the jumping animation (not grounded, moving up).
function ikhAnimJump()
{
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
}

/// @func	ikhAnimFall();
/// @desc	Runs the jumping animation (not grounded, moving down).
function ikhAnimFall()
{
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
}