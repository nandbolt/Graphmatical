/// @func	BEForceRegistry();
/// @desc	Holds force generators and the boxes they apply to.
function BEForceRegistry() constructor
{
	// Force registrations
	registrations = [];
	
	/// @func	getRegistrationCount();
	/// @desc	Returns how many force generators are in the registry.
	static getRegistrationCount = function(){ return array_length(registrations); }
	
	/// @func	add({Struct.BEBox} box, {Struct.BEForceGen} forceGen);
	static add = function(_box, _forceGen)
	{
		// Add new force registration to the registry
		array_push(registrations, new BEForceRegistration(_box, _forceGen));
	}
	
	/// @func	remove({Struct.BEBox} box, {Struct.BEForceGen} forceGen);
	/// @desc	Removes the registration if it is found in the registry.
	static remove = function(_box, _forceGen)
	{
		// Loop through registry
		for (var _i = 0; _i < array_length(registrations); _i++)
		{
			// If registration found
			var _reg = registrations[_i];
			if (_reg.box == _box && _reg.forceGen == _forceGen)
			{
				// Delete registration and return
				delete _reg;
				array_delete(registrations, _i, 1);
				return;
			}
		}
	}
	
	/// @func	clear();
	///	@desc	Clears all force registrations from the registry.
	static clear = function()
	{
		// Loop through registry
		for (var _i = 0; _i < array_length(registrations); _i++)
		{
			// Delete registration
			delete registrations[_i];
		}
		
		// Reset registrations array
		registrations = [];
	}
	
	/// @func	updateForces({real} dt);
	/// @desc	Applies the registered force generators to their given boxes.
	static updateForces = function(_dt)
	{
		// Loop through registry
		for (var _i = 0; _i < array_length(registrations); _i++)
		{
			// Apply force generator to particle
			var _reg = registrations[_i];
			_reg.forceGen.updateForce(_reg.box, _dt);
		}
	}
}

/// @func	BEForceRegistration({Struct.BEBox} box, {Struct.BEForceGen} forceGen);
/// @desc	Holds a single force generator and box registration.
function BEForceRegistration(_box=undefined, _forceGen=undefined) constructor
{
	box = _box;
	forceGen = _forceGen;
}