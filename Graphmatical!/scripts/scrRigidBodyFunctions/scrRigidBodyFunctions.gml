/// @func	rbInit();
///	@desc	Init rigid body variables that are needed to use rigid body functions.
function rbInit()
{
	// Dimensions
	bboxWidth = bbox_right - bbox_left;
	bboxHeight = bbox_bottom - bbox_top;
	
	// States
	grounded = false;
	ignoreGraphs = false;
	
	// Movement
	velocity = new Vector2();
	normal = new Vector2();
	spd = 0;
	
	// Gravity
	gravityStrength = 0.1;
	
	// Resistances
	airResistance = new Vector2();
	airConstant = 0.002;
	groundResistance = new Vector2();
	groundConstant = 0.15;
	
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
	delete airResistance;
	delete groundResistance;
}

/// @func	rbUpdate();
function rbUpdate()
{
	// Update grounded state
	rbUpdateGroundedState();
	
	// Handle resistances
	//rbHandleResistances();
	
	// Gravity
	velocity.y += gravityStrength;
	
	#region Handle Graph Collisions
	
	// If not ignoring graphs
	if (!ignoreGraphs)
	{
		// Get axes collided with
		var _axesList = ds_list_create();
		with (graphDetector)
		{
			instance_place_list(x + other.velocity.x, y + other.velocity.y, oAxes, _axesList, false);
		}
		
		// Set collision variable
		var _collision = false;
		
		// Loop through axes
		for (var _j = 0; _j < ds_list_size(_axesList); _j++)
		{
			// Get axes + equations
			var _axes = _axesList[| _j];
			var _equations = _axes.equations;
			
			// Loop through equations
			for (var _i = 0; _i < array_length(_equations); _i++)
			{
				// Get equation
				var _equation = _equations[_i];
				
				// If x graph collisions
				if (graphVectorGroundCollision(_equation, x, bbox_bottom, x + velocity.x, bbox_bottom + velocity.y))
				{
					// Store collision
					_collision = true;
					collisionVelocity.x = velocity.x;
					collisionVelocity.y = velocity.y;
					
					// Choose side to check tile collision
					var _bboxSide = bbox_left;
					if (velocity.x > 0) _bboxSide = bbox_right;
					
					#region Move Close
						
					// While velocity is below 
					while (velocity.getLength() > collisionThreshold)
					{
						// Halve velocity
						velocity.multiplyByScalar(0.5);
							
						// If no graph collision
						if (!graphVectorGroundCollision(_equation, x, bbox_bottom, x + velocity.x, bbox_bottom + velocity.y))
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
					velocity.x = 0;
					velocity.y = 0;
						
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
					normal.x = _xSize;
					normal.y = _rightY - _leftY;
					normal.rotateDegrees(90);
					normal.normalize();
						
					#endregion
					
					// Calculate velocity projection
					var _dotProduct = collisionVelocity.dotWithVector(normal);
					velocity.x = collisionVelocity.x - normal.x * _dotProduct;
					velocity.y = collisionVelocity.y - normal.y * _dotProduct;
					
					// Get rotation direction
					var _normalAngle = normal.getAngleDegrees();
					var _rotationDirection = sign(angle_difference(_normalAngle, velocity.getAngleDegrees()));
					
					// Rotate velocity until no collision (up to a max)
					var _rotationCount = 0;
					while (graphVectorGroundCollision(_equation, x, bbox_bottom, x + velocity.x, bbox_bottom + velocity.y))
					{
						// Rotate velocity
						velocity.rotateDegrees(_rotationDirection);
						_rotationCount++;
								
						// Break if too many rotations
						if (_rotationCount > 360 || _rotationDirection == 0)
						{
							velocity.x = 0;
							velocity.y = 0;
							break;
						}
					}
						
					// Land if wasn't grounded and normal isn't too steep
					if (!grounded && _normalAngle < 178 && _normalAngle > 2) rbLand();
				}
				
				// Exit equations loop if collision
				if (_collision) break;
			}
			
			// Exit axes loop if collision
			if (_collision) break;
		}
		
		// Destroy list
		ds_list_destroy(_axesList);
	}
	
	#endregion
	
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
			// Store collision velocity
			collisionVelocity.x = velocity.x;
			
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
	
	// Update x
	x += velocity.x;
	
	// Set bounce velocity
	if (collisionVelocity.x != 0 && bounciness != 0)
	{
		// Set bounce velocity
		velocity.x = -collisionVelocity.x * bounciness;
		
		// Reset collision velocity
		collisionVelocity.x = 0
	}
	
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
			// Store collision velocity
			collisionVelocity.y = velocity.y;
			
			// Set normal
			normal.x = 0;
			normal.y = -sign(velocity.y);
			
			// Land if landed
			if (!grounded && velocity.y > 0) rbLand();
			
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
	
	// Update y
	y += velocity.y;
	
	// Set bounce velocity
	if (collisionVelocity.y != 0 && bounciness != 0)
	{
		// Set bounce velocity
		velocity.y = -collisionVelocity.y * bounciness;
		
		// Reset collision velocity
		collisionVelocity.y = 0;
	}
	
	#endregion
	
	// Move graph detector
	graphDetector.x = x;
	graphDetector.y = y;
	
	// Set speed
	spd = velocity.getLength();
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
}

/// @func	rbDrawGui();
function rbDrawGui()
{
	// Text
	draw_set_halign(fa_right);
	draw_set_valign(fa_top);
	var _x = display_get_gui_width() - 16, _y = 16;
	draw_text(_x, _y, "Rigid body: " + object_get_name(object_index));
	_y += 16;
	draw_text(_x, _y, "Velocity: " + string(velocity));
	_y += 16;
	draw_text(_x, _y, "Speed: " + string(spd));
	_y += 16;
	draw_text(_x, _y, "Air resistance: " + string(airResistance));
	_y += 16;
	draw_text(_x, _y, "Ground resistance: " + string(groundResistance));
	_y += 16;
	draw_text(_x, _y, "Normal: " + string(normal));
	_y += 16;
	draw_text(_x, _y, "Grounded: " + string(grounded));
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
							return;
						}
					}
				}
			}
		}
		
		// Tile check
		for (var _i = 0; _i < 2; _i++)
		{
			if (tilemap_get_at_pixel(collisionMap, bbox_left + _i * bboxWidth, bbox_bottom + 1) == 1)
			{
				grounded = true;
				return;
			}
		}
	}
}

