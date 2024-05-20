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
			// Get quotient
			var _quotient = _leftValue / _rightValue;
			
			// Divide by zero + undefined error
			if (_quotient == infinity) throw("Evaluation error: division by zero!");
			else if (is_nan(_quotient)) throw("Evaluation error: undefined division!");
			
			// Add to value
			_value += _leftValue / _rightValue;
		}
		else if (_node.data = "^")
		{
			// Get power
			_leftValue = -1;
			_rightValue = 1/2;
			var _power = power(_leftValue, _rightValue);
			
			// Negative base + fractional exponent error
			if (is_nan(_power)) throw("Evaluation error: negative base + fractional exponent!");
			
			// Add value
			_value += _power;
		}
		else if (_node.data == "s") _value += _leftValue * sin(_rightValue);
		else if (_node.data == "c") _value += _leftValue * cos(_rightValue);
		else if (_node.data == "g")
		{
			// Get tangent
			var _tan = _leftValue * tan(_rightValue);
			
			// Divide by zero
			if (_tan == infinity) throw("Evaluation error: infinite tangent!");
			
			// Add to value
			_value += _tan;
		}
		else if (_node.data == "l")
		{
			// Get log
			var _log = logn(_leftValue, _rightValue);
			
			// Negative base
			if (is_nan(_log)) throw("Evaluation error: negative log!");
			
			// Add to value
			_value += _log;
		}
		else if (_node.data == "r")
		{
			// Get root
			var _root = power(_rightValue, 1 / _leftValue)
			
			// Negative root
			if (is_nan(_root)) throw("Evaluation error: negative root!");
			
			// Add to value
			_value += _root;
		}
		
		// Return value
		return _value;
	}
}