--VMS Tidy test rollout

try(destroyDialog roAnim);catch()

rollout roAnim "Animation" width:328 height:528
(

	ActiveXControl ilGr "MSComctlLib.ImageListCtrl" pos:[13,7] width:0 height:0

	GroupBox grpObj "Object Manager" pos:[8,8] width:312 height:312
		ActiveXControl ilBg "MSComctlLib.ImageListCtrl" pos:[13,12] width:0 height:0
		ActiveXControl axObj "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" pos:[16,24] width:296 height:264
		button btnAdd "Add..." pos:[16,296] width:72 height:16 toolTip:"Add selected from scene / pick dialog..."
		button btnRemove "Remove" pos:[88,296] width:72 height:16 toolTip:"Remove selected in grid..."
		button btnCopy "C" pos:[164,296] width:16 height:16 toolTip:"Add selected from scene / pick dialog..."
		button btnPaste "P" pos:[180,296] width:16 height:16 toolTip:"Add selected from scene / pick dialog..."
		button btnRefresh "Refresh" pos:[200,296] width:56 height:16 toolTip:"Remove selected in grid..."
		button btnClear "Clear All" pos:[256,296] width:56 height:16 toolTip:"Remove selected in grid..."

	GroupBox grpProp "Common" pos:[8,328] width:96 height:112
		checkbox chkTransform "Transform" pos:[16,344] width:72 height:16 checked:true
		checkbox chkPosition "Position" pos:[32,360] width:64 height:16 checked:true
		checkbox chkRotation "Rotation" pos:[32,376] width:64 height:16 checked:true
		checkbox chkScale "Scale" pos:[32,392] width:64 height:16 checked:true
		checkbox chkVisibility "Visibility" pos:[16,416] width:64 height:16

	GroupBox grpOther "Specific" pos:[112,328] width:96 height:112
		checkbox chkAlways "Always" pos:[120,344] width:64 height:16 checked:true triState:2
		checkbox chkCamera "Camera" pos:[136,360] width:64 height:16 checked:true
		checkbox chkLight "Light" pos:[136,376] width:64 height:16 checked:true
		checkbox chkText "Text" pos:[136,392] width:64 height:16 checked:true
		checkbox chkMaterials "Materials" pos:[120,416] width:64 height:16

	GroupBox grpExport "Miscellaneous" pos:[216,328] width:104 height:112
		dropdownList ddlExport "Create as:" pos:[224,346] width:88 height:40 items:#("Null", "Solid", "Light", "Camera", "Text")

	GroupBox grpRange "Animation Range" pos:[8,448] width:312 height:48
		dropdownList ddAnimRange "" pos:[16,462] width:120 height:21 items:#("Single frame", "Current range", "Custom...")
		spinner spnFrom "From: " pos:[176,464] width:61 height:16 range:[0,9999,0] type:#integer scale:1
		spinner spnTo "To: " pos:[256,464] width:56 height:16 range:[0,9999,100] type:#integer scale:1

	button btnExport "Export Animation !" pos:[8,504] width:312 height:16


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
/*
	fn initAXIcons=
		(
		ilGr.imagewidth = 16
		ilGr.imageheight = 15
		iconDir = (getDir #ui) + "\\icons"
		ilGr.listImages.add 1 #root (loadPicture (getIconFromBitmap (iconDir + "\\Standard_16i.bmp") 2))
		ilGr.listImages.add 2 #geomnode (loadPicture (getIconFromBitmap (iconDir + "\\Standard_16i.bmp") 1))
		ilGr.listImages.add 3 #light (loadPicture (getIconFromBitmap (iconDir + "\\Lights_16i.bmp") 3))
		ilGr.listImages.add 4 #camera (loadPicture (getIconFromBitmap (iconDir + "\\Cameras_16i.bmp") 2))
		ilGr.listImages.add 5 #helper (loadPicture (getIconFromBitmap (iconDir + "\\Helpers_16i.bmp") 1))
		--axObj.imageList = ilGr 
		) 
*/
	fn initAXIcons=
		(
		ilGr.imagewidth = 16
		ilGr.imageheight = 15
		iconFile = "E:\\03_Scripting\\3ds2ae\\03_3ds\\animation\\icons.bmp"
		for i = 1 to 7 do ilGr.listImages.add i #icon (loadPicture (getIconFromBitmap iconFile i))
		--axObj.imageList = ilGr 

		ilBg.imagewidth = 14
		ilbg.imageheight = 28
		iconFile = "E:\\03_Scripting\\3ds2ae\\03_3ds\\animation\\bg.bmp"
		ilBg.listImages.add 1 #bg (loadPicture iconFile )
		--axObj.imageList = ilGr 

		axObj.Picture=roAnim.ilBg.ListImages[1].Picture
		axObj.PictureAlignment=#lvwTile

		) 



	on roAnim open do
		(
		-- icons
			initAXIcons()
			axObj.ColumnHeaderIcons=ilGr

		
		-- objects -------------------------------------
		-- style
			axObj.MultiSelect=true
			axObj.MousePointer = #ccArrow 
			axObj.GridLines = true 
			axObj.Checkboxes = true 
			axObj.AllowColumnReorder = false 
			axObj.BorderStyle = #ccFixedSingle 
			axObj.view = #lvwReport
			axObj.LabelEdit=#lvwManual
		
		-- set headers
			ch = axObj.columnHeaders 
			hProp = ch.Add index:"Object"
			hProp = ch.Add index:"P"
			hProp = ch.Add index:"R"
			hProp = ch.Add index:"S"
			hProp = ch.Add index:"Cam"
			hProp = ch.Add index:"Lgt"
			hProp = ch.Add index:"Mtl"
			hProp = ch.Add index:""


		-- width
			for i=2 to 4 do ch[i].width=40*15
			for i=5 to 8 do ch[i].width=50*15
			ch[8].width=76*15

		-- alignment
			for i=2 to 8 do ch[i].Alignment=#lvwColumnCenter

		-- icons
			for i = 2 to 8 do
				(
				axObj.ColumnHeaders[i].icon=i-1
				--axObj.ColumnHeaders[i].Left=0.0
				)
			axObj.Icons=ilGr
			--axObj.SmallIcons=true

		-- populate
			list = axObj.listItems
			local controlData=#("Sphere01","Box02","Point01", "Dummy01")
			for i=1 to controlData.count do 
				(
				local itemHead, itemBody
				itemHead = list.Add index:(controlData[i] as string)
				--itemBody = itemHead.listsubitems.add index:"PRS Cam Mat Vis"
				)
			
			axObj.refresh()
		)

	on axObj itemClick Item do
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
			li=axObj.ListItems.Add index:o.name
			--print li.ListSubItems.count
			li.ListSubItems.Add text:(superclassof o as string)
			)
		)
	
