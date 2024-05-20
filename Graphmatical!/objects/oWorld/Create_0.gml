// Layers
collisionLayer = layer_get_id("CollisionTiles");

// Hide collision layer
layer_set_visible(collisionLayer, false);

// Graphing
precedenceMap = ds_map_create();

// Init precedence map
ds_map_add(precedenceMap, "(", 1);	// Parenthesis
ds_map_add(precedenceMap, "+", 2);	// Addition
ds_map_add(precedenceMap, "-", 2);	// Subtraction
ds_map_add(precedenceMap, "*", 3);	// Multiplication
ds_map_add(precedenceMap, "/", 3);	// Division
ds_map_add(precedenceMap, "s", 3);	// Sine
ds_map_add(precedenceMap, "c", 3);	// Cosine
ds_map_add(precedenceMap, "g", 3);	// Tangent
ds_map_add(precedenceMap, "^", 4);	// Power
ds_map_add(precedenceMap, "l", 5);	// Log
ds_map_add(precedenceMap, "r", 5);	// Root