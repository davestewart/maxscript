macroScript Tracker2D

	category:"Tools"
	toolTip:"2D Tracker"
	icon:#("frank",11)
	(
	LOS = NewRolloutFloater "Upstart!" 260 450
	rollout Tracker "2D Tracker" width:240 height:160
		(
		global dest_path=""
		fn camera_only pickedCam = isKindOf pickedCam camera

		--***** UI *****

		group "File"
			(
			button btn_path "Target Directory" align:#left width:81 height:26
			label lbl_path "" align:#left width:320 height:16
			editText file_name "File Name" align:#left width:152 height:16
			label blank1 "" height:1
			)
		group "Objects"
			(
			pickButton btn_cam "Pick Camera" align:#left width:72 height:24 filter:camera_only across:2
			label lbl_cam "no camera selected" align:#left width:96 height:16
			pickButton btn_obj "Pick Object" align:#left width:72 height:24 across:2
			label lbl_obj "no object selected" align:#left width:96 height:16
			label blank2 "" height:1
			)
		group "Range"
			(
			spinner spnStart "" width:40 height:16 range:[-10000,10000,animationRange.start] type:#integer align:#left across:5
			label lbl_to "to"
			spinner spnEnd "" width:40 height:16 range:[-10000,10000,animationRange.end] type:#integer
			label lbl_offset "Offset" pos:[158,220]
			spinner spnOffset "" width:30 height:16 range:[-10000,10000,1] type:#integer
			)
		group "Export"
			(
			button btn_export "Export to Shake" width:88 height:32 across:2
			button btn_export2 "Export to Ascii" width:88 height:32
			button btn_close "Close" align:#center width:50
			button help "Help" align:#center
			
			)
		--***** Event Handler *****
		
		on btn_path pressed  do
			(
			dest_path=getsavepath caption:"Pick Destination Folder"
			try lbl_path.text=dest_path
			catch()
			)
		on btn_cam picked obj do
			(
			lbl_cam.text=obj.name
			)
		on btn_obj picked obj do
			(
			lbl_obj.text=obj.name
			)
			
		on btn_export pressed  do
		(
		try
			(
			File_X = createfile (dest_path + "\\" + file_name.text + "_X" +".txt")
			File_Y = createfile (dest_path + "\\" + file_name.text + "_Y" +".txt")
			format "Linear(0" to:file_X
			format "Linear(0" to:file_Y
		--***** Calculate 2D position *****
			in coordsys btn_cam.object
		--*****
		
				(
				for t = spnStart.value to spnEnd.value do
						(	
					at time t
						(
					fov_y=
						(
						 local r_aspect=(renderWidth as float)/renderHeight 
						2.*atan(tan(btn_cam.object.fov/2.)/r_aspect)
						)
					fov_x=btn_cam.object.fov
						left=(tan (fov_x/2))* (btn_cam.object.pos.z+btn_obj.object.pos.z)
						right=-(tan (fov_x/2))* (btn_cam.object.pos.z+btn_obj.object.pos.z)
						bottom=(tan (fov_y/2))* (btn_cam.object.pos.z+btn_obj.object.pos.z)
						top=-(tan (fov_y/2))* (btn_cam.object.pos.z+btn_obj.object.pos.z)
						Pixel_X=((btn_obj.object.pos.x-left)/(right-left)*renderWidth) as string
						format (","+ Pixel_X + "@" + (t+spnOffset.value) as string) to:file_X
						if t == spnEnd.value do format ")" to:file_X
						Pixel_Y=(((btn_obj.object.pos.y-bottom)/(top-bottom)*renderHeight*renderPixelAspect)-(renderHeight*(renderPixelAspect-1)/2)) as string
						format (","+ Pixel_Y + "@" + (t+spnOffset.value) as string) to:file_Y
						if t == spnEnd.value do format ")" to:file_Y
					)
				)
			)
				close file_X
				close file_Y
				messagebox ("The following files were created: \n\n"+(File_X as string)+"\n" + (File_Y as string))
		)
			catch
				(
				missing_stuff=""
				if dest_path == "" do missing_stuff = missing_stuff + "no output specified!\n"
				if file_name.text == "" do missing_stuff = missing_stuff + "no file name specified!\n"
				if btn_cam.object == undefined do missing_stuff = missing_stuff + "no camera specified!\n"
				if btn_obj.object == undefined do missing_stuff = missing_stuff +  "no object specified!"
				messagebox missing_stuff title:"Missing Entrys"
				)
		)
		on btn_export2 pressed  do
		(
		try
			(
			File_X_Y = createfile (dest_path + "\\" + file_name.text +".ascii")
		--***** Calculate 2D position *****
			in coordsys btn_cam.object
				(
				for t = spnStart.value to spnEnd.value do
						(	
					at time t
						(
						fov_y	=
							(
							 local r_aspect=(renderWidth as float)/renderHeight 
							 2.0 * atan( tan( btn_cam.object.fov/2.0) / r_aspect )
							)
						fov_x	=btn_cam.object.fov
						left	=(tan (fov_x/2))* (btn_cam.object.pos.z+btn_obj.object.pos.z)
						right	=-(tan (fov_x/2))* (btn_cam.object.pos.z+btn_obj.object.pos.z)
						bottom	=(tan (fov_y/2))* (btn_cam.object.pos.z+btn_obj.object.pos.z)
						top		=-(tan (fov_y/2))* (btn_cam.object.pos.z+btn_obj.object.pos.z)
						Pixel_X	=((btn_obj.object.pos.x-left)/(right-left)*renderWidth) as string
						Pixel_Y	=(((btn_obj.object.pos.y-bottom)/(top-bottom)*renderHeight*renderPixelAspect)-(renderHeight*(renderPixelAspect-1)/2)) as string
						format (((t+spnOffset.value) as string) + ".0 : " + Pixel_X +", " +Pixel_Y +"\n")  to:File_X_Y
					)
				)
			)
				close File_X_Y
				messagebox ("The following file was created: \n\n"+(File_X_Y as string))
		)
			catch
				(
				missing_stuff=""
				if dest_path == "" do missing_stuff = missing_stuff + "no output specified!\n"
				if file_name.text == "" do missing_stuff = missing_stuff + "no file name specified!\n"
				if btn_cam.object == undefined do missing_stuff = missing_stuff + "no camera specified!\n"
				if btn_obj.object == undefined do missing_stuff = missing_stuff +  "no object specified!"
				messagebox missing_stuff title:"Missing Entrys"
				)
		
		)
		on btn_close pressed do closeRolloutFloater LOS
		on help pressed do messagebox "This script calculates the 2D position of the selected object on the rendered image.\n\nThe generated file(s) can be loaded into Shake or Combustion as x- and y- coordinates to get an exact 2D tracking of the 3D rendered object."
		)
	rollout TrackerAbout "About" width:240 height:165
	(
		label about1 "2D Tracker V0.8"
		label about2 "(C) Februar 2002 by Frank Rueter"
		label about3 "Upstart!"
		label about4 "frank@upstart.de"
	)
		addRollout Tracker LOS
		addRollout TrackerAbout LOS rolledUp:true
	)
	
macros.run "Tools" "Tracker2D"