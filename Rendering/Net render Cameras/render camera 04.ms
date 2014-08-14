rollout roRenderCameras "Render Cameras" width:256 height:328
	(

	---------------------------------------------------------------------------
	-- interface
	---------------------------------------------------------------------------

		listbox lbxCams "" pos:[8,8] width:240 height:20
		button btnStart "Start" pos:[8,304] width:240 height:16
		radioButtons rdoPass "" pos:[32,280] width:197 height:16 labels:#("All","Fg", "Bg") default:1 columns:3
	
	---------------------------------------------------------------------------
	-- variables
	---------------------------------------------------------------------------
	
		local arrCamInfo	= #()
		local pass			= "all"
		local fRoot			= "E:/02_Current_Jobs/2006-09 - Jetix promo/3 - renders/"
	
	---------------------------------------------------------------------------
	-- functions
	---------------------------------------------------------------------------
	
		fn getControllerTimes ctrl &arr =
			(
			for i = 1 to ctrl.numSubs do
				(
				local c = ctrl[i].controller
				if iscontroller c do
					(
					local range = gettimeRange c
					if range.start - range.end != 0f then
						(
						append arr range.start
						append arr range.end
						)
					getControllerTimes c &arr
					)
				)
			)
		
		fn getControllerRange ctrl =
			(
			arr	= #()
			getControllerTimes ctrl &arr
			if arr.count > 0 then return interval (aMin arr) (aMax arr)
			else return undefined
			)
			
		fn createFolder path =
			(
			local arrPath = filterString path "/"
			local path = ""
			local state = true
			
			for i = 1 to arrPath.count do
				(
				path += arrPath[i] + "/"
				
				if doesFileExist path then state = true
				else state = makeDir path
		
				if state == false then return false
				)
			return true
			)

		function getCameras =
			(
			-- get cameras
				local arrCam = for cam in cameras where superclassof cam == Camera collect cam.name
				sort arrCam
				
				for camName in arrCam do
					(
					local cam = getNodeByName camName
					local ctrl = cam.transform.controller
					
					format "% %\n" cam.name ctrl
					local cRange = getControllerRange ctrl
					
					if cRange != undefined then append arrCamInfo #(cam, cRange)
					--else append arrCamInfo #(cam, interval 0 0)
					)
			)
			
		function setViewport cam =
			(
			if viewport.numViews == 4 then
				(
				viewport.activeViewport = 4
				viewport.SetCamera cam
				)
			select cam
			)
			
		function buildCameraList =
			(
			local items = #()
			for camInfo in arrCamInfo do
				(
				local cam	= camInfo[1].name
				local t1	= camInfo[2].start as string
				local t2	= camInfo[2].end as string
				local str	= t1 + " - " + t2 + "  :  " + cam
				append items str
				)
			lbxCams.items = items
			)
	
	
		function showJobInfo = 
			(
			for prop in getpropnames job do format "% : %\n" prop (getproperty job prop)
			)
	
	
		function setBitmapOutput =
			(
			rla.colorDepth		= 32
			
			rla.alpha			= true
			rla.premultAlpha	= true
			rla.zChannel		= true
			rla.nodeIDChannel	= true
			
			rla.mtlIDChannel	= false
			rla.uvChannel		= false
			rla.normalChannel	= false
			rla.realpixChannel	= false
			rla.coverageChannel	= false
			
			tgaio.setColorDepth 32
			tgaio.setCompressed true
			)
	
	
	
	
		function buildRenderQueue =
			(
			-- bitmap stuff
				setBitmapOutput()
			
			-- connect to manager
				global m, srv_list, job
				
				m			= netrender.getmanager()
				m.connect #automatic "255.255.255.0" 
				srv_list	= m.getservers()
			
			
			for camInfo in arrCamInfo do
				(
				-- variables
					local cam	= camInfo[1]
					local t1	= camInfo[2].start
					local t2	= camInfo[2].end

					
				-- render path
					local fName 	= cam.name
					local fExt		= ".rpf"
					local fPath		= fRoot + pass + "/" + fName + "/"
					local f			= fPath + fName + " " + fExt
					
				-- craete folder
					createFolder fPath

				-- setup scene
					setViewport cam
				
				-- setup times
					rendOutputFilename = f
					rendTimeType	= 3
					rendStart		= t1
					rendEnd			= t2
					rendSaveFile	= true
					
				-- setup manager
					job				= m.newjob()
					job.includeMaps	= true
					
					job.fromFrame	= t1
					job.toFrame		= t2
					job.frameOutputName	= f
					job.name		= cam.name + " - " + pass

				-- submit
					job.submit servers:srv_list --specify which servers to use for the job
				)

			)
	
	
	
	---------------------------------------------------------------------------
	-- handlers
	---------------------------------------------------------------------------
	
	on roRenderCameras open do
		(
		getCameras()
		buildCameraList()
		)
		
	on lbxCams doubleclicked i do
		(
		local cam = arrCamInfo[i][1]
		slidertime = arrCamInfo[i][2].start
		setViewport cam
		)
		
	on btnStart pressed do
		(
		buildRenderQueue()
		)
		
	on rdoPass changed index do
		(
		if index == 1 then pass = "all"
		else if index == 2 then pass = "fg"
		else pass = "bg"
		)
	)
	
	
createDialog roRenderCameras



/*

getControllerRange $.transform.controller
*/