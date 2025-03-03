// Calculate custom index
var _customIdx = 1, _amnt = 1;
if (os_browser != browser_not_a_browser)
{
	_customIdx = instance_number(oPortalCustom);
	_amnt = -1;
}
with (oPortalCustom)
{
	if (id == other.id) other.customIdx = _customIdx;
	_customIdx += _amnt;
}

// Load name
ini_open("custom-level_" + string(customIdx) + ".sav");
name = ini_read_string("gen", "name", "Custom Level " + string(customIdx));
creator = ini_read_string("gen", "creator", "");
ini_close();