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
	collisionThreshold = 0.1;
	
	// Bounce
	bounceVelocity = new Vector2();
	bounciness = 0;
}

/// @func	rbCleanup();
function rbCleanup()
{
	// Vectors
	if (is_struct(velocity)) delete velocity;
	if (is_struct(normal)) delete normal;
	if (is_struct(bounceVelocity)) delete bounceVelocity;
	if (is_struct(airResistance)) delete airResistance;
	if (is_struct(groundResistance)) delete groundResistance;
}

/// @func	rbUpdate();
function rbUpdate()
{	
	// Reset normal
	normal.x = 0;
	normal.y = 0;
	
	// Update grounded state
	rbUpdateGroundedState();
	
	// Gravity
	velocity.y += gravityStrength;
	
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
	
	#region Handle X Graph Collisions
	
	// If not ignoring graphs
	if (!ignoreGraphs)
	{
		// Set collision variable
		var _collision = false;
		
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
					// If x graph collisions
					if (graphVectorGroundCollision(_equation, x, bbox_bottom, x + velocity.x, bbox_bottom))
					{
						// Land if landed
						if (!grounded) rbLand();
						
						// Zero x velocity
						velocity.x = 0;
					}
				}
				
				// Break if collision
				if (_collision) break;
			}
			
			// Break if collision
			if (_collision) break;
		}
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
			bounceVelocity.x = -velocity.x * bounciness;
			
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
	if (bounceVelocity.x != 0)
	{
		velocity.x = bounceVelocity.x;
		bounceVelocity.x = 0;
	}
	
	#endregion
	
	#region Handle Y Graph Collisions
	
	// If not ignoring graphs
	if (!ignoreGraphs)
	{
		// Set collision variable
		var _collision = false;
		
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
					if (graphVectorGroundCollision(_equation, x, bbox_bottom, x, bbox_bottom + velocity.y))
					{
						// Land if landed
						if (!grounded && velocity.y > 0) rbLand();
						
						// Zero y velocity
						velocity.y = 0;
					}
				}
				
				// Break if collision
				if (_collision) break;
			}
			
			// Break if collision
			if (_collision) break;
		}
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
			bounceVelocity.y = -velocity.y * bounciness;
			
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
	if (bounceVelocity.y != 0)
	{
		velocity.y = bounceVelocity.y;
		bounceVelocity.y = 0;
	}
	
	#endregion
	
	// Set speed
	spd = velocity.getLength();
	
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

/// @func	rbDraw();
/// @desc	Draws the collision box and relevant movement vectors.
function rbDraw()
{
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
							normal.x = 0;
							normal.y = -1;
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
				normal.x = 0;
				normal.y = -1;
				break;
			}
		}
	}
}

/// @func	rbLand();
function rbLand()
{
	// Set grounded state
	grounded = true;
}