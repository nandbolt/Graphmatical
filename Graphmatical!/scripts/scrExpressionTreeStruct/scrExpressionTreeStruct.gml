/// @func	ExpressionTree();
function ExpressionTree() : BinaryTree() constructor
{
	/// @func	set({array} postfixExpression);
	static set = function(_postfixExpression)
	{
		// Create stack/init current node
		var _nodeStack = [];
		
		// Loop through expression
		for (var _i = 0; _i < array_length(_postfixExpression); _i++)
		{
			// Get token
			var _token = _postfixExpression[_i];
			
			// If not an operator
			if (!charIsOperator(_token))
			{
				// Convert token to value
				var _value = 0;
				if (_token == "x") _value = "x";
				else if (_token == "p") _value = pi;
				else if (_token == "e") _value = 2.72;
				else if (string_digits(_token) != "") _value = real(_token);
				array_push(_nodeStack, new BinaryTreeNode(_value));
			}
			else
			{
				var _right = array_pop(_nodeStack);
				var _left = array_pop(_nodeStack);
				var _newNode = new BinaryTreeNode(_token, _left, _right);
				array_push(_nodeStack, _newNode);
			}
		}
		
		// Set root
		root = array_pop(_nodeStack);
		
		// Destroy stack
		_nodeStack = -1;
	}
	
	/// @func	evaluate({Real} input, {Struct.BinaryTreeNode} node);
	static evaluate = function(_input, _node)
	{
		// 0 if empty node
		if (_node == noone) return 0;
		
		// Number
		if (is_real(_node.data)) return _node.data;
		
		// X
		if (_node.data == "x") return _input;
		
		// Get values
		var _leftValue = evaluate(_input, _node.children[0]);
		var _rightValue = evaluate(_input, _node.children[1]);
		var _value = 0;
		
		// Operators
		if (_node.data == "+") _value += _leftValue + _rightValue;
		else if (_node.data == "-") _value += _leftValue - _rightValue;
		else if (_node.data == "*") _value += _leftValue * _rightValue;
		else if (_node.data == "/")
		{
			// Account for divide by zero error
			if (_rightValue == 0) _rightValue = 0.01;
			_value += _leftValue / _rightValue;
		}
		else if (_node.data = "^")
		{
			// Apparently left values can't be negative
			var _power = power(_leftValue * sign(_leftValue), _rightValue);
			_value += _power;
		}
		else if (_node.data == "s") _value += _leftValue * sin(_rightValue);
		else if (_node.data == "c") _value += _leftValue * cos(_rightValue);
		else if (_node.data == "t")
		{
			// Account for divide by zero error
			var _cosine = cos(_rightValue);
			if (_cosine == 0) _cosine = 0.01;
			_value += _leftValue * (sin(_rightValue) / _cosine);
		}
		else if (_node.data == "l")
		{
			// Account for invalid log domain (right value <= 0)
			if (_rightValue <= 0) _rightValue = 0.01;
			_value += logn(_leftValue, _rightValue);
		}
		else if (_node.data == "r")
		{
			// Account for divide by zero and negative root error
			_leftValue = floor(_leftValue);
			var _sign = 1;
			if (_leftValue == 0) _leftValue = 1;
			if (_rightValue < 0)
			{
				// Even root, cannot have negative root
				if (_leftValue mod 2 == 0) _rightValue = 0;
				// Odd root, add negative sign to end
				else
				{
					_sign = -1;
					_rightValue *= _sign
				}
			}
			_value += power(_rightValue, 1 / _leftValue) * _sign;
		}
		
		// Return value
		return _value;
	}
}