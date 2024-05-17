/// @func	Equation();
function Equation() constructor
{
	// Equation
	equationString = "";
	equationTokens = [];
	
	// Expression tree
	expressionTree = new ExpressionTree();
	postfixExpression = "";
	
	// Graphing
	errorCode = GraphingError.EMPTY;
	errorMessage = "";
	
	/// @func	cleanup();
	static cleanup = function()
	{
		// Expression tree
		expressionTree.destroyTree(expressionTree.root);
		delete expressionTree;
	}
	
	/// @func	set({string} equationString);
	static set = function(_equationString="")
	{
		// If different value
		if (_equationString != equationString)
		{
			// Set literal string
			equationString = _equationString;
		
			// Update tokens
			updateEquationTokens();
			
			// If no graphing error
			if (errorCode == GraphingError.NONE)
			{
				// Update expression tree
			}
			else
			{
				// Print error
				show_debug_message("GRAPHING ERROR: CODE " + string(errorCode));
				show_debug_message(errorMessage);
			}
		
			// Debug print
			show_debug_message("EQ Set");
			show_debug_message("EQ string: " + equationString);
			show_debug_message("EQ tokens: " + string(equationTokens));
		}
	}
	
	/// @func	charIsOperator({char} char);
	static charIsOperator = function(_char)
	{
		return _char == "+" || _char == "-" || _char == "*" || _char == "/" || _char == "^" ||
		   _char == "s" || _char == "c" || _char == "t" || _char == "l" || _char == "r";
	}
	
	/// @func	charIsConstant({char} char);
	static charIsConstant = function(_char)
	{
		return _char == "p" || _char == "e";
	}
	
	/// @func	drawGraph();
	static drawGraph = function()
	{
		draw_circle(other.x, other.y, 32, true);
	}
	
	/// @func	graphEquation();
	static graphEquation = function()
	{
		// Debug message
		show_debug_message("Equation graphed!");
	}
	
	/// @func	updateEquationTokens();
	/// @desc	Updates the equation token array using the newly set string literal.
	static updateEquationTokens = function()
	{
		// Reset tokens
		equationTokens = [];
		
		// Reset errors
		errorCode = GraphingError.NONE;
		errorMessage = "";
		
		// Remove trailing whitespace
		var _equationString = string_trim(equationString);
		
		// Remove in-between whitespace
		_equationString = string_join_ext("", string_split(_equationString, " ", true));
		
		// Force lowercase
		_equationString = string_lower(_equationString);
		
		// Replace word operators
		_equationString = string_replace(_equationString, "sin", "s");
		_equationString = string_replace(_equationString, "cos", "c");
		_equationString = string_replace(_equationString, "tan", "t");
		_equationString = string_replace(_equationString, "log", "l");
		_equationString = string_replace(_equationString, "root", "r");
		
		// Replace word constants
		_equationString = string_replace(_equationString, "pi", "p");
		
		// Loop through characters
		var _equationStringLength = string_length(_equationString)
		for (var _i = 1; _i <= _equationStringLength; _i++)
		{
			// Get character
			var _char = string_char_at(_equationString, _i);
			var _isDigit = false;
			
			// Number + decimal check
			if (charIsDigit(_char) || _char == ".")
			{
				#region Construct Number
				
				// Set digit bool (for constant check)
				_isDigit = true;
				
				// Scan upcoming characters
				var _j = 1, _decimalUsed = false;
				while (_i + _j <= _equationStringLength)
				{
					// Get next character
					var _nextChar = string_char_at(_equationString, _i + _j);
					
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
				array_push(equationTokens, _char);
				
				#endregion
			}
			// Valid character
			else if (charIsOperator(_char) || charIsConstant(_char) || _char == "x" || _char == "(" || _char == ")")
			{
				// Trig
				if ((_char == "s" || _char == "c" || _char == "t") &&	// Trig operator
					(array_length(equationTokens) == 0 ||				// 1st token					
					 charIsOperator(equationTokens[_i-2]) ||			// Previous token was an operator
					 equationTokens[_i-2] == "("))						// Previous token was an open parenthesis
				{
					// Add implied 1 to operator
					array_push(equationTokens, "1");
				}
				// Log
				else if (_char == "l" &&								// Log operator
						(array_length(equationTokens) == 0 ||			// 1st token	
						 charIsOperator(equationTokens[_i-2])))			// Previous token was an operator
				{
					// Add implied log base 10
					array_push(equationTokens, "10");
				}
				// Root
				else if (_char == "r" &&								// Root operator
						(array_length(equationTokens) == 0 ||			// 1st token	
						 charIsOperator(equationTokens[_i-2])))			// Previous token was an operator
				{
					// Add square root
					array_push(equationTokens, "2");
				}
				// Negative
				else if (_char == "-" &&								// Minus operator
					(array_length(equationTokens) == 0 ||				// 1st token					
					 charIsOperator(equationTokens[_i-2]) ||			// Previous token was an operator
					 equationTokens[_i-2] == "("))						// Previous token was an open parenthesis
				{
					// Add implied 0
					array_push(equationTokens, "0");
				}
				
				// Add to tokens
				array_push(equationTokens, _char);
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
			if ((charIsConstant(_char) || _isDigit || _char == ".") && _i < _equationStringLength)
			{
				// Get next character
				var _nextChar = string_char_at(_equationString, _i + 1);
				
				// If next character is x, a constant, or an open parenthesis
				if (_nextChar == "x" || _nextChar == "(" || charIsConstant(_char))
				{
					// Add implied multiplication
					array_push(equationTokens, "*");
				}
			}
		}
		
		// If empty
		if (array_length(equationTokens) == 0)
		{
			// Update error
			errorCode = GraphingError.EMPTY;
			//errorMessage = "Empty error: Empty equation inputted!";
		}
		// Single character expression
		else if (array_length(equationTokens) == 1)
		{
			// If decimal
			if (_char == ".")
			{
				// Update error and exit function
				errorCode = GraphingError.LONE_DECIMAL;
				errorMessage = "Decimal error: Lone decimal!";
				return;
			}
			// Else if operator or parenthesis
			else if (charIsOperator(_char))
			{
				// Update error and exit function
				errorCode = GraphingError.LONE_OPERATOR;
				errorMessage = "Operator error: Lone operator!";
				return;
			}
			// Else if parenthesis
			else if (_char == "(" || _char == ")")
			{
				// Update error and exit function
				errorCode = GraphingError.LONE_PARENTHESIS;
				errorMessage = "Parenthesis error: Lone parenthesis!";
				return;
			}
			
			// Add implied zero addition
			array_push(equationTokens, "+", "0");
		}
	}
}