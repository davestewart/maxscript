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
	/*
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
		menuItem mi_Val					"Copy value only"
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
		menuItem mi_PasteVal			"Paste current value Only"
		menuItem mi_PasteCopy			"Paste copy"
		menuItem mi_PasteWire			"Paste wire"
		menuItem mi_PasteInstance		"Paste instance"
		seperator sep2
		menuItem mi_PasteSoftInstance	"Paste soft instance"
		seperator sep3
		subMenu "Controller..."
		( 
			menuItem mi_CtrlDlg				"Controller dialog..."
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

	-- expanding branches
		local collapseNodeArr=#("gizmo","center","position","rotation","scale")
		local expandModifiers=true

	-- colours
		local colOver=		(color 200 200 200)
		local colOff=		(color 255 255 255)
		local colNodeOK= 	(color 92 192 104)
		local colChildOK= 	(color 192 232 200)
		local colChildOK= 	(color 192 139 92)

		local colNodeOK= 	(color 165 239 209)
		local colChildOK= 	(color 144 218 166)


		local colErr=		(color 200 200 255)
		
	-- drag/drop
		local curTV, lastTV, mousePick, selNode, curNode, lastNode, dropNode
		local okToCopy, nodePropArr=#(), nodeChildArr=#()
		local lastNodeCollapsed=false
		local nodeBoldStack=#(),nodeHighlightStack=#(),nodeExpandedStack=#()


---------------------------------------------------------------------------------------------------------------------------
-- user interface 
---------------------------------------------------------------------------------------------------------------------------

		ActiveXControl tv2 "MSComctlLib.TreeCtrl" pos:[((dWidth/nTV)+10),5] width:(dWidth/nTV) height:(dHeight-50) visible:true
		ActiveXControl tv1 "MSComctlLib.TreeCtrl" pos:[5,5] width:(dWidth/nTV) height:(dHeight-50) visible:true
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
				"val":(
				-- values only
					trg.value = src.value
				)
				"cop":(
				-- copy
					if (NOT src.isAnimated OR src.controller==undefined) then trg.value = src.value
					else trg.controller = copy src.controller
				)
				"ins":(
				-- instance
					if src.controller==undefined then src.controller=bezier_float()
					trg.controller = src.controller
				)
				"wir":(
				-- wire
					--sa1=$sphere01[4][2]
					--sa2=$teapot01[4][1]
					local srcName=(filterstring (src as string) ":")[2]
					local trgName=(filterstring (trg as string) ":")[2]
	
					paramWire.connect2Way src trg trgName srcName
				)
				"sof":(
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

					-- update debug info
						iconStr+=(pad j 3) +" | "+ libraryClassArr[i] +" | "+ libraryIcoArr[i] +"\n"
					)
					catch(j-=1)
				)
			-- write debug info
				--format "%" iconStr to:(win=newScript())
				--format "libraryClassArr.count:%\nj:%\n" libraryClassArr.count j to:win
		)


		fn initTreeView tv =
		(
			-- styling
				tv.lineStyle = #tvwTreeLines
				tv.style = #tvwTreelinesPlusMinusPictureText
				tv.BorderStyle=#ccFixedSingle
 				tv.Appearance=#ccFlat

			-- icons
				tv.ImageList=axImgList

			-- functionality
				tv.PathSeparator = "\\"
				tv.LabelEdit=#tvwManual
				tv.Checkboxes=false
				tv.indentation=0
				tv.SingleSel=false
				tv.FullRowSelect=true

			-- font
				tv.font="Tahoma"
				tv.font.size=7

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
		try(
		-- get class of object
			class=classof sa.object as string
			iconIndex= findItem classArr class
			if iconIndex!=0 then
			(
				format "Found icon for % ...\n" class
				return iconIndex
			)
			else
			(
			-- split the saSubAnim and try to extract the object
			-- then compare it to one last array
			-- if it's not in there, then it's just a property
			-- so assign the subanim icon
			-- get class of controller
				try(
					class= (filterstring (sa as string) ":")[2]
					iconIndex= findItem classArr class
					if iconIndex!=0 then 
					(
						format "Found icon for % ...\n" class
						return iconIndex
					)
					else
					(
						--bugger...
						format "Icon NOT found for $ ...\n" class
						return lastIcon
					)
				)
				catch
				(
					format "FAILIED on second icon pass\n"
					return lastIcon
				)
			)
		)
		catch(
			format "FAILED on first icon pass\n"
			return lastIcon
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
						local expand = false

						if d<3 then expand=true
						
						/*
						if expandModifiers==true then
						(
							if(
								try(superclassof sa.object == modifier)
								catch(false)
							)
							then expand=true
						)
						*/
						else if findItem collapseNodeArr nodeText != 0 then expand=false
						newNode.expanded=expand


					-- color
						if sa[i].numSubs > 0 then
						(
							local col = 255 - (d+1)*3
							newNode.backColor = (color col col col)
						)


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
			initImageList()
	
		-- STYLE TREE
			initTreeView tv1
			initTreeView tv2
			
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
			tv1.selectedItem=	tv1.nodes[1]
			nodeBoldStack=		#(tv1.nodes[1])

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

	
	fn boldMousePick tv =
	(
		if mousePick != undefined then
		(
		-- add the new node and update interface
			curNode=mousePick
			curNode.bold=true
			lbl3.text=curNode.text
			insertItem curNode nodeBoldStack 1
		)		
	)



	fn unboldMousePicks =
	(
		try(
		-- update any old nodes and delete from array
			if nodeBoldStack.count > 1 then
			(
				for i = nodeBoldStack.count to 2 by -1 do
				(
					nodeBoldStack[i].bold=false
					deleteItem nodeBoldStack i
				)
			)
		)
		catch()
	)

	fn highlightNode tvNode col=
	(
		try tvNode.backColor = col
		catch()
	)
	

	fn unhighlightNodes =
	(
		try(
			for n in nodeHighlightStack do n.backColor=colOff
			nodeHighlightStack=#()
		)
		catch(format"failed to decolor nodes...\n")
	)

	fn resetExpandedNodes=
	(
		try(
			for n in nodeExpandedStack do n.expanded=false
			nodeExpandedStack=#()
		)
		catch()
	)


