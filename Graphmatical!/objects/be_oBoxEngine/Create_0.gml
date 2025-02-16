/// @desc Init Simulation

/*
Box Engine
created by nandbolt
(Box Engine GitHub: https://github.com/nandbolt/Box-Engine)

Heavily utilized the book "Game Physics: Engine Development" by Ian Millington to develop this engine.
(Ian Millington's Cyclone engine source code: https://github.com/idmillington/cyclone-physics/tree/master)

Keeps track of and updates all boxes in the simulation.
*/

// World
boxes = [];											// All of the boxes in the simulation.
maxContacts = 32;									// The given number of contacts per frame the simulation can handle.
iterations = maxContacts * 2;						// The number of contact iterations used.
calculateIterations	= (iterations == 0);			// Whether the number of iterations to for contact resolver should be calculated every frame.
registry = new BEForceRegistry();					// The force registry.
resolver = new BEContactResolver(iterations);		// The contact resolver.
contactGens = [];									// The contact generators.
contacts = array_create(maxContacts, undefined);	// The list of contacts.
for (var _i = 0; _i < array_length(contacts); _i++)	// Init list of contacts.
{
	contacts[_i] = new BEContact();
}
nextContactIdx = 0;									// The current contact write position.

#region Functions

/// @func	startFrame();
/// @desc	Gets boxes ready to be processed.
startFrame = function()
{
	// Loop through boxes
	for (var _i = 0; _i < array_length(boxes); _i++)
	{
		// Clear forces
		boxes[_i].clearNetForce();
	}
}

/// @func	generateContacts();
/// @desc	Calls all registered contact generators to report their contacts. Returns number of contacts.
generateContacts = function()
{
	var _limit = maxContacts;
	
	// Init next contact
	nextContactIdx = 0;
	
	// Loop through contact generators
	for (var _i = 0; _i < array_length(contactGens); _i++)
	{
		// Add contact to contact generator (???)
		var _used = contactGens[_i].addContact(nextContactIdx, _limit);
		_limit -= _used;
		nextContactIdx += _used;
		
		// Break if ran out of contacts to fill, meaning we're missing contacts.
		if (_limit <= 0) break;
	}
	
	return maxContacts - _limit;
}

/// @func	integrate({real} dt);
/// @desc	Moves each box forward in time.
integrate = function(_dt)
{
	// Loop through boxes
	for (var _i = 0; _i < array_length(boxes); _i++)
	{
		// Integrate each box in time
		boxes[_i].integrate(_dt);
	}
}

/// @func	runPhysics({real} dt);
/// @desc	Runs a physics update on the simulation.
runPhysics = function(_dt)
{
	// Apply force generators
	registry.updateForces(_dt);
	
	// Integrate objects
	integrate(_dt);
	
	// Generate contacts
	var _usedContacts = generateContacts();
	
	// Process contacts
	if (_usedContacts > 0)
	{
		if (calculateIterations) resolver.setIterations(_usedContacts * 2);
		resolver.resolveContacts(contacts, _usedContacts, _dt);
	}
}

/// @func	removeBox({Struct.BEBox} box);
/// @desc	Removes a box from the simulation.
removeBox = function(_box)
{
	// Loop through boxes
	for (var _i = 0; _i < array_length(boxes); _i++)
	{
		// If found box position
		if (boxes[_i] == _box)
		{
			// Remove box from array
			array_delete(boxes, _i, 1);
		}
	}
}

#endregion