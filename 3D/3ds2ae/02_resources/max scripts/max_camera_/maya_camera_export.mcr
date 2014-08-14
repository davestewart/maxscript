/*
	Maya Camera Importer/Exporter
	
	
	This script let's you import/export camera between 3dsmax and Maya.
	
	It goes under the file action item category.
	
	
	maxscript written by Laszlo Sebo (lsebo@axelero.hu), 2002
	melscript written by Imre Lovasz
*/


macroscript MayaCamera
	category:"File"
	tooltip:"Import/Export Maya camera"
(

	global MayaCamera_UI
	
	global MayaCamera_In_file
	global MayaCamera_Out_file
	global TimeRange_radiobutton_state
	global CameraChooser_radiobutton_state
	global CameraChooser_camera
	global TimeRange_from_state
	global TimeRange_to_state

	fn is_camera_filter obj = return (superclassof obj == camera)

	fn Camera_Export obj _outfile _start _end = (

		local opened_file
		local notOpened = false

		try (
			opened_file = createFile _outfile
		) catch (
			NotOpened = true
			messageBox "Error creating file!"
		)
		
		if not notOpened then (
			format "//\n" to:opened_file
			format "// Camera file\n" to:opened_file
			format "// Exported from 3dsmax V%\n//\n//\n" ((maxversion())[1] / 1000.0) to:opened_file
			format "// File specification: // = comment\n" to:opened_file
			format "//                     First non-comment line = field of view of the camera\n" to:opened_file
			format "//                     Second non-comment line = start frame # of camera animation (1-based)\n" to:opened_file
			format "//                     Other non-comment lines = y-up translation and rotation coordinates\n//\n" to:opened_file
			format "// Scene name: %\n//\n//\n" maxfilename to:opened_file
			format "// Render resolution:\n//\nResX=%\nResY=%\n//\n" renderwidth renderheight to:opened_file
			format "// Device aspect ratio (image aspect):\n//\nDivAspR=%\n//\n" (getrendimageaspect()) to:opened_file
			format "// Pixel aspect ratio:\n//\nPixAspR=%\n//\n" renderpixelaspect to:opened_file
			format "// Camera aperture width (render aperture width):\n//\nCamApert=%\n//\n" (getrendaperturewidth() /25.4) to:opened_file
			format "// Focal length (lens camera parameter):\n//\nFocLen=%\n//\n" ((0.5 * (getrendaperturewidth() / 25.4))/ ((tan (0.5 * obj.fov)) * 0.03937)) to:opened_file
			--format "// FOV:\n%\n" (obj.fov) to:opened_file
			format "// Start frame (1-based):\n//\nStartFrame=%\n//\n" (_start as integer + 1) to:opened_file
			format "// Transform: Tx Ty Tz Rx Ry Rz\n" to:opened_file
			
			for t = _start to _end do (
				at time t (
					_thisframe = obj.transform * inverse (matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0])
					_rotation =  _thisframe.rotation as eulerangles
					format "% % % % % %\n" _thisframe.pos.x _thisframe.pos.y _thisframe.pos.z _rotation.x _rotation.y _rotation.z to:opened_file
				)
			)		
		)
		
		close opened_file
	)

	fn Camera_Import this_file = (

		local newCamera = FreeCamera name:("Camera_" + (getfilenameFile this_file))
		local _time = 0
		local NotValid = false
		local NotOpened = false
		local opened_file
		local line_number = 0
		local RenderAperture = undefined

		newCamera.rotation.controller = Euler_XYZ()
		newCamera.position.controller = Bezier_Position()		
		
		if (opened_file = openfile this_file) == undefined then (
			NotOpened = true
			messageBox "Error finding file!"
		)
		
		if not NotOpened then
			do (
				local newline
				local _parsed = #()
				

				try (
					newline = readline opened_file
					_parsed = filterstring newline "\t ="
				) catch()
				if (_parsed.count != 0) and (not (substring _parsed[1] 1 2 == "//")) then (
					if _parsed.count == 2 then (
						try (
							case _parsed[1] of (
								"ResX":renderWidth = _parsed[2] as integer
								"ResY":renderHeight = _parsed[2] as integer
								"DivAspR":()
								"PixAspR":renderpixelAspect = _parsed[2] as float
								"CamApert": RenderAperture = (_parsed[2] as float) * 25.4
								"FocLen": newCamera.fov = 2 * atan ((0.5 * (RenderAperture / 25.4)) / ((_parsed[2] as float) * 0.03937))
								"StartFrame":_time = (_parsed[2] as integer) - 1 -- 1-based frame data
								default:(NotValid = true;format "%\n" _parsed)
							)
						)
						catch (
							NotValid = true
							format "%\n" _parsed
						)
					) else
					if _parsed.count == 6 then (
						with animate on (
							at time _time (
							--	format "%\n" _time
								try (
									newCamera.pos.x = _parsed[1] as float
									newCamera.pos.y = _parsed[2] as float
									newCamera.pos.z = _parsed[3] as float
									newCamera.rotation.controller[1].value = (_parsed[4] as float) -- 
									newCamera.rotation.controller[2].value = (_parsed[5] as float) -- 180
									newCamera.rotation.controller[3].value = (_parsed[6] as float) -- 180
									newCamera.transform = newCamera.transform * (matrix3 [1,0,0] [0,0,1] [0,-1,0] [0,0,0])
									line_number += 1
								) catch (NotValid = true;format "%\n" _parsed)
							)
							if (line_number - 1) == 0 then (
							--	format "time:%\n" _time
								if _time != 0 then (
									try (
										deletekey newCamera.position.controller 1
										deletekey newCamera.rotation.controller[1].controller 1
										deletekey newCamera.rotation.controller[2].controller 1
										deletekey newCamera.rotation.controller[3].controller 1
										deletekey newCamera.scale.controller 1
									) catch()
								)
							)
							
							_time += 1
						)
					) else (
						NotValid = true
						format "%\n" _parsed
					)
				)
			) while (not (eof opened_file)) and (not NotValid)
		
		if NotValid then (
			delete newCamera
			messageBox "Not a Valid .mov file!" title:"Error loading file"
		)
		
		if (not (NotValid or NotOpened)) then (
			local str_ = "Camera imported successfully\nAperture width(mm) = "+(RenderAperture as string)+"\n(to set it, go to Render Options. It won't change the render result)"
			messagebox str_
		)

		return (not (NotValid or NotOpened))
	)	

	rollout G_UI "Maya Camera Import/Export" width:350 height:330
	(
		radioButtons TimeRange_radiobutton "Time range:" pos:[23,29] width:98 height:46 labels:#("Active Segment", "Custom:") columns:1
		spinner TimeRange_From "" pos:[83,60] width:52 height:16 enabled:false type:#integer range:[-9999,9999,0]
		spinner TimeRange_To "To:" pos:[146,60] width:51 height:16 enabled:false type:#integer range:[-9999,9999,100]

		groupBox group_1 "Export" pos:[10,10] width:329 height:201
		button Export_button "Export" pos:[243,172] width:83 height:29

		radioButtons CameraChooser_radiobutton "Camera:" pos:[23,87] width:68 height:46 enabled:true labels:#("Selected", "Pick:") columns:1
		pickButton CameraChooser_pickbutton "None" pos:[72,119] width:253 height:15 enabled:false filter:is_camera_filter

		editText Export_file_edittext "" pos:[72,147] width:253 height:17 --enabled:false
		button Export_file_button "File:" pos:[19,147] width:50 height:18

		groupBox group_2 "Import" pos:[10,222] width:329 height:95
		button Import_button "Import" pos:[243,268] width:83 height:27
		
		editText Import_file_edittext "" pos:[72,239] width:253 height:17 --enabled:false
		button Import_file_button "File:" pos:[19,239] width:50 height:18
		
		label label_warning "WARNING! In case it is opened, close the Render Scene dialog. Otherwise, the rendering settings can not be overriden for proper import!" pos:[19,265] width:230 height:40
		
		
		on TimeRange_radiobutton changed state do (
			case state of (
				1:(TimeRange_From.enabled = false;TimeRange_To.enabled = false)
				2:(TimeRange_From.enabled = true;TimeRange_To.enabled = true)
			)
			TimeRange_radiobutton_state = state
		)

		on CameraChooser_radiobutton changed state do (
			case state of (
				1:(CameraChooser_pickbutton.enabled = false)
				2:(CameraChooser_pickbutton.enabled = true)
			)
			CameraChooser_radiobutton_state = state
		)
		
		on TimeRange_From changed value do (
			TimeRange_From_state = value
			if (TimeRange_To.value < value) then (
				TimeRange_To.value = value
				TimeRange_To_state = value
			)
		)
	
		on TimeRange_To changed value do (
			TimeRange_To_state = value
			if (TimeRange_From.value > value) then (
				TimeRange_From.value = value
				TimeRange_From_state = value
			)
		)
	
		on CameraChooser_pickbutton picked obj do (
			deleteallchangehandlers id:#MayaCamera_deleted
			CameraChooser_pickbutton.text = obj.name
			CameraChooser_camera = obj
			when obj deleted id:#MayaCamera_deleted do (
				CameraChooser_pickbutton.text = "None"
				CameraChooser_camera = undefined
				format "%\n" CameraChooser_camera 
			)
		)
	
		on Import_File_button pressed do (
			MayaCamera_in_file = getopenfileName caption:"Camera file import" types:"Move(*.cam)|*.cam|"
			if MayaCamera_in_file != undefined then 
				Import_file_edittext.text = MayaCamera_in_file
			else
				Import_file_edittext.text = ""
		)

		on Import_file_edittext entered text do (
			MayaCamera_in_file = text
		)

		on Export_file_edittext entered text do (
			MayaCamera_out_file = text
		)

		on Export_File_button pressed do (
			MayaCamera_out_file = getsavefileName caption:"Camera file export" types:"Move(*.cam)|*.cam|"
			if MayaCamera_out_file != undefined then 
				Export_file_edittext.text = MayaCamera_out_file
			else
				Export_file_edittext.text = ""
		)
	
		on G_UI open do (
			if TimeRange_radiobutton_state != undefined then (
				TimeRange_radiobutton.state = TimeRange_radiobutton_state
				case TimeRange_radiobutton_state of (
					1:(TimeRange_From.enabled = false;TimeRange_To.enabled = false)
					2:(TimeRange_From.enabled = true;TimeRange_To.enabled = true)
				)
			)
			if TimeRange_from_state != undefined then TimeRange_From.value = TimeRange_from_state
			if TimeRange_to_state != undefined then TimeRange_to.value = TimeRange_to_state

			if CameraChooser_radiobutton_state != undefined then (
				CameraChooser_radiobutton.state = CameraChooser_radiobutton_state
				case CameraChooser_radiobutton_state of (
					1:(CameraChooser_pickbutton.enabled = false)
					2:(CameraChooser_pickbutton.enabled = true)
				)
			)

			if MayaCamera_out_file != undefined then
				Export_file_edittext.text = MayaCamera_out_file

			if MayaCamera_in_file != undefined then
				Import_file_edittext.text = MayaCamera_in_file
			
			MayaCamera_out_file=Export_file_edittext.text 
			MayaCamera_in_file=Import_file_edittext.text 

			if CameraChooser_camera != undefined then CameraChooser_pickbutton.text = CameraChooser_camera.name
			
			TimeRange_radiobutton_state = TimeRange_radiobutton.state
			TimeRange_from_state = TimeRange_from.value
			TimeRange_to_state = TimeRange_to.value
			CameraChooser_radiobutton_state = CameraChooser_radiobutton.state
		)
		
		on export_button pressed do (
			local Object_ready = false
			local object_toexport = undefined
					
			if CameraChooser_radiobutton.state == 1 then (
				if (selection.count == 1) and (superclassof selection[1] == camera) then Object_ready = true
			) else
				if (CameraChooser_camera != undefined) and (not isdeleted CameraChooser_camera) then Object_ready = true
			
			local _starttime
			local _endtime
			
			if TimeRange_radiobutton.state == 1 then (_starttime = animationrange.start;_endtime = animationrange.end)
												else (_starttime = timerange_from.value;_endtime = timerange_to.value)

			if Object_ready then (
				if CameraChooser_radiobutton_state == 1 then object_toexport = selection[1] else object_toexport = CameraChooser_camera
				if MayaCamera_out_file != undefined then camera_Export object_toexport MayaCamera_out_file _starttime _endtime
				else messagebox "Specify output file!"
			) else messagebox "No, or bad object selected for export"
		)
		
		on import_button pressed do (
			if MayaCamera_in_file != undefined then (
				if (camera_Import MayaCamera_in_file) then (
					forcecompleteredraw()
				)
			) else messagebox "Specify input file!"
		)
	)


--	local fileName_string = getopenfileName caption:"Maya move file import" types:"Move(*.mov)|*.mov|"
--	if fileName_string != undefined then
	--	if (Importer_ fileName_string) then messagebox "Camera Imported."

	if MayaCamera_UI != undefined then closerolloutFloater MayaCamera_UI
	MayaCamera_UI = newrolloutFloater "Maya Camera" 377 385

	addrollout G_UI MayaCamera_UI

)