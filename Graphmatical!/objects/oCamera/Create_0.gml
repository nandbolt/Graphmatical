// Dimensions
camWidth = oDisplayManager.baseCamWidth;
camHeight = oDisplayManager.baseCamHeight;
halfCamWidth = camWidth * 0.5;
halfCamHeight = camHeight * 0.5;

// Follow
targetPosition = new Vector2();
followAcceleration = 0.25;

// Init camera
view_enabled = true;
view_visible[0] = true;
camera_set_view_size(view_camera[0], camWidth, camHeight);