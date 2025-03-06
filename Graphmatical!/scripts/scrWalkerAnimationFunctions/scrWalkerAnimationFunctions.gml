/// @func	ikhWalkerInit();
///	@desc	Inits an inverse kinematic walker. This assumes it is also a rigid body, too.
function ikhWalkerInit()
{
	// Animation states
	currentAnimationState = WalkerAnimationState.IDLE;
	currentAnimationStateName = "Idle";
	currentAnimationFunc = ikhWalkerAnimIdle;
	animationCounter = 0;
	animationSpeed = 0.1;
	
	// Arms (general)
	armOffsetTop = 6;
	armOffsetSide = armOffsetTop * dcos(45);
	
	// Left arm
	leftArmOffset = new Vector2(armOffsetTop, -armOffsetTop);
	leftArmPos = new Vector2(x + leftArmOffset.x, y + leftArmOffset.y);
	leftArm = new Arm(leftArmPos.x, leftArmPos.y, 8, 8, 0, 0);
	leftArm.flippedArm = true;
	leftArm.color = #94B2A3;
	leftArm.armSprite = sRectRound1;
	
	// Right arm
	rightArmOffset = new Vector2(armOffsetTop, armOffsetTop);
	rightArmPos = new Vector2(x + rightArmOffset.x, y + rightArmOffset.y);
	rightArm = new Arm(rightArmPos.x, rightArmPos.y, 8, 8, 0, 0);
	rightArm.color = #94B2A3;
	rightArm.armSprite = sRectRound1;
	
	// Left leg
	leftLegOffset = new Vector2(armOffsetTop, -armOffsetTop);
	leftLegPos = new Vector2(x + leftLegOffset.x, y + leftLegOffset.y);
	leftLeg = new Arm(leftLegPos.x, leftLegPos.y, 8, 8, 0, 0);
	leftLeg.flippedArm = true;
	leftLeg.color = #94B2A3;
	leftLeg.armSprite = sRectRound1;
	
	// Right leg
	rightLegOffset = new Vector2(armOffsetTop, armOffsetTop);
	rightLegPos = new Vector2(x + rightLegOffset.x, y + rightLegOffset.y);
	rightLeg = new Arm(rightLegPos.x, rightLegPos.y, 8, 8, 0, 0);
	rightLeg.color = #94B2A3;
	rightLeg.armSprite = sRectRound1;
	
	// Arm lerps
	armLerpSpeed = 0.02;
	leftArmPrevOffset = new Vector2();
	leftArmGoalOffset = new Vector2();
	leftArmLerpAmnt = 0;
	rightArmPrevOffset = new Vector2();
	rightArmGoalOffset = new Vector2();
	rightArmLerpAmnt = 0;
	leftLegPrevOffset = new Vector2();
	leftLegGoalOffset = new Vector2();
	leftLegLerpAmnt = 0;
	rightLegPrevOffset = new Vector2();
	rightLegGoalOffset = new Vector2();
	rightLegLerpAmnt = 0;
}

/// @func	ikhWalkerCleanup();
function ikhWalkerCleanup()
{
	// Vectors
	delete leftArmOffset;
	delete leftArmPos;
	delete rightArmOffset;
	delete rightArmPos;
	delete leftLegOffset;
	delete leftLegPos;
	delete rightLegOffset;
	delete rightLegPos;
	
	// Arms
	leftArm.cleanup();
	delete leftArm;
	rightArm.cleanup();
	delete rightArm;
	leftLeg.cleanup();
	delete leftLeg;
	rightLeg.cleanup();
	delete rightLeg;
}

/// @func	ikhWalkerUpdate();
function ikhWalkerUpdate()
{
	// Update animation state
	ikhWalkerUpdateAnimState();

	// Update animation counter
	animationCounter += animationSpeed;
	
	// Run animation
	currentAnimationFunc();

	// Move roots
	leftArm.moveRoot(leftArmPos.x, leftArmPos.y);
	rightArm.moveRoot(rightArmPos.x, rightArmPos.y);
	leftLeg.moveRoot(leftLegPos.x, leftLegPos.y);
	rightLeg.moveRoot(rightLegPos.x, rightLegPos.y);

	// Move limbs
	leftArm.moveArm();
	rightArm.moveArm();
	leftLeg.moveArm();
	rightLeg.moveArm();
}

