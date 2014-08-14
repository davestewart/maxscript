---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------

rollout ro1 "Options" width:384 height:312
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

	editText edt1 "" pos:[8,8] width:768 height:332
	button btn1 "Button" width:368 height:16


	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	fn go=
		(
		local str=edt1.text
		local strArr=filterstring str "\n\r"
		--format "%\n\n" strArr
		local cArr=#()
		for s in strArr do
			(
			--format "<%>\n" s

			-- strip tab characters
				while substring s 1 1 == "\t" do s=substring s 2 -1
				
			-- get the class and tab accordingly
				if substring s 1 8 == "GroupBox" then s="	"+s
				else s="		"+s

			-- get the x,y
				local i, posStr, posArr, pos, x, y
				i=findstring s "pos:["
				if i != undefined then
					(
					posStr=substring s (i+5) -1
					posStr=substring posStr 1 ((findstring posStr "]")-1)
					posArr=filterstring posStr ","
					pos=point2 (posArr[1] as integer) (posArr[2] as integer)
					x=posArr[1] as integer
					y=posArr[2] as integer
	
					--format "% % \n" x y
				-- add to a new array
					if cArr[y]==undefined then cArr[y]=#()
					if cArr[y][x]==undefined then cArr[y][x]=s
				)
			)
		-- go through new array and print
			local c
			local str=""
			local currType="",prevType=""
			for y = 1 to cArr.count do
				(
				if cArr[y]!=undefined then
					(
					-- newline if new Y
					--if (currType == prevType)then 

					for x = 1 to cArr[y].count do
						(
						if cArr[y][x]!=undefined then
							(
							c=cArr[y][x]
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

