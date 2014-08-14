-------------------------------------------------------------------------------
-- KillAnimation.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.11
-- Created On: 10/11/00
-- Modified On: 03/09/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Simply kills any and all animation for any object you have selected.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Simply kills any and all animation for any object you have selected.
--
-- v 1.10 Now works on bipeds as well.
--
-- v 1.11 Changed the function name "kill_from_all" to "kill_anim_from_all".
-- Cleaned a bit of code.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global kill_all_anim_biped
global kill_all_anim
global kill_anim_from_all

-- Functions

fn kill_all_anim_biped onwhat = 
(
	biped.deleteKeys onwhat.controller #allKeys
)

fn kill_all_anim onwhat = 
(
	if onwhat.numsubs != 0 then	
	(
		for i = 1 to onwhat.numsubs do
		(	
			if onwhat[i] != undefined then
			(
				try (deletekeys onwhat[i] #allKeys) catch ()
			)
			kill_all_anim onwhat[i]
		)
	)
)
	
fn kill_anim_from_all = 
(
	undo "KillAnimation" on
	(
		for i in selection do 
		(
			if classof i == Biped_Object then kill_all_anim_biped i
			else kill_all_anim i
		)
	)
)

-- The Script

if selection.count == 0 then 
		(MessageBox "Please select at least one object" title:"KillAnimation")
	else
	(
		if (queryBox "Remove all animation from selected objects?" title:"KillAnimation") == true then kill_anim_from_all()
	)
)
-------------------------------------------------------------------------------