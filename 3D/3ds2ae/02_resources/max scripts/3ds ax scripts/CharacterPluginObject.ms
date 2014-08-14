-------------------------------------------------------------------------------------------
--   File:			CharacterPluginobject*.MS
--   Description:	A character assembly scripted plugin
--   By:			Ravi Karra [Discreet] 			ravi.karra@autodesk.com
--   Created:		11/26/01
--	 Modified:		01/10/02
--	 				05/08/2003 - aszabo - 
--						Added ability to add multiple members at once or without re-clicking 
--						the Add button. "Add" btn uses pickObject count:1. "Add List" button 
--						allows for picking multiple objects from Select By Name dlg
--					06/08/2003 - aszabo - 
--						Fixed #429406. Display of low\full\all objects is done on on displayRes 
--						get handler. displayRes made non-animatable
-- 
--***********************************************************************************************
global g_characterAction, g_characterTimer, rMergeAnim, rObjectMapping, g_suspendCharacterRedraw = false, g_skipped_nodes = #()
colorMan.registerColor #chr_color "Wire Color" "Character" [0.858824,0.858824,0]

rcmenu CharacterMenu
(
	menuItem mi_remove		"Remove"
	menuItem mi_lowres		"Set As Low Res"
	menuItem mi_fullres		"Set As Full Res"		
	
	on mi_remove	picked do ( g_characterAction = #remove ; g_characterTimer.active = true )
	on mi_lowres	picked do ( g_characterAction = #lowres; g_characterTimer.active = true )
	on mi_fullres	picked do ( g_characterAction = #fullres; g_characterTimer.active = true )
)

plugin helper CharacterAssembly
name:"Character"
category:"Standard"
classID:#(0xcbbf6436, 0x899498a9)
extends:character
replaceui:true
invisible:true
version:1
(
	
	local members =#(), thisNode
	-- This flag is used to keep the Add checkbutton depressed while picking character members
	local inPickMode = false
	local lastDisplayRes = 0
	
	fn getGroupHead nodes = 
(
		for n in nodes do if isGroupHead n then return n
		undefined
)
	fn genRndNumber = 
(
		local imax = 650000
		(random 1 imax) + (random 1 imax) + (bit.shift ((random 1 imax) + (random 1 imax)) -16)
)
	fn getNodes chr =
(
		for n in (refs.dependents chr) where ((isValidNode n) and n.baseobject == chr) collect n
)	
	fn getMembers parent =
(
		for c in parent.children do
	(
			if isGroupMember c then append members c
			getMembers c
	)
)
	fn getBoundingSize objs = 
(
		disableSceneRedraw()
		local sel = selection as array
		select objs
		local size = selection.max - selection.min
		select sel
		enableSceneRedraw()
		size
)
	
	fn initThisNode = 
(
--		if thisNode == undefined then
	(
			thisNode = getGroupHead (selection as array)
			if thisNode == undefined then thisNode = (getNodes this)[1]
	)
)
	
	
	rollout rParams "Character Assembly" width:160 height:324
(
		GroupBox 	grpPose 			"Skin Pose"				width:152 height:80		align:#center
		button		btnSetSkinPose 		"Set as Skin Pose" 		width:116 height:16		offset:[0,-68] --enabled:false
		button		btnAssumeSkinPose 	"Assume Skin Pose" 		width:116 height:16
		checkbutton ckbSkinPoseMode 	"Skin Pose Mode"		width:116 height:16		--enabled:false						
		
		GroupBox 	grpDisplay 		"Display" 					width:152 height:100	align:#center offset:[0,0]
		spinner		spnIconSize		"Icon Size: "				width:100 height:20		align:#left offset:[10,-85] type:#integer range:[1, 1000, 10]

		radioButtons rbDispRes		labels:#("Low Res Objects", "Full Res Objects", "All Objects") columns:1	align:#left across:3  offset:[0,0]
		
		GroupBox	grpAnim 		"Animation" 				width:152 height:85	align:#center offset:[0, 55]
		button		btnInsertAnim 	"Insert Animation" 			width:120 height:16	align:#center offset:[-44,72]
		button		btnSaveAnim 	"Save Animation" 			width:120 height:16	align:#center offset:[0,-53]
		button 		btnResetAnim	"Reset All Animation"		width:120 height:16	align:#center
		
		fn updateUI =
	(
			if thisNode != undefined then
				ckbSkinPoseMode.checked = thisNode.SkinPoseMode
			btnSetSkinPose.enabled = ckbSkinPoseMode.enabled = btnInsertAnim.enabled = btnSaveAnim.enabled = btnResetAnim.enabled = (thisNode != undefined)
	)
		
		on rParams open do 
	(
			initThisNode()
			updateUI()
	)
		on btnSetSkinPose pressed do
	(
			local res = queryBox "Do you really want to Set the Skin Pose ?" title:"Character"
			if res then
		(	
				undo "Set as Skin Pose" on
			(
					thisNode.setSkinPose()
					for m in members do m.setSkinPose()
			)
		)
	)
		on btnAssumeSkinPose pressed do
	(
			undo "Assume Skin Pose" on
		(						
				ckbSkinPoseMode.checked = false
				thisNode.SkinPoseMode = false
				thisNode.assumeSkinPose()
				for m in members do
			(
					m.SkinPoseMode = false
					m.assumeSkinPose()
			)
		)
	)
		on ckbSkinPoseMode changed state do 
	(
			thisNode.SkinPoseMode = state
			for m in members do m.SkinPoseMode = state
	)
		on btnDispAll pressed do
	(
			this.displayBones = this.displayHelpers = this.displayGeometry = this.displayIK = this.displayLowRes = this.displayFullRes = true
	)
		
		on btnDispNone pressed do
	(
			this.displayBones = this.displayHelpers = this.displayGeometry = this.displayIK = this.displayLowRes = this.displayFullRes = false
	)
		
		on btnDispInvert pressed do
	(
			this.displayBones = not this.displayBones
			this.displayHelpers = not this.displayHelpers
			this.displayGeometry = not this.displayGeometry
			this.displayIK = not this.displayIK
			this.displayLowRes = not this.displayLowRes
			this.displayFullRes = not this.displayFullRes
	)
		
		on btnInsertAnim pressed do
	(
			rMergeAnim.openDialog()
			rObjectMapping.etCurrent.text = rObjectMapping.etSource.text = thisNode.name
			rMergeAnim.btnSource.pressed()
			if rMergeAnim.file_name != undefined then
		(
				rMergeAnim.show_messages = false
				try (
					rMergeAnim.dontFilterChildren = true
					rMergeAnim.updateSource()
					rMergeAnim.updateCurrent()
					rObjectMapping.btnAutoMap.pressed()
				) catch ( MessageBox "Error Occured while Merging, " + rMergeAnim.file_name)
		)
	)
		on btnSaveAnim pressed do
	(
			local f = getSaveFileName types:"3ds max Animation (*.anm)|*.anm|XML Animation (*.xml)|*.xml|All (*.*)|*.*|"
			if f != undefined then
		(
				if (getFilenameType f) == ".xml" then
			(
					rMergeAnim.openDialog()
					rMergeAnim.Save2XML f nodes:#(thisNode) --.children
					destroyDialog rMergeAnim
			)
				else
			(
					with redraw Off
				(
						local locked = assemblyMgr.canOpen thisNode 	
						assemblyMgr.close thisNode select:false
						print members
						saveNodes members f
						if not locked then assemblyMgr.open thisNode clearSelection:false
						select thisNode
				)
			)
		)
	)
		on btnResetAnim pressed do
	(
			local res = queryBox "Do you really want to Reset All Animation?" title:"Character"
			if res then
		(
				undo "Reset All Animation" on
			(
					rMergeAnim.resetNodeAnim thisNode
					for m in members do
						rMergeAnim.resetNodeAnim m
			)
		)
	)
)
	
	parameters pbParams rollout:rParams
(
		characterID		type:#integer subAnim:false animatable:false default:0
		iconSize		type:#integer default:10 ui:spnIconSize animatable:false	
		-- Helper objects are not evaluated by the renderer, so switching LOD via  
		-- the displayRes param won't be visible in rendering of frame sequences other than the current frame
		displayRes		type:#radiobtnIndex default:3 ui:rbDispRes animatable:false
		
        	on iconSize get val do 
	(
		    iconsize = delegate.size
	)
		on iconSize set val do
	(
			delegate.Size = val
	)	
	
		-- Updating the hidden\non-hidden state of character members in the get handler
		-- ensures proper display in the viewport of the hidden\non-hidden objects
		on displayRes get val do
	(
			if (val != lastDisplayRes) do
		(	
				lastDisplayRes = val
				case val of
			(
					1: for m in members do m.isHidden = ((getAppData m this.characterID) != "true")
					2: for m in members do 
				(
						local no_proxy = (getAppData m this.characterID)
						m.isHidden = (no_proxy == "true")
						--format "proxy setting: % - %\n" m no_proxy
				)
					3: (for m in members do m.isHidden = false)
			)			
		)
			val
	)
)

	rollout rMembers "Character Members" width:160 height:360
(
		local listItems
		
		fn pickFilter obj = 
	(
			local pickable = obj.baseObject != this	and assemblyMgr.canAttach #(obj) assembly:thisNode
/*			while obj.parent != undefined do
		(
				if obj.parent == thisNode do return false
				obj = obj.parent
		)
			
			return pickable
*/			
	)
		
		checkbutton ckAdd		 	"Add" 						width:045 height:16		align:#left   offset:[-10,0] across:3
		button		btnAddList		"Add List"					width:045 height:16		align:#center offset:[0,0]
		button 		btnRemove		"Remove"					width:045 height:16		align:#right  offset:[10,0] enabled:false
		activeXControl lvMembers 	"MSComCtlLib.ListViewCtrl"	width:160 height:620	align:#center offset:[0,0]
		timer		tmr				interval:1 active:false
		
		fn getProxySetting obj = 
	(
			(getAppData obj characterID) == "true"
	)
		fn setProxySetting obj val = 
	(
			setAppData obj characterID (val as string)
			
			case this.displayRes of
		(
				1: obj.isHidden = not val
				2: obj.isHidden = val
				3: obj.isHidden = false
		)
	)
		fn updateUI = 
	(
			local sel = lvMembers.selectedItem
			ckAdd.enabled = (thisNode != undefined)
			ckAdd.state = inPickMode
			btnAddList.enabled = (thisNode != undefined)
			btnRemove.enabled = CharacterMenu.mi_remove.enabled = (sel != undefined and assemblyMgr.canDetach sel.tag)	
	)
		fn updateList =
	(
			members = #()
			if thisNode != undefined then
				getMembers thisNode
			listItems.clear()
			-- add and assign list items
			for m in members do
		(
				li = listItems.Add()
				li.tag = m		
				li.checked = getProxySetting m
				li.text = m.name
		)
			UpdateUI()
	)
		fn initListView ax =
	(
			local LVM_FIRST = 0x1000, LVM_SETCOLUMNWIDTH = (LVM_FIRST + 30)
			ax.view = #lvwReport
			ax.checkBoxes = true
			ax.fullRowSelect = true
			ax.labelEdit = #lvwManual
			ax.hideSelection = false
			ax.multiSelect = true
			
			listItems = ax.listItems
			hMembers = ax.columnHeaders.Add()
			hMembers.text = "Low Res"		
			windows.sendMessage ax.hwnd LVM_SETCOLUMNWIDTH  0 140			
	)		
				
		fn removeSelMembers = 
	(
			undo "Remove Character Members" on
		(
				for li in lvMembers.listItems where li.selected do
			(
					g_characterTimer = tmr
					callbacks.addScript #sceneUndo "g_characterTimer.active = true" id:#character
					callbacks.addScript #sceneRedo "g_characterTimer.active = true" id:#character					
					
					local member = li.tag	
					local parent = if member.parent == thisNode then thisNode.parent else member.parent
					member.parent = undefined
					assemblyMgr.detach member
					-- reset the parent
					member.parent = parent
					if (getProxySetting member) then
						member.isHidden = false
			)
				updateList()
				
		)
	)		
		fn executeAction action = 
	(
			case action of
		(
				#remove:
			(
					removeSelMembers()
			)
				#lowres:
			(
					for li in lvMembers.listItems where li.selected do
				(
						setProxySetting li.tag true
						li.checked = true
				)
			)
				#fullres:
			(
					for li in lvMembers.listItems where li.selected do
				(
						setProxySetting li.tag false
						li.checked = false
				)
			)
		)
	)
		on rMembers open do
	(			
			if not g_suspendCharacterRedraw then
		(
				initListView lvMembers
				updateList()
		)
	)
		on lvMembers itemCheck li do
	(
			setProxySetting li.tag li.checked			
	)
		on lvMembers afterLabelEdit cancel newString do
	(
			lvMembers.selectedItem.tag.name = newString
	)
		on lvMembers itemClick li do
	(
			btnRemove.enabled = CharacterMenu.mi_remove.enabled = assemblyMgr.canDetach li.tag
	)
		on lvMembers MouseUp btn shift x y do
		( 			enableAccelerators = false			
			if btn == 2 do
		(
				g_characterAction = undefined
				g_characterTimer = tmr
				popupmenu characterMenu pop:[x, y] rollout:rMembers
		)
	)
		on tmr tick do
	(
			if g_characterAction != undefined then
		(
				executeAction g_characterAction
				g_characterAction = undefined
		)
			tmr.active = false
			if thisNode != undefined then 
		(
				members = #()
				getMembers thisNode
				updateList()
		)
			rParams.updateUI()
			if g_suspendCharacterRedraw then redrawViews()
	)
		
		on btnAddList pressed do
	(
			local objs = (selectByName title:"Pick Character Members" buttonText:"Pick" filter:pickFilter showHidden:false single:false)
			if (objs != undefined) do
		(
			    --format "objs.count=%\n" (objs as array).count
				undo "Add Character Members" on
			(
					assemblyMgr.attach (objs as array) assembly:thisNode
					for obj in objs do setProxySetting obj false	
			)
		)
	)

		fn PickMultiple =
	(
		  local obj = undefined
		  while ((obj = (pickObject message:"Pick Character Members" count:1 filter:pickFilter forceListenerFocus:false)); isValidNode obj) do
		  (
				undo "Add Character Members" on
			(
					assemblyMgr.attach obj assembly:thisNode
					setProxySetting obj false	
			)
		  )
	) 

		on ckAdd changed theState do 
	(
			if (true == theState ) then 
		(
				inPickMode = true
				
				PickMultiple()
			  	
				inPickMode = false
				ckAdd.checked = false
		)
			else 
		(
				-- When the user clicks on the Add button to turn it off,
				-- terminate the current pickObejct mode
				toolmode.CommandMode = #select
		)
	)
		
		on btnRemove pressed do
	(
			removeSelMembers()
	)
)
	
	on create do
(
		if this.characterID == 0 then 
	(
			-- assign a unique id to the character
			this.characterID = genRndNumber()
	)
		initThisNode()
)	
	
	-- commented for now
	on clone fromObj do
(
		local thisMembers = #()
		this.characterID = genRndNumber()
		
		-- Get the this node
		initThisNode()
		thisNode.assemblyBBoxDisplay = false
/*				
		-- now get the members from the original node
		local nodes = for n in (refs.dependents fromObj) where ((isValidNode n) and n.baseobject == fromObj and n != thisNode ) collect n
		local fromNode = getGroupHead nodes
		getMembers fromNode		
		
		-- copy the members too
		for m in members do
	(
			local cm = copy m
			append thisMembers cm
			cm.transform = append
			
			local prx = getAppData m fromNode.characterID
			if prx != undefined then
				setAppData cm this.characterID prx
	)
		assemblyMgr.attach thisMembers assembly:thisNode		
*/		
)
	-- Prevent attempts to access UI items that aren't present
	on update do 
(
		if not g_suspendCharacterRedraw then
	(
			initThisNode()
			if rParams.open do rParams.updateUI()
			if rMembers.open do rMembers.updateUI()			
	)
		if rMembers.open do g_characterTimer = rMembers.tmr
)
)
