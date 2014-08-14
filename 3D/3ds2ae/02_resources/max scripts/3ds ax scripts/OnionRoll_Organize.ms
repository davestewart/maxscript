/*
------------------------------
Onion Organize Rollout
David Humpherys
Blur Studios
daveh@blur.com
------------------------------
*/


rollout OnionOrganize "Orgainize Layers"
(
	local labelEditing = false
	local drag_node
	local drop_node
	local nameChange_Node
	local grpExpand = #()
	
	button newGroup "Add Group" width:65 pos:[5,5]  tooltip:"Add Group"
	button delGroup "Delete Group" width:70 pos:[70,5]  tooltip:"Delete Group" 
	button help "?" width:15 pos:[140,5] tooltip:"Help"
	edittext namefield "" width:154 pos:[1,31]
	activeXControl tvAX "MSComctlLib.TreeCtrl.2" width:270 height:325 pos:[5,50]
	button done "OK" align:#right
	
	function initOrganizeTree =
(
		if (Onion.PREF_Debug_Mode)  then print ("FN: initOrganizeTree" )	
		tvAX.lineStyle = #tvwRootLines --#tvwTreeLines
		tvAX.indentation = 0
		tvAX.pathseparator = "."
		tvAX.OLEDragMode = #ccOLEDragAutomatic
		tvAX.OLEDropMode = #ccOLEDropManual
		---tvAX.enabled = false
		tvAX.LabelEdit = #tvwManual --lock out named editing in the treeview
		tvAX.hideSelection = false
)
	
	function buildTreeFromOnionData =
(
		if (Onion.PREF_Debug_Mode)  then print ("FN: buildTreeFromOnionData" )
		--organize groups
		grpInd = finditem globaltracks.oniondata.GroupOrder G
		for g = 1 to globaltracks.oniondata.grouporder.count do
	(
			
			grpInd = finditem globaltracks.oniondata.GroupOrder G
			if grpExpand[grpInd] == undefined then grpExpand[grpInd] = true
			local gnode = tvAX.nodes.add()
			gnode.text = globaltracks.oniondata.GroupName[ grpInd  ]
			gnode.tag = ( "g," + grpInd  as string )
			gnode.key = ( "g," + grpInd  as string )
			local LayerIndArray = Onion.getLayersInGroup grpInd 
			strAry = Onion.getLayerOrder LayerIndArray
			for L in strAry do
		(
				local LayerRef =  Onion.GetLayerReference L
				Lnode = tvAX.nodes.add gnode.index 4 "" LayerRef.name
				Lnode.tag = ("l," + L as string)
		)
			gnode.expanded = grpExpand[grpInd]
	)
)
	
	fn getHitNode = 
(
		--if (Onion.PREF_Debug_Mode)  then print ("FN: getHitNode" )
		local p = getCursorPos tvAX
		local calib = 15
		tvAX.HitTest ((p.x-2)*calib) ((p.y-2)*calib)	
)
	
	on newGroup pressed do
(
		local temp = for i in globaltracks.oniondata.groupOrder collect i
		sort temp
		append globaltracks.oniondata.GroupOrder ( temp[ temp.count] + 1)
		append globaltracks.oniondata.GroupName "New Group"
		append globaltracks.oniondata.GroupOpen true
		append grpExpand true
		tvAX.nodes.clear()
		buildTreeFromOnionData()
)
	on delGroup pressed do
(
		if (Onion.PREF_Debug_Mode)  then print ("EVENT: delGroup pressed" )
		if tvAX.selecteditem != undefined then
	(
			local tag = tvAx.selecteditem.tag
			if tag[1] == "g" then
		(
				groupInd =(  ( (filterstring tvAx.selecteditem.key ",")[2] ) as integer )
				if (Onion.PREF_Debug_Mode)  then print ("\tgroup index " + groupInd as string )
				--check to see if there is more than one group
				if globaltracks.oniondata.groupName.count == 1 then
			(
					messagebox "You must have at least one group"
			)
				else
			(
					LayAry = Onion.getLayersInGroup groupInd
					
					if LayAry.count == 0 then
				(
						grpO = globaltracks.oniondata.groupOrder[ groupInd ]
						
						for g = 1 to globaltracks.oniondata.groupOrder.count do
					(
							if globaltracks.oniondata.groupOrder[g]  >= grpO do globaltracks.oniondata.groupOrder[g] -= 1			
					)

						deleteitem globaltracks.oniondata.groupOrder groupInd 
						deleteitem globaltracks.oniondata.groupName groupInd
						
						--go through all layers and if their group index is greater than grpind -1
						for L = 1 to globaltracks.oniondata.layergroup.count do
					(
							if globaltracks.oniondata.layergroup[ L ] > groupInd then globaltracks.oniondata.layergroup[ L ] -= 1
					)
				)
					
					else
				(
						messagebox "The group must be empty to remove it."
				)
					tvAX.nodes.clear()
					buildTreeFromOnionData()
			)
		)
			else messagebox "Select a group first."
	)
		else messagebox "Select a group first."
)
	on help pressed do
(
		messagebox "Right-Click to change the name of a layer or group.\n\nDrag and drop layers and groups to re-order them."
	
)
	on tvAX mouseDown button shift x y do
(
		if (Onion.PREF_Debug_Mode)  then print ("EVENT: tvAX mousedown")
		if button == 1 then
	(
			drag_node = getHitNode()
			
			if (Onion.PREF_Debug_Mode) and drag_node != undefined  then print ("\tNode:" + drag_node.text)
	)	
)
	on tvAX OLEStartDrag data effects do
(
		if (Onion.PREF_Debug_Mode)  then print ("EVENT: tvAX OLEStartDrag ")
		drag_node = getHitNode()
--		if drag_node.text != tvax.selectedItem then drag_node = tvax.selectedItem
--		if drag_node == undefined then drag_node = getHitNode()
		if (Onion.PREF_Debug_Mode)  then print ("\tnode: " + drag_node.text)
	--	if drag_node == undefined or drag_node.
)
	on tvAX OLEDragOver data Effect Button Shift x y State do
(
		--if (Onion.PREF_Debug_Mode)  then print ("EVENT: tvAX OLEDragOver ")
		drop_node = getHitNode()
		if drop_node != undefined then tvax.selectedItem = drop_node --hightlight
)

	on tvAX OLEDragDrop data effect button key x y do
(
		if (Onion.PREF_Debug_Mode)  then print ("EVENT: tvAX OLEDragDrop")
		if drop_node != undefined and drag_node != undefined then
	(
			local dragID 
			local dropID
			if drop_node.tag != drag_node.tag then	--to prevent dragging something over itself.
		(
				if drop_node.tag[1] == "g" then  ---dropping on group
			(
					dropID =  ( (filterstring drop_node.key ",")[2] ) as integer	
					if drag_node.tag[1] == "g" then  --drag a group onto a group
				(
						if (Onion.PREF_Debug_Mode)  then print ("\tdraging group on to group " )
						if (Onion.PREF_Debug_Mode)  then print ("\tgroupOrder before: " + globaltracks.oniondata.groupOrder as string )				
						dragID =  ( (filterstring drag_node.key ",")[2] ) as integer
						--just reorder the group order
						dropOrder = globaltracks.oniondata.groupOrder[ dropID ]
						dragOrder = globaltracks.oniondata.groupOrder[ dragID ]
						if dragOrder > dropOrder then
					(
							for l in globaltracks.oniondata.groupOrder do
						(
								if globaltracks.oniondata.groupOrder[ l ] > dropOrder then
									if globaltracks.oniondata.groupOrder[ l ] < dragOrder then globaltracks.oniondata.groupOrder[ l ] += 1
						)
							--change the drop
							globaltracks.oniondata.groupOrder[ dragID ] = dropOrder +1
					)
						else 
					(
							for l in globaltracks.oniondata.groupOrder do
						(
								if globaltracks.oniondata.groupOrder[ l ] > dragOrder then
									if globaltracks.oniondata.groupOrder[ l ] <= dropOrder then globaltracks.oniondata.groupOrder[ l ] -= 1
						)
							--change the drop
							globaltracks.oniondata.groupOrder[ dragID ] = dropOrder	
					)
						if (Onion.PREF_Debug_Mode)  then print ("\groupOrder after: " + globaltracks.oniondata.groupOrder as string )	
				)
					else --drag a layer onto a group
				(
						if (Onion.PREF_Debug_Mode)  then print ("\tdraging layer on to  a group " )
						if (Onion.PREF_Debug_Mode)  then print ("\tlayerGroup before: " + globaltracks.oniondata.layerGroup as string )	
						if (Onion.PREF_Debug_Mode)  then print ("\tlayerIndex before: " + globaltracks.oniondata.layerIndex as string )	
						dragID = ( (filterstring drag_node.tag ",")[2] ) as integer
						--push all the layers above drag layer down 
						grp = Onion.getGroupFromLayer dragID
						layerInds = Onion.getLayersInGroup grp
						dragOrder = globaltracks.oniondata.layerindex[ dragID ]	
						for l in layerInds do 
							if globaltracks.oniondata.layerindex[ l ] > dragOrder then globaltracks.oniondata.layerindex[ l ] -= 1
							
						--push all the layers in the drop group above the drop up
						--grp = Onion.getGroupFromLayer dropID
						layerInds = Onion.getLayersInGroup dropID
						dropOrder = globaltracks.oniondata.layerindex[ dropID ]
						for l in layerInds do globaltracks.oniondata.layerindex[ l ] += 1
						--set the drop group ind to the drag group index
						globaltracks.oniondata.layergroup[ dragID ] =  dropID
						--set the drop layer +1 drag layer index
						globaltracks.oniondata.layerindex[ dragID ] = 1
						if (Onion.PREF_Debug_Mode)  then print ("\tlayerGroup after: " + globaltracks.oniondata.layerGroup as string )
						if (Onion.PREF_Debug_Mode)  then print ("\tlayerIndex after: " + globaltracks.oniondata.layerIndex as string )
				)
			)
				else -- dropping on layer
			(
					dropID = ( (filterstring drop_node.tag ",")[2] ) as integer
					if drag_node.tag[1] != "g" then --dropping layer on a layer
				(
						dragID = ( (filterstring drag_node.tag ",")[2] ) as integer
						--if the parent index of the drag and drop objects are the same then the reorder is happening inside the same group
						if drag_node.parent.index == drop_node.parent.index then
					(
							if (Onion.PREF_Debug_Mode)  then print ("\tdraging layer to layer in same group" )
							if (Onion.PREF_Debug_Mode)  then print ("\tlayerIndex before: " + globaltracks.oniondata.layerindex as string )
							--get the layers in that group
							grp = Onion.getGroupFromLayer dragID
							layerInds = Onion.getLayersInGroup grp
							dropOrder = globaltracks.oniondata.layerindex[ dropID ]
							dragOrder = globaltracks.oniondata.layerindex[ dragID ]
							if dragOrder > dropOrder then
						(
								for l in layerInds do
							(
									if globaltracks.oniondata.layerindex[ l ] > dropOrder then
										if globaltracks.oniondata.layerindex[ l ] < dragOrder then globaltracks.oniondata.layerindex[ l ] += 1

							)
								--change the drop
								globaltracks.oniondata.layerindex[ dragID ] = dropOrder +1
						)
							else 
						(
								for l in layerInds do
							(
									if globaltracks.oniondata.layerindex[ l ] > dragOrder then
										if globaltracks.oniondata.layerindex[ l ] <= dropOrder then globaltracks.oniondata.layerindex[ l ] -= 1

							)
								--change the drop
								globaltracks.oniondata.layerindex[ dragID ] = dropOrder			
						)
							if (Onion.PREF_Debug_Mode)  then print ("\tlayerIndex after: " + globaltracks.oniondata.layerindex as string )
					)
						else
					(
							if (Onion.PREF_Debug_Mode)  then print ("\tdraging layer to layer outside group on to layer" )
							if (Onion.PREF_Debug_Mode)  then print ("\tlayerIndex before: " + globaltracks.oniondata.layerindex as string )
							--push all the layers above drag layer down 
							grp = Onion.getGroupFromLayer dragID
							layerInds = Onion.getLayersInGroup grp
							dragOrder = globaltracks.oniondata.layerindex[ dragID ]	
							for l in layerInds do 
								if globaltracks.oniondata.layerindex[ l ] > dragOrder then globaltracks.oniondata.layerindex[ l ] -= 1
							--push all the layers in the drop group above the drop up
							grp = Onion.getGroupFromLayer dropID
							layerInds = Onion.getLayersInGroup grp
							dropOrder = globaltracks.oniondata.layerindex[ dropID ]
							for l in layerInds do 
								if globaltracks.oniondata.layerindex[ l ] > dropOrder then globaltracks.oniondata.layerindex[ l ] += 1
							--set the drop group ind to the drag group index
							globaltracks.oniondata.layergroup[ dragID ] =  globaltracks.oniondata.layergroup[ dropID ]
							--set the drop layer +1 drag layer index
							globaltracks.oniondata.layerindex[ dragID ] = globaltracks.oniondata.layerIndex[ dropID ] +1
					)
						
				)
					else messagebox "Can't drop a Layer Group onto a Layer"
			)
		)
			--clear the tv
			tvAX.nodes.clear()
			buildTreeFromOnionData()
	)
)
	on tvAX mouseup button shift x y do
(
		done.enabled = true
		if (Onion.PREF_Debug_Mode)  then print ("EVENT: tvAX mouseup")
		if button == 2 then
	(
			tvAX.StartLabelEdit()
			done.enabled = false
			nameChange_Node = tvAX.selectedItem.index
	)
)

	on tvAX click do
(
		if (Onion.PREF_Debug_Mode)  then print ("EVENT: tvAX click")
		if tvAx.selectedItem != undefined then
	(
			namefield.text = tvAX.selectedItem.text
			nameChange_Node = tvAX.selectedItem.index
	)
		else
	(
			namefield.text = ""
			nameChange_Node = undefined
	)
		if keyboard.shiftpressed == true then
	(
			tvAX.StartLabelEdit()
			done.enabled = false
			nameChange_Node = tvAX.selectedItem.index
	)
		
	
)
	on namefield changed txt do
(
		if tvAX.selectedItem != undefined then
			 tvAX.selectedItem.text = txt
)
	on namefield entered txt do
(
		 if tvAX.selectedItem != undefined then
		 (
			 --get the tag of the selected item
			local tag = tvAx.Nodes[ nameChange_Node ].tag
			if tag[1] != undefined then
		(
				 tvAX.selectedItem.text = txt	
				if tag[1] == "g" then
			(
					local ID =(  ( (filterstring tvAx.Nodes[ nameChange_Node ].tag ",")[2] ) as integer )
					globaltracks.oniondata.GroupName[ ID ] = txt
			)
				else --it's a layer
			(
					local L =  layerManager.getLayerFromName globaltracks.oniondata.layername[ ( (filterstring tag ",")[2] ) as integer ]
					local changeIT = L.setname txt
					if changeIT then globaltracks.oniondata.layername[ ( (filterstring tag ",")[2] ) as integer ] = txt
					else 
				(
						messagebox "WARNING: Name change will not take effect\nName must be unique to all other layers"
				)
			)
		)
	)
)
	/*
	on tvAX dblclick do 
(
)
	*/
	on tvAX AfterLabelEdit cncl newstring do
(
		done.enabled = true
		--get the tag of the selected item
		local tag = tvAx.Nodes[ nameChange_Node ].tag
		if tag[1] == "g" then
	(
			local ID =(  ( (filterstring tvAx.Nodes[ nameChange_Node ].tag ",")[2] ) as integer )
			globaltracks.oniondata.GroupName[ ID ] = newstring
	)
		else --it's a layer
	(
			local L =  layerManager.getLayerFromName globaltracks.oniondata.layername[ ( (filterstring tag ",")[2] ) as integer ]
			local changeIT = L.setname newstring
			if changeIT then globaltracks.oniondata.layername[ ( (filterstring tag ",")[2] ) as integer ] = newstring
			else messagebox "WARNING: Name change will not take effect\nName must be unique to all other layers"
	)
)
	on tvAX expand node do
(
		grpInd = (filterstring node.tag ",")[2] as integer
		grpExpand[grpInd] = true
)
	on tvAX collapse node do
(
		grpInd = (filterstring node.tag ",")[2] as integer
		grpExpand[grpInd] = false
)
	on done pressed do
(
		destroydialog OnionOrganize 
		Onion.ui.refresh()
)
	
	on OnionOrganize open do
(
		initOrganizeTree()
		buildTreeFromOnionData()
		showEvents tvAX 
)
	on OnionOrganize close do
(
		Onion.ui.refresh()
)
	on OnionOrganize resized p2 do
(
		done.pos.x = p2.x - 40
		done.pos.y = p2.y - 20
		tvAX.size.x = p2.x-10
		tvAx.size.y = (p2.y - 75)
)

)
