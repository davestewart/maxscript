/*
PSUEDO CODE

Get all properties
Loop down through lines

Get one line
If "read-only" then
	skip

Else
	split at " : "
	trimmed [1] becomes property
	trimmed [2] becomes enums
	
	If "(" is found then
		-- is enum
		split at "("
		trimmed [1] becomes strPropType
		trimmed [2] becomes strPropArray
		replace "|" with ","
		return "#" + propArray + "--" + strPropType
		
	Else
		-- is class
		handleClass
		
	
*/


fn replaceAll str outStr inStr=
	(
	for i = str.count to 1 by -1 do
		(
		if str[i]==outStr then
			(
			local beg=substring str 1 (i-1)
			local end=substring str (i+1) -1
			str=beg+inStr+end
			)
		)
	return str
	)

function convertPropString str=
	(
	local arr
	local propName
	local propEnums
	local propClass
	
	-- split string and clean up
		arr				= filterString str ":"

	-- get propName
		propName		= trimRight (trimLeft arr[1])
		propName		= substring propName 2 -2
		

	-- getpropEnums
		-- enum
			if findstring arr[2] "(" != undefined then
				(
				local arr		= split arr[2] "("
				propClass		= trimleft arr[1]
				propEnums		= arr[2]
				propEnums		= replaceAll propEnums "|" ","
				propEnums		= execute ("#" + propEnums )
				)
		-- value
			else
				(
				propClass		= trimLeft (trimright arr[2])
				propEnums		= handleClass propClass
				)
				

	-- return
		return #(propName,propEnums,propClass)
	)

convertPropString "  .Arrange : ListArrangeConstants( #lvwNone | #lvwAutoLeft | #lvwAutoTop )"
convertPropString "  .LabelWrap : boolean"

function handleClass str=
	(
	case str of
		(
		"boolean" :
			(
			return "#(true , false)"
			)
		"integer" :
			(
			return ""
			)
		"OLE_COLOR" :
			(
			return ""
			)
		"OLE_HANDLE" :
			(
			return ""
			)
		"float" :
			(
			return ""
			)
		"string" :
			(
			return ""
			)
		default: return ""
		)
	)




function getListenerText=
	(
	local str
	setListenerSel #(0,-1)
	str	= getListenerSelText()
	setListenerSel #(-1,-1)
	return str
	)

function getAXProps ax dump:false=
	(
	clearlistener()
	showproperties ax
	local propStr=getListenerText()
	if dump == true then format "%" propStr to:(newscript())
	return propStr
	)

	
function split str char=
	(
	local n = 
	findstring str char
	return #(substring str 1 (n-1), substring str n -1)
	)

function getProperties obj=
	(


	)
	

function getEnum

function parsePropStr propStr=
	(
	local propStr=propStr as stringstream
	while not eof propStr do
		(
		local line = readline propStr
		if findstring line "read-only" == undefined then
			(
			line = line as string
			if line.count > 0 then
				(
				local arr = convertPropString (line as string)
				--format "%\n" arr
				--format "<<%>>\n" (line as string)
				format "%		%	--%\n" arr[1] arr[2] arr[3]
				)
			)
		)
	)


propStr = getAXProps ro1.ax/*.listitems[1] dump:true */ 
parsePropStr propStr


getproperty ro1.ax "SortKey"

ro1.ax.View == #lvwList





arr=#(1,2,3,4)

(format "%[2]\n" arr)