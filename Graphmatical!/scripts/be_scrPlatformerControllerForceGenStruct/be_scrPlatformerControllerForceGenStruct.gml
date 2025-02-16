/// @func	BEPlatformerControllerForceGen();
/// @desc	A platformer controller force generator. Applies the force of a controller pushing the box in a platformer.
function BEPlatformerControllerForceGen() : BEForceGen() constructor
{
	controllerInput = new BEVector2();
	moveStrength = 200;
	jumpStrength = 12000;
	collisionTiles = layer_tilemap_get_id("CollisionTiles");
	groundOffset = 4;
	
	/// @func	updateForce({Struct.BEBox} box, {real} dt);
	/// @desc	Applies controller forces to the box.
	static updateForce = function(_box, _dt)
	{
		// Update move input
		controllerInput.x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
		controllerInput.scale(moveStrength);
		
		// Update jump input
		if (keyboard_check_pressed(vk_space) && onGround(_box))
		{
			var _vel = _box.getVelocity();
			_box.setVelocity(_vel.x, 0);
			controllerInput.y = -jumpStrength;
		}
		else controllerInput.y = 0;
		
		// Apply controller
		_box.addForceVector(controllerInput);
	}
	
	/// @func	onGround({Struct.BEBox} box);
	/// @desc	Returns whether the box is touching the ground.
	static onGround = function(_box)
	{
		if (tilemap_get_at_pixel(collisionTiles, _box.owner.x, _box.owner.bbox_bottom+groundOffset) > 0) return true;
		with (_box.owner)
		{
			if (place_meeting(x, y+other.groundOffset, be_oBox)) return true;
		}
	}
}