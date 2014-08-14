-------------------------------------------------------------------------------------------------------------------------------
-- 
-- Camera Animator			
-- Animate a camera through a series of locked off template shots with user-updateable hold and move times
-- 
-------------------------------------------------------------------------------------------------------------------------------
--
-- version:		1.0
-- max version:	6
--
-- author:		Dave Stewart
-- website:		www.davestewart.co.uk / www.keyframesandcode.com
/*
-- history:		25 Aug 2006 - created

				18 May 2008	- added delete camera options
							- made animated camera's controller a list controller, so secondary movement can be added
							- added option to automatically add secondary movement keys
							- added options to make hold and move tangents different types
*/
-------------------------------------------------------------------------------------------------------------------------------


try (destroydialog roCameraAnimator);catch()

rollout roCameraAnimator "Camera Animator" width:192 height:688
(

	-----------------------------------------------------------------------------------------
	-- pre-declarations
	-----------------------------------------------------------------------------------------
	
		local isCamera

	
	-----------------------------------------------------------------------------------------
	-- interface
	-----------------------------------------------------------------------------------------
	

	GroupBox grpTemplateCameras "Template Cameras" pos:[8,8] width:176 height:344
		button btnGrabCameras "Grab cameras from scene" pos:[16,26] width:160 height:16
		button btnPickCameras "Manually pick order" pos:[16,42] width:144 height:16
		checkbutton btnAppend "+" pos:[160,42] width:16 height:16 enabled:false toolTip:"Append to / Insert into list"
		multiListBox lbxCameras "" pos:[16,58] width:160 height:17 multiselect:true
		button btnUp "Up" pos:[16,288] width:72 height:16
		button btnDown "Down" pos:[88,288] width:72 height:16
		button btnKill "x" pos:[160,288] width:16 height:16
		spinner spnHoldTime "Hold time (frames)" pos:[83,312] width:90 height:16 range:[0,1000,75] type:#integer fieldwidth:35
		spinner spnMoveTime "Move time (frames)" pos:[80,328] width:93 height:16 range:[1,1000,25] type:#integer fieldwidth:35

	GroupBox grpAnimatedCamera "Animated Camera" pos:[8,360] width:176 height:40
		button btnCreateAnimated "Create" pos:[16,376] width:56 height:16
		button btnSelectAnimated "Select" pos:[72,376] width:56 height:16
		button btnDeleteAnimated "Delete" pos:[128,376] width:48 height:16

	GroupBox grpSync "Viewport/List Synchronisation" pos:[8,408] width:176 height:40
		checkbutton ckbSync "Synchronize" pos:[16,424] width:160 height:16 toolTip:"" -- checked:true

	GroupBox grpAnimate "Create Animation" pos:[8,456] width:176 height:144
		dropdownList ddlControllers "" pos:[96,472] width:80 height:21 items:#("Position XYZ", "Bezier Position") selection:1
		label lblControllers "Controllers:" pos:[16,474] width:80 height:16
		dropdownList ddlTangentsMove "" pos:[96,496] width:80 height:21 items:#("Slow", "Fast", "Smooth", "Auto", "Linear", "Step", "Current")
		label lblTangentsMove "Move tangents:" pos:[16,498] width:80 height:16
		dropdownList ddlTangentsHold "" pos:[96,520] width:80 height:21 items:#("Slow", "Fast", "Smooth", "Auto", "Linear", "Step", "Current") selection:5
		label lblTangentsHold "Hold tangents:" pos:[16,522] width:80 height:16
		checkbox chkSecondaryKeys "Create secondary motion keys" pos:[16,544] width:164 height:16 checked:true
		button btnAnimate "Animate camera now" pos:[16,568] width:160 height:24

	GroupBox grpOptions "Options" pos:[8,608] width:176 height:72
		checkbox chkTrajectory "Show trajectories" pos:[16,624] width:160 height:16 checked:true
		checkbox chkDuration "Update animation range" pos:[16,640] width:160 height:16 checked:true
		checkbox chkViewport "Set viewport to camera" pos:[16,656] width:160 height:16 checked:false

	-----------------------------------------------------------------------------------------
	-- variables
	-----------------------------------------------------------------------------------------
	
		global caCameraAnimation
	
		local holdTime
		local moveTime
	
		local animatedCamera
		local animatedCameraName	= "Animated Camera"
		
		local arrCam				= #()
		local arrCamSel				= #()

	
	-----------------------------------------------------------------------------------------
	-- custom attributes
	-----------------------------------------------------------------------------------------
	
		fn createCameraAnimationCA =
		(
			caCameraAnimation = attributes cameraAnimationParameters
			(
				parameters main rollout:params
				(
					order type:#integer ui:spnOrder default:1 animatable:false
					holdTime type:#integer ui:spnHoldTime default:75 animatable:false
					moveTime type:#integer ui:spnMoveTime default:25 animatable:false
				)
				
				rollout params "Camera animation" width:168 height:136
			(
					spinner spnOrder "Order" pos:[100,8] width:60 height:16 range:[1,1000,1] type:#integer enabled:false
					spinner spnHoldTime "Hold time (frames)" pos:[64,32] width:96 height:16 range:[0,1000,75] type:#integer
					spinner spnMoveTime "Move time (frames)" pos:[62,48] width:98 height:16 range:[1,1000,25] type:#integer
					button btnReset "Reset" pos:[8,72] width:152 height:16
					
					on btnReset pressed do
					(
						spnHoldTime.value = 75
						spnMoveTime.value = 25
					)
				)
			)
		)
			
		fn objectHasCaDef obj defName =
		(
			if classof defName == String then defName = defName as name
			if custAttributes.count obj > 0 then
			(
				caDefs = for ca in (custAttributes.getDefs obj) collect ca.name
				return (finditem caDefs defName) != 0
			)
			else return 0
		)
	
		fn addCaToCameras =
		(
			for c in arrCam do
			(
				if (objectHasCaDef c #cameraAnimationParameters) == 0 then
				(
					custAttributes.add c caCameraAnimation
				)
			)
		)

		fn getCA obj defName prop =
		(
			-- variable declarations
				local ca, arrDefs, caDef
			-- get all defs
				arrDefs = custattributes.getDefs obj
			-- get the def
				for def in arrDefs do if def.name == defName then(caDef = def;exit) else return undefined
			-- get the ca
				ca = custattributes.get obj caDef
			-- test for property
				if hasproperty ca prop then return getproperty ca prop
				else return undefined
		)
			
--for c in roCameraAnimator.arrCam do custAttributes.delete c 1
	-----------------------------------------------------------------------------------------
	-- utility functions
	-----------------------------------------------------------------------------------------
	
		-- properties
			/*
			fn tryGetProperty obj prop =
			(
				if hasproperty obj prop then return getProperty obj prop
			)
			*/
			
			fn tryGetProperty obj prop = 
			(
				if isProperty obj prop then getproperty obj prop
			)

			fn trySetProperty obj prop val =
			(
				if hasProperty obj prop then setproperty obj prop val
			)
		
		-- utility
		
			fn pad strStr strPad:"0" length:2 =
			(
				strStr = strStr as string
				while strStr.count < length do strStr = strPad + strStr
				return strStr
			)
		
			fn isCamera obj =
			(
				return superclassof obj == camera
			)
			

		-- qsorting
		
			fn compareByName v1 v2 =
			(
				v1 = v1.name
				v2 = v2.name
				case of
				(
					(v1 < v2): -1
					(v1 > v2): 1
					default: 0
				)
			)
	
			fn compareByUserProp obj1 obj2 prop:unsupplied =
			(
				v1 = (getUserProp obj1 prop)
				v2 = (getUserProp obj2 prop)
			
				if v1 == undefined then v1 = 9999999999
				if v2 == undefined then v2 = 9999999999
			
				case of
				(
					(v1 < v2): -1
					(v1 > v2): 1
					default: 0
				)
			)
				
			fn compareByProperty obj1 obj2 prop:unsupplied =
			(
				v1 = (tryGetProperty obj1 prop)
				v2 = (tryGetProperty obj2 prop)
			
				if v1 == undefined then v1 = 9999999999
				if v2 == undefined then v2 = 9999999999
			
				case of
				(
					(v1 < v2): -1
					(v1 > v2): 1
					default: 0
				)
			)

			fn compareByCA obj1 obj2 defName:unsupplied prop:unsupplied =
			(
				v1 = getCA obj1 defName prop
				v2 = getCA obj2 defName prop
			
				if v1 == undefined then v1 = 9999999999
				if v2 == undefined then v2 = 9999999999
			
				v = case of
				(
					(v1 < v2): -1
					(v1 > v2): 1
					default: 0
				)
					
			)

				
		-- animation
		

			fn setControllerKeyType ctrl tangentTypeHold tangentTypeMove =
			(
				if ctrl == undefined do return false
				if ctrl.numsubs == 0 then
				(
					for i = 1 to ctrl.keys.count do
					(
						if mod i 2 == 1 then
						(
							ctrl.keys[i].inTangentType = tangentTypeMove 
							ctrl.keys[i].outTangentType = tangentTypeHold 
						)
						else
						(
							ctrl.keys[i].inTangentType = tangentTypeHold 
							ctrl.keys[i].outTangentType = tangentTypeMove 
						)
					)
				)
				else
				(
					for i = 1 to ctrl.numsubs do
					(
						setControllerKeyType ctrl[i] tangentTypeHold tangentTypeMove
					)
				)
				-- if (isController ctrl) then ...
			)

			fn deleteAllControllerKeys ctrl =
			(
				if ctrl == undefined do return false
				if ctrl.numsubs == 0 then deleteKeys ctrl #allkeys
				else for i = 1 to ctrl.numsubs do deleteAllControllerKeys ctrl[i]
			)


			fn deleteAllCameraKeys c =	
			(
				deleteAllControllerKeys c.pos.controller
				if c.target != undefined do deleteAllControllerKeys c.target.position.controller
				if c.fov.isanimated then deleteKeys c.fov.controller #allkeys
			)

			fn getNearestKey ctrl t =
			(
				local keyArr = ctrl.keys
				local k1, k2
			
				if t < keyArr[1].time then return keyArr[1]
				else if t > keyArr[keyArr.count].time then return keyArr[keyArr.count]
				
				else
				(
					for i = keyArr.count - 1 to 1 by -1 do
					(
						if t >= keyArr[i].time then
						(
							k1 = keyArr[i]
							k2 = keyArr[i + 1]
							exit
						)
					)
					if (t - k1.time) < (k2.time - t) then return k1
					else return k2
				)
			)

	-----------------------------------------------------------------------------------------
	-- supporting functions
	-----------------------------------------------------------------------------------------
	
	
		-- spinner update
/*
			fn updateSpinner arr spn prop =
			(
				local ca		= arr[1].baseObject.cameraAnimationParameters
				local val		= getProperty ca prop
				
				for c in arr do
				(
					local ca	= c.baseObject.cameraAnimationParameters
					if getProperty ca prop != val then
					(
						spn.indeterminate = true
						exit
					)
					else
					(
						spn.value		= val
					)
				)
			)
*/

			fn updateSpinner arr spn prop =
			(
				local val		= tryGetProperty arr[1] prop
				if arr.count == 1 then
				(
					spn.value		= val
				)
				else(
					for i = 2 to arr.count do
					(
						if tryGetProperty arr[i] prop != val then
						(
							spn.indeterminate = true
							exit
						)
						else
						(
							spn.value		= val
						)
					)
				)
			)

	
			fn updateCameraPropsSpinners arr =
			(
				updateSpinner arr spnHoldTime #holdTime
				updateSpinner arr spnMoveTime #moveTime
			)
	
	
			fn updateCameraProp arr prop val =
			(
				for c in arr do
				(
					local ca		= c.baseObject.cameraAnimationParameters
					setProperty ca prop val
				)
			)


	-----------------------------------------------------------------------------------------
	-- main functions
	-----------------------------------------------------------------------------------------
	
		-- camera colors
		
			function highlightCameras arrCamSel =
			(
				arrCam.wirecolor	= color 5 54 179
				arrCamSel.wirecolor	= color 255 255 0
			)

		-- camera order
	
			function setCameraOrder =
			(
				for i = 1 to arrCam.count do
				(
					--setUserProp arrCam[i] "CameraOrder" i
					trySetProperty arrCam[i].baseobject.cameraAnimationParameters #order i
				)
			)
	
			function updateCameraList =
			(
				lbxCameras.items = for c in arrCam collect c.name
				setCameraOrder()
			)


		-- camera animation

			function createAnimatedCamera =
			(
				animatedCamera = Targetcamera target:(Targetobject()) name:animatedCameraName
				animatedCamera.target.name = animatedCamera.name+".Target"
				animatedCamera.wirecolor = animatedCamera.target.wirecolor = color 0 255 0
				
				local ctrlClass = if ddlControllers.selection == 1 then Position_XYZ else Bezier_Position
				local pList = Position_List()
				animatedCamera.pos.controller = pList
				
				pList[1].controller = ctrlClass()
				pList[2].controller = ctrlClass()
				
				pList.setName 1 "Primary Motion"
				pList.setName 2 "Secondary Motion"
			)
		
			function getAnimatedCamera =
			(
				animatedCamera = getNodeByName animatedCameraName
				if animatedCamera != undefined then
				(
					animatedCamera.wireColor = color 0 255 0
					btnPickAnimated.text = animatedCamera.name
				)
			)
				
			
			function getTemplateCameras pick =
			(
				if isValidNode animatedCamera then hide animatedCamera 
				if pick then
				(
					arrCam = pickObject message:"Select cameras" count: #multiple select:true forceListenerFocus:false filter:isCamera 
					deselect arrCam
				)
				else
				(
					/*
					*/							
					local arrOldCams = for c in cameras where
												(superclassof c == camera) AND 
												(c.name != animatedCameraName) AND 
												(tryGetProperty c #order != undefined)
												collect c
					
					--print arrOldCams
					qsort arrOldCams compareByProperty prop:#order
					--print arrOldCams
					--arrCam = arrOldCams
					
					local arrNewCams = for c in cameras where
												(superclassof c == camera) AND 
												(c.name != animatedCameraName) AND 
												(tryGetProperty c #order == undefined)
												collect c
												
					qsort arrNewCams compareByName
					arrCam = join arrOldCams arrNewCams
				)
					
				addCaToCameras()
				setCameraOrder()
					
				if isValidNode animatedCamera then unhide animatedCamera 
				if arrCam != undefined then return arrCam
				else return #()
			)
			
			function checkTemplateCameras =
			(
				-- check all template cameras still exist
					local updateListFlag = false
					for i = arrCam.count to 1 by - 1 do
					(
						if isDeleted arrCam[i] then
						(
							updateListFlag = true
							exit
						)
					)
						
				-- update list if cameras deleted
					if updateListFlag then
					(
						btnGrabCameras.pressed()
					)
			)
		
			fn setSecondaryKey t =
			(
				local ctrlSecondary	= animatedCamera.pos.controller[2]
				if chkSecondaryKeys.checked do addnewkey ctrlSecondary t
			)
						
			function animateCameraThroughTemplates =
			(
				-- vars
					local updateListFlag	= false
					local tangentType		= ddlTangentsMove.selected as name
					local tangentTypeMove	= ddlTangentsMove.selected as name
					local tangentTypeHold	= ddlTangentsHold.selected as name
					local t					= 0
					
				-- check for animated camera
					if NOT isvalidnode animatedCamera then
					(
						createAnimatedCamera()
						getAnimatedCamera()
					)
					deleteAllCameraKeys animatedCamera
					
				-- check for template cameras
					checkTemplateCameras()
					
				-- set up position
					animatedCamera.pos				= arrCam[1].pos
					animatedCamera.target.pos		= arrCam[1].target.pos
					animatedCamera.fov				= arrCam[1].fov
					
					setSecondaryKey 0
	
				-- loop thorugh cameras
					for i = 1 to arrCam.count do
					(

						-- variables
							local holdTime		= tryGetProperty arrCam[i] #holdTime
							local moveTime		= tryGetProperty arrCam[i] #moveTime
							
						-- animate start of move
							t += holdTime
							setSecondaryKey t
							with animate on at time t
							(
								animatedCamera.pos				= arrCam[i].pos
								animatedCamera.target.pos		= arrCam[i].target.pos
								animatedCamera.fov				= arrCam[i].fov
							)
								
						-- animate end of move
							t += moveTime
							if i < arrCam.count then
							(
								setSecondaryKey t
								with animate on at time t
								(
									animatedCamera.pos				= arrCam[i + 1].pos
									animatedCamera.target.pos		= arrCam[i + 1].target.pos
									animatedCamera.fov				= arrCam[i + 1].fov
								)
							)
					)
								
				-- set controller key types
					setControllerKeyType animatedCamera.position.controller[1].controller tangentTypeHold tangentTypeMove
					setControllerKeyType animatedCamera.position.controller[2].controller tangentTypeHold tangentTypeMove
					setControllerKeyType animatedCamera.target.position.controller tangentTypeHold tangentTypeMove
					setControllerKeyType animatedCamera.fov.controller tangentTypeHold tangentTypeMove
				
				
				-- update animation range
					if chkDuration.checked then animationRange = interval 0 t
					redrawViews()
					forcecompleteredraw()
				
				-- select camera
					select animatedCamera
					if chkViewport.checked then max vpt camera
					--select #(c,c.target)
					--clearSelection()
					
			)
	
	

	-----------------------------------------------------------------------------------------
	-- handlers
	-----------------------------------------------------------------------------------------
		
	-----------------------------------------------------------------------------------------
	-- camera list

		on btnGrabCameras pressed do
		(
			arrCam = getTemplateCameras false
			lbxCameras.items = for c in arrCam collect c.name
		)
		
		on btnPickCameras pressed do
		(
			arrCam = getTemplateCameras true
			updateCameraList()
			setCameraOrder()
			lbxCameras.selection = #{1}
		)
			
			
		/*
		on lbxCameras selected index do
		(
			local baSel		= lbxCameras.selection 
			local arrSel	= #()
			if baSel[index] == true then
			(
				local camNode = getNodeByName lbxCameras.items[index]
				append arrSel camNode
			)
			flashnodes arrSel
		)
			*/
	
		on lbxCameras selectionEnd do
		(
			arrCamSel = for i in lbxCameras.selection collect arrCam[i]
			updateCameraPropsSpinners arrCamSel
			highlightCameras arrCamSel
		)

		on lbxCameras doubleclicked index do
		(
			local obj = lbxCameras.items[index]
			try(
				local cam = getNodeByName obj
				select cam
				if viewport.getType() == #view_camera then viewport.setCamera cam
			)
			catch(err)
		)
			
		on btnUp pressed do
		(
			-- vars
				local ba1 = lbxCameras.selection
			-- move the array about
				for i = 2 to ba1.count do
				(
					if ba1[i] == true then swap arrCam[i] arrCam[i-1]
				)
			-- update list
				updateCameraList()
				ba2 = #{}
				for i = 2 to ba1.count do ba2[i-1] = ba1[i]
				lbxCameras.selection = ba2
		)
		
		on btnDown pressed do
		(
			-- vars
				local ba1 = lbxCameras.selection
			-- move the array about
				for i = (ba1.count - 1) to 1 by -1 do
				(
					if ba1[i] == true then swap arrCam[i+1] arrCam[i]
				)
			-- update list
				updateCameraList()
				ba2 = #{}
	--			for i = (ba1.count - 1) to 2 by -1 do ba2[i+1] = ba1[i]
				for i = 1 to (ba1.count - 1) do ba2[i+1] = ba1[i]
				lbxCameras.selection = ba2
		)
		
		on btnKill pressed do
		(
			local index
			local sel	= lbxCameras.selection as array
			local items	= lbxCameras.items
			for i = sel.count to 1 by -1 do
			(
				index = sel[i]
				deleteItem items index
				deleteItem arrCam index
			)
			lbxCameras.items = items
		)

	-----------------------------------------------------------------------------------------
	-- time values

		on spnHoldTime changed val do
		(
			updateCameraProp arrCamSel #holdTime val
		)
	
		on spnMoveTime changed val do
		(
			updateCameraProp arrCamSel #moveTime val
		)
	

	-----------------------------------------------------------------------------------------
	-- animated camera

		on btnCreateAnimated pressed do
		(
			if NOT isValidNode animatedCamera do createAnimatedCamera()
		)
		on btnSelectAnimated pressed do
		(
			if isValidNode animatedCamera do select animatedCamera
		)
		on btnDeleteAnimated pressed do
		(
			if isValidNode animatedCamera do if querybox "Are you sure you want to delete the animated camera?" do delete animatedCamera
		)
			
	
	
	-----------------------------------------------------------------------------------------
	-- time callbacks
	
		fn updateLbxCameras = 
		(
			-- exit if no animated camera
				if NOT isValidNode animatedcamera then
				(
					unregisterTimeCallback tcb_CameraAnimator
					return false
				)

			-- get properties
				local ctrl	= animatedcamera.position.controller[1].controller
				if ctrl.keys.count == 0 do return false

				local k		= getNearestKey ctrl slidertime
				local t		= k.time
				local p		= at time t ctrl.value
		
			-- get camera	
				local arr = (for c in arrCam where c.pos == p and c != animatedCamera collect c)
				if arr.count > 0 then
				(
					local cam = arr[1]
					local i = tryGetProperty cam #order
					
				-- update list
					if lbxCameras.selection != #{i} then lbxCameras.selection = #{i}
				)
		)
		
		fn tcb_CameraAnimator = updateLbxCameras()
	
		on ckbSync changed state do
		(
			if state then
			(
				updateLbxCameras()
				registerTimeCallback tcb_CameraAnimator
			)
			else unregisterTimeCallback tcb_CameraAnimator
		)


	
	-----------------------------------------------------------------------------------------
	-- do it
	
		on btnAnimate pressed do
		(
			--renameCameras()
			if arrCam.count > 0 then animateCameraThroughTemplates()
			animatedCamera.showTrajectory = chkTrajectory.checked
			if animatedCamera.target != undefined then animatedCamera.target.showTrajectory = chkTrajectory.checked
		)
			
	-----------------------------------------------------------------------------------------
	-- open
	
		on roCameraAnimator open do
		(
			createCameraAnimationCA()
			getAnimatedCamera()
			btnGrabCameras.pressed()
		)
			
		on roCameraAnimator close do
		(
			ckbSync.changed(false)
		)

		
)

createdialog roCameraAnimator