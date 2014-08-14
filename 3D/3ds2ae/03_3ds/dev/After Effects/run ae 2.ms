-- strings
	appFolder="C:\\Design\\4_Video\\After Effects 6.5\\Support Files\\"
	app="afterfx.exe"
	fileFolder="scripts\\dave\\"
	file="DemoPalette.jsx"
	file="test01.jsx"
	
	script="alert('Hello!')"

-- commands
	fileStr=stringstream ""
	scriptStr=stringstream ""
	
	format "\"%\" -r %" (appFolder+app) (appFolder+fileFolder+file) to:fileStr
	format "\"%\" -s \"%\"" (appFolder+app) script to:scriptStr
	

-- execute
	DOSCommand (fileStr as string)
--	DOSCommand (scriptStr as string)

format "%\n" (scriptStr as string)