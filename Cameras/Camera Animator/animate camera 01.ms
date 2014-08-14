rollout r1 "Untitled" width:176 height:520
	(
	
	-----------------------------------------------------------------------------------------
	-- interface
	-----------------------------------------------------------------------------------------
	
		groupBox grpTemplate "Template cameras" pos:[8,8] width:160 height:320
		
			multiListBox lbxCameras "" pos:[16,24] width:144 height:20 items:#() multiSelect:true
			button btnDown "Down" pos:[16,288] width:72 height:16
			button btnUp "Up" pos:[88,288] width:64 height:16
			button btnPick "Pick new order" pos:[16,304] width:136 height:16
		
	
		groupBox grpAnimation "Animation" pos:[8,336] width:160 height:168
		
			spinner spnHold "Hold time (frames)" pos:[32,360] width:128 height:16 range:[0,100,0] type:#integer
			spinner spnMove "Move time (frames)" pos:[27,376] width:133 height:16 range:[0,100,0] type:#integer
	
			checkbox chkTangents "" pos:[144,400] width:16 height:16
			label lblTangents "Set tangents to slow" pos:[44,400] width:100 height:16
	
			button btnAnimate "Animate!" pos:[16,448] width:144 height:24
	
			checkbox chkTime "" pos:[144,480] width:16 height:16
			label lblTime "Update scene duration" pos:[32,480] width:112 height:16
			
			
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
		
		on btnPick pressed do
			(
			arrCam = pickObject message:"Select cameras" count:#multiple filter:isCamera select:true forceListenerFocus:false
			lbxCameras.items = for c in arrCam collect c.name
			)
	
		on btnAnimate pressed do
			(
			renameCameras()
			animateCameraThroughExistingCameras()
			)
		
		--renameCameras ()


	

	
	)
createdialog r1