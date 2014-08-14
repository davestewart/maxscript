---------------------------------------------------------------------------------------------------
-- global declarations
---------------------------------------------------------------------------------------------------
global RSro1 RSro2

rollout RSro1 "Render Presets  ( Single-click to edit  /  Double-click to render )" width:816 height:180
(
	ActiveXControl ax "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" pos:[5,22] width:882 height:118
		label lblName "Setting Name" pos:[12,6] width:160 height:16 bold:true
		label lblSize "Output Size" pos:[142,6] width:160 height:16
		label lblTime "Time Output" pos:[250,6] width:160 height:16

		label lblSH "sh" pos:[369,6] width:16 height:16
		label lblAA "aa" pos:[386,6] width:16 height:16
		label lblref "ref" pos:[403,6] width:16 height:16
		label lblmp "mp" pos:[419,6] width:16 height:16
		label lblflt "flt" pos:[439,6] width:16 height:16
		label lblMB "mb" pos:[453,6] width:16 height:16

		label lblOutput "Render Output" pos:[474,6] width:160 height:16
		label lblRend "Renderer" pos:[820,6] width:160 height:16




	--GroupBox grpOpt "Import" pos:[8,144] width:880 height:42


	on RSro1 open do
	(
	-- SET UP AX OBJECT
	--------------------------------------------------------
		ax.MousePointer = #ccArrow 
		ax.GridLines = true 
		ax.AllowColumnReorder = false 
		ax.BorderStyle = #ccFixedSingle 
		ax.view = #lvwReport -- ( #lvwIcon | #lvwSmallIcon | #lvwList | #lvwReport )
		ax.Checkboxes=false
		ax.FullRowSelect = true
		ax.MultiSelect = false
		ax.HideColumnHeaders =true
		
		chs = ax.columnHeaders
		
		--showProperties chs 
		--showMethods chs
		
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
						"Renderer")
		
		for i = 1 to colLabels.count  do
		(
			tmp = chs.Add Width:200
			tmp.text=colLabels[i]
			--execute(colLabels[i] + ".text = " + colLabels[i] as string)

		)
		
	-- ADD ITEMS
	--------------------------------------------------------
	for i = 1 to 8 do
	(
		local li = ax.listItems.Add() 
		--local str = "Item " + i as string
		--li.text = str
		for j = 2 to 11 do
		(
			lsi = ax.ListItems[i].ListSubItems.add() --ForeColor:(128*128*128)
			--str = str = "Item " + ((10*(i-1))+j) as string
			--lsi.text = str
		)
/*
*/
	)

	-- CHANGE COL WIDTHS
	--------------------------------------------------------
/*
Syntax
        lResult = SendMessage(               // returns LRESULT in lResult
        (HWND) hWndControl,                  // handle to destination control
        (UINT) LVM_SETCOLUMNWIDTH,           // message ID
        (WPARAM) wParam,                     // = (WPARAM) (int) iCol
        (LPARAM) lParam                      // = (LPARAM) MAKELPARAM ((int) cx, 0)
        );
*/ 

		--LVM_FIRST = 0x1000
		--LVM_SETCOLUMNWIDTH = (LVM_FIRST+30)

--		windows.sendMessage ax.hwnd LVM_SETCOLUMNWIDTH 0 500

		LVM_SETCOLUMNWIDTH = (0x1000+30)
		local colWidths =#(126,110,122,17,17,17,17,17,17,344,72)
		for i = 1 to colWidths.count do
			windows.sendMessage ax.hwnd LVM_SETCOLUMNWIDTH (i-1) (colWidths[i])
		ax.refresh()


	-- Randomly check render options
	--------------------------------------------------------
		for i = 1 to ax.listItems.count do
		(
			for j = 1 to 6 do
			(
				local n str
				n = random 0 1
				if n == 0 then str = "" else str="x"
				ax.listItems[i].ListSubItems[j+2].text=str
			)
		)

)
		


	-- col select code
	--------------------------------------------------------
	/*
	local varIndex, h, col, argButton, argShift, argX, argY, argItem
	
	on ax mouseDown argButton argShift argX argY do
	(
		col = argX
	)
	on ax itemClick argItem do
	(
		For h in ax.ColumnHeaders do
		(
			if col > (h.Left + ax.pos.x) and col < (h.Left + ax.pos.x + h.Width) then
			(
				-- Found the column
				varIndex = h.Index
				exit
			)
		)
		format "Row: %\tColumn: %\n" argItem.Index varIndex
	)
	*/
	  on ax Click do (
		RSro2.index = ax.SelectedItem.index
		format "%\n" RSro2.index
	)
	
	-- Column Resizing
	--------------------------------------------------------
	  on ax ColumnClick col do print col


	-- Useful code
	--------------------------------------------------------
	/*	
	-- To move column headers
		RSro1.ax.columnHeaders[1].position = 0
		RSro1.ax.refresh()
	
	-- to check an item
		RSro1.ax.listItems[1].checked = true
	
	
	-- to set an items text
		RSro1.ax.listItems[1].text = "c:\\renders\\large\\video1.avi"
	
	-- To set the color
	-- BGR value = (blue * 65536) + (green * 256) + red 
		local c r g b
		r = 128
		g = 128
		b = 128
		local c= (b * 65536) + (g * 256) + r 
		
		RSro1.ax.listitems[1].ListSubItems[1].ForeColor = (128*128*128)
		RSro1.ax.Refresh()





	*/
	-- SET UP VARIABLES
	--------------------------------------------------------
	on ax DblClick do (print (RSro2.index as string + " Double-clicked"))
)

