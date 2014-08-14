-------------------------------------------------------------------------------------------------------------------------------
-- 
-- Collapse and Replace
--
-- Collapse a selection of objects to one mesh, retaining materials and mapping, and optionally replace
-- another object's base mesh with the new mesh. Useful for modelling and animation when you need one mesh
-- but still need access to the original objects
-- 
-------------------------------------------------------------------------------------------------------------------------------
--
-- version:		0.6
-- max version:	7+
--
-- author:		Dave Stewart
-- website:		www.davestewart.co.uk / www.keyframesandcode.com
/*
-- history:		6 Oct 2006 - created
				12 May 2008	- updated interface and fixed a bug where newly created objects lost their correct pivot point position
*/
-------------------------------------------------------------------------------------------------------------------------------

try(destroyDialog roCollapse );catch()
rollout roCollapse "Collapse and Replace" width:176 height:560
(

	--------------------------------------------------------------------------------------------------
	-- variables
	--------------------------------------------------------------------------------------------------

		local arrSrc	= #()
		local objSrc, objTrg
		local pickFilter

	--------------------------------------------------------------------------------------------------
	-- ui
	--------------------------------------------------------------------------------------------------
	
	GroupBox grpSource "Source Objects" pos:[8,8] width:160 height:288
		listbox lbxSource "" pos:[16,24] width:144 height:17
		button btnSource "Grab Selected" pos:[16,256] width:128 height:16 toolTip:"Grab selected objects"
		button btnClear "x" pos:[144,256] width:16 height:16 toolTip:"Clear source objects"
		pickbutton pckPivot "Pick pivot mesh..." pos:[16,272] width:144 height:16 toolTip:"Select which object should provide the pivot point for the new mesh (you can also double-click the Source Objects list to do this)"-- filter:pickFilter
		
	GroupBox grpTarget "Target Mesh" pos:[8,304] width:160 height:64
		pickbutton btnTarget "Pick ..." pos:[16,323] width:144 height:16
		checkbox chkMaterial "Replace material" pos:[16,344] width:104 height:16 checked:true
		
	GroupBox grpAction "Action" pos:[8,376] width:160 height:104
		radiobuttons rdoAction "" pos:[16,392] width:135 height:48 labels:#("Collapse source objects", "Create a new mesh", "Update a target mesh") default:1
		button btnGo "Duplicate and Collapse" pos:[16,448] width:144 height:24
	
	GroupBox grpAbout "About" pos:[8,488] width:160 height:62
		ActiveXControl axFlash "{D27CDB6E-AE6D-11CF-96B8-444553540000}" pos:[16,504] width:144 height:40


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
					throw str[n]
					)
					
				if NOT (classof sel == ObjectSet OR classof sel == Array OR superClassof sel == GeometryClass) do (throwError 1; return false)
		
			-- do it!
				--undo "Safe-collpase to mesh" on
					(
					with redraw off
						(
						-- variables
							local arr = #()
							local objSrc, objTrg, objOld, objNew
							
						-- get rid of non mesh objects
							if duplicate == false then
								(
								arr = sel
								for i = sel.count to 1 do if NOT canConvertTo sel[i] Editable_mesh do deleteitem sel i
								convertToMesh arr
								sel = #()
								)
						-- copy objects and convert to mesh
							else
								(
								for objOld in sel do
									(
									objNew = copy objOld
									convertToMesh objNew
									if classof objNew == Editable_mesh then append arr objNew
									else delete objNew
									)
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
							else if duplicate == true then
								(
								select objSrc
								)
							else
								(
								if objSrc.parent == undefined do setGroupMember objSrc false
								select objSrc
								)
						)
					)
			)

	--------------------------------------------------------------------------------------------------
	-- ui functions
	--------------------------------------------------------------------------------------------------

		fn initAbout =
			(
			local col = colorMan.getColor #background
			axFlash.BackgroundColor = ((col.x * 65536) + (col.y * 256) + col.z) * 255
			try(
				local mov		= "http://www.davestewart.co.uk/images/web/davestewart.swf"
				axFlash.movie	= mov
				axFlash.movie	= mov
				axFlash.SAlign	= "ML"
				axFlash.Menu	= false
				);
			catch()
			)

		fn checkGoButton =
			(
			-- vars
				local index = rdoAction.state
				
			-- button text
				case index of
					(
					1:	(
						btnGo.text = "Collapse"
						btnGo.enabled = arrSrc.count > 0
						)
							
					2:	(
						btnGo.text = "Create New"
						btnGo.enabled = arrSrc.count > 0
						)
						
					3:	(
						btnGo.text = "Update Target"
						btnGo.enabled = arrSrc.count > 0 AND isValidNode objTrg
						if NOT isValidNode objTrg then btnTarget.text = "Pick..."
						)
					)
			)
			
		fn setSourceObjects arr =
			(
			arrSrc = #()
			for obj in arr do if canConvertTo obj Editable_mesh do append arrSrc obj
			if arrSrc.count > 1 then
				(
				local items = for obj in arrSrc collect obj.name
				lbxSource.items = items
				)
			else(
				arrSrc = #()
				)
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
			)

		fn pickFilter obj =
			(
			finditem arrSrc obj > 0
			)

		fn setBaseObject index: obj: =
			(
			-- variables
				objSrc = undefined
			
			-- set correct base object
				if arrSrc.count > 1 do
					(
					if index != unsupplied then
						(
						objSrc = getNodeByName lbxSource.items[index]
						)
					else if obj != unsupplied then
						(
						objSrc = if finditem lbxSource.items obj.name > 0 then obj else undefined
						)
					)

			-- base object needs to be last for correct pivot position

			-- update ui and variables
				if objSrc != undefined then
					(
					-- array
						local index = finditem arrSrc objSrc
						deleteItem arrSrc index
						append arrSrc objSrc
						
					-- ui
						pckPivot.text = "Pivot mesh: " + objSrc.name
						lbxSource.selection = finditem lbxSource.items objSrc.name
						flashnodes #(objSrc)
						completeredraw()
					)
				else
					(
					pckPivot.text = "Pick pivot mesh..."
					)
			)
	--------------------------------------------------------------------------------------------------
	-- handlers
	--------------------------------------------------------------------------------------------------
	
		on lbxSource doubleClicked index do
			(
			setBaseObject index:index
			)
		
		on btnSource pressed do
			(
			lbxSource.items = #()
			setSourceObjects (getCurrentSelection())
			if objSrc == undefined do setBaseObject obj:arrSrc[1]
			checkGoButton()
			)
			
		on btnClear pressed do
			(
			arrSrc = #()
			lbxSource.doubleClicked 0
			lbxSource.items = #()
			checkGoButton()
			)
			
		on pckPivot picked obj do
			(
			setBaseObject obj:obj
			)
			
		on rdoAction changed state do
			(
			checkGoButton()
			)
	
		on btnTarget picked obj do
			(
			if isValidNode obj then
				(
				objTrg = obj
				btnTarget.text = obj.name
				rdoAction.state = 3
				checkGoButton()
				)
			else
				(
				btnTarget.text = "Pick ..."
				)
			)
	
		on btnGo pressed do
			(
			if checkSourceObjects() == true then undo "Safe-collpase to mesh" on
				(
				max create mode
				case rdoAction.state of
					(
					1:	(
						safeCollapse arrSrc
						lbxSource.items = #()
						arrSrc = #()
						)
					2:	(
						safeCollapse arrSrc duplicate:true
						)
					3:	safeCollapse arrSrc duplicate:true replaceNode:objTrg replaceMaterial:chkMaterial.checked
					)
				)
			)
	
		on roCollapse open do
			(
			initAbout()
			checkGoButton()
			btnSource.pressed()
			)
)

createDialog roCollapse 