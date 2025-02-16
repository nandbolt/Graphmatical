/// @func	BETileContactGen({id} tileLayer, {int} tileSize);
/// @desc	Handles contacts with tiles in the room.
function BETileContactGen(_tileLayer=layer_tilemap_get_id("CollisionTiles"), _tileSize=16) : BEContactGen() constructor
{
	collisionTiles = _tileLayer;
	tileSize = _tileSize;
	inverseTileSize = 1 / tileSize;
	halfTileSize = tileSize * 0.5;
	
	/// @func	addContact({int} contactIdx, {int} limit);
	/// @param	{int}	contactIdx	The contact to add.
	///	@param	{int}	limit		The max number of contacts in the array that can be written to.
	/// @return	{int}				The number of contacts that have been written.
	/// @desc	Fills the contact structure with a generated tile contact.
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
			var _tileCollision = false;
			for (var _k = 0; _k < 2; _k++)
			{
				for (var _j = 0; _j < 2; _j++)
				{
					var _owner = boxes[_i].owner;
					var _x = _owner.bbox_left + _j * (_owner.bbox_right - _owner.bbox_left);
					var _y = _owner.bbox_top + _k * (_owner.bbox_bottom - _owner.bbox_top);
					if (tilemap_get_at_pixel(collisionTiles, _x, _y) > 0)
					{
						// We have a collision (so fill out contact data)
						_tileCollision = true;
						
						// Calculate normal
						var _tx = floor(_x * inverseTileSize) * tileSize + halfTileSize, _ty = floor(_y * inverseTileSize) * tileSize + halfTileSize;
						var _dx = _owner.x - _tx, _dy = _owner.y - _ty;
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
						
						// Ignore if there's a tile opposite to the normal
						if (tilemap_get_at_pixel(collisionTiles, _x + _normal.x * tileSize, _y + _normal.y * tileSize) > 0) continue;
						
						// Set normal
						contacts[_contactIdx].normal.setVector(_normal);
				
						// Set everything but interpenetration
						contacts[_contactIdx].restitution = _restitution;
						contacts[_contactIdx].boxes[0] = boxes[_i];
						contacts[_contactIdx].boxes[1] = undefined;
				
						// Calculate interpenetration
						//if (_normal.y != 0) contacts[_contactIdx].penetration = halfTileSize - abs(_dy);
						//else contacts[_contactIdx].penetration = halfTileSize - abs(_dx);
						
						// Calculate interpenetration
						if (_normal.x > 0) contacts[_contactIdx].penetration = _tx + halfTileSize - _x;
						else if (_normal.x < 0) contacts[_contactIdx].penetration = _x - _tx + halfTileSize;
						else if (_normal.y > 0) contacts[_contactIdx].penetration = _ty + halfTileSize - _y;
						else contacts[_contactIdx].penetration = _y - _ty + halfTileSize;
						//contacts[_contactIdx].penetration *= -1;
				
						// Increment
						_used++;
						_contactIdx++;
						if (_contactIdx >= array_length(contacts)) return _used;
					}
				}
			}
		}
		return _used;
	}
}