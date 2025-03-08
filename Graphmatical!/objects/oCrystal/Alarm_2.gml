/// @desc Power Source Timer

// Check for nearby power sources
powerSource = noone;
if (active)
{
	var _min = 99999, _source = noone;
	for (var _i = 0; _i < array_length(potentialSources); _i++)
	{
		var _inst = instance_nearest(x, y - 8, potentialSources[_i]);
		if (instance_exists(_inst))
		{
			var _dist = point_distance(x, y - 8, _inst.x, _inst.y);
			if (_dist < _min)
			{
				// Found potential power source
				_min = _dist;
				_source = _inst;
			}
		}
	}
	if (instance_exists(_source) && _min <= powerRadius)
	{
		// Found power source
		powerSource = _source;
		togglePower(true);
		alarm[1] = residualPowerTime;
	}
}

// Reset alarm
alarm[2] = powerCheckFrequency;