/// @desc Start Game
if (oGameManager.tutorialComplete) room_goto_next();
else
{
	global.currentLevelName = "First Steps";
	global.previousHubPortalIdx = 0;
	room_goto(rTutorialLevel);
}