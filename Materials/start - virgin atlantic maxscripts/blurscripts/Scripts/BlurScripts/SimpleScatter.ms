-------------------------------------------------------------------------------
-- SimpleScatter.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.10
-- Created On: 05/27/01
-- Modified On: 05/30/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- BSLib.ms, http://www.blur.com/blurmaxscripts
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- A simple scatter. Takes a selected object, makes n instances of it, moves them
-- around randomly within a distance you specify, rotates them randomly around 
-- the z axis, and scales them between 10% and 200% their original size.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 A simple scatter. Takes a selected object, makes n instances of it, 
-- moves them around randomly within a distance you specify, rotates them randomly 
-- around the z axis, and scales them between 10% and 200% their original size.
--
-- v 1.10 Added Select Previous Scatter button in the Utilities section. Also,
-- now if you select more then one object to scatter, it'll randomly choose an
-- object from your selection for each scatter object.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global perform_scatter

global ss_floater
global ss_rollout

-- Includes

include "$scripts\BlurScripts\BSLib.ms"

-- Variables

scatter_obj = #()
ss_num_duplicates = 15
ss_distance = 100

-- Functions

fn perform_scatter = 
	(
	if selection.count == 0 then (MessageBox "Please select at least one object to scatter." title:"SimpleScatter")
	else
		(
		scatter_obj = #()
		s_objs = #()
		for i in selection do append s_objs i
		for i = 1 to ss_num_duplicates do
			(
			m = instance s_objs[random 1 s_objs.count]
			
			m.scale *= (random 0.1 2)
			
			Rotate m (angleaxis (random -180 180) [0,0,1])
			
			ss_start = -(ss_distance*0.5)
			ss_end = (ss_distance*0.5)
			
			m.pos.x += random ss_start ss_end
			m.pos.y += random ss_start ss_end
			
			append scatter_obj m
			)
		)
	)

-- Rollouts

rollout ss_rollout "SimpleScatter"
	(
	group "Parameters"
	(
	spinner num_dups "Duplicates:" fieldWidth:50 range:[1,99999,15] type:#integer
	spinner dist "Distance:" fieldWidth:50 range:[0.001,99999999,100] type:#worldunits
	)
	on num_dups changed val do ss_num_duplicates = val
	on dist changed val do ss_distance = val
	
	group "Utilities"
	(	
	button clear_scatter "Delete Previous Scatter" width:150 align:#center toolTip:"Delete Previous Scatter"
	button select_scatter "Select Previous Scatter" width:150 align:#center toolTip:"Select Previous Scatter"
	)
	on clear_scatter pressed do 
		(
		try (for i in scatter_obj do delete i)
		catch (MessageBox "This operation has failed. One of the scatter objects may have been deleted, or you may have restarted the script since your last scatter." title:"SimpleScatter")
		)
	on select_scatter pressed do 
		(
		disableSceneRedraw()
		try (select scatter_obj)
		catch (MessageBox "This operation has failed. One of the scatter objects may have been deleted, or you may have restarted the script since your last scatter." title:"SimpleScatter")
		enableSceneRedraw()
		completeRedraw()
		)
	
	button do_scatter "Scatter" width:150 align:#center toolTip:"Scatter"
	on do_scatter pressed do perform_scatter()
	)

if ss_floater != undefined then CloseRolloutFloater ss_floater
ss_floater = newRolloutFloater "SimpleScatter v1.10" 200 240
addRollout ss_rollout ss_floater
)
-------------------------------------------------------------------------------