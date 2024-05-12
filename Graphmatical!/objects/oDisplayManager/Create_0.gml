// GUI
baseGuiWidth = 640;
baseGuiHeight = 360;

// Canvas
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

#endregion

// Set font
draw_set_font(fDefault);