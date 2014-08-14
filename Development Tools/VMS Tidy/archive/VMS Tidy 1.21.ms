/*-----------------------------------------------------------------------------------------------------
-- VMS Tidy
-------------------------------------------------------------------------------------------------------

--	Date: 			21st Feb 2005
--	Version: 		1.4
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
	1.1
		Added rename functionality
		Added basic variable handling functionality
		Improved parsing


-- Notes on formatting
	place standard properties at the start
	place arrays and other stuff at the end
	properties should NOT have spaces in them, ie - pos:[10,10], as opposed to pos: [10,10]
		
-----------------------------------------------------------------------------------------------------*/
	struct VMSTidySettings	(iniFile, str, size, height, tidyOpt)
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
			global VMSTidySettings = VMSTidySettings iniFile:iniFile str:"" size:size height:height tidyOpt:1
		)

	global VMSTidyFloater

-------------------------------------------------------------------------------------------------------
-- global declarations
-------------------------------------------------------------------------------------------------------
rollout VMSTidyVars "VMS Tidy - Variables" width:412 height:212
	(
	-- interface
		label lbl1 "If your rollout needs variables to run, you can enter them here..." pos:[8,8] width:400 height:16
		edittext edtCode "" pos:[4,24] width:404 height:164
		button btnDone "Done" pos:[8,192] width:400 height:16

	-- handlers
		on btnDone pressed do
			(
			destroydialog VMSTidyVars 
			)
	)


rollout VMSTidyOptions "VMS Tidy - Options" width:208 height:300
	(
	-- declarations
		local controlTypeArr=#(
			#("angle", "ang"),
			#("activeXControl", "ax act"),
			#("bitmap", "bmp"),
			#("button", "btn"),
			#("checkbox", "chk"),
			#("checkbutton", "chb ckb"),
			#("colorpicker", "cp cpk"),
			#("combobox", "cbx"),
			#("curvecontrol", "curv crv"),
			#("dropdownlist", "ddl dd"),
			#("edittext", "edt"),
			#("groupBox", "grp"),
			#("hyperLink", "hyp"),
			#("imgTag", "img"),
			#("label", "lbl"),
			#("listbox", "lbx"),
			#("mapbutton", "map"),
			#("materialbutton", "mtl"),
			#("multilistbox", "mlbx mList "),
			#("pickbutton", "pck"),
			#("popUpMenu", "pop"),
			#("progressbar", "pb"),
			#("radiobuttons", "rdo"),
			#("slider", "sld"),
			#("spinner", "spn"),
			#("subRollout", "sub subRoll"),
			#("timer", "tmr"),
			#("Custom", "")
			)
	
	-- interface
	
	GroupBox grpRename "Auto-Rename" pos:[8,8] width:232 height:232
	label lbl1 "Process the following prefixes:" pos:[16,24] width:176 height:16
	ActiveXControl ax "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" pos:[16,40] width:216 height:152 
	radiobuttons rdoLabel "Use the following words from label text:" pos:[16,200] width:201 height:30 labels:#("First word only", "All words") default:1 columns:2		
		
	GroupBox grpOther "Other" pos:[8,248] width:232 height:56
	radiobuttons rdoCode "When VMS Tidy processes dubious code:" pos:[16,264] width:173 height:30 enabled:true labels:#("Comment it", "Delete it") columns:2
		
	button btnDone "Done" pos:[8,312] width:232 height:16
	-- handlers
/*
	on VMSTidyOptions open do
	(
	local str=""
	for s in (getpropnames VMSTidy.VMSTidyControlList) do str+=((s as string) + "; ")
	--edtRename.text=str
	)
*/
		on VMSTidyOptions open do 
			(
			-- style
				ax.MousePointer = #ccArrow 
				ax.GridLines = true 
				ax.AllowColumnReorder = false 
				ax.BorderStyle = #ccFixedSingle 
				ax.view = #lvwReport
	
			-- set headers
				ch = ax.columnHeaders 
				hPrefix = ch.Add index:"Prefix"
				hControlName = ch.Add index:"Control"
		
			-- populate
				list = ax.listItems
				for i=1 to controlTypeArr.count do 
					(
					local itemHead, itemBody
					itemHead = list.Add index:(controlTypeArr[i][2] as string)
					itemBody = itemHead.listsubitems.add index:(controlTypeArr[i][1] as string)
					) 
		
			-- update interface
				ax.columnHeaders[1].position=2
				ax.refresh()
			)
	
		on ax BeforeLabelEdit arg do enableAccelerators=false
		on ax AfterLabelEdit arg1 arg2 do enableAccelerators=true
		on btnDone pressed do
			(
			destroydialog VMSTidyOptions
			)
	)

