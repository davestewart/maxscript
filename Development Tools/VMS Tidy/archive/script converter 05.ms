---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------
rollout ro1 "Enter your rollout code here..." width:784 height:376
(
	---------------------------------------------------------------------------------------------------
	-- declarations
	---------------------------------------------------------------------------------------------------

	local roSize=point2 100 25

	local uiStr="
	GroupBox grpElements \"Elements\" pos:[4,88] width:168 height:88
	checkbox chkUseJunction \"Checkbox\" pos:[8,120] width:16 height:16

	checkbox chkUseHead \"Checkbox\" pos:[8,136] width:16 height:16
	label lblOffset \"Offset\" pos:[120,104] width:48 height:16
	label lblUse \"Use\" pos:[8,104] width:20 height:16

	label lblNode \"Node\" pos:[54,104] width:32 height:16
	checkbox chkUseBody \"Checkbox\" pos:[8,152] width:16 height:16
	"

	local uiStr="
	GroupBox grpSettings \"Settings management\" pos:[4,4] width:232 height:42
	button btnCopy \"Copy...\" pos:[8,24] width:56 height:16
	button btnPaste \"Paste...\" pos:[64,24] width:64 height:16 enabled:false
	dropDownList ddlCopyType \"\" pos:[130,22] width:104 height:21 items:#(\"All settings\", \"Output size\", \"Time\", \"Scanline options\", \"Render output\", \"Renderer\", \"Camera\") enabled:false


	GroupBox grpPreset \"Preset management\" pos:[240,4] width:128 height:42
	button btnDown \"Move Down\" pos:[244,24] width:68 height:16
	button btnUp \"Move Up\" pos:[312,24] width:52 height:16

	GroupBox grpFile \"Preset I/O\" pos:[372,4] width:188 height:42
	button btnSave \"Save\" pos:[376,24] width:60 height:16
	button btnLoad \"Load\" pos:[436,24] width:60 height:16
	button btnClear \"Clear\" pos:[496,24] width:60 height:16

	GroupBox grpGlobal \"Global options\" pos:[564,4] width:262 height:42
	checkbox chkAnim \"Auto-open animations\" pos:[572,24] width:124 height:16 checked:true
	checkbox chkSaveOnClose \"Auto-save on close\" pos:[700,24] width:120 height:16 checked:false

	GroupBox grpRenderWanger \"RenderWanger v0.8\" pos:[830,4] width:146 height:42
	button btnHelp \"Help\" pos:[836,24] width:60 height:16
	button btnWeb \"Report bugs\" pos:[896,24] width:76 height:16
"
	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------

	edittext edt1 "" pos:[8,8] width:768 height:332
	button btnTidy "Tidy code now..." pos:[8,344] width:360 height:16
	button btnTest "Test..." pos:[368,344] width:114 height:16
	checkbox chkGroup "Group similar items" pos:[664,344] width:112 height:15
	
	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn isIn container item=
		(
		-- items should be uiItem structs
		local c=container
		local i = item
		if c!= undefined AND i!=undefined then
			(
			local c=box2 c.x c.y c.w c.h
			local i=point2 i.x i.y
			return (contains c i)
			)
		else return false
		)

	fn orderArray arr=
		(
		tmpArr=#()
		for y = 1 to arr.count do
			(
			if arr[y]!=undefined then
				(
				for x = 1 to arr[y].count do
					(
					if arr[y][x]!=undefined then
						(
						append tmpArr arr[y][x]
						)
					)
				)
			)
		return tmpArr
		)

	fn go=
		(
		-----------------------------------------------------------------
		--	variables
			roSize=point2 100 25
			local str, strArr=#(), uiItemArr=#(), uiGroupArr=#(), uiArr=#()
			local uiType,x,y,w,h,s
			struct uiItem (type,x,y,w,h,string)
		
		-----------------------------------------------------------------
		--	get string and put into array
		str=edt1.text
		strArr=filterstring str "\n\r"


		-----------------------------------------------------------------
		--	PARSE ARRAY INTO A NEW ARRAY uiItemArr OF uiItem STRUCTS
		-----------------------------------------------------------------

		for s in strArr do
			(
			---------------------------------------------------------
			--	strip whitespace

				while substring s 1 1 == "\t" do s=substring s 2 -1
				while substring s 1 1 == " " do s=substring s 2 -1

			---------------------------------------------------------
			-- start breaking string down to get propeties

				local i, str, arr
				-- type
					type=(filterstring s " ")[1]
					if stricmp type "GroupBox" == 0 then type="groupBox"
					--format "uiType: % \n" uiType

				-- x,y
					i=findstring s "pos:["
					if i != undefined then
						(
						str=substring s (i+5) -1
						str=(filterstring str "]")[1]
						arr=filterstring str ","
						x=arr[1] as integer
						y=arr[2] as integer
						--format "x: % y: % \n" x y
						)

				-- width
					i=findstring s "width:"
					if i != undefined then
						(
						str=substring s (i+6) -1
						str=(filterstring str " ")[1]
						w=str as integer
						--format "w: % \n" w
						)

				-- height
					i=findstring s "height:"
					--format "i:% \n" i
					if i != undefined then
						(
						str=substring s (i+7) -1
						str=(filterstring str " ")[1]
						h=str as integer
						--format "h: % \n" h
						)


			---------------------------------------------------------
			--	finalise uiItem properties
			
				-- move dropdown lists slightly
				--	if stricmp type "dropDownList" == 0 then y+=2


			---------------------------------------------------------
			--	set ro dimensions
				if x+w > roSize.x then roSize.x=x+w
				if y+h > roSize.y then roSize.y=y+h


			---------------------------------------------------------
			--	create item and add to correct array

				local ui=uiItem type:type x:x y:y w:w h:h string:s

				if type=="groupBox" then
					(
					if uiGroupArr[y]==undefined then uiGroupArr[y]=#()
					if uiGroupArr[y][x]==undefined then uiGroupArr[y][x]=ui
					)
				else
					(
					if uiItemArr[y]==undefined then uiItemArr[y]=#()
					if uiItemArr[y][x]==undefined then uiItemArr[y][x]=ui
					)
			)
			


		-------------------------------------------------------------
		-- ORDER ARRAYS
		-----------------------------------------------------------------

		uiGroupArr=orderArray uiGroupArr
		--for i = 1 to uiGroupArr.count do format "%,% %\n" uiGroupArr[i].x uiGroupArr[i].y uiGroupArr[i].string

		uiItemArr=orderArray uiItemArr
		--for i = 1 to uiItemArr.count do format "%,% %\n" uiItemArr[i].x uiItemArr[i].y uiItemArr[i].string


		-------------------------------------------------------------
		-- GO THROUGH ARRAYS AND CREATE LAYOUT
		-------------------------------------------------------------
		local str = stringstream ""
		local currentGroup=undefined
		local insertExtraLine=true
		for i = 1 to uiItemArr.count do
			(
			-- check if in any groups;
				local isInGroup=false
				-- is it in the current group?
					if isIn currentGroup uiItemArr[i] then isInGroup=true
				-- loop through remaining groups
					else
						(
						for g = 1 to uiGroupArr.count do
							(
							if isIn uiGroupArr[g] uiItemArr[i] then
								(
								format "\n	%\n" uiGroupArr[g].string to:str
								isInGroup=true
								currentGroup=uiGroupArr[g]
								uiGroupArr=deleteItem uiGroupArr g
								exit
								)
							)
						)
			if isInGroup then
				(
				format "		%\n" uiItemArr[i].string to:str
				insertExtraLine=true
				)
			else
				(
				if insertExtraLine then format "\n" to:str
				format "	%\n" uiItemArr[i].string to:str
				insertExtraLine=false
				)
			)
		format "\n" to:str

		edt1.text=(str as stringstream)

		)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------



	

	on ro1 open do
		(
		edt1.text = uiStr
		)
	on btnTidy pressed do
		(
		go()
		)
	on btnTest pressed do
		(
		try (destroyDialog uiTidyTestRo);catch()
		w=int (roSize.x +4) as string
		h=int (roSize.y +4) as string
		uiTidyTestStr="rollout uiTidyTestRo \"UITidy Test Rollout\" width:"+w+" height:"+h+"
			(
			"+edt1.text as string+"
			)"
		execute uiTidyTestStr
		createDialog uiTidyTestRo
		)
)
if uiTidyFloater != undefined then closerolloutfloater uiTidyFloater
	uiTidyFloater = newRolloutFloater "My Floater" 800 400 10 10
addRollout ro1 uiTidyFloater

