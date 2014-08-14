-------------------------------------------------------------------------------
-- KillMissingModifiers.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 01/14/02
-- Modified On: 01/14/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Removes all missing modifiers from selected objects.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global rem_miss_mod

-- Variables

numberkilled = 0

-- Functions

fn kill_the_modifiers obj which_modifiers =
	(
	if which_modifiers.count == 0 then continue
	else
		(
		which_modifiers = (sort_dec which_modifiers)
		for k = 1 to which_modifiers.count do
			(
			deleteModifier obj obj.modifiers[which_modifiers[k]]
			)
		numberkilled = numberkilled + which_modifiers.count
		)
	)

fn rem_miss_mod = 
	(
	numberkilled = 0
	undo "KillMissingModifiers" on
		(
		disableSceneRedraw()
		for i in selection do
			(
			killit_array = #()
			if i.modifiers.count == 0 then continue
			else
				(
				for j = 1 to i.modifiers.count do
					(
					if classof i.modifiers[j] == Missing_OSM then 
					append killit_array j 
					else continue
					)
				)
			kill_the_modifiers i killit_array
			)
		enableSceneRedraw()
		completeRedraw()
		)
	to_print = "Number Of Missing Modifiers Removed: " + (numberkilled as string)
	print to_print
	)

-- The Script

if selection.count == 0 then 
		(MessageBox "Please select at least one object" title:"KillMissingModifiers")
	else
		(
		if (queryBox "Remove all missing modifiers from selected objects?" title:"KillMissingModifiers") == true then rem_miss_mod()
		)
)
-------------------------------------------------------------------------------