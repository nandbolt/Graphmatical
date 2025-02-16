/// @func	BEGravityForceGen({real} x, {real} y);
/// @desc	A gravity force generator. Applies the force of gravity.
function BEGravityForceGen(_x=0, _y=500) : BEForceGen() constructor
{
	// Gravity
	grav = new BEVector2(_x, _y);
	
	/// @func	updateForce({Struct.BEBox} box, {real} dt);
	/// @desc	Applies gravity to the box.
	static updateForce = function(_box, _dt)
	{
		// Return if infinite mass
		if (!_box.hasFiniteMass()) return;
		
		// Apply gravity
		_box.addForceVector(grav.getScaled(_box.getMass()));
	}
}