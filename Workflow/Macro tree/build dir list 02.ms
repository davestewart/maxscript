(
--struct folders (name="", files=#())

fn pad n=
	(
	str=""
	for i = 1 to n do str += "	"
	return str
	)



dir="K:\\4 - transfer"
dir="E:\\03_Scripting\\3ds2ae"

fn getFolderStructure filePath depth:0 =
	(
	if depth == unsupplied then depth = 0
	if depth > 5 then return ""
	
	local padding=	pad depth
	local path=filePath+"*"

	--format "£%\n" depth
	
	local files=	getFiles path
	local dirs=		getDirectories path
	
--	format "%\n" path
--	format "%\n" files
	
	
	for f in files do format "%%\n" padding f
	
	/*
	*/
	for dir in dirs do
		(
		--local path=(path +f)
		--print dir
		getFolderStructure dir depth:(depth+1)
		)
	)
	
getFolderStructure dir
)

