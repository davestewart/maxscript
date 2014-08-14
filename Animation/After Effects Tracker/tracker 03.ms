--VMS Tidy test rollout

try(
	destroyDialog roAETracker
	)
catch()

rollout roAETracker "After Effects Tracker" width:192 height:352
(

	-------------------------------------------------------------------------------------------
	-- pre-declarations
	-------------------------------------------------------------------------------------------

		fn filterIsPlane obj = classof obj == Plane

	-------------------------------------------------------------------------------------------
	-- ui
	-------------------------------------------------------------------------------------------
	
		GroupBox grp3dsmax "3dsmax" pos:[8,8] width:176 height:80

			pickbutton pckTrackerObject "Pick Tracker Plane..." pos:[16,24] width:160 height:16 filter:filterIsPlane 
	
			label lblVertex "Vertex Order:" pos:[24,56] width:64 height:16
			button btnVert3 "3" pos:[96,48] width:16 height:16
			button btnVert4 "4" pos:[112,48] width:16 height:16
			button btnVert1 "1" pos:[96,64] width:16 height:16
			button btnVert2 "2" pos:[112,64] width:16 height:16
			
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
			spinner spnTimeStart "Start:" pos:[32,224] width:64 height:16 range:[0,1000,0] type:#integer fieldwidth:35
			spinner spnTimeEnd "End:" pos:[112,224] width:64 height:16 range:[0,1000,0] type:#integer fieldwidth:35
	
		GroupBox grpTrack "Track" pos:[8,256] width:176 height:56
			checkbox chkDisplay "Display on Screen" pos:[16,272] width:160 height:16 checked:true
			checkbox chkCopy "Copy to clipboard" pos:[16,288] width:160 height:16 checked:true
	
		button btnCalculate "Calculate now" pos:[8,320] width:176 height:24
	
	-------------------------------------------------------------------------------------------
	-- variables
	-------------------------------------------------------------------------------------------
	
		local objTracker	= undefined
		local trackerSize	= [0,0]
		local renderSize	= [0,0]
		local timeSegment	= interval 0f 0f
		
		local testing		= false
	
	-------------------------------------------------------------------------------------------
	-- functions
	-------------------------------------------------------------------------------------------
	
	
		function setAEKeyframeCode =
			(
			)
	
		function doTrack =
			(
			)
			
		fn setTrackerObject obj =
			(
			objTracker = obj
			pckTrackerObject.text = "Tracker: " + objTracker.name
			)

		fn getTrackerObject =
			(
			local sel = getCurrentSelection()
			if sel.count == 1 then
				(
				if filterIsPlane sel[1] then setTrackerObject sel[1]
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
	
	-------------------------------------------------------------------------------------------
	-- handlers
	-------------------------------------------------------------------------------------------

		on pckTrackerObject picked obj do
			(
			setTrackerObject obj
			)
		
		on btnCalculate pressed do doTrack()

		on roAETracker open do
			(
			getTrackerObject()
			getTrackSize()
			getRenderSize()
			timeSegment = animationRange
			getTimeSegment()
			)
	)
	
createDialog roAETracker

