// Axes
if (instance_exists(oAxes))
{
	with (oAxes)
	{
		bboxVisible = true;
	}
}

// Obstacle
if (instance_exists(oObstacle))
{
	with (oObstacle)
	{
		// Collider
		draw_sprite_pos(sSquare, 0, bbox_left, bbox_top, bbox_right, bbox_top, bbox_right, bbox_bottom, bbox_left, bbox_bottom, 0.25);
	}
}

// Flags
if (instance_exists(oFlag))
{
	with (oFlag)
	{
		// Collider
		draw_sprite_pos(sSquare, 0, bbox_left, bbox_top, bbox_right, bbox_top, bbox_right, bbox_bottom, bbox_left, bbox_bottom, 0.25);
	}
}

// Tiler
if (instance_exists(oTiler))
{
	with (oTiler)
	{
		// Collider
		draw_sprite_pos(sSquare, 0, bbox_left, bbox_top, bbox_right, bbox_top, bbox_right, bbox_bottom, bbox_left, bbox_bottom, 0.25);
	}
}