---------------------------------------------------------------------------------------------------
-- RenderWanger v0.8
-- by Dave Stewart
-- www.davestewart.co.uk
---------------------------------------------------------------------------------------------------
/*
	RenderWanger makes rendering quicker easier when you need to change rendering configurations often.

	Store multiple configurations for:
	- Different sizes, resolutions or quality.
	- Different cameras or animation periods.
	- Different output paths.

	Render Presets panel:
	- Click items to edit.
	- Double-click items to render.

	Edit Settings panel:
	- Adjust individual settings using the controls provided.

	Tools panel:
	- Copy, paste and move presets.
	- Save and load Presets.

*/
---------------------------------------------------------------------------------------------------
-- global functions
---------------------------------------------------------------------------------------------------

	fn replaceAll str outStr inStr =
	(
		str = #(str as string,"")

		while findstring str[1] outStr != undefined do
		(
		-- get variables
			s1 = 1
			s2 = (findstring str[1] outStr) + (-1)
			s3 = (findstring str[1] outStr) + outStr.count

		-- build str[2]
			str[2]+= substring str[1] s1 s2
			str[2]+= inStr
			
		-- reduce str[1]
			str[1]= substring str[1] s3 str[1].count
		)
		str[2]+=str[1]
		return str[2]
	)

	---------------------------------------------------------------------------------------------------

	fn convertToSMPTEString t =
	(
		-- input t to be seconds
			
		-- seconds
			s = (mod t 60) as integer
			t= (t-s)/60
			
		-- minutes
			m = (mod t 60) as integer
			
			
		-- hours
			h= ((t-m)/60) as integer
	
		-- create strings
		if s < 10 then s = "0" + s as string else s = s as string
		if m < 10 then m = "0" + m as string else m = m as string
		if h < 10 then h = "0" + h as string else h = h as string
	
		return (h+ ":" +m+ ":" +s)
	)


	---------------------------------------------------------------------------------------------------

	fn filterFileTypes showExtension =
	(
		-- define filetypes
			local i
			local fileTypes=#(#(),#(),#())
			local all = ""
			local anim = ""
			local still = ""
			local vector = ""
			local str = ""
	
			-- Animation
				i=0
				fileTypes[1][i+=1]=#(	"AVI File",						"*.avi")
				fileTypes[1][i+=1]=#(	"MOV QuickTime File",			"*.mov")
				fileTypes[1][i+=1]=#(	"Autodesk Flic Image File",		"*.flc; *.fli; *.cel")
	
			-- Still
				i=0
				fileTypes[2][i+=1]=#(	"BMP Image File",				"*.bmp")
				fileTypes[2][i+=1]=#(	"JPEG File",					"*.jpg; *.jpe; *.jpeg")
				fileTypes[2][i+=1]=#(	"PNG Image File",				"*.png")
				fileTypes[2][i+=1]=#(	"SGI's Image File Format",		"*.rgb")
				fileTypes[2][i+=1]=#(	"RLA Image File",				"*.rla")
				fileTypes[2][i+=1]=#(	"RPF Image File",				"*.rpf")
				fileTypes[2][i+=1]=#(	"Targa Image File",				"*.tga; *.vda; *.icb; *.vst")
				fileTypes[2][i+=1]=#(	"TIF Image File",				"*.tif")
	
			-- Vector
				i=0
				fileTypes[3][i+=1]=#(	"Shockwave Flash SWF",			"*.swf")
				fileTypes[3][i+=1]=#(	"Adobe Illustrator AI",			"*.ai")
				fileTypes[3][i+=1]=#(	"Autocad DXF",					"*.dxf")
			
		-- build format strings
			for i = 1 to 3 do
			(
				for f in fileTypes[i] do all+= f[2] + "; "
			)
			for f in fileTypes[1] do anim+= f[2] + "; "
			for f in fileTypes[2] do still+= f[2] + "; "
			for f in fileTypes[3] do vector+= f[2] + "; "
	
	
		
		-- build types string
			str = stringstream ""
	
			format ("All formats|" +all+ "|") to:str
	
			for i = 1 to fileTypes.count do
			(
				-- Types heading...
					if i  == 1 then format ("Animation formats..." +"|" + anim + "|") to:str
					if i  == 2 then format ("Still formats..." +"|" + still + "|") to:str
					if i  == 3 then format ("Vector formats..." +"|" + vector + "|") to:str
				
				-- Types individually
					for f in filetypes[i] do
					(
						format ("      " + f[1])									to:str
						if showExtension == false then format (" (" +f[2]+")")		to:str
						format  ("|"+f[2] + "|")									to:str
					)
					
			)
			
			format "Any file (*.*)|*.*" to:str
		-- done	
			return str
	)

