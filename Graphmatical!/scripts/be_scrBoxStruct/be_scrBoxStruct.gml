/// @func	BEBox({id} owner, {real} mass, {real} damping);
/// @desc	A point-mass box that is simulated by the Box Engine. It is affected by forces
///			produced by force generators and impulses caused by contact generators.
function BEBox(_owner=other.id, _mass=1, _damping=0.5) constructor
{
	/*
	The object that this box is parented to. This is where it will get its
	position. It is also vital in collision detection since GameMaker's collision
	detection system has objects in mind.
	*/
	owner = _owner;
	
	// Movement
	velocity = new BEVector2();
	acceleration = new BEVector2();
	netForce = new BEVector2();
	
	// Mass
	inverseMass = 1 / _mass;	// Better to keep inverse mass than mass for computations. (zero inverse mass = immoveable)
	
	// Drag
	damping = _damping;			// Dampens velocity (1 = no damping, 0 = max damping)
	
	#region Getters/Setters
	
	/// @func	getPosition();
	static getPosition = function(){ return new BEVector2(owner.x, owner.y); }
	
	/// @func	setPosition({real} x, {real} y);
	static setPosition = function(_x, _y)
	{
		owner.x = _x;
		owner.y = _y;
	}
	
	/// @func	setPositionVector({Struct.BEVector2} v);
	static setPositionVector = function(_v)
	{
		owner.x = _v.x;
		owner.y = _v.y;
	}
	
	/// @func	getVelocity();
	static getVelocity = function(){ return new BEVector2(velocity.x, velocity.y); }
	
	/// @func	setVelocity({real} x, {real} y);
	static setVelocity = function(_x, _y)
	{
		velocity.x = _x;
		velocity.y = _y;
	}
	
	/// @func	setVelocityVector({Struct.BEVector2} v);
	static setVelocityVector = function(_v)
	{
		velocity.x = _v.x;
		velocity.y = _v.y;
	}
	
	/// @func	getAcceleration();
	static getAcceleration = function(){ return new BEVector2(acceleration.x, acceleration.y); }
	
	/// @func	setAcceleration({real} x, {real} y);
	static setAcceleration = function(_x, _y)
	{
		acceleration.x = _x;
		acceleration.y = _y;
	}
	
	/// @func	setAccelerationVector({Struct.BEVector2} v);
	static setAccelerationVector = function(_v)
	{
		acceleration.x = _v.x;
		acceleration.y = _v.y;
	}
	
	/// @func	getMass();
	static getMass = function()
	{
		if (inverseMass == 0) return infinity;
		return 1 / inverseMass;
	}
	
	/// @func	setMass({real} mass);
	static setMass = function(_mass)
	{
		if (_mass == 0) throw("Set mass error. Mass can't be 0!");
		inverseMass = 1 / _mass;
	}
	
	/// @func	getInverseMass();
	static getInverseMass = function(){ return inverseMass; }
	
	/// @func	setInverseMass({real} inverseMass);
	static setInverseMass = function(_inverseMass){ inverseMass = _inverseMass; }
	
	/// @func	getDamping();
	static getDamping = function(){ return damping; }
	
	/// @func	setDamping({real} damping);
	static setDamping = function(_damping){ damping = _damping; }
	
	/// @func	getInstance();
	static getInstance = function(){ return owner; }
	
	/// @func	setInstance({id} inst);
	static setInstance = function(_inst){ owner = _inst; }
	
	#endregion
	
	/// @func	hasFiniteMass();
	/// @desc	Returns whether the box has finite mass.
	static hasFiniteMass = function(){ return inverseMass >= 0; }
	
	/// @func	clearNetForce();
	/// @desc	Clears all of the net forces acting on the box.
	static clearNetForce = function()
	{
		netForce.x = 0;
		netForce.y = 0;
	}
	
	/// @func	addForce({real} x, {real} y);
	/// @desc	Adds the given force to the net forces acting on the box.
	static addForce = function(_x, _y)
	{
		netForce.x += _x;
		netForce.y += _y;
	}
	
	/// @func	addForceVector({Struct.BEVector2} v);
	/// @desc	Adds the given force to the net forces acting on the box.
	static addForceVector = function(_v){ netForce.addVector(_v); }
	
	/// @func	integrate({real} dt);
	/// @desc	Integrates the box forward in time by the given duration of time. In other words,
	///			if there are forces acting on the box, it will integrate, or convert the force into
	///			an acceleration, the acceleration into a velocity, and the velocity into a position
	///			given the amount of time.
	static integrate = function(_dt)
	{
		// Make sure time is not zero
		if (_dt <= 0) throw("Integration error. Duration of integration can't be less than or equal to zero!");
		
		// Update position
		owner.x += velocity.x * _dt;
		owner.y += velocity.y * _dt;
		
		// Calculate acceleration
		//var _resultingAccel = acceleration.getCopy();
		//_resultingAccel.addScaledVector(netForce, inverseMass);
		acceleration.set();
		acceleration.addScaledVector(netForce, inverseMass);
		
		// Update velocity
		//velocity.addScaledVector(_resultingAccel, _dt);
		velocity.addScaledVector(acceleration, _dt);
		
		// Apply drag
		velocity.scale(power(damping, _dt));
		
		// Clear forces
		clearNetForce();
	}
}