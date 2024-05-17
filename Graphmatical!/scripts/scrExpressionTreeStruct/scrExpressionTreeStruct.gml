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
			
			// Equation scope
			with (other)
			{
				// If not an operator
				if (!charIsOperator(_token))
				{
					// Convert token to value
					var _value = 0;
					if (_token == "x") _value = "x";
					else if (_token == "p") _value = pi;
					else if (_token == "e") _value = 2.72;
					else if (string_digits(_token) != "") _value = real(_token);
					array_push(_nodeStack, new BinaryTreeNode(_token));
				}
				else
				{
					var _right = array_pop(_nodeStack);
					var _left = array_pop(_nodeStack);
					var _newNode = new BinaryTreeNode(_token, _left, _right);
					array_push(_nodeStack, _newNode);
				}
			}
		}
		
		// Set root
		root = array_pop(_nodeStack);
		
		// Destroy stack
		_nodeStack = -1;
	}
	
	/// @func	evaluate({real} input);
	static evaluate = function(_input){}
}