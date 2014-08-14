
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
		format "--------------\n"
		
		--if dump == true then format "%" propStr to:(newscript())
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


	fn tabToSize str size=
		(
		local n = (size - str.count) / 4.0
		for i = 1 to n do str += "	"
		format "% - " (mod str.count 4.0)
--		if (mod str.count 4) == 4 then str += "	"
		return str
		)

	str = ""
	for i = 1 to 10 do
		(
		str += i as string
		format "%|% %\n" (tabToSize str 30.0) i (mod i 4.0)
		)


-------------------------------------------------------------------
-- Mains Functions
	
	
	struct axProperty (name, value, enums, class)
	global ax, propArr
	
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
					try
						(
						local props = convertPropString (line as string)
						append propArr props
						)
					catch
						(
						format "-- Failed on line %\n" line
						)
					)
				)
			)
		)


	function printProps=
		(
		-- stringstream
			ss = stringstream ""
		
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
					format "ax.%" nameStr to:ss


				-- values
					

				-- enums
					if p.enums == undefined then
						(
						if  p.class == "string" then format "= \"%\"" p.value to:ss
						else format "= %" p.value to:ss

						if p.value == undefined then format "	--%" p.class to:ss
						format "\n" to:ss
						)
					else
						(
						local n = finditem p.enums p.value
						format "= %[%]	--%\n" p.enums n p.class to:ss
						)
				)
		-- format
			w = newscript()
			format "%" (ss as string) to:w
		)
(
propArr = #()
ax = roTV.tv
propStr = getAXProps ax --dump:true
parsePropStr propStr
printProps()
)


classof propArr[3].value