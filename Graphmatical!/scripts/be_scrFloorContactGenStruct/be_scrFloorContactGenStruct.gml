/// @func	BEFloorContactGen();
/// @desc	A floor contact generator which generates a contact when a box touches the bottom of the screen.
function BEFloorContactGen() : BEContactGen() constructor
{
	floorY = room_height;
	
	/// @func	addContact({int} contactIdx, {int} limit);
	/// @param	{int}	contactIdx	The contact to add.
	///	@param	{int}	limit		The max number of contacts in the array that can be written to.
	/// @return	{int}				The number of contacts that have been written.
	/// @desc	Fills the contact structure with a generated floor contact.
	static addContact = function(_contactIdx, _limit)
	{
		var _restitution = 0.8;
		
		// Loop through boxes
		var _used = 0;
		for (var _i = 0; _i < array_length(boxes); _i++)
		{
			// Break if used the limit
			if (_used >= _limit) break;
			
			// Check for penetration
			if (boxes[_i].owner.bbox_bottom > floorY)
			{
				// We have a collision (so fill out contact data)
				contacts[_contactIdx].normal.set(0, -1);
				contacts[_contactIdx].restitution = _restitution;
				contacts[_contactIdx].boxes[0] = boxes[_i];
				contacts[_contactIdx].boxes[1] = undefined;
				contacts[_contactIdx].penetration = boxes[_i].owner.bbox_bottom - floorY;
				_used++;
				_contactIdx++;
			}
		}
		return _used;
	}
}