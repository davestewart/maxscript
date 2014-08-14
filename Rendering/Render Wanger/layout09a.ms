---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------
global RSro1 RSro2

rollout RSro1 "Render Presets" width:984 height:180 --   ( Single-click to edit  /  Double-click to render )
(
----------------------------------------------------------------------------------------------------
	-- INTERFACE
	------------------------------------------------------------------------------------------------
		checkbutton ckbSize "<" pos:[156,4] width:16 height:16 highlightColor:(color 255 196 0) checked:false tooltip:"Click to toggle floater size"

		ActiveXControl ax "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" pos:[4,22] width:974 height:118
		
		label lblName "Setting Name" pos:[12,6] width:100 height:16 bold:true
		label lblSize "Output Size" pos:[180,6] width:100 height:16
		label lblTime "Time Output" pos:[250,6] width:100 height:16

		label lblSH "aa" pos:[368,6] width:16 height:16
		label lblAA "sh" pos:[385,6] width:16 height:16
		label lblref "ref" pos:[403,6] width:16 height:16
		label lblmp "mp" pos:[419,6] width:16 height:16
		label lblflt "flt" pos:[439,6] width:16 height:16
		label lblMB "mb" pos:[453,6] width:16 height:16

		label lblOutput "Render Output" pos:[474,6] width:160 height:16
		label lblRend "Renderer" pos:[818,6] width:160 height:16

		label lblCam "Camera" pos:[892,6] width:160 height:16



	on RSro1 open do
	(
	-- SET UP AX OBJECT
	--------------------------------------------------------
		ax.MousePointer = #ccArrow 
		ax.GridLines = true 
		ax.AllowColumnReorder = false 
		ax.BorderStyle = #ccFixedSingle 
		ax.view = #lvwReport
		ax.Checkboxes=false
		ax.FullRowSelect = true
		ax.MultiSelect = false
		ax.HideColumnHeaders =true
		
		chs = ax.columnHeaders
		
	-- ADD COLUMN HEADERS
	--------------------------------------------------------
		colLabels = #(	"Setting Name",
						"Output Size",
						"Time Output",
						"",
						"",
						"",
						"",
						"",
						"",
						"Output Path",
						"Renderer",
						"Camera")
		
		for i = 1 to colLabels.count  do
		(
			tmp = chs.Add Width:200
			tmp.text=colLabels[i]
		)
		
	-- ADD ITEMS
	--------------------------------------------------------
		for i = 1 to 8 do
		(
			-- VERTICAL
				local li = ax.listItems.Add() 
			-- HORIZONATAL
				for j = 2 to colLabels.count do lsi = ax.ListItems[i].ListSubItems.add() --ForeColor:(128*128*128)
		)


	-- CHANGE COL WIDTHS
	--------------------------------------------------------
		LVM_SETCOLUMNWIDTH = (0x1000+30)
		local colWidths =#(166,70,122,17,17,17,17,17,17,344,74,90)
		for i = 1 to colWidths.count do
			windows.sendMessage ax.hwnd LVM_SETCOLUMNWIDTH (i-1) (colWidths[i])
		ax.refresh()
)


