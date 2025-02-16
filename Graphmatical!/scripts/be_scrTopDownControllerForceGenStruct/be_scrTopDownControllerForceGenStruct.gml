/// @func	BETopDownControllerForceGen();
/// @desc	A top down controller force generator. Applies the force of a controller pushing the box in 8 directions.
function BETopDownControllerForceGen() : BEForceGen() constructor
{
	controllerInput = new BEVector2();
	controllerStrength = 200;
	
	/// @func	updateForce({Struct.BEBox} box, {real} dt);
	/// @desc	Applies controller forces to the box.
	static updateForce = function(_box, _dt)
	{
		// Update controller input
		controllerInput.x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
		controllerInput.y = keyboard_check(ord("S")) - keyboard_check(ord("W"));
		controllerInput.normalize();
		controllerInput.scale(controllerStrength);
		
		// Apply controller
		_box.addForceVector(controllerInput);
	}
}