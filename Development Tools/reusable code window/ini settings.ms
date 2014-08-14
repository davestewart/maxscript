The following methods allow you to read and write key values in .INI files. 
getINISetting <filename_string> <section_string> <key_string> 
Reads an INI setting from the specified file. Within the file, the section identified by <section_string> is located, and then the key specified by the <key_string> is located. The value assigned to this key is then returned as a string. If the specified file, section, or key is not found, a null string is returned. For example: 
GetINISetting "c:\\3dsmax2\\3dsmax.ini" "Directories" "Scenes" 
If the specified file, section, or key is not found, a null string is returned. 
setINISetting <filename_string> <section_string> <key_string> <key_value_string> 
Sets an INI setting in the specified file. Returns a value of true if the key value was written to the file, false if the key was not written. Within the file, the section identified by <section_string> is located, and then the key specified by the <key_string> is located. The <key_value_string> is then assigned to this key. For example: 
setINISetting "c:\\3dsmax2\\3dsmax.ini" "Directories" "Scenes" "c:\\3dsmax\\scenes" 
If the specified file, section, or key is not found, a new file, section, or key is created. 
If the specified file is read-only, or the file is open in MAXScript, the key value is not written to the file. 