/// @func	ikhWalkerDraw();
function ikhWalkerDraw()
{
	// Back limbs
	if (imageAngle > -90 && imageAngle < 90)
	{
		image_yscale = 1;
		leftArm.color = #757C93;
		leftLeg.color = #757C93;
		leftArm.flippedArm = true;
		leftLeg.flippedArm = false;
		rightArm.flippedArm = true;
		rightLeg.flippedArm = false;
		leftArm.draw();
		leftLeg.draw();
	}
	else
	{
		image_yscale = -1;
		rightArm.color = #757C93;
		rightLeg.color = #757C93;
		leftArm.flippedArm = false;
		leftLeg.flippedArm = true;
		rightArm.flippedArm = false;
		rightLeg.flippedArm = true;
		rightArm.draw();
		rightLeg.draw();
	}
	
	// Inherit the parent event
	event_inherited();
	
	// Front limbs
	if (imageAngle > -90 && imageAngle < 90)
	{
		rightArm.color = #8B93AF;
		rightLeg.color = #8B93AF;
		rightArm.draw();
		rightLeg.draw();
	}
	else
	{
		leftArm.color = #8B93AF;
		leftLeg.color = #8B93AF;
		leftArm.draw();
		leftLeg.draw();
	}
}

/// @func	ikhWalkerDrawDebug();
function ikhWalkerDrawDebug()
{
	// Bones
	leftArm.drawDebug();
	rightArm.drawDebug();
	leftLeg.drawDebug();
	rightLeg.drawDebug();
	
	// State
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	draw_text_transformed(x, y - 20, "Anim: " + currentAnimationStateName, 0.5, 0.5, 0);
}

/// @func	ikhWalkerUpdateAnimState();
/// @desc	Updates the current animation state.
function ikhWalkerUpdateAnimState()
{
	if (nearGround)
	{
		// On entering crawl
		if (currentAnimationState != WalkerAnimationState.CRAWL) currentAnimationStateName = "Crawl";
			
		// Crawl
		currentAnimationState = WalkerAnimationState.CRAWL;
		currentAnimationFunc = ikhWalkerAnimCrawl;
	}
	else
	{
		// On entering fall
		if (currentAnimationState != WalkerAnimationState.FALL) currentAnimationStateName = "Fall";
			
		// Fall
		currentAnimationState = WalkerAnimationState.FALL;
		currentAnimationFunc = ikhWalkerAnimFall;
	}
}

/// @func	ikhWalkerAnimIdle();
/// @desc	Runs the idling animation (grounded, speed approx. zero).
function ikhWalkerAnimIdle()
{
}

