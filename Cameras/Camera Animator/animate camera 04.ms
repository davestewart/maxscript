try (destroydialog r1);catch()

rollout r1 "Camera Animator" width:176 height:550
(

	-----------------------------------------------------------------------------------------
	-- pre-declarations
	-----------------------------------------------------------------------------------------
	
		local isCamera

	
	-----------------------------------------------------------------------------------------
	-- interface
	-----------------------------------------------------------------------------------------
	
	GroupBox grpTemplateCameras "Template cameras" pos:[8,8] width:160 height:384
			
		button btnGrabCameras "Grab cameras from scene" pos:[16,24] width:144 height:16
		button btnPickCameras "Manually pick order" pos:[16,40] width:128 height:16
		checkbutton chkAppend "+" pos:[144,40] width:16 height:16 toolTip:"Append to / Insert into list"
		
		multiListBox lbxCameras "" pos:[16,60] width:144 height:20 multiSelect:true
		button btnUp "Up" pos:[16,328] width:64 height:16
		button btnDown "Down" pos:[80,328] width:64 height:16
		button btnKill "x" pos:[144,328] width:16 height:16
		
		spinner spnHoldTime "Hold time (frames)" pos:[67,352] width:90 height:16 range:[1,1000,75] type:#integer fieldwidth:35
		spinner spnMoveTime "Move time (frames)" pos:[64,368] width:93 height:16 range:[1,1000,25] type:#integer fieldwidth:35
		
	GroupBox grpAnimatedCamera "Animated camera" pos:[8,400] width:160 height:40
		pickbutton btnPickAnimated "Camera: pick camera" pos:[16,416] width:144 height:16 filter:isCamera
	
	GroupBox grpAnimate "Create animation" pos:[8,448] width:160 height:96
		label lblTangentType "Tangents:" pos:[16,468] width:56 height:16
		dropdownList ddlTangentType "" pos:[80,464] width:80 height:21 items:#("Slow", "Fast", "Smooth", "Auto", "Step", "Current")
		button btnAnimate "Animate camera now" pos:[16,512] width:144 height:24
		checkbox chkDuration "Update animation range" pos:[16,488] width:144 height:16 checked:true
			
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
					spinner spnHoldTime "Hold time (frames)" pos:[64,32] width:96 height:16 range:[1,1000,75] type:#integer
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
--for c in r1.arrCam do custAttributes.delete c 1
	-----------------------------------------------------------------------------------------
	-- utility functions
	-----------------------------------------------------------------------------------------
	
	
		fn trySetProperty obj prop val = (
			if hasProperty obj prop then setproperty obj prop val
			)
	
		fn pad strStr strPad:"0" length:2 =
			(
			strStr = strStr as string
			while strStr.count < length do strStr = strPad + strStr
			return strStr
			)
	
		fn getTangentType = 
			(
			return ddlTangentType.selected as name
			)
	
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
			v1 = getProperty obj1 ca
			v2 = getProperty obj2 ca
		
			if v1 == undefined then v1 = 9999999999
			if v2 == undefined then v2 = 9999999999
		
			case of
				(
				(v1 < v2): -1
				(v1 > v2): 1
				default: 0
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

		fn isCamera obj =
			(
			return superclassof obj == camera
			)
		

		fn setControllerKeyType ctrl type =
			(
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
					for i = 1 to ctrl.numsubs do setControllerKeyType ctrl[i] type 
					)
			-- if (isController ctrl) then ...
			)
	
	
		fn deleteAllCameraKeys c =	
			(
			local ctrlCam = c.position.controller
			for i = 1 to ctrl.numsubs do deleteKeys ctrlCam[i] #allkeys
			
			if c.target != undefined then
				(
				local ctrlTrg = c.target.position.controller
				for i = 1 to ctrl.numsubs do deleteKeys ctrlTrg[i] #allkeys
				)
			)


	-----------------------------------------------------------------------------------------
	-- main functions
	-----------------------------------------------------------------------------------------
	
		fn setCameraOrder =
			(
			for i = 1 to arrCam.count do
				(
				setUserProp arrCam[i] "CameraOrder" i
				trySetProperty arrCam[i].baseobject.cameraAnimationParameters #order i
				)
			)

		fn updateCameraList =
			(
			lbxCameras.items = for c in arrCam collect c.name
			setCameraOrder()
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


		fn updateSpinner arr spn prop =
			(
			local ca		= arr[1].baseObject.cameraAnimationParameters
			local val		= getProperty ca prop
			spn.value		= val
			
			for c in arr do
				(
				local ca	= c.baseObject.cameraAnimationParameters
				if getProperty ca prop != val then
					(
					spn.indeterminate = true
					exit
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
				arrCam = pickObject message:"Select cameras" count:#multiple filter:isCamera select:true forceListenerFocus:false
				deselect arrCam
				)
			else
				(
				arrCam = for c in cameras where superclassof c == camera AND c.name != animatedCameraName collect c
				qsort arrCam compareByUserProp prop:"CameraOrder"
				)
				
			addCaToCameras()
			setCameraOrder()
				
			if isValidNode animatedCamera then unhide animatedCamera 
			if arrCam != undefined then return arrCam
			else return #()
			)
		
	
					
		function animateCameraThroughTemplates=
			(
			-- local variables
				holdTime			= spnHoldTime.value
				moveTime			= spnMoveTime.value
				
				local tangentType	= ddlTangentType.selected as name
				
			-- loop thorugh cameras
			
			
				if animatedCamera == undefined then
					(
					createAnimatedCamera()
					getAnimatedCamera()
					)
			
				for i = 1 to arrCam.count do
					(
					local tStart = (i-1) * (moveTime + holdTime)
					local tEnd = tStart + holdTime
					
					-- format "start:% End:%\n" tStart tEnd
					
					local srcPos
					local trgPos
				
					with animate on at time tStart
						(
						--format "% %\n" arrCam[i].name arrCam[i].target--transform
						animatedCamera.transform = arrCam[i].transform
						animatedCamera.target.transform = arrCam[i].target.transform
						animatedCamera.fov = arrCam[i].fov
						)
						
					with animate on at time tEnd
						(
						--format "% %\n" arrCam[i].name arrCam[i].target--transform
						animatedCamera.transform = arrCam[i].transform
						animatedCamera.target.transform = arrCam[i].target.transform
						animatedCamera.fov = arrCam[i].fov
						)
					)
			-- set camera keys to slow
				setControllerKeyType animatedCamera.position.controller tangentType
				setControllerKeyType animatedCamera.target.position.controller tangentType
				setControllerKeyType animatedCamera.fov.controller tangentType
			
			
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
	-- do it
	
		on btnAnimate pressed do
			(
			--renameCameras()
			if arrCam.count > 0 then animateCameraThroughTemplates()
			if chkDuration.checked then animationRange = interval 0 ((holdTime + moveTime)*arrCam.count)
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

r1.lbxCameras.selection = 4

createdialog r1