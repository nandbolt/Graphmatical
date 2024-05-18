/// @func	print({Any} value);
function print(_value="")
{
	show_debug_message(_value);
}

/// @func	charIsDigit({char} char);
/// @desc	Returns if the given character is a digit (0-9).
function charIsDigit(_char)
{
	var _ord = ord(_char);
	return _ord > 47 && _ord < 58;
}

/// @func	charIsOperator({char} char);
///	@desc	Returns if the character is a math operator.
function charIsOperator(_char)
{
	return _char == "+" || _char == "-" || _char == "*" || _char == "/" || _char == "^" ||
		_char == "s" || _char == "c" || _char == "t" || _char == "l" || _char == "r";
}
	
/// @func	charIsConstant({char} char);
///	@desc	Returns if the character is a constant value.
function charIsConstant(_char)
{
	return _char == "p" || _char == "e" || string_digits(_char) != "";
}