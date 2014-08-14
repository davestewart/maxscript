-------------------------------------------------------------------------------
-- NoiseControllerRandomSeed.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.10
-- Created On: 03/10/99
-- Modified On: 11/03/00
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes all selected objects and finds any noise controllers in them and gives
-- those controllers a random seed.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Takes all selected objects and finds any noise controllers in them and 
-- gives those controllers a random seed.
--
-- v 1.01 Added version to titlebar.
--
-- v 1.10 Compatible with R4.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global changeseed

-- Variables

randomlow_value = 1
randomhigh_value = 100000

-- Functions

fn changeseed onwhat = 
	(
	if onwhat.numsubs != 0 then
		(
		for i = 1 to onwhat.numsubs do
			(
			if onwhat[i] != undefined then
				(
				if classof onwhat[i].controller == Noise_position or classof onwhat[i].controller == noise_float or classof onwhat[i].controller == noise_point3 or classof onwhat[i].controller == noise_rotation or classof onwhat[i].controller == noise_scale then
				onwhat[i].seed = random randomlow_value randomhigh_value
				)
			changeseed onwhat[i]
			)
		)
	)

-- Script

if selection.count == 0 then (MessageBox "Please select at least one object" title:"NoiseControllerRandomSeed")
else 
	(
	undo "NoiseControllerRandomSeed" on
		(
		if (queryBox "Apply a random seed to all noise controllers in selection?" title:"NoiseControllerRandomSeed") == true then 
			(
			for i in selection do changeseed i
			)
		)
	)
)
-------------------------------------------------------------------------------