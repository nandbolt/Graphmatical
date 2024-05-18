/// @func	Equation();
function Equation() constructor
{
	// Equation
	expressionString = "";
	expressionTokens = [];
	
	// Expression tree
	expressionTree = new ExpressionTree();
	postfixExpressionTokens = [];
	
	// Graphing
	errorCode = GraphingError.EMPTY;
	errorMessage = "";
	static drawResolution = 0.1;	// The lower the value, the finer the graphs
	graphPath = path_add();
	
	/// @func	cleanup();
	static cleanup = function()
	{
		// Expression tree
		if (is_struct(expressionTree))
		{
			expressionTree.cleanup();
			delete expressionTree;
		}
		
		// Graph
		path_delete(graphPath);
	}
	
	/// @func	set({string} expressionString);
	static set = function(_expressionString="")
	{
		// Set literal string
		expressionString = _expressionString;
		
		// Update tokens + validate expression
		updateExpressionTokens();
			
		// If no graphing error
		if (errorCode == GraphingError.NONE)
		{
			// Update postfix expression
			updatePostfixExpression();
				
			// Cleanup expression tree
			expressionTree.cleanup();
				
			// Set expression tree
			expressionTree.set(postfixExpressionTokens);
				
			// Set graph path
			setGraphPath();
		}
	}
	
	/// @func	drawGraph();
	static drawGraph = function()
	{
		// Draw params
		var _color = c_yellow;
		
		// Loop through path points
		var _pointCount = path_get_number(graphPath);
		for (var _i = 0; _i < _pointCount - 1; _i++)
		{
			// Get point position
			var _x = path_get_point_x(graphPath, _i), _y = path_get_point_y(graphPath, _i);
			var _xNext =path_get_point_x(graphPath, _i + 1), _yNext = path_get_point_y(graphPath, _i + 1);
			var _dx = _xNext - _x, _dy = _yNext - _y;
			var _dir = point_direction(0, 0, _dx, _dy);
			var _len = point_distance(0, 0, _dx, _dy);
			
			// Draw line
			draw_sprite_ext(sDot, 0, _x, _y, _len, 1, _dir, _color, 1);
		}
	}
	
	/// @func	updateExpressionTokens();
	/// @desc	Updates the equation token array using the newly set string literal.
	static updateExpressionTokens = function()
	{
		// Reset tokens
		expressionTokens = [];
		
		// Reset errors
		errorCode = GraphingError.NONE;
		errorMessage = "";
		
		// Remove trailing whitespace
		var _expressionString = string_trim(expressionString);
		
		// Remove in-between whitespace
		_expressionString = string_join_ext("", string_split(_expressionString, " ", true));
		
		// Force lowercase
		_expressionString = string_lower(_expressionString);
		
		// Replace word operators
		_expressionString = string_replace_all(_expressionString, "sin", "s");
		_expressionString = string_replace_all(_expressionString, "cos", "c");
		_expressionString = string_replace_all(_expressionString, "tan", "t");
		_expressionString = string_replace_all(_expressionString, "log", "l");
		_expressionString = string_replace_all(_expressionString, "root", "r");
		
		// Replace word constants
		_expressionString = string_replace_all(_expressionString, "pi", "p");
		
		// Loop through characters
		var _expressionStringLength = string_length(_expressionString)
		for (var _i = 1; _i <= _expressionStringLength; _i++)
		{
			// Get character
			var _char = string_char_at(_expressionString, _i);
			
			// Number + decimal check
			if (charIsDigit(_char) || _char == ".")
			{
				#region Construct Number
				
				// Scan upcoming characters
				var _j = 1, _decimalUsed = false;
				while (_i + _j <= _expressionStringLength)
				{
					// Get next character
					var _nextChar = string_char_at(_expressionString, _i + _j);
					
					// If number or decimal
					if (charIsDigit(_nextChar) || _nextChar == ".")
					{
						#region Multidecimal Check
						
						// If trying to use more than one decimal
						if (_nextChar == ".")
						{
							// If trying to use more than one decimal
							if (_decimalUsed)
							{
								// Update error and exit function
								errorCode = GraphingError.MULTI_DECIMAL;
								errorMessage = "Decimal error: Too many decimals on one number!";
								return;
							}
							// Else first time using decimal
							else _decimalUsed = true;
						}
						
						#endregion
						
						// Add new character to number
						_char += _nextChar;
					}
					// Else if lone decimal
					else if (_char == ".")
					{
						// Update error and exit function
						errorCode = GraphingError.LONE_DECIMAL;
						errorMessage = "Decimal error: Lone decimal!";
						return;
					}
					// Number complete
					else break;
					
					// Increment index
					_j++;
				}
				
				// Increment i based on j
				_i += _j - 1;
				
				// Add to tokens
				array_push(expressionTokens, _char);
				
				#endregion
			}
			// Valid character
			else if (charIsOperator(_char) || charIsConstant(_char) || _char == "x" || _char == "(" || _char == ")")
			{
				// Get info
				var _len = array_length(expressionTokens);
				var _prevChar = "";
				if (_len > 0) _prevChar = expressionTokens[_len - 1];
				
				// Trig
				if ((_char == "s" || _char == "c" || _char == "t") && (_len == 0 || charIsOperator(_prevChar) || _prevChar == "("))
				{
					// Add implied 1 to operator
					array_push(expressionTokens, "1");
				}
				// Log
				else if (_char == "l" && (_len == 0 || charIsOperator(_prevChar)))
				{
					// Add implied log base 10
					array_push(expressionTokens, "10");
				}
				// Root
				else if (_char == "r" && (_len == 0 || charIsOperator(_prevChar)))
				{
					// Add square root
					array_push(expressionTokens, "2");
				}
				// Negative
				else if (_char == "-" && (_len == 0 || charIsOperator(_prevChar) || _prevChar == "("))
				{
					// Add implied 0
					array_push(expressionTokens, "0");
				}
				
				// Add to tokens
				array_push(expressionTokens, _char);
			}
			else
			{
				#region Unknown Symbol
				
				// Update error and exit function
				errorCode = GraphingError.UNKNOWN_SYMBOL;
				errorMessage = "Unknown symbol error: Can't interpret the symbol `" + _char + "`!";
				return;
				
				#endregion
			}
			
			// If constant value and not last character in string
			if ((charIsConstant(_char) || _char == ".") && _i < _expressionStringLength)
			{
				// Get next character
				var _nextChar = string_char_at(_expressionString, _i + 1);
				
				// If next character is x, a constant, or an open parenthesis
				if (_nextChar == "x" || _nextChar == "p" || _nextChar == "e" || _nextChar == "(")
				{
					// Add implied multiplication
					array_push(expressionTokens, "*");
				}
			}
		}
		
		// If empty
		if (array_length(expressionTokens) == 0)
		{
			// Update error
			errorCode = GraphingError.EMPTY;
			//errorMessage = "Empty error: Empty equation inputted!";
		}
		// Single character expression
		else if (array_length(expressionTokens) == 1)
		{
			// If decimal
			if (expressionTokens[0] == ".")
			{
				// Update error and exit function
				errorCode = GraphingError.LONE_DECIMAL;
				errorMessage = "Decimal error: Lone decimal!";
				return;
			}
			// Else if operator or parenthesis
			else if (charIsOperator(expressionTokens[0]))
			{
				// Update error and exit function
				errorCode = GraphingError.LONE_OPERATOR;
				errorMessage = "Operator error: Lone operator!";
				return;
			}
			// Else if parenthesis
			else if (expressionTokens[0] == "(" || expressionTokens[0] == ")")
			{
				// Update error and exit function
				errorCode = GraphingError.LONE_PARENTHESIS;
				errorMessage = "Parenthesis error: Lone parenthesis!";
				return;
			}
			
			// Add implied zero addition
			array_push(expressionTokens, "+", "0");
		}
		
		#region Validate Expression
		
		// Token check
		var _parenthesisSum = 0;		// Parenthesis must sum to 0 where an ( maps to +1 and a ) maps to -1
		var _parenthesesEmpty = false;	// Parentheses must enclose something ({something})
		var _hasValue = false;			// Must have value somewhere
		
		// Loop through tokens
		for (var _i = 0; _i < array_length(expressionTokens); _i++)
		{
			// Open parenthesis
			if (expressionTokens[_i] == "(")
			{
				// Add to sum
				_parenthesisSum++;
				
				// Empty parentheses so far
				_parenthesesEmpty = true;
			}
			// Closed parenthesis
			else if (expressionTokens[_i] == ")")
			{
				// If parenthesis empty
				if (_parenthesesEmpty)
				{
					// Update error and exit function
					errorCode = GraphingError.EMPTY_PARENTHESES;
					errorMessage = "Parenthesis error: Empty parentheses!";
					return;
				}
				
				// Decrement sum
				_parenthesisSum--;
			}
			else
			{
				// If has no value yet and arrived at something of value (x or a constant value)
				if (!_hasValue && (expressionTokens[_i] == "x" || charIsConstant(expressionTokens[_i]) || string_digits(expressionTokens[_i]) != ""))
				{
					// Set has value
					_hasValue = true;
				}
				
				// Something in parentheses
				_parenthesesEmpty = false;
			}
			
			// If negative sum
			if (_parenthesisSum < 0)
			{
				// Update error and exit function
				errorCode = GraphingError.EMPTY_PARENTHESES;
				errorMessage = "Parenthesis error: Incorrect order!";
				return;
			}
		}
		
		// If not zero sum
		if (_parenthesisSum != 0)
		{
			// Update error and exit function
			errorCode = GraphingError.MISSING_PARENTHESES;
			errorMessage = "Parenthesis error: Missing a parenthesis!";
			return;
		}
		
		// Value check
		if (!_hasValue)
		{
			// Update error and exit function
			errorCode = GraphingError.MISSING_PARENTHESES;
			errorMessage = "Value error: No constants or variables!";
			return;
		}
		
		#endregion
	}
	
	/// @func	updatePostfixExpression();
	/// @desc	Converts the validated expression (infix) into a postfix expression which can be converted into an expression tree.
	static updatePostfixExpression = function()
	{
		// Reset postfix expression
		postfixExpressionTokens = [];
		
		// Init stack of operators used to determine order of operations
		var _operatorStack = [];
		
		// Scan infix expression
		for (var _i = 0; _i < array_length(expressionTokens); _i++)
		{
			// Get token
			var _token = expressionTokens[_i];
			var _isOperator = charIsOperator(expressionTokens[_i]);
			
			// Append token to expression if operand (not an operator)
			if (!_isOperator && _token != "(" && _token != ")") array_push(postfixExpressionTokens, _token);
			// Push onto operator stack if opening parenthesis
			else if (_token == "(") array_push(_operatorStack, _token);
			// If closing parenthesis
			else if (_token == ")")
			{
				// Pop stack until corresponding left parenthesis is removed, append each operator to end of output list
				var _topToken = array_pop(_operatorStack);
				while (_topToken != "(")
				{
					array_push(postfixExpressionTokens, _topToken);
					_topToken = array_pop(_operatorStack);
				}
			}
			// Else token is an operator
			else
			{
				// Remove any operators already in stack that have higher or equal precedence and append them to output list, then push token to stack
				while (array_length(_operatorStack) > 0 && 
					  (oGrapher.precedenceMap[? _operatorStack[array_length(_operatorStack) - 1]] >= oGrapher.precedenceMap[? _token]))
				{
					array_push(postfixExpressionTokens, array_pop(_operatorStack));
				}
				array_push(_operatorStack, _token);
			}
		}
		
		// Add remaining operators on stack to output list
		while (array_length(_operatorStack) > 0) array_push(postfixExpressionTokens, array_pop(_operatorStack));
		
		// Cleanup stack
		_operatorStack = -1;
	}
	
	/// @func	setGraphPath();
	static setGraphPath = function()
	{
		// Clear points
		path_clear_points(graphPath);
		
		// Loop through domain
		for (var _ax = other.lowerDomain; _ax <= other.upperDomain; _ax += drawResolution)
		{
			// Get equation output
			var _ay = evaluate(_ax);
			
			// If axis y value is within range
			if (_ay >= other.lowerRange && _ay <= other.upperRange)
			{
				// Convert axes values to world coordinates and add to path
				path_add_point(graphPath, axisXtoX(other, _ax), axisYtoY(other, _ay), 100);
			}
		}
	}
	
	/// @func	evaluate({real} input);
	static evaluate = function(_input)
	{
		return expressionTree.evaluate(_input, expressionTree.root);
	}
}