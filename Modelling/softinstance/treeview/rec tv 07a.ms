fileIn "bmpArr.ms"
fileIn "classArr.ms"

if  (getCurrentSelection()).count==0 then
	(
	if (NOT isvalidnode b) then
		(
		b=box()
		addModifier b (Bend ())
	/*
		addModifier b (Taper ())
		addModifier b (Twist ())
		addModifier b (Noisemodifier ())
		addModifier b (Stretch ())
		addModifier b (Squeeze ())
		addModifier b (Push ())
		addModifier b (Relax ())
		addModifier b (Ripple ())
		addModifier b (Wave ())
		addModifier b (Skew ())
		addModifier b (SliceModifier ())
		addModifier b (Spherify ())
		addModifier b (Affect_Region ())
		addModifier b (Lattice ())
		addModifier b (Mirror ())
		addModifier b (Displace ())
		addModifier b (XForm ())
		addModifier b (Preserve ())
		b.material = meditmaterials[1]
	*/
		select b
		)
	)
if test!=undefined then destroydialog test
global doCopy
	
--------------------------------------------------------


	rcMenu copyMenu
		( 
		--local clone_node, is_cut		
		menuItem mi_Copy				"Copy"
		seperator sep1
		menuItem mi_Instance			"Instance"
		seperator sep2
		menuItem mi_SoftInstance		"Soft Instance"
		
		on mi_Copy picked do			test.doCopy 0
		on mi_Instance picked do		test.doCopy 1
		on mi_SoftInstance picked do	test.doCopy 2
		)	


	rcMenu nodeMenu
		( 
		--local clone_node, is_cut		
		menuItem mi_SelNone			"Select none"
		menuItem mi_SelAllDown			"Select all downstream"
		seperator sep1
		menuItem mi_Instance		"Show in trackview"
		menuItem mi_SoftInstanceAll	"Assign Controller"
		seperator sep2
		menuItem mi_SoftInstanceSome	"AutoExpand settings"
		)	
