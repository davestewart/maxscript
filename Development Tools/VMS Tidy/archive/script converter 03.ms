---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------

rollout ro1 "Enter your rollout code here..." width:784 height:376
(
	---------------------------------------------------------------------------------------------------
	-- declarations
	---------------------------------------------------------------------------------------------------

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
	button btn1 "Re-order code now..." pos:[9,345] width:183 height:16
	label lblArrange "Arrange by:" pos:[216,344] width:56 height:16
	radioButtons rdoArrange "" pos:[280,344] width:146 height:16 labels:#("Groups", "Position") default:1 columns:2
	checkbox chkIndent "Indent code" pos:[440,344] width:80 height:15 checked:true 
	checkbox chkSpace "Space between code" pos:[528,344] width:128 height:15
	checkbox chkGroup "Group similar items" pos:[664,344] width:112 height:15
	
	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn isIn container item=
	(
		-- items should be uiItem structs
		local c=box2 c.x c.y c.w c.h
		local i=point2 i.x i.y
		return (contains c i)
	)

	fn go=
	(
		-----------------------------------------------------------------
		--	variables
		
			local str, strArr=#(), uiArr=#()
			local uiType,x,y,w,h,s
			struct uiItem (type,x,y,w,h,string)
		
		-----------------------------------------------------------------
		--	get string and put into array

			str=edt1.text
			strArr=filterstring str "\n\r"

		-----------------------------------------------------------------
		--	start to parse array into a new array uiArr of uiObj structs

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
			--	set up final string
				if chkIndent.checked then
				(
					if stricmp type "GroupBox" == 0 then s="	"+s
					else s="		"+s
				)
			---------------------------------------------------------
			-- add to a new array
				local ui=uiItem type:type x:x y:y w:w h:h string:s
				format ">>%\n" ui
				if uiArr[y]==undefined then uiArr[y]=#()
				if uiArr[y][x]==undefined then uiArr[y][x]=ui
		)
			


		-------------------------------------------------------------
		-- go through new array and assign to groups
/*
			local c
			local str=""
			local currType="",prevType=""
			for y = 1 to uiArr.count do
			(
				if uiArr[y]!=undefined then
				(
					-- newline if new Y
					--if (currType == prevType)then 

					for x = 1 to uiArr[y].count do
					(
						if uiArr[y][x]!=undefined then
						(
							c=uiArr[y][x]
							currType=substring c 1 (findstring c " ")
							format "%\n" currType
							str+=c+"\n"
						)
					)
					-- newline
						str+="\n"
					-- take away newline if the same
						if (currType == prevType)then str = substring str 1 (str.count-1)
						prevType = currType
				)
			)
			edt1.text=str
*/
	)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------



	

	on ro1 open do
	(
		edt1.text = uiStr
		--go()
	)
	on btn1 pressed do
	(
		go()
	)
)

if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 800 400 10 10
addRollout ro1 myFloater

