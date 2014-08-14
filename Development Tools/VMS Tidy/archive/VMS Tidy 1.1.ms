/*-----------------------------------------------------------------------------------------------------
-- VMS Tidy
-------------------------------------------------------------------------------------------------------

--	Date: 			21st Feb 2005
--	Version: 		1.3
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
	1.03
		Improved code parsing
		Improved linebreak insertion code
		Included check to strip out irrelevant code
		More informative error messaging, now checks for variables in code too
		Added Copy/Paste buttons (Avguard extensions needed)
		Added auto-renumbering of unnamed controls
	1.04
		Added clear and undo/redo functionality


-- Notes on formatting
	place standard properties at the start
	place arrays and other stuff at the end
	properties should NOT have spaces in them, ie - pos:[10,10], as opposed to pos: [10,10]
		
-----------------------------------------------------------------------------------------------------*/
	struct VMSTidySettings	(iniFile, size, height, str)
	(
		-- ini file
			local iniFile = (getDir #plugcfg)+"\VMSTidy.ini"
	
		-- rollout size
			global size = (getinisetting iniFile "settings" "size") as number
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
	local undoStack=#()
	local undoIndex=0
	local undoMax=20

	local controlTypeArr=#(
		#angle,
		#activeXControl,
		#bitmap,
		#button,
		#checkbox,
		#checkbutton,
		#colorpicker,
		#combobox,
		#curvecontrol,
		#dropdownlist,
		#edittext,
		#groupBox,
		#hyperLink,
		#imgTag,
		#label,
		#listbox,
		#mapbutton,
		#materialbutton,
		#multilistbox,
		#pickbutton,
		#popUpMenu,
		#progressbar,
		#radiobuttons,
		#slider,
		#spinner,
		#subRollout,
		#timer
	)

	struct VMSTidyControlList(
		ax=0,
		bmp=0,
		btn=0,
		chk=0,
		chb=0, ckb=0,
		cp=0,
		cbx=0,
		curv=0,
		ddl=0, dd=0,
		edt=0,
		grp=0,
		hyp=0,
		img=0,
		lbl=0,
		lbx=0,
		mapbutton=0,
		materialbutton=0,
		mlbx=0, mList=0, 
		pck=0, pickbutton=0,
		pop=0, popUpMenu=0,
		pb=0, progressbar=0,
		rdo=0,
		sld=0,
		spn=0,
		sub=0, subRoll=0,
		tmr=0
	)
/*
*/

	---------------------------------------------------------------------------------------------------
	-- Sample Code
	---------------------------------------------------------------------------------------------------

	local sampleArr=#("",

	"
	GroupBox grpButton \"Objects\" pos:[8,8] width:72 height:104
	pickbutton btn1 \"PickButton\" pos:[16,24] width:56 height:16
	GroupBox grpSpn \"Values\" pos:[88,8] width:104 height:104
	spinner spn5 \"Spn1\" pos:[104,24] width:70 height:16
	GroupBox grpColor \"Color\" pos:[200,8] width:160 height:104
	radiobuttons rdo1 \"\" pos:[208,24] width:155 height:16 labels:#(\"1\", \"2\", \"3\", \"4\", \"5\") default:3 columns:5
	checkbutton ckb1 \"CheckButton\" pos:[16,40] width:56 height:16
	spinner spn4 \"Spn1\" pos:[104,40] width:70 height:16 range:[0,100,0]
	colorPicker cp1 \"\" pos:[208,40] width:144 height:64
	checkbox chk3 \"Yes\" pos:[16,56] width:56 height:16
	spinner spn1 \"Spn1\" pos:[104,56] width:70 height:16 range:[0,100,0]
	checkbox chk1 \"No\" pos:[16,72] width:56 height:16
	spinner spn2 \"Spn1\" pos:[104,72] width:70 height:16 range:[0,100,0]
	checkbox chk2 \"Maybe\" pos:[16,88] width:56 height:16
	spinner spn3 \"Spn1\" pos:[104,88] width:70 height:16 range:[0,100,0]
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
	progressBar pb1 \"ProgressBar\" pos:[208,248] width:144 height:8 value:50",

	"GroupBox grpColStatus \"Status\" pos:[8,8] width:184 height:40
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
	button btnWeb \"Report bugs\" pos:[896,24] width:76 height:16"

)


	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------

	GroupBox grpCode "Code" pos:[8,8] width:161 height:40
		button btnTidy "Tidy..." pos:[16,24] width:78 height:16 toolTip:"Tidies the code..."
		checkbox chkRenum "Renumber" pos:[96,24] width:68 height:16

	GroupBox grpEdit "Edit" pos:[168,8] width:80 height:40
		button btnCopy "C" pos:[176,24] width:16 height:16 toolTip:"Copy script"
		button btnPaste "P" pos:[192,24] width:16 height:16 enabled:true toolTip:"Paste script"
		button btnClear "x" pos:[208,24] width:16 height:16 enabled:true toolTip:"Clear script"
		--button btnUndo "<" pos:[224,24] width:16 height:16 enabled:true toolTip:"Undo"
		button btnUndo "<" pos:[224,24] width:8 height:16 enabled:true toolTip:"Undo"
		button btnRedo ">" pos:[232,24] width:8 height:16 enabled:true toolTip:"Undo"


	GroupBox grpTools "Tools" pos:[256,8] width:184 height:40
		button btnEdit "Edit..." pos:[264,24] width:56 height:16 toolTip:"Edit the code in a new MaxScript editor window..."
		button btnTest "Test..." pos:[320,24] width:54 height:16 enabled:true toolTip:"Create a new rollout..."
		checkbox chkTidy "Auto-tidy" pos:[376,24] width:62 height:16 checked:true

	GroupBox grpHelp "Help" pos:[448,8] width:81 height:40
		button btnHelp "Instructions" pos:[456,24] width:64 height:16 toolTip:"Open the help file..."

	GroupBox grpSample "Sample Code" pos:[528,8] width:120 height:40
		dropdownList ddlSample "" pos:[536,22] width:106 height:21 items:#("", "Mixed Layout", "Vertical Layout", "Horizontal Layout") toolTip:"Play with some sample code..."

	GroupBox grpSize "Dialog Box Size" pos:[656,8] width:112 height:40
		dropdownList ddlSize "" pos:[664,22] width:98 height:21 items:#("Small", "Medium", "Large")

	edittext edtCode "" pos:[8,56] width:760 fieldwidth:768 height:(VMSTidySettings.height-100) --height:724 

	---------------------------------------------------------------------------------------------------
	-- Utility Functions
	---------------------------------------------------------------------------------------------------

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

	fn stripWhiteSpace s=
	(
		-- start of line
			while substring s 1 1 == "\t" do s=substring s 2 -1
			while substring s 1 1 == " " do s=substring s 2 -1
		-- end of line
			while substring s (s.count) 1 == "\t" do s=substring s 1 (s.count-1)
			while substring s (s.count) 1 == " " do s=substring s 1 (s.count-1)
		-- return
			return s
	)

	---------------------------------------------------------------------------------------------------
	-- UI Functions
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

	fn createScript=
	(
		local w=int (roSize.x +4) as string
		local h=int (roSize.y +4) as string
		local str="--VMS Tidy test rollout\n\n"+
			"try(destroyDialog VMSTidyTestRo);catch()\n\n"+
			"rollout VMSTidyTestRo \"VMS Tidy - Test Rollout\" width:"+w+" height:"+h+"\n"+
			"	(\n"+
			edtCode.text as string+
			"\n	)\n\n"
		return str
	)

	---------------------------------------------------------------------------------------------------
	-- Undo Functions
	---------------------------------------------------------------------------------------------------

	fn setUndoStack =
	(
		--messagebox "set undo"
		-- indexes
			if undoIndex < undoMax then
			(
			-- index
				undoIndex+=1
			-- stack
				if undoStack.count==undoMax then undoStack=deleteItem undoStack 1
				append undoStack edtCode.text
				undoStack.count=undoIndex
			)
		-- interface
			btnUndo.tooltip="Undos left: "+(undoIndex-1) as string
			btnRedo.tooltip="Redos left: "+(undoStack.count - undoIndex) as string
			btnUndo.enabled=undoIndex>1
			btnRedo.enabled=undoIndex<undoStack.count
	)

	fn getUndoStack v =
	(
		--format "undoIndex: %\n" undoIndex
		-- index
			if v<0 then
			(
	 			--undo
				if undoIndex>1 then undoIndex-=1
			)
			else if v>0 then
			(
				-- redo
				if undoIndex<undoStack.count then undoIndex+=1
			)
		-- stack
			edtCode.text=replaceAll undoStack[undoIndex] "\r" ""
		-- interface
			btnUndo.tooltip="Undos left: "+(undoIndex-1) as string
			btnRedo.tooltip="Redos left: "+(undoStack.count - undoIndex) as string
			btnUndo.enabled=undoIndex>1
			btnRedo.enabled=undoIndex!=undoStack.count
	)

