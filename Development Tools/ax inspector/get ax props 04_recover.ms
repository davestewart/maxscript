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
		local n = findstring str char
		if n != undefined then return #(substring str 1 (n-1), substring str n -1)
		else return #(str)
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

	fn trim str =
	(
		return trimRight (trimLeft str)
	)

-------------------------------------------------------------------
-- Mains Functions
	
	
	struct axProperty (name, value, enums, class)
	global ax
	
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
		
		--	Example strings
			--	.Arrange : ListArrangeConstants( #lvwNone | #lvwAutoLeft | #lvwAutoTop )
			--	.ColumnHeaders : IColumnHeaders

		-- variables
			local axProp = axProperty()
			local arrNameClass
			local arrClassEnums
		
		-- split string and clean up <	.Arrange : ListArrangeConstants( #lvwNone | #lvwAutoLeft | #lvwAutoTop )>
			arrNameClass	= filterString str ":"
	
		-- get NAME <	.Arrange >
			axProp.name		= (filterstring arrNameClass[1] " .")[1]
	
		-- get CLASS / ENUMS < ListArrangeConstants( #lvwNone | #lvwAutoLeft | #lvwAutoTop )>

			arrClassEnums	= split arrNameClass[2] "("

			-- simple
				if arrClassEnums.count == 1 then --< IColumnHeaders>
				(
					axProp.class	= trim arrClassEnums[1]
					axProp.enums	= handleClass propClass
				)
			-- complex (enum)
				else
				(
					axProp.class	= trim arrClassEnums[1]
					axProp.enums	= arrClassEnums[2]
					axProp.enums	= replaceAll axProp.enums "|" ","
					axProp.enums	= execute ("#" + axProp.enums)
				)
				
			-- get VALUE
					axProp.value = getproperty ax axProp.name
	
	
		-- return
			return axProp
			--#(propName,propValue,propEnums,propClass)
	)
	

	function parsePropStr propStr=
	(
		local propStr	= propStr as stringstream
		while not eof propStr do
		(
			local line = readline propStr
			if findstring line "read-only" == undefined then
			(
				line = line as string
				if line.count > 0 then
				(
					local props = convertPropString (line as string)
					append propArr props
				)
			)
		)
	)


	function tabToSize str size=
	(
		local n = (size - str.count +2) / 4
		for i = 0 to n do str += "	"
		return str
	)



	function printProps=
	(
		-- get longest name
			local x, width=0
			for p in propArr do if (x = p.name.count) > width then width = x
			width += 4
			print width
			local nameStr
		-- print props
			for p in propArr do
			(
				-- name
					nameStr = tabToSize p.name width
					format "ax.%" nameStr 

				-- values
					if p.enums == undefined then
					(
						format "= %" p.value
						if p.value == undefined then format "	--%" p.class
						format "\n"
					)
					else
					(
						local n = finditem p.enums p.value
						format "= %[%]	--%\n" p.enums n p.class
					)
			)
	)

global ax = ro1.ax
global propArr = #()
propStr = getAXProps ro1.ax/*.listitems[1] dump:true */ 
parsePropStr propStr
printProps()

str = "dave"
while str.count < 20 do str += "    "
str
propArr[3].name.count < 18


