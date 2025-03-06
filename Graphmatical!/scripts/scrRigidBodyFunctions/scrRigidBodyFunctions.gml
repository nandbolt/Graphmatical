/// @func	rbInit();
///	@desc	Init rigid body variables that are needed to use rigid body functions.
function rbInit()
{
	// Dimensions
	bboxWidth = bbox_right - bbox_left;
	bboxHeight = bbox_bottom - bbox_top;
	
	// States
	grounded = false;
	onGraph = false;
	onGraphEquation = undefined;
	ignoreGraphs = false;
	
	// Movement
	velocity = new Vector2();
	normal = new Vector2();
	spd = 0;
	
	// Circle rotations
	circleRotations = false;
	circleTorque = 0;
	
	// Gravity
	gravityStrength = 0.1;
	
	// Resistances
	airResistance = new Vector2();
	airConstant = 0.001;
	groundResistance = new Vector2();
	groundConstant = 0.1;
	
	// Collisions
	collisionMap = layer_tilemap_get_id("CollisionTiles");
	collisionVelocity = new Vector2();
	collisionThreshold = 0.1;
	graphDetector = instance_create_layer(x, y, "Instances", oHitbox);
	with (graphDetector)
	{
		image_xscale = other.bboxWidth * 0.5 + TILE_SIZE;
		image_yscale = other.bboxHeight * 0.5 + TILE_SIZE;
	}
	
	// Bounce
	bounciness = 0;
	bounceVelocity = new Vector2();
	onBounce = function(){}
	bounceThreshold = 0.1;
	
	// Tile slopes
	slopePosition = new Vector2();	// Where the slope was detected
	slopeVelocity = new Vector2();	// What the velocity across the slope is
	
	// Sfx
	landSfx = sfxLand;
	
	// Death
	dead = false;
	die = function(){ instance_destroy(); }
}

/// @func	rbCleanup();
function rbCleanup()
{
	// Detector
	instance_destroy(graphDetector);
	
	// Vectors
	delete velocity;
	delete normal;
	delete collisionVelocity;
	delete bounceVelocity;
	delete airResistance;
	delete groundResistance;
}

/// @func	rbUpdate();
function rbUpdate()
{
	// Reset collision variables
	collisionVelocity.set();
	slopeVelocity.set();
	
	// Update grounded state
	rbUpdateGroundedState();
	
	// Bounce
	rbHandleBounce();
	
	// Handle resistances
	rbHandleResistances();
	
	// Gravity
	velocity.y += gravityStrength;
	
	// Graphs
	rbHandleGraphCollisions();
	
	// X Tiles
	rbHandleXTileCollisions();
	
	// Update x
	x += velocity.x;
	
	// Y Tiles
	rbHandleYTileCollisions();
	
	// Update y
	y += velocity.y;
	
	// Add slope velocity if no subsequent collisions
	if (slopeVelocity.x != 0 || slopeVelocity.y != 0)
	{
		var _x = slopePosition.x + slopeVelocity.x, _y = slopePosition.y + slopeVelocity.y;
		if (rbTileCollisionAtPoint(_x, _y) == -1)
		{
			velocity.x = slopeVelocity.x;
			velocity.y = slopeVelocity.y
			x += velocity.x;
			y += velocity.y;
		}
	}
	
	// Move graph detector
	graphDetector.x = x;
	graphDetector.y = y;
	
	// Set speed
	spd = velocity.getLength();
}

/// @func	rbEndUpdate();
function rbEndUpdate()
{
	if (dead) die();
}

/// @func	rbDraw();
/// @desc	Draws the collision box and relevant movement vectors.
function rbDraw()
{
	// Detection box
	with (graphDetector) draw_sprite_pos(sSquare, 0, bbox_left, bbox_top, bbox_right, bbox_top, bbox_right, bbox_bottom, bbox_left, bbox_bottom, 0.05);
	
	// Collision box
	draw_sprite_pos(sSquare, 0, bbox_left, bbox_top, bbox_right, bbox_top, bbox_right, bbox_bottom, bbox_left, bbox_bottom, 0.25);
	
	// Origin
	//draw_sprite(sSquare, 0, x, y);
	
	// Vectors
	draw_line_color(x-1, y-1, x + velocity.x-1, y + velocity.y-1, c_aqua, c_aqua);
	var _rx = airResistance.x, _ry = airResistance.y;
	if (normal.x != 0 || normal.y != 0)
	{
		_rx += groundResistance.x;
		_ry += groundResistance.y;
		draw_line_color(x-1, bbox_bottom-1, x + normal.x * 4-1, bbox_bottom + normal.y * 4 -1, c_lime, c_lime);
	}
	draw_line_color(x-1, y-1, x + _rx-1, y + _ry-1, c_red, c_red);
	
	// Ground line
	draw_line(x-1, bbox_bottom-1, x-1, bbox_bottom + 1);
}