---------------------------------------------------------------------------------------------------------------------------
-- node / click/drag functions
---------------------------------------------------------------------------------------------------------------------------


	fn tvNodeClick tv tvNode =
	(
		unboldMousePicks()
		-- update the label
			lbl1.text = tvNode.fullpath
	
		-- code
			-- print node / maxobject properties
				--clearListener()
				try(
					local saStr = getSAStringFromNode tvNode
					local sa = getSAFromNode tvNode
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
				if superclassof sa.object == modifier then
				(
					format "IS MODIFIER!\n"
					modPanel.setCurrentObject sa.object
				)
				else format "%\n" (superclassof sa.object)
*/
	)

	

		-------------
		-- mouse down
		-------------
		fn tvMouseDown tv btn shift x y =
		(
			--format "down\n"
			getMousePick tv
			if mousePick != undefined then
			(
				boldMousePick tv
				selNode=mousePick
				tv.selectedItem=selNode
				lbl1.text = selNode.text
				unboldMousePicks()
			)
		)


		------------
		-- mouse up
		------------


		fn tvMouseUp tv btn shift x y =
		(
			enableAccelerators = false			
			--selNode = tvGetHitNode tv
			if btn == 2 and selNode != undefined do
			(
				popupmenu nodeMenu pop:[x, y] rollout:test
 			)
			unboldMousePicks()
		)

		-------------
		-- start drag
		-------------
			fn tvStartDrag tv data AllowedEffects=
			(
				--format "start drag\n"
				-- get node array props
					nodePropArr=getNodeChildren selNode
				-- convert to text as opposed to nodes
					for i = 1 to nodePropArr.count do nodePropArr[i] = nodePropArr[i].text
--				lastNode.bold=false
			)


		fn checkNode =
		(
			-- unhighlight any previously coloured nodes
				unhighlightNodes()
				
			-- reset expanded status of previous nodes
				resetExpandedNodes()
	
			-- inspect node
				local dragNodeClass = classof((getSAFromNode selNode).object)
				local dropNodeClass = classof((getSAFromNode curNode).object)
		
				local dragNodeSuperclass = superclassof((getSAFromNode selNode).object)
				local dropNodeSuperclass = superclassof((getSAFromNode curNode).object)
	
				--format "% | %\n" dragNodeClass dropNodeClass 
				--format "% | %\n" dragNodeSuperclass dropNodeSuperclass 
			
			-- if compatible, hightlight
				if dragNodeClass == dropNodeClass then
				(
					okToCopy=true
					highlightNode curNode colNodeOK
					append nodeHighlightStack curNode
				)
				else
				(
					okToCopy=false
				)
		)
	
	
		fn checkNodeChildren =
		(
			local propsInCommon=false
			try(
			-- check for common subanims
				nodeChildArr = getNodeChildren curNode
				for n in nodeChildArr do
				(
					if finditem nodePropArr n.text != 0 then
					(
						propsInCommon=true
						highlightNode n colChildOK
						append nodeHighlightStack n
					)
				)
			-- if there are properties in common, expand
				if curNode.expanded==false AND propsInCommon==true then
				(
					curNode.expanded=true
					append nodeExpandedStack curNode
				)
			)
			catch(format"failed to check for common subAnims...\n")
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
					--if nodeBoldStack.count>1 then
					unboldMousePicks()

				-- update feedback
					lbl3.text = lastNode.text
					lbl4.text = curNode.text
					

				-- if different RUN THE CODE!
				-- (this ensures the code is only run once)
					if curNode.index!=lastNode.index then
					(
						lbl5.text="PROCESSING!"
					-- run code
						try(
						-- update interface
							boldMousePick tv
							--lastNode.bold=false
							--curNode.bold=true

						-- START EXECUTABLE CODE -----------------------------------
							checkNode()
							checkNodeChildren()
	
						-- END EXECUTABLE CODE -------------------------------------
						)
						catch()
					)
				-- udpate feedback
					else
					(
						lbl5.text=""
						--lastNode.bold=false
					)
				)
			)

		-------
		-- drop
		-------
			fn tvDragDrop tv data Effect btn key x y =
			(
				--curNode.backColor=colOff
				--curNode.bold=false
				messagebox ""
				unboldMousePicks()
			)


		-----------
		-- complete
		-----------
			fn tvCompleteDrag tv Effect =
			(
				mousePick = selNode
				boldMousePick tv
				unboldMousePicks()
				unhighlightNodes()
				resetExpandedNodes()
			)

 


 
