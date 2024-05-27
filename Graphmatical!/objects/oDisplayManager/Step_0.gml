// Fullscreen
if (keyboard_check_pressed(vk_f11))
{
	window_set_fullscreen(!window_get_fullscreen());
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