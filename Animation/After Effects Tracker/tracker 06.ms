try(
	destroyDialog roAETracker
	)
catch()


rollout roAETracker "After Effects Tracker" width:192 height:452
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

		include "ui.ms"
		include "worldToCam 05.ms"
		include "worldToVpt 06.ms"
		include "ae keyframe data 04.ms"
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
			spinner spnMainWidth "Size:" pos:[36,232] width:64 height:16 range:[0,2000,0] type:#integer fieldwidth:35 across:2
			spinner spnMainHeight " x " pos:[94,232] width:64 height:16 range:[0,2000,0] type:#integer fieldwidth:35
			button btnGrabMainSize "<" pos:[160,232] width:16 height:16
	
			label lblTrackComp "Tracked Layer" pos:[16,256] width:120 height:16 --
			spinner spnTrackWidth "Size:" pos:[36,272] width:64 height:16 range:[0,2000,0] type:#integer fieldwidth:35 across:2
			spinner spnTrackHeight "x " pos:[94,272] width:64 height:16 range:[0,2000,0] type:#integer fieldwidth:35
			button btnGrabTrackSize "<" pos:[160,272] width:16 height:16
	
		GroupBox grpTime "Time" pos:[8,304] width:176 height:40
			spinner spnTimeStart "Start:" pos:[36,320] width:64 height:16 range:[0,1000,0] type:#integer fieldwidth:35
			spinner spnTimeEnd "to" pos:[94,320] width:64 height:16 range:[0,1000,0] type:#integer fieldwidth:35
			button resetTime "<" pos:[160,320] width:16 height:16
	
		GroupBox grpTrack "Track" pos:[8,352] width:176 height:56
			checkbox chkDisplay "Display on Screen" pos:[16,368] width:160 height:16 checked:true
			checkbox chkCopy "Copy to clipboard" pos:[16,384] width:160 height:16 checked:true
	
		button btnCalculate "Calculate now" pos:[8,416] width:176 height:24
	
	
	
	-------------------------------------------------------------------------------------------
	-- variables
	-------------------------------------------------------------------------------------------
	
		-- tracker
			local objTracker1	= undefined
			local objTracker2	= undefined
			local objCamera		= undefined
			
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
				local w = spnMainWidth.value = renderWidth
				local h = spnMainHeight.value = renderHeight
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
	
				local obj	= objTracker1
				local cam	= objCamera
				
				local t1	= timeSegment.start
				local t2	= timeSegment.end
				
				
				
				clearListener()
				
				--format "% % % %\n" obj.name cam.name t1 t2
	
--				format "%\n" (getAEStart renderWidth renderHeight)
				format "%\n" (getAEStart 200 200)
				
				format "%\n" (getAEPosition undefined t1 t2)
				format "%\n" (getAEAnchor undefined t1 t2)
				format "%\n" (getAECornerPin obj cam t1 t2 drawMarkers:true)
				format "%\n" (getAEEnd())
				)
			

		
	-------------------------------------------------------------------------------------------
	-- handlers
	-------------------------------------------------------------------------------------------


		on btnCorner1 pressed do getVertexOrder 1
		on btnCorner2 pressed do getVertexOrder 2
		on btnCorner3 pressed do getVertexOrder 3
		on btnCorner4 pressed do getVertexOrder 4
		on btnResetVerts pressed do resetVertexOrder()
		on btnShowVerts changed state do displayVertOrder state

		on btnGrabMainSize pressed do getRenderSize()
		on btnGrabTrackSize pressed do getTrackSize()

		on pckTracker1 picked obj do setTracker 1 obj
		on pckTracker2 picked obj do setTracker 2 obj
		
		on pckCamera picked cam do setCamera cam
		on btnGrabCam pressed do getCamera()
		
		on spnTimeStart changed val do if val > spnTimeEnd.value then spnTimeEnd.value = val + 1
		on spnTimeEnd changed val do if val < spnTimeStart.value then spnTimeStart.value = val - 1
		on resetTime pressed do getTimeSegment()

		
		
		on btnCalculate pressed do
			(
			setTimeSegment()
			doTrack()
			)

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

