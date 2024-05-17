/// @func	charIsDigit({char} char);
/// @desc	Returns if the given character is a digit (0-9).
function charIsDigit(_char)
{
	var _ord = ord(_char);
	return _ord > 47 && _ord < 58;
}