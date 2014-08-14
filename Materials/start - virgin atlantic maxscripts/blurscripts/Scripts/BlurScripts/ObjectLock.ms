-------------------------------------------------------------------------------
-- ObjectLock.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.10
-- Created On: 08/30/00
-- Modified On: 11/03/00
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Locks or unlocked the transform, rotation and scale of an object by turning 
-- on or off all the objects transform locks in one click. Thanks to Grant Adam
-- for the original code.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Locks or unlocked the transform, rotation and scale of an object by 
-- turning on or off all the objects transform locks in one click. Thanks to 
-- Grant Adam for the original code.
--
-- v 1.10 Now compatible with R4.0.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Global

global locked
global unlocked

global ol_floater
global ol_rollout

-- Functions

fn locked =
	(
	if selection.count == 0 then (MessageBox "Please select at least one object" title:"ObjectLock")
	else
		(
		undo "ObjectLock" on
			(
			for i = 1 to selection.count do
				(
				setTransformLockFlags selection[i] #{1,2,3,4,5,6,7,8,9}
				)
			)
		)
	)

fn unlocked =
	(
	if selection.count == 0 then (MessageBox "Please select at least one object" title:"ObjectLock")
	else
		(
		undo "ObjectLock" on
			(
			for i = 1 to selection.count do
				(
				setTransformLockFlags selection[i] #{}
				)
			)
		)
	)

-- getTransformLockFlags <obj>

-- Script

rollout ol_rollout "ObjectLock"
	(
	button button_locked "Locked" width:150 align:#center toolTip:"Locked"
	button button_unlocked "UnLocked" width:150 align:#center toolTip:"UnLocked"
	on button_locked pressed do locked ()
	on button_unlocked pressed do unlocked ()
	)

if ol_floater != undefined then CloseRolloutFloater ol_floater
ol_floater = newRolloutFloater "ObjectLock v1.10" 230 123
addRollout ol_rollout ol_floater
)
-------------------------------------------------------------------------------