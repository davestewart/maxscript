-------------------------------------------------------------------------------------------
--   File:			MergeAnimation.MS
--   Description:	A utility for merging complex animation between scenes
--   By:			Ravi Karra [Discreet] 			ravi.karra@autodesk.com
--					Randy Kreitzman [Discreet]		randy.kreitzman@autodesk.com
--   Created:		1/26/01
--	 Modified:		11/02/02
/*
	7/16/01
					Added support for CA's
	7/31/01
					Added auto name mapping button
					isAnimated state now checks for custom attributes
	11/05/02				
					Removed major chunk of old tree view related code
	08/11/03 - aszabo
					Added code to delete anim keys on CUstom Attributes of base object and modifier. 
					CAs on the character head's and member's material should not be deleted by the Reset All Animation command
*/
-------------------------------------------------------------------------------------------
  global gXmlIO, rObjectMapping, rMergeAnim, gEnableDebug 
  rollout rObjectMapping "Object Mapping" width:620 height:520
  (
	local cur_width=336, src_width=230, num_rolls = 0, sry = 0, merge_col = 1, enable_debug = if (gEnableDebug == undefined) then false else gEnableDebug

	-- Node level drag & drop variables
	local in_drop = false, drag_node, drop_node

	
	label 		lblCurrent	"Current Objects:"	pos:[src_width+25, 2]
	label 		lblSource	"Source Objects:"	pos:[05, 2]	
	editText 	etCurrent	"" 					pos:[(src_width+21), 015] width:(cur_width-16)	height:17
	button 		btnCurUpdate"U"					pos:[(cur_width+src_width+4), 015] width:20 height:17 tooltip:"Update Current List"
	editText 	etSource 	"" 					pos:[001, 015] width:(src_width-18) height:17
	button 		btnSrcUpdate"U"					pos:[(src_width-15), 015] width:20 height:17 tooltip:"Update Source List"

	button 		btnUp		"^"					pos:[src_width+5, 100] width:20 tooltip:"Move Up"
	button 		btnDel		"x"					pos:[src_width+5, 130] width:20 tooltip:"Clear Selected"
	button 		btnDn		"v"					pos:[src_width+5, 160] width:20 tooltip:"Move Down"
	button		btnAutoMap	"A"					pos:[src_width+5, 190] width:20 tooltip:"Auto Name Mapping"

	---------------------------------------------------------------------------------------
	groupBox grpDisplay		"Display Options" 	pos:[005,350] width:230 height:40
	---------------------------------------------------------------------------------------
	checkbox chkOnlyAnim 	"Show Animated Only"pos:[015,365] checked:false
	spinner	spnIndent 		"Indent:" 			pos:[175, 365] type:#integer range:[0,20,1] width:50

	button	 btnLoadMapping		"Load Mapping" 	pos:[250,365] width:100 height:20
	button	 btnSaveMapping		"Save Mapping" 	pos:[370,365] width:100 height:20

	activeXControl ilLv "{2C247F23-8591-11D1-B16A-00C0F0283628}" height:0 width:0
	activeXControl lvSource  "MSComctlLib.ListViewCtrl" pos:[005, 040] width:src_width				height:310	-- source objects listview
	activeXControl lvCurrent "MSComctlLib.ListViewCtrl" pos:[src_width+25, 040] width:cur_width 	height:310	-- current objects listview		  			

	fn sortList lv key =
	(
		setWaitCursor()
		lv.sortKey = key
		local order = lv.sortOrder
		lv.sortOrder = if order == #lvwAscending then #lvwDescending else #lvwAscending
		lv.sorted = true  -- sort for now
		lv.sorted = false -- disabling auto sorting
		setArrowCursor()
	)
	
	fn getHitNode ctrl =
	(
		local p = getCursorPos ctrl
		local calib = 15
		ctrl.HitTest ((p.x-2)*calib) ((p.y-2)*calib)
	)

	fn doRollup state = 
	(
		-- hack: have to special the 3rd one for some reason
		if state or num_rolls == 3 then sry = 400 else sry = 0 
		
		rMergeAnim.height = 250 + sry
		rMergeAnim.srRollouts.height = sry + 30
		--format "% % - % - %\n" num_rolls state sry rMergeAnim.srRollouts.height
		rMergeAnim.statusBar.pos = [5, sry + 225]
		rMergeAnim.pbStatus.pos = [360, sry + 226]		
		rMergeAnim.statusBar.size = [350, 20]
		num_rolls += 1
	)
	
	on rObjectMapping rolledUp state do
	(
		doRollup state
	)
	
	on rObjectMapping open do
	(
		-- set the up/down button images
--		try (
			local icon_dir = getDir #ui
			ilLv.imageHeight = ilLv.imageWidth = 4
			ilLv.listImages.add 1 "" (loadPicture (icon_dir + "\\icons\\tvObj.ico"))
			
			btnUp.images = #(icon_dir + "\\icons\\MergeAnim_24i.bmp", undefined, 4, 1, 1, 1, 1)
			btnDn.images = #(icon_dir + "\\icons\\MergeAnim_24i.bmp", undefined , 4, 2, 2, 2, 2)
			btnDel.images = #(icon_dir + "\\icons\\MergeAnim_24i.bmp", undefined, 4, 3, 3, 3, 3)
			btnAutoMap.images = #(icon_dir + "\\icons\\MergeAnim_24i.bmp", undefined, 4, 4, 4, 4, 4)
			
			btnCurUpdate.images = #(icon_dir + "\\icons\\MergeAnim_16i.bmp", icon_dir + "\\icons\\MergeAnim_16i.bmp", 1, 1, 1, 1, 1)
			btnSrcUpdate.images = #(icon_dir + "\\icons\\MergeAnim_16i.bmp", icon_dir + "\\icons\\MergeAnim_16i.bmp", 1, 1, 1, 1, 1)

			lvSource.smallIcons = lvCurrent.smallIcons = rObjectMapping.ilLv
--		) catch ()
	
	)
	
	on etCurrent entered val do rMergeAnim.updateCurrent()
	on etSource entered val do rMergeAnim.updateSource()
	on btnCurUpdate pressed do rMergeAnim.updateCurrent()
	on btnSrcUpdate pressed do rMergeAnim.updateSource()
	on chkOnlyAnim changed val do ( rMergeAnim.updateSource() )
	
	on btnUp pressed do
	(
		local items = lvCurrent.listItems
		if items.count == 0 or items[1].selected then return()
		rMergeAnim.moveItems items 2 items.count 1
	)	
	on btnDn pressed do
	(
		local items = lvCurrent.listItems
		if items.count == 0 or items[items.count].selected then return()
		rMergeAnim.moveItems items (items.count-1) 1 -1
	)
	on btnDel pressed do rMergeAnim.clearSelected lvCurrent
	on btnAutoMap pressed do 
	(
		setWaitCursor()
		rMergeAnim.setStatus "Auto Mapping..."
		local sidx = findString etSource.text "*"
		local cidx = findString etCurrent.text "*"
		item_count = lvSource.listItems.count
		local i=1
		
		-- first collapse to straight columns
		for lis in lvSource.listItems do 
		(
			local text = lis.text
			
			-- form the search string from prefix of current + suffix of source		
			if sidx != undefined then
				text = subString etCurrent.text 1 (cidx-1) + subString lis.text sidx (lis.text.count-sidx+1)
			
			-- find the list item and fillup the merge column
			local lv_node = lvCurrent.findItem text
			if lv_node != undefined then 
			(
				-- set the text and tag properties of the Listview's subitem
				setIndexedProperty lv_node #subItems merge_col lis.text
				-- copy the tv node tag to the list item tag
				lv_node.listSubItems[merge_col].tag = lis.tag				
			)
			rMergeAnim.pbStatus.value = 100.*i/item_count; i += 1
		)		
		lvCurrent.refresh()
		rMergeAnim.pbStatus.value = 0
		rMergeAnim.setStatus "Auto Mapping Completed"

	)
	on btnLoadMapping pressed do
	( 
		local f = getOpenFileName caption:"Open Merge Animation Mapping" types:"Mam Files (*.mam)|*.mam|All (*.*)|*.*|"
		if f != undefined then
		(
			rMergeAnim.map_stream = openFile f
			rMergeAnim.loadMapping()
			close rMergeAnim.map_stream
			rMergeAnim.setStatus "Mapping file loaded"
		)
	)
	on btnSaveMapping pressed do 
	( 
		local f = getSaveFileName caption:"Save Merge Animation Mapping" types:"Mam Files (*.mam)|*.mam|All (*.*)|*.*|"
		if f != undefined then
		(
			rMergeAnim.map_stream = createFile f
			rMergeAnim.saveMapping()
			close rMergeAnim.map_stream
		)		
--		print map_stream
	)
	
	
	on lvCurrent ItemClick lvn do
	(
		lvn = lvCurrent.selectedItem
		if lvn != undefined then
		(
			lvCurrent.dropHighlight = undefined
			local si = lvn.listSubItems[merge_col]
			rMergeAnim.setStatus (if si == undefined or rMergeAnim.xml_input or (getNodeByName si.text) ==  undefined then "" else ("Animation From: " + si.tag.name))
		)
	)
	on lvCurrent columnClick columnHeader do sortList lvCurrent (columnHeader.index - 1)
	on lvSource columnClick columnHeader do sortList lvSource (columnHeader.index - 1)
	on lvSource ItemClick lvn do
	(
		lvn = lvSource.selectedItem
		if lvn != undefined then
		(
			rMergeAnim.setStatus (if rMergeAnim.xml_input then (rMergeAnim.xmlIO.getAttribute (rMergeAnim.xmlIO.xmlDoc.selectSingleNode ("//object[@id='" + lvn.tag + "']")) "name") else lvn.tag.name)
		)
	)

	-------------------------------------------------------------------------------------------
	-- All the drag & drop stuff
	-------------------------------------------------------------------------------------------
	on lvSource OLEStartDrag DataObject Effects do
	(
		in_drop = true
	)
	on lvCurrent OLEDragOver DataObject Effect Button Shift x y State do
	(
		try
		(
			local high_node = getHitNode lvCurrent
			lvCurrent.multiselect = false
			lvCurrent.selectedItem = high_node --dropHighlight
			lvCurrent.multiselect = true
		)
		catch( high_node = undefined )
	)
	on lvCurrent OLEDragDrop DataObject Effect Button key x y do
	(
		in_drop = false
--		try
		(
			drop_node = getHitNode lvCurrent
			-- clear the existing selection				
			for li in lvCurrent.listItems do li.selected = false
			lvCurrent.selectedItem = drop_node
			
			if drop_node != undefined then
			(
				local drag_nodes = #(), from_index, to_index, lv_items = lvCurrent.listItems, drop_index = drop_node.index, lv_node
					for li in lvSource.listItems do if li.selected then append drag_nodes li
					from_index = 1
					to_index = drag_nodes.count
--					format "% - %\n" from_index to_index
					for i = from_index to to_index do
					(
						lv_node = lv_items[drop_index + i - from_index]
						if lv_node == undefined then exit () -- might have reached the end
						
						-- set the text and tag properties of the Listview's subitem
						setIndexedProperty lv_node #subItems merge_col drag_nodes[i].text
			
						-- copy the tv node tag to the list item tag
						lv_node.listSubItems[merge_col].tag = drag_nodes[i].tag						
					)
					lvCurrent.refresh()
					enableAccelerators = false
					lvCurrent.dropHighlight = undefined
					gc()
			)
		)
--		catch( )
	)
	on lvCurrent dblclick do
	( 
		lvItem = lvCurrent.selectedItem
		if lvItem != undefined and lvItem.tag != undefined then select lvItem.tag
	)
	on lvCurrent click do enableAccelerators = false
	on lvCurrent keypress key do
	( 
--		print key
		if ( key==32 or key==8 or key==100) do -- ASCII value for SPACEBAR, BACKSPACE and DELETE
		(
			rMergeAnim.clearSelected lvCurrent
		)
	)
  )
  rollout rMergeAnim "Merge Animation" width:620
  (
	local xmlIO, dontFilterChildren = false, current_range = interval 0 0
	local	merge_col = 1, xml_input = false, 
			ini_file = ini_file = ((getDir #plugcfg) + "\\mergeAnim.ini"),
			is_holding = false, hold_objects = #(), hold_file = ((getDir #autoback) + "\\__merge_anim.mx") -- hold related
			
	local file_name = undefined, new_xref, new_tree, current_nodes, source_nodes, src_node, whenHandle, mergAnimID = 0x1ef782c5, map_stream, replaceController_fn
	
	local lvSource, lvCurrent, show_messages = true
	
	-- various colors
	local anim_color = 255, proc_color = 16744192, err_color = 1777088

	-- Sub-anim level drag & drop variables
	local in_sub_drop = false, sub_drag_node, sub_drop_node
	
	-- Temporary vertical UI offset
	local offset = -140, offset2 = 51, x_offset = 260, my = -70, aty = -210, ax = 500, ay = 100, sy = 5
	
	-- Merge variables
	local mergeNodeArray = #(), new_tree_count = 0

	-- Procedural types
	local proc_types = #(
			position_script,
			rotation_script,
			scale_script,
			float_script,
			position_expression,
			scale_expression,
			float_expression,
			position_wire,
			rotation_wire,
			scale_wire,
			float_wire	
			)
			
	-- counters
	local savedNodes=0, loadedNodes=0, obj_count = 1

	---------------------------------------------------------------------------------------
	groupBox grpFile		"Source Objects"	pos:[005,sy] width:605 height:50
	---------------------------------------------------------------------------------------	
	button	 btnSource		"Source File" 		pos:[010,sy+020] width:100 height:20
	button	 btnSourceObj	"Source Object" 	pos:[120,sy+020] width:100 height:20	
	label 	 lblProps		""  				pos:[230,sy+010] width:379 height:30		-- file properties

	button 	 btnSave2XML	"Save Scene to XML"	pos:[ax+15,ay+015] width:100 height:20
	button	 btnMerge		"Merge Animation"	pos:[ax+15,ay+045] width:100 height:20
	button	 btnFetch		"Undo Last Merge"	pos:[ax+15,ay+075] width:100 height:20 enabled:false
		
	---------------------------------------------------------------------------------------
	groupBox grpSource		"Source Time Range" pos:[005,125+my] width:250 height:142
	---------------------------------------------------------------------------------------
	radiobuttons rb_ctrl						pos:[010,140+my] labels:#("Replace Animation", "Paste to Existing Animation") columns:1 default:1
	
	checkbox cb_matchRange	"Match Source File Time" pos:[15,175+my] width:130 highlightColor:green enabled:false
	spinner	s_startTime		"Start Time:" 		pos:[20,195+my] type:#integer fieldwidth:35 range:[-100000,100000,animationRange.start] enabled:false
	spinner	s_endTime		"End Time: " 		pos:[130,195+my] type:#integer fieldwidth:35 range:[-100000,100000,animationRange.end] enabled:false

	spinner s_insert "Insert Animation to Frame:" pos:[30,215+my] type:#integer fieldwidth:30 range:[-100000,100000,currentTime]
	radiobuttons rb_relAbs						pos:[15,230+my] labels:#("Relative", "Absolute") enabled:false columns:2

	checkbox chkAdjustTimeRange "Adjust Current Time Range" pos:[15,245+my] width:180 height:20 highlightColor:(color 0 255 0) enabled:true
	
	---------------------------------------------------------------------------------------
	groupBox grpApply 		"Apply To" 		pos:[x_offset,265 +aty] width:250 height:140
	---------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------
	groupBox grpMainAttribs "Main Attributes" pos:[x_offset+5,(280 + aty)] width:120 height:120
	---------------------------------------------------------------------------------------
	checkbox chkTransform 	"Transform" 	pos:[x_offset+10,(300 + aty)] height:015 checked:true
	checkbox chkIK			"IK"			pos:[x_offset+85,(300 + aty)] width:30 height:015 checked:true
	checkbox chkPosition 	"Position" 		pos:[x_offset+20,(320 + aty)] width:80 height:015 checked:true
	checkbox chkRotation 	"Rotation" 		pos:[x_offset+20,(340 + aty)] width:80 height:015 checked:true
	checkbox chkScale 		"Scale" 		pos:[x_offset+20,(360 + aty)] width:80 height:015 checked:true
	checkbox chkModifiers 	"Modifiers" 	pos:[x_offset+10,(380 + aty)] width:80 height:015 checked:true
	
	---------------------------------------------------------------------------------------
	groupBox grpMoreAttribs "More Attributes" pos:[x_offset+130,(280 + aty)] width:115 height:120
	---------------------------------------------------------------------------------------
	checkbox chkCustAttrib 	"Custom Attributes" pos:[x_offset+135,(300 + aty)] width:100 height:015 checked:true
	checkbox chkAddNewDefs	"Add New Defs" 	pos:[x_offset+140,(320 + aty)] width:95 height:015 checked:true
	checkbox chkBaseObject 	"Base Objects" 	pos:[x_offset+135,(340 + aty)] width:100 height:015 checked:false
	checkbox chkMaterials 	"Materials/Maps"pos:[x_offset+135,(360 + aty)] width:100 height:015 checked:false
	checkbox chkVisTracks 	"Visibility Tracks" pos:[x_offset+135,(380 + aty)] width:100 height:015 checked:false


	subRollout srRollouts	""				pos:[005,200] width:610 rolledUp:true
	activeXControl statusBar "MSComctlLib.SBarCtrl" -- status bar	
	progressBar  pbStatus	 ""				width:255 height:20 color:blue
	---------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------
	fn highlight tvNode subAnim =
	(
		if xmlio.isAnimated subAnim do ( tvNode.forecolor = anim_color; tvNode.bold = true )
	)
	
	fn hasProcedural node =
	(
		local tm = node[3].controller
		if tm == undefined then return false
		if (classof tm.controller) == transform_script then return true
		for i=1 to tm.numSubs do
		(
			local sa = getSubAnim tm i
--			format " %->% - %\n" node.name (getSubAnimName tm i) (classof sa.controller) as string
			if sa != undefined and ((findItem proc_types (classof sa.controller)) != 0) then
			(
				return true
			)
		)
		false
	)
	
	fn hasXMLProcedural xmlNode =
	(
		local tm = xmlNode.selectSingleNode (#transform as string) 
		if tm == undefined then return false
		if (xmlIO.getAttribute tm #classOf) == "transform_script" then return true
		for c in tm.childNodes do
		(
			if (findItem class_types (xmlIO.getAttribute c #classOf)) != 0 then
				return true
		)
		false
	)	
	
	fn getNodeByHandle handle = 
	(
		for o in objects do if o.handle == handle then return o
		undefined
	)
	-------------------------------------------------------------------------------------------
	-- Statusbar functions
	-------------------------------------------------------------------------------------------
	fn initStatusBar = 
	(
		statusBar.style = #sbrSimple
		statusBar.simpleText = ""
	)
	fn setStatus text error:false =
	(
		statusBar.simpleText = (if error then "E R R O R: " else "") + text
		statusBar.font.bold = error
	)
	-------------------------------------------------------------------------------------------
	-- Listview functions
	-------------------------------------------------------------------------------------------	
	fn initListView lv =
	(
		enableAccelerators = false		
		lv.gridLines = true
		lv.borderStyle = #ccFixedSingle
		lv.view = #lvwReport
		lv.fullRowSelect = true
		lv.multiSelect = true
		lv.labelEdit = #lvwManual
		lv.hideSelection = false
		lv.sortOrder = #lvwAscending		
	)
	fn clearSelected lv = 
	(
		local item_count = lv.listItems.count
		for i = 1 to item_count do
		(
			local li = lv.listItems[i]
			if li.selected and li.listSubItems.count > 0 then
			(
				 li.listSubItems[merge_col].text = ""
				 li.listSubItems.remove merge_col -- delete the merge cel entry
			)
		)
	)
	fn swapItems li1 li2 = 
	(
		local text1, text2, tag1, sel1 = li1.selected
		text1 = getIndexedProperty li1 #subItems merge_col
		text2 = getIndexedProperty li2 #subItems merge_col
		tag1  = if text1 != "" then li1.listSubItems[merge_col].tag else ""
		
		li1.selected = li2.selected
		li2.selected = sel1
		
		if text2 == "" then
		(
			li1.listSubItems.remove 1
		)
		else
		(
			setIndexedProperty li1 #subItems merge_col text2
			li1.listSubItems[merge_col].tag = li2.listSubItems[merge_col].tag			
		)
		if text1 == "" then
		(
			li2.listSubItems.remove 1
		)
		else
		(
			setIndexedProperty li2 #subItems merge_col text1
			li2.listSubItems[merge_col].tag = tag1			
		)		
	)
	fn moveItems items start end byNum=
	(
		setWaitCursor()
		for i=start to end by byNum do
		(
			if not items[i-byNum].selected and items[i].selected do
			(
			 	start = i
				exit
			)			
		)		
		for i = start to end by byNum do
		(
			local si = getIndexedProperty items[i] #subItems merge_col
			if items[i].selected and si != "" and si != undefined then
				swapItems items[i] items[i-byNum]
		)
		setArrowCursor()
	)
	
	fn addNodesToListView lv max_nodes pattern_string:undefined recurse:true indent:0 =
	(
--		gc()
		local lv_nodes = lv.listItems
		for i=1 to max_nodes.count do
		(
			local c = max_nodes[i], animated = xmlio.isAnimated c, add_node = (c.name != "_merge_anim"), lvn
			
			-- do node filtering based upon the pattern string
			if add_node and pattern_string != undefined and pattern_string != "" then
			(
				add_node = if pattern_string == "$" then c.isSelected else matchPattern c.name pattern:pattern_string
			)
				
			-- do node filtering based "Show Animated" checkbox status
			if add_node and rObjectMapping.chkOnlyAnim.checked then
				add_node = animated
			
			if add_node then
			(
				lvn = lv_nodes.add()
				lvn.text = c.name
				listView.setIndent lv.hwnd lvn.index indent
				lvn.tag = c -- save a pointer to the node in the tag property
				
				if (hasProcedural c) then
				(

					lvn.forecolor = proc_color
					lvn.bold = true
				)
				else if animated and not rObjectMapping.chkOnlyAnim.checked do
				(
					lvn.forecolor = anim_color
					lvn.bold = true
				)				
			)
			if recurse and c.name != "_merge_anim" then
				addNodesToListView lv c.children pattern_string:(if dontFilterChildren then undefined else pattern_string) recurse:recurse indent:(indent + rObjectMapping.spnIndent.value)
		)
	)
	
	fn addXMLNodesToListView lv xml_nodes pattern_string:undefined recurse:true indent:0 =
	(
--		gc()
		local lv_nodes = lv.ListItems
		for i=0 to (xml_nodes.length-1) do
		(
			local c = xml_nodes[i], animated = ((xmlIO.getAttribute c "isAnimated")=="true"), add_node = true, lvn
			-- do node filtering based upon the pattern string
			if add_node and pattern_string != undefined and pattern_string != "" then
			(
				add_node = if pattern_string == "$" then c.isSelected else matchPattern (xmlIO.getAttribute c "name") pattern:pattern_string
			)
				
			-- do node filtering based "Show Animated" checkbox status
			if add_node and rObjectMapping.chkOnlyAnim.checked then
				add_node = animated
			
			if add_node then
			(
				lvn = lv_nodes.add()
				lvn.text = (xmlIO.getAttribute c "name")
				listView.setIndent lv.hwnd lvn.index indent
				lvn.tag = xmlIO.getAttribute c "id" -- save the node handle in the tag property
				
				if (hasXMLProcedural c) then
				(
					lvn.forecolor = proc_color
					lvn.bold = true
				)
				else if animated and not rObjectMapping.chkOnlyAnim.checked do
				(
					lvn.forecolor = anim_color
					lvn.bold = true
				)				
			)
			if recurse then
				addXMLNodesToListView lv (c.selectNodes "children/object") pattern_string:(if dontFilterChildren then undefined else pattern_string) recurse:recurse indent:(indent + rObjectMapping.spnIndent.value)
		)
	)		

	-------------------------------------------------------------------------------------------
	-- Update functions
	-------------------------------------------------------------------------------------------	
	fn updateCurrent = 
	(
		 if lvCurrent.listItems == undefined then return()
		--		if not (queryBox "This operation will clear the merge list, do you want to proceed" title:"Info") then return()+
		local text = rObjectMapping.etCurrent.text
		setWaitCursor()
		lvCurrent.listItems.clear()
		lvCurrent.sorted = false
		
		current_nodes = if text == "$" then selection else rootNode.children
		addNodesToListView lvCurrent current_nodes pattern_string:text recurse:(if text == "$" then false else true) 
		setArrowCursor()

	)
	fn updateSource = 	
	(
		if lvSource.listItems == undefined then return()
		local text = rObjectMapping.etSource.text
		if new_tree == undefined then return()
		setWaitCursor()		
		lvSource.listItems.clear()
		if xml_input then
			addXMLNodesToListView lvSource source_nodes pattern_string:(if text == "$" then undefined else text) recurse:true
		else
			addNodesToListView lvSource source_nodes pattern_string:(if text == "$" then undefined else text) recurse:true
		setArrowCursor()
	)	
	
	fn updateCurrentList reload:true =
	(
		local srcSel, curSel
		try if rMergeAnim.lvCurrent.selectedItem != undefined do curSel = rMergeAnim.lvCurrent.selectedItem.index
		catch()
		if reload then
			rMergeAnim.current_nodes = rootNode.children
		updateCurrent()
		try if curSel != undefined do rMergeAnim.lvCurrent.selectedItem = rMergeAnim.lvCurrent.nodes[curSel]
		catch()		
	)	
	-------------------------------------------------------------------------------------------
	-- Animation functions
	-------------------------------------------------------------------------------------------
	-- getRefTarget() recursively tracks down dependencies in a copied controller's reference hierarchy !!CURRENTLY NOT IN USE!!
	fn getRefTarget fromNodeCtrl nodeArray =
	(
		for i = 1 to fromNodeCtrl.numsubs do
		(
			if fromNodeCtrl[i].controller != undefined do
			(
				getRefTarget fromNodeCtrl[i].controller nodeArray
			)
		)
		-- Collect fromNodeCtrl root node reference for later comparison
		local nodeArray2 = #()
		for t in (refs.dependents fromNodeCtrl) do
		(
			if (isKindOf t node) do
			(
				-- Hack to filter out classOf "node" objects
				try
				(
					t.name
					if (findItem nodeArray2 t) == 0 do append nodeArray2 t
				)
				catch()
			)
		)
		for r in (refs.dependsOn fromNodeCtrl) do
		(
			-- Depends on PB1/PB2 Reference Target (Path, Positon, Link constraint, etc...)
			if (findString (r as string) "ReferenceTarget:") != undefined do
			(
				local ref = refs.dependsOn r
				for t in ref do
				(
					if (isKindOf t node) then
					(
						if (findItem nodeArray t) == 0 do append nodeArray t
					)
					else if ref.count == 1 do r = t
				)
			)
			-- Depends on sub-anim controller (Param wires, instanced controllers, etc.)
			if (findString ((superClassOf r) as string) "Controller") != undefined do
			(
				local ref = refs.dependents r
				for t in ref do
 				(
					if (isKindOf t node) do
					(
						-- Hack to filter out classOf "node" objects
						try
						(
							t.name
							if (findItem nodeArray t) == 0 and (findItem nodeArray2 t) == 0 do append nodeArray t
						)
						catch()
					)
				)
			)
			-- Depends directly on node (Expression controller absolute node reference)
			if (isKindOf r node) do
			(
				-- Hack to filter out classOf "node" objects
				try
				(
					r.name
					if (findItem nodeArray r) == 0 do append nodeArray r
				)
				catch()
			)
		)
		nodeArray
	)
	
	fn traverseSubAnims fromNodeCtrl toNodeCtrl =
	(
		for i = 1 to fromNodeCtrl.numsubs do
		(
			local sub_anim = getSubAnimName fromNodeCtrl i
--			if rObjectMapping.enable_debug do format "%(%) -- %(%)\n" fromNodeCtrl[i] fromNodeCtrl[i].controller toNodeCtrl[sub_anim] toNodeCtrl[sub_anim].controller			
			if (toNodeCtrl[sub_anim] != undefined) then
			(
				if fromNodeCtrl[i].controller != undefined then 
					replaceController_fn fromNodeCtrl[i].controller &toNodeCtrl[sub_anim]
				else
					traverseSubAnims fromNodeCtrl[i] toNodeCtrl[sub_anim]
			)
		)
	)
	
	fn createControllerHeirarchy fromNodeCtrl &toNodeCtrl =
	(
		toNodeCtrl.controller = createInstance (classof fromNodeCtrl) --execute (classOf fromNodeCtrl as string + "()")
		if ( list_ctrl = (findString (classOf toNodeCtrl.controller as string) "_list") != undefined ) then
		(
			-- also create the sub anim controllers
			for i=1 to (fromNodeCtrl.NumSubs-1) do -- -1 for skipping available slot
				createControllerHeirarchy fromNodeCtrl[i].controller &toNodeCtrl["available"]
		)
	)
	
	-- replaceController() copies/pastes all keys from the source controller to the destination controller, overwriting existing keys
	fn replaceController fromNodeCtrl &toNodeCtrl =
	(		
		if fromNodeCtrl == undefined then return()
		
		-- Assign a new controller to a non-animated parameter, if necessary		
		try(
			if toNodeCtrl.controller == undefined or (classOf fromNodeCtrl) != (classOf toNodeCtrl.controller) do createControllerHeirarchy fromNodeCtrl &toNodeCtrl
		) catch( if rObjectMapping.enable_debug then format "  Merge Error : Controller conversion % -> % \n" fromNodeCtrl toNodeCtrl)		
		
		-- Filter out incompatible controllers (such as Bezier_Position and Position_XYZ)
		if (classOf fromNodeCtrl) != (classOf toNodeCtrl.controller) do return()		
		
		-- Filter out Position/Euler XYZ controllers which return an invalid key array
		if (findItem #(Position_XYZ, Euler_XYZ, Master_Point_Controller) (classOf fromNodeCtrl)) == 0 do 
		(	
			try	(
				-- Filter out all but key-framed controllers
				if fromNodeCtrl.keys.count > 0 and toNodeCtrl.controller != fromNodeCtrl do with animate off 	(
			source_range = (getTimeRange fromNodeCtrl) -- DMW
			if source_range.start < current_range.start do current_range.start = source_range.start  -- DMW
			if source_range.end > current_range.end do current_range.end = source_range.end          -- DMW		
				
					deleteKeys toNodeCtrl.controller #allkeys
					for k in fromNodeCtrl.keys do					(
						appendKey toNodeCtrl.controller.keys k
					)
				)
			) catch	( if rObjectMapping.enable_debug then format "Cannot access keys for controller: % -> %\n " fromNodeCtrl toNodeCtrl )
		)		
		-- Recursively traverse controller sub-anim tree looking for sub-controllers
		traverseSubAnims fromNodeCtrl toNodeCtrl
	)
	
	-- pasteToActiveCtrl() copies/pastes a range of keys (relative/absolute) from the source controller to the destination controller at an optional insertion point
	fn pasteToActiveCtrl fromNodeCtrl &toNodeCtrl =
	(
		local 	source_range, toKeyArray = #(),
				insert_time = s_insert.value, 
				tempCtrl, toNodeVal = toNodeCtrl.value, deltaVal, fromCtrl, toCtrl,
				list_ctrl = (findString (classOf toNodeCtrl.controller as string) "_list") != undefined
		
		local deps = refs.dependents toNodeCtrl.controller		
		if fromNodeCtrl == undefined or ( findItem proc_types (classOf fromNodeCtrl) ) != 0 or (findItem proc_types (classOf toNodeCtrl.controller) ) != 0  do
		(
			if rObjectMapping.enable_debug then
				format  "skipping % --> %\n" fromNodeCtrl toNodeCtrl.controller
			return()	
		)
		fromCtrl = fromNodeCtrl		
		
		-- If toNodeCtrl is a list controller then send the active controller downstream as toCtrl
		if list_ctrl and false then
		(
			if rObjectMapping.enable_debug then
				format  "list controller % --> %\n" fromCtrl toNodeCtrl.controller

			-- If the active controller is "Available" then create a new controller
			local listI = toNodeCtrl.controller.getActive()
			local activeAnim = toNodeCtrl.controller[listI] 
			if listI==0 and activeAnim == undefined then 
			(
				toNodeCtrl.available.controller = createInstance (classof fromCtrl)
				listI = 1
			)
			else if listI == 1 do 
			(
				local activeCtrl = activeAnim.controller				if activeCtrl == undefined or (classOf fromNodeCtrl) != (classOf activeCtrl) do
				(
					if rObjectMapping.enable_debug then
						format "overwritten:% --> %\n" activeAnim.controller (refs.dependents toNodeCtrl.controller)
					activeAnim.controller = createInstance (classof fromCtrl)
				)
			)
			toCtrl = toNodeCtrl.controller[listI].controller
			
			toCtrl = createInstance (classof fromCtrl)
			toNodeCtrl.available.controller = toCtrl
			toNodeCtrl.controller.setActive toNodeCtrl.controller.count
--			format "list -- % - %\n" listI toNodeCtrl
		)	
		else	
		(		
			-- Assign a new controller to a non-animated parameter, if necessary
--			try(
				if toNodeCtrl.controller == undefined or (classOf fromNodeCtrl) != (classOf toNodeCtrl.controller) do
				(
					if rObjectMapping.enable_debug then
						format "overwritten:% --> %\n" toNodeCtrl.controller (refs.dependents toNodeCtrl.controller)
					toNodeCtrl.controller = createInstance (classof fromNodeCtrl)
				)
--			) catch( if rObjectMapping.enable_debug then format "  Merge Error : Controller conversion % -> % \n" fromNodeCtrl toNodeCtrl)		
			-- Filter out incompatible controllers (such as Bezier_Position and Position_XYZ)
			if (classOf fromCtrl) != (classOf toNodeCtrl.controller) do return()
			toCtrl = toNodeCtrl.controller
		)
		
		-- Filter out Position/Euler XYZ controllers which return an invalid key array
		if ( (findItem #(Position_XYZ, Euler_XYZ, Master_Point_Controller) (classOf fromCtrl)) == 0) and 
				fromNodeCtrl.keys.count > 0 and toNodeCtrl.controller != fromNodeCtrl do with animate off
		(	
			local ctrlTime, keyTimes = #()
			-- Start building/parsing toCtrl key array
			if cb_matchRange.checked then source_range = (getTimeRange fromCtrl)
			else
			(
				source_range = interval s_startTime.value s_endTime.value
				if source_range.start > (getTimeRange fromCtrl).start do addNewKey fromCtrl source_range.start
				if source_range.end < (getTimeRange fromCtrl).end do addNewKey fromCtrl source_range.end
			)
		if source_range.start < current_range.start do current_range.start = source_range.start
		if source_range.end > current_range.end do current_range.end = source_range.end

			-- Relative offset for fromCtrl values
			if rb_relAbs.state == 1 do
			(
				local toVal = (at time insert_time toCtrl.value)
				local fromVal = (at time source_range.start fromCtrl.value)
				if toVal == undefined then toVal = 0
				if fromVal == undefined then fromVal = 0				
				deltaVal =  toVal - fromVal
--				format "deltaVal:%\n" deltaVal
				ctrlTime = fromCtrl.value
				fromCtrl.value += deltaVal
			)
			-- Offset key times if "Insertion Time" is checked
			for ki=1 to fromCtrl.keys.count do
			(
				--local k = if (isKindOf fromCtrl BipSlave_Control) then (biped.getKey fromCtrl ki) else (getKey fromCtrl ki)
				local k = getKey fromCtrl ki
				if (k.time >= source_range.start) and (k.time <= source_range.end) do
				(
					append keyTimes k.time
					k.time += (insert_time - source_range.start)
					append toKeyArray k
				)
			)
			-- Select toCtrl keys to be deleted
			deselectKeys toCtrl
			for k in toCtrl.keys where (k.time > insert_time) and (k.time < (source_range.end + (insert_time - source_range.start))) do selectKeys toCtrl k.time
			deleteKeys toCtrl #selection
			-- Append toKeyArray to toCtrl(destination) key-array
			for ki=1 to toKeyArray.count do
			(
				local k = toKeyArray[ki]
				if (getKeyIndex toCtrl k.time) == 0 do
				(
	/*				if (isKindOf toCtrl BipSlave_Control) then
				(
					local bk = (biped.addNewKey toCtrl k.time)
					for kp in getPropNames k where kp != #selected and kp != #type do
						setProperty bk kp (getProperty k kp)
				)
				else
	*/					appendKey toCtrl.keys k
				)
				k.time = keyTimes[ki] -- restore the original key time				
			)
			sortKeys toCtrl			
			if rb_relAbs.state == 1 do fromCtrl.value = ctrlTime-- restore the original value


		)
		-- Recursively traverse controller sub-anim tree looking for sub-controllers
		for i = 1 to fromNodeCtrl.numsubs do
		(
			--print fromNodeCtrl[i]
			local sub_anim = getSubAnimName fromNodeCtrl i
			--format "paste anim: % - % -  %\n" sub_anim fromNodeCtrl[i].controller toCtrl[sub_anim]
			if fromNodeCtrl[i].controller != undefined and toCtrl[sub_anim] != undefined do 
				pasteToActiveCtrl fromNodeCtrl[i].controller &toCtrl[sub_anim]
		)

	)
	
	-- Support for animated custom attributes
	fn getDefIndex obj str = 
	(
		local defs = custAttributes.getDefs obj
		if defs == undefined then return undefined
		local idx = 1
		for ca in defs do 
		(
			if ca.name == str do return idx
			idx += 1 
		)
		undefined
	)	
	fn replaceCAAnim fromAnim toAnim =
	(
		if chkCustAttrib.checked do
		(
			for c = 1 to (custAttributes.count fromAnim) do
			(
				local def = custAttributes.getDef fromAnim c
				local fca = custAttributes.get fromAnim c				local idx = getDefIndex toAnim def.name
				CAT_CurrentDef = def -- fix for #470704
				
				-- delete the def if it already exists in the dest anim
				--if idx != undefined do custAttributes.delete toAnim idx
				
				-- add the definition from the source anim, and make it unique
				if idx == undefined then
				(
					if chkAddNewDefs.checked then
					(
						if rObjectMapping.enable_debug then
							format "Adding new def%\n%\n" def (custAttributes.getDefSource def)
						custAttributes.add toAnim (execute (custAttributes.getDefSource def))
						idx = (custAttributes.count toAnim)
					)
					else continue;
				)				
				-- now get the dest CA
				local tca = custAttributes.get toAnim idx				
				-- copy the animation
				for j = 1 to fca.numsubs do if j <= tca.numSubs do
				(
					local fromSubAnim = fca[j]; if fromSubAnim.controller == undefined do continue
					if fromSubAnim.isAnimated do case rb_ctrl.state of
					(
						1:	replaceController fromSubAnim.controller &tca[getSubAnimName fca j] 
						2:	pasteToActiveCtrl fromSubAnim.controller &tca[getSubAnimName fca j]
					)
				)
			)
		)
	)
	-- replaceNodeAnim specifies which node sub-anims are sent to replaceController() and pasteToActiveCtrl()
	fn replaceNodeAnim fromNode toNode recurse =
	(
		if fromNode == undefined or toNode == undefined or (isDeleted fromNode) or (isDeleted toNode) then return()
		if recurse do for i=1 to fromNode.children.count do replaceNodeAnim fromNode.children[i] toNode.children[i] recurse
		-- Visibility tracks
		if chkVisTracks.checked and fromNode[1].controller != undefined do
		(
			if toNode[1].controller == undefined then
			(
				animate on (at time 100 toNode.visibility = false)
			)
			case rb_ctrl.state of
			(
				1:	replaceController fromNode[1].controller &toNode[1] 
				2:	pasteToActiveCtrl fromNode[1].controller &toNode[1]
			)
		)
		-- Filter out IK-controlled objects to be dealt downstream
		if (findString (classOf fromNode.controller as string) "IK") == undefined and (findString (classOf toNode.controller as string) "IK") == undefined then
		(
			if chkTransform.checked do
		(
			local chkArray = #(chkPosition.checked, chkRotation.checked, chkScale.checked)
			local toNodeCtrl = toNode.controller
			local tmc = fromNode.controller
			
			if (classOf toNodeCtrl) != (classof tmc) do (toNodeCtrl = toNode.controller = copy tmc)
			if (isKindOf tmc Link_Constraint) do
			(
				tmc = tmc[1];toNodeCtrl = toNodeCtrl[1]			)
			-- Go through transform sub-anims (PRS)
			if (classof tmc) == prs then
			(
				for j = 1 to 3 do
				(
					if chkArray[j] do case rb_ctrl.state of
					(
						1:	replaceController tmc[j].controller &toNodeCtrl[j]
						2:	pasteToActiveCtrl tmc[j].controller &toNodeCtrl[j]
					)
				)
			)
			else
			(
				for j=1 to tmc.numSubs do
				(
					case rb_ctrl.state of
					(
						1:	replaceController tmc[j].controller &toNodeCtrl[j]
						2:	pasteToActiveCtrl tmc[j].controller &toNodeCtrl[j]
					)
				)
			)
		)
		)
		-- Specific to IK-controlled nodes
		else if chkIK.checked then
		(
			local chkArray = #(chkPosition.checked, chkRotation.checked, chkScale.checked)
			local tmc = fromNode.controller
			-- Pasting from IK goal objects
			if (isKindOf tmc IKChainControl) then
			(
				-- Only paste IK goal's transform controller to non-IK goal object
				if (classof toNode.controller) != (classof tmc) then for j = 1 to 3 do
				(
					if chkArray[j] do case rb_ctrl.state of
					(
						1:	replaceController tmc[2][j].controller &toNode.controller[j]
						2:	pasteToActiveCtrl tmc[2][j].controller &toNode.controller[j]
					)
				)
				-- IK goal to IK goal paste
				else
				(

					--IK goal Swivel param
					if tmc[1].controller != undefined do case rb_ctrl.state of
					(
						1: 	replaceController tmc[1].controller &toNode.controller[1]
						2:	pasteToActiveCtrl tmc[1].controller &toNode.controller[1]
					)
					--IK goal transforms
					for j = 1 to 3 do
					(
						if chkArray[j] and tmc[2][j].isAnimated do case rb_ctrl.state of
						(
							1:	replaceController tmc[2][j].controller &toNode.controller[2][j] 
							2:	pasteToActiveCtrl tmc[2][j].controller &toNode.controller[2][j]
						)
					)	
					if (isKindof toNode.controller[3].controller On_Off) then
					(
					--Hack to paste IK Enabled keys
					deleteKeys toNode.controller[3].keys #allKeys
					for k in tmc[3].keys do addNewKey toNode.controller[3].keys k.time
					if rb_ctrl.state == 2 do
					(
						local 	tempCtrl = toNode.controller[3].controller,
								source_range = interval s_startTime.value s_endTime.value,
								insert_time  = s_insert.value
						if not cb_matchRange.checked do setTimeRange tempCtrl source_range
						insertTime tempCtrl (getTimeRange tempCtrl).start (insert_time - (getTimeRange tempCtrl).start)
					)			
				)
					else -- maybe the new boolean controller
					(
						case rb_ctrl.state of
						(
							1:	replaceController tmc[3].controller &toNode.controller[3]
							2:	pasteToActiveCtrl tmc[3].controller &toNode.controller[3]
						)
			)
				)
			)
			-- Pasting from IK bone objects
			else if (isKindOf tmc IKControl) then
			(
				-- Only paste IK bone's FK_Sub_Contrl to non-IK object
				if (classof toNode.controller) != (classof tmc) then for j = 1 to 3 do
				(
					if chkArray[j] do case rb_ctrl.state of
					(
						1:	replaceController tmc[4][j].controller &toNode.controller[j]
						2:	pasteToActiveCtrl tmc[4][j].controller &toNode.controller[j]
					)
				)
				-- Bone to bone pasting				
				else 
				(
					-- Bone to bone pasting				
					for j = 1 to 3 do -- for preferred angles
					(
						if chkArray[j] and tmc[j].controller != undefined do case rb_ctrl.state of
						(
							1:	replaceController tmc[j].controller &toNode.controller[j]
							2:	pasteToActiveCtrl tmc[j].controller &toNode.controller[j]
						)
					)
					for j = 1 to 3 do -- fk sub control
					(
						if chkArray[j] do case rb_ctrl.state of
						(
							1:	replaceController tmc[4][j].controller &toNode.controller[4][j]
							2:	pasteToActiveCtrl tmc[4][j].controller &toNode.controller[4][j]
						)
					)
				)
			)
			else -- maybe a spline IK control
			(
				--print " I am IK spline"
				for j=1 to tmc.numSubs do
				(
					case rb_ctrl.state of
					(
						1:	replaceController tmc[j].controller &toNode.controller[j]
						2:	pasteToActiveCtrl tmc[j].controller &toNode.controller[j]
					)
				)
			)			
		)		
		-- Support for animated base object sub-anims based on sub-anim name
		if chkBaseObject.checked do
		(
			for j = 1 to fromNode.baseObject.numsubs do
			(
				local fromSubAnim = fromNode.baseObject[j]; if fromSubAnim.controller == undefined do continue
				if toNode.baseObject[getSubAnimName fromNode.baseObject j] != undefined and fromSubAnim.isAnimated do case rb_ctrl.state of
				(
					1:	replaceController fromSubAnim.controller &toNode.baseObject[getSubAnimName fromNode.baseObject j] 
					2:	pasteToActiveCtrl fromSubAnim.controller &toNode.baseObject[getSubAnimName fromNode.baseObject j]
				)
			)			
		)
		replaceCAAnim fromNode.baseobject toNode.baseobject
		-- Support for animated modifier sub-anims based on modifier name
		if chkModifiers.checked and toNode.modifiers.count > 0 do
		(
			for m=1 to fromNode.modifiers.count do 
			(
				local mod = fromNode.modifiers[m]
--				format "%-%-%\n" m (classof mod) (classof toNode.modifiers[m])
				if (classof mod) == (classof toNode.modifiers[m]) then
				(
					for j = 1 to mod.numsubs do
					(
						local fromSubAnim = mod[j]; if fromSubAnim.controller == undefined do continue
						if fromSubAnim.isAnimated do case rb_ctrl.state of
						(
							1:	replaceController fromSubAnim.controller &toNode.modifiers[mod.name][j] 
							2:	pasteToActiveCtrl fromSubAnim.controller &toNode.modifiers[mod.name][j]
						)
					)
					replaceCAAnim mod toNode.modifiers[m]
				)
			)
		)
		if chkMaterials.checked and fromNode.material != undefined then
		(
			local mat = fromNode.material
			if toNode.material == undefined then
				toNode.material = createInstance (classof mat)
			if (classof toNode.material) == (classof mat) do
			(
				for j = 1 to mat.numsubs do
				(
					for k = 1 to mat[j].numSubs do
					(
						local fromSubAnim = mat[j][k]; if fromSubAnim.controller == undefined do continue
						if fromSubAnim.isAnimated do case rb_ctrl.state of
						(
							1:	replaceController fromSubAnim.controller &toNode.material[j][k] 
							2:	pasteToActiveCtrl fromSubAnim.controller &toNode.material[j][k]
						)
					)
				)
			)
		)	
	)
	fn replaceAnim fromAnim toAnim recurse =
	(
		if fromAnim.numSubs != toAnim.numSubs do return false
		if fromAnim.numSubs == 0 then
		(
			try
			(
				toAnim.controller = fromAnim.controller
			)
			catch
			( 
				SetStatus ("Could not set animation " + toAnim as string + " < - " + fromAnim as string) error:true
			)
		)
		for j=1 to fromAnim.numSubs do
		(
			if fromAnim[j].isAnimated then
				toAnim[j].controller = fromAnim[j].controller
		)
	)	
	
	-- these functions are used by the character script
	fn resetAnim fromAnim =
	(
		--format "\tReset Anim Controller: %\n" (fromAnim.controller as string)
		if fromAnim.controller != undefined then
			deleteKeys fromAnim.controller #allKeys			
		
		-- delete anims from custom attributes
		--format "\tReset Anim CA.count: %\n" (custAttributes.count fromAnim) 
		for k=1 to (custAttributes.count fromAnim) do 
		(
			local ca = custattributes.get fromAnim k
			--format "\tReset Anim CA[%]: %\n" k (ca as string) 
			if (ca != undefined) do
			(
				local saNames = getSubAnimNames ca
				--format "\t\tReset Anim CA.subAnims.Count: %\n" saNames.count 
				for s=1 to saNames.count do 
				(
					--format "\t\tReset Anim CA.subAnims[%]: %\n" s ca[s] 
					if (ca[s].controller != undefined) do (
						--format "\t\t\tReset Anim CA.subAnims[%].controller: %\n" s (ca[s].controller as string) 
						deleteKeys ca[s].controller #allKeys
					)	
				)
			)
		)

		--format "\tReset Anim SubAnims.count: %\n" fromAnim.numSubs 
		for j=1 to fromAnim.numSubs do
		(
			resetAnim fromAnim[j]
		)
	)
	fn resetNodeAnim node = 
	(
		--format "Reset Anim Node: %\n" node.name
		--format "Reset Anim Node.Controller: %\n" (node.controller as string)
		resetAnim node.controller
		--format "Reset Anim Node.BaseObject: %\n" (node.baseobject as string)
		resetAnim node.baseObject
		for m in node.modifiers do (
		--format "Reset Anim Node.modifier: %\n" (m as string)
			resetAnim m
		)
	)
	-------------------------------------------------------------------------------------------
	-- File I/O Stuff	-------------------------------------------------------------------------------------------	
	-- loadFileInfo() has been modified to merge source objects into a group; this is somewhat faster than using XRefs and provides more direct access to source nodes
	--	fn unloadXRef = ( try (delete new_xref) catch () )
--	fn unloadXRef = ( try (delete new_tree) catch () )
	fn unloadXRef = 
	( 
		try 
		(
			xml_input = false
			if new_xref != undefined then delete new_xref
			if $_merge_anim != undefined do delete $_merge_anim*			
		) catch() 
	)
	
	fn loadXMLFile fname = 
	(
		if fname == undefined then return false
		setWaitCursor()
		xml_input = true		
		new_xref = undefined
		file_name = fname
		lblProps.caption =
			"File:   	   " + (getFileNameFile file_name) + ".xml" +
			"\nLocation:   "  +(getFileNamePath file_name)
		
		xmlIO.init()
		if (xmlIO.load fname) then
		(
			new_tree = xmlIO.xmlDoc.selectSingleNode("//objects")
			source_nodes = new_tree.childNodes
			lvSource.listItems.clear()
			addXMLNodesToListView lvSource source_nodes recurse:true
		)
		else
			setStatus (xmlIO.xmlDoc.parseError.reason + " at " + xmlIO.xmlDoc.parseError.srcText) error:true
		setArrowCursor()
		true
	)
	fn loadFileInfo fname =
	(
		if fname == undefined then return false		
		setWaitCursor()		
		new_xref = undefined
		file_name = fname

		rMergeAnim.unloadXRef()

		-- Create new group at world origin to ensure a 1-1 correspondence with source and destination node transformation
		new_tree = group (local temp_node = point()) name:"_merge_anim"
		local obj_count = objects.count
		local res = mergeMAXFile file_name #mergedups #noRedraw
		if not res then return false
		
		-- Collect all newly merged objects into a new temp group
		local gobjs = for i = (obj_count + 1) to objects.count collect
				( objects[i].isHidden = true; objects[i] )
		local temp_group = group gobjs
		
		if temp_group != undefined and temp_group != ok then -- group created
		(
			temp_group.isHidden = true
			
			-- Transfer objects from the temp group into new_tree
			for c in temp_group.children do c.parent = new_tree; delete #(temp_node, temp_group)
		
			new_tree.isHidden = true
			new_tree_count = new_tree.children.count
			clearUndoBuffer()
		)
		else -- bring in the source file as an xref
		(
			for i = gobjs.count to 1 by -1 do ( try (if not (isDeleted gobjs[i]) then delete gobjs[i]) catch(format "Error deleting temp node:%\n" gobjs[i]) )
			if file_name == (maxFilePath + maxFileName) then
			( 				MessageBox "Cannot open the currently opened file as source file."
				return false
			)
			xrefs.addNewXrefFile file_name
			new_xref = xrefs.getXRefFile (xrefs.getXRefFileCount())
			new_xref.hidden = true
			new_tree = new_xref.tree						
		)							
		lblProps.caption =
			"File:   	    " + (getFileNameFile file_name) + (getFileNameType file_name) +
			"\nLocation:   " + (getFileNamePath file_name)

		setArrowCursor()
		true
	)	

	fn loadSource f =
	(
		setWaitCursor()
		unLoadXRef()
		local shortFileName = getFileNameFile f + getFileNameType f
		setStatus ("Loading source file " + shortFileName)
		if loadFileInfo f then
		(
			lvSource.listItems.clear()
			addNodesToListView lvSource (source_nodes = new_tree.children) recurse:true
			setStatus "Loaded source file successfully"
		)
		else SetStatus ("Failed to load file " + shortFileName) error:true
		setArrowCursor()
	)
	fn saveMapping =
	(
		setWaitCursor()
		format "\"%\" %\n" (if file_name == undefined then "" else file_name) lvCurrent.listItems.count to:map_stream
		for li in lvCurrent.listItems do
		(
			local si = getIndexedProperty li #subItems merge_col
			format "\"%\" % % %" li.text li.forecolor li.bold li.tag.handle to:map_stream
			if si == undefined or si == "" then
				format " \"\" \"\"\n" to:map_stream
			else
			(				local tag = li.listSubItems[merge_col].tag
				format " \"%\" %\n" si (if xml_input then tag else tag.handle) to:map_stream
			)
		)
		setArrowCursor()
	)
	fn loadMapping =
	(
		local items = lvCurrent.listItems, num_lines, ln=0, src_file 
		items.clear()
		seek map_stream 0
		src_file = readValue map_stream
		
		-- if a source file is listed then see if it is different from the existing one and load it
		if src_file != "" and src_file != file_name then ( loadSource src_file; lvSource.refresh() )
		
		num_lines = readValue map_stream
		
		setWaitCursor()
		SetStatus "Loading mapping file..."
		while not eof map_stream do
		(
			local li, li_tag, si, si_tag, li_node
			li = items.add()
			
			-- read the values
			li.text = readValue map_stream
			li.forecolor = readValue map_stream
			li.bold = readValue map_stream
			li_node = getNodeByHandle (readValue map_stream)			
			si = readValue map_stream
			si_tag = readValue map_stream
			
			li_tag = if li_node == undefined then execute ("$'" + li.text + "'") else li_node
			li.tag = li_tag
			if li_tag == undefined then ( li.bold = true; li.forecolor = err_color )
			if si != "" then
			(
				setIndexedProperty li #subItems merge_col si
				si_node = getNodeByHandle si_tag
				li.listSubItems[merge_col].tag = if si_node == undefined then execute ("$'" + si + "'") else si_node
				if si_node == undefined then li.listSubItems[merge_col].forecolor = err_color
			)
			ln += 1
			pbStatus.value = 100.*ln/num_lines
			if (mod pbStatus.value 10) == 0 then	gc() -- for every 10%, do a gc
		)
		pbStatus.value = 0
		setArrowCursor()
	)
	
	fn Save2XML filename nodes: =
	(
		if filename != undefined then
		(
			setWaitCursor()
			savedNodes = 0
			if nodes == unsupplied then nodes = rootNode.children
			obj_count = nodes.count			
			setStatus "Saving XML File..."
			xmlIO.init()
			local objsElem = xmlIO.xmlDoc.createElement "objects"
			xmlIO.world.appendChild objsElem
			for o in nodes do
			(
				xmlIO.obj2xml o objsElem  postCallback:(rMergeAnim.postSaveCB)
			)
			xmlIO.save filename
--			messageBox (xmlIO.no_key_frames as string)
			setStatus "XML File Saved Successfully"
			if show_messages then
				MessageBox "Save completed" title:"Merge Animation" beep:true
			setArrowCursor()
		)
	)

	fn RegisterCallbacks =
	(
		callbacks.addScript #systemPreReset		"destroyDialog rMergeAnim" 	id:#rMergeAnim
		callbacks.addScript #systemPreNew		"destroyDialog rMergeAnim"	id:#rMergeAnim
		callbacks.addScript #filePreOpen		"destroyDialog rMergeAnim" 	id:#rMergeAnim
	
--		callbacks.addScript #filePreSave		"rMergeAnim.unloadXRef()" 	id:#rMergeAnim
--		callbacks.addScript #filePostSave		"rMergeAnim.updateTrees()" id:#rMergeAnim

	)
	-------------------------------------------------------------------------------------------
	-- Initialization Stuff
	-------------------------------------------------------------------------------------------
	on rMergeAnim open do
	(
		replaceController_fn = replaceController

		setWaitCursor()		
		xmlio = gxmlIO
		file_name = undefined
		dontFilterChildren = false
		addSubRollout srRollouts rObjectMapping	rolledUp:false
		
		-- initialize various
		lvCurrent = rObjectMapping.lvCurrent
		lvSource = rObjectMapping.lvSource
		
		-- add other procedural types
		append proc_types position_reactor
		append proc_types rotation_reactor
		append proc_types scale_reactor
		append proc_types float_reactor		
		append proc_types BipSlave_Control
		append proc_types Footsteps
		append proc_types Biped_SubAnim
		
		-- Initialize various controls
		initStatusBar()

		
		initListView lvCurrent
		initListView lvSource
		-- Allow only drop, no drag
		lvCurrent.OLEDragMode = #ccOLEDragManual
		lvCurrent.OLEDropMode = #ccOLEDropManual			
		
		-- Allow only drag, no drop			
		lvSource.OLEDragMode = #ccOLEDragAutomatic
		lvSource.OLEDropMode = #ccOLEDropManual

		-- add the columns
		(lvCurrent.columnHeaders.add()).text = "Current Nodes"
		(lvCurrent.columnHeaders.add()).text = "Merge Nodes"
		(lvSource.columnHeaders.add()).text = "Source Nodes"
		 			-- resize the listview controls
		local LVM_FIRST = 0x1000, LVM_SETCOLUMNWIDTH = (LVM_FIRST + 30)
		windows.sendMessage lvCurrent.hwnd LVM_SETCOLUMNWIDTH  0 (rObjectMapping.cur_width/2 - 2)
	    windows.sendMessage lvCurrent.hwnd LVM_SETCOLUMNWIDTH  1 (rObjectMapping.cur_width/2 - 2)
		windows.sendMessage lvSource.hwnd LVM_SETCOLUMNWIDTH  0 (rObjectMapping.src_width - 4)
		
		btnSave2XML.visible = rObjectMapping.enable_debug
		
		if fname != undefined and (loadFileInfo fname) then
		(
			local start, end 
			start = timeStamp()
			
			addNodesToListView lvSource (source_nodes = new_tree.children) recurse:true
			
			end = timeStamp()
			format "Total:%\n" ((end-start)/1000)
		)
		
		s_insert.enabled = false
		current_nodes = rootNode.children

		addNodesToListView lvCurrent current_nodes		
	
		callbacks.removeScripts id:#rMergeAnim
		RegisterCallbacks()
		
		setArrowCursor()
		rObjectMapping.doRollup true
	)
	on rMergeAnim close do
	(
		setIniSetting ini_file #general #position ((getDialogpos rMergeAnim) as string)
		callbacks.removeScripts id:#rMergeAnim
		unloadXRef()
	)
	-------------------------------------------------------------------------------------------
	-- UI options events
	-------------------------------------------------------------------------------------------
	on chkTransform		changed state do ( chkPosition.enabled = chkRotation.enabled = chkScale.enabled = state)
	on chkCustAttrib	changed state do chkAddNewDefs.enabled = state

	on cb_matchRange changed state do s_startTime.enabled = s_endTime.enabled = not state
	on rb_ctrl changed state do case state of
	(
		1:	s_startTime.enabled = s_endTime.enabled = cb_matchRange.enabled = s_insert.enabled = rb_relAbs.enabled = false

		2:	(
				s_startTime.enabled = s_endTime.enabled = (not cb_matchRange.state)
				cb_matchRange.enabled = true
				s_insert.enabled = rb_relAbs.enabled = true
			)
	)
	
	on btnFetch pressed do
	( 
		callbacks.removeScripts id:#rMergeAnim		
		setStatus "Fetching in progress..."
		if is_holding then
		(
			try
			(
				unloadXRef()
				delete hold_objects							
				mergeMaxFile hold_file --#deleteOldDups				
			) catch()
--			map_stream = stringStream ""; loadMapping()
		)
		RegisterCallbacks()		
		if (getFileNameType file_name) == ".xml" then loadXMLFile file_name
		else ( loadSource file_name; new_tree.isHidden = true )
		updateSource()
		updateCurrent()		
		setStatus "Fetching done"
		btnFetch.enabled = false
	)
	-------------------------------------------------------------------------------------------
	-- Do the animation merging/replacing
	-------------------------------------------------------------------------------------------
	on btnSource pressed do
	(
		local f = getOpenFileName caption:"Source File" types:"3ds max Animation (*.anm)|*.anm|3ds max (*.max)|*.max|xml scene (*.xml)|*.xml|All (*.*)|*.*|"
		if f != undefined do
		(
			if (getFileNameType f) == ".xml" then loadXMLFile f
			else loadSource f
			updateCurrent()
		)
 	)
	on btnSourceObj pressed do
	(
		if hitByNameDlg() then 
		(
			unloadXref()
			file_name = ""			
			source_nodes = selection

			setStatus "Loading source objects..."
			lvSource.listItems.clear()
			addNodesToListView lvSource source_nodes recurse:false
			updateCurrent()
			setStatus "Source objects successfully"
		)
 	)	
	on btnSave2XML pressed do
	(
		local f = getSaveFileName types:"xml Scene (*.xml)|*.xml"
		Save2XML f
	)
	on btnMerge pressed do
	(
		local st = timeStamp(), dt, et=0, ot=0, ct=0, merged_objects=0
		-- run through all the list items and do the merge
		local items = lvCurrent.listItems, item_count = items.count
		if item_count == 0 or lvSource.listItems.count == 0 then
		(
			if show_messages then MessageBox "No items to merge" title:"Merge Animation" beep:true
			return()
		)
		is_holding = true		
		deleteFile hold_file
		btnFetch.enabled = true
		hold_objects = #()
		-- save all nodes to a temp file to provide undoing the merge
		saveNodes objects hold_file
		gc light:true
		
		map_stream = stringStream ""--; saveMapping()
		setWaitCursor()
		setStatus "Merging animation..."
		xmlio.animatedOnly = false		
		
		with redraw Off
		(
			for i = 1 to item_count do
			(		
				local li = items[i], si = li.listSubItems[merge_col]
				if si != undefined then
				(
--					try
					(
						local fromNode, toNode = li.tag
						if toNode == undefined or (isDeleted toNode) do continue
						if xml_input then
						(
							local fromElem = xmlIO.xmlDoc.selectSingleNode ("//object[@id='" + si.tag + "']")							 

							local ots = timeStamp()
							
							-- create the object from the xml element
							fromNode = xmlIO.xml2obj	fromElem chkTransform:chkTransform.checked \
														chkBaseObject:chkBaseObject.checked \
														chkModifiers:chkModifiers.checked \
														chkCustAttrib:chkCustAttrib.checked
							ot += timeStamp() - ots
							local cls = (xmlIO.getAttribute fromElem #classOf)
							if fromNode != undefined then
							(
								replaceNodeAnim fromNode toNode false
								delete fromNode
--								gc()
							)
							else 								format "Cannot create node for % of type %\n" (xmlIO.getAttribute fromElem #name) cls
						)
						else
						(
							local skip = false							
							try (fromNode = si.tag) catch (skip = true)							
							if not skip and (getNodeByName si.text) != undefined then 
							(
								append hold_objects toNode
								replaceNodeAnim fromNode toNode false
							)
							
							else 
							(
								li.forecolor = err_color
								li.bold = true
							)
						)
						if xmlio.isAnimated toNode do ( li.forecolor = si.forecolor = anim_color; li.bold = true )
						merged_objects += 1
					)
/*					catch
					(
						-- incase of an error, highlight the list item
						li.forecolor = err_color
						li.bold = true
						format "  Error occurred in processing list node %\n" li.text					
						throw()
					)
*/				
				)
				pbStatus.value = 100.*i/item_count
				if (mod pbStatus.value 10) == 0 then gc() -- for every 10%, do a gc
			)			
		)
		setArrowCursor()

		-- Timings
		dt = timeStamp() - st
		if xml_input then
		(
			et = xmlio.exec_time
			ct = xmlio.create_time
		)
		
		if rObjectMapping.enable_debug then
		(
			format "---------------\nTotal Time - %s\n---------------\n"  (dt/1000)
			format "Execute Time 		  - %\%\n" (et*100/dt)
			format "Object Creation Time  - %\%\n" (ot*100/dt)
			format "CreateInstance Time   - %\%\n" (ct*100/dt)
		)
		if chkAdjustTimeRange.checked and current_range.start != current_range.end do animationRange = current_range

		if show_messages then MessageBox (if merged_objects == 0 then "Merge Nodes column is empty, no objects merged"  else "Merge completed") title:"Merge Animation" beep:true	
		setStatus ("Total Merged: " + merged_objects as string)
		pbStatus.value = 0
	)
	fn postSaveCB obj = 
	(
		savedNodes += 1
		pbStatus.value = savedNodes*100/obj_count
	)
	
	fn openDialog = 
	(
		local pos = execute (getIniSetting ini_file #general #position)
		--local rolledUp = (execute (getIniSetting ini_file #general #rolledUp)) == true
		if pos == ok then pos = [100, 100]
		createDialog rMergeAnim pos:pos style:#(#style_border, #style_titlebar, #style_minimizebox, #style_maximizebox, #style_sysmenu) escapeEnable:false
	)	
  )
