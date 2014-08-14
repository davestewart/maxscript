fileIn "icoArr.ms"
fileIn "classArr.ms"
fileIn "superclassArr.ms"

/*
rename to:

classDataArr
classIcoArr
superclassDataArr
superclassIcoArr

*/

if  (getCurrentSelection()).count==0 then
	(
	if (NOT isvalidnode b) then
		(
		b=box()
		addModifier b (Bend ())
		addModifier b (Taper ())
		addModifier b (UVWMap ())
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
	/*
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
		menuItem mi_Val					"Copy Value Only"
		seperator sep1
		menuItem mi_Copy				"Copy controller"
		menuItem mi_Wire				"Wire controller"
		menuItem mi_Instance			"Instance controller"
		seperator sep2
		menuItem mi_SoftInstance		"Soft Instance controller..."
		
		on mi_Val picked do				test.doCopy "val"
		on mi_Copy picked do			test.doCopy "cop"
		on mi_Wire picked do			test.doCopy "wir"
		on mi_Instance picked do		test.doCopy "ins"
		on mi_SoftInstance picked do	test.doCopy "sof"
		)	


	rcMenu nodeMenu
		( 
		--local clone_node, is_cut		
		menuItem mi_Copy				"Copy"
		seperator sep1
		menuItem mi_PasteVal			"Paste Value Only"
		menuItem mi_PasteCopy			"Paste Copy"
		menuItem mi_PasteWire			"Paste Wire"
		menuItem mi_PasteInstance		"Paste Instance"
		seperator sep2
		menuItem mi_PasteSoftInstance	"Paste Soft Instance"
		seperator sep3
		subMenu "Controller..."
			( 
			menuItem mi_CtrlDlg				"Controller Dialog..."
			menuItem mi_TrackviewSelect		"Select in trackview..."
			menuItem mi_AssignController	"Assign..."
			)
		seperator sep4
		subMenu "Tree..."
			( 
			menuItem mi_SelAllDown			"Select all downstream"
			seperator sep5
			menuItem mi_Options				"AutoExpand settings"
			)
		
		on mi_CtrlDlg picked do			test.ctrlDiag()

		)	
--------------------------------------------------------


	rollout test "The Phat Controller" width:512 height:584
		(

---------------------------------------------------------------------------------------------------------------------------
-- declarations
---------------------------------------------------------------------------------------------------------------------------

	-- objects
		local obj1, obj2

	-- utility
		local obj, replaceAll
		
	-- icon stuff
		local classArr=#(), icoArr=#()
		
	-- treeview
		local initTreeView, initImageList
		local recurseSubAnims
		local getSAStringFromNode, getSAFromNode, getIconIndex

	-- interface
		local nTV=2,dWidth=600,dHeight=600
		local collapseNodeArr=#("gizmo","center","position","rotation","scale")

	-- colours
		local colOver=	(color 200 200 200)
		local colOff=	(color 255 255 255)
		local colOK=	(color 200 255 200)
		local colErr=	(color 200 200 255)
		
	-- drag/drop
		local curTV, lastTV, mousePick, selNode, curNode, lastNode, dropNode
		local okToCopy, nodePropArr=#()
		

---------------------------------------------------------------------------------------------------------------------------
-- user interface 
---------------------------------------------------------------------------------------------------------------------------

		ActiveXControl tv1 "MSComctlLib.TreeCtrl" pos:[5,5] width:(dWidth/nTV) height:(dHeight-50)
		ActiveXControl tv2 "MSComctlLib.TreeCtrl" pos:[((dWidth/nTV)+10),5] width:(dWidth/nTV) height:(dHeight-50)
		activeXControl axImgList "{2C247F23-8591-11D1-B16A-00C0F0283628}" height:0 width:0 pos:[-50,-50]
		--activeXControl axImgList "MSComctlLib.ImageListCtrl.2" width:1 height:1 pos:[-50,-50]

		label lbl1 "Path" pos:[5,(dHeight-40)] width:100 height:15
		label lbl2 "" pos:[105,(dHeight-40)] width:100 height:15
		label lbl3 "" pos:[205,(dHeight-40)] width:100 height:15
		label lbl4 "" pos:[305,(dHeight-40)] width:100 height:15
		label lbl5 "" pos:[405,(dHeight-40)] width:100 height:15

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

		function ctrlDiag = try(displayControlDialog (getSAFromNode selNode).controller "")catch()

---------------------------------------------------------------------------------------------------------------------------
-- docopy functions
---------------------------------------------------------------------------------------------------------------------------


	fn doCopy type =
		(
		local src, trg
		src= getSAFromNode dragNode
		trg= getSAFromNode dropNode
		
		format "% | %\n" src.object trg.object

		undo "Property Copy" on
			(
			case type of
				(
				"val":	(
				-- values only
					trg.value = src.value
					)
				"cop":	(
				-- copy
					if (NOT src.isAnimated OR src.controller==undefined) then trg.value = src.value
					else trg.controller = copy src.controller
					)
				"ins":	(
				-- instance
					if src.controller==undefined then src.controller=bezier_float()
					trg.controller = src.controller
					)
				"wir":	(
				-- wire
					--sa1=$sphere01[4][2]
					--sa2=$teapot01[4][1]
					local srcName=(filterstring (src as string) ":")[2]
					local trgName=(filterstring (trg as string) ":")[2]
	
					paramWire.connect2Way src trg trgName srcName
					)
				"sof":	(
				-- soft instance
					-- popup new window with checkboxes
					-- makes selection
					-- instance recursively
					)
				default:messagebox "Unknown argument for doCopy()"
				)
		--update icon
			dragNode.image=getIconIndex src
			dropNode.image=getIconIndex trg
			)
		)

---------------------------------------------------------------------------------------------------------------------------
-- treeview functions
---------------------------------------------------------------------------------------------------------------------------



		fn initImageList=
			(
			--messageBox "initImageList()"
			-- set variables
				local icoRel ="icons\\ico\\"
				local j=0
				local iconStr=""
			-- start the loop
				for i = 1 to libraryClassArr.count do
					(
					try (
					-- get and load the bitmap file
						local icoFile =icoRel + libraryIcoArr[i]
						axImgList.listimages.Add (j+=1) "" (LoadPicture icoFile)

					-- update local array with classname
						append classArr libraryClassArr[i]

					-- update ebug info
						iconStr+=(pad j 3) +" | "+ libraryClassArr[i] +" | "+ libraryIcoArr[i] +"\n"
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
			local saStr="$"+tvNode.root.key
			local saArr=filterstring tvNode.tag ","
			for n in saArr do saStr+="["+n as string+"]"
			return saStr
		)

	fn getSAFromNode tvNode =
		(
		-- set up variables
			local saStr="$"+tvNode.root.key
			local saArr=filterstring tvNode.tag ","
			for n in saArr do saStr+="["+n as string+"]"
			return (execute(saStr))
		)


	fn getIconIndex sa =
		(
		local iconIndex, lastIcon, class
		lastIcon = axImgList.ListImages.Count
		iconIndex=lastIcon 
		try	(
			class=classof sa.object as string
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

				-- START MAIN NODE PROPERTY MAIN CODE ----------------------------------------------
					-- text
						local nodeText = (getSubAnimName sa i) as string
						nodeText=replaceAll nodeText "_" " "
						newNode.text = nodeText

					-- expanded
						if d!=2 then newNode.expanded=true
						if findItem collapseNodeArr nodeText != 0 then newNode.expanded=false
						
					-- tag
						-- important to set this before creating the image!
						-- as the tag holds the depth, and therefore, path info
						-- add the parent's tag and this depth...
						newNode.tag=tvNode.tag as string + i as string +","


					-- icon
						--local nodeIcon = getIconIndex newNode
						local nodeIcon = getIconIndex (getSubAnim sa i)
						newNode.image=nodeIcon 
					
				-- END NODE PROPERTY MAIN CODE ------------------------------------------------

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
			newNode.key=replaceAll obj.name " " "_"

			local class = (classof obj.baseobject) as string
			local iconIndex=(findItem classArr class)
			newNode.Image=iconIndex
			newNode.expanded=true

		-- do the rest
			recurseSubAnims obj tv newNode 0

		-- set up interface stuff

		-- Time it...
			timeIt 1
			--tv1.MouseIcon = (LoadPicture "E:\\2_Current_Jobs\\softinstance\\treeview\\icons\\ico\\AtmosApp_01.ico")

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
			
			try(
			-- get objects
				obj1 = objects[1]
				try (obj2 = objects[2])
				catch (obj2=obj1)
	
			-- POPULATE TREEVIEWS
				populateTreeView tv1 obj1
				populateTreeView tv2 obj2
				)
			catch()

		-- SET UP INTERFACE FOR CLICKS
			lastNode = curNode = selNode = tv1.selectedItem = tv1.nodes[1]
			--curNode = tv1.nodes[1]

			format "selitem is %\n" tv1.selectedItem.index


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


	on btnNew1 pressed do populateTreeView tv1 (obj1=pickObject())
	on btnUpdate1 pressed do populateTreeView tv1 obj1

	on btnNew2 pressed do populateTreeView tv2 (obj2=pickObject())
	on btnUpdate2 pressed do populateTreeView tv2 obj2




---------------------------------------------------------------------------------------------------------------------------
-- node control functions
---------------------------------------------------------------------------------------------------------------------------



	fn tvGetHitNode tv = 
		(
		local p = getCursorPos tv
		tv.hitTest (p.x*15) (p.y*15)
		)

	fn getMousePick tv=
		(
		mousePick=tvGetHitNode tv
		if mousePick!= undefined then lbl2.text=mousePick.text

		else lbl2.text=mousePick as string
		)
		
---------------------------------------------------------------------------------------------------------------------------
-- node utility functions
---------------------------------------------------------------------------------------------------------------------------


	-- list all downstream...
		fn getDownstreamNodes tv tvNode =
			(
			local nodeArr=#()
			for i = tvNode.index+1 to tvNode.next.index-1 do append nodeArr tv.nodes[i]
			return nodeArr
			)
		
	
	-- get all children
	
		fn getNodeChildren tvNode =
			(
			local nodeArr=#()
			local c = tvNode.child
			for i = 1 to tvNode.children do
				(
				append nodeArr c
				c=c.next
				)
			if debug==true then (
				format "% | " nodeArr.count
				for n in nodeArr do format "%, " n.text
				format "\n"
				)

			return nodeArr
			)


---------------------------------------------------------------------------------------------------------------------------
-- node / click/drag functions
---------------------------------------------------------------------------------------------------------------------------


		fn tvNodeClick tv1 tvNode =
			(
			)
	

		-------------
		-- mouse move
		-------------
		fn tvMouseMove tv btn shift x y =
			(
			)



		-------------
		-- mouse down
		-------------
		fn tvMouseDown tv btn shift x y =
			(
			getMousePick tv
			if mousePick != undefined then
				(
				selNode.backColor=colOff
				selNode=curNode=mousePick
				tv.selectedItem=selNode
				lbl3.text=selNode.text
				)
			)


		------------
		-- mouse up
		------------
		fn tvMouseUp tv btn shift x y =
			(
			)


		-------------
		-- start drag
		-------------
			fn tvStartDrag tv data AllowedEffects=
				(
				nodePropArr=getNodeChildren selNode
				for i = 1 to nodePropArr.count do nodePropArr[i] = nodePropArr[i].text
				)
	
		------------
		-- drag over
		------------
			fn tvDragOver tv data Effect Button Shift x y State =
				(
				getMousePick tv
				if mousePick!=undefined then
					(
				--get this and last nodes
					lastNode=curNode
					curNode=mousePick

				-- update feedback
					lbl3.text = lastNode.text
					lbl4.text = curNode.text
					

				-- if different, process!
					if curNode.index!=lastNode.index then
						(
						lbl5.text="PROCESSING!"
					-- run code
						try	(
						-- update interface
							--lastNode.bold=false
							--curNode.bold=true

							lastNode.backColor=colOff
							curNode.backColor=colOver

						-- START EXECUTABLE CODE -----------------------------------
							try(
							-- check for common subanims
								local childNodeArr = getNodeChildren curNode
								for n in childNodeArr do
									(
									if finditem nodePropArr n.text != 0 then
										(
										n.bold=true
										if curNode.expanded==false then curNode.expanded=true
										)
									)
								)
							catch()
							)
						-- END EXECUTABLE CODE -------------------------------------
						catch()
						)
				-- udpate feedback
					else lbl5.text=""
					)
				)

		-------
		-- drop
		-------
			fn tvDragDrop tv data Effect btn key x y =
				(
				curNode.backColor=colOff
				)


		-----------
		-- complete
		-----------
			fn tvCompleteDrag tv Effect =
				(
				curNode.backColor=colOff
				selNode.backColor=colOver
				)

 
---------------------------------------------------------------------------------------------------------------------------
-- mouse handlers
---------------------------------------------------------------------------------------------------------------------------

		on tv1 NodeClick tvNode do 									tvNodeClick tv1 tvNode
		--on tv2 NodeClick tvNode do 									tvNodeClick tv2 tvNode

		on tv1 MouseDown btn shift x y do 							tvMouseDown tv1 btn shift x y
		on tv2 MouseDown btn shift x y do 							tvMouseDown tv2 btn shift x y

		on tv1 MouseMove btn shift x y do 							tvMouseMove tv1 btn shift x y
		on tv2 MouseMove btn shift x y do 							tvMouseMove tv2 btn shift x y

		--on tv1 MouseUp btn shift x y do 							tvMouseUp tv1 btn shift x y
		--on tv2 MouseUp btn shift x y do 							tvMouseUp tv2 btn shift x y

		on tv1 OLEStartDrag data AllowedEffects do 						tvStartDrag tv1 data AllowedEffects
		on tv2 OLEStartDrag data AllowedEffects do 						tvStartDrag tv2 data AllowedEffects

		on tv1 OLEDragOver data Effect Button Shift x y State do 	tvDragOver tv1 data Effect Button Shift x y State
		on tv2 OLEDragOver data Effect Button Shift x y State do 	tvDragOver tv2 data Effect Button Shift x y State

		--on tv1 OLEDragDrop data Effect btn key x y do 				tvDragDrop tv1 data Effect btn key x y
		--on tv2 OLEDragDrop data Effect btn key x y do 				tvDragDrop tv2 data Effect btn key x y

		on tv1 OLECompleteDrag effect do 							tvCompleteDrag tv1 effect
		on tv2 OLECompleteDrag effect do 							tvCompleteDrag tv2 effect

	)

createdialog test 615 600 50 50 style:#(#style_minimizebox,#style_titlebar, #style_border, #style_sysmenu,#style_resizing)
