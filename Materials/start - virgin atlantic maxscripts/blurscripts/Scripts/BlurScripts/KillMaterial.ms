-------------------------------------------------------------------------------
-- KillMaterial.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 03/09/01
-- Modified On: 03/09/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Simply removes all materials from your selected objects.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global kill_mat_from_all

-- Functions

fn kill_mat_from_all = 
	(
	undo "KillMaterial" on
		(
		for i in selection do
			(
			i.material = undefined
			)
		)
	)

-- The Script

if selection.count == 0 then 
		(MessageBox "Please select at least one object" title:"KillMaterial")
	else
		(
		if (queryBox "Remove all materials from selected objects?" title:"KillMaterial") == true then kill_mat_from_all()
		)
)
-------------------------------------------------------------------------------