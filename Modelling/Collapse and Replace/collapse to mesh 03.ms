rollout roCollapse "Collapse & Replace" width:176 height:432
(
	--------------------------------------------------------------------------------------------------
	-- ui
	--------------------------------------------------------------------------------------------------

		groupBox grpSource "Source Objects" pos:[8,8] width:160 height:296
			--pickButton btnSource "Pick ..." pos:[16,24] width:144 height:16 multiple:true
			listBox lbxSource "" pos:[16,24] width:144 height:17
			button btnSource "Grab Selected" pos:[16,254] width:144 height:16
			label lblSource "Double-click to set base mesh" pos:[16,272] width:144 height:28 tooltip:"Double-click to set base mesh"
			
		groupBox grpAction "Action" pos:[8,312] width:160 height:80
			dropDownList ddlAction "" pos:[16,328] width:144 height:21 items:#("Replace original", "Duplicate original", "Replace Target") selection:2
			pickButton btnTarget "Pick ..." pos:[16,352] width:144 height:16 enabled:false
			checkbox chkMaterial "Replace material" pos:[16,370] width:104 height:16 enabled:false checked:true
			
		button btnGo "Duplicate and Collapse" pos:[8,400] width:160 height:24
	
	--------------------------------------------------------------------------------------------------
	-- variables
	--------------------------------------------------------------------------------------------------

		local arrSrc	= #()
		local objSrc, objTrg

	--------------------------------------------------------------------------------------------------
	-- functions
	--------------------------------------------------------------------------------------------------
	
		function safeCollapse sel duplicate:false name:#prompt moveTo:unsupplied moveBy:unsupplied replaceNode:unsupplied replaceMaterial:true =
			(
			-- error checking
				function throwError n =
					(
					local str = #(
						"function 'safeCollapse' requires parameter 1 to be a selection or, geometry, or array of geometry",
						"function 'safeCollapse' requires that all objects can be converted to editable meshes"
						)
					format "-- Runtime error: %\n" str[n]
					)
					
				if NOT (classof sel == ObjectSet OR classof sel == Array OR superClassof sel == GeometryClass) do (throwError 1; return false)
		
			undo "Safe-collpase to mesh" on
				(
				with redraw off
					(
					-- variables
						local arr = #()
						local objSrc, objTrg, objNew
						
					-- copy objects and convert to mesh
						for objTrg in sel do
							(
							objNew = copy objTrg
							convertToMesh objNew
							if classof objNew == Editable_mesh then append arr objNew
							else delete objNew
							)
							
					-- error check
						if arr.count == 0 do  (throwError 2; return false)
							
					-- setup objects for collapsing, and make the last selected the source
						objSrc = arr[arr.count]
						arr.count = arr.count - 1
						objSrc.material = copy objSrc.material
		
					-- do the collapse
						for objTrg in arr do
							(
							meshop.attach objSrc objTrg attachMat:#MatToID condenseMat:true
							)
							
					-- move / delete
						if moveTo != unsupplied then if classof moveTo == Point3 then arr.pos = moveTo
						if moveBy != unsupplied then if classof moveBy == Point3 then move arr moveBy
						if NOT duplicate do delete sel
						
					-- select / replace
						if isValidNode replaceNode == true then
							(
							replaceNode.baseObject = objSrc
							if replaceMaterial == true do replaceNode.material = objSrc.material
							--delete objSrc
							)
						else
							(
							select objSrc
							)
					)
				)
			)
	
	--------------------------------------------------------------------------------------------------
	-- ui functions
	--------------------------------------------------------------------------------------------------

		fn checkOkToGo =
			(
			-- vars
				local index = ddlAction.selection
				
			-- button text
				case index of
					(
					1:	(
						btnGo.text = "Collapse"
						btnGo.enabled = arrSrc.count > 0
						)
							
					2:	(
						btnGo.text = "Duplicate & Collapse"
						btnGo.enabled = arrSrc.count > 0
						)
						
					3:	(
						btnGo.text = "Duplicate, Collapse & Replace"
						btnGo.enabled = arrSrc.count > 0 AND isValidNode objTrg
						if NOT isValidNode objTrg then btnTarget.text = "Pick..."
						)
					)
			)

	--------------------------------------------------------------------------------------------------
	-- handlers
	--------------------------------------------------------------------------------------------------
	
	on btnSource pressed do
		(
		local arrTemp = getCurrentSelection()
		arrSrc = #()
		for obj in arrTemp do
			(
			if canConvertTo obj Editable_mesh do append arrSrc obj
			)
		lbxSource.items = for obj in arrSrc collect obj.name
		select arrSrc
		
		lbxSource.doubleClicked arrSrc.count
		lbxSource.selection = arrSrc.count
		)
		
	on lbxSource doubleClicked index do
		(
		if arrSrc.count > 1 do
			(
			objSrc = getNodeByName lbxSource.items[index]
			lblSource.text = "Source mesh: " + objSrc.name
			deselect objSrc
			selectmore objSrc
			flashnodes #(objSrc)
			completeredraw()
			)
		)
	
	on ddlAction selected index do
		(
		btnTarget.enabled = chkMaterial.enabled = index == 3
		checkOkToGo()
		)

	on btnTarget picked obj do
		(
		objTrg = obj
		btnTarget.text = obj.name
		ddlAction.selection = 3
		checkOkToGo()
		)

	on btnGo pressed do
		(
		case ddlAction.selection of
			(
			1:	safeCollapse arrSrc
			2:	safeCollapse arrSrc duplicate:true
			3:	safeCollapse arrSrc replaceNode:objTrg replaceMaterial:chkMaterial.checked
			)

		)

	on roCollapse open do
		(
		btnSource.pressed()
		)
)

createDialog roCollapse 





roCollapse.arrSrc.count