-------------------------------------------------------------------------------
-- CameraTransfer.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.12
-- Created On: 03/23/01
-- Modified On: 09/26/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes a camera and outputs it's movement to a textfile, which can then be
-- read in by the same script and applied to a camera. This is useful
-- for transfering camera information between different packages (in the
-- future) or different releases of max, for example, converting an r4 camera 
-- to r3.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Takes a camera and outputs it's movement to a textfile, which can then 
-- be read in by the same script and applied to a camera. This is useful
-- for transfering camera information between different packages (in the
-- future) or different releases of max, for example, converting an r4 camera 
-- to r3.
--
-- v 1.10 Changed the string filtering process to divide inputs using a more obscure
-- dividing character, so cameras that had underscores in their names would still
-- process. Added controls for choosing what time interval the camera outputs
-- information.
--
-- v 1.11 Removed height:18 code now that editboxes have been fixed in r4.2.
--
-- v 1.12 The path label has been replaced with a path editbox. Fixed a bug that
-- occured when the camera you were trying to export wasn't animated.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Information:
--
-- The script records the following information into the text file:
--
-- Name, type, target.name (if not a target camera, undefined), ortho projection 
-- checkbox, showcone, show horizon, show ranges, near range, far range, clip 
-- manually, near clip, far clip)
--
-- Then seperate info for each frame. If the result is a target camera, the rest 
-- of the lines are time, position, roll angle, scale, fov, and target position
-- 
-- If a free camera, the lines are time, position, rotation, scale, fov.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global ct_camera_out
global ct_camera_in

global ct_linecount_in_file
global ct_linecount_in_file_rec

global get_start_time
global get_end_time

global write_cam_data

global read_cam_data
global read_file_target
global read_file_free

global ct_rollout_out
global ct_rollout_in
global ct_floater

-- Variables

ct_out_dir = undefined
ct_out_filename = "ct01"

ct_time_value = 2
ct_start_time_value = 0
ct_end_time_value = 100

ct_in_file = undefined

-- Functions

fn camera_filter o = 
	(
	superClassOf o == camera 
	)

fn ct_linecount_in_file thefile = 
	(
	m = openFile thefile
	curcount = 0
	mo = 0
	if classof m == FileStream then
		(
		mo = ct_linecount_in_file_rec m curcount
		)
	close m
	return (curcount + mo)
	)
	
-- required by ct_linecount_in_file, not to be used as a function by itself.
fn ct_linecount_in_file_rec thefile thecount =
	(
	if eof thefile == false then
		(
		readLine thefile
		thecount += 1
		ct_linecount_in_file_rec thefile thecount
		)
	else return thecount
	)
	
fn get_start_time = 
	(
	if ct_time_value == 1 then
		(
		return animationRange.start
		)
	else if ct_time_value == 2 then
		(
		st = #()
		c = ct_camera_out
		if c.type == #target then
			(
			if c.pos.keys != undefined and c.pos.keys.count != 0 then append st c.pos.keys[1].time
			if c.controller.rollangle.keys != undefined and c.controller.rollangle.keys.count != 0 then append st c.controller.rollangle.keys[1].time
			if c.scale.keys != undefined and c.scale.keys.count != 0 then append st c.scale.keys[1].time
			if c.fov.keys != undefined and c.fov.keys.count != 0 then append st c.fov.keys[1].time
			if c.target.pos.keys != undefined and c.target.pos.keys.count != 0 then append st c.target.pos.keys[1].time
			
			if st == #() then return animationRange.start
			else return amin st
			)
		else 
			(
			if c.pos.keys != undefined and c.pos.keys.count != 0 then append st c.pos.keys[1].time
			if c.rotation.keys != undefined and c.rotation.keys.count != 0 then append st c.rotation.keys[1].time
			if c.scale.keys != undefined and c.scale.keys.count != 0 then append st c.scale.keys[1].time
			if c.fov.keys != undefined and c.fov.keys.count != 0 then append st c.fov.keys[1].time
			
			if st == #() then return animationRange.start
			else return amin st
			)
		)
	else
		(
		return ct_start_time_value
		)
	)
	
