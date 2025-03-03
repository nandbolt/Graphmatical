// If player can move
if (other.canMove)
{
	// Set player nearby
	playerNear = true;
	onPlayerNear();
	if (keyboard_check_pressed(ord("E"))) interactPressed();
	if (keyboard_check(ord("E"))) interact();
	if (keyboard_check_released(ord("E"))) interactReleased();
	alarm[0] = 10;
}