/// @func	rbDrawGui();
function rbDrawGui()
{
	// Text
	draw_set_halign(fa_right);
	draw_set_valign(fa_bottom);
	var _x = display_get_gui_width() - 16, _y = display_get_gui_height() - 16;
	draw_text(_x, _y, "Rigid body: " + object_get_name(object_index));
	_y -= 16;
	draw_text(_x, _y, "Velocity: " + string(velocity));
	_y -= 16;
	draw_text(_x, _y, "Speed: " + string(spd));
	_y -= 16;
	draw_text(_x, _y, "Air resistance: " + string(airResistance));
	_y -= 16;
	draw_text(_x, _y, "Ground resistance: " + string(groundResistance));
	_y -= 16;
	draw_text(_x, _y, "Normal: " + string(normal));
	_y -= 16;
	draw_text(_x, _y, "Grounded: " + string(grounded));
	_y -= 16;
	draw_text(_x, _y, "On Graph: " + string(onGraph));
	if (onGraph)
	{
		_y -= 16;
		draw_text(_x, _y, "On Graph EQ: " + string(onGraphEquation.expressionString));
	}
}

/// @func	rbUpdateBbox();
/// @desc	Updates the bounding box sizes based off of current bounding box side locations.
function rbUpdateBbox()
{
	bboxWidth = bbox_right - bbox_left;
	bboxHeight = bbox_bottom - bbox_top;
}

/// @func	rbUpdateGroundedState();
function rbUpdateGroundedState()
{
	// Only update if grounded (collision functions should set ground state initially)
	if (grounded)
	{
		// Reset grounded
		grounded = false;
		onGraph = false;
		onGraphEquation = undefined;
		
		// Graph check
		if (!ignoreGraphs)
		{
			// Loop through axes
			with (oAxes)
			{
				// Loop through equations
				for (var _i = 0; _i < array_length(equations); _i++)
				{
					// Get equation
					var _equation = equations[_i];
				
					// Go back to rigid body scope
					with (other)
					{
						// If y graph collisions
						if (graphVectorGroundCollision(_equation, x, bbox_bottom, x, bbox_bottom + 2))
						{
							grounded = true;
							onGraph = true;
							onGraphEquation = _equation;
							return;
						}
					}
				}
			}
			onGraph = false;
		}
		
		// Tile check
		for (var _i = 0; _i < 2; _i++)
		{
			if (rbTileCollisionAtPoint(bbox_left + _i * bboxWidth, bbox_bottom + 1) != -1)
			{
				grounded = true;
				return;
			}
		}
	}
}

/// @func	rbHandleBounce();
function rbHandleBounce()
{
	// Bounce if necessary
	if (bounceVelocity.getLength() > bounceThreshold)
	{
		onBounce();
		if (bounceVelocity.x != 0)
		{
			velocity.x += bounceVelocity.x;
			bounceVelocity.x = 0;
		}
		if (bounceVelocity.y != 0)
		{
			velocity.y += bounceVelocity.y;
			bounceVelocity.y = 0;
		}
	}
}

/// @func	rbHandleResistances();
function rbHandleResistances()
{
	// If moving
	var _speed = velocity.getLength();
	if (_speed > 0)
	{
		// Apply air resistance
		airResistance.setLengthVector(velocity, -1 * airConstant * _speed * _speed);
		velocity.addResistanceVector(airResistance);
		
		// If grounded
		if (grounded)
		{
			// Apply ground resistance
			groundResistance.setLengthVector(velocity, -1 * groundConstant);
			velocity.addResistanceVector(groundResistance);
		}
	}
}

/// @func	rbHandleGraphCollisions();
function rbHandleGraphCollisions()
{
	// Get axes collided with
	var _axesList = ds_list_create();
	var _axesCount = 0;
	with (graphDetector)
	{
		_axesCount = instance_place_list(x + other.velocity.x, y + other.velocity.y, oAxes, _axesList, false);
	}
	
	// Loop through axes
	for (var _j = 0; _j < _axesCount; _j++)
	{
		// Get axes + equations
		var _axes = _axesList[| _j];
		var _equations = _axes.equations;
		var _equationCount = array_length(_equations);
		
		// If ignore graphs and axes is not laser
		if (ignoreGraphs && _axes.material != GraphType.LASER) continue;
		
		// Loop through equations
		for (var _i = 0; _i < _equationCount; _i++)
		{
			// Get equation
			var _equation = _equations[_i];
			
			// If not laser
			if (_axes.material != GraphType.LASER) rbHandleSolidGraphCollision(_equation);
			else rbHandleLaserGraphCollision(_equation);
		}
	}
		
	// Destroy list
	ds_list_destroy(_axesList);
}

