file = openfile "E:\\2_Current_Jobs\\softinstance\\treeview\\icons\\Macro_Cameras.mcr"
srr = "" as stringstream
while NOT (eof file) do
	(
--	skiptostring file "macroScript "
	line = readline file as string
	-- find name
		if findstring line "macroScript " != undefined then
			(
			local name = filterstring line " "
			name = name[2]
			format "%\n" name
			)
	-- find icon
		if findstring line "icon:#(" != undefined then
			(
			local start= (findstring line "icon:#(") + 6
			format "%\n" start
--			format "%\n" (line substring line start)
			)
	)


--findString "Thanks for all the fish!" "all" -- returns 12
--filterString "MAX Script, is-dead-funky" ", -" 
