try(
	destroyDialog roAETracker
)
catch()


rollout roAETracker "After Effects Tracker" width:192 height:528
(


	-------------------------------------------------------------------------------------------
	-- pre-declarations
	-------------------------------------------------------------------------------------------

		global rcMenuVertList
		local testing = false

		fn filterIsPlane obj = classof obj.baseobject == Plane
		fn filterIsCamera obj = superclassof obj == Camera

	-------------------------------------------------------------------------------------------
	-- includes
	-------------------------------------------------------------------------------------------

		include "ui 02.ms"
		include "worldToCam 06.ms"
		include "worldToVpt 06.ms"
		include "ae keyframe data 05.ms"
		include "controller functions 01.ms"

	-------------------------------------------------------------------------------------------
	-- ui
	-------------------------------------------------------------------------------------------
	
		GroupBox grp3dsmax "Tracked Object" pos:[8,8] width:176 height:128
			dropDownList ddlType "" pos:[48,24] width:128 height:21 items:#("1-point (any object)", "2-point (2 objects)", "4-point (a plane)") selection:3
			label lblType "Type:" pos:[17,27] width:28 height:16
	
			pickbutton pckTracker1 "Object 1" pos:[16,56] width:144 height:16 filter:filterIsPlane --
			button btnResetTracker1 "x" pos:[160,56] width:16 height:16 toolTip:"Kill Tracker"
			pickbutton pckTracker2 "Object 2" pos:[16,72] width:144 height:16 
			button btnResetTracker2 "x" pos:[160,72] width:16 height:16 toolTip:"Kill Tracker"
	
			button btnCorner1 "3" pos:[96,96] width:16 height:16 --
			button btnCorner2 "4" pos:[112,96] width:16 height:16
			label lblVertex "Vertex Order:" pos:[24,104] width:64 height:16
			checkbutton btnShowVerts "@" pos:[144,104] width:16 height:16 toolTip:"Show verts"
			button btnResetVerts "x" pos:[160,104] width:16 height:16 toolTip:"Reset vertex order"
			button btnCorner3 "1" pos:[96,112] width:16 height:16
			button btnCorner4 "2" pos:[112,112] width:16 height:16
	
		GroupBox grpCamera "Camera" pos:[8,144] width:176 height:40
			--pickbutton pckCamera "Pick Camera..." pos:[16,160] width:128 height:16 filter:filterIsCamera
			--button btnAutoCam "Auto" pos:[144,160] width:32 height:16 toolTip:"Reset vertex order" checked:true
			pickbutton pckCamera "Pick Camera..." pos:[16,160] width:144 height:16 filter:filterIsCamera
			button btnGrabCam "<" pos:[160,160] width:16 height:16 toolTip:"Reset vertex order" checked:true
	
		GroupBox grpAfterEffects "After Effects Comps" pos:[8,192] width:176 height:104
			label lblMainComp "Main Composition" pos:[16,216] width:120 height:16
			spinner spnCompWidth "Size:" pos:[36,232] width:64 height:16 range:[0,2000,0] type:#integer fieldwidth:35 across:2
			spinner spnCompHeight " x " pos:[94,232] width:64 height:16 range:[0,2000,0] type:#integer fieldwidth:35
			button btnGrabMainSize "<" pos:[160,232] width:16 height:16
	
			label lblTrackComp "Tracked Layer" pos:[16,256] width:120 height:16 --
			spinner spnTrackWidth "Size:" pos:[36,272] width:64 height:16 range:[0,2000,0] type:#integer fieldwidth:35 across:2
			spinner spnTrackHeight "x " pos:[94,272] width:64 height:16 range:[0,2000,0] type:#integer fieldwidth:35
			button btnGrabTrackSize "<" pos:[160,272] width:16 height:16
	
		GroupBox grpTime "Time" pos:[8,304] width:176 height:40
			spinner spnTimeStart "Start:" pos:[36,320] width:64 height:16 range:[0,1000,0] type:#integer fieldwidth:35
			spinner spnTimeEnd "to" pos:[94,320] width:64 height:16 range:[0,1000,0] type:#integer fieldwidth:35
			button resetTime "<" pos:[160,320] width:16 height:16
	
		GroupBox grpTrack "Track" pos:[8,352] width:176 height:96
			checkbox chkDisplay "Display on Screen" pos:[16,368] width:160 height:16 checked:true
			checkbox chkCopy "Copy to clipboard" pos:[16,384] width:160 height:16 checked:true
	
			button btnCalculate "Calculate now" pos:[16,408] width:160 height:24
			progressBar pb1 "ProgressBar" pos:[16,434] width:160 height:8 value:100
	
		GroupBox grpCopy "Copy" pos:[8,456] width:176 height:64
			button btnCopyTrack "Tracking data" pos:[16,476] width:160 height:16
			button btnCopyDepth "Depth data" pos:[16,496] width:160 height:16

	
	
	
	-------------------------------------------------------------------------------------------
	-- variables
	-------------------------------------------------------------------------------------------
	
		-- tracker
			local objTracker1	= undefined
			local objTracker2	= undefined
			local objCamera		= undefined
			
		-- tracking data
			local arrTrack		= #()
			local arrMesh		= #()
			
			local showVertsCb
			
		-- parameters
			local trackerSize	= [0,0]
			local renderSize	= [0,0]
			local timeSegment	= interval 0f 0f

		-- vertex order			
			local defaultVertexOrder = #(3,4,1,2)
			local vertexOrder	= #(3,4,1,2)
			local btnCornerDown	= 0
			local arrCorners	= #(btnCorner1, btnCorner2, btnCorner3, btnCorner4)
	
		-- testing
			--local vert			= 1
			

	
	-------------------------------------------------------------------------------------------
	-- functions
	-------------------------------------------------------------------------------------------
	
		---------------------------------------------------------------------------------------
		-- Vertex display

			fn displayVertOrder state =
			(
				if state == true then
				(
					fn showVertsCb = showVertexOrder objTracker1
					registerRedrawViewsCallback showVertsCb 
				)
				else
				(
					unRegisterRedrawViewsCallback showVertsCb
				)
				completeRedraw()
			)
	
			fn getVertexOrder i =
			(
				if objTracker1 != undefined then
				(
					btnCornerDown = i
					popupMenu rcMenuVertList
				)
			)
	
			fn setVertexOrder i v =
			(
				local iOld = finditem vertexOrder v
				if iOld != 0 then
				(
					arrCorners[iOld].text = arrCorners[i].text
					vertexOrder[iOld] = arrCorners[iOld].text as number
				)
				arrCorners[i].text = v as string
				vertexOrder[i] = v
			)
	
			fn resetVertexOrder =
			(
				vertexOrder = copy defaultVertexOrder #nomap
				for i = 1 to arrCorners.count do arrCorners[i].text = vertexOrder[i] as string
			)
			
		---------------------------------------------------------------------------------------
		-- Tracked object
					
			fn setTracker index obj =
			(
				if getnumverts obj.baseobject.mesh != 4 then
				(
					if querybox "In order to use this object for tracking, it needs to have 4 vertices. Would you like to make the adjustment automatically?" then
					(
						try
						(
							obj.lengthsegs	= 1
							obj.widthsegs	= 1
						)
						catch(
							return false
						)
					)
					else return false
				)
				if index == 1 then
				(
					objTracker1 = obj
					pckTracker1.text = "Object 1: " + obj.name
				)
				else
				(
					objTracker2 = obj
					pckTracker2.text = "Object 2: " + obj.name
				)
			)
	
			fn getTracker =
			(
				local obj, sel = getCurrentSelection()
				if sel.count == 1 then
				(
					obj = sel[1]
					if filterIsPlane obj then setTracker 1 obj
				)
				else
				(
					obj = for i = 1 to objects.count do if filterIsPlane objects[i] then exit with objects[i]
					if obj != undefined then setTracker 1 obj
				)
			)
	
			fn getTrackSize =
			(
				if isValidNode objTracker1 then
				(
					local w = spnTrackWidth.value = objTracker1.baseObject.width
					local h = spnTrackHeight.value =  objTracker1.baseObject.length
					trackerSize = [w,h]
				)
			)
		
		---------------------------------------------------------------------------------------
		-- Cameras
					
			fn setCamera cam =
			(
				objCamera = cam
				pckCamera.text = cam.name
			)
				
			fn getCamera =
			(
				local cam = viewport.GetCamera()
				if cam != undefined then setCamera cam
			)
	
			fn getRenderSize =
			(
				local w = spnCompWidth.value = renderWidth
				local h = spnCompHeight.value = renderHeight
				renderSize = [w,h]
			)
					
		---------------------------------------------------------------------------------------
		-- Time
			
			fn setTimeSegment =
			(
				timeSegment = interval spnTimeStart.value spnTimeEnd.value
			)
		
			fn getTimeSegment =
			(
				local timeSegment
				if objCamera != undefined then
				(
					local ts = getControllerRange objCamera.transform.controller
					if ts != undefined then timeSegment = ts
				)
				else
				(
					timeSegment = animationRange
				)
				spnTimeStart.value = timeSegment.start
				spnTimeEnd.value = timeSegment.end
			)
		
		---------------------------------------------------------------------------------------
		-- UI
					
			fn setButtons =
			(
				iconUtil.init()
	
				iconUtil.setIcon btnResetVerts #refresh
				iconUtil.setIcon btnGrabMainSize #refresh
				iconUtil.setIcon btnGrabTrackSize #refresh
				iconUtil.setIcon resetTime #refresh
				iconUtil.setIcon btnGrabCam #refresh
				iconUtil.setIcon btnResetVerts #refresh
				
				iconUtil.setIcon btnResetTracker1 #cross
				iconUtil.setIcon btnResetTracker2 #cross
				
				iconUtil.setIcon btnShowVerts #eye
			)
		

		---------------------------------------------------------------------------------------
		-- Do track
	
			function doTrack =
			(
				-- objects
					local obj	= objTracker1
					local cam	= objCamera
					
					local t1	= timeSegment.start
					local t2	= timeSegment.end
				
				-- do the track
					arrMesh		= getMeshPoints obj t1 t2
					arrTrack	= getCamPointsArr arrMesh cam t1 t2
					
				-- swap the vertices around to match the AE Tracker
					for i = 1 to arrTrack.count do
					(
						local arrTemp	= arrTrack[i]
						local arrVerts	= #()
						
						for i = 1 to vertexOrder.count do -- #(3,4,1,2)
						(
							local n = vertexOrder[i]
							append arrVerts arrTemp[n]
						)
						arrTrack[i] = arrVerts
					)
					/*
					*/
				
			)
			
			function dumpTrackData =
			(
				-- objects
					local obj	= objTracker1
					local cam	= objCamera
					
					local t1	= timeSegment.start
					local t2	= timeSegment.end
					
				-- build theoutput
				
					local output= stringstream ""
					format "%\n" (getAEStart trackerSize.x trackerSize.y) to:output
					format "%\n" (getAEPosition undefined t1 t2) to:output
					format "%\n" (getAEAnchor undefined t1 t2) to:output
					format "%\n" (getAECornerPin arrTrack) to:output
					format "%\n" (getAEEnd()) to:output
					
				-- dump the output
				
					if setClipboardText != undefined then setClipboardText (output as string)
					else
					(
						clearListener()
						format "%\n" (output as string)
					)

			)
				
			function dumpDepthData =
			(
				-- objects
					local obj	= objTracker1
					local cam	= objCamera
					
					local t1	= timeSegment.start
					local t2	= timeSegment.end
					
					local arrDepth = for a in arrTrack collect a[1]
					
				-- build theoutput
				
					local output= stringstream ""
					format "%\n" (getAEStart renderWidth renderHeight) to:output
					format "%\n" (getAEDepthMatte arrDepth) to:output
					format "%\n" (getAEEnd()) to:output

				-- dump the output
				
					if setClipboardText != undefined then setClipboardText (output as string)
					else
					(
						clearListener()
						format "%\n" (output as string)
					)

			)

	-------------------------------------------------------------------------------------------
	-- handlers
	-------------------------------------------------------------------------------------------

		
		-- tracker
		
			on pckTracker1 picked obj do setTracker 1 obj
			on pckTracker2 picked obj do setTracker 2 obj
			
			on btnCorner1 pressed do getVertexOrder 1
			on btnCorner2 pressed do getVertexOrder 2
			on btnCorner3 pressed do getVertexOrder 3
			on btnCorner4 pressed do getVertexOrder 4
			on btnResetVerts pressed do resetVertexOrder()
			on btnShowVerts changed state do displayVertOrder state
	
		-- camera
		
			on pckCamera picked cam do setCamera cam
			on btnGrabCam pressed do getCamera()
		
		-- comp sizes
	
			on btnGrabMainSize pressed do getRenderSize()
			on btnGrabTrackSize pressed do getTrackSize()
	
			on spnTrackWidth changed val do trackerSize[1] = val
			on spnTrackHeight changed val do trackerSize[2] = val
			
			on spnCompWidth changed val do renderSize[1] = val
			on spnCompHeight changed val do renderSize[2] = val
			
		-- time

			on spnTimeStart changed val do if val > spnTimeEnd.value then spnTimeEnd.value = val + 1
			on spnTimeEnd changed val do if val < spnTimeStart.value then spnTimeStart.value = val - 1
			on resetTime pressed do getTimeSegment()

		
		-- track
		
			on btnCalculate pressed do
			(
				setTimeSegment()
				doTrack()
				dumpTrackData()
			)
	
			on btnCopyTrack pressed do dumpTrackData()
			on btnCopyDepth pressed do dumpDepthData()

		-- open
		
			on roAETracker open do
			(
				setButtons()
				getTracker()
				getTrackSize()
				getRenderSize()
				getCamera()
				timeSegment = interval 0 0
				getTimeSegment()
			)
)


rcmenu rcMenuVertList
(
	
	menuItem mi1 "1" checked:false enabled:true
	menuItem mi2 "2" checked:false enabled:true
	menuItem mi3 "3" checked:false enabled:true
	menuItem mi4 "4" checked:false enabled:true
	
	local index, vert, arrMi
	local ro	= roAETracker
	
	on rcMenuVertList open do
	(
		index	= ro.btnCornerDown
		vert	= ro.vertexOrder[index]
		
		arrMi	= #(mi1, mi2, mi3, mi4)
		arrMi[vert].checked = true
		arrMi[vert].enabled = false
	)

	on rcMenuVertList close do
	(
		print "Closed!"
	)
		
	on mi1 picked do ro.setVertexOrder index 1
	on mi2 picked do ro.setVertexOrder index 2
	on mi3 picked do ro.setVertexOrder index 3
	on mi4 picked do ro.setVertexOrder index 4
)	

createDialog roAETracker

