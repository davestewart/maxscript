(
-- folders
	app="C:\\Design\\4_Video\\After Effects 6.5\\Support Files\\afterfx.exe"
	fileFolder="E:\\03_Scripting\\3ds2ae\\04_ae\\1 - utility\\"
	fileFolder="E:\\03_Scripting\\3ds2ae\\04_ae\\2 - objects\\"

-- file commands

	file="comp properties.jsx"
	fileStr=stringstream ""
	format "\"%\" -r %" app (fileFolder+file) to:fileStr
	format "%\n" (fileStr as string)
	DOSCommand (fileStr as string)
)