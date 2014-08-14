/*
appFolder="E:\\03_Scripting\\3ds2ae\\03_3ds\\rollout code\\"
appAE="C:\\Design\\4_Video\\After Effects 6.5\\Support Files\\afterfx.exe"
*/


try(destroyDialog roAnim);catch()

rollout roAnim "Animation" width:400 height:464
(

--------------------------------------------------------------------------------------
-- includes
	include "core/jsx.ms"
	include "core/utility.ms"
	include "core/data functions 09.ms"
	include "core/filestream functions 01.ms"
/*
*/
--------------------------------------------------------------------------------------
-- declarations


	local rcAxObj, checkAXItems, rcm=false, showObjectManager 
	local objectConstructorCode="object constructor 11.jsx"

--------------------------------------------------------------------------------------
-- interface


	GroupBox grpSel "Use objects in..." pos:[8,8] width:384 height:40
		radiobuttons rdoUse "" pos:[16,24] width:327 height:16 enabled:true labels:#("Viewport selection", "Object Manager") columns:3 default:2

	GroupBox grpObj "Object Manager" pos:[8,56] width:384 height:312
		ActiveXControl ilGr "MSComctlLib.ImageListCtrl" pos:[0,0] width:0 height:0
		ActiveXControl ilBg "MSComctlLib.ImageListCtrl" pos:[0,0] width:0 height:0
		ActiveXControl ax "{BDD1F04B-858B-11D1-B16A-00C0F0283628}" pos:[16,72] width:368 height:264
		button btnAdd "Add..." pos:[16,344] width:72 height:16 toolTip:"Add selected from scene / pick dialog..."
		button btnRemove "Remove" pos:[88,344] width:72 height:16 toolTip:"Remove selected in grid..."
		button btnCopy "" pos:[164,344] width:16 height:16 images:#("ui/copyPaste.bmp", "ui/copyPasteMask.bmp", 2, 1, 1, 1, 1) toolTip:"Copy settings"
		button btnPaste "" pos:[180,344] width:16 height:16 images:#("ui/copyPaste.bmp", "ui/copyPasteMask.bmp", 2, 2, 2, 2, 2) toolTip:"Paste settings"
		button btnRefresh "Refresh" pos:[328,344] width:56 height:16 toolTip:"Refresh from objects in scene..."

	GroupBox grpProp "Common" pos:[8,376] width:96 height:96
		checkbox chkTransform "Transform" pos:[16,392] width:72 height:16 checked:true
		checkbox chkPosition "Position" pos:[32,408] width:64 height:16 checked:true
		checkbox chkRotation "Rotation" pos:[32,424] width:64 height:16 checked:true
		checkbox chkScale "Scale" pos:[32,440] width:64 height:16 checked:true

	GroupBox grpOther "Specific" pos:[112,376] width:96 height:96
		checkbox chkAlways "Always" pos:[120,392] width:64 height:16 checked:true --triState:2
		checkbox chkCamera "Camera" pos:[136,408] width:64 height:16 checked:true
		checkbox chkLight "Light" pos:[136,424] width:64 height:16 checked:true
		checkbox chkText "Text" pos:[136,440] width:64 height:16 checked:true

	GroupBox grpExport "Miscellaneous" pos:[216,376] width:176 height:96
		checkbox chkVisibility "Visibility" pos:[224,392] width:64 height:16
		checkbox chkMaterials "Materials" pos:[224,408] width:64 height:16
		checkbox chkIgnoreLights "Objects ignore lights" pos:[224,424] width:120 height:16
		label lblExport "Export as:" pos:[224,448] width:48 height:16
		radiobuttons rdoExport "" pos:[280,448] width:105 height:16 labels:#("Null", "Point") columns:2

	button btnExport "Export Animation..." pos:[8,480] width:384 height:24


--------------------------------------------------------------------------------------
-- functions


	fn exportObjects=
		(
		if (SETTINGS.checkBeforeExport()) then
			(
			--start
				clearListener()
				
			-- variables
				local objectCode=stringstream ""
				local templateCode=stringstream ""
				local finalCode=stringstream ""
				local sel, f, comp
			
			-- comp code
				comp=SETTINGS.compName
				if comp != undefined then comp="'"+comp+"'"

			-- object code
				sel=getCurrentSelection()
				for s in sel do format (printObject s) to:objectCode

			-- get template
				--f=openencryptedfile "objects.dat" key
				f=openfile (appFolder+"jsx\\"+objectConstructorCode) mode:"r"
				while not eof f do format"%\n" (readline f) to:templateCode
				close f

			-- insert object code into template
				format (templateCode as string) comp (objectCode as string) to:finalCode

			-- into it, create jsx and run
				createJSX "maxObjects.jsx" (finalCode as string)
			
			)
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
		iconFile = appFolder+"ui/icons.bmp"
		for i = 1 to 8 do ilGr.listImages.add i #icon (loadPicture (getIconFromBitmap iconFile i))

		ilBg.imagewidth = 14
		ilbg.imageheight = 28
		iconFile = appFolder+"ui/listBg.bmp"
		ilBg.listImages.add 1 #bg (loadPicture iconFile )

		ax.Picture=roAnim.ilBg.ListImages[1].Picture
		ax.PictureAlignment=#lvwTile
		) 


--------------------------------------------------------------------------------------
-- handlers


	--------------------------------------------------------------------------------------
	-- AX Stuff
	--------------------------------------------------------------------------------------

	on roAnim open do
		(
		
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
			hProp = ch.Add index:"P"; hProp.width=40*15
			hProp = ch.Add index:"R"; hProp.width=40*15
			hProp = ch.Add index:"S"; hProp.width=40*15
			hProp = ch.Add index:"Cm"; hProp.width=50*15
			hProp = ch.Add index:"Lt"; hProp.width=50*15
			hProp = ch.Add index:"Mt"; hProp.width=50*15
			hProp = ch.Add index:"LNum"; hProp.width=76*15

/*
		-- width
			for i=2 to 4 do ch[i].width=40*15
			for i=5 to 8 do ch[i].width=50*15
			ch[8].width=76*15
*/
		-- alignment
			for i=2 to 8 do ch[i].Alignment=#lvwColumnCenter

		-- icons
			if SETTINGS != undefined then
				(
				initAXIcons()
				ax.ColumnHeaderIcons=ilGr
				ax.Icons=ilGr
				for i = 1 to 8 do ax.ColumnHeaders[i].icon=i
				--ax.SmallIcons=true
				)

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
				
				)

		-- tidy up	
			ax.refresh()
			
		-- set object manager off
			rdoUse.state=1
			showObjectManager false

		)

	
	on rcAxObj open do
		(
		rcm=true
		format "rcm=%\n" rcm
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

	fn checkAXItems state=
		(
		for i = 1 to ax.listitems.count do
			(
			li=ax.listitems[i]
			if li.selected then li.checked = state
			)
		)

	--on btnCheck changed state do checkAXItems state

	on ax ItemClick Item do
		(
			if rcm == false then print Item.index
		 )

	on ax MouseDown Button Shift x y do
		(
		if ax.listitems.count > 0 then -- rcm == false AND
			(
			if button==2 then popupMenu rcAxObj pos:[x+16,y+24] rollout:roAnim align:#align_topleft
			--format "%, %, %, %, %\n" "MouseDown" Button Shift x y
			local yOffset = -((ax.listitems[1].top-503)/ax.listitems[1].height) as integer
			local item=((y-20)/14)+1
			--format "Clicked item: %\n" (yOffset+item)
			)
		)
		
	--------------------------------------------------------------------------------------
	-- Other Stuff
	--------------------------------------------------------------------------------------

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


	local useObjectManager=true
	
	fn showObjectManager state=
		(
		local controls
		if aeBridge!=undefined then controls = aeBridge.controls[2].rollouts[2].controls
		else controls = roAnim.controls
		
		format ">>%\n>>%\n" (controls as string) aeBridge
		
		local ctrlList1=	[3,11]
		local ctrlList2=	[12,controls.count]
		
		local w
		
		if aeBridge!=undefined then w=aeBridge.width
		else w=420
		
		local h=controls[ctrlList1[1]].height+8
		local lastControl=controls[controls.count]
		
		local x=0, y=0
		if NOT state AND useObjectManager==true then (x=w;y=-h;useObjectManager=false)
		else if state AND useObjectManager==false then (x=-w;y=h;useObjectManager=true)
		
		for i = ctrlList1[1] to ctrlList1[2] do controls[i as integer].pos+=[x,0]
		for i = ctrlList2[1] to ctrlList2[2] do controls[i as integer].pos+=[0,y]
		
		--update root rollout
		if aeBridge!=undefined then
			(
			aeBridge.controls[2].rollouts[2].height=lastControl.pos[2]+28
			aeBridge.flashClick 2
			)
		)

	on rdoUse changed state do showObjectManager (state==2)
	
	on btnExport pressed do exportObjects()

)
if aeBridge==undefined then createdialog roAnim roAnim.width roAnim.height 10 10
/*
roAnim.ax.listitems[1].left
roAnim.ax.columnheaders[3].width
roAnim.ax.DropHighlight
*/