/// @func	rbHandleSolidGraphCollision({Equation} equation);
function rbHandleSolidGraphCollision(_equation)
{
	// Get axes
	var _axes = _equation.axes;
	
	// If x graph collisions
	if (graphVectorGroundCollision(_equation, x, bbox_bottom, x + velocity.x, bbox_bottom + velocity.y))
	{
		// Store collision
		collisionVelocity.setVector(velocity);
		
		// Calculate circular torque if necessary
		if (circleRotations)
		{
			var _r = new Vector2(x + velocity.x, bbox_bottom + velocity.y);
			_r.normalize();
			var _angle = _r.getAngleDegrees() - velocity.getAngleDegrees();
			circleTorque = velocity.getLength() * bboxWidth * 0.5 * sign(_angle);
		}
					
		// Choose side to check tile collision
		var _bboxSide = bbox_left;
		if (velocity.x > 0) _bboxSide = bbox_right;
					
		#region Move Close
						
		// While velocity is below 
		while (velocity.getLength() > collisionThreshold)
		{
			// Halve velocity
			velocity.scale(0.5);
							
			// If point above graph
			//if (!graphVectorGroundCollision(_equation, x, bbox_bottom, x + velocity.x, bbox_bottom + velocity.y))
			if (graphPointAbove(_equation, x + velocity.x, bbox_bottom + velocity.y))
			{
				// If no tile collisions
				if (tilemap_get_at_pixel(collisionMap, x + velocity.x, bbox_bottom + velocity.y) == 0 && 
					tilemap_get_at_pixel(collisionMap, _bboxSide + velocity.x, y + velocity.y) == 0)
				{
					// Move closer
					x += velocity.x;
					y += velocity.y;
					_bboxSide += velocity.x;
				}
			}
		}
					
		// Zero velocity
		velocity.set();
						
		#endregion
					
		#region Calculate Normal
						
		// Calculate y values
		var _xSize = 2;
		var _ayLeft = _equation.evaluate(xToAxisX(_axes, x-1));
		if (is_string(_ayLeft))
		{
			_ayLeft = _equation.evaluate(xToAxisX(_axes, x));
			_xSize--;
		}
		var _ayRight = _equation.evaluate(xToAxisX(_axes, x+1));
		if (is_string(_ayRight))
		{
			_ayRight = _equation.evaluate(xToAxisX(_axes, x));
			_xSize--;
		}
		var _leftY = axisYtoY(_axes, _ayLeft), _rightY = axisYtoY(_axes, _ayRight);
						
		// Calculate normal
		normal.setNormal(_xSize, _rightY - _leftY);
		normal.rotateDegrees(90);
						
		#endregion
					
		// Calculate velocity projection
		var _dotProduct = collisionVelocity.dotWithVector(normal);
		velocity.set(collisionVelocity.x - normal.x * _dotProduct, collisionVelocity.y - normal.y * _dotProduct);
				
		// If bouncy
		if (bounciness != 0 || _axes.material == GraphType.BOUNCY)
		{
			// Calculate bounce velocity
			bounceVelocity.set(collisionVelocity.x - normal.x * _dotProduct * 2, collisionVelocity.y - normal.y * _dotProduct * 2);
			if (_axes.material != GraphType.BOUNCY) bounceVelocity.scale(bounciness);
					
			// Set grounded state
			grounded = true;
					
			// Zero velocity 
			velocity.set();
		}
		else
		{
			// Get rotation direction
			var _normalAngle = normal.getAngleDegrees();
			var _rotationDirection = sign(angle_difference(_normalAngle, velocity.getAngleDegrees()));
					
			// Rotate velocity until no collision (up to a max)
			var _rotationCount = 0;
			while (!graphPointAbove(_equation, x + velocity.x, bbox_bottom + velocity.y))
			{
				// Rotate velocity
				velocity.rotateDegrees(_rotationDirection);
				_rotationCount++;
								
				// Break if too many rotations
				if (_rotationCount > 45)
				{
					velocity.set();
					break;
				}
			}
					
			// Last check
			if (!graphPointAbove(_equation, x + velocity.x, bbox_bottom + velocity.y)) velocity.set();
						
			// Land if wasn't grounded and normal isn't too steep
			if (!grounded && _normalAngle < 178 && _normalAngle > 2) rbLand();
		}
	}
}