/*
testUndo()

fn testUndo=
(
	local undoStack=VMSTidyRo.undoStack

	format "=======================================\n\nundoStack: "
	for i = 1 to undoStack.count do
	(
		if undoStack[i] != undefined then str = (substring undoStack[i] 1 60)
		else str="undefined"
		format "%:[%]\n" i str
	)
	format "\nundoStack count: % " undoStack.count
	format "\nundoIndex: %\n " VMSTidyRo.undoIndex
)
*/

	---------------------------------------------------------------------------------------------------
	-- Main Tidy Function
	---------------------------------------------------------------------------------------------------

	fn tidy reorder:true=
	(
		clearListener()
		-----------------------------------------------------------------
		--	variables
			roSize=point2 100 25
			local str, strArr=#(), uiItemArr=#(), uiGroupArr=#(), uiArr=#(), badLineArr=#()
			local itemType,itemName,x=0,y=0,w,h,itemString
			struct uiItem (type,x,y,w,h,string,linebreak)
			local controlList=VMSTidyControlList()
			local logErrors=true
		
		-----------------------------------------------------------------
		--	get string and put into array
			strArr=filterstring edtCode.text"\r\n"
		
		-----------------------------------------------------------------
		--	PARSE ARRAY INTO A NEW ARRAY uiItemArr OF uiItem STRUCTS
		-----------------------------------------------------------------

		for s in strArr do
		(
			---------------------------------------------------------
			s = stripWhiteSpace s

			try(
				if s.count>0 then
				(
					---------------------------------------------------------
					-- full string
						itemString=s
	
					---------------------------------------------------------
					-- start breaking string down to get propeties
					-- <item_type> <name> [ <label_string> ] [ <parameters> ]
		
						local i, str, tmpArr	-- temp strings
						
						-- kill crappy code
							if matchpattern s pattern:"rollout*" then continue
							if matchpattern s pattern:"(" then continue
							if matchpattern s pattern:")" then continue
							if (filterstring s " \t").count < 3 then continue
	
	
						-- commenting
							local comment=substring s 1 2
	
							if comment == "--" then s = substring s 3 -1
							else if  comment== "/*" then
							(
								append badLineArr s
								continue
							)
	
						-- type
							-- get substring
								--format "> %\n" s
								i=(findstring s " ")-1
								if i==undefined then continue
	
								itemType=((substring s 1 i) as name)
								--format ">%\n" itemType--(substring s 1 i)
	
							-- pass string on
								s=substring s (i+1) -1
								s= stripWhiteSpace s
	
							-- parse substring
								if findItem controlTypeArr itemType == 0 then
								(
									if logErrors then append badLineArr ("/* unsupported control type */ -- " +s)
									continue
								)
	
	
	
						-- name / number
							-- get substring
								i=(findstring s " ")-1
								if i==undefined then continue
	
								itemName=substring s 1 i
	
							-- pass string on
								s=substring s (i+1) -1
								s= stripWhiteSpace s
	
							-- get name / number
								local n, numStr=itemName, nameStr=""
								while (numStr as number == undefined) do
								(
									numStr=substring numStr 2 -1
								)
								nameStr=substring itemName 1 (itemName.count-numStr.count)
								if numStr != "" then n= numStr as number
								
								--format ">% - %\n" nameStr numStr
	
							-- autonumber
								if chkRenum.checked then
								(
									local prop=try(getproperty controlList nameStr);catch(undefined)
									if prop != undefined then
									(
										setProperty controlList nameStr (prop+1)
										local newItemName=nameStr+((prop+1)as string)
										itemString = itemType as string + " " + newItemName + " " + s
									)
								)
		
						-- x,y
							i=findstring s "pos:["
							if i != undefined then
							(
								str=substring s (i+5) -1
								str=(filterstring str "]")[1]
								tmpArr=filterstring str ","
								x=tmpArr[1] as integer
								y=tmpArr[2] as integer
								--format "x: % y: % \n" x y
								if x==undefined OR y==undefined then
								(
									append badLineArr ("/* x/y property as undefined variable */ -- " +itemString)
									continue
								)
							)
							else
							(
								append badLineArr ("/* missing position property */ -- " +itemString)
								continue
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
	
						-- check for correct width and height						
							if w==undefined OR h==undefined then
							(
								append badLineArr ("/* width/height property as undefined variable */ -- " +itemString)
								continue
							)
		
						-- line-break / comment
							local linebreak= (substring s (s.count-1) 2)=="--"
							--messagebox (linebreak as string)
	
		
					---------------------------------------------------------
					--	finalise uiItem properties
					
						-- move dropdown lists slightly
						--	if stricmp type "dropDownList" == 0 then y+=2
		
		
					---------------------------------------------------------
					--	set ro dimensions
					
						if(w!=undefined AND h!=undefined) then
						(
							if x+w > roSize.x then roSize.x=x+w
							if y+h > roSize.y then roSize.y=y+h
						)
		
		
					---------------------------------------------------------
					--	create item and add to arrays
						local ui=uiItem type:itemType x:x y:y w:w h:h string:itemString linebreak:linebreak
		
						-- create y entry (row)
							if uiItemArr[y]==undefined then uiItemArr[y]=#()
							
						-- create x entry (column)
							if itemType==#groupBox then
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
					)-- end if
				)-- end try
			catch(
				if logErrors then append badLineArr ("/* unknown error */ -- " +s)
			)
				
			)-- end for loop
			
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

			if badLineArr.count > 0 then str+="\n\n"

			for i = 1 to badLineArr.count do
			(
				str+="	"+badLineArr[i]+"\n"
			)

			edtCode.text=str
		)
		-- update interface / undo
			chkRenum.checked=false
			setUndoStack()
	)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------



	
	on VMSTidyRo open do
	(
		-- insert text (if any)
			local str=VMSTidySettings.str
			str=replaceAll str "\r" ""
			edtCode.text=str
		-- update interface
			ddlSize.selection=VMSTidySettings.size
			btnUndo.enabled=false
			btnRedo.enabled=false
			if getClipboardText == undefined then btnPaste.enabled=btnCopy.enabled=false
		-- load in script for testing
			--ddlSample.selection=4
			--edtCode.text = sampleArr[4]
		-- undo
			setUndoStack()
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
		edtCode.pos=[8,8]
		format "%\n" edtCode.height
	)
