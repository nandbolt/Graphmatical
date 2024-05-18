/// @func	xToAxisX({Id.Instance} axes, {real} x);
/// @arg	{Id.Instance}	axes
/// @arg	{Real}			x
function xToAxisX(_axes, _x)
{
	return (_x - _axes.x) * INVERSE_TILE_SIZE;
}

/// @func	yToAxisY({Id.oAxes} axes, {real} y);
/// @arg	{Id.Instance}	axes
/// @arg	{Real}			y
function yToAxisY(_axes, _y)
{
	return (_y - _axes.y) * -INVERSE_TILE_SIZE;
}

/// @func	axisXtoX({Id.oAxes} axes, {real} axisX);
/// @arg	{Id.Instance}	axes
/// @arg	{Real}			axisX
function axisXtoX(_axes, _axisX)
{
	return _axisX * TILE_SIZE + _axes.x;
}

/// @func	axisYtoY({Id.oAxes} axes, {real} axisY);
/// @arg	{Id.Instance}	axes
/// @arg	{Real}			axisY
function axisYtoY(_axes, _axisY)
{
	return _axisY * -TILE_SIZE + _axes.y;
}