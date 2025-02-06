/// @desc Event

#region Functions

/// @func	save();
save = function()
{
	// Init save
	var _saveData = [];
	
	// Save game manager
	with (oGameManager)
	{
		var _dataEntry = 
		{
			objectName : object_get_name(object_index),
			tutorialComplete : tutorialComplete,
		}
		array_push(_saveData, _dataEntry);
	}
	
	// Save as a JSON string
	var _string = json_stringify(_saveData);
	var _buffer = buffer_create(string_byte_length(_string)+1, buffer_fixed, 1);
	buffer_write(_buffer, buffer_string, _string);
	buffer_save(_buffer, "save_1.save");
	buffer_delete(_buffer);
	
	show_debug_message("Game saved! " + _string);
}

/// @func	load();
load = function()
{
	// Check file
	var _fileName = "save_1.save";
	if (file_exists(_fileName))
	{
		// Read string
		var _buffer = buffer_load(_fileName);
		var _string = buffer_read(_buffer, buffer_string);
		buffer_delete(_buffer);
		
		// Convert to struct
		var _loadData = json_parse(_string);
		while (array_length(_loadData) > 0)
		{
			// Get data entry
			var _dataEntry = array_pop(_loadData);
			
			// Process object/asset
			var _asset = asset_get_index(_dataEntry.objectName);
			switch (_asset)
			{
				case oGameManager:
					if (instance_exists(oGameManager))
					{
						with (oGameManager)
						{
							tutorialComplete = _dataEntry.tutorialComplete;
						}
					}
					break;
			}
		}
		
		show_debug_message("Game loaded! " + _string);
	}
}

#endregion