----------------------------------------------------------------------------------------------------
	-- FUNCTIONS
	------------------------------------------------------------------------------------------------

		fn updateUI =
		(
		-- Update Input UI
		--------------------------------------------
			obj=RSro2.RSArr[RSro2.index]
			RSro2.edtName.text = obj[1] as string
			
			RSro2.spnWidth.value = obj[2].x as float
			RSro2.spnHeight.value = obj[2].y as float
			
			-- format ">%\n" obj[3]
			RSro2.updateTimeUI obj[3]
			RSro2.spnRndFrom.value = obj[4].x as float
			RSro2.spnRndTo.value = obj[4].y as float
			
			RSro2.chkAA.checked = obj[5]
			RSro2.chkSH.checked = obj[6]
			RSro2.chkREF.checked = obj[7]
			RSro2.chkMP.checked = obj[8]
			RSro2.chkFlt.checked = obj[9]
			RSro2.chkMB.checked = obj[10]
			
			RSro2.edtPath.text = obj[11] as string
			RSro2.chkSave.checked = obj[12]
			
			if obj[13] == true then RSro2.btnRend.text = "Production" else RSro2.btnRend.text = "Draft"
			
			if obj[14] != "" then RSro2.pck1.text = obj[14] else RSro2.pck1.text = "Viewport"
		)
		
		fn updateListColor=
		(
		-- Update List
		--------------------------------------------
			-- Normal
				obj=ax.ListItems[RSro2.indexOld]
				obj.bold=false
				--obj.forecolor = color 0 0 0
				for subObj in obj.ListSubItems do
				(
					subObj.bold=false
					--subObj.forecolor = color 0 0 0
				)
	
			-- Bold
				obj=ax.ListItems[RSro2.index]
				obj.bold=true
				--obj.forecolor = color 0 0 255
				for subObj in obj.ListSubItems do
				(
					subObj.bold=true
					--subObj.forecolor = color 0 0 255
				)
				
			--format "% %\n" RSro2.index RSro2.indexOld

		)

	
		fn convertToValidFilename str= 
		(
			-- first, take out all double backslashes "\\"
			--	while (i = findString str "\\") != undefined do	(replace str i 2 "\\")

			-- then, once they're all single, put the double ones back in
				newStr = ""
				for i=1 to str.count do
				(
					if str[i] == "\\" then newStr += "\\\\"
					else newStr += str[i]
				)
				return newStr
		)


	-- FINAL RENDER FUNCTION
	--------------------------------------------------------

		fn doRender obj =
		(

		-- begin
			rendStr = "" as stringstream
			format "%" 						"rWin=render "	to:rendStr

		-- fileSize
			format "outputSize:% " 			obj[2] 		to:rendStr
		

		-- frameRange
			local t
			case obj[3] of
			(
				1: t= "frame:#current "
				2: t= "framerange:#active "
				3: t= "fromFrame:" +obj[4].x as String+ " toFrame:"+obj[4].y as String+ " "
			)
		
			format "% "						t	to:rendStr

		--Scanline options
			format "antiAliasing:% "		obj[5]		to:rendStr
			format "shadows:% " 			obj[6]		to:rendStr
			format "autoReflect:% "			obj[7]		to:rendStr
			format "mapping:% "				obj[8]		to:rendStr
			format "filterMaps:% "			obj[9]		to:rendStr
			format "imageMotionBlur:% "		obj[10]		to:rendStr
			format "objectMotionBlur:% "	obj[10]		to:rendStr

		-- fileOutput
			if obj[12]==true then
			(
				local str = convertToValidFilename obj[11]
				format "outputfile:\"%\" "	str 		to:rendStr
			)
			
		-- Camera
			local cam = getNodeByName obj[14]
			if isValidNode cam then
				format "camera:% "		("$"+cam.name)	to:rendStr


		-- Window
			--local win = "rWin"
			--print ("win: " + win)
			--format "to:% "					win			to:rendStr
			if rWin != undefined then close rWin

		-- RENDER!
			format "\n%\nRendering..." rendStr
			execute (rendStr as string)
			
		-- Open animation?
			if (obj[3] > 1 AND
				RSro3.chkAnim.checked AND
				RSro2.chkSave.checked) then ShellLaunch (convertToValidFilename obj[11]) ""

			--messagebox "Finished Rendering!"
		)


		fn checkForCamera obj =
		(
			local cam = obj[14]
			if cam=="" then return true
			else if (isValidNode (getNodeByName cam)) then return true
				else
				(
					local vpType = substring (viewport.getType() as string) 6 20
					local str = "The specified camera doesn't exist.\n\nDo you want to continue rendering through the active ("+vpType+ ") viewport?"
					if queryBox str then return true else return false
				) 
		)


	-- EVENTS
	--------------------------------------------------------

		on ax Click do
		(
		  	RSro2.indexOld = RSro2.index
			RSro2.index = ax.SelectedItem.index
			updateUI()
			updateListColor()
		)

		on ax DblClick do
		(
			-- update List
				RSro2.initList RSro2.index
			
			-- check, then render
				local obj=RSro2.RSArr[RSro2.index]
				if (checkForCamera obj) then doRender obj
		)

		on ckbSize changed state do
		(
			case state of
			(
				true:
				(
				 -- make floater small
					RSro2.open=false
					RSro3.open=false
					ckbSize.text=">"
					RSFloater.size = [200,173]
					RSro1.scrollPos = 20
					RSFloater.pos+=[0,8]

				)
				false:
				(
				 -- make floater big
					RSro2.open=true
					RSro3.open=true
					ckbSize.text="<"
					RSFloater.size = [1010,300]
					RSro1.scrollPos = 0
					RSFloater.pos+=[0,8]
				)
			)
		)


)