*/

	on btnTidy pressed do
	(
		if edtCode.text.count>0 then
		(
			tidy()
			--try();catch(messagebox errStr)
		)
	)

	on btnCopy pressed do if edtCode.text.count>0 then setClipboardText edtCode.text

	on btnPaste pressed do
	(
		local str=replaceAll (getClipboardText()) "\r" "\n"
		edtCode.text=str
		setUndoStack()
	)

	on btnClear pressed do
	(
		edtCode.text=""
	)

	on btnUndo pressed do
	(
		getUndoStack -1
	)

	on btnRedo pressed do
	(
		getUndoStack 1
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
		if edtCode.text.count>0 then
		(
			-- tidy
				try(tidy reorder:chkTidy.state);catch()
			-- create new rollout
				global VMSTidyTestRo
				try(
					execute (createScript())
					try (destroyDialog VMSTidyTestRo);catch()
					try (createDialog VMSTidyTestRo);catch(messageBox errStr)
				)
				catch(
					messageBox errStr
				)
		)
	)


	global VMSTidyHelp

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
	
	on ddlSample selected item do
	(
		edtCode.text = sampleArr[item]
		setUndoStack()
	)
	
	on edtCode entered text do
	(
		format "-- undo created\n"
		setUndoStack()
	)

	on ddlSize selected item do
	(
		-- get selection
			local height=#(400,724,1100)[item]
		-- set settings
			setinisetting iniFile "settings" "size" (item as string)
			VMSTidySettings.size=item
			VMSTidySettings.height=height
			VMSTidySettings.str=edtCode.text
		-- resize
			VMSTidyFloater.size=[800,height]
			removeRollout VMSTidyRo VMSTidyFloater
			addRollout VMSTidyRo VMSTidyFloater
		-- sort text
			--VMSTidyFloater.edtCode.text=VMSTidySettings.str

	)

)
/*
try(destroydialog VMSTidyRo);catch()
createDialog VMSTidyRo 800 724 10 10 style:#(#style_minimizebox,#style_titlebar, #style_border, #style_sysmenu)
*/

if VMSTidyFloater != undefined then closerolloutfloater VMSTidyFloater
	VMSTidyFloater = newRolloutFloater "VMS (Visual MaxScript) Tidy" 800 VMSTidySettings.height 10 10
addRollout VMSTidyRo VMSTidyFloater
