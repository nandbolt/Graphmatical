/// @func	rbInit();
///	@desc	Init rigid body variables that are needed to use rigid body functions.
function rbInit()
{
	// Dimensions
	bboxWidth = bbox_right - bbox_left;
	bboxHeight = bbox_bottom - bbox_top;
	
	// Movement
	velocity = new Vector2();
	
	// Gravity
	gravityStrength = 0.1;
	
	// Collisions
	collisionMap = layer_tilemap_get_id("CollisionTiles");
	collisionThreshold = 0.1;
}

/// @func	rbCleanup();
function rbCleanup()
{
	// Vectors
	delete velocity;
}

/// @func	rbUpdate();
function rbUpdate()
{
	// Gravity
	velocity.y += gravityStrength;
	
	#region Handle X Tile Collisions
	
	var _bboxSide = bbox_left;
	if (velocity.x > 0) _bboxSide = bbox_right;
	for (var _j = 0; _j < 2; _j++)
	{
		// Check for x collision on moving side
		var _y = bbox_top + _j * bboxHeight;
		var _tile = tilemap_get_at_pixel(collisionMap, _bboxSide + velocity.x, _y);
		if (_tile == 1)
		{		
			// Loop until close enough to tile
			while (abs(velocity.x) > collisionThreshold)
			{
				// Halve velocity
				velocity.x *= 0.5;
				
				// Move if no collision
				_tile = tilemap_get_at_pixel(collisionMap, _bboxSide + velocity.x, _y);
				if (_tile != 1)
				{
					_bboxSide += velocity.x;
					x += velocity.x;
				}
			}
			
			// X collision
			velocity.x = 0;
			break;
		}
	}
	x += velocity.x;
	
	#endregion
	
	#region Handle Y Tile Collisions
	
	_bboxSide = bbox_top;
	if (velocity.y > 0) _bboxSide = bbox_bottom;
	for (var _i = 0; _i < 2; _i++)
	{
		// Check for y collision on moving side
		var _x = bbox_left + _i * bboxWidth;
		var _tile = tilemap_get_at_pixel(collisionMap, _x, _bboxSide + velocity.y);
		if (_tile == 1)
		{
			// Loop until close enough to tile
			while (abs(velocity.y) > collisionThreshold)
			{
				// Halve velocity
				velocity.y *= 0.5;
				
				// Move if no collision
				_tile = tilemap_get_at_pixel(collisionMap, _x, _bboxSide + velocity.y);
				if (_tile != 1)
				{
					_bboxSide += velocity.y;
					y += velocity.y;
				}
			}
			
			// Y collision
			velocity.y = 0;
			break;
		}
	}
	y += velocity.y;
	
	#endregion
}

/// @func	rbUpdateBbox();
/// @desc	Updates the bounding box sizes based off of current bounding box side locations.
function rbUpdateBbox()
{
	bboxWidth = bbox_right - bbox_left;
	bboxHeight = bbox_bottom - bbox_top;
}