---------------------------------------------------------------------------------------------------
-- global functions
---------------------------------------------------------------------------------------------------
	global RWro1, RWro2, RWRo3




rollout RWro1 "Presets  (Double-click to render)" width:984 height:180 --   ( Single-click to edit  /  Double-click to render )
(
----------------------------------------------------------------------------------------------------
	-- INTERFACE
	------------------------------------------------------------------------------------------------
		checkbutton ckbSize "<" pos:[190,4] width:16 height:16 highlightColor:(color 255 196 0) checked:false tooltip:"Click to toggle floater size"

		ActiveXControl ax "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" pos:[4,22] width:974 height:118
		
		label lblName "Setting Name" pos:[12,6] width:100 height:16 bold:true
		label lblSize "Output Size" pos:[214,6] width:100 height:16
		label lblTime "Time Output" pos:[294,6] width:100 height:16

		label lblSH "aa" pos:[412,6] width:16 height:16
		label lblAA "sh" pos:[429,6] width:16 height:16
		label lblref "ref" pos:[447,6] width:16 height:16
		label lblmp "mp" pos:[463,6] width:16 height:16
		label lblflt "flt" pos:[483,6] width:16 height:16
		label lblMB "mb" pos:[497,6] width:16 height:16

		label lblOutput "Render Output" pos:[518,6] width:160 height:16
		label lblRend "Renderer" pos:[818,6] width:160 height:16

		label lblCam "Camera" pos:[892,6] width:160 height:16



	on RWro1 open do
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
		ax.LabelEdit = #lvwManual
		
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
				li.tooltiptext = "Double-click to render..."
			-- HORIZONATAL
				for j = 2 to colLabels.count do lsi = ax.ListItems[i].ListSubItems.add() --ForeColor:(128*128*128)
		)


	-- CHANGE COL WIDTHS
	--------------------------------------------------------
		LVM_SETCOLUMNWIDTH = (0x1000+30)
		local colWidths =#(200,80,122,17,17,17,17,17,17,300,74,90)
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
			obj=RWro2.RSArr[RWro2.index]
			RWro2.edtName.text = obj[1] as string
			
			RWro2.spnWidth.value = obj[2].x as float
			RWro2.spnHeight.value = obj[2].y as float
			RWro2.setSizeLock()
			
			RWro2.updateTimeUI obj[3]
			RWro2.spnRndFrom.value = obj[4].x as float
			RWro2.spnRndTo.value = obj[4].y as float
			
			RWro2.chkAA.checked = obj[5]
			RWro2.chkSH.checked = obj[6]
			RWro2.chkREF.checked = obj[7]
			RWro2.chkMP.checked = obj[8]
			RWro2.chkFlt.checked = obj[9]
			RWro2.chkMB.checked = obj[10]
			
			RWro2.edtPath.text = obj[11] as string
			RWro2.chkSave.checked = obj[12]
			if RWro2.chkSave.checked then RWro2.edtPath.enabled = true else RWro2.edtPath.enabled = false

			if obj[13] == true then RWro2.btnRend.text = "Production" else RWro2.btnRend.text = "Draft"
			if obj[14] != "" then RWro2.pck1.text = obj[14] else RWro2.pck1.text = "Viewport"
		)
		
		fn updateListColor=
		(
		-- Update List
		--------------------------------------------
			-- Normal
				obj=ax.ListItems[RWro2.indexOld]
				obj.bold=false
				--obj.forecolor = color 0 0 0
				for subObj in obj.ListSubItems do
				(
					subObj.bold=false
					--subObj.forecolor = color 0 0 0
				)
	
			-- Bold
				obj=ax.ListItems[RWro2.index]
				obj.bold=true
				--obj.forecolor = color 0 0 255
				for subObj in obj.ListSubItems do
				(
					subObj.bold=true
					--subObj.forecolor = color 0 0 255
				)
				
			--format "% %\n" RWro2.index RWro2.indexOld

		)



	-- FINAL RENDER FUNCTION
	--------------------------------------------------------
		local renderTime = #(0,0,"")

		fn doRender obj =
		(
			-- get start time
				renderTime[1] = timeStamp()

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
					local str = replaceAll obj[11] "\\" "\\\\"
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
	

			--------------------------------------------------------

			-- START RENDER
				format "\nRendering: %\n" rendStr
				execute (rendStr as string)

			-- FINISHED RENDER

				-- report rendertime
					renderTime[2] = timeStamp()
					renderTime[3] = convertToSMPTEString ((renderTime[2]-renderTime[1]) as float /1000)
					format "Render Time was %\n" renderTime[3]

				-- save as tooltip
					ax.listitems[RWro2.index].tooltiptext = ("Last render time: " + renderTime[3])
					--RWro2.RSArr[RWro2.index][15] = renderTime[3]

					
				-- Open animation?
					if (
						RWro3.chkAnim.checked AND
						obj[3] > 1 AND
						RWro2.chkSave.checked AND
						(getFilenameType obj[11] == ".mov" OR getFilenameType obj[11] == ".avi")
					)
						then ShellLaunch (obj[11]) ""

			--------------------------------------------------------
			try(
			)
			catch
			(
				MessageBox "Rendering interrupted!"
			)
			--------------------------------------------------------
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
		  	RWro2.indexOld = RWro2.index
			RWro2.index = ax.SelectedItem.index
			updateUI()
			updateListColor()
		)

		on ax DblClick do
		(
			-- update List
				RWro2.initList RWro2.index
			
			-- check, then render
				local obj=RWro2.RSArr[RWro2.index]
				if (checkForCamera obj) then doRender obj
		)

		on ckbSize changed state do
		(
			case state of
			(
				true:
				(
				 -- make floater small
					RWro2.open=false
					RWro3.open=false
					ckbSize.text=">"
					RWFloater.size = [233,173]
					RWro1.scrollPos = 20
					RWFloater.pos+=[0,8]

				)
				false:
				(
				 -- make floater big
					RWro2.open=true
					RWro3.open=true
					ckbSize.text="<"
					RWFloater.size = [1010,294]
					RWro1.scrollPos = 0
					RWFloater.pos+=[0,8]
				)
			)
		)


)

