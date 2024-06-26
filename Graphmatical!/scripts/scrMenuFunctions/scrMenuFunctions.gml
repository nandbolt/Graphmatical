/// @func	changeMenu({func} menuFunc);
function changeMenu(_menuFunc=undefined)
{
	// Remove previous menu
	if (is_struct(currentMenu))
	{
		currentMenu.cleanup();
		delete currentMenu;
	}
	
	// Init next menu if one given
	if (_menuFunc != undefined) currentMenu = new _menuFunc();
}