rollout RSro2 "Options" width:816 height:192
(
	---------------------------------------------------------------------------------------------------
	-- declarations
	---------------------------------------------------------------------------------------------------

	local index = 1
	local initList
	--struct RSCfg (name,size,time,sh,aa,ref,mp,fm,mb,path,save,renderer,display)
	local RSArr = #()
	

	

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------

	GroupBox grpName "Setting Name" pos:[4,4] width:128 height:68
		edittext edtName "" pos:[4,48] width:124 height:16 text:"Render Setting 1" tabIndex:1

	GroupBox grpSize "Output Size" pos:[136,4] width:104 height:68
		label lblWidth "Width" pos:[145,32] width:32 height:16
		label lblHeight "Height" pos:[192,32] width:32 height:16
			
		spinner spnWidth "" pos:[140,48] width:48 height:16 range:[0,9999,1024] type:#integer scale:1
		spinner spnHeight "" pos:[188,48] width:48 height:16 range:[0,9999,576] type:#integer scale:1

	GroupBox grpTime "Time Output" pos:[244,4] width:120 height:68
		label lblFrom "From" pos:[268,32] width:32 height:16
		label lblTo "To" pos:[316,32] width:32 height:16
	
		button btnRndType "S" pos:[248,48] width:16 height:16 toolTip:"S=single, C=current, R=range" tabIndex:2
		spinner spnRndFrom "" pos:[264,48] width:48 height:16 range:[-9999,9999,0] type:#integer scale:1
		spinner spnRndTo "" pos:[312,48] width:48 height:16 range:[-9999,9999,100] type:#integer scale:1


	GroupBox grpScanline "Scanline Options" pos:[368,4] width:100 height:68
		label lblSH "sh" pos:[372,32] width:16 height:16
		label lblAA "aa" pos:[387,32] width:16 height:16
		label lblref "ref" pos:[404,32] width:16 height:16
		label lblmp "mp" pos:[419,32] width:16 height:16
		label lblFlt "flt" pos:[438,32] width:16 height:16
		label lblMB "mb" pos:[450,32] width:16 height:16

		checkbox chkSH "" pos:[372,48] width:16 height:16 enabled:true checked:false  tooltip:"Anti-aliasing"
		checkbox chkAA "" pos:[388,48] width:16 height:16 enabled:true checked:false
		checkbox chkREF "" pos:[404,48] width:16 height:16 enabled:true checked:false
		checkbox chkMP "" pos:[420,48] width:16 height:16 enabled:true checked:false
		checkbox chkFM "" pos:[436,48] width:16 height:16 enabled:true checked:false
		checkbox chkMB "" pos:[450,48] width:16 height:16 enabled:true checked:false

	
	GroupBox grpOutput "Render Output" pos:[472,4] width:340 height:68
		label lblPath "Output path" pos:[496,32] width:160 height:16

		button btnPath ">" pos:[478,48] width:16 height:16 toolTip:"Get file path"
		edittext edtPath "" pos:[492,48] width:300 height:16
		checkbox chkSave "" pos:[794,48] width:16 height:16 enabled:true checked:true

	GroupBox grpRend "Renderer" pos:[816,4] width:70 height:68
		checkbutton ckbRend "Production" pos:[820,48] width:60 height:16 highlightColor:(color 255 196 0)


	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	on ax click do print "clicked"

	-- Name
		on edtName changed text do
		(
			RSArr[index][1] = text as String
			initList index
		)
	
	-- Output Size
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
			
	
	-- Time
		local rndArr=#("S","A","R"), i=1
		on btnRndType pressed  do
		(
			i+=1
			if i > rndArr.count then i = 1
			btnRndType.text = rndArr[i]
	
			if i!=3 then	(spnRndFrom.enabled=false;spnRndTo.enabled=false)
				else	(spnRndFrom.enabled=true;spnRndTo.enabled=true)
				
			case i of
			(
				1:	grpTime.text= "Time (Single)"
				2:	grpTime.text= "Time (Active time)"
				3:	grpTime.text= "Time (Range)"
			)
		)
	
	
	
	
	
		/*
		RSro1.ax.ListItems[1].ListSubItems[2].text = "Single frame"
		RSro1.ax.ListItems[2].ListSubItems[2].text = "Active Time Segment"
		RSro1.ax.ListItems[3].ListSubItems[2].text = "0 - 100"
		
		*/
	
	
		on spnRndFrom changed val do
			if val >= spnRndTo.value then spnRndTo.value=val
	
		on spnRndTo changed val do
			if val <= spnRndFrom.value then spnRndFrom.value=val
	
	
		on ckbRend changed state do
		(
			rnd = case ckbRend.state of 
			( 
				true: #Draft
				false: #Production
				default: #Production
			)
			ckbRend.text = rnd
		)
	
	
	
		on btnPath pressed do
		(
			path = getSaveFileName "Choose output directory and filename"
			
			if path != undefined then
			(
				edtPath.text = path
				RSArr[index][9] = path
				initList index
			)
		)
	
		on chkSave changed state do edtPath.enabled = state


	---------------------------------------------------------------------------------------------------
	-- Final Setup
	---------------------------------------------------------------------------------------------------

	function initList i=
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

			
		-- Output Type
			j = 3
			cell = RSro1.ax.ListItems[i].ListSubItems[j-1]
			local ot = RSArr[i][j]

		-- Output
			j = 4
			cell = RSro1.ax.ListItems[i].ListSubItems[j-2]

			if ot == #single then str = "Single"
			else if ot == #active then str = "Active time segment"
			else if ot == #range then
			(
				local r = RSArr[i][j]
				str = "Range: " + (r.x as Integer) as String + " - " + (r.y as Integer) as String 
			)
			cell.text = str

		-- Scanline Options
			for j = 5 to 11 do
			(
				cell = RSro1.ax.ListItems[i].ListSubItems[j-2]
				local opt = RSArr[i][j]
				if opt==true then cell.text = "x" else cell.text = ""
			)
		
		-- Render Output
			j = 11
			cell = RSro1.ax.ListItems[i].ListSubItems[j-2]
			local p = RSArr[i][j]
			cell.text = p


		-- Save
			j = 12
			cell = RSro1.ax.ListItems[i].ListSubItems[j-3]
			local sv = RSArr[i][j]
			if sv == false then cell.ForeColor = 255

		-- Renderer
			j = 13
			cell = RSro1.ax.ListItems[i].ListSubItems[j-3]
			local r = RSArr[i][j]
			if r == "#production" then str="Production" else str = "Draft" 
			cell.text = str
/*
*/
	)

	on RSro2 open do
	(
		path = getFilenamePath  rendOutputFilename
		edtPath.text = path

		--rndFloater.height=300
		
	--print RSArr.count
	--RSArr = #(RSCfg name:"Setting 1", RSCfg name:"setting 2")
	--classOf RSArr
	RSArr[1] = #("Still: Small, LQ",[512,288],#single,[0,100],FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,"c:\\temp",FALSE,"#production",TRUE)
	RSArr[2] = #("Still: Small, MQ",[512,288],#single,[0,100],FALSE,TRUE,FALSE,TRUE,TRUE,FALSE,"c:\\temp",FALSE,"#production",TRUE)
	RSArr[3] = #("Still: Large, HQ (Lighting)",[1024,576],#single,[0,100],TRUE,FALSE,TRUE,TRUE,FALSE,FALSE,"c:\\temp",FALSE,"#production",TRUE)
	RSArr[4] = #("Anim: Small, HQ",[341,192],#active,[0,100],TRUE,TRUE,TRUE,TRUE,FALSE,FALSE,"c:\\temp\\scene.avi",TRUE,"#production",TRUE)
	RSArr[5] = #("Anim: Medium, LQ",[512,288],#active,[0,100],FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,"c:\\temp\\scene.avi",TRUE,"#production",TRUE)
	RSArr[6] = #("Anim: Large, HQ (Preview segment)",[1024,576],#range,[40,60],TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,"c:\\temp\\scene.avi",TRUE,"#production",TRUE)
	RSArr[7] = #("Flash: Single Frame",[1024,576],#single,[0,100],TRUE,TRUE,TRUE,TRUE,FALSE,FALSE,"c:\\temp",FALSE,"#draft",TRUE)
	RSArr[8] = #("Flash: Anim",[1024,576],#active,[0,100],TRUE,TRUE,TRUE,TRUE,FALSE,FALSE,"c:\\temp",FALSE,"#draft",TRUE)
	
	for i = 1 to RSArr.count do initList i

		
	)

)




if rndFloater != undefined then closerolloutfloater rndFloater
	rndFloater = newRolloutFloater "My Floater" 920 300
	rndFloater.pos = [0,0]
addRollout RSro1 rndFloater
addRollout RSro2 rndFloater



/*
Time Output
	·	rendTimeType		integer
		·	1 (single)
		·	2 (active)
		·	3 (range)
	·	rendStart			time
	·	rendEnd				time

Render Output
	·	rendOutputFilename 	string
	·	rendSaveFile		boolean 

Output Size
	·	RenderHeight		integer
	·	RenderWidth			integer

Render Options
	·	rendHidden			boolean 
	·	rendAtmosphere		boolean
	·	renderEffects 		boolean

JbTools

Scanline Options
	·	antiAliasing		boolean
	·	shadows				boolean
	·	mapping				boolean
	·	filterMaps			boolean
	·	autoReflect			boolean

str="Setting one;[1024,576];[0,0];0;0;0;0;0;0;c:\\renders;true;production;true"
str = filterstring str ";"
for s in str do format "%\n" s


*/
/*

-- make floater small
rndFloater.size = [160,153]
RSro1.scrollPos = 40
rndFloater.pos+=[0,8]


*/