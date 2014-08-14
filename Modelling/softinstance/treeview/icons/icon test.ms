	global objhold
	global SceneExplorerRoll 
	global bmproot = (getdir #scripts + "\\_blurScripts\\Scene_Explorer\\")
	
	global DIS_ENVIRONMENT = true
	global DIS_EFFECTS = true
	global DIS_XREFSCENE = true
	global DIS_XREFOBJECT = true
	global DIS_SELECTIONSETS = true
	global DIS_LAYERS = true
	global DIS_OBJECTS = true
	
	rcmenu ObjectRCMenu
	(
		MenuItem miProp "Properties"
		seperator sep0
		MenuItem miPos "Position" enabled:false
		MenuItem miRot "Rotation" enabled:false
		MenuItem miScl "Scale" enabled:false
		seperator sep1
		MenuItem miSela "Select Children" enabled:false
		MenuItem miSelb "Select All" enabled:false
		
		on miProp picked do
		(
			select objhold
			max properties 
		)
		--hide
		--unhide
		--freeze
		--unfreeze
		--display props..wire, box etc.
	)
	
	rollout OptionsRoll "Options"
	(
		group "Display Categories"
		(
			checkbox ui_showEnv "Environment" checked:DIS_ENVIRONMENT
			checkbox ui_showEffect "Effects" checked:DIS_EFFECTS
			checkbox ui_showXScene "XRef Scenes" checked:DIS_XREFSCENE
			checkbox ui_showXObject "XRef Objects" checked:DIS_XREFOBJECT
			checkbox ui_showSelSet "Selection Sets" checked:DIS_SELECTIONSETS
			checkbox ui_showLM "Layers" checked:DIS_LAYERS
			checkbox ui_showObj "Objects" checked:DIS_OBJECTS
		)

		on ui_showEnv changed state do DIS_ENVIRONMENT = state
		on ui_showEffect changed state do DIS_EFFECTS = state
		on ui_showXScene changed state do DIS_XREFSCENE = state
		on ui_showXObject changed state do DIS_XREFOBJECT = state
		on ui_showLM changed state do DIS_LAYERS = state
		on ui_showObj changed state do DIS_OBJECTs = state
	)
	
	rollout SceneExplorerRoll "Scene Explorer" 
	(
		button displayOptions "" pos:[5,5] tooltip:"Display Options" width:28 height:28 images:#(getdir #ui + "\\icons\\TrackViewTools_24i.bmp", undefined ,108,1,1,1,1)
		button update "" tooltip:"Update" pos:[35,5] width:28 height:28 images:#(bmproot + "Buttons.bmp", undefined ,1,1,1,1,1)
	--	button filter "f" pos:[35,5] tooltip:"Filters" width:28 height:28
	--	button sort "s" pos:[65,5] tooltip:"Sort" width:28 height:28
	--	button babout "a" pos:[155,5] tooltip:"About" width:28 height:28	

		activeXControl il "MSComctlLib.ImageListCtrl.2" width:1 height:1 pos:[50,50]-- imagelist control
		activeXControl tv "MSComctlLib.TreeCtrl.2" height:305 width:186 pos:[2,40]
		
		function colortoOLE color = ( return ((color.b *65536) + (color.g *256) + color.r) )
	
		function initList =
		(
			tv.nodes.clear()
			tv.lineStyle = #tvwRootLines --#tvwTreeLines
			tv.indentation = 0
			tv.pathseparator = "."
			-- enable 'Picture', otherwise you'll never see any pictures
			tv.style = #tvwTreelinesPlusMinusPictureText
			-- add pictures to imagelist (index 1)

			il.listimages.Add 1 "" (LoadPicture ( bmproot + "FldrClosed.BMP"))
			il.listimages.Add 2 "" (LoadPicture ( bmproot + "FldrOpen.BMP"))
			il.listimages.Add 3 "" (LoadPicture ( bmproot + "Drive.BMP"))
			il.listimages.Add 4 "" (LoadPicture ( bmproot + "sound.BMP"))
			il.listimages.Add 5 "" (LoadPicture ( bmproot + "Obj_Geom.BMP"))
			il.listimages.Add 6 "" (LoadPicture ( bmproot + "Obj_Shape.BMP"))
			il.listimages.Add 7 "" (LoadPicture ( bmproot + "Obj_Light.BMP"))
			il.listimages.Add 8 "" (LoadPicture ( bmproot + "Obj_Camera.BMP"))
			il.listimages.Add 9 "" (LoadPicture ( bmproot + "Obj_Helper.BMP"))
			il.listimages.Add 10 "" (LoadPicture ( bmproot + "Materials.BMP"))
			il.listimages.Add 11 "" (LoadPicture ( bmproot + "Layer.BMP"))
			il.listimages.Add 12 "" (LoadPicture ( bmproot + "world.BMP"))
			il.listimages.Add 13 "" (LoadPicture ( bmproot + "lines.BMP"))
			il.listimages.Add 14 "" (LoadPicture ( bmproot + "maxfile.BMP"))
			il.listimages.Add 15 "" (LoadPicture ( bmproot + "maxcube.BMP"))
			il.listimages.Add 16 "" (LoadPicture ( bmproot + "Obj_Bip.BMP"))
			
			-- bind imagelist 6o treeview
			tv.imagelist = il
		)
		

-- MAIN RECURSIVE FUNCTION!
		
		function addchildren ui_ref node =
		(	
			objNode = tv.nodes.add ui_ref.index 4 "" (node.name)
			objNode.tag = "obj"
			if node.ishidden == true then
				objNode.forecolor = (colortoOLE (color 150 150 150))
			case (superclassof node) of
			(
				GeometryClass:(
					case classof node of
					(
						Targetobject:(objNode.image = 9)
						Biped_Object:(objNode.image = 16)
						default:(objNode.image = 5)
					)

				)
				shape:( objNode.image = 6)
				light:( objNode.image = 7)
				camera:( objNode.image = 8)
				helper:( objNode.image = 9)
				default:( objNode.image = 13)
				--SpaceewarpObject
			)
			
			if Node.children.count > 0 then 
			(
				for n in Node.Children do addchildren objNode n
			)			
		)
		
		function setupObj objParent=
		(
			for node in rootnode.children do addchildren objParent node
		)
		
		function setupMat mat_dir = 
		(
			for mat in scenematerials do
			(
				matNode = tv.nodes.add mat_dir.index 4 "" (mat.name)-- + " : " + (classof mat as string ) )
				matNode.image = 10
				matNode.tag = "mat"
	
				if classof mat == StandardMaterial then
				(
					for map in mat.maps where map != undefined do
					(
						mapNode = tv.nodes.add matNode.index 4 "" (map.name) -- + " : " + (classof map as string) )
						rm = rendermap map size:[16,16] scale:50.0 filename:"c:/temp.bmp" 
						save rm
						close rm
						mapNode.image = 3
					)
				)
			)
		)
		
		function setupSelSets selset_dir=
		(
			for ss = 1 to selectionsets.count do
			(
				n = getNamedSelSetName ss
				selNode = tv.nodes.add selset_dir.index 4 "" n
				selNode.tag = "SelectionSet"
				selNode.image = 13
			)
		)
		
		function setupXrefScenes scene_dir =
		(
			for xr = 1 to xrefs.getXRefFileCount() do
			(
				xrf = xrefs.getXRefFile xr
				xrefNode = tv.nodes.add scene_dir.index 4 "" xrf.filename
				xrefNode.Tag = "XRefScene"
				xrefNode.image = 15
			)
		)
		function setupXrefObjects obj_dir =
		(
			for xo = 1 to objxrefs.getnumfiles() do
			(
				xro_fn = objxrefs.getFileName xo
				xrefNode = tv.nodes.add obj_dir.index 4 "" xro_fn
				xrefNode.image = 15
				for xro = 1 to (objxrefs.getNumXREFObjects xro_fn) do
				(
					objref = objxrefs.getXRefObject xro_fn xro
					objname = objref.currentObjectName
					xrefObjNode = tv.nodes.add xrefNode.index 4 "" objname
					xrefObjNode.image = 5
				)
			)
		)
	
		function setupEnvironment env_dir =
		(
			for i = 1 to numAtmospherics do
			(
				atmos = getAtmospheric i
				envnode = tv.nodes.add env_dir.index 4 "" atmos.name
				envnode.image = 15
			)
		)
		function setupLayers lay_dir =
		(
			if LM != undefined then
			(
				for L = 1 to LM.Layers.count do
				(
					laynode = tv.nodes.add lay_dir.index 4 "" LM.Layers[L].LayerName
					laynode .image = 11
				)
			)
		)
		
		function setuplist =
		(
			/*
			sound_dir = tv.nodes.add()
			sound_dir.text = "Sound"
			sound_dir.image = 4
			--sound_dir.visible = false
			*/
			if DIS_ENVIRONMENT == true then
			(
				envir_dir = tv.nodes.add()
				envir_dir.text = "Environment"
				envir_dir.tag = "Environment"
				envir_dir.image = 13
				setupEnvironment envir_dir
			)
			if DIS_EFFECTS == true then
			(
				effct_dir = tv.nodes.add()
				effct_dir.text = "Render Effects"
				effct_dir.tag = "Render Effects"
				effct_dir.image = 13
			)
			if DIS_XREFSCENE == true then
			(
				xrefscene_dir = tv.nodes.add()
				xrefscene_dir.text = "XRef Scenes"
				xrefscene_dir.tag = "XRef Scenes"
				xrefscene_dir.image = 2
				setupXrefScenes xrefscene_dir
				xrefscene_dir.forecolor = (colortoOLE blue)
			)
			if DIS_XREFOBJECT == true then
			(
				xrefobj_dir = tv.nodes.add()
				xrefobj_dir.text = "XRef Objects"
				xrefobj_dir.tag = "XRef Objects"
				xrefobj_dir.image = 2
				setupXrefObjects xrefobj_dir
				xrefscene_dir.forecolor = (colortoOLE blue)
			)
			if DIS_SELECTIONSETS == true then
			(
				selset_dir = tv.nodes.add()
				selset_dir.text = "Selection Sets"
				selset_dir.tag = "Selection Sets"
				selset_dir.image = 2
				setupSelSets selset_dir
			)
			if DIS_LAYERS == true then
			(
				layer_dir = tv.nodes.add()
				layer_dir.text = "Layers"
				layer_dir.tag = "Layers"
				layer_dir.image = 11
				setupLayers layer_dir
			)
			
			if DIS_OBJECTS == true then
			(
				obj_dir = tv.nodes.add()
				obj_dir.text = "Objects"
				obj_dir.image = 5
				setupObj obj_dir
		
				mat_dir = tv.nodes.add()
				mat_dir.text = "Materials"
				mat_dir.tag = "Materials"
				mat_dir.image = 10
				setupMat mat_dir
			)
			
		
		)
		function updateUI =
		(
			initList()
			setupList()
		)
	
		on SceneExplorerRoll open do updateUI()
		on update pressed do updateUI()
		on displayOptions pressed do createdialog OptionsRoll modal:true
		on tv click do 
		(
			case tv.selecteditem.tag of
			(
				"obj":(
					print tv.selecteditem.text
					--subroll.default_parameters_roll.updatelist (execute ("$"+tv.selecteditem.text))
				)
				"mat":(
	
					local ind = (tv.selecteditem.index - tv.selecteditem.parent.index)
					local sendaway = (scenematerials[ ind ])
				--	if sendaway != undefined then
				--		subroll.default_parameters_roll.updatelist sendaway
				--	else
				--		print ind
				)
			)
		)
		on tv dblclick do 
		(
			print "dblclick"
			case tv.selecteditem.tag of
			(
				"obj":(
					if keyboard.shiftpressed == true then
						selectmore (getnodebyname tv.selecteditem.text)
					else
						select (getnodebyname tv.selecteditem.text)
				)
				"mat":(
					--this doesn't work because of the maps
					--also if the material editor isn't displaying the same grid 3x2 4x6
					max mtledit
					local ind = (tv.selecteditem.index - tv.selecteditem.parent.index)
					setMeditMaterial (medit.GetActiveMtlSlot()) scenematerials[ind]
				)
				"SelectionSet":(
					local ind = (tv.selecteditem.index - tv.selecteditem.parent.index)
					select selectionsets[ ind ]
				)
				"Selection Sets":( max rns )
				"XRef Objects":( max file xref object )
				"XRef Scenes":( max file xref scene )
				"Materials":( max mtledit )
				"Environment":( actionMan.executeAction 0 "40029" )
				"Render Effects":( actionMan.executeAction 0 "40367" )
			)
			gc()
		)
		
		on tv mouseup Button Shift Xpos Ypos do
		(
			if button == 2 then
			(
				case tv.selecteditem.tag of
				(
					"obj":( PopupMenu ObjectRCMenu 
						objhold = getnodebyname tv.selecteditem.text
					)
				)
			)
			gc()
		)
		on SceneExplorerRoll resized size do
		(
			tv.size.x = size.x - 4
			tv.size.y = size.y - 50
		)
		
	)
	createdialog SceneExplorerRoll 190 350 style:#(#style_titlebar, #style_sysmenu, #style_resizing, #style_minimizebox)

