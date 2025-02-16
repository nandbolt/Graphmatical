var _x = 0, _y = 32;

// Background
draw_set_color(c_black);
draw_set_alpha(0.5);
draw_rectangle(_x, _y, _x+288, _y+128, false);
draw_set_color(c_white);
draw_set_alpha(1);

// Debug information
draw_text(_x, _y, "Instances: " + string(instance_count));
_y += 16;
draw_text(_x, _y, "Boxes: " + string(array_length(boxEngine.boxes)));
_y += 16;
draw_text(_x, _y, "Force Registrations: " + string(boxEngine.registry.getRegistrationCount()));
_y += 16;
draw_text(_x, _y, "Contact Gens: " + string(array_length(boxEngine.contactGens)));
_y += 16;
draw_text(_x, _y, "Contact Resolver Iterations: " + string(boxEngine.resolver.getIterationsUsed()));
_y += 16;
draw_text(_x, _y, "FPS: " + string(fps));
_y += 16;
draw_text(_x, _y, "Real FPS: " + string(fps_real));