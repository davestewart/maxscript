try(
	destroyDialog roAETracker
	)
catch()


rollout roAETracker "After Effects Tracker" width:192 height:352
	(


	-------------------------------------------------------------------------------------------
	-- pre-declarations
	-------------------------------------------------------------------------------------------

		global rcMenuVertList
		local testing = false
		fn filterIsPlane obj = classof obj.baseobject == Plane


	-------------------------------------------------------------------------------------------
	-- includes
	-------------------------------------------------------------------------------------------

		include "ui.ms"
		include "worldToCam 05.ms"
		include "worldToVpt 06.ms"
		include "ae keyframe data 04.ms"

	-------------------------------------------------------------------------------------------
	-- ui
	-------------------------------------------------------------------------------------------
	
		GroupBox grp3dsmax "3dsmax" pos:[8,8] width:176 height:80

			pickbutton pckTrackerObject "Pick Tracker Plane..." pos:[16,24] width:144 height:16 filter:filterIsPlane 
			button btnResetTracker "x" pos:[160,24] width:16 height:16 toolTip:"Kill Tracker"
	
			label lblVertex "Vertex Order:" pos:[24,56] width:64 height:16
			button btnCorner1 "3" pos:[96,48] width:16 height:16
			button btnCorner2 "4" pos:[112,48] width:16 height:16
			button btnCorner3 "1" pos:[96,64] width:16 height:16
			button btnCorner4 "2" pos:[112,64] width:16 height:16
			
			checkButton btnShowVerts "@" pos:[144,56] width:16 height:16 toolTip:"Show verts"
			button btnResetVerts "x" pos:[160,56] width:16 height:16 toolTip:"Reset vertex order"
	
		GroupBox grpAfterEffects "After Effects Comps" pos:[8,96] width:176 height:104
			label lblMainComp "Main Composition" pos:[16,120] width:120 height:16
			spinner spnMainWidth "Size:" pos:[36,136] width:64 height:16 range:[0,2000,0] type:#integer fieldwidth:35 across:2
			spinner spnMainHeight " x " pos:[94,136] width:64 height:16 range:[0,2000,0] type:#integer fieldwidth:35
			button btnGrabMainSize "<" pos:[160,136] width:16 height:16
	
			label lblTrackComp "Tracked Layer" pos:[16,160] width:120 height:16 --
			spinner spnTrackWidth "Size:" pos:[36,176] width:64 height:16 range:[0,2000,0] type:#integer fieldwidth:35 across:2
			spinner spnTrackHeight "x " pos:[94,176] width:64 height:16 range:[0,2000,0] type:#integer fieldwidth:35
			button btnGrabTrackSize "<" pos:[160,176] width:16 height:16
	
		GroupBox grpTime "Time" pos:[8,208] width:176 height:40
			spinner spnTimeStart "Start:" pos:[36,224] width:64 height:16 range:[0,1000,0] type:#integer fieldwidth:35
			spinner spnTimeEnd "to" pos:[94,224] width:64 height:16 range:[0,1000,0] type:#integer fieldwidth:35
			button resetTime "<" pos:[160,224] width:16 height:16
	
		GroupBox grpTrack "Track" pos:[8,256] width:176 height:56
			checkbox chkDisplay "Display on Screen" pos:[16,272] width:160 height:16 checked:true
			checkbox chkCopy "Copy to clipboard" pos:[16,288] width:160 height:16 checked:true
	
		button btnCalculate "Calculate now" pos:[8,320] width:176 height:24
	
	
	
	
	-------------------------------------------------------------------------------------------
	-- variables
	-------------------------------------------------------------------------------------------
	
		-- tracker
			local objTracker	= undefined
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
	
	
		fn displayVertOrder state =
			(
			if state == true then
				(
				fn showVertsCb = showVertexOrder objTracker
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
			if objTracker != undefined then
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
	
		function setAEKeyframeCode =
			(
			)
	
		function doTrack =
			(

			local obj	= objTracker
			local t1	= timeSegment.start
			local t2	= timeSegment.end
			
			
			clearListener()

			format "%\n" (getAEStart renderWidth renderHeight)
			format "%\n" (getAEPosition undefined t1 t2)
			format "%\n" (getAEAnchor undefined t1 t2)
			format "%\n" (getAECornerPin obj t1 t2 drawMarkers:true)
			format "%\n" (getAEEnd())
			)
			
		fn setTrackerObject obj =
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
			objTracker = obj
			pckTrackerObject.text = "Tracker: " + objTracker.name
			)

		fn getTrackerObject =
			(
			local obj, sel = getCurrentSelection()
			if sel.count == 1 then
				(
				obj = sel[1]
				if filterIsPlane obj then setTrackerObject obj
				)
			else
				(
				obj = for i = 1 to objects.count do if filterIsPlane objects[i] then exit with objects[i]
				if obj != undefined then setTrackerObject obj
				)
			)

		fn getRenderSize =
			(
			local w = spnMainWidth.value = renderWidth
			local h = spnMainHeight.value = renderHeight
			renderSize = [w,h]
			)
			
		fn getTrackSize =
			(
			if isValidNode objTracker then
				(
				local w = spnTrackWidth.value = objTracker.baseObject.width
				local h = spnTrackHeight.value =  objTracker.baseObject.length
				trackerSize = [w,h]
				)
			)
	
		fn setTimeSegment =
			(
			timeSegment = interval spnTimeStart.value spnTimeEnd.value
			)
	
		fn getTimeSegment =
			(
			spnTimeStart.value = timeSegment.start
			spnTimeEnd.value = timeSegment.end
			)
			
		fn setButtons =
			(
			local b					= arrayToBmp bmpRefresh
			local bImages			= #(b, b, 1, 1, 1, 1, 1)
			btnResetVerts.images	= bImages
			btnGrabMainSize.images	= bImages
			btnGrabTrackSize.images	= bImages
			resetTime.images		= bImages
			
			local b					= arrayToBmp bmpCross
			local bImages			= #(b, b, 1, 1, 1, 1, 1)
			btnResetTracker.images	= bImages
			
			local b					= arrayToBmp bmpEye
			local bImages			= #(b, b, 1, 1, 1, 1, 1)
			btnShowVerts.images	= bImages
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

		on pckTrackerObject picked obj do setTrackerObject obj
		
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
			getTrackerObject()
			getTrackSize()
			getRenderSize()
			timeSegment = interval 150 300
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

