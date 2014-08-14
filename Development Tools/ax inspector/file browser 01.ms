fn getFilesRecursive root pattern =
(
	local files
	local dirs
	
	dirs = GetDirectories (root + "/*")
	for d in dirs do
	(
		join dirs (GetDirectories (d + "/*"))
	 )
	
	files = #()
	for f in dirs do
	join files (getFiles (f + pattern))
	
	return files
)
	
--get all .ms files from the max installation
arr = getFilesRecursive "c:/temp" "*.*"
print arr



dirs = GetDirectories ("c:\\temp\\*")

join

for d in dirs do
(
	local d = replaceAll d "\\" "\\\\"
	print (getFiles d + "\\*")
)


fn replaceAll strStr strOut strIn =
(
	local strTemp = ""
	local arrTemp = filterstring strStr strOut
	for a in arrTemp do strTemp += a + strIn
	return strTemp
)
	
	
replaceAll "c:\temp\Incomplete\" "\\" "\\\\"
 