rollout RSro2 "Edit Settings" width:984 height:192
(
----------------------------------------------------------------------------------------------------
	-- DECLARATIONS
	------------------------------------------------------------------------------------------------

		local index = 1, indexOld=1
		local initList
		local RSArr = #()
	

	

----------------------------------------------------------------------------------------------------
	-- INTERFACE
	------------------------------------------------------------------------------------------------



		GroupBox grpName "Setting Name" pos:[4,4] width:128 height:60
			edittext edtName "" pos:[4,40] width:124 height:16 text:"Render Setting 1" tabIndex:1
	
		GroupBox grpSize "Output Size" pos:[136,4] width:104 height:60
			label lblWidth "Width" pos:[145,24] width:32 height:16
			label lblHeight "Height" pos:[192,24] width:32 height:16
	
			spinner spnWidth "" pos:[140,40] width:48 height:16 range:[0,9999,1024] type:#integer scale:1
			spinner spnHeight "" pos:[188,40] width:48 height:16 range:[0,9999,576] type:#integer scale:1
--			checkButton btnSizeLock "L" pos:[176,24] width:14 height:14 highlightColor:(color 255 196 0) checked:true 
	
	
		GroupBox grpTime "Time Output" pos:[244,4] width:120 height:60
			label lblFrom "From" pos:[268,24] width:32 height:16
			label lblTo "To" pos:[316,24] width:32 height:16
		
			button btnRndType "S" pos:[248,40] width:16 height:16 toolTip:"S=single, C=current, R=range" tabIndex:2
			spinner spnRndFrom "" pos:[264,40] width:48 height:16 range:[-9999,9999,0] type:#integer scale:1
			spinner spnRndTo "" pos:[312,40] width:48 height:16 range:[-9999,9999,100] type:#integer scale:1
	
	
		GroupBox grpScanline "Scanline Options" pos:[368,4] width:100 height:60
	 		label lblAA "aa" pos:[372,24] width:16 height:16
			label lblSH "sh" pos:[388,24] width:16 height:16
			label lblref "ref" pos:[404,24] width:16 height:16
			label lblmp "mp" pos:[419,24] width:16 height:16
			label lblFlt "flt" pos:[438,24] width:16 height:16
			label lblMB "mb" pos:[450,24] width:16 height:16
	
			checkbox chkAA "" pos:[372,40] width:16 height:16 enabled:true checked:false  tooltip:"Anti-aliasing"
			checkbox chkSH "" pos:[388,40] width:16 height:16 enabled:true checked:false
			checkbox chkREF "" pos:[404,40] width:16 height:16 enabled:true checked:false
			checkbox chkMP "" pos:[420,40] width:16 height:16 enabled:true checked:false
			checkbox chkFlt "" pos:[436,40] width:16 height:16 enabled:true checked:false
			checkbox chkMB "" pos:[450,40] width:16 height:16 enabled:true checked:false
	
		GroupBox grpOutput "Render Output" pos:[472,4] width:340 height:60
			label lblPath "Output path" pos:[496,24] width:160 height:16

			button btnPath ">" pos:[478,40] width:16 height:16 toolTip:"Get file path"
			edittext edtPath "" pos:[492,40] width:300 height:16
			checkbox chkSave "" pos:[794,40] width:16 height:16 enabled:true checked:true
	
		GroupBox grpRend "Renderer" pos:[816,4] width:70 height:60
			button btnRend "Production" pos:[820,40] width:60 height:16 highlightColor:(color 255 196 0) checked:true 
	
			fn camFilter c = classOf c == Targetcamera
	
		GroupBox grpCam "Camera" pos:[890,4] width:86 height:60
			pickbutton pck1 "Viewport" pos:[894,40] width:60 height:16 highlightColor:(color 255 196 0) filter:camFilter tooltip:"Pick Camera from scene..."
			button btnRC "x" pos:[954,40] width:16 height:16 highlightColor:(color 255 196 0) tooltip:"Revert to viewport"



		local cam


	-- Update RSArr on interface change
	--------------------------------------------------------
		-- Name
			on edtName changed text do
			(
				RSArr[index][1] = text as String
				initList index
			)
		
		-- Output Size
			on btnSizeLock changed state do
			(
				if state == true then local sizeLock = [spnWidth.value,spnHeight,value]
			)
			
			on spnWidth changed val do
			(
				RSArr[index][2] = [val,spnHeight.value]
				initList index
			)
		
			on spnHeight changed val do
			(
				RSArr[index][2] = [spnWidth.value,val]
				initList index
			)
				
		---------------------------------------------------------------------------------------------------
	-- Events
	---------------------------------------------------------------------------------------------------

	
		-- Time
			-- Type
			
				local rndArr=#("S","A","R"), rt=1
				
				fn updateTimeUI rt =
				(
					--RSArr[index][3]=rt.
					btnRndType.text = rndArr[rt]
			
					if rt!=3 then	(spnRndFrom.enabled=false;spnRndTo.enabled=false)
						else	(spnRndFrom.enabled=true;spnRndTo.enabled=true)
						
					case rt of
					(
						1:	grpTime.text= "Time (Single)"
						2:	grpTime.text= "Time (Active time)"
						3:	grpTime.text= "Time (Range)"
					)
	
				)
				on btnRndType pressed do
				(
					rt+=1
					if rt > rndArr.count then rt = 1
					RSArr[index][3]=rt
					updateTimeUI rt
					initList index
				)
	
			-- From and To
	
				on spnRndFrom changed val do
				(
					if val >= spnRndTo.value then spnRndTo.value=val
					RSArr[index][4] = [val,spnRndTo.value]
					initList index
				)
			
				on spnRndTo changed val do
				(
					if val <= spnRndFrom.value then spnRndFrom.value=val
					RSArr[index][4] = [spnRndFrom.value,val]
					initList index
				)
	
	
			
		-- Scanline Options
			
			fn updateScanline i state =
			(
				RSArr[index][i]=state
				initList index
			)
	
			on chkAA changed state do updateScanline 5 state
			on chkSH changed state do updateScanline 6 state
			on chkRef changed state do updateScanline 7 state
			on chkMp changed state do updateScanline 8 state
			on chkFlt changed state do updateScanline 9 state
			on chkMB changed state do updateScanline 10 state
		
		
		
		-- Render Output
		
			on btnPath pressed do
			(
				path = getSaveFileName "Choose output directory and filename"
				
				if path != undefined then
				(
					edtPath.text = path
					RSArr[index][11] = path
					initList index
				)
			)
	
			on edtPath entered text do
			(
				RSArr[index][11] = text as String
				initList index
			)
	
			on chkSave changed state do
			(
				RSArr[index][12] = state
				edtPath.enabled = state
				initList index
			)
	
	
		-- renderer
		
			on btnRend pressed do
			(
				if RSArr[index][13]==true then RSArr[index][13]=false else RSArr[index][13]=true
				btnRend.text = case RSArr[index][13] of 
				( 
					false: "Draft"
					true: "Production"
				)
				initList index
			)
		
		-- camera
		
			on pck1 picked obj do
			(
				pck1.text = obj.name
				cam=obj
				RSArr[index][14] = cam.name
				initList index
			)
	
			on btnRC pressed do
			(
				pck1.text = "Viewport"
				cam=undefined
				RSArr[index][14] = ""
				initList index
			)


	---------------------------------------------------------------------------------------------------
	-- Final Setup
	---------------------------------------------------------------------------------------------------

	-- reinitialize each row after editing
	--------------------------------------------------------

	fn initList i=
	(
		-- ListItem
		-- name
			cell = RSro1.ax.ListItems[i]
			cell.text = RSArr[i][1]

		-- ListSubItems
		-- size
			j=2
			cell = RSro1.ax.ListItems[i].ListSubItems[j-1]
			local s = RSArr[i][j]
			str = (s.x as Integer) as String + " x " + (s.y as Integer) as String 
			cell.text = str
			---------------------------------------------------------------------
			RenderWidth = s.x
			RenderHeight = s.y

			
		-- Output Type
			j = 3
			cell = RSro1.ax.ListItems[i].ListSubItems[j-1]
			local ot = RSArr[i][j]
			---------------------------------------------------------------------
			rendTimeType = ot

		-- Output
			j = 4
			cell = RSro1.ax.ListItems[i].ListSubItems[j-2]
			local r = RSArr[i][j]

			str = case ot of 
			( 
				1: "Single" 
				2: "Active time segment"
				3: (
					str = "Range: " + (r.x as Integer) as String + " to " + (r.y as Integer) as String 
				)  
			) 
			cell.text = str
			---------------------------------------------------------------------
			rendStart = r.x as Integer
			rendEnd = r.y as Integer


		-- Scanline Options
			for j = 5 to 11 do
			(
				cell = RSro1.ax.ListItems[i].ListSubItems[j-2]
				local opt = RSArr[i][j]
				if opt==true then cell.text = "x" else cell.text = ""
			)
			---------------------------------------------------------------------
			antiAliasing =	RSArr[i][5]
			shadows =		RSArr[i][6]
			autoReflect =	RSArr[i][7]
			mapping =		RSArr[i][8]
			filterMaps =	RSArr[i][9]
			imageMotionBlur=RSArr[i][10]
			objectMotionBlur=RSArr[i][10]
			
		
		-- Render Output
			j = 11
			cell = RSro1.ax.ListItems[i].ListSubItems[j-2]
			local p = RSArr[i][j]
			cell.text = p
			---------------------------------------------------------------------
			rendOutputFilename=p



		-- Save
			j = 12
			cell = RSro1.ax.ListItems[i].ListSubItems[j-3]
			local sv = RSArr[i][j]
			
			if sv == false then	cell.ForeColor = color 200 200 200
				else cell.ForeColor = color 0 0 0
			
			---------------------------------------------------------------------
			rendSaveFile = sv


		-- Renderer
			j = 13
			cell = RSro1.ax.ListItems[i].ListSubItems[j-3]
			local r = RSArr[i][j]
			if r == true then str="Production" else str = "Draft" 
			cell.text = str
			---------------------------------------------------------------------
			execute("renderer = #" + str)

		-- Camera
			j = 14
			cell = RSro1.ax.ListItems[i].ListSubItems[j-3]
			local c = RSArr[i][j]
			cell.text = c
			---------------------------------------------------------------------
			--execute("renderer = #" + str)
		
	)
)