fn get_end_time = 
	(
	if ct_time_value == 1 then
		(
		return animationRange.end
		)
	else if ct_time_value == 2 then
		(
		en = #()
		c = ct_camera_out
		if c.type == #target then
			(
			if c.pos.keys != undefined and c.pos.keys.count != 0 then append en c.pos.keys[c.pos.keys.count].time
			if c.controller.rollangle.keys != undefined and c.controller.rollangle.keys.count != 0 then append en c.controller.rollangle.keys[c.controller.rollangle.keys.count].time
			if c.scale.keys != undefined and c.scale.keys.count != 0 then append en c.scale.keys[c.scale.keys.count].time
			if c.fov.keys != undefined and c.fov.keys.count != 0 then append en c.fov.keys[c.fov.keys.count].time
			if c.target.pos.keys != undefined and c.target.pos.keys.count != 0 then append en c.target.pos.keys[c.target.pos.keys.count].time
			
			if en == #() then return animationRange.end
			else return amax en
			)
		else 
			(
			if c.pos.keys != undefined and c.pos.keys.count != 0 then append en c.pos.keys[c.pos.keys.count].time
			if c.rotation.keys != undefined and c.rotation.keys.count != 0 then append en c.rotation.keys[c.rotation.keys.count].time
			if c.scale.keys != undefined and c.scale.keys.count != 0 then append en c.scale.keys[c.scale.keys.count].time
			if c.fov.keys != undefined and c.fov.keys.count != 0 then append en c.fov.keys[c.fov.keys.count].time
			
			if en == #() then return animationRange.end
			else return amax en
			)
		)
	else
		(
		return ct_end_time_value
		)
	)

fn write_cam_data = 
	(
	disableSceneRedraw()
	
	old_slider_time = slidertime
	old_start_time = animationRange.start
	old_end_time = animationRange.end
	
	s = get_start_time()
	e = get_end_time()
		
	-- Check To See If Camera Is Animated
	givewarning = false
	if s == undefined then 
		(
		s = animationRange.start
		givewarning = true
		)
	if e == undefined then 
		(
		e = animationRange.end
		givewarning = true
		)
	if givewarning == true then (MessageBox "An error occured getting the requested time range (possibly the camera is not animated), using active time segment instead." title:"CameraTransfer")
	
	if s != e then animationRange = interval s e else animationRange = interval s (e + 1)
	
	ct_file_name = ((ct_out_dir as string) + ct_out_filename + ".txt")
	if (getFiles ct_file_name).count != 0 then deletefile ct_file_name
	ct_file_file = createFile ct_file_name
	
	-- Common Paramaters
	
	format (ct_camera_out.name as string) to:ct_file_file
	format "|" to:ct_file_file
	format (ct_camera_out.type as string) to:ct_file_file
	format "|" to:ct_file_file

	if ct_camera_out.type == #target then
		(
		format (ct_camera_out.target.name as string) to:ct_file_file
		)
	else
		(
		format (undefined as string) to:ct_file_file
		)
	format "|" to:ct_file_file

	format (ct_camera_out.orthoProjection as string) to:ct_file_file
	format "|" to:ct_file_file
	format (ct_camera_out.showCone as string) to:ct_file_file
	format "|" to:ct_file_file
	format (ct_camera_out.showHorizon as string) to:ct_file_file
	format "|" to:ct_file_file
	format (ct_camera_out.showRanges as string) to:ct_file_file
	format "|" to:ct_file_file
	format (ct_camera_out.nearrange as string) to:ct_file_file
	format "|" to:ct_file_file
	format (ct_camera_out.farrange as string) to:ct_file_file
	format "|" to:ct_file_file
	format (ct_camera_out.clipManually as string) to:ct_file_file
	format "|" to:ct_file_file
	format (ct_camera_out.nearclip as string) to:ct_file_file
	format "|" to:ct_file_file
	format (ct_camera_out.farclip as string) to:ct_file_file
	format "\n" to:ct_file_file

	if ct_camera_out.type == #target then
		(
		for i = s to e do
			(
			slidertime = i
			format (sliderTime as string) to:ct_file_file
			format "|" to:ct_file_file
			format (ct_camera_out.pos as string) to:ct_file_file
			format "|" to:ct_file_file
			format (ct_camera_out.controller.rollangle as string) to:ct_file_file
			format "|" to:ct_file_file
			format (ct_camera_out.scale as string) to:ct_file_file
			format "|" to:ct_file_file
			format (ct_camera_out.fov as string) to:ct_file_file
			format "|" to:ct_file_file
			format (ct_camera_out.target.pos as string) to:ct_file_file
			format "\n" to:ct_file_file
			)
		)
	else
		(
		for i = s to e do
			(
			slidertime = i
			format (sliderTime as string) to:ct_file_file
			format "|" to:ct_file_file
			format (ct_camera_out.pos as string) to:ct_file_file
			format "|" to:ct_file_file
			format (ct_camera_out.rotation as string) to:ct_file_file
			format "|" to:ct_file_file
			format (ct_camera_out.scale as string) to:ct_file_file
			format "|" to:ct_file_file
			format (ct_camera_out.fov as string) to:ct_file_file
			format "\n" to:ct_file_file
			)
		)
		
	close ct_file_file

	animationRange = interval old_start_time old_end_time
	slidertime = old_slider_time
	
	enableSceneRedraw()
	completeRedraw()
	)

