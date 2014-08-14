
ss = stringstream ""
showallactivexcontrols to: ss

arr = #()
seek ss 0
while not eof ss do
(
	local line = readline ss
	if findstring line "microsoft" != undefined do append arr (line as string)
)
print arr



struct axControl (name, programId, ClassId)

for i = 1 to strCount do
(
	iStart		= 2
	iEnd		= findstring str "\" \"" - 2
	strFound	= substring str iStart iEnd
	str			= 
)

filterstring str "\" \"" splitEmptyTokens:false

classid

function getAXControlTypes str =
(
	token = "\" \""
	while findstring str token != undefined do
	(
		i	= findstring str token
		str = replace str i 3 "|"
	)
	str = substring str 2 (str.count - 2)
	arr = filterstring str "|"
	print arr
	axControl name:arr[1] programId:arr[2] ClassId:arr[3]
)

function printStruct s =
(
)

str = "\"Microsoft DirectAnimation Sprite\" \"DirectAnimation.SpriteControl\" \"{FD179533-D86E-11D0-89D6-00A0C90833E6}\""
ax = getAXControlTypes str
arr = #(1,2,#(1,#(1,ax,#(1,2,#(1,2,3,4),4),4),3,4),4)


printCompound ax
function printCompound obj depth:0 =
(
	local indent = ""
	for i = 1 to depth do indent += "	"

	if classof obj == Array then
	(
		for i = 1 to obj.count do
		(
			local p = obj[i]
			if classof p == String then format "%#%: \"%\"\n" indent i p
			else if (classof p == Array OR superclassof p == structDef) then printCompound p depth:(depth + 1)
			else format "%#%: %\n" indent i p
		)
	)
	else if superclassof obj == StructDef do
	(
		for prop in (getPropNames obj) do
		(
			local p		= getProperty ax prop
			if classof p == String then format "%%: \"%\"\n" indent prop p
			else if classof p == Array OR superclassof p == structDef then printCompound p depth:(depth + 1)
			else format "%%: %\n" indent prop p
		)
	)
)
	
$.pos as array
printCompound $.pos.controller

superclassof 1.5