--------------------------------------------------------


	rollout test "Copy Properties" width:512 height:584
		(

---------------------------------------------------------------------------------------------------------------------------
-- declarations
---------------------------------------------------------------------------------------------------------------------------

	-- utility
		local obj, replaceAll
		
	-- icon stuff
		local classArr=#(), bmpArr=#()
		
	-- treeview
		local initTreeView, initImageList
		local recurseSubAnims
		local getSAStringFromNode, getSAFromNode 

	-- interface
		local prevNode, curNode
		local nTV=2,dWidth=600,dHeight=600
		
	-- drag/drop
		local dragNode, dropNode, lastNode
		local okToCopy
		

---------------------------------------------------------------------------------------------------------------------------
-- user interface 
---------------------------------------------------------------------------------------------------------------------------

		ActiveXControl tv1 "MSComctlLib.TreeCtrl" pos:[5,5] width:(dWidth/nTV) height:(dHeight-50)
		ActiveXControl tv2 "MSComctlLib.TreeCtrl" pos:[((dWidth/nTV)+10),5] width:(dWidth/nTV) height:(dHeight-50)
		activeXControl axImgList "{2C247F23-8591-11D1-B16A-00C0F0283628}" height:0 width:0 pos:[-50,-50]
		--activeXControl axImgList "MSComctlLib.ImageListCtrl.2" width:1 height:1 pos:[-50,-50]

		label lbl1 "Path" pos:[5,(dHeight-40)] width:400 height:15
		button btnNew1 "New Object" pos:[5,(dHeight-20)] width:100 height:16
		button btnUpdate1 "Update" pos:[105,(dHeight-20)] width:100 height:16

		button btnNew2 "New Object" pos:[((dWidth/nTV)+10),(dHeight-20)] width:100 height:16
		button btnUpdate2 "Update" pos:[((dWidth/nTV)+110),(dHeight-20)] width:100 height:16



---------------------------------------------------------------------------------------------------------------------------
-- utility functions
---------------------------------------------------------------------------------------------------------------------------

		function pad num padLength =
			(
			num=num as string
			while num.count < padLength do num = ("0"+num)
			return num
			)
	

		function replaceAll str outStr inStr =
			(
			-- str the original string
			-- the string/character to replace
			-- the replacement string/character
			
			origStr=str
			while ((n=findstring str outStr) != undefined) do str = replace str n inStr.count inStr
			if str != undefined then return str
			else return origStr
			)


		function reverseArray inArr =
			(
			local outArr = #()
			while inArr.count > 0 do
				(
				append outArr inArr[inArr.count]
				deleteItem inArr inArr.count
				)
			return outArr
			)


		local t1=0,t2=0
		function timeIt type =
			(
			if type==0 then t1=timeStamp()
			else
				(
				t2=timestamp()
				local t=(t2-t1)/1000 as float
				format "Processing took % seconds\n" t
				)
			)


---------------------------------------------------------------------------------------------------------------------------
-- docopy functions
---------------------------------------------------------------------------------------------------------------------------


	fn doCopy type =
		(
		
		local src, trg
		src= getSAFromNode dragNode
		trg= getSAFromNode dropNode
		
		format "% | %\n" src.object trg.object

		case type of
			(
			0:	(	-- copy
				messagebox "Doing Copy!"
				trg.controller = copy src.controller
				)
			1:	(	-- instance
				messagebox "Doing Instance!"
				trg.controller = src.controller
				)
			2:	(	-- soft instance
				-- popup new window with checkboxes
				-- makes selection
				-- instance recursively
				)
			default:messagebox "No result"
			)
		)
--						local dragNodeClass = classof((getSAFromNode dragNode).object)
--						local dropNodeClass = classof((getSAFromNode dropNode).object)

---------------------------------------------------------------------------------------------------------------------------
-- treeview functions
---------------------------------------------------------------------------------------------------------------------------



		fn initImageList=
			(
			--messageBox "initImageList()"
			-- set variables
				local bmpRel ="icons\\final\\"
				local j=0
				local iconStr=""
			-- start the loop
				for i = 1 to libraryClassArr.count do
					(
					try (
					-- get and load the bitmap file
						local bmpFile =bmpRel + libraryBmpArr[i]
						axImgList.listimages.Add (j+=1) "" (LoadPicture bmpFile)

					-- update local array with classname
						append classArr libraryClassArr[i]

					-- update ebug info
						iconStr+=(pad j 3) +" | "+ libraryClassArr[i] +" | "+ libraryBmpArr[i] +"\n"
						)
					catch(j-=1)
					)
			-- write debug info
				--format "%" iconStr to:(win=newScript())
				--format "libraryClassArr.count:%\nj:%\n" libraryClassArr.count j to:win
			)


		fn initTreeView tv singleSel=
			(
			-- linestyles
				tv.lineStyle = #tvwRootLines
				tv.lineStyle = #tvwTreeLines
				--tv.Checkboxes= true
				tv.BorderStyle=#ccFixedSingle
				tv.Appearance=#ccFlat
				tv.LabelEdit=#tvwManual
				tv.style = #tvwTreelinesPlusMinusText
				tv.style = #tvwTreelinesPlusMinusPictureText
				tv.SingleSel=false--singleSel
				tv.PathSeparator = "\\"
				tv.indentation=0
				tv.fullrowselect=false
				tv.font="Tahoma"
				tv.font.size=7

			-- associate imagelist with treeview
			--format ">>>>>>>%\n" imageList.count
				--tv.ImageList=axImgList

			-- dragndrop
				tv.oleDragMode = #ccOLEDragAutomatic
				tv.oleDropMode = #ccOLEDropManual

			)



	fn getSAStringFromNode tvNode =
		(
		-- set up variables
			local saStr="$"
			local saArr=filterstring tvNode.tag ","
			for n in saArr do saStr+="["+n as string+"]"
			return saStr
		)

	fn getSAFromNode tvNode =
		(
		-- set up variables
			local saStr="$"
			local saArr=filterstring tvNode.tag ","
			for n in saArr do saStr+="["+n as string+"]"
			return (execute(saStr))
		)

	

	fn getSAPropFromNode tvNode prop=
		(
		-- set up variables
			local saStr="$"
			local obj, saIndex

			local saArr=filterstring tvNode.tag ","
			for i = 1 to saArr.count-1 do saStr+="["+n as string+"]"

			obj = execute(saStr)
			saIndex = saArr[saArr.count-1]

			return "Unfinished function"
		)

	fn getIconIndex sa i=
		(
		local iconIndex, lastIcon, class
		lastIcon = axImgList.ListImages.Count
		iconIndex=lastIcon 
		try	(
			class=(classof (getSubAnim sa i).object) as string
			--format "%\n" sa as string
			iconIndex= findItem classArr class
			if iconIndex==0 then iconIndex=lastIcon 
			return iconIndex
			)
		catch(
			return iconIndex
			)
		)


-- main recursive function

		fn recurseSubAnims sa tv tvNode d=
			(
			d+=1
			for i = 1 to sa.numSubs do
				(

			 -- flag if not visibility, transform, modified object or material
				local oktoBuild=true
				if d==1 AND (i<2 OR i>5) then oktobuild=false

			-- build the nodes
				if oktobuild == true then
					(
				-- build the node
					newNode = tv.nodes.add tvNode.index 4 ""

				-- update node properties
					-- text
						local nodeText = (getSubAnimName sa i) as string
						nodeText=replaceAll nodeText "_" " "
						newNode.text = nodeText

					-- expanded
						if d!=2 then newNode.expanded=true
						
					-- tag
						-- important to set this before creating the image!
						-- as the tag holds the depth, and therefore, path info
						--newNode.tag=i as string
						newNode.tag=tvNode.tag as string + i as string +","


					-- icon
						--local nodeIcon = getIconIndex newNode
						local nodeIcon = getIconIndex sa i
						newNode.image=nodeIcon 
					
					-- reupdate text
						--newNode.text = nodeText + " ("+classArr[nodeIcon]+")"

				-- do children
					recurseSubAnims sa[i] tv newNode d
					)
				)
			)


/*
	.Add
		Relative:undefined 
		Relationship:undefined 
		Key:undefined 
		Text:undefined 
		Image:undefined 
		SelectedImage:undefined
*/


	fn populateTreeView tv obj =
		(
		-- Time it...
			timeIt 0
		-- clear
			tv.nodes.clear()
		
		-- get node and set up tv
			local newNode = tv.nodes.add()
			newNode.text = obj.name as string
			newNode.tag=""
			local class = (classof obj.baseobject) as string
			local iconIndex=(findItem classArr class)
			newNode.Image=iconIndex
			newNode.expanded=true

		-- do the rest
			recurseSubAnims obj tv newNode 0

		-- set up interface stuff
			tv.selectedItem=tv.nodes[1]
			prevNode=tv.selectedItem
			curNode=tv.selectedItem
			lastNode=tv1.nodes[0]

		-- Time it...
			timeIt 1
			--tv1.MouseIcon = (LoadPicture "E:\\2_Current_Jobs\\softinstance\\treeview\\icons\\final\\AtmosApp_01.BMP")

		)



---------------------------------------------------------------------------------------------------------------------------
-- rollout handlers
---------------------------------------------------------------------------------------------------------------------------


	
	on test open do
		(

		-- Time it...
			timeIt 0
	
		-- DO ICONS
			--messagebox "Calling initImageList()"
			initImageList()
			--messagebox "tv1.ImageList=axImgList"
			tv1.ImageList=axImgList
			tv2.ImageList=axImgList
	
		-- STYLE TREE
			initTreeView tv1 true
			initTreeView tv2 true
	
		-- POPULATE TREEVIEWS
			populateTreeView tv1 objects[1]
			populateTreeView tv2 objects[2]


		-- Time it...
			timeIt 1
	-- END
		)

	on test resized size do
		(
		tv1.size.x = (size.x-15)/2
		tv2.size.x = (size.x-15)/2

		tv1.size.y = size.y - 50
		tv2.size.y = size.y - 50

		tv2.pos.x  = ((size.x-15)/2)+10


		lbl1.pos=		[5,(size.y-40)]
		btnNew1.pos=	[5,(size.y-20)]
		btnUpdate1.pos=	[105,(size.y-20)]


		btnNew2.pos=	[((size.x/nTV)+5),(size.y-20)]
		btnUpdate2.pos=	[((size.x/nTV)+105),(size.y-20)]
		)


	on btnNew1 pressed do populateTreeView tv1 (pickObject())
	on btnUpdate1 pressed do populateTreeView tv1 $

	on btnNew2 pressed do populateTreeView tv2 (pickObject())
	on btnUpdate2 pressed do populateTreeView tv2 $


---------------------------------------------------------------------------------------------------------------------------
-- node / control handlers
---------------------------------------------------------------------------------------------------------------------------

	on tv1 NodeClick tvNode do
		(
		-- interface
			-- update variables
				prevNode=curNode
				curNode = tv1.SelectedItem
			
			-- color/text change
				prevNode.bold=false
				curNode.bold=true
/*
				curNode.backcolor = (color 204 238 85)
				prevNode.backcolor= (color 255 255 255)
*/
			-- update the label
				lbl1.text = tvNode.fullpath

		-- code
			-- print node / maxobject properties
				--format "%\n" tvNode.tag
				local saStr = getSAStringFromNode tvNode
				local sa = getSAFromNode tvNode
				try(
					--clearListener()
					format "\n-- object --------------------------\n"
					format "  %\n" (exprformaxobject sa)
					format "\n-- subanim -------------------------\n"
					format "  sa string :      %\n" saStr
					format "  sa subanim:      %\n" sa
					format "  sa object:       %\n" sa.object
					format "  sa class:        %\n" (classof sa.object)
					format "  sa superclass:   %\n" (superclassof sa.object)
					format "\n-- controller  ---------------------\n"
					format "  ctrl             %\n" sa.controller
					format "  ctrl class:      %\n" (classof sa.controller)
					format "  ctrl superclass: %\n\n" (superclassof sa.controller)
					)
				catch()
/*			
*/		
		)



---------------------------------------------------------------------------------------------------------------------------
-- dragging functions
---------------------------------------------------------------------------------------------------------------------------
/*
*/


	-- declarations


		fn tvGetHitNode tv= 
			(
			local p = getCursorPos tv
			tv.hitTest (p.x*15) (p.y*15)
			)



	-- right-click menu stuff
		fn tvMouseUp tv MouseUp btn shift x y =
			(
			enableAccelerators = false			
			local selNode = tvGetHitNode tv
			if btn == 2 and selNode != undefined do
				(
				popupmenu nodeMenu pop:[x, y] rollout:test
				)
			)

	-- drag stuff
		-- start drag
			fn tvOLEStartDrag tv data effects =
				(
				dragNode = tvGetHitNode tv
				if dragNode == undefined or dragNode.parent == undefined then return()
				--mouseIcon = tv.mouseIcon
				--tv.mouseIcon = loadPicture (iconDir + "tvSet.ico")--ilTv.listImages[drag_node.image].picture
				--dragNode.createDragImage()
				)
	
		-- drag over
			fn tvOLEDragOver tv data Effect Button Shift x y State =
				(
				try
					(
					try lastNode.backcolor = (color 255 255 255)
					catch()
					dropNode = tvGetHitNode tv
					if dropNode != undefined then
						(
						--				local saStr = getSAStringFromNode tvNode
						--				format "  sa class:        %\n" (classof sa.object)

						local dragNodeClass = classof((getSAFromNode dragNode).object)
						local dropNodeClass = classof((getSAFromNode dropNode).object)
						--format "%\n" dragNodeClass
						if dragNodeClass == dropNodeClass then
							(
							dropNode.backcolor = (color 128 200 255)
							lastNode=dropNode
							okToCopy=true
							)
						else okToCopy=false
						)
					)
				catch()
				)

		-- drop

			fn tvOLEDragDrop tv data Effect btn key x y =
				(
				local cPos=mouse.screenpos
				if dropNode != undefined then popupmenu copyMenu pop:[cPos.x, (cPos.y-30)] rollout:test
				)
	

---------------------------------------------------------------------------------------------------------------------------
-- dragging handlers
---------------------------------------------------------------------------------------------------------------------------

		on tv1 MouseUp btn shift x y do 							tvMouseUp tv1 MouseUp btn shift x y
		on tv2 MouseUp btn shift x y do 							tvMouseUp tv2 MouseUp btn shift x y

		on tv1 OLEStartDrag data effects do 						tvOLEStartDrag tv1 data effects
		on tv2 OLEStartDrag data effects do 						tvOLEStartDrag tv2 data effects

		on tv1 OLEDragOver data Effect Button Shift x y State do 	tvOLEDragOver tv1 data Effect Button Shift x y State
		on tv2 OLEDragOver data Effect Button Shift x y State do 	tvOLEDragOver tv2 data Effect Button Shift x y State

		on tv1 OLEDragDrop data Effect btn key x y do 				tvOLEDragDrop tv1 data Effect btn key x y
		on tv2 OLEDragDrop data Effect btn key x y do 				tvOLEDragDrop tv2 data Effect btn key x y


	)

createdialog test 615 600 50 50 style:#(#style_minimizebox,#style_titlebar, #style_border, #style_sysmenu,#style_resizing)