/// @func	rbHandleLaserGraphCollision({Equation} equation);
function rbHandleLaserGraphCollision(_equation)
{
	if (graphTouching(_equation, self)) dead = true;
}

/// @func	rbHandleXTileCollisions();
function rbHandleXTileCollisions()
{
	// Choose bounding box side
	var _bboxSide = bbox_left;
	if (velocity.x > 0) _bboxSide = bbox_right;
	for (var _j = 0; _j < 2; _j++)
	{
		// Check for x collision on moving side
		var _y = bbox_top + _j * bboxHeight;
		var _tile = rbTileCollisionAtPoint(_bboxSide + velocity.x, _y);
		if (_tile != -1)
		{
			// Get actual index (to account for rotations)
			var _tileIdx = tile_get_index(_tile);
			
			// Check slanted tiles
			if (_tileIdx == 2)
			{
				// If slant normal is defined
				var _normal = rbGetTileSlopeNormal(_tile, _bboxSide, _y, _bboxSide + velocity.x, _y);
				if (is_struct(_normal))
				{
					// Rotate normal
					var _angle = velocity.getAngleDegrees() - _normal.getAngleDegrees();
					if (_angle > 0) _normal.rotateDegrees(90);
					else _normal.rotateDegrees(-90);
					
					// Calculate slope velocity
					var _dot = _normal.dotWithVector(velocity);
					slopeVelocity.x = _normal.x * _dot;
					slopeVelocity.y = _normal.y * _dot;
				}
			}
			
			// Store collision velocity
			collisionVelocity.x = velocity.x;
			bounceVelocity.x = -velocity.x * bounciness;
			
			// Calculate circular torque if necessary
			if (circleRotations)
			{
				var _r = new Vector2(_bboxSide + velocity.x - x, _y - y);
				_r.normalize();
				var _angle = _r.getAngleDegrees() - velocity.getAngleDegrees();
				circleTorque = velocity.getLength() * bboxWidth * 0.5 * sign(_angle);
			}
			
			// Loop until close enough to tile
			while (abs(velocity.x) > collisionThreshold)
			{
				// Halve velocity
				velocity.x *= 0.5;
				
				// Move if no collision
				_tile = rbTileCollisionAtPoint(_bboxSide + velocity.x, _y);
				if (_tile == -1)
				{
					_bboxSide += velocity.x;
					x += velocity.x;
				}
			}
			
			// Update slope position
			if (_tileIdx == 2)
			{
				slopePosition.x = _bboxSide;
				slopePosition.y = _y;
			}
			
			// X collision
			velocity.x = 0;
			break;
		}
	}
}

/// @func	rbHandleYTileCollisions();
function rbHandleYTileCollisions()
{
	var _bboxSide = bbox_top;
	if (velocity.y > 0) _bboxSide = bbox_bottom;
	for (var _i = 0; _i < 2; _i++)
	{
		// Check for y collision on moving side
		var _x = bbox_left + _i * bboxWidth;
		var _tile = rbTileCollisionAtPoint(_x, _bboxSide + velocity.y);
		if (_tile != -1)
		{
			// Get actual index (to account for rotations)
			var _tileIdx = tile_get_index(_tile);
			
			// Check slanted tiles
			var _newSlope = false;
			if (_tileIdx == 2 && slopeVelocity.getLength() == 0)
			{
				// If slant normal is defined
				var _normal = rbGetTileSlopeNormal(_tile, _x, _bboxSide, _x, _bboxSide + velocity.y);
				if (is_struct(_normal))
				{
					_newSlope = true;
					
					// Rotate normal
					var _angle = velocity.getAngleDegrees() - _normal.getAngleDegrees();
					if (_angle > 0) _normal.rotateDegrees(90);
					else _normal.rotateDegrees(-90);
					
					// Calculate slope velocity
					var _dot = _normal.dotWithVector(velocity);
					slopeVelocity.x = _normal.x * _dot;
					slopeVelocity.y = _normal.y * _dot;
				}
			}
			
			// Store collision velocity
			collisionVelocity.y = velocity.y;
			bounceVelocity.y = -velocity.y * bounciness;
			
			// Set normal
			normal.set(0, -sign(velocity.y));
			
			// Land if landed
			if (!grounded && velocity.y > 0) rbLand();
			
			// Calculate circular torque if necessary
			if (circleRotations)
			{
				var _r = new Vector2(_x - x, _bboxSide + velocity.y - y);
				_r.normalize();
				var _angle = _r.getAngleDegrees() - velocity.getAngleDegrees();
				circleTorque = velocity.getLength() * bboxHeight * 0.5 * sign(_angle);
			}
			
			// Loop until close enough to tile
			while (abs(velocity.y) > collisionThreshold)
			{
				// Halve velocity
				velocity.y *= 0.5;
				
				// Move if no collision
				_tile = rbTileCollisionAtPoint(_x, _bboxSide + velocity.y);
				if (_tile == -1)
				{
					_bboxSide += velocity.y;
					y += velocity.y;
				}
			}
			
			// Update slope position
			if (_newSlope)
			{
				slopePosition.x = _x;
				slopePosition.y = _bboxSide;
			}
			
			// Y collision
			velocity.y = 0;
			break;
		}
	}
}

