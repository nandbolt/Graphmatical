// Player
if (instance_exists(oPlayer))
{
	with (oPlayer)
	{
		// Rigid body
		rbDraw();
		
		// IKH
		ikhDrawDebug();
	}
}

// Walkers
if (instance_exists(oWalker))
{
	with (oWalker)
	{
		// Rigid body
		rbDraw();
		
		// IKH
		ikhWalkerDrawDebug();
		
		// Near ground
		if (nearGround)
		{
			draw_sprite(sSquareCenter, 0, x, nearGroundGoalYMin);
			draw_sprite(sSquareCenter, 0, x, nearGroundGoalYMax);
			draw_sprite(sSquareCenter, 0, x, groundY);
		}
	}
}