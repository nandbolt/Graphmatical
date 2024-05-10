#region Human

// Head
draw_sprite(sHumanHead, 0, neckPosition.x, neckPosition.y);

// Body
draw_line(neckPosition.x - 1, neckPosition.y - 1, hipPosition.x - 1, hipPosition.y - 1);

// Arms
rightArm.draw();
leftArm.draw();

// Legs
rightLeg.draw();
leftLeg.draw();

#endregion

// Debug mode
if (debugMode) rbDraw();