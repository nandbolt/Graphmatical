// Rotate towards velocity
var _dir = box.getVelocity().angleDegrees();
image_angle += angle_difference(_dir, image_angle) * 0.1;