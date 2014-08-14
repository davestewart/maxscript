fn parseMacroscriptFile file =
	(
-- set up
	basepath="E:\\2_Current_Jobs\\softinstance\\treeview\\icons\\"
	file = openfile (basepath+file)
	str = "" as stringstream
	fileName = getFilenameFile (file as string)
	fileName = substring fileName 7 -1
	format "/*  %  */\n" fileName to:iconWin


-- set up
	local data=#()
	local iconName, iconFile, iconIndex
	local iconStr, iconArr, start, end

	while NOT (eof file) do
		(
		-- set up
			line = readline file as string

		-- find iconName
			if findstring line "macroScript " != undefined then
				(
				data=#()
				iconName = filterstring line " "
				iconName = iconName[2]
				append data iconName
				)

		-- find icon
			if findstring line "icon:#(" != undefined then
				(
				start= (findstring line "icon:#(") + 7
				end = line.count - start

				iconStr=substring line start end
				iconArr= filterstring iconStr ","
				iconFile = substring iconArr[1] 2 (iconArr[1].count-2)
				iconIndex=iconArr[2] as Integer
				
				append data iconFile
				append data iconIndex
				)

		-- build the array
			if data.count==3 then
				(
				format "	%,\n" data to:iconWin
				iconName=undefined
				iconFile=undefined
				iconIndex=undefined
				data=#()
				)
		)
--	format "%\n" data
	)



mcrArr=#(
	"Macro_Cameras.mcr",
	"Macro_Compounds.mcr",
	"Macro_Dynamics.mcr",
	"Macro_Helpers.mcr",
	"Macro_Lights.mcr",
	"Macro_Modifiers.mcr",
	"Macro_Nurbs.mcr",
	"Macro_Objects.mcr",
	"Macro_Particles.mcr",
	"Macro_Shapes.mcr",
	"Macro_SpaceWarps.mcr",
	"Macro_SubObjectLevels.mcr",
	"Macro_Systems.mcr",
	"Reactor.mcr"
	)
--parseMacroscriptFile mcrArr[4]

iconWin = newScript()
format "libraryIcons=#(\n" to:iconWin
	for f in mcrArr do parseMacroscriptFile f
format ")\n" to:iconWin

/*
*/