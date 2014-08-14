cmdPath = getDir #scripts + "\\simpleCredits"
print ("cmdpath set up as " + cmdPath)


cmdStr	=cmdPath+"\\listfonts.bat "+cmdPath 
Welcome to MAXScript.

for f in (getFiles ((getDir #scripts) + "\\*.bat")) do print f


f = for f in (getFiles ((getDir #scripts) + "\\*.bat")) do print f

openFile <filename_string> [ mode:<mode_string> ] 
opens an existing file and returns a <filestream> value. If the specified file does not exist, the value undefined is returned. The optional mode_string can be "a" to mean open an existing file for append output, or "r" to mean open file read-only. 

if openFile cmdStr mode:"r" == undefined then format "ERROR: File not found at path %\n" cmdStr


