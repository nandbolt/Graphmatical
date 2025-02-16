/// @func	BEForceGen();
/// @desc	A force generator which adds forces to boxes that they are 'registered' with. This is an
///			interface, meaning only inherited force generators will be instanced (not this base class).
function BEForceGen() constructor
{
	/// @func	updateForce({Struct.BEBox} box, {real} dt);
	/// @desc	Applies the force generator to the box with the given time. Should be overwritten in
	///			an inherited force generator.
	static updateForce = function(_box, _dt){}
}