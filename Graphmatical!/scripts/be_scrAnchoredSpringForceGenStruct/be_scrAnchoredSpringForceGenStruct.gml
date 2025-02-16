/// @func	BEAnchoredSpringForceGen({real} anchorX, {real} anchorY, {real} springConstant, {real} restLength);
/// @desc	An anchored spring force generator. Applies the force of an anchored spring to a box.
function BEAnchoredSpringForceGen(_anchorX, _anchorY, _springConstant=1, _restLength=16) : BEForceGen() constructor
{
	anchorX = _anchorX;
	anchorY  = _anchorY;
	springConstant = _springConstant;
	restLength = _restLength;
	
	/// @func	updateForce({Struct.BEBox} box, {real} dt);
	/// @desc	Applies spring forces to the box.
	static updateForce = function(_box, _dt)
	{
		// Calculate force direction
		var _boxPosition = _box.getPosition();
		var _force = new BEVector2(_boxPosition.x - anchorX, _boxPosition.y - anchorY);
		
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