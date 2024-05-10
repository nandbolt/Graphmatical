// Rigid body
if (debugMode)
{
	rbDrawGui();
	
	// Player stats
	var _x = 16, _y = display_get_gui_height() * 0.5;
	draw_text(_x, _y, "More player info: ");
	_y += 16;
	draw_text(_x, _y, "Move input: " + string(inputMove));
	_y += 16;
	draw_text(_x, _y, "Coyote: " + string(coyoteBufferCounter));
	_y += 16;
	draw_text(_x, _y, "Jump buffer: " + string(jumpBufferCounter));
	_y += 16;
}