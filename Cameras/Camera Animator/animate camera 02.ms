rollout r1 "Camera Animator" width:176 height:616
(
	
	-----------------------------------------------------------------------------------------
	-- interface
	-----------------------------------------------------------------------------------------
	
	GroupBox grpTemplateCameras "Template cameras" pos:[8,8] width:160 height:344
		
		button btnPick "Grab cameras from scene" pos:[16,24] width:144 height:16
		button btnPickTemplate "Manually pick order" pos:[16,40] width:144 height:16
		multiListBox lbxCameras "" pos:[16,60] width:144 height:20 multiSelect:true
		button btnDown "Down" pos:[16,328] width:72 height:16
		button btnUp "Up" pos:[88,328] width:72 height:16
	
	GroupBox grpAnimatedCamera "Animated camera" pos:[8,360] width:160 height:152
		
		radiobuttons rdoKeys "" pos:[16,400] width:105 height:32 labels:#("Use existing keys", "Create new keys")
		pickbutton btnPickAnimated "Camera: pick camera" pos:[16,376] width:144 height:16
		spinner spnHold "Hold time (frames)" pos:[72,440] width:88 height:16 enabled:false range:[1,1000,75] type:#integer
		spinner spnMove "Move time (frames)" pos:[67,456] width:93 height:16 enabled:false range:[1,1000,25] type:#integer
		label lblTangents "Tangents:" pos:[24,483] width:56 height:16
		dropdownList ddlTangentType "" pos:[80,480] width:80 height:21 items:#("Slow", "Fast", "Smooth", "Auto", "Step")
	
	GroupBox grpAnimate "Animate" pos:[8,520] width:160 height:88

		button btnAnimate "Animate!" pos:[16,536] width:144 height:24
		checkbox chkRename "Rename template cameras" pos:[16,568] width:144 height:16
		checkbox chkDuration "Update scene duration" pos:[16,584] width:144 height:16
			
	-----------------------------------------------------------------------------------------
	-- functions
	-----------------------------------------------------------------------------------------
	
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
		
		fn isCamera obj =
			(
			return superclassof obj == camera
			)
		

		function renameCameras =
			(
			local i = 1
			local camArray = for c in cameras where superclassof c == camera collect c
			for c in camArray do
				(
				local numStr = pad i
				local camName = "Camera" + numStr
				local trgName = camName + ".Target"
				c.name = camName
				if c.target != undefined then
					(
					c.target.name = trgName
					)
				i += 1
				)
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
					/*
			if (isController ctrl) then
				(
				)
			else( format "% is not a controller!\n" ctrl)
			*/
			)
	
		function animateCameraThroughExistingCameras =
			(
			-- grab existing animated camera or create new one
				camName = "Animated Camera"
				c = getNodeByName camName
				if NOT isvalidnode c then
					(
					c = Targetcamera target:(Targetobject()) name:camName
					c.target.name = c.name+".Target"
					c.wirecolor = c.target.wirecolor = color 0 255 0
					)
					
			-- delete keys of animated camera
				local ctrlCam = $'Animated Camera'.position.controller
				local ctrlTrg = $'Animated Camera'.target.position.controller
				
				for i = 1 to ctrl.numsubs do deleteKeys ctrlCam[i] #allkeys
				for i = 1 to ctrl.numsubs do deleteKeys ctrlTrg[i] #allkeys
		
			
			-- get existing cameras
				camArray = for c in cameras where superclassof c == camera AND c.name != camName collect c
			
				
			-- local variables
				moveTime = 25
				holdTime = 75
				
			-- loop thorugh cameras
				for i = 1 to camArray.count do
					(
					local tStart = (i-1) * (moveTime + holdTime)
					local tEnd = tStart + holdTime
					
					format "start:% End:%\n" tStart tEnd
					
					local srcPos
					local trgPos
				
					with animate on at time tStart
						(
						--format "% %\n" camArray[i].name camArray[i].target--transform
						c.transform = camArray[i].transform
						c.target.transform = camArray[i].target.transform
						c.fov = camArray[i].fov
						)
						
					with animate on at time tEnd
						(
						--format "% %\n" camArray[i].name camArray[i].target--transform
						c.transform = camArray[i].transform
						c.target.transform = camArray[i].target.transform
						c.fov = camArray[i].fov
						)
					)
			-- set camera keys to slow
				setControllerKeyType c.position.controller #slow
				setControllerKeyType c.target.position.controller #slow
				setControllerKeyType c.fov.controller #slow
			
			
			-- select camera
				select c
				if querybox "Set viewport to camera?" then max vpt camera
				--select #(c,c.target)
				--clearSelection()
			)
	
	

	-----------------------------------------------------------------------------------------
	-- handlers
	-----------------------------------------------------------------------------------------
		
	
		
		--renameCameras ()


	
	on btnAnimate pressed do
		(
		renameCameras()
		animateCameraThroughExistingCameras()
		)

	
		
		
		
)

createdialog r1