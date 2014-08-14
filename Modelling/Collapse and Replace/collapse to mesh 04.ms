rollout roCollapse "Twin Towers" width:176 height:472
(
	--------------------------------------------------------------------------------------------------
	-- ui
	--------------------------------------------------------------------------------------------------
		groupBox grpSource "Source Objects" pos:[8,8] width:160 height:296
			listBox lbxSource "" pos:[16,24] width:144 height:17
			button btnSource "Grab Selected" pos:[16,254] width:144 height:16
			label lblSource "Double-click to set base mesh" pos:[16,272] width:144 height:28 tooltip:"Double-click to set base mesh"

		GroupBox grpAction "Action" pos:[8,312] width:160 height:48
			dropdownList ddlAction "" pos:[16,328] width:144 height:21 items:#("Replace original", "Duplicate original", "Replace Target") selection:2
			
		GroupBox grpTarget "Target Object" pos:[8,368] width:160 height:64
			pickbutton btnTarget "Pick ..." pos:[16,388] width:144 height:16
			checkbox chkMaterial "Replace material" pos:[16,408] width:104 height:16 checked:true
			
		button btnGo "Duplicate and Collapse" pos:[8,440] width:160 height:24


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
				--with redraw off
					--(
					-- variables
						local arr = #()
						local objSrc, objTrg, objOld, objNew
						
					-- copy objects and convert to mesh
						for objOld in sel do
							(
							objNew = copy objOld
							convertToMesh objNew
							if classof objNew == Editable_mesh then append arr objNew
							else delete objNew
							)
							
					-- error check
						if arr.count == 0 do (throwError 2; return false)
							
					-- setup source object
						objSrc = arr[arr.count]
						objSrc.material = copy objSrc.material
		
					-- do the collapse
						arr.count = arr.count - 1
						for objTrg in arr do
							(
							meshop.attach objSrc objTrg attachMat:#MatToID condenseMat:true
							)
						arr = undefined
							
					-- move / delete
						if moveTo != unsupplied then if classof moveTo == Point3 then objSrc.pos = moveTo
						if moveBy != unsupplied then if classof moveBy == Point3 then move objSrc moveBy
						
					-- select / replace
						if replaceNode != unsupplied AND isValidNode replaceNode == true AND replaceNode != objSrc then
							(
							replaceNode.baseObject = objSrc
							if replaceMaterial == true do replaceNode.material = objSrc.material
							delete objSrc
							)
						else
							(
							if duplicate == false do
								(
								--objSrc.name = sel[sel.count]
								delete sel
								)
							select objSrc
							)
					--)
				)
			)

	--------------------------------------------------------------------------------------------------
	-- ui functions
	--------------------------------------------------------------------------------------------------

		fn checkGoButton =
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
			
		fn setSourceObjects arr =
			(
			arrSrc = #()
			for obj in arr do
				(
				if canConvertTo obj Editable_mesh do append arrSrc obj
				)
			local items = for obj in arrSrc collect obj.name
			lbxSource.items = items

			lbxSource.selection = arrSrc.count
			lbxSource.doubleClicked arrSrc.count
			select arrSrc
			)
			
		fn checkSourceObjects =
			(
			local objectsOK = true
			for obj in arrSrc do
				(
				if NOT isValidNode obj do (objectsOK = false;exit)
				)
			if NOT objectsOK then
				(
				if (querybox "Objects have been deleted, or a new scene may have been opened / merged\nDo you want to attempt to recover the object references?") then
					(
					local arr = #()
					for item in lbxSource.items do
						(
						local objTmp = getNodeByName item
						if objTemp != undefined then append arr objTemp
						)
					setSourceObjects arr
					)
				return false
				)
			else return true
			/*
			*/
			)

		fn setBaseObject index =
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
	--------------------------------------------------------------------------------------------------
	-- handlers
	--------------------------------------------------------------------------------------------------
	
	on btnSource pressed do
		(
		lbxSource.items = #()
		local arr = getCurrentSelection()
		setSourceObjects arr
		)
		
	on lbxSource doubleClicked index do
		(
		setBaseObject index
		)
	
	on ddlAction selected index do
		(
		checkGoButton()
		)

	on btnTarget picked obj do
		(
		if isValidNode obj then
			(
			objTrg = obj
			btnTarget.text = obj.name
			ddlAction.selection = 3
			checkGoButton()
			)
		else
			(
			btnTarget.text = "Pick ..."
			)
		)

	on btnGo pressed do
		(
		if checkSourceObjects() == true then
			(
			case ddlAction.selection of
				(
				1:	(
					safeCollapse arrSrc
					lbxSource.items = #()
					arrSrc = #()
					)
				2:	(
					safeCollapse arrSrc duplicate:true
					)
				3:	safeCollapse arrSrc replaceNode:objTrg replaceMaterial:chkMaterial.checked
				)
			)
		)

	on roCollapse open do
		(
		btnSource.pressed()
		)
)

createDialog roCollapse 





roCollapse.arrSrc.count