fn read_cam_data = 
	(
	disableSceneRedraw()
	if openFile ct_in_file != undefined then
		(
		numlines = ct_linecount_in_file ct_in_file
		m = openFile ct_in_file
		if numlines != 0 then
			(
			inputdata = readLine m
			inputarray = filterString inputdata "|"
			ct_camera_in.name = inputarray[1] as string
			ct_camera_in.type = inputarray[2] as name
			
			if (inputarray[2] as name) == #target then
			(
			ct_camera_in.target.name = inputarray[3] as string
			)
			
			ct_camera_in.orthoProjection = (execute inputarray[4])
			ct_camera_in.showCone = (execute inputarray[5])
			ct_camera_in.showHorizon = (execute inputarray[6])
			ct_camera_in.showRanges = (execute inputarray[7])
			ct_camera_in.nearrange = inputarray[8] as float
			ct_camera_in.farrange = inputarray[9] as float
			ct_camera_in.clipManually = (execute inputarray[10])
			ct_camera_in.nearclip = inputarray[11] as float
			ct_camera_in.farclip = inputarray[12] as float
			
			progressStart "CameraTransfer"
			escapeEnable = false
			curline = 0
			
			if (inputarray[2] as name) == #target then read_file_target m curline numlines
			else read_file_free m curline numlines
			
			progressEnd()
			)
		close m
		)
	enableSceneRedraw()
	completeRedraw()
	)
	
fn read_file_target the_file a b = 
	(
	if eof the_file == false then
		(
		a += 1
		
		inputdata = readLine the_file
		inputarray = filterString inputdata "|"
		animate on at time (inputarray[1] as integer) ct_camera_in.pos = (execute inputarray[2])
		animate on at time (inputarray[1] as integer) ct_camera_in.controller.rollangle = (execute inputarray[3])
		animate on at time (inputarray[1] as integer) ct_camera_in.scale = (execute inputarray[4])
		animate on at time (inputarray[1] as integer) ct_camera_in.fov = (execute inputarray[5])
		animate on at time (inputarray[1] as integer) ct_camera_in.target.pos = (execute inputarray[6])

		curprog = ((a as float)/(b as float))*100
		progressUpdate curprog

		read_file_target the_file a b
		)
	)
	
fn read_file_free the_file a b = 
	(
	if eof the_file == false then
		(
		a += 1
		
		inputdata = readLine the_file
		inputarray = filterString inputdata "|"
		print inputarray
		animate on at time (inputarray[1] as integer) ct_camera_in.rotation = (execute inputarray[3])
		animate on at time (inputarray[1] as integer) ct_camera_in.scale = (execute inputarray[4])
		animate on at time (inputarray[1] as integer) ct_camera_in.fov = (execute inputarray[5])
		animate on at time (inputarray[1] as integer) ct_camera_in.pos = (execute inputarray[2])
		
		curprog = ((a as float)/(b as float))*100
		progressUpdate curprog
		
		read_file_free the_file a b
		)
	)

-- The Script

