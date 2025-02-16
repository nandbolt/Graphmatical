/// @func	BEBoxContactGen();
/// @desc	Handles contacts with boxes in the room.
function BEBoxContactGen() : BEContactGen() constructor
{
	/// @func	addContact({int} contactIdx, {int} limit);
	/// @param	{int}	contactIdx	The contact to add.
	///	@param	{int}	limit		The max number of contacts in the array that can be written to.
	/// @return	{int}				The number of contacts that have been written.
	/// @desc	Fills the contact structure with a generated box contact.
	static addContact = function(_contactIdx, _limit)
	{
		var _restitution = 0.5;
		
		// Loop through boxes
		var _used = 0;
		for (var _i = 0; _i < array_length(boxes); _i++)
		{
			// Break if used the limit
			if (_used >= _limit) break;
			
			// Check for penetration
			var _inst = noone, _owner = boxes[_i].owner;
			with (_owner)
			{
				if (place_meeting(x, y, be_oBox)) _inst = instance_place(x, y, be_oBox);
			}
			if (_inst != noone)
			{
				// We have a collision (so fill out contact data)
					
				// Calculate normal
				var _dx = _owner.x - _inst.x, _dy = _owner.y - _inst.y;
				var _normal = new BEVector2();
				if (abs(_dx) > abs(_dy))
				{
					if (_dx > 0) _normal.setX(1);	// Right
					else _normal.setX(-1);			// Left
				}
				else
				{
					if (_dy > 0) _normal.setY(1);	// Down
					else _normal.setY(-1);			// Up
				}
				contacts[_contactIdx].normal.setVector(_normal);
				
				// Set everything but interpenetration
				contacts[_contactIdx].restitution = _restitution;
				contacts[_contactIdx].boxes[0] = _owner.box;
				contacts[_contactIdx].boxes[1] = _inst.box;
				
				// Calculate interpenetration
				if (_normal.x > 0) contacts[_contactIdx].penetration = _inst.bbox_right - _owner.bbox_left;
				else if (_normal.x < 0) contacts[_contactIdx].penetration = _owner.bbox_right - _inst.bbox_left;
				else if (_normal.y > 0) contacts[_contactIdx].penetration = _inst.bbox_bottom - _owner.bbox_top;
				else contacts[_contactIdx].penetration = _owner.bbox_bottom - _inst.bbox_top;
				contacts[_contactIdx].penetration += 0.01;
				//contacts[_contactIdx].penetration *= -1;
				
				// Increment
				_used++;
				_contactIdx++;
			}
		}
		return _used;
	}
}