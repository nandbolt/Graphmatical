// Fullscreen
if (keyboard_check_pressed(vk_f11))
{
	if (window_get_fullscreen())
	{
		// Untoggle fullscreen
		window_set_fullscreen(false);
		worleyWidth = baseCanvasWidth * 0.75;
		worleyHeight = baseCanvasHeight * 0.75;
		surface_resize(application_surface, baseCanvasWidth, baseCanvasHeight);
	}
	else
	{
		// Toggle fullscreen
		window_set_fullscreen(true);
		worleyWidth = display_get_width() * 0.75;
		worleyHeight = display_get_height() * 0.75;
		surface_resize(application_surface, display_get_width(), display_get_height());
	}
}

// If using a browser
if (os_browser != browser_not_a_browser)
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
	//if (browser_width != canvasWidth || browser_height != canvasHeight)
	//{
	//	// Scale canvas
	//	canvasWidth = browser_width;
	//	canvasHeight = browser_height;
	//	browserCanvasFullscreen(baseSize);
	//}
	
	#endregion
}