/// @func	ikhWalkerAnimCrawl();
/// @desc	Runs the running animation (grounded, speed > zero).
function ikhWalkerAnimCrawl()
{
	#region Arm Offsets
	
	// Angles
	var _leftArmAngle, _rightArmAngle, _leftLegAngle, _rightLegAngle, _offset;
	if (nearGround)
	{
		// Side view
		sprite_index = sWalkerSide;
		_leftArmAngle = imageAngle;
		_rightArmAngle = imageAngle;
		_leftLegAngle = imageAngle + 180;
		_rightLegAngle = imageAngle + 180;
		_offset = armOffsetSide;
	}
	else
	{
		// Top view
		sprite_index = sWalker;
		_leftArmAngle = imageAngle + 45;
		_rightArmAngle = imageAngle - 45;
		_leftLegAngle = imageAngle + 135;
		_rightLegAngle = imageAngle - 135;
		_offset = armOffsetTop;
	}
	
	// Set offset
	leftArmOffset.set(lerp(leftArmOffset.x, lengthdir_x(_offset, _leftArmAngle), 0.1),
		lerp(leftArmOffset.y, lengthdir_y(_offset, _leftArmAngle), 0.1));
	rightArmOffset.set(lerp(rightArmOffset.x, lengthdir_x(_offset, _rightArmAngle), 0.1),
		lerp(rightArmOffset.y, lengthdir_y(_offset, _rightArmAngle), 0.1));
	leftLegOffset.set(lerp(leftLegOffset.x, lengthdir_x(_offset, _leftLegAngle), 0.1),
		lerp(leftLegOffset.y, lengthdir_y(_offset, _leftLegAngle), 0.1));
	rightLegOffset.set(lerp(rightLegOffset.x, lengthdir_x(_offset, _rightLegAngle), 0.1),
		lerp(rightLegOffset.y, lengthdir_y(_offset, _rightLegAngle), 0.1));
	
	#endregion
	
	#region Arm Targets
	
	// Right arm
	if (rightArmGoalOffset.getLength() == 0)
	{
		if (rightArm.getTargetDistance() > rightArm.rootArmLength + rightArm.elbowArmLength)
		{
			rightArmPrevOffset.set(rightArm.handPosition.x - rightArm.rootJoint.x, rightArm.handPosition.y - rightArm.rootJoint.y);
			if (imageAngle > -90 && imageAngle < 90) rightArmGoalOffset.set(bbox_right + 12 - rightArm.rootJoint.x, groundY - rightArm.rootJoint.y);
			else rightArmGoalOffset.set(bbox_left - 12 - rightArm.rootJoint.x, groundY - rightArm.rootJoint.y);
			rightArmLerpAmnt = 0;
		}
	}
	else
	{
		rightArmLerpAmnt += armLerpSpeed;
		var _x = lerp(rightArmPrevOffset.x, rightArmGoalOffset.x, rightArmLerpAmnt) + rightArm.rootJoint.x;
		var _y = lerp(rightArmPrevOffset.y, rightArmGoalOffset.y, rightArmLerpAmnt) + rightArm.rootJoint.y;
		rightArm.moveTarget(_x, _y);
		if (rightArmLerpAmnt >= 1) rightArmGoalOffset.set();
	}
	
	// Left arm
	if (leftArmGoalOffset.getLength() == 0)
	{
		if (leftArm.getTargetDistance() > leftArm.rootArmLength + leftArm.elbowArmLength)
		{
			leftArmPrevOffset.set(leftArm.handPosition.x - leftArm.rootJoint.x, leftArm.handPosition.y - leftArm.rootJoint.y);
			if (imageAngle > -90 && imageAngle < 90) leftArmGoalOffset.set(bbox_right + 12 - leftArm.rootJoint.x, groundY - leftArm.rootJoint.y);
			else leftArmGoalOffset.set(bbox_left - 12 - leftArm.rootJoint.x, groundY - leftArm.rootJoint.y);
			leftArmLerpAmnt = 0;
		}
	}
	else
	{
		leftArmLerpAmnt += armLerpSpeed;
		var _x = lerp(leftArmPrevOffset.x, leftArmGoalOffset.x, leftArmLerpAmnt) + leftArm.rootJoint.x;
		var _y = lerp(leftArmPrevOffset.y, leftArmGoalOffset.y, leftArmLerpAmnt) + leftArm.rootJoint.y;
		leftArm.moveTarget(_x, _y);
		if (leftArmLerpAmnt >= 1) leftArmGoalOffset.set();
	}
	
	// Right leg
	if (rightLegGoalOffset.getLength() == 0)
	{
		if (rightLeg.getTargetDistance() > rightLeg.rootArmLength + rightLeg.elbowArmLength)
		{
			rightLegPrevOffset.set(rightLeg.handPosition.x - rightLeg.rootJoint.x, rightLeg.handPosition.y - rightLeg.rootJoint.y);
			if (imageAngle > -90 && imageAngle < 90) rightLegGoalOffset.set(bbox_left + 12 - rightLeg.rootJoint.x, groundY - rightLeg.rootJoint.y);
			else rightLegGoalOffset.set(bbox_right - 12 - rightLeg.rootJoint.x, groundY - rightLeg.rootJoint.y);
			rightLegLerpAmnt = 0;
		}
	}
	else
	{
		rightLegLerpAmnt += armLerpSpeed;
		var _x = lerp(rightLegPrevOffset.x, rightLegGoalOffset.x, rightLegLerpAmnt) + rightLeg.rootJoint.x;
		var _y = lerp(rightLegPrevOffset.y, rightLegGoalOffset.y, rightLegLerpAmnt) + rightLeg.rootJoint.y;
		rightLeg.moveTarget(_x, _y);
		if (rightLegLerpAmnt >= 1) rightLegGoalOffset.set();
	}
	
	// Left leg
	if (leftLegGoalOffset.getLength() == 0)
	{
		if (leftLeg.getTargetDistance() > leftLeg.rootArmLength + leftLeg.elbowArmLength)
		{
			leftLegPrevOffset.set(leftLeg.handPosition.x - leftLeg.rootJoint.x, leftLeg.handPosition.y - leftLeg.rootJoint.y);
			if (imageAngle > -90 && imageAngle < 90) leftLegGoalOffset.set(bbox_left + 12 - leftLeg.rootJoint.x, groundY - leftLeg.rootJoint.y);
			else leftLegGoalOffset.set(bbox_right - 12 - leftLeg.rootJoint.x, groundY - leftLeg.rootJoint.y);
			leftLegLerpAmnt = 0;
		}
	}
	else
	{
		leftLegLerpAmnt += armLerpSpeed;
		var _x = lerp(leftLegPrevOffset.x, leftLegGoalOffset.x, leftLegLerpAmnt) + leftLeg.rootJoint.x;
		var _y = lerp(leftLegPrevOffset.y, leftLegGoalOffset.y, leftLegLerpAmnt) + leftLeg.rootJoint.y;
		leftLeg.moveTarget(_x, _y);
		if (leftLegLerpAmnt >= 1) leftLegGoalOffset.set();
	}
	
	#endregion
	
	// Move roots
	leftArmPos.set(x + leftArmOffset.x, y + leftArmOffset.y);
	rightArmPos.set(x + rightArmOffset.x, y + rightArmOffset.y);
	leftLegPos.set(x + leftLegOffset.x, y + leftLegOffset.y);
	rightLegPos.set(x + rightLegOffset.x, y + rightLegOffset.y);
}

