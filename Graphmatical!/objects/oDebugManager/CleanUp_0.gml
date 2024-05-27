// Hide collision tiles
layer_set_visible(collisionLayer, false);

// Overlay
show_debug_overlay(false);

// Axes
if (instance_exists(oAxes))
{
	with (oAxes)
	{
		bboxVisible = false;
	}
}