/// @func	inArray({Array} array, {Any} value)
/// @desc	Returns whether the given value is within the array.
function inArray(_array, _value)
{
	// Loop through array
	for (var _i = 0; _i < array_length(_array); _i++)
	{
		// Found value
		if (_array[_i] == _value) return true;
	}
	
	// Nothing found
	return false;
}