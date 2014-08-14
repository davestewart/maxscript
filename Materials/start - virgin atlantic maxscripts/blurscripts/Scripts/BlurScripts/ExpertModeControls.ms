-------------------------------------------------------------------------------
-- ExpertModeControls.ms
-- By Brandon Davis (brandon@blur.com)
-- v 1.00
-- Created On: 01/30/01
-- Modified On:
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Moves common animation controls into a floater and stores all selection sets
-- in a fast and convenient listbox.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Variables

numofselsets = GetNumNamedSelSets()
select_array = #()

-- Functions

fn go_process = 
(
	numofselsets = GetNumNamedSelSets()
	select_array = #()
	for i = 1 to numofselsets do
	(
		append select_array (getNamedSelSetName i)
	)
)

-- The Script

go_process()

rollout MC_rollout "SelectionSets"
(
	listbox sel_list items: select_array
	button sel_obj_byname "SELECT" single: true width:50 height:30 across:2
	dropdownlist coord_list "" items:#("View", "Screen", "World", "Parent", "Local") width:75 selection:1
	
	on sel_list selected i do
	(
		disableSceneRedraw()		
		select selectionSets[i]
		enableSceneRedraw()
		redrawViews()
	)	
	
	on sel_obj_byname pressed do hitByNameDlg()
	
	on coord_list selected i do
	(
		if i == 1 then setRefCoordSys #hybrid
		else if i == 2 then setRefCoordSys #screen
		else if i == 3 then setRefCoordSys #world
		else if i == 4 then setRefCoordSys #parent
		else if i == 5 then setRefCoordSys #local
	)	
)
	
if MC_floater != undefined then CloseRolloutFloater MC_floater
MC_floater = newRolloutFloater "ExpertMode Controls" 180 260
addRollout MC_rollout MC_floater
)
-------------------------------------------------------------------------------