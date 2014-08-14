/*-----------------------------------------------------------------------------------------------------
-- VMS Tidy
-------------------------------------------------------------------------------------------------------

--	Date: 			18th Feb 2005
--	Version: 		1.0
--	Author: 		Dave Stewart
--	Contact:		3dsmax@pondskata.com / www.pondskata.com
--	Max Version:	6.0+ (Haven't tested below, let me know if it works)

--	Overview
	Visual Max Script is a great tool for quickly fleshing out a user interface for your latest script, 
	but the code it writes is messy to say the least. 

	VMS Tidy will take that mess and order it into something structured and readable, making it easy to 
	start coding around it.

--	Instructions
	Be sure to distribute both the script file, and the help file.

--	File updates.
	1.0
		Finished main script
	
	1.01
		Updated scope issue with Help
	1.02
		Updated user interface to include Auto rename (currently unimplimented) and Dialog Box Size
		
-----------------------------------------------------------------------------------------------------*/
	struct VMSTidySettings	(iniFile, size, height, str)

	(
	-- ini file
		local iniFile = (getDir #plugcfg)+"\VMSTidy.ini"

	-- rollout size
		global size = (getinisetting iniFile "" "size") as number
		if size == 0 then size=2
		local height=case size of
			(
			1:	400
			2:	724
			3:	1100
			default:724
			)
	-- settings object
		global VMSTidySettings = VMSTidySettings iniFile:iniFile size:size height:height str:""
	)

	global VMSTidyFloater

-------------------------------------------------------------------------------------------------------
-- global declarations
-------------------------------------------------------------------------------------------------------
rollout VMSTidyRo "Copy and paste rollout code below..." width:800 height:800 -- "VMS (Visual MaxScript) Tidy"
(
	---------------------------------------------------------------------------------------------------
	-- declarations
	---------------------------------------------------------------------------------------------------

	local roSize=point2 100 25
	local errStr="There was an error processing the rollout code.\n\nTo see the error, click Edit and evaluate the script manually by pressing CTRL+E."
	local iniFile = (getDir #plugcfg)+"\VMSTidy.ini"

	---------------------------------------------------------------------------------------------------
	-- Sample Code
	---------------------------------------------------------------------------------------------------

	local uiStrArr=#("",

	"
	GroupBox grpColStatus \"Status\" pos:[8,8] width:184 height:40
	checkbutton chkColStatus \"Enabled\" pos:[16,24] width:166 height:16 toolTip:\"Click to enable / disable on create\" checked:true highlightColor:(color 197 220 197)
	GroupBox grpCol \"Base\" pos:[8,56] width:184 height:48
	colorPicker cpClrBluBas \"\" pos:[132,233] width:24 height:16 enabled:false color:(color 64 128 255)
	colorPicker cpClr \"\" pos:[16,72] width:168 height:24 color:(color 237 178 50) title:\"Choose a color\"
	GroupBox grpColVar \" +/- \" pos:[8,112] width:184 height:168
	spinner spnClrRedVar \"Red \" pos:[39,137] width:56 height:16 range:[0,255,200] type:#integer
	colorPicker cpClrRedMin \"\" pos:[103,137] width:24 height:16 enabled:false color:(color 64 128 255)
	label lblClrRedMin \"000\" pos:[108,156] width:20 height:16
	colorPicker cpClrRedBas \"\" pos:[132,137] width:24 height:16 enabled:false color:(color 64 128 255)
	colorPicker cpPrv3 \"\" pos:[48,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpClrGrnBas \"\" pos:[132,185] width:24 height:16 enabled:false color:(color 64 128 255)
	colorPicker cpClrGrnMax \"\" pos:[161,185] width:24 height:16 enabled:false color:(color 64 128 255)
	label lblClrGrnMax \"000\" pos:[166,204] width:20 height:16
	spinner spnClrBluVar \"Blue \" pos:[36,232] width:59 height:16 range:[0,255,50] type:#integer--
	colorPicker cpPrv5 \"\" pos:[80,364] width:20 height:16 enabled:false color:(color 255 255 255)
	label lblClrRedMax \"000\" pos:[166,156] width:20 height:16
	colorPicker cpPrv4 \"\" pos:[64,364] width:20 height:16 enabled:false color:(color 255 255 255)
	label lblClrGrnMin \"000\" pos:[108,204] width:20 height:16
	spinner spnClrGrnVar \"Green \" pos:[30,185] width:65 height:16 range:[0,255,100] type:#integer--
	colorPicker cpPrv7 \"\" pos:[112,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpPrv8 \"\" pos:[128,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpClrGrnMin \"\" pos:[103,185] width:24 height:16 enabled:false color:(color 64 128 255)
	label lblClrBluMax \"000\" pos:[166,252] width:20 height:16
	colorPicker cpClrRedMax \"\" pos:[161,137] width:24 height:16 enabled:false color:(color 64 128 255)
	colorPicker cpPrv2 \"\" pos:[32,364] width:20 height:16 enabled:false color:(color 255 255 255)
	GroupBox grpColGen \"Colour Generation\" pos:[8,288] width:184 height:50
	radiobuttons rdoColGen \"\" pos:[16,308] width:149 height:16 labels:#(\"Random\", \"Smooth\") columns:2
	GroupBox grpPrv \"Preview\" pos:[8,344] width:184 height:48
	colorPicker cpPrv1 \"\" pos:[16,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpPrv6 \"\" pos:[96,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpPrv9 \"\" pos:[144,364] width:20 height:16 enabled:false color:(color 255 255 255)
	colorPicker cpClrBluMin \"\" pos:[103,233] width:24 height:16 enabled:false color:(color 64 128 255)
	label lblClrBluMin \"000\" pos:[108,252] width:20 height:16
	colorPicker cpClrBluMax \"\" pos:[161,233] width:24 height:16 enabled:false color:(color 64 128 255)
	colorPicker cpPrv10 \"\" pos:[160,364] width:20 height:16 enabled:false color:(color 255 255 255)",
	
	"
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
	button btnWeb \"Report bugs\" pos:[896,24] width:76 height:16",

	"
	GroupBox grpButton \"Objects\" pos:[8,8] width:72 height:104
	pickbutton btn1 \"PickButton\" pos:[16,24] width:56 height:16
	GroupBox grpSpn \"Values\" pos:[88,8] width:104 height:104
	spinner spn1 \"Spn1\" pos:[104,24] width:70 height:16
	GroupBox grpColor \"Color\" pos:[200,8] width:160 height:104
	radiobuttons rdo1 \"\" pos:[208,24] width:155 height:16 labels:#(\"1\", \"2\", \"3\", \"4\", \"5\") default:3 columns:5
	checkbutton ckb1 \"CheckButton\" pos:[16,40] width:56 height:16
	spinner spn2 \"Spn1\" pos:[104,40] width:70 height:16 range:[0,100,0]
	colorPicker cp1 \"\" pos:[208,40] width:144 height:64
	checkbox chk3 \"Yes\" pos:[16,56] width:56 height:16
	spinner spn3 \"Spn1\" pos:[104,56] width:70 height:16 range:[0,100,0]
	checkbox chk1 \"No\" pos:[16,72] width:56 height:16
	spinner spn4 \"Spn1\" pos:[104,72] width:70 height:16 range:[0,100,0]
	checkbox chk2 \"Maybe\" pos:[16,88] width:56 height:16
	spinner spn5 \"Spn1\" pos:[104,88] width:70 height:16 range:[0,100,0]
	GroupBox grpBody \"Body Parts\" pos:[8,120] width:184 height:144
	slider sld1 \"\" pos:[80,136] width:104 height:25
	GroupBox grpList \"GroupBox Lists\" pos:[200,120] width:160 height:144
	listbox lbx1 \"\" pos:[208,136] width:72 height:6 items:#(\"Hello\", \"My\", \"Name\", \"Is\", \"Barney\")
	listbox lbx2 \"\" pos:[280,136] width:72 height:6 items:#(\"What's\", \"The\", \"Story\", \"Morning\", \"Glory\")
	label lbl1 \"Fingers\" pos:[16,141] width:56 height:16
	slider sld4 \"\" pos:[80,160] width:104 height:25 range:[0,100,25]
	label lbl2 \"Thumbs\" pos:[16,165] width:56 height:16
	slider sld5 \"\" pos:[80,184] width:104 height:25 range:[0,100,50]
	label lbl3 \"Hands\" pos:[16,189] width:56 height:16
	slider sld6 \"\" pos:[80,208] width:104 height:25 range:[0,100,75]
	label lbl4 \"Legs\" pos:[16,213] width:56 height:16
	button btn3 \"Button\" pos:[208,224] width:144 height:24
	slider sld7 \"\" pos:[80,232] width:104 height:25 range:[0,100,100]
	label lbl5 \"Sparrows\" pos:[16,237] width:56 height:16
	progressBar pb1 \"ProgressBar\" pos:[208,248] width:144 height:8 value:50"

	)


	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------

	GroupBox grpCode "Code" pos:[8,8] width:209 height:40
	button btnTidy "Tidy..." pos:[16,24] width:114 height:16 toolTip:"Tidies the code..."
	checkbox chkRename "Auto-number" pos:[132,24] width:78 height:16 enabled:false

	GroupBox grpTools "Tools" pos:[216,8] width:216 height:40
	button btnEdit "Edit..." pos:[224,24] width:72 height:16 toolTip:"Edit the code in a new MaxScript editor window..."
	button btnTest "Test..." pos:[296,24] width:70 height:16 enabled:true toolTip:"Create a new rollout..."
	checkbox chkTidy "Auto-tidy" pos:[368,24] width:62 height:16 checked:true

	GroupBox grpHelp "Help" pos:[440,8] width:89 height:40
	button btnHelp "Instructions" pos:[448,24] width:72 height:16 toolTip:"Open the help file..."

	GroupBox grpSample "Sample Code" pos:[528,8] width:120 height:40
	dropdownList ddlSample "" pos:[536,22] width:106 height:21 items:#("", "Vertical Layout", "Horizontal Layout", "Mixed Layout")

	GroupBox grpSize "Dialog Box Size" pos:[656,8] width:112 height:40
	dropdownList ddlSize "" pos:[664,22] width:98 height:21 items:#("Small", "Medium", "Large") selection:VMSTidySettings.size

	edittext edt1 "" pos:[8,56] width:760 fieldwidth:768 height:(VMSTidySettings.height-100)

	---------------------------------------------------------------------------------------------------
	-- Utility Functions
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

	fn replaceAll str inStr outStr=
		(
		while (local i=findstring str inStr) != undefined do str=replace str i 1 outStr
		--format ">%\n" str
		return str
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
						--format "> %\n" arr[y][x]
						)
					)
				)
			)
		return tmpArr
		)


	fn createScript=
		(
		local w=int (roSize.x +4) as string
		local h=int (roSize.y +4) as string
		local str="--UI Tidy test rollout\n\n"+
			"try(destroyDialog VMSTidyTestRo);catch()\n\n"+
			"rollout VMSTidyTestRo \"VMS Tidy - Test Rollout\" width:"+w+" height:"+h+"\n"+
			"	(\n"+
			edt1.text as string+
			"\n	)\n\n"
		return str
		)


	---------------------------------------------------------------------------------------------------
	-- Main Tidy Function
	---------------------------------------------------------------------------------------------------

	fn tidy reorder:true=
		(
		-----------------------------------------------------------------
		--	variables
			roSize=point2 100 25
			local str, strArr=#(), uiItemArr=#(), uiGroupArr=#(), uiArr=#()
			local uiType,x,y,w,h,s
			struct uiItem (type,x,y,w,h,string,linebreak)
		
		-----------------------------------------------------------------
		--	get string and put into array
		str=edt1.text
		strArr=filterstring str "\r\n"
		
		-----------------------------------------------------------------
		--	PARSE ARRAY INTO A NEW ARRAY uiItemArr OF uiItem STRUCTS
		-----------------------------------------------------------------

		for s in strArr do
			(
			x=0
			y=0
			---------------------------------------------------------
			--	strip whitespace

				while substring s 1 1 == "\t" do s=substring s 2 -1
				while substring s 1 1 == " " do s=substring s 2 -1

			if s.count>0 then
				(
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
	
					-- line-break / comment
						i=findstring s "--"
						local linebreak=(i != undefined)
						--messagebox (linebreak as string)

	
				---------------------------------------------------------
				--	finalise uiItem properties
				
					-- move dropdown lists slightly
					--	if stricmp type "dropDownList" == 0 then y+=2
	
	
				---------------------------------------------------------
				--	set ro dimensions
				
					if x+w > roSize.x then roSize.x=x+w
					if y+h > roSize.y then roSize.y=y+h
	
	
				---------------------------------------------------------
				--	create item and add to arrays
	
					local ui=uiItem type:type x:x y:y w:w h:h string:s linebreak:linebreak
	
					-- create y entry (row)
						if uiItemArr[y]==undefined then uiItemArr[y]=#()
						
					-- create x entry (column)
						if type=="groupBox" then
							(
							-- add to ui array
								if uiItemArr[y][x]==undefined then uiItemArr[y][x]=#(ui)
							-- add to group lookup
								if uiGroupArr[y]==undefined then uiGroupArr[y]=#()
								if uiGroupArr[y][x]==undefined then uiGroupArr[y][x]=ui
							)
						else
							(
							-- add to ui array
								uiItemArr[y][x]=ui
							)
				)
			)
			
		--format "Items added OK\n"

		-------------------------------------------------------------
		-- ORDER ARRAYS
		-----------------------------------------------------------------


		if reorder then
			(
			uiGroupArr=orderArray uiGroupArr
			--for i = 1 to uiGroupArr.count do format "%,% %\n" uiGroupArr[i].x uiGroupArr[i].y uiGroupArr[i].string
	
			--uiItemArr=orderArray uiItemArr
			--for i = 1 to uiItemArr.count do format "%,% %\n" uiItemArr[i].x uiItemArr[i].y uiItemArr[i].string
	
	
			--messagebox (uiGroupArr as string)
			-------------------------------------------------------------
			-- FIRST RUN THROUGH NEW ARRAY - Move controls to groups
			-------------------------------------------------------------
	
			for y = 1 to uiItemArr.count do
				(
				if uiItemArr[y]!=undefined then
					(
					for x = 1 to uiItemArr[y].count do
						(
						if uiItemArr[y][x]!=undefined then
							(
							if classof uiItemArr[y][x] != Array then
								(
								for g = 1 to uiGroupArr.count do
									(
									if isIn uiGroupArr[g] uiItemArr[y][x] then
										(
										append uiItemArr[uiGroupArr[g].y][uiGroupArr[g].x] uiItemArr[y][x]
										uiItemArr[y][x]=undefined
										exit
										)
									)
								)
							)
						)
					)
				)
	
			-------------------------------------------------------------
			-- SECOND RUN THROUGH NEW ARRAY
			-- Reduce array, and build rollout code
			-------------------------------------------------------------
	
			uiItemArr=orderArray uiItemArr
	
	--		messagebox "Items successfully re-ordered!"
			--for i = 1 to uiItemArr.count do format "% % \n" i uiItemArr[i]
	
			str=""
			local group=false
			local y=0
			for i = 1 to uiItemArr.count do
				(
				if classof uiItemArr[i] == Array then
					(
					str+="\n"
					group=true
					for j = 1 to uiItemArr[i].count do
						(
						if j == 1 then str+="	"+uiItemArr[i][j].string+"\n"
						else
							(
							if uiItemArr[i][j].linebreak==true then str+="\n"
							str+="		"+uiItemArr[i][j].string+"\n"
							)
						)
					)
				else(
					if group==true then str+="\n"
					if uiItemArr[i].linebreak==true then str+="\n"
					str+="	"+uiItemArr[i].string+"\n"
					group=false
					)
				)	
			edt1.text=str
			)
		)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------



	
	on VMSTidyRo open do
		(
		-- insert text (if any)
			local str=VMSTidySettings.str
			str=replaceAll str "\r" ""
			edt1.text=str
		)
