-------------------------------------------------------------------------------
-- GlobalMotionBlur.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.32
-- Created On: 03/03/00
-- Modified On: 02/15/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Applies image motionblur to every visible object in the scene except to
-- particle systems.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Applies image motionblur to every visible object in the scene except to
-- particle systems. Written for David Stinnett.
--
-- v 1.10 Added ability to apply motionblur to all objects, even hidden ones,
-- made it an option to exlude particle systems, added ability to choose the
-- type of motionblur applied, and made a handy interface.
--
-- v 1.11 Cleaned up the code a bit.
--
-- v 1.12 Added version to titlebar.
--
-- v 1.20 Fixed it so that you can also include/exclude frozen objects, which
-- was a bug fix that became a feature request. Also changed the functions
-- around a lot, making it prettier and more straight forward.
--
-- v 1.21 Deals with frozen and hidden objects in a much nicer, friendlier way.
--
-- v 1.22 Include Hidden and Frozen Objects is now on by default.
--
-- v 1.30 Now Compatible with R4, broke out some functionality to BSLib.
--
-- v 1.31 Changed the name of the particle filter used by the script. Changed
-- the floater closing code from a try / catch to an undefined test.
--
-- v 1.32 BSLib is now accessed using an include instead of getting loaded
-- at max startup.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global changemotionblur
global gmb_start

global gmb_rollout
global gmb_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

gmb_type_value = 3
hiddenobjects_value = 1
frozenobjects_value = 1
excludeparticles_value = 1

-- Functions

fn changemotionblur w = 
	(
	if gmb_type_value == 1 then w.motionblur = #none
	else if gmb_type_value == 2 then w.motionblur = #object
	else if gmb_type_value == 3 then w.motionblur = #image
	)

fn gmb_start =
	(
	for i in $* do
		(
		if i.ishidden == true and hiddenobjects_value == 0 then continue
		else
			(
			if i.isfrozen == true and frozenobjects_value == 0 then continue
			else
				(
				if excludeparticles_value == 0 then changemotionblur i
				else
					(
					if particles_filter i == false then changemotionblur i
					)
				)
			)
		)
	)

-- Script

rollout gmb_rollout "GlobalMotionBlur"
	(
	group "Motion Blur Type:"
	(
	dropdownlist blurtype "" items:#("None", "Object", "Image") align:#left selection:3
	)
	on blurtype selected i do gmb_type_value = i

	group "Exclude / Include:"
	(
	checkbox hiddenobjects "Include Hidden Objects" checked:true
	checkbox frozenobjects "Include Frozen Objects" checked:true
	checkbox excludeparticlesystems "Exclude Particle Systems" checked:true
	)
	on hiddenobjects changed state do 
		(
		if hiddenobjects.checked == true then hiddenobjects_value = 1
		else hiddenobjects_value = 0
		)
	on frozenobjects changed state do 
		(
		if frozenobjects.checked == true then frozenobjects_value = 1
		else frozenobjects_value = 0
		)
	on excludeparticlesystems changed state do 
		(
		if excludeparticlesystems.checked == true then excludeparticles_value = 1
		else excludeparticles_value = 0
		)

	button doit "Do it!" width:100 align:#center toolTip:"Do It!"
	on doit pressed do gmb_start()
	)

if gmb_floater != undefined then CloseRolloutFloater gmb_floater
gmb_floater = newRolloutFloater "GlobalMotionBlur v1.32" 210 233
addRollout gmb_rollout gmb_floater
)
-------------------------------------------------------------------------------