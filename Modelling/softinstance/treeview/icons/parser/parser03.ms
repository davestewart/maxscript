fn parseMacroscriptFile file =
(
	file = openfile file
	str = "" as stringstream
	fileName = getFilenameFile (file as string)
	fileName = substring fileName 7 -1
	format "%\n" fileName
	while NOT (eof file) do
	(
			local name, iconFile, iconIndex
		-- set up
			data=#()
			line = readline file as string
		-- find name
			if findstring line "macroScript " != undefined then
			(
				name = filterstring line " "
				name = name[2]
				--format "\"%\"," name
			)
		-- find icon
			if findstring line "icon:#(" != undefined then
			(
				local start= (findstring line "icon:#(") + 7
				local end = line.count - start

				local iconStr=substring line start end
				local iconArr= filterstring iconStr ","
				iconFile = iconArr[1]
				iconIndex=iconArr[2]
/*				
				format "%\n" iconFile
				format "%\n" iconIndex
				try(append data iconFile)catch(format "failed on %\n" iconFile)
				try(append data iconIndex)catch(format "failed on %\n" iconIndex)
*/
				/*
			)
			if(name!=undefined)then
			(
				append data name
				format "%\n" data
			)
				*/


			--format "%\n" data
	)
	
	
)

parseMacroscriptFile "E:\\2_Current_Jobs\\softinstance\\treeview\\icons\\Macro_Cameras.mcr"