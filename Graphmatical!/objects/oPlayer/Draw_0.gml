#region Human

// Head
draw_sprite(sHumanHead, 0, x, y - 4)

// Body
draw_line(x + neckOffset.x - 1, y + neckOffset.y - 1, x + hipOffset.x - 1, y + hipOffset.y - 1);

// Left leg
draw_line(x + hipOffset.x - 1, y + hipOffset.y - 1, x + leftKneeOffset.x - 1, y + leftKneeOffset.y - 1);
draw_line(x + leftKneeOffset.x - 1, y + leftKneeOffset.y - 1, x + leftFootOffset.x - 1, y + leftFootOffset.y - 1);

// Right leg
draw_line(x + hipOffset.x - 1, y + hipOffset.y - 1, x + rightKneeOffset.x - 1, y + rightKneeOffset.y - 1);
draw_line(x + rightKneeOffset.x - 1, y + rightKneeOffset.y - 1, x + rightFootOffset.x - 1, y + rightFootOffset.y - 1);

// Left arm
draw_line(x + neckOffset.x - 1, y + neckOffset.y - 1, x + leftElbowOffset.x - 1, y + leftElbowOffset.y - 1);
draw_line(x + leftElbowOffset.x - 1, y + leftElbowOffset.y - 1, x + leftHandOffset.x - 1, y + leftHandOffset.y - 1);

// Right arm
draw_line(x + neckOffset.x - 1, y + neckOffset.y - 1, x + rightElbowOffset.x - 1, y + rightElbowOffset.y - 1);
draw_line(x + rightElbowOffset.x - 1, y + rightElbowOffset.y - 1, x + rightHandOffset.x - 1, y + rightHandOffset.y - 1);

#endregion

// Debug mode
if (debugMode) rbDraw();