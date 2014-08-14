fn fileToString file=
(
	str=stringstream ""
	strFile = openFile file
	while not eof strFile do
	(
		format "%\n" (readline strFile) to:str
	)
	return str as string
)

newStr = fileToString "rc menu 02.ms"