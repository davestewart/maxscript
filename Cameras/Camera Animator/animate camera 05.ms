try (destroydialog r1);catch()

rollout r1 "Camera Animator" width:176 height:616
(

	-----------------------------------------------------------------------------------------
	-- pre-declarations
	-----------------------------------------------------------------------------------------
	
		local isCamera

	
	-----------------------------------------------------------------------------------------
	-- interface
	-----------------------------------------------------------------------------------------
	
	GroupBox grpTemplateCameras "Template Cameras" pos:[8,8] width:160 height:384
		button btnGrabCameras "Grab cameras from scene" pos:[16,24] width:144 height:16
		button btnPickCameras "Manually pick order" pos:[16,40] width:128 height:16
		checkbutton chkAppend "+" pos:[144,40] width:16 height:16 toolTip:"Append to / Insert into list"
			
		multiListBox lbxCameras "" pos:[16,60] width:144 height:20 multiSelect:true
		button btnUp "Up" pos:[16,328] width:64 height:16
		button btnDown "Down" pos:[80,328] width:64 height:16
		button btnKill "x" pos:[144,328] width:16 height:16
			
		spinner spnHoldTime "Hold time (frames)" pos:[67,352] width:90 height:16 range:[0,1000,75] type:#integer fieldwidth:35
		spinner spnMoveTime "Move time (frames)" pos:[64,368] width:93 height:16 range:[1,1000,25] type:#integer fieldwidth:35
		
	GroupBox grpAnimatedCamera "Animated Camera" pos:[8,400] width:160 height:40
		pickbutton btnPickAnimated "Camera: pick camera" pos:[16,416] width:144 height:16 filter:isCamera
	
	groupBox grpSync "Viewport/List Synchronisation" pos:[8,448] width:160 height:40
		checkButton ckbSync "Synchronize" pos:[16,464] width:144 height:16 toolTip:"" checked:true

	GroupBox grpAnimate "Create Animation" pos:[8,496] width:160 height:112
		label lblTangentType "Tangents:" pos:[16,516] width:56 height:16
		dropdownList ddlTangentType "" pos:[80,512] width:80 height:21 items:#("Slow", "Fast", "Smooth", "Auto", "Step", "Current")
		checkbox chkDuration "Update animation range" pos:[16,536] width:144 height:16 checked:true
		checkbox chkTrajectory "Show trajectories" pos:[16,552] width:144 height:16 checked:true

		button btnAnimate "Animate camera now" pos:[16,576] width:144 height:24

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


			
--for c in r1.arrCam do custAttributes.delete c 1
	-----------------------------------------------------------------------------------------
	-- utility functions
	-----------------------------------------------------------------------------------------
	
		-- properties
	
			fn trySetProperty obj prop val = (
				if hasProperty obj prop then setproperty obj prop val
			)
		
			fn tryGetProperty obj prop = (
				if hasproperty obj prop then return getProperty obj prop
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
	
			fn compareByCA obj1 obj2 ca:unsupplied =
			(
				v1 = tryGetProperty obj1 ca
				v2 = tryGetProperty obj2 ca
			
				if v1 == undefined then v1 = 9999999999
				if v2 == undefined then v2 = 9999999999
			
				case of
				(
					(v1 < v2): -1
					(v1 > v2): 1
					default: 0
				)
			)
				
		-- animation
		
			fn getTangentType = 
			(
				return ddlTangentType.selected as name
			)
		
			fn setControllerKeyType ctrl type =
			(
				if ctrl == undefined then return false
				if ctrl.numsubs == 0 then
				(
					for k in ctrl.keys do
					(
						k.inTangentType = type
						k.outTangentType = type
					)
				)
				else
				(
					for i = 1 to ctrl.numsubs do
					(
						setControllerKeyType ctrl[i] type 
					)
				)
				-- if (isController ctrl) then ...
			)
		
			fn deleteAllCameraKeys c =	
			(
				local ctrl = c.position.controller
				
				--format "% % \n" c ctrl
				
				for i = 1 to ctrl.numsubs do deleteKeys ctrl[i] #allkeys
				
				if c.target != undefined then
				(
					local ctrl = c.target.position.controller
					for i = 1 to ctrl.numsubs do deleteKeys ctrl[i] #allkeys
				)
					
				if c.fov.isanimated then deleteKeys c.fov.controller #allkeys
			)

			fn getNearestKey ctrl t =
			(
				local k1, k2
				local keyArr = ctrl.keys
				for i = 1 to keyArr.count do if keyArr[i].time >= t then
				(
					k2 = keyArr[i]
					if i > 1 then k1 = keyArr[i-1] else k1 = k2
					exit
				)
					
				if (t - k1.time) < (k2.time - t) then return k1
				else return k2
			)
	
	-----------------------------------------------------------------------------------------
	-- supporting functions
	-----------------------------------------------------------------------------------------
	
	
		-- spinner update

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
	

		-- camera order
	
			function setCameraOrder =
			(
				for i = 1 to arrCam.count do
				(
					setUserProp arrCam[i] "CameraOrder" i
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
					local arrOldCams = for c in cameras where
												(superclassof c == camera) AND 
												(c.name != animatedCameraName) AND 
												(tryGetProperty c.cameraAnimationParameters #order != undefined)
												collect c
												
					qsort arrOldCams compareByCA ca:#order
					*/							
					
					local arrNewCams = for c in cameras where
												(superclassof c == camera) AND 
												(c.name != animatedCameraName) AND 
												(tryGetProperty c #cameraAnimationParameters == undefined)
												collect c
												
					qsort arrNewCams compareByName
	
					--arrCam = join arrOldCams arrNewCams
					arrCam = arrNewCams
				)
					
				addCaToCameras()
				setCameraOrder()
					
				if isValidNode animatedCamera then unhide animatedCamera 
				if arrCam != undefined then return arrCam
				else return #()
			)
			
		
						
			function animateCameraThroughTemplates=
			(
				-- vars
					local tangentType	= ddlTangentType.selected as name
					local t				= 0
					
				-- check for animated camera
					if NOT isvalidnode animatedCamera then
					(
						createAnimatedCamera()
						getAnimatedCamera()
					)
					deleteAllCameraKeys animatedCamera
	
				
				-- set up position
					animatedCamera.pos				= arrCam[1].pos
					animatedCamera.target.pos		= arrCam[1].target.pos
	
				-- loop thorugh cameras
					for i = 1 to arrCam.count do
					(
						-- variables
							local holdTime		= tryGetProperty arrCam[i].cameraAnimationParameters  #holdTime
							local moveTime		= tryGetProperty arrCam[i].cameraAnimationParameters  #moveTime
							
						-- animate start of move
							t += holdTime
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
								with animate on at time t
								(
									animatedCamera.pos				= arrCam[i+1].pos
									animatedCamera.target.pos		= arrCam[i+1].target.pos
									animatedCamera.fov				= arrCam[i+1].fov
								)
							)
					)
								
				-- set camera keys to slow
					setControllerKeyType animatedCamera.position.controller tangentType
					setControllerKeyType animatedCamera.target.position.controller tangentType
					setControllerKeyType animatedCamera.fov.controller tangentType
				
				
				-- update animation range
	
					if chkDuration.checked then animationRange = interval 0 t
	
				
				-- select camera
					select animatedCamera
					if querybox "Set viewport to camera?" then max vpt camera
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
			lbxCameras.selection = #{}
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
		
		
		on lbxCameras doubleclicked index do
		(
			local obj = lbxCameras.items[index]
			try	(select (getNodeByName obj))
			catch(err)
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

		on btnPickAnimated picked obj do
		(
			animatedCamera = obj
			btnPickAnimated.text = obj.name
		)
	
	
	-----------------------------------------------------------------------------------------
	-- time callbacks
	
		fn updateLbxCameras = 
		(
			-- exit if no animated camera
				if NOT isValidNode animatedcamera
				(
					unregisterTimeCallback tcb_CameraAnimator
					return false
				)
			-- get properties
				local k = getNearestKey animatedcamera.position.controller slidertime
				local t = k.time
				local p = at time t ctrl.value
		
			-- get camera	
				local cam = for c in arrCam where c.pos == p and c != animatedCamera collect c
				local i = tryGetProperty cam.cameraAnimationParameters #order
				
			-- update list
				lbxCameras.selection = #{i}
		)
		
		fn tcb_CameraAnimator = updateLbxCameras()
	
		on ckbSync changed state do
		(
			if state then registerTimeCallback tcb_CameraAnimator
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
	
		on r1 open do
		(
			createCameraAnimationCA()
			getAnimatedCamera()
			btnGrabCameras.pressed()
		)

		
)

createdialog r1