try(destroyDialog roMD2Exporter);catch()

rollout roMD2Exporter "MD2 Exporter" width:224 height:664
(
	
	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██        ██               ████                   
	--  ██        ██               ██                     
	--  ██ █████ █████ █████ ████  ██   █████ █████ █████ 
	--  ██ ██ ██  ██   ██ ██ ██   █████    ██ ██    ██ ██ 
	--  ██ ██ ██  ██   █████ ██    ██   █████ ██    █████ 
	--  ██ ██ ██  ██   ██    ██    ██   ██ ██ ██    ██    
	--  ██ ██ ██  ████ █████ ██    ██   █████ █████ █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Interface

	GroupBox grpAnimation "Animations" pos:[8,8] width:208 height:208
		dotNetControl lvAnimations "System.Windows.Forms.ListView" pos:[16,24] width:192 height:160
		button btnAnimationNew "New..." pos:[16,190] width:48 height:20 toolTip:"Add a new animation sequence item"
		button btnAnimationIn "In" pos:[64,190] width:20 height:20 toolTip:"Set the selected item's in point"
		button btnAnimationOut "Out" pos:[84,190] width:20 height:20 toolTip:"Set the selected item's out point"
		button btnAnimationSel "Auto" pos:[104,190] width:30 height:20 toolTip:"Set the selected item's in and out points from the object's selected transformation and modifier keysframes"
						
		button btnAnimationUp "-" pos:[148,190] width:20 height:20 toolTip:"Move the selected item up"
		button btnAnimationDown "+" pos:[168,190] width:20 height:20 toolTip:"Move the selected item down"
		button btnAnimationDelete "x" pos:[188,190] width:20 height:20 toolTip:"Delete the selected item"
				
	GroupBox grpTextures "Texture Maps" pos:[8,224] width:208 height:120
		listbox lbxTextures "" pos:[16,240] width:192 height:5

		button btnTexturesBrowse "Browse..." pos:[130,316] width:58 height:20 toolTip:"Browse for a new texture file"
		button btnTexturesDelete "x" pos:[188,316] width:20 height:20 toolTip:"Delete the selected texture file"
			
	GroupBox grpExport "Export" pos:[8,352] width:208 height:96
		button btnExport "Export" pos:[16,368] width:162 height:24 toolTip:"Export object to MD2 format"
		checkbutton btnExportSel "Sel" pos:[178,368] width:30 height:24 toolTip:"Only export selected animations"
		spinner spnExportSteps "Every n frames" pos:[140,400] width:68 height:16 range:[1,100,5] type:#integer scale:1 fieldwidth:30
		progressBar pb1 "ProgressBar" pos:[16,424] width:192 height:16 --value:50
			
	GroupBox grpOptions "MD2 Options" pos:[8,456] width:208 height:120
		checkbox chkOptionsZsort "Z-Sort Triangles" pos:[24,480] width:105 height:15 checked:true toolTip:""
		checkbox chkOptionsNormals "Generate Normals" pos:[24,496] width:109 height:15 checked:true
		checkbox chkOptionsGLCommands "Add GL Commands" pos:[24,512] width:115 height:15 checked:true
		checkbox chkOptionsBoundingBox "Unified Bounding Box" pos:[24,536] width:126 height:15 checked:false
		checkbox chkOptionsSameGLCommands "Use same GLCmds" pos:[40,552] width:114 height:15 enabled:false checked:false
		
	GroupBox grpAbout "About" pos:[8,584] width:208 height:70
		--activeXControl actx1 "" pos:[8,592] width:208 height:56

	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██  ██            ██       ██    ██             
	--  ██  ██                     ██    ██             
	--  ██  ██ █████ ████ ██ █████ █████ ██ █████ █████ 
	--  ██  ██    ██ ██   ██    ██ ██ ██ ██ ██ ██ ██    
	--  ██  ██ █████ ██   ██ █████ ██ ██ ██ █████ █████ 
	--   ████  ██ ██ ██   ██ ██ ██ ██ ██ ██ ██       ██ 
	--    ██   █████ ██   ██ █████ █████ ██ █████ █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Variables
	
		-- variables
			local colors				= DotNetClass "System.Drawing.Color"
	
		-- properties
			local keyList				= #()
			local textureMaps			= #()
			local obj
			
		-- predeclarations
			local updateAnimationListItem, updateButtonText

	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██  ██  ██   ██ ██ ██  ██   ██             
	--  ██  ██  ██      ██     ██                  
	--  ██  ██ █████ ██ ██ ██ █████ ██ █████ █████ 
	--  ██  ██  ██   ██ ██ ██  ██   ██ ██ ██ ██    
	--  ██  ██  ██   ██ ██ ██  ██   ██ █████ █████ 
	--  ██  ██  ██   ██ ██ ██  ██   ██ ██       ██ 
	--  ██████  ████ ██ ██ ██  ████ ██ █████ █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Utilities
	
		fn getCell name index: =
	(
			-- returns a reference to a cell within lvAnimations
			
			local subIndex = case name of
		(
				"name"		:0
				"in"		:1
				"out"		:2
				"frames"	:3
		)
			index = if index != unsupplied then index else if lvAnimations.SelectedItems.count > 0 do lvAnimations.selectedIndices.item[0]
			if index != undefined do
		(
				lvAnimations.items.item[index].subItems.item[subIndex]
		)
	)
		
		fn walkSubAnim ctrl =
	(
			-- variables
				local sub, n, k
			
			-- controller and keys
				if ctrl.controller != undefined do
			(
					n = numKeys ctrl.controller
					if n > 0 do
				(
						for k = 1 to n do
					(
							if isKeySelected ctrl.controller k do
						(
								appendIfUnique keyList (getKeyTime ctrl.controller k)
						)
					)
				)
			)
			
			-- sub anim and children
				for i = 1 to ctrl.numSubs do
			(
					sub = getsubanim ctrl i
					if sub.controller != undefined do
				(
						walkSubAnim sub
				)
			)
	)
		
		fn debugProperty property recursive:false depth:0 =
	(
			local props = getpropnames property
			for i = 1 to props.count do
		(
				-- properties
					local propName		= props[i] as string
					local prop			= getproperty property propName
					local propClass		= classof prop
					
				-- output
					format ".% (%)\n----------------------------------------------------------------\n" propName propClass
					try
				(
						getPropNames prop
						show prop
						if recursive AND depth < 3 do debugProperty prop recursive:true depth:(depth + 1)
				)
					catch
				(
						format "  %\n" prop
				)
					format "\n"
		)
	)
	
		
	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██████                    ██   ██                   
	--  ██                        ██                        
	--  ██     ██ ██ █████ █████ █████ ██ █████ █████ █████ 
	--  █████  ██ ██ ██ ██ ██     ██   ██ ██ ██ ██ ██ ██    
	--  ██     ██ ██ ██ ██ ██     ██   ██ ██ ██ ██ ██ █████ 
	--  ██     ██ ██ ██ ██ ██     ██   ██ ██ ██ ██ ██    ██ 
	--  ██     █████ ██ ██ █████  ████ ██ █████ ██ ██ █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Functions

		--------------------------------------------------------------------------------------------------------------------------
		-- Animation
		--------------------------------------------------------------------------------------------------------------------------
		
			function addAnimation name: inPoint:"-" outPoint:"-" beginEdit:false =
		(
				-- variables
					local li, liSub
					name = if name != unsupplied then name else "Animation " + (lvAnimations.items.count + 1) as string
					
				-- create a ListViewItem object
					li = dotNetObject "System.Windows.Forms.ListViewItem" name
					
				-- add sub-items
					liSub = li.SubItems.add (inPoint as string)
					liSub = li.SubItems.add (outPoint as string)
					liSub = li.SubItems.add "-"
				
				-- populate ListView
					lvAnimations.Items.add li
					
				-- edit if needed
					if beginEdit do li.BeginEdit()
		)

			function deleteAnimation =
		(
				selectedItems = lvAnimations.SelectedItems
				if selectedItems.count > 0 do
			(
					if queryBox "Are you sure you want to delete these animation presets?" do
				(
						for i = selectedItems.count - 1 to 0 by -1 do selectedItems.item[i].remove()
				)
			)
		)

			function setAnimationInPoint frame: =
		(
				if frame == unsupplied do frame = sliderTime as integer / ticksperframe
				local cell = getCell "in"
				if cell != undefined do cell.text = frame as String
				updateAnimationListItem()
		)

			function setAnimationOutPoint frame: =
		(
				if frame == unsupplied do frame = sliderTime as integer / ticksperframe
				local cell = getCell "out"
				if cell != undefined do cell.text = frame as String
				updateAnimationListItem()
		)

			function setAnimationInOutPoint =
		(
				-- variables
					keyList			= #()
					local ctrl		= obj.transform.controller
					
				-- position controllers
					walkSubAnim ctrl

				-- modifiers
					if obj.modifiers.count > 0 do
				(
						for i = 1 to obj.modifiers[1].numSubs do
					(
							walkSubAnim obj.modifiers[1][i]
					)
				)
					
				-- in and out points
					if keyList.count > 0 do
				(
						setAnimationInPoint frame:(amin keyList)
						setAnimationOutPoint frame:(amax keyList)
				)
		)

			function moveAnimationUp =
		(
				
		)

			function moveAnimationDown =
		(
				
		)
			
			function updateAnimationListItem index: =
		(
				-- index
					index = if index != unsupplied then index else if lvAnimations.SelectedItems.count > 0 do lvAnimations.selectedIndices.item[0]
					if index != undefined do
				(
						-- variables
							local vIn		= (getCell "in").text as integer
							local vOut		= (getCell "out").text as integer
						
						-- frames & order
							if vIn != undefined AND vOut != undefined do
						(
							-- frames
								(getCell "frames").text = (vOut - vIn) as String
								
							-- wrong order
								lvAnimations.items.item[index].ForeColor = if vOut < vIn then colors.Red else colors.Black
						)
							
						-- not sure
				)
		)
			
			function updateAnimationList =
		(
				for i = 1 to lvAnimations.items.count do
			(
					updateAnimationListItem index:i
			)
		)
			
			function checkAnimationName index label =
		(
				local cell = getCell "name" index:index
				print cell.text
				print label
				if cell.text.count > 12 do cell.text = substring cell.text 1 12
		)
			
			fn updateListViewSelection =
		(
				-- updated selected items colors
					for i = 0 to lvAnimations.items.count - 1 do
				(
						lvAnimations.items.item[i].backColor = undefined -- set to white
				)
					
					for i = 0 to lvAnimations.SelectedItems.count - 1 do 
				(
						lvAnimations.SelectedItems.item[i].backColor = colors.Gainsboro -- set to gray
				)
					
				-- update button text
					updateButtonText()
		)
			
		--------------------------------------------------------------------------------------------------------------------------
		-- Textures
		--------------------------------------------------------------------------------------------------------------------------
		
			function addTexture =
		(
				local f = getOpenFileName types:"Image files (*.jpg, *.png)|*.jpg;*.png;" caption:"Choose a texture map..."
				if f != undefined do
			(
					lbxTextures.items = append lbxTextures.items ((filenameFromPath f) + "  (" + (getFilenamePath f) + ")")
					textureMaps = append textureMaps f
					lbxTextures.selection = lbxTextures.items.count
			)
		)

			function deleteTexture =
		(
				if lbxTextures.items.count > 0 AND lbxTextures.selection > 0 do
			(
					if queryBox "Are you sure you want to delete this texture?" do 
				(
						local i = lbxTextures.selection
						lbxTextures.items = deleteItem lbxTextures.items i
						deleteItem textureMaps i
				)
			)
		)

		--------------------------------------------------------------------------------------------------------------------------
		-- Export
		--------------------------------------------------------------------------------------------------------------------------
			
			function export =
		(
				
		)
			
			fn updateButtonText =
		(
				btnExport.text = "Export"
				if btnExportSel.checked do
			(
					btnExport.text += " (" + lvAnimations.selectedItems.count as string + " animations only)"
			)
		)
			

		--------------------------------------------------------------------------------------------------------------------------
		-- Options
		--------------------------------------------------------------------------------------------------------------------------
			

	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██████          ██       
	--  ██              ██       
	--  ██     █████ █████ █████ 
	--  ██     ██ ██ ██ ██ ██ ██ 
	--  ██     ██ ██ ██ ██ █████ 
	--  ██     ██ ██ ██ ██ ██    
	--  ██████ █████ █████ █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Code

			fn init =
		(
				local sel = getCurrentSelection()
				obj = if sel.count == 1 then obj = sel[1] else undefined
		)
			
			fn initListView =
		(
				-- properties
					lvAnimations.gridLines		= true
					lvAnimations.labelEdit		= true
					--lvAnimations.checkBoxes		= true
					lvAnimations.FullRowSelect	= true
					--lvAnimations.MultiSelect	= false
					lvAnimations.View			= (dotNetClass "System.Windows.Forms.View").Details
				
				
				-- defaults
					
					local align					= (dotNetClass "System.Windows.Forms.HorizontalAlignment")
					local left					= align.Left
					local right					= align.Right
				
					local columnNames			= #("Name", "In", "Out", "Frames")
					local columnWidths			= #(80, 30, 30, 48)
					local columnAligns			= #(left, right, right, right)
			
				-- columns, names, widths & alignments
					for i = 1 to columnNames.count do
				(
						local column = lvAnimations.Columns.add columnNames[i] columnWidths[i]
						column.textAlign = columnAligns[i]
				)
		)
			
			fn populate =
		(
				for i = 1 to 5 do addAnimation()
		)
				
	-- ------------------------------------------------------------------------------------------------------------------------
	--
	--  ██  ██                ██ ██                  
	--  ██  ██                ██ ██                  
	--  ██  ██ █████ █████ █████ ██ █████ ████ █████ 
	--  ██████    ██ ██ ██ ██ ██ ██ ██ ██ ██   ██    
	--  ██  ██ █████ ██ ██ ██ ██ ██ █████ ██   █████ 
	--  ██  ██ ██ ██ ██ ██ ██ ██ ██ ██    ██      ██ 
	--  ██  ██ █████ ██ ██ █████ ██ █████ ██   █████ 
	--
	-- ------------------------------------------------------------------------------------------------------------------------
	-- Handlers

		------------------------------------------------------------------------------------------------------------------------
		-- Animations
		
			on lvAnimations DoubleClick e do
		(
				format "%\n" e
		)
			
			on lvAnimations SelectedIndexChanged evt do updateListViewSelection()
			on lvAnimations MouseClick evt do
		(
				clearListener()
				--debugProperty evt recursive:true
				roProps.add evt
				
			/*
				on <control_name> Click			<System.EventArgs>e do ( ... )
				on <control_name> MouseClick	<System.Windows.Forms.MouseEventArgs>e do ( ... )
				on <control_name> MouseUp		<System.Windows.Forms.MouseEventArgs>e do ( ... )
				on <control_name> MouseWheel	<System.Windows.Forms.MouseEventArgs>e do ( ... )
			*/
		)
			
			on btnAnimationNew pressed do addAnimation beginEdit:true
			on btnAnimationDelete pressed do deleteAnimation()
			
			on btnAnimationIn pressed do setAnimationInPoint()
			on btnAnimationOut pressed do setAnimationOutPoint()
			on btnAnimationSel pressed do setAnimationInOutPoint()
			
			on btnAnimationUp pressed do moveAnimationUp()
			on btnAnimationDown pressed do moveAnimationDown()
			
		------------------------------------------------------------------------------------------------------------------------
		-- texture maps
			
			on btnTexturesBrowse pressed do addTexture()
			on btnTexturesDelete pressed do deleteTexture()
		
		------------------------------------------------------------------------------------------------------------------------
		-- export
		
			on btnExport pressed do export()
			on btnExportSel changed state do updateButtonText()
			on spnExportSteps changed val do updateAnimationList()
			
		------------------------------------------------------------------------------------------------------------------------
		-- options
		
		------------------------------------------------------------------------------------------------------------------------
		-- rollout
	
			on roMD2Exporter open do
		(
				clearListener()
				init()
				initListView()
				populate()
		)
			
)

createDialog roMD2Exporter --500 200

/*
roMD2Exporter.lvAnimations.labelEdit = true
roMD2Exporter.lvAnimations.items.item[0].BeginEdit()

roMD2Exporter.lvAnimations.items.item[0].subItems.item[1].text = "jkjh"

--show roMD2Exporter.lvAnimations.Sorting = 


roMD2Exporter.lvAnimations.CheckBoxes = true

roMD2Exporter.lvAnimations.items.item[1].ForeColor = (DotNetClass "System.Drawing.Color").Red

show roMD2Exporter.lvAnimations
showmethods roMD2Exporter.lvAnimations
showevents roMD2Exporter.lvAnimations


*/