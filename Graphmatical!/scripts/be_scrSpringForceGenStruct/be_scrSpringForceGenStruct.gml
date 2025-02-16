/// @func	BESpringForceGen();
/// @desc	A spring force generator. Applies the force of a spring to a box.
function BESpringForceGen(_otherBox=undefined, _springConstant=1, _restLength=16) : BEForceGen() constructor
{
	otherBox = _otherBox;
	springConstant = _springConstant;
	restLength = _restLength;
	
	/// @func	updateForce({Struct.BEBox} box, {real} dt);
	/// @desc	Applies spring forces to the box.
	static updateForce = function(_box, _dt)
	{
		// Calculate force direction
		var _p1 = _box.getPosition(), _p2 = otherBox.getPosition();
		var _force = new BEVector2(_p1.x - _p2.x, _p1.y - _p2.y);
		
		// Calculate force magnitude
		var _mag = _force.magnitude();
		_mag = abs(_mag - restLength);
		_mag *= springConstant;
		
		// Apply force
		_force.normalize();
		_force.scale(-_mag);
		_box.addForceVector(_force);
	}
}