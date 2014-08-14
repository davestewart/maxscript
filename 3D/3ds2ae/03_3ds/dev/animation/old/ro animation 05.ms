

try(destroyDialog roAnim);catch()

rollout roAnim "Animation" width:328 height:512
(

	local rcAxObj, checkAXItems 


	ActiveXControl ilGr "MSComctlLib.ImageListCtrl" pos:[0,0] width:0 height:0
	ActiveXControl ilBg "MSComctlLib.ImageListCtrl" pos:[0,0] width:0 height:0

	GroupBox grpObj "Object Manager" pos:[8,8] width:312 height:312
		ActiveXControl ax "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" pos:[16,24] width:296 height:264
		button btnAdd "Add..." pos:[16,296] width:72 height:16 toolTip:"Add selected from scene / pick dialog..."
		button btnRemove "Remove" pos:[88,296] width:72 height:16 toolTip:"Remove selected in grid..."
		button btnCopy "C" pos:[164,296] width:16 height:16 toolTip:"Copy settings..."
		button btnPaste "P" pos:[180,296] width:16 height:16 toolTip:"Paste settings..."
		button btnRefresh "Refresh" pos:[256,296] width:56 height:16 toolTip:"Refresh from objects in scene..."

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
		radioButtons rdoExport "" pos:[224,380] width:94 height:32 labels:#("Export as Point", "Export as Null") columns:1

	
	GroupBox grpRange "Animation Range" pos:[8,432] width:312 height:40
		dropdownList ddAnimRange "" pos:[16,446] width:96 height:21 items:#("Single frame", "Current range", "Custom...")
		spinner spnFrom "From: " pos:[138,448] width:52 height:16 range:[0,9999,0] type:#integer scale:1
		spinner spnTo "To: " pos:[208,448] width:52  height:16 range:[0,9999,100] type:#integer scale:1
		spinner spnBy "By:" pos:[278,448] width:40 height:16 range:[1,100,1] type:#integer scale:1

	button btnExport "Export Animation..." pos:[8,480] width:312 height:24


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
		iconFile = "E:\\03_Scripting\\3ds2ae\\03_3ds\\animation\\icons.bmp"
		for i = 1 to 8 do ilGr.listImages.add i #icon (loadPicture (getIconFromBitmap iconFile i))

		ilBg.imagewidth = 14
		ilbg.imageheight = 28
		iconFile = "E:\\03_Scripting\\3ds2ae\\03_3ds\\animation\\bg.bmp"
		ilBg.listImages.add 1 #bg (loadPicture iconFile )

		ax.Picture=roAnim.ilBg.ListImages[1].Picture
		ax.PictureAlignment=#lvwTile
	) 


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

				on miCheck picked do checkAXItems true
				on miUnCheck picked do checkAXItems false
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
					if i == 7 then lis.text=superclassof o as string
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

	on ax MouseDown Button Shift x y do
	(
		if button==2 then popupMenu rcAxObj pos:[x+16,y+24] rollout:roAnim align:#align_topleft
		format "%, %, %, %, %\n" "MouseUp" Button Shift x y 
	)


)
createdialog roAnim roAnim.width roAnim.height 10 10
/*
for i = 1 to roAnimation.ax.listitems.count do roAnimation.ax.listitems[i].forecolor=if (mod i 2 == 1) then (color 255 0 0) else (color 255 255 0)
.backcolor = (color 255 240 240)
*/
--roAnim.ddlExport.items=#("","hello")
--showevents roAnim.ax

--show roAnim.ax.FlatScrollBar=true
--showevents roAnim.ax

