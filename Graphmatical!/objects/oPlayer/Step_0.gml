// Move input
velocity.x = keyboard_check(ord("D")) - keyboard_check(ord("A"));

// Jump
if (keyboard_check_pressed(vk_space)) velocity.y = -3;

// Rigid body
rbUpdate();