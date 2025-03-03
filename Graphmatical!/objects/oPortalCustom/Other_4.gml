// Load name
ini_open("custom-level_" + string(customIdx) + ".sav");
name = ini_read_string("gen", "name", "Custom Level");
creator = ini_read_string("gen", "creator", "");
ini_close();