/// @func	rbLand();
function rbLand()
{
	// Set grounded state
	grounded = true;
	
	// Land sfx
	if (visibleToCamera(other.id)) audio_play_sound(landSfx, 2, false);
}

/// @func	rbTileCollisionAtPoint(x, y);
///	@param	{real}	x	The x-coordinate to check.
///	@param	{real}	y	The y-coordinate to check.
///	@desc	Checks if there's a tile collision at the point. If so, returns tile data. If not, returns -1.
///	@return	{TileData}
function rbTileCollisionAtPoint(_x, _y)
{
	// Get tile data
	var _tileData = tilemap_get_at_pixel(collisionMap, _x, _y);
	
	// Square tile
	if (_tileData == 1) return _tileData;
	
	// Get actual index (to account for rotations)
	var _tileIdx = tile_get_index(_tileData);
	
	// Slanted tile
	if (_tileIdx == 2)
	{
		// Get tile orientation
		var _flipped = tile_get_flip(_tileData);	// Up/Down
		var _mirrored = tile_get_mirror(_tileData);	// Right/Left
				
		// Get position in tile
		var _tx = floor(_x / TILE_SIZE) * TILE_SIZE, _ty = floor(_y / TILE_SIZE) * TILE_SIZE;
		var _rx = _x - _tx, _ry = _y - _ty;
				
		// |\
		if (!_flipped && !_mirrored && _ry > _rx) return _tileData;
		// \|
		else if (_flipped && _mirrored && _ry < _rx) return _tileData;
		// |/
		else if (!_flipped && _mirrored && _ry > (-_rx + TILE_SIZE)) return _tileData;
		// /|
		else if (_flipped && !_mirrored && _ry < (-_rx + TILE_SIZE)) return _tileData
	}
	
	// No collision
	return -1;
}

/// @func	rbGetTileSlopeNormal(tileData, x1, y1, x2, y2);
///	@param	{TileData}	tileData	The sloped tile data.
///	@param	{real}		x1			The starting x-coordinate.
///	@param	{real}		y1			The starting y-coordinate.
///	@param	{real}		x2			The ending x-coordinate.
///	@param	{real}		y2			The ending y-coordinate.
///	@desc	Checks if there's a slope between the points. If so, returns the normal. If not, returns undefined.
///	@return	{Struct.Vector2}
function rbGetTileSlopeNormal(_tileData, _x1, _y1, _x2, _y2)
{
	// Get tile orientation
	var _flipped = tile_get_flip(_tileData);	// Up/Down
	var _mirrored = tile_get_mirror(_tileData);	// Right/Left
				
	// Get position in tile
	var _tx = floor(_x2 / TILE_SIZE) * TILE_SIZE, _ty = floor(_y2 / TILE_SIZE) * TILE_SIZE;
	var _vx = _x2 - _x1, _vy = _y2 - _y1;
				
	// |\
	if (!_flipped && !_mirrored)
	{
		// Slope collision if NE
		if (_x1 > _tx && _y1 < (_ty + TILE_SIZE)) return new Vector2(SQRT_2BY2, -SQRT_2BY2);
	}
	// \|
	else if (_flipped && _mirrored)
	{
		// Slope collision if SW
		if (_x1 < (_tx + TILE_SIZE) && _y1 > _ty) return new Vector2(-SQRT_2BY2, SQRT_2BY2);
	}
	// |/
	else if (_flipped && !_mirrored)
	{
		// Slope collision if SE
		if (_x1 > _tx && _y1 > _ty) return new Vector2(SQRT_2BY2, SQRT_2BY2);
	}
	// /|
	else if (!_flipped && _mirrored)
	{
		// Slope collision if NW
		if (_x1 < (_tx + TILE_SIZE) && _y1 < (_ty + TILE_SIZE)) return new Vector2(-SQRT_2BY2, -SQRT_2BY2);
	}
	
	// No collision
	return undefined;
}