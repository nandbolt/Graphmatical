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

// If still no power
if (alarm[0] == -1)
{
	// Check graphs
	if (place_meeting(x, y, oAxes))
	{
		var _axes = instance_place(x, y, oAxes);
		if (_axes.material == GraphType.TUBE_POWERED || _axes.material == GraphType.DOTTED_TUBE_POWERED)
		{
			for (var _i = 0; _i < array_length(_axes.equations); _i++)
			{
				if (graphTouching(_axes.equations[_i], self.id))
				{
					toggleActive(true);
					break;
				}
			}
		}
	}
}

// Reset alarm
alarm[1] = powerCheckFrequency;