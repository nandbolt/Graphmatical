#region Macros

#macro TILE_SIZE 16
#macro HALF_TILE_SIZE 8
#macro INVERSE_TILE_SIZE .0625
#macro SQRT_2BY2 sqrt(2) / 2

#endregion

#region Global Variables

// Level
global.currentLevelName = "Hub";
global.currentLevelCreator = "";
global.previousHubPortalIdx = -1;
global.editMode = false;
global.customLevelIdx = -1;

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

enum WalkerAnimationState
{
	IDLE,
	CRAWL,
	FALL,
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

enum GraphType
{
	NORMAL,
	LASER,
	BOUNCY,
}

#endregion