rollout ct_rollout_out "CameraTransfer Export"
	(
	group "Camera To Export From"
	(
	label what_camera_out "None" align:#center

	pickbutton pickthecamera_out "Pick The Camera" width:200 align:#center toolTip:"Pick The Camera" filter:camera_filter
	)
	on pickthecamera_out picked obj do 
		(
		ct_camera_out = obj
		what_camera_out.text = obj.name
		)
		
	group "Time"
	(
	dropdownlist ct_time "" items:#("Active Time Segment", "Camera Animation", "Range") selection:2
	spinner ct_start_time "Start: " range:[-9999999,9999999,0] type:#integer fieldWidth:50 align:#center across:2 enabled:false
	spinner ct_end_time " End: " range:[-9999999,9999999,100] type:#integer fieldWidth:50 align:#center enabled:false
	)
	
	on ct_time selected i do
		(
		if i == 1 then 
			(
			ct_start_time.enabled = false
			ct_end_time.enabled = false
			ct_time_value = 1
			)
		else if i == 2 then 
			(
			ct_start_time.enabled = false
			ct_end_time.enabled = false
			ct_time_value = 2
			)
		else if i == 3 then 
			(
			ct_start_time.enabled = true
			ct_end_time.enabled = true
			ct_time_value = 3
			)
		)
	on ct_start_time changed val do ct_start_time_value = val
	on ct_end_time changed val do ct_end_time_value = val
		
	group "File To Export"
	(
	button ct_getpath "Path" align:#left across:2
	edittext ct_pathlabel "" fieldWidth:160 offset:[0,4] text:"undefined" align:#right
	edittext ct_filename "Name: " fieldWidth:160 text:ct_out_filename align:#right
	)

	on ct_getpath pressed do
		(
		ct_out_dir = getSavePath()
		ct_pathlabel.text = (ct_out_dir as string)
		)
	on ct_pathlabel entered text do 
		(
		if ct_pathlabel.text == "undefined" then ct_out_dir = undefined
		else ct_out_dir = ct_pathlabel.text
		)
	on ct_filename changed text do ct_out_filename = ct_filename.text
			
	button ct_export "Export" width:200 toolTip:"Export" align:#right
	on ct_export pressed do 
		(
		if ct_camera_out != undefined then
			(
			if ct_out_dir != undefined then
				(
				if ct_out_dir[ct_out_dir.count] != "\\" then ct_out_dir = ct_out_dir + "\\"
				write_cam_data()
				ct_camera_out = undefined
				what_camera_out.text = "None"
				)
			else (MessageBox "Please pick a valid Path" title:"CameraTransfer")
			)
		else (MessageBox "Please pick a camera to export from" title:"CameraTransfer")
		)
	)
	
rollout ct_rollout_in "CameraTransfer Import"
	(
	group "Camera To Import To"
	(
	label what_camera_in "None" align:#center

	pickbutton pickthecamera_in "Pick The Camera" width:200 align:#center toolTip:"Pick The Camera" filter:camera_filter
	)
	on pickthecamera_in picked obj do 
		(
		ct_camera_in = obj
		what_camera_in.text = obj.name
		)

	group "File To Import"
	(
	button ct_getinfile "File" align:#left across:2
	label ct_pathinlabel "None" align:#left offset:[-59,4]
	)
	on ct_getinfile pressed do
		(
		ct_in_file = getOpenFileName()
		if ct_in_file == undefined then ct_pathinlabel.text = "None"
		else ct_pathinlabel.text = ct_in_file
		)

	button ct_import "Import" width:200 toolTip:"Import" align:#right
	on ct_import pressed do 
		(
		if ct_camera_in != undefined then
			(
			if ct_in_file != undefined then 
				(
				read_cam_data()
				ct_camera_in = undefined
				what_camera_in.text = "None"	
				)
			else (MessageBox "Please pick a valid File" title:"CameraTransfer")
			)
		else (MessageBox "Please pick a camera to import to" title:"CameraTransfer")
		)
	)

if ct_floater != undefined then CloseRolloutFloater ct_floater
ct_floater = newRolloutFloater "CameraTransfer v1.12" 260 484
addRollout ct_rollout_out ct_floater
addRollout ct_rollout_in ct_floater
)
-------------------------------------------------------------------------------