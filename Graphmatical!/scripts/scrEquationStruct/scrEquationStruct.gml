/// @func	Equation({Id.Instance} axes);
function Equation(_axes) constructor
{
	// Equation
	expressionString = "";
	expressionTokens = [];
	
	// Expression tree
	expressionTree = new ExpressionTree();
	postfixExpressionTokens = [];
	
	// Graphing
	axes = _axes;
	errorCode = GraphingError.EMPTY;
	errorMessage = "";
	static drawResolution = 0.1;	// The lower the value, the finer the graphs
	xGraphPaths = [];
	yGraphPaths = [];
	
	// Time
	hasTime = false;
	timeOrigin = 0;
	
	/// @func	isEmpty();
	static isEmpty = function()
	{
		return array_length(expressionTokens) == 0;
	}
	
	/// @func	cleanup();
	static cleanup = function()
	{
		// Expression tree
		if (is_struct(expressionTree))
		{
			expressionTree.cleanup();
			delete expressionTree;
		}
		
		// Graph paths
		clearGraphPaths();
		xGraphPaths = -1;
		yGraphPaths = -1;
	}
	
	/// @func	clearGraphPaths();
	static clearGraphPaths = function()
	{
		// Graph paths
		for (var _i = 0; _i < array_length(xGraphPaths); _i++) xGraphPaths[_i] = -1;
		for (var _i = 0; _i < array_length(yGraphPaths); _i++) yGraphPaths[_i] = -1;
		xGraphPaths = [];
		yGraphPaths = [];
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
	
	/// @func	draw();
	static draw = function()
	{
		// Loop through paths
		var _pathCount = array_length(xGraphPaths);
		for (var _i = 0; _i < _pathCount; _i++)
		{
			// Plot path
			plot(xGraphPaths[_i], yGraphPaths[_i]);
		}
	}
	
	/// @func	update();
	static update = function()
	{
		// Return if no time
		if (!hasTime) return;
		
		// Increment time
		expressionTree.time = current_time * 0.001 - timeOrigin;
		
		// Set equation again
		set(expressionString);
	}
	
	/// @func	plot({array} xs, {array} ys, {color} color, {real} alpha, {int} style, {sprite} lineSprite);
	static plot = function(_xs, _ys, _color=c_white, _alpha=1, _style=0, _lineSprite=sDot)
	{
		// Array must be the same size
		var _xCount = array_length(_xs), _yCount = array_length(_ys);
		if (_xCount != _yCount) return;
		
		// Loop through values
		for (var _i = 0; _i < _xCount - 1; _i++)
		{
			// Draw line
			var _x1 = _xs[_i], _y1 = _ys[_i], _x2 = _xs[_i+1], _y2 = _ys[_i+1];
			var _dir = point_direction(_x1, _y1, _x2, _y2);
			var _len = point_distance(_x1, _y1, _x2, _y2);
			draw_sprite_ext(_lineSprite, 0, _x1, _y1, _len, 1, _dir, _color, _alpha);
			
			// Style (for dotted lines)
			if (_style != 0) _i++;
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
		var _split = string_split(_expressionString, " ", true);
		_expressionString = "";
		for (var _i = 0; _i < array_length(_split); _i++) _expressionString += _split[_i];
		
		// Force lowercase
		_expressionString = string_lower(_expressionString);
		
		// Replace word operators
		_expressionString = string_replace_all(_expressionString, "sin", "s");
		_expressionString = string_replace_all(_expressionString, "cos", "c");
		_expressionString = string_replace_all(_expressionString, "tan", "g");
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
			else if (charIsOperator(_char) || charIsConstant(_char) || _char == "x" || _char == "t" || _char == "(" || _char == ")")
			{
				// Get info
				var _len = array_length(expressionTokens);
				var _prevChar = "";
				if (_len > 0) _prevChar = expressionTokens[_len - 1];
				
				// Trig
				if ((_char == "s" || _char == "c" || _char == "g") && (_len == 0 || charIsOperator(_prevChar) || _prevChar == "("))
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
				if (_nextChar == "x" || _nextChar == "t" || _nextChar == "p" || _nextChar == "e" || _nextChar == "(")
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
				if (!_hasValue && (expressionTokens[_i] == "x" || expressionTokens[_i] == "t" || charIsConstant(expressionTokens[_i]) || string_digits(expressionTokens[_i]) != ""))
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
		
		// Update time
		var _prevHadTime = hasTime;
		hasTime = string_pos("t", _expressionString) != 0;
		if (hasTime && !_prevHadTime) setTimeOrigin();
	}
	
	/// @func	setTimeOrigin();
	static setTimeOrigin = function()
	{
		timeOrigin = current_time * 0.001;
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
					  (oWorld.precedenceMap[? _operatorStack[array_length(_operatorStack) - 1]] >= oWorld.precedenceMap[? _token]))
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
	/// @desc	Sets the points that will be used for drawing the graph.
	static setGraphPath = function()
	{
		// Clear points
		clearGraphPaths();
		
		// Init first path
		var _idx = 0, _newPathStarted = false;
		
		// Loop through domain
		for (var _ax = axes.lowerDomain; _ax <= axes.upperDomain; _ax += drawResolution)
		{
			// Get equation output
			var _ay = evaluate(_ax);
			
			// Continue if error
			if (is_string(_ay)) continue;
			
			// If axis y value is within range
			if (_ay >= axes.lowerRange && _ay <= axes.upperRange)
			{
				// If start of new path
				if (!_newPathStarted)
				{
					// Add a new path
					array_push(xGraphPaths, []);
					array_push(yGraphPaths, []);
					
					// If first point is not near the edge
					if (axes.upperRange - abs(_ay) > 0.1 && axes.upperDomain - abs(_ax) > 0.1)
					{
						#region Left Clamped Point
					
						// Calcuate out of bounds axis values
						var _axOut = _ax - drawResolution;
						var _ayOut = evaluate(_axOut);
					
						// If previous point was not an error
						if (!is_string(_ayOut))
						{
							// Init edge axis values
							var _axEdge = _ax, _ayEdge = _ay;
							var _dir = point_direction(_ax, _ay * -1, _axOut, _ayOut * -1);
					
							// Loop 100 times just in case
							var _incr = 0.05;
							for (var _i = 0; _i < 100; _i++)
							{
								// Move edge values closer to out of bounds value
								var _dx = dcos(_dir) * _incr, _dy = dsin(_dir) * _incr;
								_axEdge += _dx;
								_ayEdge += _dy;
						
								// If edge is now out of bounds
								if (axes.upperRange - abs(_ayEdge) < 0 || axes.upperDomain - abs(_axEdge) < 0) break;
							}
					
							// Add edge value
							array_push(xGraphPaths[_idx], axisXtoX(axes, _axEdge));
							array_push(yGraphPaths[_idx], axisYtoY(axes, _ayEdge));
						}
					
						#endregion
					}
				}
				
				// Convert axes values to world coordinates and add to path
				array_push(xGraphPaths[_idx], axisXtoX(axes, _ax));
				array_push(yGraphPaths[_idx], axisYtoY(axes, _ay));
				
				// Set new path started
				_newPathStarted = true;
			}
			else if (_newPathStarted)
			{
				// Set out of bounds axis values
				var _axOut = _ax;
				var _ayOut = _ay;
				
				// Calculate previous axis values
				_ax -= drawResolution;
				_ay = evaluate(_ax);
				
				// If start of new path and first point is not near the edge
				if (!is_string(_ay) && axes.upperRange - abs(_ay) > 0.1 && axes.upperDomain - abs(_ax) > 0.1)
				{
					#region Right Clamped Point
					
					// Init edge axis values
					var _axEdge = _ax, _ayEdge = _ay;
					var _dir = point_direction(_ax, _ay * -1, _axOut, _ayOut * -1);
					
					// Loop 100 times just in case
					var _incr = 0.05;
					for (var _i = 0; _i < 100; _i++)
					{
						// Move edge values closer to out of bounds value
						var _dx = dcos(_dir) * _incr, _dy = dsin(_dir) * _incr;
						_axEdge += _dx;
						_ayEdge += _dy;
						
						// If edge is now out of bounds
						if (axes.upperRange - abs(_ayEdge) < 0 || axes.upperDomain - abs(_axEdge) < 0) break;
					}
					
					// Add edge value
					array_push(xGraphPaths[_idx], axisXtoX(axes, _axEdge));
					array_push(yGraphPaths[_idx], axisYtoY(axes, _ayEdge));
					
					#endregion
				}
				
				// Increment index
				_idx++;
				
				// Reset new path started
				_newPathStarted = false;
			}
		}
	}
	
	/// @func	evaluate({real} input);
	/// @desc	Evaluates the equation at the input and returns the output. If there is a math error, return an error code (string).
	static evaluate = function(_input)
	{
		// Init value
		var _value = 0;
		
		// Try to...
		try
		{
			// Evaluate function at input
			_value = expressionTree.evaluate(_input, expressionTree.root);
		}
		// Catch any math errors
		catch(_exception)
		{
			// Set value to exception (string)
			_value = _exception;
		}
		
		// Return value
		return _value;
	}
}