#region Human

// Head
draw_sprite(sHumanHead, 0, neckPosition.x, neckPosition.y);

// Body
var _bodyLength = point_distance(neckPosition.x, neckPosition.y, hipPosition.x, hipPosition.y);
var _bodyAngle = point_direction(neckPosition.x, neckPosition.y, hipPosition.x, hipPosition.y);
draw_sprite_ext(sDot, 0, neckPosition.x+0.5, neckPosition.y, _bodyLength, 1, _bodyAngle, c_gray, 1);
//draw_line(neckPosition.x - 1, neckPosition.y - 1, hipPosition.x - 1, hipPosition.y - 1);

// Arms
rightArm.draw();
leftArm.draw();

// Legs
rightLeg.draw();
leftLeg.draw();

#endregion

// Debug mode
if (debugMode) rbDraw();