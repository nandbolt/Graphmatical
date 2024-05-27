// GUI
baseGuiWidth = 640;
baseGuiHeight = 360;

// Canvas
baseSize = 512;
baseCanvasWidth = 1280;
baseCanvasHeight = 720;
canvasWidth = baseCanvasWidth;
canvasHeight = baseCanvasHeight;

// Camera
baseCamWidth = 320;
baseCamHeight = 180;

#region Functions

/// @func	browserScaleCanvas({int} baseWidth, {int} baseHeight, {int} currentWidth, {int} currentHeight, {bool} center);
browserScaleCanvas = function(_baseWidth, _baseHeight, _currentWidth, _currentHeight, _center)
{
	// Set window size
	var _aspect = _baseWidth / _baseHeight;
	if ((_currentWidth / _aspect) > _currentHeight) window_set_size(_currentHeight * _aspect, _currentHeight);
	else window_set_size(_currentWidth, _currentWidth / _aspect);
	
	// Set center
	if (_center) window_center();
	
	// Set viewport size
	var _viewWidth = min(window_get_width(), _baseWidth), _viewHeight = min(window_get_height(), _baseHeight);
	view_set_wport(0, _viewWidth);
	view_set_hport(0, _viewHeight);
	
	// Resize surface
	surface_resize(application_surface, _viewWidth, _viewHeight);
}

/// @func	browserCanvasFullscreen({int} base);
browserCanvasFullscreen = function(_base)
{
	// Set viewport
	view_set_wport(0, browser_width);
	view_set_hport(0, browser_height);
	window_set_size(browser_width, browser_height);
	window_center();
	
	// Set aspect
	var _aspect = browser_width / browser_height;
	var _vw, _vh;
	if (_aspect < 1)
	{
		_vw = _base * _aspect;
		_vh = _base;
		
		// Set gui size
		display_set_gui_size(baseGuiWidth, baseGuiWidth / _aspect);
	}
	else
	{
		_vw = _base;
		_vh = _base / _aspect;
		
		// Set gui size
		display_set_gui_size(baseGuiHeight * _aspect, baseGuiHeight);
	}
	
	// Resize surface
	camera_set_view_size(view_camera[0], _vw, _vh);
	if (instance_exists(oCamera))
	{
		with (oCamera)
		{
			camWidth = _vw;
			camHeight = _vh;
			halfCamWidth = _vw * 0.5;
			halfCamHeight = _vh * 0.5;
		}
	}
	surface_resize(application_surface, view_get_wport(0), view_get_hport(0));
}

#endregion

// Set font
draw_set_font(fDefault);

// Fullscreen
//if (os_browser != browser_not_a_browser) browserCanvasFullscreen(baseSize);