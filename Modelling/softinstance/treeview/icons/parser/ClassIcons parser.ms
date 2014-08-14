-- global functions
	fn replaceAll str outStr inStr =
		(
		-- str the original string
		-- the string/character to replace
		-- the replacement string/character
		
		origStr=str
		while ((n=findstring str outStr) != undefined) do str = replace str n inStr.count inStr
		if str != undefined then return str
		else return origStr
		)
	
	
	fn pad num padLength =
		(
		num=num as string
		while num.count < padLength do num = ("0"+num)
		return num
		)



-- main parsing function

	fn parseClassIconsDat =
		(
	-- get the file
		basepath="E:\\2_Current_Jobs\\softinstance\\treeview\\icons\\"
		file = openfile (basepath+"ClassIcons.dat")
		str = "" as stringstream
	
	
		skipToString file "MODIFY THIS AT YOUR OWN RISK"
	
	-- set up variables
		local iconName, iconFile, iconIndex
		local iconStr, iconArr, start, end
		local data=#()
	
		
	-- parse the DAT file
		while NOT (eof file) do
			(
			-- set up
				line = readline file as string
	
				--format "	%,\n" line --to:iconWin
	
	
			-- print class category
				if (findstring line "--" != undefined) then
					(
					format "\n/* % -----------------------------------------------------  */\n" line to:classSS
					format "\n/* % -----------------------------------------------------  */\n" line to:bmpSS
					)
	
			-- print class / icon
				if (findstring line "Icon:" != undefined) then
					(
				-- get data
					data=#()
					data = filterstring line " "
					--Morph Icon:#("Compound",1)
	
				-- class
					class = data[1]
					format "	\"%\",\n" class to:classSS
	
	
				-- bitmap
					start= 9
					end = data[2].count-start
					local tempStr = substring data[2] start end
	
					data=filterstring tempStr "\","			-- reuse data array
	
					local bmpStr = data[1]+"_"+(pad data[2] 2)+".bmp"
					format "	\"%\",\n" bmpStr to:bmpSS
					)
				)


	-- finish off windowstreams
	
		format "\n/* User defined -----------------------------------------------------  */\n" line to:classSS
		format "	\"<unknown>\"\n" class to:classSS
		format "	)\n" class to:classSS
	
		format "\n/* User defined -----------------------------------------------------  */\n" line to:bmpSS
		format "	\"<unknown>\"\n" class to:bmpSS
		format "	)\n" class to:bmpSS
	
		)

-- initialise windowstreams
	global classSS = newScript()
	global bmpSS = newScript()

	format "libraryClassArr=#(\n" class to:classSS
	format "libraryBmpArr=#(\n" class to:bmpSS

-- go!
	parseClassIconsDat ()
