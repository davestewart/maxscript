fn parseMacroscriptFile file =
(
	file = openfile file
	str = "" as stringstream
	fileName = getFilenameFile (file as string)
	format "%\n" (fileName as string)
	while NOT (eof file) do
	(
		-- set up
			
		
			line = readline file as string
		-- find name
			if findstring line "macroScript " != undefined then
			(
				local name = filterstring line " "
				name = name[2]
				format "\"%\"," name
			)
		-- find icon
			if findstring line "icon:#(" != undefined then
			(
				local start= (findstring line "icon:#(") + 7
				local end = line.count - start
				--format "%\n" start
				format "%\n" (substring line start end)
			)
	)
	
	
)

parseMacroscriptFile "E:\\2_Current_Jobs\\softinstance\\treeview\\icons\\Macro_Cameras.mcr"