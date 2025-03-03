// Update rigid body movements
rbUpdate();

// Set angular velocity
if (circleTorque != 0)
{
	angularVelocity = circleTorque;
}

// Set angle
if (angularVelocity != 0 && velocity.getLength() > 0) imageAngle += angularVelocity;