rollout VMSTidy "Copy and paste rollout code below..." width:800 height:800 -- "VMS (Visual MaxScript) Tidy"
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
		ax=0, act=0,
		bmp=0,
		btn=0,
		chk=0,
		chb=0, ckb=0,
		cp=0, cpk=0,
		cbx=0,
		curv=0, crv=0,
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

	include "VMS Tidy Sample Code.ms"

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------


	GroupBox grpCode "Code" pos:[8,8] width:165 height:40
		button btnTidy "Tidy..." pos:[16,22] width:68 height:20 toolTip:"Tidies the code..."
		dropdownList ddlTidyOpt "" pos:[84,22] width:84 height:21 items:#("", "+ renumber", "+ rename", "---------------------", "   Options...") toolTip:"Play with some sample code..."

	GroupBox grpEdit "Edit" pos:[172,8] width:100 height:40
		button btnCopy "C" pos:[180,24] width:16 height:16 toolTip:"Copy script"
		button btnPaste "P" pos:[196,24] width:16 height:16 enabled:true toolTip:"Paste script"
		button btnClear "x" pos:[212,24] width:16 height:16 enabled:true toolTip:"Clear script"
		button btnUndo "<" pos:[232,24] width:16 height:16 enabled:true toolTip:"Undo"
		button btnRedo ">" pos:[248,24] width:16 height:16 enabled:true toolTip:"Undo"

	GroupBox grpVars "Variables" pos:[280,8] width:81 height:40
		button btnVars "Manage..." pos:[288,24] width:64 height:16 toolTip:"Assign variables, other scripts, etc..."

	GroupBox grpTools "Rollout" pos:[368,8] width:169 height:40
		button btnEdit "New..." pos:[376,24] width:56 height:16 toolTip:"Edit the code in a new MaxScript editor window..."
		button btnTest "Test..." pos:[432,24] width:54 height:16 enabled:true toolTip:"Create a new rollout..."
		checkbox chkTidy "Tidy" pos:[488,24] width:40 height:16 checked:true

	GroupBox grpHelp "Help" pos:[544,8] width:81 height:40
		button btnHelp "Instructions" pos:[552,24] width:64 height:16 toolTip:"Open the help file..."

	GroupBox grpSample "Sample Layouts" pos:[624,8] width:97 height:40
		dropdownList ddlSample "" pos:[632,22] width:82 height:21 items:#("", "Mixed", "Vertical", "Horizontal") toolTip:"Play with some sample code..."

	GroupBox grpSize "Dialog Size" pos:[728,8] width:76 height:40
		dropdownList ddlSize "" pos:[736,22] width:62 height:21 items:#("Small", "Medium", "Large")

	edittext edtCode "" pos:[4,56] width:800 height:(VMSTidySettings.height-100) --height:724 

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

	fn stripIllegalChars str=
		(
		local legal="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
		local split=" "-- -/\|\t"
		str=(filterstring str split)[1]
		for i = str.count to 1 by -1 do
			(
			if findstring legal str[i] == undefined then
				(
				str=(substring str 1 (i-1))+(substring str (i+1) -1)
				)
			)
		return str
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
	local undoStack=VMSTidy.undoStack

	format "=======================================\n\nundoStack: "
	for i = 1 to undoStack.count do
		(
		if undoStack[i] != undefined then str = (substring undoStack[i] 1 60)
		else str="undefined"
		format "%:[%]\n" i str
		)
	format "\nundoStack count: % " undoStack.count
	format "\nundoIndex: %\n " VMSTidy.undoIndex
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
			local itemType,itemName,itemLabel,x=0,y=0,w,h,itemString
			struct uiItem (type,x,y,w,h,string,linebreak)
			local controlList=VMSTidyControlList()
			local logErrors=true
		
		-----------------------------------------------------------------
		--	get string and put into array
			str=replaceAll edtCode.text "\r" "\n"
			strArr=filterstring edtCode.text "\n\r"
		
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
							if matchpattern s pattern:"(*" then continue
							if matchpattern s pattern:")*" then continue
							if (filterstring s " \t").count < 3 then continue
	
	
						-- commenting
							local comment=substring s 1 2
	
							if comment == "--" then s = substring s 3 -1
							else if  comment== "/*" then
								(
								append badLineArr s
								continue
								)
	
						-- item type
							-- get substring
								--itemType itemName "itemLabel" itemParams

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
	
	
	
						-- item name
							-- get substring
								--itemName "itemLabel" itemParams
								i=(findstring s " ")-1
								if i==undefined then continue
	
								itemName=substring s 1 i
	
							-- pass string on
								s=substring s (i+1) -1
								s= stripWhiteSpace s



						-- item label
							--strip first quote
								--"itemLabel" itemParams
								s=substring s 2 -1
							-- get second quote
								--itemLabel" itemParams
								i=(findstring s "\"")-1
								if i==undefined then continue
	
								itemLabel=substring s 1 i


							-- pass string on
								s=substring s (i+2) -1
								s=stripWhiteSpace s
								--format "% \n" itemLabel s-- itemLabel



						-- Split name / number from itemName-----------------------------------

							-- get name / number
								local n=undefined
								local numStr=itemName, nameStr=""
								while (numStr as integer == undefined) do
									(
									numStr=((substring numStr 2 -1) as string)
									print (classof (numStr as Integer))
									)
								format ">% - % - %\n" n nameStr numStr 
								nameStr=substring itemName 1 (itemName.count-numStr.count)
								if numStr != "" then n= numStr as number
								
		
							-- Rename / renumber -----------------------------------
							
								if ddlTidyOpt.selection==2 then
									(
									-- autonumber
										local prop=try(getproperty controlList nameStr);catch(undefined)
										if prop != undefined then
											(
											setProperty controlList nameStr (prop+1)
											local newItemName=nameStr+((prop+1)as string)
											itemString = itemType as string + " " + newItemName + " \"" + itemLabel +"\" "+ s
											)
									)
								else if ddlTidyOpt.selection==3 AND n != undefined then
									(
									-- autoName
										if itemLabel != "" then
											(
											local newItemName=nameStr+(stripIllegalChars itemLabel)
											itemString = itemType as string + " " + newItemName + " \"" + itemLabel +"\" "+ s
											)
									)
										

/*	
*/
						-- Properties -----------------------------------

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
			--chkRenum.checked=false
			ddlTidyOpt.selection=1
			setUndoStack()
		)

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	
	------------------------------------------------------------------------------------------
	-- Tidy

		on btnTidy pressed do
			(
			if edtCode.text.count>0 then
				(
				tidy()
				--try();catch(messagebox errStr)
				)
			)
	
	-- Tidy Settings

		on ddlTidyOpt selected item do
			(
			if item <= 3 then
				(
				VMSTidySettings.tidyOpt=item
				)
			else
				(
				ddlTidyOpt.selection=VMSTidySettings.tidyOpt
				if item==5 then
				 	(
					try(destroyDialog VMSTidyVars);catch()
					createdialog VMSTidyOptions 246 336 modal:true
					)
				)
			)
	
	------------------------------------------------------------------------------------------
	-- Edit

		fn setBtnEditText=
			(
			btnEdit.text=if edtCode.text.count==0 then "New..." else "Edit..."
			)

		on edtCode entered text do
			(
			format "-- undo created\n"
			setUndoStack()
			setBtnEditText()
			)
	
		on edtCode changed text do
			(
			setBtnEditText()
			)
	
		on btnCopy pressed do if edtCode.text.count>0 then setClipboardText edtCode.text
	
		on btnPaste pressed do
			(
			local str=replaceAll (getClipboardText()) "\r" "\n"
			edtCode.text=str
			setUndoStack()
			setBtnEditText()
			)
	
		on btnClear pressed do
			(
			edtCode.text=""
			setBtnEditText()
			)
	
		on btnUndo pressed do
			(
			getUndoStack -1
			setBtnEditText()
			)
	
		on btnRedo pressed do
			(
			getUndoStack 1
			setBtnEditText()
			)


	------------------------------------------------------------------------------------------
	-- Variables

		global VMSTidyVars
		on btnVars pressed do
			(
			try(destroyDialog VMSTidyVars);catch()
			createdialog VMSTidyVars 416 212
			)
	
	
	------------------------------------------------------------------------------------------
	-- Rollout testing

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

	

	------------------------------------------------------------------------------------------
	-- Help

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
			try(
				edtCode.text = sampleArr[item]
				setUndoStack()
				setBtnEditText()
				)
			catch(messagebox "Sample Code file not found...")
			)



	------------------------------------------------------------------------------------------
	-- Resize

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
				VMSTidyFloater.size=[VMSTidyFloater.size[1],height]
				removeRollout VMSTidy VMSTidyFloater
				addRollout VMSTidy VMSTidyFloater
			-- sort text
				--VMSTidyFloater.edtCode.text=VMSTidySettings.str
	
			)

	------------------------------------------------------------------------------------------
	-- Open
		
		on VMSTidy open do
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
				setBtnEditText()

			-- load in script for testing
				--ddlSample.selection=4
				--edtCode.text = sampleArr[4]
			-- undo
				setUndoStack()
			)

)
/*
try(destroydialog VMSTidy);catch()
createDialog VMSTidy 800 724 10 10 style:#(#style_minimizebox,#style_titlebar, #style_border, #style_sysmenu)
*/

if VMSTidyFloater != undefined then closerolloutfloater VMSTidyFloater
	VMSTidyFloater = newRolloutFloater "VMS (Visual MaxScript) Tidy" 824 VMSTidySettings.height 10 10
addRollout VMSTidy VMSTidyFloater