---------------------------------------------------------------------------------------------------------------------------
-- mouse handlers
---------------------------------------------------------------------------------------------------------------------------

		on tv1 NodeClick tvNode do 									tvNodeClick tv1 tvNode
		on tv2 NodeClick tvNode do 									tvNodeClick tv2 tvNode

		on tv1 MouseDown btn shift x y do 							tvMouseDown tv1 btn shift x y
		on tv2 MouseDown btn shift x y do 							tvMouseDown tv2 btn shift x y

		--on tv1 MouseMove btn shift x y do 							tvMouseMove tv1 btn shift x y
		--on tv2 MouseMove btn shift x y do 							tvMouseMove tv2 btn shift x y

		on tv1 MouseUp btn shift x y do 							tvMouseUp tv1 btn shift x y
		on tv2 MouseUp btn shift x y do 							tvMouseUp tv2 btn shift x y

		on tv1 OLEStartDrag data AllowedEffects do 						tvStartDrag tv1 data AllowedEffects
		on tv2 OLEStartDrag data AllowedEffects do 						tvStartDrag tv2 data AllowedEffects

		on tv1 OLEDragOver data Effect Button Shift x y State do 	tvDragOver tv1 data Effect Button Shift x y State
		on tv2 OLEDragOver data Effect Button Shift x y State do 	tvDragOver tv2 data Effect Button Shift x y State

		on tv1 OLEDragDrop data Effect btn key x y do 				tvDragDrop tv1 data Effect btn key x y
		on tv2 OLEDragDrop data Effect btn key x y do 				tvDragDrop tv2 data Effect btn key x y

		on tv1 OLECompleteDrag effect do 							tvCompleteDrag tv1 effect
		on tv2 OLECompleteDrag effect do 							tvCompleteDrag tv2 effect

)

createdialog test 615 600 50 50 style:#(#style_minimizebox,#style_titlebar, #style_border, #style_sysmenu,#style_resizing)--#style_maximizebox,