/// @func	rbHandleResistances();
function rbHandleResistances()
{
	// Air resistance
	var _dx = sign(velocity.x), _dy = sign(velocity.y);
	velocity.x += airResistance.x;
	velocity.y += airResistance.y;
	if (sign(velocity.x) != _dx) velocity.x = 0;
	if (sign(velocity.y) != _dy) velocity.y = 0;
	
	// Ground resistance
	if (grounded)
	{
		_dx = sign(velocity.x);
		_dy = sign(velocity.y);
		velocity.x += groundResistance.x;
		velocity.y += groundResistance.y;
		if (sign(velocity.x) != _dx) velocity.x = 0;
		if (sign(velocity.y) != _dy) velocity.y = 0;
	}
	
	// Calculate resistances
	if (spd > 0)
	{
		// Calculate air resistance
		airResistance.x = -velocity.x;
		airResistance.y = -velocity.y;
		airResistance.normalize();
		airResistance.multiplyByScalar(airConstant * spd * spd);
		
		// If touching normal
		if (normal.x != 0 || normal.y != 0)
		{
			// Calculate ground resistance
			groundResistance.x = -velocity.x;
			groundResistance.y = -velocity.y;
			groundResistance.normalize();
			groundResistance.multiplyByScalar(groundConstant);
		}
	}
}

/// @func	rbLand();
function rbLand()
{
	// Set grounded state
	grounded = true;
}