/*
	on axObj BeforeLabelEdit Cancel do format "%, %\n" "BeforeLabelEdit" Cancel 
	on axObj AfterLabelEdit Cancel NewString do format "%, %, %\n" "AfterLabelEdit" Cancel NewString 
	on axObj ColumnClick ColumnHeader do format "%, %\n" "ColumnClick" ColumnHeader 
	on axObj ItemClick Item do format "%, %\n" "ItemClick" Item 
	on axObj KeyDown KeyCode Shift do format "%, %, %\n" "KeyDown" KeyCode Shift 
	on axObj KeyUp KeyCode Shift do format "%, %, %\n" "KeyUp" KeyCode Shift
	on axObj KeyPress KeyAscii do format "%, %\n" "KeyPress" KeyAscii 
	on axObj MouseDown Button Shift x y do format "%, %, %, %, %\n" "MouseDown" Button Shift x y 
	on axObj MouseMove Button Shift x y do format "%, %, %, %, %\n" "MouseMove" Button Shift x y 
	on axObj MouseUp Button Shift x y do format "%, %, %, %, %\n" "MouseUp" Button Shift x y 
	on axObj Click do format "%\n" "Click"
	on axObj DblClick do format "%\n" "Doubleclick"
	on axObj OLEStartDrag &Data &AllowedEffects do format "%, %, %\n" "OLEStartDrag" &Data &AllowedEffects 
	on axObj OLEGiveFeedback &Effect &DefaultCursors do format "%, %, %\n" "OLEGiveFeedback" &Effect &DefaultCursors 
	on axObj OLESetData &Data &DataFormat do format "%, %, %\n" "OLESetData" &Data &DataFormat 
	on axObj OLECompleteDrag &Effect do format "%, %\n" "OLECompleteDrag" &Effect 
	on axObj OLEDragOver &Data &Effect &Button &Shift &x &y &State do format "%, %, %, %, %, %, %\n" "OLEDragOver" &Data &Effect &Button &Shift &x &y &State 
	on axObj OLEDragDrop &Data &Effect &Button &Shift &x &y do format "%, %, %, %, %, %, %\n" "OLEDragDrop" &Data &Effect &Button &Shift &x &y 
	on axObj ItemCheck Item do format "%, %\n" "ItemCheck" Item 
*/

)
createdialog roAnim
/*
for i = 1 to roAnimation.axObj.listitems.count do roAnimation.axObj.listitems[i].forecolor=if (mod i 2 == 1) then (color 255 0 0) else (color 255 255 0)
.backcolor = (color 255 240 240)
*/
--roAnim.ddlExport.items=#("","hello")
--showevents roAnim.axObj