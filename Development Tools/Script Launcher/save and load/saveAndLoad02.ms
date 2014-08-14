rollout ro1 "Options" width:160 height:311
(
	---------------------------------------------------------------------------------------------------
	-- declare globals
	---------------------------------------------------------------------------------------------------

	local listPath = (getDir #scripts) + "\new\Script Launcher\settings.ini"


	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	listBox lbxList "ListBox" pos:[8,8] width:144 height:9 items:#("one","two","three","four","five")
	button btnSave "Save" pos:[8,160] width:48 height:16
	button btnLoad "Load" pos:[56,160] width:48 height:16
	button btnClear "Clear" pos:[104,160] width:48 height:16

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn saveList =
	(
		for i = 1 to lbxList.items.count do
		( 
			setINISetting listPath lbxList.name ("item_" + i as String) lbx.items[i]
/*				<filename_string> 
				<section_string> 
				<key_string> 
				<key_value_string> */
		)
	)

	fn loadList =
	(
	)


	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------
	on btnClear pressed do lbxList.items = #()
	
	on btnSave pressed do saveList()
	
	on btnLoad pressed do loadList()

	
)

if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 188 500 
addRollout ro1 myFloater

/*
	getINISetting 
		<filename_string> 
		<section_string> 
		<key_string> 

		Reads an INI setting from the specified file. Within the file, the 
		section identified by <section_string> is located, and then the key 
		specified by the <key_string> is located. The value assigned to this 
		key is then returned as a string. If the specified file, section, or 
		key is not found, a null string is returned. For example: 

			GetINISetting "c:\\3dsmax2\\3dsmax.ini" "Directories" "Scenes" 

		If the specified file, section, or key is not found, a null string is returned. 

	setINISetting
		<filename_string> 
		<section_string> 
		<key_string> 
		<key_value_string> 

		Sets an INI setting in the specified file. Returns a value of true if the key 
		value was written to the file, false if the key was not written. 
		Within the file, the section identified by <section_string> is located, 
		and then the key specified by the <key_string> is located. 
		The <key_value_string> is then assigned to this key. For example: 

			setINISetting "c:\\3dsmax2\\3dsmax.ini" "Directories" "Scenes" "c:\\3dsmax\\scenes" 

		If the specified file, section, or key is not found, a new file, section, or key is created. 
		
		If the specified file is read-only, or the file is open in MAXScript, the key 
		value is not written to the file. 
*/