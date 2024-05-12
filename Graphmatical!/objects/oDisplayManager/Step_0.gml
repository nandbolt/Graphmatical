// Fullscreen
if (keyboard_check_pressed(vk_f11))
{
	window_set_fullscreen(!window_get_fullscreen());
}

// Check if not on browser
if (os_browser == browser_not_a_browser)
{
	#region PC Scaling
	
	// Calculate aspect
	var _aspect = display_get_width() / display_get_height();

	// Adjust gui size
	if (_aspect > 1)
	{
		// Landscape
		display_set_gui_size(baseGuiHeight * _aspect, baseGuiHeight);
	}
	else
	{
		// Portrait
		display_set_gui_size(baseGuiWidth, baseGuiWidth / _aspect);
	}
	
	#endregion
}
else
{
	#region Browser Scaling
	
	// If browser dimensions changed
	if (browser_width != canvasWidth || browser_height != canvasHeight)
	{
		// Scale canvas
		canvasWidth = min(baseCanvasWidth, browser_width);
		canvasHeight = min(baseCanvasHeight, browser_height);
		browserScaleCanvas(baseCanvasWidth, baseCanvasHeight, canvasWidth, canvasHeight, true);
	}
	
	#endregion
}