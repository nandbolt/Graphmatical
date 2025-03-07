// Init image angle
if (imageAngle > 180) imageAngle -= 360;
if (!(imageAngle > -90 && imageAngle < 90)) inputDirection.x = -1;