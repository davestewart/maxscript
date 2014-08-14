-------------------------------------------------------------------------------
-- StackControl.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 02/15/02
-- Modified On: 02/15/02
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Lets you quickly move to different parts of the stack.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global stc_rollout
global stc_floater

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Script

rollout stc_rollout "StackControl"
	(
	button stack_top "Top" width:114 align:#center toolTip:"Top"
	button stack_up "Up" width:114 align:#center toolTip:"Up"
	button stack_down "Down" width:114 align:#center toolTip:"Down"
	button stack_bottom "Bottom" width:114 align:#center toolTip:"Bottom"

	on stack_top pressed do 
		(
		if selection.count == 1 then 
			(
			try 
				(
				modPanel.setCurrentObject $.modifiers[1]
				)
			catch
				(
				modPanel.setCurrentObject $
				)
			)
		)
	on stack_up pressed do 
		(
		if selection.count == 1 then 
			(
			current_mod_index = current_modifier_index $
			if current_mod_index == 0 then
				(
				modPanel.setCurrentObject $.modifiers[$.modifiers.count]
				)
			else
				(
				if current_mod_index != 1 then
					(
					current_mod_index = current_mod_index - 1
					modPanel.setCurrentObject $.modifiers[current_mod_index]
					)
				)
			)
		)
	on stack_down pressed do 
		(
		if selection.count == 1 then 
			(
			current_mod_index = current_modifier_index $
			if current_mod_index != 0 then
				(
				if current_mod_index == $.modifiers.count then
					(
					modPanel.setCurrentObject $
					)
				else 
					(
					current_mod_index = current_mod_index + 1
					modPanel.setCurrentObject $.modifiers[current_mod_index]
					)
				)
			)
		)
	on stack_bottom pressed do 
		(
		if selection.count == 1 then 
			(
			modPanel.setCurrentObject $
			)
		)
	)

if stc_floater != undefined then CloseRolloutFloater stc_floater
stc_floater = newRolloutFloater "StackControl v1.00" 150 174
addRollout stc_rollout stc_floater
)
-------------------------------------------------------------------------------