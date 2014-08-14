/*
appFolder="E:\\03_Scripting\\3ds2ae\\03_3ds\\rollout code\\"
appAE="C:\\Design\\4_Video\\After Effects 6.5\\Support Files\\afterfx.exe"
*/



function runJSX jsx=
	(
	local dosStr=stringstream ""
	local jsx=appFolder+"jsx\\"+jsx

	format "\"%\" -r %" appAE jsx to:dosStr
	

	--format "%\n" (dosStr as string) 
	--HiddenDOSCommand (dosStr as string) -- TAKEN OUT TO TEST!
	
	--DOSCommand (dosStr as string)
	)

function createJSX jsx str run:true=
	(
	if appFolder!=undefined then
		(
		f=createFile (appFolder+"jsx\\"+jsx)
		format "%\n" str to:f
		flush f; close f
		if run != false then runJSX jsx else return jsx
		)
	else messagebox "appFolder and related variables need to be defined"
	)
/*
--createJSX "test2.jsx" "alert('hello!')"

function deleteJSX url=
	(
	
	)


(
local key=1234567890123456789012345678901234567890
)
*/

function encryptObjectsJSX url=
	(
	local fileSrc=url
	local fileEnc="objects.dat"
	encryptFile fileSrc fileEnc key
	)
	

--encryptObjectsFile "object constructor 08.jsx"


