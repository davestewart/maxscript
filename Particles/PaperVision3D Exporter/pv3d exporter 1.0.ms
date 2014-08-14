-------------------------------------------------------------------------------------------------------------------------------
-- Papervision 3D Exporter
-------------------------------------------------------------------------------------------------------------------------------
--
-- version:		1.0
-- author:		dave stewart
-- website:		www.davestewart.co.uk / www.keyframesandcode.com
-- date:		30 April 2008
-- max version:	9
--
-- description:	Exports particle positions and rotations to custom file format [px,py,pz,rx,ry,rz] from
--				max (Z-up) to Papervision (Y-up) coordinate system. Also exports camera data, which has 
--				a different local Z axis which means a different transform is needed.
--				Additionally, provides a way
--				
--
-------------------------------------------------------------------------------------------------------------------------------

try(destroydialog roPVExporter);catch()
rollout roPVExporter "PaperVision3D Exporter" width:224 height:536
(
	-------------------------------------------------------------------------------------------------------------------------------
	-- interface
	-------------------------------------------------------------------------------------------------------------------------------
	
	GroupBox grpObjects "Objects" pos:[8,8] width:208 height:72
		dropdownList ddlParticles "" pos:[64,24] width:128 height:21
		button btnUpdateParticles "<" pos:[192,24] width:18 height:20 toolTip:"Update"
		label lblParticles "Particles" pos:[16,27] width:48 height:16
		dropdownList ddlCamera "" pos:[64,48] width:128 height:21
		button btnUpdateCameras "<" pos:[192,48] width:18 height:20 toolTip:"Update"
		label lblCamera "Camera" pos:[16,51] width:48 height:16

	GroupBox grpTime "Time" pos:[8,88] width:208 height:80
		dropdownList ddlTimeRange "" pos:[64,104] width:128 height:21 items:#("Current range", "Current frame", "User defined")
		checkbutton btnTimeReverse "R" pos:[192,104] width:18 height:20 toolTip:"Reverse"
		label lblTimeRange "Range" pos:[16,106] width:48 height:16
		label lblTimeFrom "From" pos:[64,128] width:48 height:16
		spinner spnTimeFrom "" pos:[128,128] width:64 height:16 range:[0,9999,10] type:#integer
		button btnTimeReset "<" pos:[192,128] width:18 height:32 toolTip:"Reset to animation range"
		label lblTimeTo "To" pos:[64,144] width:48 height:16
		spinner spnTimeTo "" pos:[128,144] width:64 height:16 range:[0,9999,10] type:#integer

	GroupBox grpVisualise "Visualise" pos:[8,176] width:208 height:160
		dropdownList ddlVisParticles "" pos:[64,192] width:128 height:21 items:#("Every Nth", "All", "Selected", "Single")
		label lblVisParticles "Particle(s)" pos:[16,194] width:48 height:16
		label lblVisParticleId "Every" pos:[64,216] width:52 height:16
		spinner spnVisParticleId "" pos:[128,216] width:64 height:16 range:[1,9999,10] type:#integer
		slider sldAccuracy "............................................................." pos:[22,240] width:192 height:44 range:[1,5,2] type:#integer ticks:4
		button btnCreateSplines "Create splines" pos:[16,296] width:144 height:24
		button btnSelectSplines "Sel" pos:[160,296] width:24 height:24 toolTip:"Select splines"
		button btnDeleteSplines "Del" pos:[184,296] width:24 height:24 toolTip:"Delete splines"
		progressBar pbCreateSplines "ProgressBar" pos:[16,320] width:192 height:8 value:0 color:(color 30 10 190)
	
	GroupBox grpExport "Export Options" pos:[8,344] width:208 height:104
		edittext edtPath "" pos:[60,360] width:132 height:20
		button btnPath "<" pos:[192,360] width:18 height:20 toolTip:"Get save path"
		label lblPath "Path" pos:[16,363] width:48 height:16
		edittext edtFilename "" pos:[60,384] width:132 height:20
		button btnFilename "<" pos:[192,384] width:18 height:20 toolTip:"Set filename to scene name"
		label lblFilename "Filename" pos:[16,387] width:48 height:16
		button btnExportParticles "Export particles" pos:[16,408] width:96 height:24
		button btnExportCamera "Export camera" pos:[112,408] width:96 height:24
		progressBar pbExport "ProgressBar" pos:[16,434] width:192 height:8
		
	GroupBox grpAbout "About" pos:[8,456] width:208 height:72
		ActiveXControl axFlash "{D27CDB6E-AE6D-11CF-96B8-444553540000}" pos:[16,472] width:192 height:48

	-------------------------------------------------------------------------------------------------------------------------------
	-- variables
	-------------------------------------------------------------------------------------------------------------------------------
	
		-- declarations
		
			local asPath, asFolder
			local getASArrayFromPData
			struct pData (pos, rot)
	
			local precision 		= 2
			
			local pf
			local cam
			local splines			= #()
			local exportInterval	= animationrange

		-- pre-declarations
		
			local	updateSplineTotal, 
					updateTimeRange, 
					getExportInterval,
					getExportPath,
					getExportFile
					
		-- structs
		
			struct progressBarUpdater
				(
				pb			= undefined,
				value		= 0,
				step		= 0,
				
				fn init _pb v1 v2 =
					(
					if amax v1 v2 == v1 do swap v1 v2
					step		= 100.0 / ((v2 - v1) + 1)
					value		= 0
					pb			= _pb
					pb.value	= 0
					),
					
				fn update =
					(
					value		+= step
					pb.value	= value
					),
					
				fn reset =
					(
					value		= 0
					pb.value	= 0
					)
				)
				
			struct timeStamper
				(
				t1			= 0,
				t2			= undefined,
				duration	= 0,
				_task		= "",
				fn start task:"" = (_task = task; t2 = undefined; t1 = timeStamp()),
				fn end		= (t2 = timestamp();duration = t2 - t1; t2),
				fn print	= (if t2 == undefined do end(); format "Processing % took % seconds\n" _task (duration / 1000.0)),
				fn prompt	= (if t2 == undefined do end(); displayTempPrompt ("Processing " +_task+ " took " +(duration / 1000.0) as string + " seconds") 3000)
				)

	
	-------------------------------------------------------------------------------------------------------------------------------
	-- functions
	-------------------------------------------------------------------------------------------------------------------------------
	
		
		----------------------------------------------------------------------------------------------
		-- utility functions
		----------------------------------------------------------------------------------------------
		
				fn round n points =
					(
					if points == 0 then
						(
						n += 0.5
						n = n as integer
						)
					else
						(
						local exp = pow 10 points
						n *= exp
						n = floor n
						n /= exp
						)
					n
					)
					
				fn getUIColorAsInteger colorName =
					(
					local col = colorMan.getColor #background
					((col.x * 65536) + (col.y * 256) + col.z) * 255
					)
				
					
		----------------------------------------------------------------------------------------------
		-- trajectory functions
		----------------------------------------------------------------------------------------------
		
				function arrayToSpline arr redrawInterval: segmentType:#line =
					(
					-- spline
						local ss = SplineShape pos:arr[1]
						addNewSpline ss
						
					-- curve types
						local vertexType, segmentType
						if segmentType == #line then
							(
							vertexType	= #corner
							segmentType	= #line
							)
						else(
							vertexType	= #smooth
							segmentType	= #curve
							)
							
					-- knots
						for i = 1 to arr.count do
							(
							addKnot ss 1 vertexType segmentType arr[i]
							/*
							if redrawInterval != unsupplied do
								(
								if mod i redrawInterval == 0 do
									(
									if i > 2 do updateShape ss
									redrawViews()
									)
								)
							*/
							)
						updateShape ss
						
					-- return
						ss
					)
		
				function objectTrajectoryToArray obj start:0 end:animationrange.end step:1 =
					(
					local arr	= for t = start to end by step collect at time t obj.pos
					arr
					)
		
				function particleTrajectoryToArray pf pIndex start:0 end:animationrange.end step:1 =
					(
					local arr	= #()
					for t = start to end by step do
						(
						pf.updateParticles pf t
						append arr (pf.getParticlePositionById pIndex)
						)
					arr
					)
		
		
		----------------------------------------------------------------------------------------------
		-- data functions
		----------------------------------------------------------------------------------------------
		
				function getAllParticleData numParticles:#all frames:#all degrees:true =
					(
					-- variables
						local pos, rot, tm
						local rotScalar	= if degrees then 180.0 / Pi else 1
						local mxYUp		= matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]
						local mxPart, mxPartYUp
		
			
					-- num particles
						if numParticles == #all do numParticles = pf.numParticles()
						
					-- create initial arrays
						local arr = #()
						for pIndex = 1 to numParticles do
							(
							arr[pIndex] = #()
							)
				
					-- get time variables
						local exportInterval	= getExportInterval()
						local tStart			= exportInterval.start
						local tEnd				= exportInterval.end
						local tStep				= 1
						if btnTimeReverse.state == true do
							(
							swap tStart tEnd
							tStep = -1
							)
						
					-- loop through time
						local pb		= progressBarUpdater()
						pb.init pbExport tStart tEnd
						for t = tStart to tEnd by tStep do
							(
							--print ("Time " + t as string)
							
							pb.update()
							
							pf.updateParticles pf t
							for pIndex = 1 to numParticles do
								(
								mxPart		= pf.getParticleTMById pIndex
								mxPartYUp	= mxPart * mxYUp
		
								pos	= mxPartYUp.pos
								rot	= mxPartYUp.rotation as eulerangles
								
								append arr[pIndex] (pData pos:pos rot:rot)
								)
							)
						pbExport.value = 0
					arr
					)
		
				function getParticleData pIndex frames:#all degrees:true =
					(
					-- variables
						local pos, rot, tm
						local rotScalar	= if degrees then 180.0 / Pi else 1
			
					-- create initial arrays
						local arr = #()
				
					-- get time variables
						local exportInterval	= getExportInterval()
						local tStart			= exportInterval.start
						local tEnd				= exportInterval.end
						local tStep				= 1
						if btnTimeReverse.state == true do
							(
							swap tStart tEnd
							tStep = -1
							)
						
					-- loop through time
						for t = tStart to tEnd by tStep do
							(
							pf.updateParticles pf t
		
							pos	= (pf.getParticlePositionById pIndex)
							rot	= (pf.getParticleOrientationById pIndex) * rotScalar
		
							append arr (pData pos:pos rot:rot)
							)
							
					-- return
						arr
					)
					
					
				function getCameraData frames:#all degrees:true =
					(
					-- variables
						local r, rot, pos
						local mxCam, mxCamYUp
						local arr		= #()
						local rotScalar	= if degrees then 1 else Pi * 180
						local mxYUp		= matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0]
						local mxRot90	= rotateXMatrix -90
						
					-- get time variables
						local exportInterval	= getExportInterval()
						local tStart			= exportInterval.start
						local tEnd				= exportInterval.end
						local tStep				= 1
						if btnTimeReverse.state == true do
							(
							swap tStart tEnd
							tStep = -1
							)
							
					-- loop through time
						local pb		= progressBarUpdater()
						pb.init pbExport tStart tEnd

						for t = tStart to tEnd by tStep do
							(
							at time t
								(
								
								pb.update()
								
								mxCamPos	= cam.transform * mxYUp
								mxCamRot	= cam.transform * mxRot90
								
								pos			= mxCamPos.pos
								rot			= mxCamRot.rotation as eulerangles
		
								append arr (pData pos:pos rot:rot)
								)
							)
						pb.reset()
							
					-- return
						arr
					)
		
		----------------------------------------------------------------------------------------------
		-- export functions
		----------------------------------------------------------------------------------------------
		
		--local exportInterval	= getExportInterval()

				function exportParticles arr frames:#all =
					(
					-- variables
						local str			= stringstream ""
						local strBox		= stringstream ""
						local strAll		= stringstream "[],"
						
					-- loop	
						frames = if frames == #all then arr.count else frames
						for b = 1 to frames do
							(
							strBox = stringstream ""
							for t = 1 to arr[b].count do
								(
								-- object
									str = getASArrayFromPData arr[b][t]	type:"normal"						
									
								-- output
									format "%" str to:strBox
									if t < arr[b].count do format "," to:strBox
						
								)
							-- output
								format "[%]" (strBox as string) to:strAll
								if b < frames do format ",\n" to:strAll
							)
					
					-- output
						strAll
					)
		
				function exportCamera arr frames:#all =
					(
					-- variables
						local strAll		= stringstream ""
						local str			= stringstream ""
						
					-- loop	
						frames = if frames == #all then arr.count else frames
						for i = 1 to frames do
							(
							str = getASArrayFromPData arr[i] type:"camera"
							format "%" str to:strAll
							if i < frames do format ",\n" to:strAll
							)
					
					-- output
						strAll
					)
			
		
		----------------------------------------------------------------------------------------------
		-- Flash functions
		----------------------------------------------------------------------------------------------
		
				fn printASData str =
					(
					format "var animation_array:Array = [\n%\n];\n\n" (str as string) to:(newScript())
					)
		
				fn saveASData str type =
					(
					-- filename
						local filename
						local exportPath	= getExportPath()
						local exportFile	= getExportFile()
						
						if exportPath == undefined do
							(
							messagebox "No export path set. Aborting script."
							return false
							)
						
						if exportFile == undefined do
							(
							messagebox "No export filename set. Aborting script."
							return false
							)
						
					-- filepath
						if type == "camera" then
							filename = exportPath+ "/" +exportFile+ "Camera.as"
						else
							filename = exportPath+ "/" +exportFile+ ".as"
						
					-- file
						local fs = createFile filename
						format "var animation_array:Array = [\n%\n];\n\n" (str as string) to:fs
						flush fs
						close fs
						
					-- print 
						format "Exported to file: %\n" filename
					)
				
		
				function getASArrayFromPData data type: =
					(
					
					-- stringstream
						local str = stringstream ""
						local mpx, mpy, mpz, mrx, mry, mrz
						local fpx, fpy, fpz, frx, fry, frz
					
					-- max coords
						mpx	= round data.pos.x precision
						mpy	= round data.pos.y precision
						mpz	= round data.pos.z precision
						
						mrx	= round data.rot.x precision
						mry	= round data.rot.y precision
						mrz	= round data.rot.z precision
		
					-- flash coords
						--local type = "camera"
		
						case type of
							(
							
							"object":
								(
								fpx	= mpx
								fpy	= mpy
								fpz	= mpz
								
								frx	= mrx
								fry	= mry
								frz	= mrz
								)
								
							"camera":
								(
								fpx	= mpx
								fpy	= -mpy
								fpz	= mpz
								
								frx	= mrx
								fry	= -mry
								frz	= mrz
								)
								
							default:
								(
								fpx	= mpx
								fpy	= -mpy
								fpz	= mpz
								
								frx	= - mrx + 180
								fry	= mry
								frz	= mrz
		
								)
							)
		
						
					-- output
						format "[%, %, %, %, %, %]" fpx fpy fpz frx fry frz to:str
						
					-- return
						str as string
					)

	
	
		----------------------------------------------------------------------------------------------
		-- ui functions
		----------------------------------------------------------------------------------------------
		
			-- settings
			
				fn saveSetting key value =
					(
					setinisetting (getdir #plugcfg + "\pv3d_exporter.ini") "settings" key (value as string)
					)
					
				fn loadSetting key =
					(
					getinisetting (getdir #plugcfg + "\pv3d_exporter.ini") "settings" key
					)

			-- objects
			
				fn setCamera =
					(
					local camName = ddlCamera.selected
					cam = if camName != undefined then getNodeByName camName else undefined
					)
					
				fn setParticles =
					(
					local pfName = ddlParticles.selected
					pf = if pfName != undefined then getNodeByName pfName else undefined
					updateSplineTotal()
					)
			
				fn updateCameraItems =
					(
					local arr = for obj in objects where superclassof obj == Camera collect obj.name
					ddlCamera.items = arr
					if ddlCamera.selected == undefined do ddlCamera.selection = 1
					setCamera()
					)
					
				fn updateParticleItems =
					(
					local arr = for obj in objects where classof obj == PF_Source collect obj.name
					ddlParticles.items = arr
					if ddlParticles.selected == undefined do ddlParticles.selection = 1
					setParticles()
					)
					
			-- time
			
				fn getExportInterval =
					(
					local range	= case ddlTimeRange.selection of
						(
						1: animationrange
						2: interval slidertime slidertime
						3: interval spnTimeFrom.value spnTimeTo.value
						)
					range
					)
					
				fn setExportInterval =
					(
					spnTimeFrom.value	= animationrange.start
					spnTimeTo.value		= animationrange.end
					updateTimeRange()
					)
					
				fn updateTimeRange =
					(
					-- dropdown state
						local index		= ddlTimeRange.selection
						local state		= index == 3
						
					-- update labels, spinners and button
						lblTimeFrom.enabled = spnTimeFrom.enabled = state
						lblTimeTo.enabled = spnTimeTo.enabled = state
						btnTimeReset.enabled = state
						
					-- update export interval
						exportInterval	= getExportInterval()
						local t1		= exportInterval.start as string
						local t2		= exportInterval.end as string
						if btnTimeReverse.checked == true do swap t1 t2
						
					-- update group caption
						grpTime.text = "Time (" +t1+ " - " +t2+ ")"
					)
					
				fn updateTimeSpinners spn1 spn2 index offset:0 =
					(
					if index == 1 then
						(
						if spn1.value >= spn2.value do spn2.value = spn1.value + offset
						)
					else(
						if spn2.value <= spn1.value do spn1.value = spn2.value - offset
						)
					updateTimeRange()
					)
				
			-- visualize
			
				fn updateSplineTotal =
					(
					
					if pf == undefined do return false
					
					spnVisParticleId.range.y = pf.numParticles()
					
					grpObjects.text = "Objects (" +pf.numParticles() as string+ " particles)"
					
					local n
					n = case ddlVisParticles.selection of
						(
						
						1: pf.numParticles() / spnVisParticleId.value -- Every Nth
						2: pf.numParticles() -- All
						3: pf.Selected_Particles.count -- Selected
						4: 1 -- Single
						)
					
					--if ddlVisParticles.selection == 1 AND n < pf.numParticles() do n += 1
					grpVisualise.text = "Visualise (" +n as string+ " splines)"
					)

				fn updateVisParticleId index =
					(
					state = index == 1 OR index == 4
					lblVisParticleId.enabled	= state
					spnVisParticleId.enabled	= state
					
					if state do lblVisParticleId.text = if index == 1 then "Every" else "Particle Id"
					updateSplineTotal()
					)
					
				fn updateAccuracy =
					(
					local val	= sldAccuracy.value
					local text	= case val of
						(
						5: "Exact (every frame)"
						4: "Good (every 5 frames)"
						3: "Quick (every 10 frames)"
						2: "Draft (every 15 frames)"
						1: "Rough (every 25 frames)"
						)
					sldAccuracy.text = "Accuracy: " + text
					
					local frames = case val of
						(
						5: 1
						4: 5
						3: 10
						2: 15
						1: 25
						)
						
					return frames
					)
				
				fn createSplines =
					(
					-- timestamping
						local ts = timeStamper()
						ts.start task:"Spline Creation"
					
					-- variables
						splines = #()
						local particleIds
						
					-- set particle system
						setParticles()
						if pf == undefined do
							(
							messagebox "Can't create splines, as no particle system has been created / selected"
							updateParticleItems()
							return false
							)
						
					-- get selected particles
						particleIds = case ddlVisParticles.selection of
							(
							1:	for i = 1 to pf.numParticles() by spnVisParticleId.value collect i  -- Every Nth
							2:	for i = 1 to pf.numParticles() collect i -- All
							3:	pf.Selected_Particles -- Selected
							4:	#(spnVisParticleId.value) -- Single
							)
	
					-- create splines
						local pb		= progressBarUpdater()
						pb.init pbCreateSplines 1 particleIds.count
						for i = 1 to particleIds.count do
							(
							pb.update()

							local particleId		= particleIds[i]
							local exportInterval	= getExportInterval()
							local splineSteps		= updateAccuracy()
							local arr				= particleTrajectoryToArray pf particleId start:exportInterval.start end:exportInterval.end step:splineSteps
							local ss				= arrayToSpline arr segmentType:(if splineSteps == 1 then #line else #curve)
							
							ss.wirecolor = random white green
							append splines ss
							forcecompleteredraw()
							
							if keyboard.escPressed do if querybox "Do you wish to abort visualisation?" do exit
							)

						pbCreateSplines.value = 0
						
					-- timestamping
						ts.end()
						ts.print()
						ts.prompt()
					)
					
			-- export
			
				fn setPath =
					(
					local s	= getsavepath()
					if s != undefined then
						(
						edtPath.text = s
						saveSetting "path" s
						)
					)
					
				fn getPath =
					(
					s = loadSetting "path"
					if s != undefined do edtPath.text = s
					)
					
				fn setFilename =
					(
					local arr			= filterstring maxfilename " .,"
					edtFilename.text	= if arr.count > 0 then arr[1] else ""
					)
					
				fn getExportPath =
					(
					local exportPath = edtPath.text
					if doesFileExist exportPath == true then exportPath else undefined
					)
					
				fn getExportFile =
					(
					local exportFile = edtFilename.text
					if exportFile != "" then exportFile else undefined
					)
					
				fn processParticles =
					(
					-- timestamping
						local ts = timeStamper()
						ts.start task:"Particle Export"

					-- set particle system
						setParticles()
						if pf == undefined do
							(
							messagebox "Can't export, as no particle system has been created / selected"
							updateParticleItems()
							return false
							)

					-- process
						local particleData	= getAllParticleData()
						local actionscript	= exportParticles particleData
						saveASData actionscript "content"
						
					-- timestamping
						ts.print()
						ts.prompt()

					)
					
				fn processCamera =
					(
					-- set particle system
						setcamera()
						if cam == undefined do
							(
							messagebox "Can't export, as no camera has been created / selected"
							updateCameraItems()
							return false
							)

					-- process
						local cameraData	= getCameraData()
						local actionscript	= exportCamera cameraData
						saveASData actionscript "camera"
					)
					
			-- about
				fn initAbout =
					(
					roPVExporter.axFlash.BackgroundColor = getUIColorAsInteger #background
					try(
						local mov		= "http://www.davestewart.co.uk/images/web/davestewart.swf"
						axFlash.movie	= mov
						axFlash.movie	= mov
						axFlash.SAlign	= "TL"
						axFlash.Menu	= false
						);
					catch()
					)


	-------------------------------------------------------------------------------------------------------------------------------
	-- handlers
	-------------------------------------------------------------------------------------------------------------------------------
	
		on roPVExporter open do
			(
			escapeEnable = true
			SetDialogPos roPVExporter (execute (loadSetting "pos"))
			initAbout()
			updateAccuracy()
			updateCameraItems()
			updateParticleItems()
			updateTimeRange()
			updateSplineTotal()
			setExportInterval()
			getPath()
			setFilename()
			)
			
		on btnUpdateParticles pressed do updateParticleItems()
		on btnUpdateCameras pressed do updateCameraItems()
		on ddlCamera selected item do setCamera()
		on ddlParticles selected item do setParticles()
		
		on ddlTimeRange selected index do updateTimeRange()
		on btnTimeReverse changed state do updateTimeRange()
		on spnTimeFrom changed value do updateTimeSpinners spnTimeFrom spnTimeTo 1
		on spnTimeTo changed value do updateTimeSpinners spnTimeFrom spnTimeTo 2
		on btnTimeReset pressed do setExportInterval()
		
		on ddlVisParticles selected index do updateVisParticleId index
		on spnVisParticleId changed value do updateSplineTotal()
		on sldAccuracy changed val do updateAccuracy()
		on btnCreateSplines pressed do createSplines()
		on btnSelectSplines pressed do (try(select splines);catch())
		on btnDeleteSplines pressed do (try(delete splines);catch())
		
		on btnPath pressed do setPath()
		on btnFilename pressed do setFilename()
		
		on btnExportParticles pressed do processParticles()
		on btnExportCamera pressed do processCamera()
		
		on roPVExporter moved pos do saveSetting "pos" pos
		
		
	
)
createdialog roPVExporter

