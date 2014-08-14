try(destroydialog roPVExporter);catch()
--rollout roPVExporter "PaperVision3D Exporter" width:224 height:400
rollout roPVExporter "PaperVision3D Exporter" width:224 height:480
(
	-------------------------------------------------------------------------------------------------------------------------------
	-- interface
	-------------------------------------------------------------------------------------------------------------------------------
	

	GroupBox grpObjects "Objects" pos:[8,8] width:208 height:72
		dropdownList ddlParticles "" pos:[64,24] width:128 height:21
		button btnUpdateParticles "<" pos:[192,24] width:18 height:20 toolTip:"Update"
		label lblParticles "Particles" pos:[16,27] width:48 height:16
		dropdownList ddlCamera "" pos:[65,48] width:128 height:21
		button btnUpdateCameras "<" pos:[192,48] width:18 height:20 toolTip:"Update"
		label lblCamera "Camera" pos:[16,51] width:48 height:16

	GroupBox grpTime "Time" pos:[8,88] width:208 height:80
		dropdownList ddlTimeRange "" pos:[64,104] width:128 height:21 items:#("Current range", "Current frame", "User defined")
		checkbutton btnTimeReverse "R" pos:[192,104] width:18 height:20 toolTip:"Reverse"
		label lblTimeRange "Range" pos:[16,106] width:48 height:16
		label lblTimeFrom "From" pos:[64,128] width:48 height:16
		spinner spnTimeFrom "" pos:[128,128] width:64 height:16 range:[0,9999,10] type:#integer
		label lblTimeTo "To" pos:[64,144] width:48 height:16
		spinner spnTimeTo "" pos:[128,144] width:64 height:16 range:[0,9999,10] type:#integer
		button btnTimeReset "<" pos:[192,128] width:18 height:32 toolTip:"Reset to animation range"

	GroupBox grpVisualise "Visualise" pos:[8,176] width:208 height:104
		label lblVisParticles "Particle(s)" pos:[16,194] width:48 height:16
		dropdownList ddlVisParticles "" pos:[64,192] width:128 height:21 items:#("Every Nth", "All", "Selected", "Single")
		label lblVisParticleId "Every" pos:[64,216] width:52 height:16
		spinner spnVisParticleId "" pos:[128,216] width:64 height:16 range:[1,9999,10] type:#integer
		button btnCreateSplines "Create Splines (1)" pos:[16,240] width:144 height:24
		button btnSelectSplines "Sel" pos:[160,240] width:24 height:24 toolTip:"Select splines"
		button btnDeleteSplines "Del" pos:[184,240] width:24 height:24 toolTip:"Delete splines"
		progressBar pbCreateSplines "ProgressBar" pos:[16,266] width:192 height:8 value:0 color:(color 30 10 190)

	GroupBox grpExport "Export Options" pos:[8,288] width:208 height:104
		label lblPath "Path" pos:[16,307] width:48 height:16
		edittext edtPath "" pos:[60,304] width:132 height:20
		button btnPath "<" pos:[192,304] width:18 height:20 toolTip:"Get save path"
			
		label lblFilename "Filename" pos:[16,331] width:48 height:16
		edittext edtFilename "" pos:[60,328] width:132 height:20
		button btnFilename "<" pos:[192,328] width:18 height:20 toolTip:"Set filename to scene name"
			
		button btnExportParticles "Export particles" pos:[16,352] width:96 height:24
		button btnExportCamera "Export camera" pos:[112,352] width:96 height:24
		progressBar pbExport "ProgressBar" pos:[16,378] width:192 height:8
		
	groupBox grpAbout "www.keyframesandcode.com" pos:[8,400] width:208 height:72
		bitmap bmpAbout "Bitmap" pos:[16,416] width:192 height:48 fileName:""

	
	-------------------------------------------------------------------------------------------------------------------------------
	-- variables
	-------------------------------------------------------------------------------------------------------------------------------
	
		local asPath, asFolder
		local getASArrayFromPData
		struct pData (pos, rot)

		local precision 		= 2
		
		local pf
		local cam
		local splines			= #()

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
					
		----------------------------------------------------------------------------------------------
		-- trajectory functions
		----------------------------------------------------------------------------------------------
		
				function arrayToSpline arr =
				(
					-- spline
						local ss = SplineShape pos:arr[1]
						addNewSpline ss
						
					-- knots
						for i = 1 to arr.count do
						(
							addKnot ss 1 #corner #line arr[i]
						)
						updateShape ss
						
					-- return
						ss
				)
		
				function objectTrajectoryToArray obj =
				(
					local arr	= for t = 0 to animationrange.end collect at time t obj.pos
					arr
				)
		
				function particleTrajectoryToArray pf pIndex =
				(
					local arr	= #()
					for t = 0 to animationrange.end do
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
						local rotScalar	= if degrees then 180 / Pi else 1
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
				
					-- loop through time
						local fStart	= animationrange.start
						local fEnd		= if frames == #all then animationrange.end else frames
						
						--local tStart	= animationrange.start
						--local tEnd		= animationrange.end
						
						print frames
						
						for t = fStart to fEnd do
						(
							print ("Time " + t as string)
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
					arr
				)
		
				function getParticleData pIndex frames:#all degrees:true =
				(
					-- variables
						local pos, rot, tm
						local rotScalar	= if degrees then 180 / Pi else 1
			
					-- create initial arrays
						local arr = #()
				
					-- loop through time
						local fStart	= animationrange.start
						local fEnd		= if frames == #all then animationrange.end else frames
						
						for t = fStart to fEnd do
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
						
					-- loop	
						frames = if frames == #all then animationrange.end else frames
						for t = 0 to frames do
						(
							at time t
							(
								
								mxCamPos	= cam.transform * mxYUp
								mxCamRot	= cam.transform * mxRot90
								
								pos			= mxCamPos.pos
								rot			= mxCamRot.rotation as eulerangles
		
								append arr (pData pos:pos rot:rot)
							)
						)
							
					-- return
						arr
				)
		
		
		----------------------------------------------------------------------------------------------
		-- export functions
		----------------------------------------------------------------------------------------------
		
				function exportParticles arr frames:#all =
				(
					-- variables
						local cam			= $camera01
						local tm			= $ExposeTMCamera01
			
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
						local asScene
						
					-- scene
						--asScene = if findstring maxfilename "content" != undefined then "content" else "intro"
						asScene = (filterstring maxfilename " ")[1]
						
					-- filepath
						if type == "camera" then
							filename = asPath + asScene + "/" + asScene + "Camera" + ".as"
						else
							filename = asPath + asScene + "/" + asScene + ".as"
						
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
		
			-- pre-declarations
			
				local updateSplineTotal
		
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
					if camName != undefined do cam = getNodeByName camName
				)
					
				fn setParticles =
				(
					local pfName = ddlParticles.selected
					if pfName != undefined do pf = getNodeByName pfName
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
					btnCreateSplines.text = "Create Splines (" +n as string+ ")"
				)

				fn updateVisParticleId index =
				(
					state = index == 1 OR index == 4
					lblVisParticleId.enabled	= state
					spnVisParticleId.enabled	= state
					
					if state do lblVisParticleId.text = if index == 1 then "Every" else "Particle Id"
					updateSplineTotal()
				)
			
			
				fn createSplines =
				(
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
						pbCreateSplines.value = 0
						for i = 1 to particleIds.count do
						(
							pbCreateSplines.value	= (i / (particleIds.count as float)) * 100
							local particleId		= particleIds[i]
							local arr				= particleTrajectoryToArray pf particleId
							local ss				= arrayToSpline arr
							
							append splines ss
							
							if keyboard.escPressed do if querybox "Do you wish to abort the script?" do exit
						)

						pbCreateSplines.value = 0
				)
					
			-- time
			
				fn updateTimeRange index =
				(
					local state = index == 3
					lblTimeFrom.enabled = spnTimeFrom.enabled = state
					lblTimeTo.enabled = spnTimeTo.enabled = state
					btnTimeReset.enabled = state
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
				)
				
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
					local arr			= filterstring maxfilename " "
					edtFilename.text	= if arr.count > 0 then arr[1] else ""
				)
					
					

	-------------------------------------------------------------------------------------------------------------------------------
	-- handlers
	-------------------------------------------------------------------------------------------------------------------------------
	
		on roPVExporter open do
		(
			SetDialogPos roPVExporter (execute (loadSetting "pos"))
			escapeEnable = true
			updateCameraItems()
			updateParticleItems()
			updateTimeRange 1
			updateSplineTotal()
			setExportInterval()
			getPath()
			setFilename()
		)
			
		on btnUpdateParticles pressed do updateParticleItems()
		on btnUpdateCameras pressed do updateCameraItems()
		on ddlCamera selected item do setCamera()
		on ddlParticles selected item do setParticles()
		
		on ddlTimeRange selected index do updateTimeRange index
		on spnTimeFrom changed value do updateTimeSpinners spnTimeFrom spnTimeTo 1
		on spnTimeTo changed value do updateTimeSpinners spnTimeFrom spnTimeTo 2
		on btnTimeReset pressed do setExportInterval()
		
		on ddlVisParticles selected index do updateVisParticleId index
		on spnVisParticleId changed value do updateSplineTotal()
		on btnCreateSplines pressed do createSplines()
		on btnSelectSplines pressed do select splines
		on btnDeleteSplines pressed do delete splines
		
		on btnPath pressed do setPath()
		on btnFilename pressed do setFilename()
		
		on roPVExporter moved pos do saveSetting "pos" pos
		
		
	
)
createdialog roPVExporter