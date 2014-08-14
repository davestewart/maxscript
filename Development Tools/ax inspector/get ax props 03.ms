-------------------------------------------------------------------
-- Notes

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

-------------------------------------------------------------------
-- Functions

	fn split str char=
		(
		local n = 
		findstring str char
		return #(substring str 1 (n-1), substring str n -1)
		)

	fn getListenerText=
		(
		local str
		setListenerSel #(0,-1)
		str	= getListenerSelText()
		setListenerSel #(-1,-1)
		return str
		)
	
	fn getAXProps ax dump:false=
		(
		clearlistener()
		showproperties ax
		local propStr=getListenerText()
		if dump == true then format "%" propStr to:(newscript())
		return propStr
		)
	
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

-------------------------------------------------------------------
-- Mains Functions
	
	
	struct axProperty (name, value, enums, class)
	
	
	function handleClass class=
		(
		case class of
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
			default: return undefined
			)
		)

	function convertPropString str=
		(
		local arr
		local propName
		local propEnums
		local propClass
		local propValue
		
		
		-- split string and clean up
			arr				= filterString str ":"
	
		-- get propName
			propName		= trimRight (trimLeft arr[1])
			propName		= substring propName 2 -2
			
	
		-- get propEnums
			-- complex (enum)
				if findstring arr[2] "(" != undefined then
					(
					local arr		= split arr[2] "("
					propClass		= trimleft arr[1]
					propEnums		= arr[2]
					propEnums		= replaceAll propEnums "|" ","
					propEnums		= execute ("#" + propEnums )
					)
			-- simple
				else
					(
					propClass		= trimLeft (trimright arr[2])
					propEnums		= handleClass propClass
					)
				
			-- get prop value
					propValue = getproperty ro1.ax propName
	
	
		-- return
			return #(propName,propValue,propEnums,propClass)
		)
	

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
					
					--	format "%\n"arr[3]
					if arr[3]=="" then
						(
						format "%		% --%\n" arr[1] arr[2] arr[4]
						)
					else
						(
						--local n = finditem arr[3] arr[2]
						--format "%		%[%]	--%\n" arr[1] arr[3] n arr[4]
	
						)
					)
				)
			)
		)
	

propStr = getAXProps ro1.ax/*.listitems[1] dump:true */ 
parsePropStr propStr


getproperty ro1.ax "SortKey"

ro1.ax.View == #lvwList


finditem #(#ccOLEDragManual, #ccOLEDragAutomatic) (getproperty ro1.ax "OLEDragMode")



arr=#(1,2,3,4)

(format "%[2]\n" arr)