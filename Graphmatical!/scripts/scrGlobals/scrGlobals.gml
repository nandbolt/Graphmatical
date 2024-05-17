#region Macros

#macro TILE_SIZE 16
#macro HALF_TILE_SIZE 8

#endregion

#region Global Variables

#endregion

#region Enums

enum HumanAnimationState
{
	IDLE,
	RUN,
	CROUCH,
	SLIDE,
	FALL,
	JUMP,
}

enum GrapherState
{
	INIT,
	CHOOSE,
	EDIT,
}

enum GraphingError
{
	NONE,
	EMPTY,
	LONE_DECIMAL,
	MULTI_DECIMAL,
	UNKNOWN_SYMBOL,
	LONE_OPERATOR,
	LONE_PARENTHESIS,
	EMPTY_PARENTHESES,
	FLIPPED_PARENTHESES,
	MISSING_PARENTHESES,
	NO_VALUE,
}

#endregion