rollout RWro2 "Editor" width:984 height:192
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

		GroupBox grpName "Setting Name" pos:[4,4] width:172 height:62
			edittext edtName "" pos:[4,44] width:168 height:16 text:"Render Setting 1" tabIndex:1
	
		GroupBox grpSize "Output Size" pos:[180,4] width:104 height:62
			label lblWidth "Width" pos:[187,28] width:32 height:16
			label lblHeight "Height" pos:[236,28] width:32 height:16
	
			spinner spnWidth "" pos:[184,44] width:48 height:16 range:[0,9999,1024] type:#integer scale:1
			spinner spnHeight "" pos:[232,44] width:48 height:16 range:[0,9999,576] type:#integer scale:1
			checkButton btnSizeLock "L" pos:[220,28] width:14 height:14 highlightColor:(color 255 196 0) checked:true tooltip:"Lock image aspect"


		GroupBox grpTime "Time Output" pos:[288,4] width:120 height:62
			label lblFrom "From" pos:[312,28] width:32 height:16
			label lblTo "To" pos:[360,28] width:32 height:16
		
			button btnRndType "S" pos:[292,44] width:16 height:16 toolTip:"S=single, C=current, R=range" tabIndex:2
			spinner spnRndFrom "" pos:[308,44] width:48 height:16 range:[-9999,9999,0] type:#integer scale:1
			spinner spnRndTo "" pos:[356,44] width:48 height:16 range:[-9999,9999,100] type:#integer scale:1
	
	
		GroupBox grpScanline "Scanline Options" pos:[412,4] width:100 height:62
	 		label lblAA "aa" pos:[416,28] width:16 height:16
			label lblSH "sh" pos:[432,28] width:16 height:16
			label lblref "ref" pos:[448,28] width:16 height:16
			label lblmp "mp" pos:[465,28] width:16 height:16
			label lblFlt "flt" pos:[482,28] width:16 height:16
			label lblMB "mb" pos:[494,28] width:16 height:16
	
			checkbox chkAA "" pos:[416,44] width:16 height:16 enabled:true checked:false  tooltip:"Anti-aliasing"
			checkbox chkSH "" pos:[432,44] width:16 height:16 enabled:true checked:false
			checkbox chkREF "" pos:[448,44] width:16 height:16 enabled:true checked:false
			checkbox chkMP "" pos:[464,44] width:16 height:16 enabled:true checked:false
			checkbox chkFlt "" pos:[480,44] width:16 height:16 enabled:true checked:false
			checkbox chkMB "" pos:[494,44] width:16 height:16 enabled:true checked:false
	
		GroupBox grpOutput "Render Output" pos:[516,4] width:296 height:62
			label lblPath "Output path" pos:[540,28] width:116 height:16

			button btnPath ">" pos:[522,44] width:16 height:16 toolTip:"Get file path"
			edittext edtPath "" pos:[536,44] width:256 height:16
			checkbox chkSave "" pos:[794,44] width:16 height:16 enabled:true checked:true
	
		GroupBox grpRend "Renderer" pos:[816,4] width:70 height:62
			button btnRend "Production" pos:[820,44] width:60 height:16 highlightColor:(color 255 196 0) checked:true 
	
			fn camFilter c = classOf c == Targetcamera
	
		GroupBox grpCam "Camera" pos:[890,4] width:86 height:62
			pickbutton pck1 "Viewport" pos:[894,44] width:60 height:16 highlightColor:(color 255 196 0) filter:camFilter tooltip:"Pick Camera from scene..."
			button btnRC "x" pos:[954,44] width:16 height:16 highlightColor:(color 255 196 0) tooltip:"Revert to viewport"



		local cam, sizeLock

		fn setSizeLock = sizeLock =[spnWidth.value,spnHeight.value]


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
				if state then setSizeLock()
			)
			
			on spnWidth changed val do
			(
				if btnSizeLock.checked then spnHeight.value = val*(sizeLock[2]/sizeLock[1])
				RSArr[index][2] = [val,spnHeight.value]
				initList index
			)
		
			on spnHeight changed val do
			(
				if btnSizeLock.checked then spnWidth.value = val*(sizeLock[1]/sizeLock[2])
				RSArr[index][2] = [spnWidth.value,val]
				initList index
			)

	
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
				path = getSaveFileName caption:"Choose output folder / filename" filename:edtPath.text types:(filterFileTypes true)
				
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

	-- reinitialize the display of each row after editing
	--------------------------------------------------------

	fn initList i=
	(
		-- ListItem
		-- name
			cell = RWro1.ax.ListItems[i]
			cell.text = RSArr[i][1]

		-- ListSubItems
		-- size
			j=2
			cell = RWro1.ax.ListItems[i].ListSubItems[j-1]
			local s = RSArr[i][j]
			str = (s.x as Integer) as String + " x " + (s.y as Integer) as String 
			cell.text = str
			---------------------------------------------------------------------
				RenderWidth = s.x
				RenderHeight = s.y

			
		-- Output Type
			j = 3
			cell = RWro1.ax.ListItems[i].ListSubItems[j-1]
			local ot = RSArr[i][j]
			---------------------------------------------------------------------
				rendTimeType = ot

		-- Output
			j = 4
			cell = RWro1.ax.ListItems[i].ListSubItems[j-2]
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
				cell = RWro1.ax.ListItems[i].ListSubItems[j-2]
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
			cell = RWro1.ax.ListItems[i].ListSubItems[j-2]
			local p = RSArr[i][j]
			cell.text = p
			cell.tooltiptext=p
			---------------------------------------------------------------------
				rendOutputFilename=p



		-- Save
			j = 12
			cell = RWro1.ax.ListItems[i].ListSubItems[j-3]
			local sv = RSArr[i][j]
			
			if sv == false then	cell.ForeColor = color 200 200 200
				else cell.ForeColor = color 0 0 0
			
			---------------------------------------------------------------------
				rendSaveFile = sv


		-- Renderer
			j = 13
			cell = RWro1.ax.ListItems[i].ListSubItems[j-3]
			local r = RSArr[i][j]
			if r == true then str="Production" else str = "Draft" 
			cell.text = str
			---------------------------------------------------------------------
				execute("renderer = #" + str)

		-- Camera
			j = 14
			cell = RWro1.ax.ListItems[i].ListSubItems[j-3]
			local c = RSArr[i][j]
			cell.text = c
			---------------------------------------------------------------------
				--execute("renderer = #" + str)
		
	)
)


