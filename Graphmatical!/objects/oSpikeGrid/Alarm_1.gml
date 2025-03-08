/// @desc Power Source Timer

// Check for nearby power sources
var _inst = instance_nearest(x, y - 8, oCrystal);
if (instance_exists(_inst))
{
	var _isPowered = false;
	with (_inst)
	{
		_isPowered = isPowered();
	}
	if (_isPowered)
	{
		var _dist = distance_to_object(_inst);
		if (_dist <= _inst.powerRadius) toggleActive(true);
	}
}

// Reset alarm
alarm[1] = powerCheckFrequency;