rollout RSro3 "Tools" width:984 height:56
(
----------------------------------------------------------------------------------------------------
	-- INTERFACE
	------------------------------------------------------------------------------------------------

	GroupBox grpSettings "Settings management" pos:[4,4] width:232 height:44
	button btnCopy "Copy" pos:[8,24] width:56 height:16
	dropDownList ddlCopyType "" pos:[64,22] width:104 height:21 items:#("All settings", "Output size", "Time", "Scanline options", "Render output", "Renderer", "Camera")
	button btnPaste "Paste" pos:[168,24] width:64 height:16

	GroupBox grpPreset "Preset management" pos:[240,4] width:128 height:44
	button btnDown "Move Down" pos:[244,24] width:68 height:16
	button btnUp "Move Up" pos:[312,24] width:52 height:16

	GroupBox grpFile "Preset I/O" pos:[372,4] width:128 height:44
	button btnSave "Save" pos:[376,24] width:60 height:16
	button btnLoad "Load" pos:[436,24] width:60 height:16

	GroupBox grpGlobal "Global options" pos:[504,4] width:322 height:44
	checkbox chkAnim "Auto-open animations" pos:[512,24] width:124 height:16 checked:true
	checkbox chkSaveOnClose "Save on close" pos:[640,24] width:96 height:16 checked:true

	GroupBox grpRenderWanger "RenderWanger v0.8" pos:[830,4] width:146 height:44
	button btnHelp "Help" pos:[836,24] width:60 height:16
	button btnWeb "Report bugs" pos:[896,24] width:76 height:16



----------------------------------------------------------------------------------------------------
	-- DECLARATIONS
	------------------------------------------------------------------------------------------------

	local tmpArr = #()
	local iniPrefs = getDir #scripts + "\\RenderWanger.ini"
	local iniPresets
	local fs


	-- Initial RSArr settings
	--------------------------------------------------------

		/*
			Array Sub-Items
			1	Name				String
			
			2	Size				Point2		[width,height]
			
			3	RenderOutputType 	Integer		1:Single | 2:Active | 3:Range
			4	FrameRange			Point2		[from,to]
			
			5	AntiAliasing		Boolean
			6	Shadows				Boolean
			7	Reflections			Boolean
			8	Mapping				Boolean
			9	FilterMaps			Boolean
			10	MotionBlur			Boolean
			
			11	OutputFile			String
			12	Save				Boolean
			
			13	UseDraftRenderer	Boolean
			14	Camera				String
			
			15	Display				Boolean
		*/
	fn initRSArr =
	(
		RSRo2.RSArr[1] = #("Render Setting 1", [512,288], 1, [0,100], true, false, false, false, false, false, "c:\\temp\\scene.avi", false, true, "", true)
		RSRo2.RSArr[2] = #("Render Setting 2", [512,288], 1, [0,100], false, true, false, false, false, false, "c:\\temp\\scene.avi", false, true, "", true)
		RSRo2.RSArr[3] = #("Render Setting 3", [512,288], 1, [0,100], true, true, false, false, false, false, "c:\\temp\\scene.avi", false, true, "", true)
		RSRo2.RSArr[4] = #("Render Setting 4", [512,288], 1, [0,100], true, true, true, true, true, false, "c:\\temp\\scene.avi", false, true, "", true)
		RSRo2.RSArr[5] = #("Render Setting 5", [1024,576], 1, [0,100], false, false, false, false, false, false, "c:\\temp\\scene.jpg", false, true, "", true)
		RSRo2.RSArr[6] = #("Render Setting 6", [1024,576], 1, [0,100], true, true, true, true, true, true, "c:\\temp\\scene.tga", true, true, "", true)
		RSRo2.RSArr[7] = #("Render Setting 7", [341,192], 3, [50,70], true, true, false, true, true, false, "c:\\temp\\scene.avi", true, true, "", true)
		RSRo2.RSArr[8] = #("Render Setting 8", [341,192], 2, [0,100], false, false, false, false, false, false, "c:\\temp\\scene.avi", true, true, "", true)		

		for i = 1 to RSRo2.RSArr.count do RSro2.initList i
		RSro2.index = 1
		RSro1.updateUI()
		RSro1.updateListColor()
	)




----------------------------------------------------------------------------------------------------
	-- FUNCTIONS
	------------------------------------------------------------------------------------------------
	fn replaceAll str outStr inStr =
	(
		-- str the original string
		-- the string/character to replace
		-- the replacement string/character
		return (while ((n=findstring str outStr) != undefined) do str = replace str n inStr.count inStr)
	)


	fn saveSettings iniPresets =
	(
	-- create filestream and save
		MessageBox ("0 saveSettings iniPresets is " + iniPresets as string)

		if iniPresets != undefined then
		(
			MessageBox ("1 saveSettings iniPresets is " + iniPresets as string)
	
			fs = createFile iniPresets
			for arr in RSro2.RSArr do
			(
				format "arr in RSro2.RSArr is %\n" arr
			-- save a validFileName copy to the stringstream
				local tmpArr = arr
				format "tmpArr is %\n" tmpArr
				tmpArr[11] = replaceAll tmpArr[11] "\\" "/"
				format "%\n" tmpArr[11]
				format "%\n" tmpArr to:fs
			)
			close fs
			
			setINISetting iniPrefs "Settings" "LastFileOpened" (replaceAll iniPresets "\\" "/")
			setINISetting iniPrefs "Settings" "AutoOpenAnimations" "true"
			setINISetting iniPrefs "Settings" "SaveOnClose" "true"

		)
	)

	fn loadSettings iniPresets=
	(
		messagebox ("1 loadsettings iniPresets is: " +iniPresets as string)
		-- open file and read line by line
		local ln = 0
		if iniPresets != undefined then
		(
			iniPresets = replaceAll iniPresets "/" "\\"
			messagebox ("2 loadsettings iniPresets is: " +iniPresets as string)
			local prompt = "RenderWanger is loading " + (getFilenameFile iniPresets) as string
			displayTempPrompt prompt 3000

			try(
				fs = openFile iniPresets
				format ">> %" iniPresets
				while not eof fs do
				(
					ln+=1
					str = "RSro2.RSArr["+ln as string+"]=" + replaceAll (readline fs) "/" "\\"
					--format "%\n" str
					execute str
				)
				close fs
			
			-- Update the UI, etc
				for i = 1 to ln do RSro2.initList i
				RSro2.indexOld = RSro2.index
				RSro2.index = 1
				RSro1.updateUI()
				RSro1.updateListColor()

			-- update the global settinsg boxes
				execute ("chkAnim.checked=" + getINISetting iniPrefs "Settings" "AutoOpenAnimations")
				execute ("chkSaveOnClose.checked=" + getINISetting iniPrefs "Settings" "SaveOnClose")
			)
			catch
			(
				MessageBox "Failed to load Preset File.\nAttempting to load default Preset file"
				format "%\n" ".. Error loading file! Loading default settings..."
				loadSettings (getDir #scripts + "\\default.rs.ini")
			)
		)
	)
----------------------------------------------------------------------------------------------------
	-- HANDLERS
	------------------------------------------------------------------------------------------------
		on btnWeb pressed do ShellLaunch "http://www.davestewart.co.uk/mxs" ""
		
		on btnLoad pressed do loadSettings (getOpenFileName types:"RenderSettings(*.rs.ini)|*.rs.ini|All|*.*|")
		on btnSave pressed do saveSettings (getSaveFileName types:"RenderSettings(*.rs.ini)|*.rs.ini|All|*.*|")


		on btnCopy pressed do
		(
			tmpArr = RSro2.RSArr[RSro2.index]
			format "%\n" tmpArr
		)

		on btnPaste pressed do
		(
			RSro2.RSArr[RSro2.index] = tmpArr
			RSro1.updateUI()
		)

		on btnUp pressed do
		(
			if RSro2.index > 1 then
			(
				tmpArr = RSro2.RSArr[RSro2.index-1]
	
				RSro2.RSArr[RSro2.index-1] = RSro2.RSArr[RSro2.index]
				RSro2.RSArr[RSro2.index] = tmpArr
	
				RSro2.indexOld = RSro2.index
				RSro2.index = RSro2.index-1
				
				RSro2.initList RSro2.index
				RSro2.initList RSro2.indexOld
				
				RSro1.updateListColor()
			)
		)

		on btnDown pressed do
		(
			if RSro2.index < RSro2.RSArr.count then
			(
				tmpArr = RSro2.RSArr[RSro2.index+1]
	
				RSro2.RSArr[RSro2.index+1] = RSro2.RSArr[RSro2.index]
				RSro2.RSArr[RSro2.index] = tmpArr
	
				RSro2.indexOld = RSro2.index
				RSro2.index = RSro2.index+1
				
				RSro2.initList RSro2.index
				RSro2.initList RSro2.indexOld
				
				RSro1.updateListColor()
			)
		)
		
		on btnHelp pressed do
		(
			str= "RenderWanger makes rendering quicker easier when you need to \nchange rendering configurations often.\n\n"
			str+= "Store multiple configurations for:\n"
			str+= "   - Different sizes, resolutions or quality.\n   - Different cameras or animation periods.\n   - Different output paths.\n\n"
			str+= "Render Presets panel:\n   - Click items to edit.\n   - Double-click items to render.\n\n"
			str+= "Edit Settings panel:\n   - Adjust individual settings using the controls provided.\n\n"
			str+= "Tools panel:\n   - Copy, paste and move presets.\n   - Save and load Presets."
			MessageBox str title:"RenderWanger Help"
		)

		on RSro3 oktoclose do
		(
			try(
				setINISetting iniPrefs "Settings" "AutoOpenAnimations" (chkAnim.state as string)
				setINISetting iniPrefs "Settings" "SaveOnClose" (chkSave.state as string)
				if chkSave.checked then saveSettings f
			)
			catch(
				--MessageBox "Problem setting ini file.\nPlease delete and re-open RenderWanger."
			)
		)
-- OPEN
		on RSro3 open do
		(
			iniPresets = getINISetting iniPrefs "Settings" "LastFileOpened"
			if (iniPresets != undefined AND iniPresets != "") then	-- if ini file exists
			(
				loadSettings iniPresets
			)
			else -- if ini file doesn't exist
			(
				MessageBox "First run: setting default values..." title:"RenderWanger info..."
				initRSArr()
				iniPresets = (getDir #scripts +"\\default.rs.ini")
				messagebox ("default preset file is: " + iniPresets as string)
				savesettings iniPresets
			)
		)

)




if RSFloater != undefined then closerolloutfloater RSFloater
	RSFloater = newRolloutFloater "RenderWanger! v0.8 | Easily manage multiple rendering configurations. Load and save by project, activity or user." 1010 382 --1010 300
	RSFloater.pos = [0,76]
addRollout RSro1 RSFloater
addRollout RSro2 RSFloater
addRollout RSro3 RSFloater




/*

str="Setting one;[1024,576];[0,0];0;0;0;0;0;0;c:\\renders;true;production;true"
str = filterstring str ";"
for s in str do format "%\n" s

f = getOpenFileName types:"RenderSettings(*.rs.ini)|*.rs.ini|All|*.*|" 


*/
/*

-- make floater small
RSFloater.size = [160,153]
RSro1.scrollPos = 40
RSFloater.pos+=[0,8]
 
*/