rollout RWro3 "Tools" width:984 height:56
(
----------------------------------------------------------------------------------------------------
	-- INTERFACE
	------------------------------------------------------------------------------------------------

	GroupBox grpSettings "Settings management" pos:[4,4] width:232 height:42
	button btnCopy "Copy..." pos:[8,24] width:56 height:16
	button btnPaste "Paste..." pos:[64,24] width:64 height:16 enabled:false
	dropDownList ddlCopyType "" pos:[130,22] width:104 height:21 items:#("All settings", "Output size", "Time", "Scanline options", "Render output", "Renderer", "Camera") enabled:false


	GroupBox grpPreset "Preset management" pos:[240,4] width:128 height:42
	button btnDown "Move Down" pos:[244,24] width:68 height:16
	button btnUp "Move Up" pos:[312,24] width:52 height:16

	GroupBox grpFile "Preset I/O" pos:[372,4] width:188 height:42
	button btnSave "Save" pos:[376,24] width:60 height:16
	button btnLoad "Load" pos:[436,24] width:60 height:16
	button btnClear "Clear" pos:[496,24] width:60 height:16

	GroupBox grpGlobal "Global options" pos:[564,4] width:262 height:42
	checkbox chkAnim "Auto-open animations" pos:[572,24] width:124 height:16 checked:true
	checkbox chkSaveOnClose "Auto-save on close" pos:[700,24] width:120 height:16 checked:false

	GroupBox grpRenderWanger "RenderWanger v0.8" pos:[830,4] width:146 height:42
	button btnHelp "Help" pos:[836,24] width:60 height:16
	button btnWeb "Report bugs" pos:[896,24] width:76 height:16



----------------------------------------------------------------------------------------------------
	-- DECLARATIONS
	------------------------------------------------------------------------------------------------

	local iniPrefs = getDir #scripts + "\\RenderWanger.ini"
	local iniPresets
	local fs
	local tmpArr = #()
	local saveINI, loadINI, savePresets, loadPrestes
	local copyArr, pasteArr


	fn help =
	(
		str= "RenderWanger makes rendering quicker easier when you need to \nchange rendering configurations often.\n\n"
		str+= "Store multiple configurations for:\n"
		str+= "   - Different sizes, resolutions or quality.\n   - Different cameras or animation periods.\n   - Different output paths.\n\n"
		str+= "Render Presets panel:\n   - Click items to edit.\n   - Double-click items to render.\n\n"
		str+= "Edit Settings panel:\n   - Adjust individual settings using the controls provided.\n\n"
		str+= "Tools panel:\n   - Copy, paste and move presets.\n   - Save and load Presets."
		MessageBox str title:"RenderWanger Help"
	)
			
	
	fn initPlugin =
		(
			MessageBox "Setting example rendering presets...\nTo delete them, use the 'Clear' button under the 'Tools' rollout."  title:"RenderWanger is initialising..."

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
	
			RWro2.RSArr[1] =#("Lighting: medium", [512,288], 1, [0,100], true, true, false, false, false, false, "c:/temp/scene.tga", false, true, "", true)
			RWro2.RSArr[2] =#("Materials: medium", [512,288], 1, [0,100], false, false, true, true, true, false, "c:/temp/scene.tga", false, true, "", true)
			RWro2.RSArr[3] =#("Full quality: medium", [512,288], 1, [0,100], true, true, true, true, true, true, "c:/temp/scene_small.tga", true, true, "", true)
			RWro2.RSArr[4] =#("Full quality: Large", [1024,576], 1, [0,100], true, true, true, true, true, true, "c:/temp/scene_big_hq.tga", true, true, "", true)
			RWro2.RSArr[5] =#("Anim: Cam 01, walk cycle only", [512,288], 3, [30,50], false, false, false, false, false, false, "c:/temp/walk cycle.avi", true, true, "Camera01", true)
			RWro2.RSArr[6] =#("Anim: Cam02, lighting & materials", [512,288], 2, [0,100], true, true, true, true, true, false, "c:/temp/scene material test.avi", true, true, "Camera02", true)
			RWro2.RSArr[7] =#("Anim: Cam03, full quality", [1024,576], 2, [0,1000], true, true, true, true, true, true, "c:/temp/scene final animation.avi", true, true, "Camera03", true)
			RWro2.RSArr[8] =#("Anim: Flash", [400,300], 3, [0,100], false, false, false, false, false, false, "c:/temp/scene.swf", true, false, "", true)
	
		-- update UI
			for i = 1 to RWro2.RSArr.count do RWro2.initList i
			RWro2.index = 1
			RWro1.updateUI()
			RWro1.updateListColor()
	
	
		-- save INI settings
			iniPresets = (getDir #scripts +"\\default.rs.ini")
			savePresets()

			if (QueryBox "This appears to be the first time RenderWanger has been run. Would you like to see the help?" title:"RenderWanger information") then help()

		)




----------------------------------------------------------------------------------------------------
	-- FUNCTIONS
	------------------------------------------------------------------------------------------------

	fn setGrpFileText =
	(
		
		local str = (filenameFromPath iniPresets) as string
		grpFile.text = "Preset: " + substring str 1 ((findstring str ".rs")-1)
	)


	------------------------------------------------------------------------------------------------


	fn loadPresets =
	(
		--messagebox ("loadPresets: "+inipresets)
		-- open preset file
			local ln = 0
			local str
			local tmpStr = replaceAll iniPresets "/" "\\"
			fs = openFile tmpStr
		-- read-in line by line
			while not eof fs do
			(
				ln+=1
				try(
					str = readline fs
					str =  replaceAll str "/" "\\\\"
					format "%\n" str
				)
				catch()
		-- set presets array
				execute ("RWro2.RSArr["+ln as string+"]=" + str)
			)
			close fs

		-- Update the UI, etc
			try(
				for i = 1 to ln do RWro2.initList i
				RWro2.indexOld = 1
				RWro2.index = 1
				RWro1.updateUI()
				RWro1.updateListColor()

				--messagebox "updating UI..."
				setGrpFileText()

			)
			catch(
				if (QueryBox "Error updating presets!\n\nWould you like to re-initialise RenderWanger?" title:"RenderWanger Error") then
				(
					deleteFile ((getDir #scripts) + "\\RenderWanger.ini")
					deleteFile ((getDir #scripts) + "\\default.rs.ini")
					--chkSaveOnClose.checked = false
					if(loadINI())then loadPresets()
				)
				else closerolloutfloater RWFloater
			)
		)



	fn savePresets =
	(
		try(
			fs = createFile iniPresets
			for arr in RWro2.RSArr do
			(
				format "arr in RWro2.RSArr is %\n" arr
			-- save a validFileName copy to the stringstream
				local tmpArr = arr
				tmpArr[11] = replaceAll tmpArr[11] "\\" "/"
				format "%\n" tmpArr to:fs
			)
			close fs
			displayTempPrompt ("RenderWanger preset file saved: " + iniPresets as string) 2000
			saveINI()
		)
		catch
		(
			MessageBox ("Error saving preset file: " + iniPresets as string)  title:"RenderWanger info..."
		)
			 	)


	------------------------------------------------------------------------------------------------


	fn saveINI =
	(
		setINISetting iniPrefs "Settings" "LastFileOpened" (replaceAll iniPresets "\\" "/")
		setINISetting iniPrefs "Settings" "AutoOpenAnimations" (chkAnim.state as string)
		setINISetting iniPrefs "Settings" "SaveOnClose" (chkSaveOnClose.state as string)
		setGrpFileText()
	)


	fn loadINI =
	(
		iniPresets = getINISetting iniPrefs "Settings" "LastFileOpened"
		--messagebox ("loadINI: " + inipresets)

		-- if ini file exists
			if ((iniPresets != "") AND (doesFileExist iniPresets)) then
			(
				displayTempPrompt ("RenderWanger: Loading Preset " + iniPresets as string) 2000

			-- update the global settings boxes
				if (getINISetting iniPrefs "Settings" "AutoOpenAnimations") == "false" then chkAnim.checked=false
				if (getINISetting iniPrefs "Settings" "SaveOnClose") == "false" then chkSaveOnClose.checked=false				
				return true
			)
			else
			(
				displayTempPrompt "RenderWanger: No preset file exists!" 3000
				initPlugin()
				saveINI()
				return false
			)
	)


----------------------------------------------------------------------------------------------------
	-- HANDLERS
	------------------------------------------------------------------------------------------------
		on btnWeb pressed do ShellLaunch "http://www.davestewart.co.uk/mxs" ""
		
		on btnLoad pressed do
		(
			local f = getOpenFileName types:"RenderSettings(*.rs.ini)|*.rs.ini|All|*.*|" filename:(getDir #scripts + "\\")
			if f != undefined then
			(
				iniPresets = f
				loadPresets()
			)
		)

		on btnSave pressed do
		(
			local f = getSaveFileName filename:".rs.ini" types:"RenderSettings(*.rs.ini)|*.rs.ini|All|*.*|"
			if f != undefined then
			(
				if findstring f ".rs.ini" == undefined then f = f + ".rs.ini"
				print f
				iniPresets = f
				savePresets()
			)
		)

		on btnClear pressed do
		(
			if (QueryBox "Are you sure you want to clear ALL presets?") then
			(
				for i = 1 to 8 do
				(
					RWro2.RSArr[i] = #("Setting " + i as string, [renderWidth,renderHeight], 1, [0,100], true, false, false, true, false, false, "", true, true, "", true)
					RWro2.initList i
				)
				RWro2.index = 1
				RWro1.updateUI()
				RWro1.updateListColor()
		
			)
		)

		on btnCopy pressed do
		(
			btnPaste.enabled=true
			ddlCopyType.enabled=true
			copyArr = RWro2.RSArr[RWro2.index]
			format "%\n" copyArr
		)

		on btnPaste pressed do
		(
			pasteArr = case ddlCopyType.selection of 
			( 
				1:	#(1,2,3,4,5,6,7,8,9,10,11,12,13)	--"All settings"
				2:	#(2)				--"Output size"
				3:	#(3,4)				--"Time"
				4:	#(5,6,7,8,9,10)		--"Scanline options"
				5:	#(11,12)			--"Render output"
				6:	#(13)				--"Renderer"
				7:	#(14)				--"Camera"
				default: #()
			)
			for i in pasteArr do
			(
				print i
				RWro2.RSArr[RWro2.index][i] = copyArr[i]
			)
			RWro1.updateUI()
		)

		on btnUp pressed do
		(
			if RWro2.index > 1 then
			(
				tmpArr = RWro2.RSArr[RWro2.index-1]
	
				RWro2.RSArr[RWro2.index-1] = RWro2.RSArr[RWro2.index]
				RWro2.RSArr[RWro2.index] = tmpArr
	
				RWro2.indexOld = RWro2.index
				RWro2.index = RWro2.index-1
				
				RWro2.initList RWro2.index
				RWro2.initList RWro2.indexOld
				
				RWro1.updateListColor()
			)
		)

		on btnDown pressed do
		(
			if RWro2.index < RWro2.RSArr.count then
			(
				tmpArr = RWro2.RSArr[RWro2.index+1]
	
				RWro2.RSArr[RWro2.index+1] = RWro2.RSArr[RWro2.index]
				RWro2.RSArr[RWro2.index] = tmpArr
	
				RWro2.indexOld = RWro2.index
				RWro2.index = RWro2.index+1
				
				RWro2.initList RWro2.index
				RWro2.initList RWro2.indexOld
				
				RWro1.updateListColor()
			)
		)
		

		on btnHelp pressed do help()

		on RWro3 oktoclose do
		(
			local action = YesNoCancelBox "Save settings before close?" title:"RenderWanger info..."
				saveINI()
				case action of
				(
					#yes:		(savePresets(); true)
					#no:		true
					#cancel:	false
				)
		)

		on RWro3 open do
		(
			if(loadINI())then loadPresets()
		)

)




if RWFloater != undefined then closerolloutfloater RWFloater
	RWFloater = newRolloutFloater "RenderWanger! v0.8 | Easily manage multiple rendering configurations. Load and save by project, activity or user." 1010 294
	RWFloater.pos = [0,76]
addRollout RWro1 RWFloater
addRollout RWro2 RWFloater
addRollout RWro3 RWFloater








