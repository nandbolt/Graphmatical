/// @func	BEBuoyancyForceGen();
/// @desc	A buoyancy force generator. Applies the force of a spring to a box.
function BEBuoyancyForceGen(_maxDepth=1, _volume=0, _waterHeight=136,_liquidDensity=10) : BEForceGen() constructor
{
	maxDepth = _maxDepth;
	volume = _volume;
	waterHeight = _waterHeight;
	liquidDensity = _liquidDensity;
	
	/// @func	updateForce({Struct.BEBox} box, {real} dt);
	/// @desc	Applies spring forces to the box.
	static updateForce = function(_box, _dt)
	{
		// Calculate submersion depth
		var _depth = _box.owner.y;
		maxDepth = (_box.owner.bbox_bottom - _box.owner.bbox_top) * 0.5;
		
		// Check if out of water
		if (_depth <= waterHeight + maxDepth) return;
		var _force = new BEVector2();
		volume = (_box.owner.bbox_right - _box.owner.bbox_left) * (_box.owner.bbox_bottom - _box.owner.bbox_top) * 0.0625;
		
		// Check if at max depth
		if (_depth <= waterHeight - maxDepth)
		{
			_force.y = -liquidDensity * volume;
			_box.addForceVector(_force);
			return;
		}
		
		// Otherwise partly submerged
		_force.y = -liquidDensity * volume * (_depth - maxDepth - waterHeight) / 2 * maxDepth;
		_box.addForceVector(_force);
	}
}