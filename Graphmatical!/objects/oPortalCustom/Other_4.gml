// Calculate custom index
var _customIdx = 1;
with (oPortalCustom)
{
	if (id == other.id) other.customIdx = _customIdx;
	_customIdx++;
}

// Load name
ini_open("custom-level_" + string(customIdx) + ".sav");
name = ini_read_string("gen", "name", "Custom Level " + string(customIdx));
creator = ini_read_string("gen", "creator", "");
ini_close();