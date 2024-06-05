// Player
if (instance_exists(oPlayer))
{
	with (oPlayer)
	{
		// Rigid body
		rbDrawGui();
	
		// Player stats
		var _x = display_get_gui_width() - 16, _y = display_get_gui_height() - 16 * 10;
		draw_text(_x, _y, "Move input: " + string(inputMove));
		_y -= 16;
		draw_text(_x, _y, "Time: " + string(current_time / 1000 - oLevel.startTime));
		_y -= 16;
		draw_text(_x, _y, "FPS: " + string(fps_real));
		_y -= 16;
		draw_text(_x, _y, "State: " + string(oPlayer.currentAnimationStateName));
	}
}

// Grapher
if (instance_exists(oGrapher))
{
	draw_sprite_ext(sSquare, 0, display_get_gui_width() * 0.5, display_get_gui_height() * 0.5, 1, 1, 0, c_red, 1);
}