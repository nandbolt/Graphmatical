// Inherit the parent event
event_inherited();

// Check edit mode
if (global.editMode) instance_create_layer(0, 0, "Instances", oCustomEditorManager);
else instance_create_layer(0, 0, "Instances", oCustomManager);