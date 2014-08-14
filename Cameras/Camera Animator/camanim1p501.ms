--************************************************************************************************************
--Camera animator
--by Michiel Quist
--info@3idee.nl
--http://www.3idee.nl
--Version: 1.5
--
--Whats new in version 1.5: Insert button works
--
--This script creates a new animated camera that animates along the scene camera's
--Every position ,rotation and FOV is stored in an animation key.
--It converts target camera's to free camera's (for now). It also selects hidden camera's (for now)
--It lets you render a number of camera's without making numerous network renderjobs
--or having to set up the video post every time.
--Some other insignificant bugs are still in it.
--************************************************************************************************************

utility camanim "Camera Animator 1.5"
(
local camset = #()
local inscams = #()
local listnum = 1
local y = 1
local b = undefined
button getcams "Get camera's / refresh / reset"
listbox camlist "Camera's in scene" enabled:false height:8
button moveup "Move up" pos:[12,165] enabled:false width:65
button movedown "Move down" pos:[85,165] enabled:false width:65
button remcam "Remove" pos:[12,190] enabled:false width:65
button inscam "Insert" pos:[85,190] enabled:false width:65
label camn "Camera name:" align:#left
edittext camname "" text:"NewAnimCam" enabled:false
button createcam "Create animation camera" enabled:false
label tekst1 "Only works with freecams so it"
label tekst2 "converts targetcams to freecams"
label tekst3 "Version 1.5"
label info3 "(C) 2004 3idee"
label info_4 "www.3idee.nl"

fn cam_filt obj = iskindof obj camera

on getcams pressed do
(
	if cameras.count == 0 then 
	(
		messagebox "There are no camera's in this scene!!" beep:false
		camset = #()
		moveup.enabled = false
		movedown.enabled = false
		remcam.enabled = false
		inscam.enabled = false
		camname.enabled = false
		createcam.enabled = false
	)
	else
(
		for i in cameras do
	(
		if iskindof i camera do
	(
		i.type = #free
	)
)
	camset = #()
	camlist.items =
	for i in 1 to cameras.count collect
	--if classof cameras[i] == targetobject then dontcollect else 
	cameras[i].name
	camlist.enabled = true
	for i in 1 to cameras.count collect
	(
		--if classof cameras[i] == targetobject then dontcollect else 
		camset[i] = cameras[i]
		print camset[i]
	)
	moveup.enabled = true
	movedown.enabled = true
	remcam.enabled = true
	inscam.enabled = true
	camname.enabled = true
	createcam.enabled = true
	print listnum
	
)
)
on camlist selected sel do
(
	listnum = sel
	print sel
)
on remcam pressed do
(
	if listnum > camset.count then messagebox "No camera selected in the list!!" beep:false else
	deleteitem camset listnum
	camlist.items=
	for i in 1 to camset.count collect
	camset[i].name
)
on moveup pressed do
(
	y=listnum-1
	if y < 1 then messagebox "Your on the top of the list!!" beep:false else
	(
		x=camset.count + 1
		z=camset[y]
		append camset z
		camset[listnum] == camset[x]
		camset[y] = camset[listnum]
		camset[listnum] = camset[x]
		deleteitem camset x
		camlist.selection = y
		camlist.items=
		for i in 1 to camset.count collect
		camset[i].name
		listnum = y
	)
)
on movedown pressed do
(
	y=listnum+1
	if y > camset.count then messagebox "Your on the bottom of the list!!" beep:false else
	(
		x=camset.count + 1
		z=camset[y]
		append camset z
		camset[listnum] == camset[x]
		camset[y] = camset[listnum]
		camset[listnum] = camset[x]
		deleteitem camset x
		camlist.selection = y
		camlist.items=
		for i in 1 to camset.count collect
		camset[i].name
		listnum = y
		for i in 1 to camset.count do
		(
			print camset[i]
		)
	)
)
on inscam pressed do
(
	inscams = selectByName title:"Pick camera's to insert" buttontext:"Insert..." filter:cam_filt
	if inscams != undefined then
	(
		for i in 1 to inscams.count do
		(
			print inscams[i].name
		)
		join camset inscams
		print camset.count
		camlist.items=
		for i in 1 to camset.count collect
		camset[i].name
	)
)

on createcam pressed do
(
	print camname.text
	b=freecamera name:camname.text ()
	for i in 1 to camset.count do
	(
		set animate on
		set time (i-1)
		print b.position
		print camset[i].position
		--b.pos = [camset[i].position.x,camset[i].position.y,camset[i].position.z]
		b.rotation = camset[i].rotation
		b.position = camset[i].position
		b.fov = camset[i].fov
		set animate off
	)
	setTrajectoryOn b true
	messagebox ("Your animated camera: " + camname.text + ", is created with trajectory...")
	if (queryBox "Do you want your render setting adjusted to the new camera duration?" title:"Camera render duration") == true then
	(
		rendStart = 0
		rendEnd = (camset.count-1)
		rendTimeType = 3
		renderscenedialog.update()
		viewport.setcamera b
	)
)
)
