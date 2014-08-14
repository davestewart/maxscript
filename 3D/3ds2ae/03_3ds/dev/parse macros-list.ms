(
-- variables
	local 
	logFile="c:/temp/my_log.txt"
	
-- functions
	function getMacrosList=
		(
		clearListener()
		openLog logFile
		macros.list()
		flushLog()
		closeLog()
		)

	function createMacroArray=
		(
		local arr=#()
		local fs= openfile logFile
		while not eof fs do
			(
			local text= (readLine fs) as stringstream
			local lineArr=#()
			while peekToken text != undefined do (
				append lineArr (readToken text)
				)
			append arr lineArr
			)
		return arr 
		)
		
-- main
	
	--local 
	macroList=createMacroArray()
)

struct dataGrid (names,members)
table=dataGrid #() #()
table.names

struct macroInfo (id, name, category, internalCategory, path)
