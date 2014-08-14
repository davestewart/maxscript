-------------------------------------------------------------------------------
-- RenderCam.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.16
-- Created On: 04/19/00
-- Modified On: 09/26/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- When running (and on is pressed) will output a sequence of rendered images 
-- of whatever was in your camera view at the current interval time. Useful 
-- for outputing a sequential set of images showing the progress of you 
-- building your scene. Minimize the script (don't close it) to let it run 
-- without cluttering your view. Just hit the off button to turn the timer on
-- after you've setup your other defaults, or hit render now to do a render of 
-- the current scene without waiting for the timer.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 When running (and on is pressed) will output a sequence of rendered 
-- images of whatever was in your camera view at the current interval time. 
-- Useful for outputing a sequential set of images showing the progress of you 
-- building your scene. Minimize the script (don't close it) to let it run 
-- without cluttering your view.
--
-- v 1.01 Added version number to titlebar. Also made it so that the images 
-- created have a 4 digit number such as 0000 instead of 0.
--
-- v 1.02 Fixed it so that if you don't have a \ at the end of your directory
-- path (which is needed to be a valid directory path), the script adds it for 
-- you.
--
-- v 1.03 Fixed a bug that was stopping the script from finding the camera.
--
-- v 1.04 Now when it renders an image, it looks to see if there's already
-- images by that name in the directory, and if there is, it starts saving
-- your new images after the last previously rendered image. Changed the
-- look of the on off buttons as well, unifying them into a single button.
-- Added a render now button to render a shot of the scene now and not wait 
-- for the next interval.
--
-- v 1.05 Script now leaves timer mode automatically when doing a render now,
-- and then goes back into timer mode once the current render is done.
--
-- v 1.10 Compatible with R4.0
--
-- v 1.11 Moved some functionality out to BSLib.ms
--
-- v 1.12 Renamed a few variables adding a rc_ prefix to avoid conflicts with
-- other scripts. Removed a bunch of variables that didn't see to be doing
-- anything anymore, probably some legacy code from previous versions of the 
-- script.
--
-- v 1.13 BSLib is now accessed using an include instead of getting loaded
-- at max startup.
--
-- v 1.14 Added a standard max path dialogue box instead of the original text 
-- field.
--
-- v 1.15 Removed height:18 code now that editboxes have been fixed in r4.2.
--
-- v 1.16 The path label has been replaced with a path editbox.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global what_to_do

global rc_floater
global rc_rollout

global myrendercam

-- Includes

include "$scripts/BlurScripts/BSLib.ms"

-- Variables

multiplier = 60000
clockon = 0
intervaltime_min = 20
intervaltime_ticks = 20*multiplier
camerapicked = 0

rc_out_dir = undefined
rc_outfilename = "rendercam"
rc_outfiletype = ".tga"

-- Functions

fn what_to_do = 
(
	if rc_out_dir[rc_out_dir.count] != "\\" then 
	(
		rc_out_dir = rc_out_dir + "\\"
	)
	rc_outname = ""
	i = 1
	for w = 1 to 999999 do
	(
		rc_outname = rc_out_dir + rc_outfilename + (extra_zeros w 4) + rc_outfiletype
		if (getFiles rc_outname).count != 0 then
		(
			i = i + 1
		)
		else exit
	)
	rc_outname = rc_out_dir + rc_outfilename + (extra_zeros i 4) + rc_outfiletype
	render camera: myrendercam frame: 0 outputfile: rc_outname vfb: off
	gc()
)

-- The Script

rollout rc_rollout "RenderCam"
(
	timer myclock interval:intervaltime_ticks
	on myclock tick do 
	(
		if clockon == 1 then what_to_do ()
	)

	group "Camera"
(
	label what_camera "None" align:#center

	pickbutton pickthecamera "Pick The Camera" width:150 align:#center toolTip:"Pick The Camera" filter:camera_filter
)
	on pickthecamera picked obj do 
	(
		camerapicked = 1
		myrendercam = obj
		what_camera.text = obj.name
	)

	group "Time"
(
	spinner intervaltime_spinner "Interval Time (min): " range:[1,99999,20] fieldWidth:35 type:#integer align:#center
)
	on intervaltime_spinner changed val do 
	(
		intervaltime_min = val
		intervaltime_ticks = intervaltime_min * multiplier
		myclock.interval = intervaltime_ticks
	)

	group "Files"
(
	button rc_getpath "Path" align:#left across:2
	edittext rc_pathlabel "" fieldWidth:145 offset:[-55,4] text:"undefined"
	edittext rc_filename "Name: " fieldWidth:145 text:"rendercam" align:#left offset:[4,0]
	edittext rc_filetype "Type: " fieldWidth:145 text:".tga" align:#left offset:[8,0]
)
	
	on rc_getpath pressed do
	(
		rc_out_dir = getSavePath()
		rc_pathlabel.text = (rc_out_dir as string)
	)
	on rc_pathlabel entered text do 
	(
		if rc_pathlabel.text == "undefined" then rc_out_dir = undefined
		else rc_out_dir = rc_pathlabel.text
	)
	on rc_filename changed text do rc_out_filename = rc_filename.text
	on rc_filetype changed text do rc_out_filetype = rc_filetype.text	

	checkbutton startthecam "Off" width:150 align:#center toolTip:"Off" highlightColor:orange
	on startthecam changed state do
	(
		if state == on then
		(
			if camerapicked == 1 then
			(
				if rc_out_dir != undefined then
				(
					clockon = 1
					startthecam.text = "On"
					rc_getpath.enabled = false
					rc_pathlabel.enabled = false
					rc_filename.enabled = false
					rc_filetype.enabled = false
				)
				else
				(
					MessageBox "Please pick a valid path" title:"RenderCam"
					startthecam.state = off
					startthecam.text = "Off"
				)
			)
			else 
			(
				MessageBox "Please select a camera first" title:"RenderCam"
				startthecam.state = off
				startthecam.text = "Off"
			)
		)
		else 
		(
			clockon = 0
			startthecam.state = off
			startthecam.text = "Off"
			rc_getpath.enabled = true
			rc_pathlabel.enabled = true
			rc_filename.enabled = true
			rc_filetype.enabled = true
		)
	)

	button rendernow "Render Now" width:150 align:#center toolTip:"Render Now"
	on rendernow pressed do 
	(
		if camerapicked == 1 then
		(
			if rc_out_dir != undefined then
			(
				if clockon == 1 then 
				(
					clockon = 0
					startthecam.state = off
					startthecam.text = "Off"
					what_to_do ()
					clockon = 1
					startthecam.state = on
					startthecam.text = "On"		
				)
				else
				(
					rc_getpath.enabled = false
					rc_pathlabel.enabled = false
					rc_filename.enabled = false
					rc_filetype.enabled = false
					what_to_do ()
					rc_getpath.enabled = true
					rc_pathlabel.enabled = true
					rc_filename.enabled = true
					rc_filetype.enabled = true
				)
			)
			else (MessageBox "Please pick a valid path" title:"RenderCam")
		)
		else (MessageBox "Please select a camera first" title:"RenderCam")
	)
)

if rc_floater != undefined then CloseRolloutFloater rc_floater
rc_floater = newRolloutFloater "RenderCam v1.16" 240 333
addRollout rc_rollout rc_floater
)
-------------------------------------------------------------------------------