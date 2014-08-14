-------------------------------------------------------------------------------
-- IWantMyMom.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.30
-- Created On: 05/22/00
-- Modified On: 11/02/00
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Selects top level parents in the world or a selection set.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Selects all objects visible in the scene that are parented to the world 
-- (ie, that aren't linked to any other object). For David Stinnett.
--
-- v 1.10 Now instead of selecting objects that are parented to the world, it 
-- deselects all selected objects that have parents who are also currently
-- selected. Useful if you want to link a set of objects to a dummy, if you
-- just select all the objects and link them to the dummy, you'll loose any 
-- hierarchy you originally had with your objects, by just selecting and 
-- linking the heads of your currently selected hierarchy, you retain your 
-- links and still link everything to your new dummy. Still can do what v1.00 
-- did, just select everything in your scene and then run the script.
--
-- v 1.20 Added an interface, now you can choose either to select the world
-- parents or the high level parents in your selection.
--
-- v 1.30 Compatible with R4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global deselect_the_nodes
global world_select
global selected_select

global iwmm_rollout
global iwmm_floater

-- Variables

deselect_array = #()

-- Functions

fn deselect_the_nodes =
(
	if deselect_array.count != 0 then
	(
		for j = 1 to deselect_array.count do
		deselect deselect_array[j]
	)
)

fn world_select =
(
	max select all
	for i = 1 to selection.count do 
	(
		if selection[i].parent != undefined then 
		(
			if isGroupMember selection[i] != true then
			(
				append deselect_array selection[i]
			)
		)
	)
)

fn selected_select =
(
	if selection.count != 0 then
	(
		for i = 1 to selection.count do 
		(
			if selection[i].parent != undefined then 
			(
				if selection[i].parent.isselected == true then
				(
					if isGroupMember selection[i] != true then
					(
						append deselect_array selection[i]
					)
				)
			)
		)
	)
	else (MessageBox "Please Select at least one object." title:"IWantMyMom!")
)

-- Script

rollout iwmm_rollout "IWantMyMom!"
(
	button inw "In World" width:150 align:#center toolTip:"In World"
	on inw pressed do 
	(
		undo "IWantMyMom!" on
		(
			deselect_array = #()
			world_select ()
			deselect_the_nodes ()
		)
	)

	button ins "In Selected" width:150 align:#center toolTip:"In Selected"
	on ins pressed do 
	(
		undo "IWantMyMom!" on
		(
			deselect_array = #()
			selected_select ()
			deselect_the_nodes ()
		)
	)
)

if iwmm_floater != undefined then CloseRolloutFloater iwmm_floater
iwmm_floater = newRolloutFloater "IWantMyMom! v1.30" 224 122
addRollout iwmm_rollout iwmm_floater
)
-------------------------------------------------------------------------------