/*
	on ro1 resized size do
		(
		h=size[2]
		ro1.height=h-35
		for c in ro1.controls do
			(
			local x=c.pos[1]
			local y=h-56
			c.pos=[x,y]
			)
		edt1.pos=[8,8]
		format "%\n" edt1.height
		)
*/

	on btnTidy pressed do
		(
		if edt1.text.count>0 then
			(
			try(tidy());catch(messagebox errStr)
			)
		)

	on btnEdit pressed do
		(
		-- tidy
			try(tidy reorder:chkTidy.state);catch(messagebox errStr)
		-- dump to new window
			local VMSTidyTestStr=createScript()
			if (uiScriptWin==undefined) OR ((uiScriptWin as string).count<10) then uiScriptWin=newScript()
			format "%\n" VMSTidyTestStr to:uiScriptWin
			format "%\n" "createDialog VMSTidyTestRo\n" to:uiScriptWin
	
		)

	on btnTest pressed do
		(
		if edt1.text.count>0 then
			(
			-- tidy
				try(tidy reorder:chkTidy.state);catch()
			-- create new rollout
				global VMSTidyTestRo
				try	(
					execute (createScript())
					try (destroyDialog VMSTidyTestRo);catch()
					try (createDialog VMSTidyTestRo);catch(messageBox errStr)
					)
				catch(
					messageBox errStr
					)
			)
		)


	global VMSTidyHelp, helpStr
	on btnHelp pressed do
		(
		try(destroyDialog VMSTidyHelp);catch()

		local f=(openfile "VMSTidy.html")
		if f!= undefined then
			(
			flush f; close f
	
			helpStr=f as string
			helpStr = substring helpStr 7 (helpStr.count-7)
			helpStr=replaceAll helpStr "\\" "/"
			execute("rollout VMSTidyHelp \"VMS Tidy Help\"(activeXControl ax \"file://"+helpStr+"\" pos:[6,6] width:400 height:600)")
			createdialog VMSTidyHelp 412 612
			)
		else messageBox "Help file not found..."
		)
	
	on ddlSample selected item do edt1.text = uiStrArr[item]
	
	on chkClear changed val do
		(
		edt1.text=""
		chkClear.checked=false
		rdoSample.state = 0
		)

	on ddlSize selected item do
		(
		-- get selection
			local height=#(400,724,1100)[item]
		-- set settings
			setinisetting iniFile "" "size" (item as string)
			VMSTidySettings.size=item
			VMSTidySettings.height=height
			VMSTidySettings.str=edt1.text
		-- resize
			VMSTidyFloater.size=[800,height]
			removeRollout VMSTidyRo VMSTidyFloater
			addRollout VMSTidyRo VMSTidyFloater
		-- sort text
			--VMSTidyFloater.edt1.text=VMSTidySettings.str

		)

	--on edt1 changed value do btnTest.enabled = value.count>0
)
/*
try(destroydialog VMSTidyRo);catch()
createDialog VMSTidyRo 800 724 10 10 style:#(#style_minimizebox,#style_titlebar, #style_border, #style_sysmenu)
*/

if VMSTidyFloater != undefined then closerolloutfloater VMSTidyFloater
	VMSTidyFloater = newRolloutFloater "VMS (Visual MaxScript) Tidy" 800 VMSTidySettings.height 10 10
addRollout VMSTidyRo VMSTidyFloater

/*
*/