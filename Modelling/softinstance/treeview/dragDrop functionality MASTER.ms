-- Macro_namedSelSets.ms - visual named selection set manager
-- October 30, 2001
-- Mark Young, Ravi Karra
macroScript namedSelSets ButtonText:"Named Selection Sets" category:"Edit" internalCategory:"Edit" tooltip:"Named Selection Sets"
(
	global vEditNamedSelectionSets
	global ensMenu, sToolbar
	if (vEditNamedSelectionSets != undefined) do (
		try DestroyDialog vEditNamedSelectionSets
		catch ()
	)
	
	rcMenu ensMenu
	( 
		local clone_node, is_cut		
		menuItem mi_rename		"Rename (F2)"
		menuItem mi_cut			"Cut (Ctrl+X)"
		menuItem mi_copy		"Copy (Ctrl+C)"
		menuItem mi_paste		"Paste (Ctrl+V)"
		menuItem mi_collapse	"Collapse All"
		menuItem mi_expand		"Expand All"
		seperator sep1
		menuItem mi_create		""
		menuItem mi_delete		""
		--menuItem mi_pick		""
		menuItem mi_add			""
		menuItem mi_subtract	""
		seperator sep2
		menuItem mi_selectSet	""
		menuItem mi_selectName	""
		menuItem mi_query		""
		menuItem mi_findNext	"Find Next (Ctrl+G)"
		
		on mi_rename picked do ( vEditNamedSelectionSets.startEdit() )
		on mi_collapse picked do ( for n in vEditNamedSelectionSets.vTVSets.nodes where n.parent != undefined do n.expanded = false )
		on mi_expand picked do ( for n in vEditNamedSelectionSets.vTVSets.nodes where n.parent != undefined do n.expanded = true )
		
		on mi_create		picked do vEditNamedSelectionSets.executeButton #create
		on mi_delete		picked do vEditNamedSelectionSets.executeButton #delete
		--on mi_pick		picked do vEditNamedSelectionSets.executeButton #pick
		on mi_add			picked do vEditNamedSelectionSets.executeButton #add
		on mi_subtract		picked do vEditNamedSelectionSets.executeButton #subtract
		on mi_selectSet 	picked do vEditNamedSelectionSets.executeButton #selectSet
		on mi_selectName 	picked do vEditNamedSelectionSets.executeButton #selectName
		on mi_filter 		picked do vEditNamedSelectionSets.executeButton #filter
		on mi_findNext 		picked do vEditNamedSelectionSets.findNext()
		
		on ensMenu open do
		(
			local rcMenuStr = ""
			local btns = vEditNamedSelectionSets.btns
			for i=1 to btns.count do
			(
				
				local b = btns[i] as string
				rcMenuStr += ";ensMenu.mi_" + b + ".text = \""  + vEditNamedSelectionSets.btnToolTips[i] + "\"" +
							 ";ensMenu.mi_" + b + ".enabled = " + vEditNamedSelectionSets.vToolbar.buttons[i].enabled as string
				
			)
			execute rcMenuStr
			
			-- set states for cut/copy/paste
			local sel = vEditNamedSelectionSets.vTVSets.selectedItem
			mi_rename.enabled = mi_copy.enabled = mi_cut.enabled = (sel.parent != undefined)
			try
			(
				mi_paste.enabled = sel.parent != undefined and clone_node != undefined and
					clone_node.parent != undefined and sel.text != clone_node.parent.text
			)
			catch ( mi_paste.enabled = false )
		)	
		on mi_cut picked do
		(
			if clone_node != undefined then clone_node.image = 2
			clone_node = vEditNamedSelectionSets.vTVSets.selectedItem
			clone_node.image = 3
			is_cut = true
		)
		
		on mi_copy picked do
		(
			try(if clone_node != undefined then clone_node.image = 2)catch()
			clone_node = vEditNamedSelectionSets.vTVSets.selectedItem
			is_cut = false
		)
		on mi_paste picked do
		(
			if clone_node != undefined then
			(
				vEditNamedSelectionSets.tvClone clone_node is_cut
				if is_cut then (clone_node = undefined)
				vEditNamedSelectionSets.vTVSets.refresh()
			)
		)		
	)	
	rollout vEditNamedSelectionSets "Named Selection Sets" width:340 height:375
	(
		--------------------------------------------------------
		local btnToolTips = #(
			"Create New Set",
			"Remove",
			"Add Selected Objects",
			"Subtract Selected Objects",
			"Select Objects in Set",
			"Select Objects By Name",
			"Highlight Selected Objects")
		local menuStrs = #("Rename")
		--------------------------------------------------------
		local bw = 24, bh = 24				
		local vToolbar, ini_file = ((getDir #plugcfg) + "\\namedSelSets.ini")
		
		--activexControl vToolBar "MSComctlLib.Toolbar" pos:[10,5] width:280 height:24
		button vCreate		"" pos:[10 + bw*0, 5] width:bw height:bh tooltip:"Create New Set"
		button vDelete		"" pos:[10 + bw*1, 5] width:bw height:bh tooltip:"Remove"
		button vAdd			"" pos:[10 + bw*2, 5] width:bw height:bh tooltip:"Add Selected Objects"
		button vSubtract	"" pos:[10 + bw*3, 5] width:bw height:bh tooltip:"Subtract Selected Objects"
		button vSelectSet	"" pos:[10 + bw*4, 5] width:bw height:bh tooltip:"Select Objects in Set"
		button vSelectName	"" pos:[10 + bw*5, 5] width:bw height:bh tooltip:"Select Objects By Name"
		button vQuery		"" pos:[10 + bw*6, 5] width:bw height:bh tooltip:"Highlight Selected Objects"
		
		activexControl vTVSets "MSComctlLib.TreeCtrl" pos:[10,10+bh] width:320 height:300
		activexControl vStatusBar "MSComctlLib.SBarCtrl" pos:[1,360] width:325 height:20
		
		-- Image list controls for holding icons
		activeXControl ilTv "{2C247F23-8591-11D1-B16A-00C0F0283628}" height:0 width:0
		activeXControl ilTb "{2C247F23-8591-11D1-B16A-00C0F0283628}" height:0 width:0		
		timer tmr "" interval:1 active:false
		edittext et "" pos:[1000,1000]
		
		-- Various locals
		local btns = #(#create, #delete, #add, #subtract, #selectSet, #selectName, #query)		

		local highNodes = #() -- highlighted nodes
		local nmsNode -- top node for named selection sets
		local tvBackColor = color 223 223 223, tvNodeHighColor = color 0 120 0, tvSetHighColor = color 0 0 120
		local in_drag = false, drag_node, drop_node, mouse_icon
		
		-- various key equivalents
		local kCtrl = 2, kF2 = 113, kF5 = 116, kDelete = 46, kCtrlX = 24, kCtrlC = 3, kCtrlV = 22, kCtrlG = 7
		
		local iconDir = (getDir #ui) + "\\icons"		
		fn initToolbar tb =
		(
			tb.appearance = #ccFlat
			tb.style = #tbrFlat
			tb.buttonWidth = ilTb.imageheight = 16
			tb.buttonHeight = ilTb.imagewidth = 16
			tb.borderStyle = #ccNone
			
			for i=1 to btns.count do
				ilTb.listImages.add i btns[i] (loadPicture (iconDir + "\\tool" + btns[i] + ".ico"))
			
			tb.imageList = ilTb
			for i=1 to btns.count do
			(
				local btn = tb.buttons.add()
				btn.key = btns[i] as string
				btn.image = i
				--if btns[i] == #pick then btn.style = #tbrCheck
				btn.toolTipText = btnToolTips[i]		
			)
		)
		
		fn initButtons =
		(
			-- collect the toolbar buttons into vToolbar.buttons array
			local btnStr = ""
			for i = 1 to btns.count do			
				btnStr += ";append vEditNamedSelectionSets.vToolbar.buttons vEditNamedSelectionSets.v" + btns[i]
			execute btnStr
			
			-- assign image indices
			for  b = 1 to btns.count do
			(
				local ii = b*2-1
				if b > 6 then ii -= 1
				vToolbar.buttons[b].images = #(
					iconDir + "\\enss_tools_16i.bmp", 
					iconDir + "\\enss_tools_16a.bmp",
					13, ii, ii, ii+1, ii+1)
				try(
					vToolbar.buttons[b].toolTip = btnToolTips[b]
				)catch()
			)
		)
		
		fn initTreeView tv =
		(
			local TV_FIRST = 0x1100			
			local TVM_SETINDENT =  (TV_FIRST + 7)
			
			local TVM_SETBKCOLOR = (TV_FIRST + 29)
			local TVM_SETINSERTMARKCOLOR =  (TV_FIRST + 37)
			local TVM_SETLINECOLOR =  (TV_FIRST + 40)
		 
			windows.sendMessage tv.hWnd TVM_SETBKCOLOR 0 0xDDDDDD
			windows.sendMessage tv.hWnd TVM_SETINSERTMARKCOLOR 0 0xDDDDDD
			
			windows.sendMessage tv.hWnd TVM_SETINDENT 0 1
			
			tv.labelEdit = #tvwManual
			tv.font.size = 10
			tv.scroll = true
			tv.fullRowSelect = true
			tv.style = #tvwPlusPictureText
			--tv.style = #tvwTreeLinesPlusMinusPictureText
			tv.hideSelection = false
			tv.oleDragMode = #ccOLEDragAutomatic
			tv.oleDropMode = #ccOLEDropManual
			
			ilTv.imageheight = 16
			ilTv.imagewidth = 16
			ilTv.listImages.add 1 #selSet (loadPicture (iconDir + "\\tvSet.ico"))
			ilTv.listImages.add 2 #node (loadPicture (iconDir + "\\tvObj.ico"))
			ilTv.listImages.add 3 #cutNode (loadPicture (iconDir + "\\tvCutObj.ico"))
			tv.imageList = ilTv
		)
		
		fn initStatusBar sb = 
		(
			sb.style = #sbrSimple
			sb.simpleText = ""
			sb.font.size = 10
		)
		
		fn findChildNode tvn text = 
		(
			local c = tvn.child
			for i=1 to tvn.children do
			(
				if text == c.text then return c
				c = c.next
			)
			return undefined
		)
		
		fn getHitNode = 
		(
			local p = getCursorPos vTVSets
			vTVSets.hitTest (p.x*15) (p.y*15)			
		)
		
		fn isSelSet tag = 
		(
			((classof tag) == String and selectionSets[tag] != undefined)
		)
		
		fn addNodesToTreeView tv_nodes max_nodes parent:undefined =
		(
			if isValidNode max_nodes then max_nodes = #(max_nodes)
			for i=1 to max_nodes.count do
			(
				local c = max_nodes[i]
				if c == undefined do continue
				local tvn
				if parent == undefined then
				(
					tvn = tv_nodes.add()
					tvn.text = c.name
					tvn.tag = c
				)
				else
				(
					-- add the tv node as a child
					tvn = tv_nodes.add parent.index 4 "" c.name 2
					
					 -- tag the tv node with the child
					tvn.tag = c
				)
				tvn.backcolor = tvBackcolor
				tvn.expanded = true
			)
		)
		
		function addSettoTreeView name = 
		(
			local ssNode = vTVSets.nodes.add nmsNode.index 4 "" name
			ssNode.expanded = false
			ssNode.backcolor = tvBackColor
			ssNode.tag = name
			ssNode.image = 1
			ssNode.sorted = true
			ssNode
		)
		
		function fUpdateTools sel: =
		(
			if sel == undefined then return()
			local btns = vToolbar.buttons
			if sel == unsupplied do sel = vTVSets.selectedItem			
			local scene = (selection.count > 0)			
			local list = if sel.parent == undefined then false else isSelSet sel.tag		
			local any = sel.parent != undefined
			
			vdelete.enabled = any
			vselectSet.enabled = any
			vselectName.enabled = true
			--vpick.enabled = list
			
			vadd.enabled = scene and any
			vsubtract.enabled = scene and any
			
			local cursel = getCurrentSelection()
			local setStr = if list then sel.text else if (isValidNode sel.tag) then sel.parent.text else ""
			local selStr = if cursel.count == 1 then cursel[1].name else cursel.count as string
			vStatusBar.simpleText = "{" + setStr + "} - " + "Selected: " + selStr
			
		)
	
		function fResetGUI =
		(
			local tv_nodes = vTVSets.nodes
			vTVSets.nodes.clear()
			nmsNode = tv_nodes.add()
			nmsNode.text = "Named Selection Sets"
			nmsNode.expanded = true
			nmsNode.backcolor = tvBackColor/*color 180 180 180*/
--			nmsNode.forecolor = red
--			nmsNode.bold = true
			nmsNode.sorted = true		
			vTVSets.selectedItem = nmsNode
			for i=1 to getNumNamedSelSets() do
			(
				local ssNode = addSetToTreeView (getNamedSelSetName i)			
				addNodesToTreeView tv_nodes selectionSets[i] parent:ssNode
			)
		)		
		function fRefresh =
		(
			local selIndex = if vTVSets.selectedItem == undefined then 1 else vTVSets.selectedItem.index
			fResetGUI()
			vTVSets.refresh()
			vTVSets.selectedItem = vTVSets.nodes[selIndex]
		)
		function fCreateSet =
		(
			local a, b=undefined, i=1
			while (b == undefined) do (
				local c = "New Set"
				if (i > 1) do c = c + " (" + (i as string) + ")"
				if (selectionSets[c] == undefined) then b = c
				else i = i + 1
			)			
			try selectionSets[c] = selection
			catch ()
			vTVSets.selectedItem = (addSettoTreeView c)
			addNodesToTreeView vTVSets.nodes (getCurrentSelection()) parent:vTVSets.selectedItem
			enableAccelerators = false
			vTVSets.startLabelEdit()
		)	
	
		function fAddObjects objs selSet:undefined mode:#add =
		(
			local s, t, sel = (if selSet == undefined then vTVSets.selectedItem else selSet)
			if objs == undefined or sel == undefined or sel.parent == undefined then return()	
			if (isValidNode sel.tag) then sel = sel.parent
			t = sel.text
			
			local u = #()
			try s = selectionSets[t]
			catch s = undefined
			if (s != undefined) do (
				u = for w in s collect w
				for w in objs do
				(
					local i = findItem u w
					if (mode == #subtract) then
					(
						if (i > 0) do 
						(
							vTVSets.nodes.remove (findChildNode sel u[i].name).index
							deleteItem u i
						)
					)
					else if (i == 0) do
					(
					 	append u w
						addNodesToTreeView vTVSets.nodes w parent:sel
					)
				)									
				selectionSets[t] = u				
			)
		)
		
		function fDeleteItem =
		(
			local sel = vTVSets.selectedItem			
			if (sel != undefined) do (
				local val = sel.tag
				if (classof val) == String and selectionSets[val] != undefined then
				(
					deleteItem selectionSets sel.text
					if sel.previous != undefined then vTVSets.selectedItem = sel.previous
					vTVSets.nodes.remove sel.index
				)
				else if (isValidNode val) then
				(
					fAddObjects val mode:#subtract
				)
			)
		)
		
		function fPickObjects = 
		(
			local objs = #()
			append objs (pickObject message:"Pick Objects to Add" /*count:#multiple*/)
			fAddObjects objs
			vToolbar.buttons[#pick].value = #tbrUnpressed
		)
		
		function fSelectObjects =
		(
			local selSet, o
			sel = vTVSets.selectedItem
			if sel.parent == undefined then return()	
			if (isValidNode sel.tag) then sel = sel.parent		
			try selSet = selectionSets[sel.text]
			catch selSet = undefined
			
			if (selSet!= undefined) do (
				clearSelection()
				
				local hidden_frozen = false
				local unset
				for o in selSet do
				(
					if o == undefined then continue
					if o.isHidden or o.isFrozen and unset == undefined then
					(
						hidden_frozen = true
						unset = QueryBox	"This set contains hidden and/or frozen objects.\nDo you want these objects to be unhidden and unfrozen?\n(Choosing \"No\" means that the hidden/frozen objects will become selected!)" \
											title:"3ds max"
					)
					if unset == true then ( o.isHidden = o.isFrozen = false )
					selectMore o
				)								
			)
		)
	
		function fChangeName completed =
		(
			if (vListSets.selection == 0) then (
				if (vEditName.text != "") do vEditName.text = ""
			) else if (completed) do (
				local s = vListSets.selected
				if ((findItem vListSets.items vEditName.text) > 0) then vEditName.text = s
				else (
					local u, w=#()
					for u in selectionSets[s] do append w u
					deleteItem selectionSets s
					selectionSets[vEditName.text] = w
					fShowSets()
					fSelectSet name:vEditName.text
				)
			)
		)
	
		function fSelQuery objs =
		(
			setWaitCursor()
			-- clear existing highlights
			for hn in highNodes do
			(
				try
				(
					hn.forecolor = black
					hn.bold = false
				) catch()
			)
			vTVSets.selectedItem = nmsNode			
			highNodes = #()
			local c = nmsNode.child
			for i=1 to nmsNode.children do
			(
				local qNodes = #()
				if objs.count == 0 then
				(
					c = c.next
					continue
				)				
				local has_one = false
				for o in objs do
				(
					local cNode = findChildNode c o.name
					if cNode != undefined then
					(	
						append qNodes cNode
						has_one = true
					)					
				)
				
				if has_one then
				(
					append highNodes c
					join highNodes qNodes					
				)
				c = c.next
			)
			if highNodes.count > 0 then highNodes[1].ensureVisible()
			-- highlight the nodes
			for hn in highNodes do
			(
				hn.bold = true
				hn.forecolor = if (isKindOf hn.tag String) then tvSetHighColor else tvNodeHighColor				
			)
			setArrowCursor()
		)
		
		function findNext =
		(
			if highNodes.count < 2 then return()
			local sel = vTVSets.selectedItem
			local c
			if sel == undefined then
				c = nmsNode.child
			else			
				c = if (isValidNode sel.tag) then sel.parent else if (isSelSet sel.tag) then sel else nmsNode.child
			while true do
			(
				c = if c.next == undefined then c.firstSibling else c.next
				if c.bold == true then
					( vTVSets.selectedItem = c; exit())				
			)
		)
	
		function fOpen =
		(
--			try 
			(	
				if GetCommandPanelTaskMode() == #modify and subobjectlevel > 0 then
					max rns
				else
				(
					local pos = execute (getIniSetting ini_file #general #position)
					local width = execute (getIniSetting ini_file #general #width)
					local height = execute (getIniSetting ini_file #general #height)
					
					if pos == ok then pos = [100, 100]					
					if width == ok then width = 340
					if height == ok then height = 375
					createDialog vEditNamedSelectionSets width:width height:height pos:pos \
						style:#(#style_titlebar, #style_sysmenu, #style_resizing, #style_minimizebox) escapeEnable:false
					registerViewWindow vEditNamedSelectionSets
				)
			)
--			catch ()
		)
		
		fn startEdit =
		(
			enableAccelerators = false
			if vTVSets.selectedItem.parent != undefined then
			(
				vTVSets.startLabelEdit()			
			)
		)
		
		fn executeButton name = 
		(
			undo on
			(
				case name of
				(
					#create:		fCreateSet()
					#delete:		fDeleteItem() 
					#add:			fAddObjects (getCurrentSelection())
					--#pick:		if btn.value == #tbrPressed then fPickObjects() else btn.value = #tbrPressed 
					#subtract:		fAddObjects (getCurrentSelection()) mode:#subtract
					#selectSet:		fSelectObjects()
					#selectName: 	
					(
						local objs = (selectByName title:"Select Objects")
						if objs != undefined then select objs
					)
					#query:			(fSelQuery selection)
				)
			)
		)
		
		fn tvClone tvNode kMove =
		(
			local objs = if isSelSet tvNode.tag then selectionSets[tvNode.text] else #(tvNode.tag)
			fAddObjects objs
			if kMove and not (isSelSet tvNode.tag) then
			(
				fAddObjects objs selSet:tvNode mode:#subtract			
			)
			gc light:true
		)
		
		on vEditNamedSelectionSets open do
		(
			vToolbar = sToolbar ()
			initTreeView vTVSets
			--initToolbar vToolbar
			initButtons ()
			initStatusBar vStatusbar
			fResetGUI()
			fUpdateTools()
			vTVSets.size = [vEditNamedSelectionSets.width,vEditNamedSelectionSets.height] - [20, 60]
			vStatusbar.pos = [10, vEditNamedSelectionSets.height-25]
			vStatusbar.size = [vEditNamedSelectionSets.width - 20, 20]
			
			callbacks.addScript #selectionSetChanged	"vEditNamedSelectionSets.fUpdateTools()" \
				id:#vEditNamedSelectionSets
			callbacks.addScript #filePostOpen			"vEditNamedSelectionSets.fResetGUI()" \
				id:#vEditNamedSelectionSets
			callbacks.addScript #systemPostReset		"vEditNamedSelectionSets.fResetGUI()" \
				id:#vEditNamedSelectionSets
			callbacks.addScript #systemPostNew			"vEditNamedSelectionSets.fResetGUI()" \
				id:#vEditNamedSelectionSets	
			callbacks.addScript #selectedNodesPostDelete "vEditNamedSelectionSets.fResetGUI()" \
				id:#vEditNamedSelectionSets	
			callbacks.addScript #nodeRenamed			"vEditNamedSelectionSets.fResetGUI()" \
				id:#vEditNamedSelectionSets
			callbacks.addScript #sceneNodeAdded			"vEditNamedSelectionSets.tmr.active=true" \
				id:#vEditNamedSelectionSets
			callbacks.addScript #sceneUndo				"vEditNamedSelectionSets.fResetGUI()" \
				id:#vEditNamedSelectionSets
			callbacks.addScript #sceneRedo				"vEditNamedSelectionSets.fResetGUI()" \
				id:#vEditNamedSelectionSets
			callbacks.addScript #systemPreReset			"destroyDialog vEditNamedSelectionSets" \
				id:#vEditNamedSelectionSets
			callbacks.addScript #systemPreNew			"destroyDialog vEditNamedSelectionSets" \
				id:#vEditNamedSelectionSets
			callbacks.addScript #filePreOpen			"destroyDialog vEditNamedSelectionSets" \
				id:#vEditNamedSelectionSets				
		)
		
		on vEditNamedSelectionSets close do 
		(
--			try 
			(
				callbacks.removeScripts id:#vEditNamedSelectionSets
				unRegisterViewWindow vEditNamedSelectionSets
				ensMenu.clone_node = undefined
				setIniSetting ini_file #general #position ((getDialogpos vEditNamedSelectionSets) as string)
				setIniSetting ini_file #general #width (vEditNamedSelectionSets.width as string)
				setIniSetting ini_file #general #height (vEditNamedSelectionSets.height as string)
			)
--			catch ()
		)
		
		on vEditNamedSelectionSets resized size do 
		(
			vTVSets.size = size - [20, 60]
			vStatusbar.pos = [10, size.y-25]
			vStatusbar.size = [size.x - 20, 20]
		)		
		
		on vToolbar buttonClick btn do executeButton (btn.key as name)
		
		-- button clicks
		on vCreate		pressed do executeButton #create
		on vDelete		pressed do executeButton #delete
		on vAdd			pressed do executeButton #add
		on vSubtract	pressed do executeButton #subtract
		on vSelectSet	pressed do executeButton #selectSet
		on vSelectName	pressed do executeButton #selectName
		on vQuery		pressed do executeButton #query
		
		on vTVSets keyUp KeyCode Shift do
		(
			print keyCode
			case keyCode of
			(
				kF5		: fRefresh()
				kF2 	: startEdit()
				kDelete	: fDeleteItem()				
			)
		)
		on vTVSets keyPress keyCode do
		(
			local sel = vTVSets.selectedItem
			case keyCode of
			(
				kCtrlX 	: if isValidNode sel.tag then ensMenu.mi_cut.picked()
				kCtrlC	: if isValidNode sel.tag then ensMenu.mi_copy.picked()
				kCtrlV	: if sel.parent != undefined then ensMenu.mi_paste.picked()
				kCtrlG  : findNext()
			)
		)		
		on vTVSets beforeLabelEdit cancel do enableAccelerators = false
		on vTVSets afterLabelEdit cancel newString do
		(
			if cancel==1 then return ()
			local sel = vTVSets.selectedItem
			local val = sel.tag			
			if isSelSet val then
			(
				local objs = for o in selectionSets[sel.text] collect o
				deleteItem selectionSets sel.text
				selectionSets[newString] = objs
				sel.tag = newString
			)
			else if (isValidNode val) then
			(
				val.name = newString
			)
		)
		
		on vTVSets MouseUp btn shift x y do
		(
			enableAccelerators = false			
			local sel = getHitNode()
			fUpdateTools()
			if btn == 2 and sel != undefined do
			(
				vTVSets.selectedItem = sel
				popupmenu ensMenu pop:[x, y] rollout:vEditNamedSelectionSets				
			)
		)
		
		on vTVSets DblClick do 
		( 
			local p = getCursorPos vTVSets
			if (vTVSets.hitTest (p.x*15) (p.y*15)) != undefined then
				vTVSets.selectedItem.expanded = not vTVSets.selectedItem.expanded
			local val = vTVSets.selectedItem.tag
			undo "Select Set" on
			(				
				if isSelSet val then
					fSelectObjects()
				else if (isValidNode val) then 
					select val
			)
		)
		
		on vTVSets OLEStartDrag data effects do
		(
			drag_node = getHitNode()
			if drag_node == undefined or drag_node.parent == undefined then return()
			mouse_icon = vTVSets.mouseIcon
			--vTVSets.mouseIcon = loadPicture (iconDir + "tvSet.ico")--ilTv.listImages[drag_node.image].picture
			--drag_node.createDragImage()
			showProperties data
--			data.clear()
		)
		
		on vTVSets OLEDragOver data Effect Button Shift x y State do
		(
			try
			(
				drop_node = getHitNode()
				if drop_node != undefined and isSelSet drop_node.tag then
				(
					if drop_node.text != drag_node.parent.text then
						vTVSets.selectedItem = drop_node --dropHighlight
					else
						vTVSets.selectedItem = undefined
				)
			)
			catch()
		)
		on vTVSets OLEDragDrop data Effect btn key x y do
		(
			if drop_node != undefined and (isSelSet drop_node.tag) then tvClone drag_node (key != kCtrl)			
		)
		on tmr tick do ( fRefresh(); tmr.active = false)
		on vTVSets OLECompleteDrag effect do 
		(
			if drop_node == undefined then ( tmr.active = true /*hack!!! refresh after drag&drop*/ ) 			drop_node = undefined
		)

		on vEditNamedSelectionSets help do
		(
			helpSys.help 3412
		)		
	)
	struct sToolbar (buttons=#())	
	vEditNamedSelectionSets.fOpen()
	
	/* eof */
	
)