/// @func	ikhWalkerAnimFall();
/// @desc	Runs the jumping animation (not grounded, moving down).
function ikhWalkerAnimFall()
{
	#region Arm Offsets
	
	// Top view
	sprite_index = sWalker;
	
	// Set offset
	leftArmOffset.set(lerp(leftArmOffset.x, lengthdir_x(armOffsetTop, imageAngle + 45), 0.1),
		lerp(leftArmOffset.y, lengthdir_y(armOffsetTop, imageAngle + 45), 0.1));
	rightArmOffset.set(lerp(rightArmOffset.x, lengthdir_x(armOffsetTop, imageAngle - 45), 0.1),
		lerp(rightArmOffset.y, lengthdir_y(armOffsetTop, imageAngle - 45), 0.1));
	leftLegOffset.set(lerp(leftLegOffset.x, lengthdir_x(armOffsetTop, imageAngle + 135), 0.1),
		lerp(leftLegOffset.y, lengthdir_y(armOffsetTop, imageAngle + 135), 0.1));
	rightLegOffset.set(lerp(rightLegOffset.x, lengthdir_x(armOffsetTop, imageAngle - 135), 0.1),
		lerp(rightLegOffset.y, lengthdir_y(armOffsetTop, imageAngle - 135), 0.1));
	
	#endregion
	
	#region Arm Targets
	
	// Move target to hand positions
	rightArm.moveTarget(rightArm.handPosition.x, rightArm.handPosition.y);
	leftArm.moveTarget(leftArm.handPosition.x, leftArm.handPosition.y);
	rightLeg.moveTarget(rightLeg.handPosition.x, rightLeg.handPosition.y);
	leftLeg.moveTarget(leftLeg.handPosition.x, leftLeg.handPosition.y);
	
	#endregion
	
	// Move roots
	leftArmPos.set(x + leftArmOffset.x, y + leftArmOffset.y);
	rightArmPos.set(x + rightArmOffset.x, y + rightArmOffset.y);
	leftLegPos.set(x + leftLegOffset.x, y + leftLegOffset.y);
	rightLegPos.set(x + rightLegOffset.x, y + rightLegOffset.y);
}