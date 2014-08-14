-------------------------------------------------------------------------------
-- MotionBlurSelect.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.11
-- Created On: 10/28/99
-- Modified On: 06/02/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Allows you to select objects based on the type of motionblur you have
-- applied to them. The object must be visible for it to work.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Allows you to select objects based on the type of motionblur you have
-- applied to them. The object must be visible for it to work.
--
-- v 1.01 Cleaned the code a bit.
--
-- v 1.02 Added version number to titlebar.
--
-- v 1.10 Compatible with R4.
--
-- v 1.11 Cleaned the code a lot, and removed all code pertaining to selection
-- sets, it uses arrays of scene objects now instead. Also turns off screen 
-- redraw. Requires BSLib.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global blurselect

global mbs_floater
global mbs_rollout

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Functions

fn blurselect typeofblur =
(
	undo "MotionBlurSelect" on
	(
		objs = unhiddenobj()
		new_objs = #()

		disableSceneRedraw()
		
		for i in objs do
		(
			if typeofblur == 1 then
			(
				if i.motionblur == #none then append new_objs i
			)
			if typeofblur == 2 then
			(
				if i.motionblur == #object then append new_objs i
			)
			if typeofblur == 3 then
			(
				if i.motionblur == #image then append new_objs i
			)
		)
		if new_objs.count != 0 then select new_objs
		
		enableSceneRedraw()
		completeRedraw()
	)
)

-- Script
		
rollout mbs_rollout "MotionBlurSelect"
(
	button noneblur "None" width:60 align:#center toolTip:"None" across:3
	on noneblur pressed do blurselect 1

	button objectblur "Object" width:60 align:#center toolTip:"Object"
	on objectblur pressed do blurselect 2
	
	button imageblur "Image" width:60 align:#center toolTip:"Image"
	on imageblur pressed do blurselect 3
)

if mbs_floater != undefined then CloseRolloutFloater mbs_floater
mbs_floater = newRolloutFloater "MotionBlurSelect v1.11" 255 97
addRollout mbs_rollout mbs_floater
)
-------------------------------------------------------------------------------