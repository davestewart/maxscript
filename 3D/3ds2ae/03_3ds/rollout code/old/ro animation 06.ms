try(destroyDialog roAnim);catch()

rollout roAnim "Animation" width:400 height:464
(

--------------------------------------------------------------------------------------
-- includes
	include "core/jsx.ms"
	include "core/utility.ms"
	include "core/data functions 08.ms"
	include "core/filestream functions 01.ms"
/*
*/
--------------------------------------------------------------------------------------
-- declarations


	local rcAxObj, checkAXItems, rcm=false

--------------------------------------------------------------------------------------
-- interface


	ActiveXControl ilGr "MSComctlLib.ImageListCtrl" pos:[0,0] width:0 height:0
	ActiveXControl ilBg "MSComctlLib.ImageListCtrl" pos:[0,0] width:0 height:0

	GroupBox grpObj "Object Manager" pos:[8,8] width:384 height:312
		ActiveXControl ax "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" pos:[16,24] width:368 height:264
		button btnAdd "Add..." pos:[16,296] width:72 height:16 toolTip:"Add selected from scene / pick dialog..."
		button btnRemove "Remove" pos:[88,296] width:72 height:16 toolTip:"Remove selected in grid..."
/*
		button btnCopy "C" pos:[164,296] width:16 height:16 toolTip:"Copy settings..." images:#("ui/copyPaste.bmp", "ui/copyPasteMask.bmp", 2, 1, 1, 1, 1)
		button btnPaste "P" pos:[180,296] width:16 height:16 toolTip:"Paste settings..." images:#("ui/copyPaste.bmp", "ui/copyPasteMask.bmp", 2, 2, 2, 2, 2)
*/
		button btnCopy "" pos:[164,296] width:16 height:16 images:#("ui/copyPaste.bmp", "ui/copyPasteMask.bmp", 2, 1, 1, 1, 1) toolTip:"Copy settings"
		button btnPaste "" pos:[180,296] width:16 height:16 images:#("ui/copyPaste.bmp", "ui/copyPasteMask.bmp", 2, 2, 2, 2, 2) toolTip:"Paste settings"

	button btnRefresh "Refresh" pos:[328,296] width:56 height:16 toolTip:"Refresh from objects in scene..."

	GroupBox grpProp "Common" pos:[8,328] width:96 height:96
		checkbox chkTransform "Transform" pos:[16,344] width:72 height:16 checked:true
		checkbox chkPosition "Position" pos:[32,360] width:64 height:16 checked:true
		checkbox chkRotation "Rotation" pos:[32,376] width:64 height:16 checked:true
		checkbox chkScale "Scale" pos:[32,392] width:64 height:16 checked:true
		--checkbox chkTarget "Target" pos:[32,408] width:64 height:15 checked:true

	GroupBox grpOther "Specific" pos:[112,328] width:96 height:96
		checkbox chkAlways "Always" pos:[120,344] width:64 height:16 checked:true triState:2
		checkbox chkCamera "Camera" pos:[136,360] width:64 height:16 checked:true
		checkbox chkLight "Light" pos:[136,376] width:64 height:16 checked:true
		checkbox chkText "Text" pos:[136,392] width:64 height:16 checked:true

	GroupBox grpExport "Miscellaneous" pos:[216,328] width:104 height:96
		checkbox chkVisibility "Visibility" pos:[224,344] width:64 height:16
		checkbox chkMaterials "Materials" pos:[224,360] width:64 height:16
		radiobuttons rdoExport "" pos:[224,384] width:94 height:32 labels:#("Export as Point", "Export as Null") columns:1

	button btnExport "Export Animation..." pos:[8,432] width:384 height:24



--------------------------------------------------------------------------------------
-- functions


	function exportObjects=
	(
		clearListener()
		local objectCode=stringstream ""
		local comp="Comp 1"
		local sel=getCurrentSelection()
	
		for s in sel do if classof s != Targetobject then format (printObject s) to:objectCode
		
		buildFinalJSXCode comp (objectCode as string)
	)


	fn getIconFromBitmap thePath number =
	(
		tempBmp = openBitmap thePath
		iconBmp = bitmap 15 15
		for v = 0 to iconBmp.width-1 do
		setPixels iconBmp [0,v] (getPixels tempBmp [(number-1)*15, v] 15)
		iconBmp.filename = getDir #image +"/_temp.bmp"
		--display iconBmp
		save iconBmp
		close iconBmp 
		close tempBmp
		getDir #image +"/_temp.bmp"
		/*
		*/
	)

	fn initAXIcons=
	(
		ilGr.imagewidth = 16
		ilGr.imageheight = 15
		iconFile = max2ae.appFolder+"ui/icons.bmp"
		for i = 1 to 8 do ilGr.listImages.add i #icon (loadPicture (getIconFromBitmap iconFile i))

		ilBg.imagewidth = 14
		ilbg.imageheight = 28
		iconFile = max2ae.appFolder+"ui/listBg.bmp"
		ilBg.listImages.add 1 #bg (loadPicture iconFile )

		ax.Picture=roAnim.ilBg.ListImages[1].Picture
		ax.PictureAlignment=#lvwTile
	) 


--------------------------------------------------------------------------------------
-- handlers


	on roAnim open do
	(
		-- icons
			initAXIcons()
			ax.ColumnHeaderIcons=ilGr

		-- style
			ax.MultiSelect=true
			ax.MousePointer = #ccArrow 
			ax.GridLines = true 
			ax.Checkboxes = true 
			ax.AllowColumnReorder = false 
			ax.BorderStyle = #ccFixedSingle 
			ax.view = #lvwReport
			ax.FullRowSelect=true
			ax.LabelEdit=#lvwManual
		
		-- set headers
			ch = ax.columnHeaders 
			hProp = ch.Add index:"Object"--; hProp.width=40*15
			hProp = ch.Add index:""; hProp.width=40*15
			hProp = ch.Add index:""; hProp.width=40*15
			hProp = ch.Add index:""; hProp.width=40*15
			hProp = ch.Add index:""; hProp.width=50*15
			hProp = ch.Add index:""; hProp.width=50*15
			hProp = ch.Add index:""; hProp.width=50*15
			hProp = ch.Add index:""; hProp.width=76*15

/*
		-- width
			for i=2 to 4 do ch[i].width=40*15
			for i=5 to 8 do ch[i].width=50*15
			ch[8].width=76*15
*/
		-- alignment
			for i=2 to 8 do ch[i].Alignment=#lvwColumnCenter

		-- icons
			ax.Icons=ilGr
			for i = 1 to 8 do ax.ColumnHeaders[i].icon=i
			--ax.SmallIcons=true

		-- right click stuff
			rcmenu rcAxObj
			(
				menuItem miCheck "Check selected"
				menuItem miUnCheck "Uncheck selected"
				separator sep1
				menuItem miSel "Select all"
				menuItem miUnSel "Unselect all"
				menuItem miSelInv "Select inverted"

				on miCheck picked do (
					checkAXItems true
					rcm=false
				--	format "rcm=%\n" rcm
				)
				on miUnCheck picked do
				(
					checkAXItems false
					rcm=false
				--	format "rcm=%\n" rcm
				)
				
	on rcAxObj open do
	(
		rcm=true
		format "rcm=%\n" rcm
 	)
			)

		-- tidy up	
			ax.refresh()
	)

	
	on ax itemClick Item do
	(
		try(
			--messagebox (Item.selected as string)
			local obj=getnodebyname (Item.text)
			if Item.selected then selectmore obj
			else deselect obj
		)
		catch()
	)

	on btnAdd pressed do
	(
		for o in objects do
		(
			if classof o != Targetobject then
			(
				li=ax.ListItems.Add index:o.name
				--print li.ListSubItems.count
				--li.ListSubItems.Add text:(superclassof o as string)
				for i = 1 to 7 do
				(
					lis=li.ListSubItems.Add()-- text:""
					lis.bold=true
					if i<=3 then lis.text="x"
					if i==3 AND (superclassof o==Camera OR superclassof o==Light) then lis.text=""
					if i==4 AND superclassof o==Camera then lis.text="x"
					if i==5 AND superclassof o==Light then lis.text="x"
					if i == 7 then lis.text=ax.listItems.count--superclassof o as string
				)
			)
		)
		ax.refresh()
	)

	fn checkAXItems state=
	(
		for i = 1 to ax.listitems.count do
		(
			li=ax.listitems[i]
			if li.selected then li.checked = state
		)
	)

	on btnCheck changed state do checkAXItems state

	on ax ItemClick Item do
	(
			if rcm == false then print Item.index
		 )

	on ax MouseDown Button Shift x y do
	(
		if rcm == false then
		(
			if button==2 then popupMenu rcAxObj pos:[x+16,y+24] rollout:roAnim align:#align_topleft
			--format "%, %, %, %, %\n" "MouseDown" Button Shift x y
			local yOffset = -((ax.listitems[1].top-503)/ax.listitems[1].height) as integer
			local item=((y-20)/14)+1
			--format "Clicked item: %\n" (yOffset+item)
		)
	)

	on btnExport pressed do
	(
		exportObjects()
	)

)
if max2ae==undefined then createdialog roAnim roAnim.width roAnim.height 10 10
/*
for i = 1 to roAnimation.ax.listitems.count do roAnimation.ax.listitems[i].forecolor=if (mod i 2 == 1) then (color 255 0 0) else (color 255 255 0)
.backcolor = (color 255 240 240)
*/
--roAnim.ddlExport.items=#("","hello")
--showevents roAnim.ax

--show roAnim.ax.FlatScrollBar=true
--showevents roAnim.ax

/*
roAnim.ax.listitems[1].left
roAnim.ax.columnheaders[3].width
roAnim.ax.DropHighlight
*/