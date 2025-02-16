/// @func	BEBoxSpringForceGen();
/// @desc	A box spring force generator. Applies the force of a spring to a box only when a collision occurs.
function BEBoxSpringForceGen() : BEForceGen() constructor
{
	boxes = be_oBoxEngine.boxes;
	springConstant = 128;
	
	/// @func	updateForce({Struct.BEBox} box, {real} dt);
	/// @desc	Applies spring forces to the box.
	static updateForce = function(_box, _dt)
	{
		// Check for collision
		var _inst = noone, _owner = _box.owner;
		with (_owner)
		{
			if (place_meeting(x, y, be_oBox)) _inst = instance_place(x, y, be_oBox);
		}
		if (_inst != noone)
		{
			// We have a collision
				
			// Calculate force direction
			var _p1 = _owner.box.getPosition(), _p2 = _inst.box.getPosition();
			var _dx = _p1.x - _p2.x, _dy = _p1.y - _p2.y;
			var _force = new BEVector2();
			if (abs(_dx) > abs(_dy))
			{
				if (_dx > 0) _force.setX(1);	// Right
				else _force.setX(-1);			// Left
			}
			else
			{
				if (_dy > 0) _force.setY(1);	// Down
				else _force.setY(-1);			// Up
			}
			
			// Calculate force magnitude
			var _mag = 0;
			if (_force.x > 0) _mag = _inst.bbox_right - _owner.bbox_left;
			else if (_force.x < 0) _mag = _owner.bbox_right - _inst.bbox_left;
			else if (_force.y > 0) _mag = _inst.bbox_bottom - _owner.bbox_top;
			else _mag = _owner.bbox_bottom - _inst.bbox_top;
			_mag *= springConstant;
		
			// Apply force
			_force.scale(_mag);
			_box.addForceVector(_force);
		}
	}
}