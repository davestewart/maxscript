fn parseMacroscriptFile file =
	(
	file = openfile file
	str = "" as stringstream
	fileName = getFilenameFile (file as string)
	fileName = substring fileName 7 -1
	format "%\n" fileName
	while NOT (eof file) do
		(
		-- set up
			local iconName, iconFile, iconIndex
			local iconStr, iconArr, start, end
			line = readline file as string

		-- find iconName
			if findstring line "macroScript " != undefined then
				(
				iconName = filterstring line " "
				iconName = iconName[2]
				)

		-- find icon
			if findstring line "icon:(#" != undefined then
				(
				start= (findstring line "icon:(#") + 7
				end = line.count - start

				iconStr=substring line start end
				iconArr= filterstring iconStr ","
				iconFile = iconArr[1]
				iconIndex=iconArr[2]
				)

		-- build the array
			if iconName!= undefined then append data iconName
			if iconFile!= undefined then append data iconFile
			if iconIndex!=undefined then append data iconIndex

			if data.count==3 then
				(
				format "%\n" data
				data=#()
				)
		)
	)

parseMacroscriptFile "E:\\2_Current_Jobs\\softinstance\\treeview\\icons\\Macro_Cameras.mcr"