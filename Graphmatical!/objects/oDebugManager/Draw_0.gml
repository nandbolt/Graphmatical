// Player
if (instance_exists(oPlayer))
{
	with (oPlayer)
	{
		// Rigid body
		rbDraw();
		
		// Ground line
		draw_line(x, bbox_bottom, x, bbox_bottom + 2);
	}
}