/// @func	SignMenu();
function SignMenu() : Menu() constructor
{
	// Sign textfield
	textfieldSign = new GuiTextfield("Sign", 80, 16, "", "Insert text here.", other.onSignTextEntered)
}