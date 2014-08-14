-------------------------------------------------------------------------------
-- KeyMaker.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 11/07/01
-- Modified On: 11/07/01
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Creates keys on each key for all selected tracks between the start and end time.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global km_add_keys

global km_floater
global km_rollout

-- Variables

km_startframe_value = 0
km_endframe_value = 100

-- Functions

fn km_add_keys tv = 
(
	undo "KeyMaker" on
	(
		if tv != undefined then
		(
			selected_tracks = #()
			for i = 1 to tv.numSelTracks() do
			(
				append selected_tracks (tv.getSelected i)
			)
			if selected_tracks.count !=0 then
			(
				for w = 1 to selected_tracks.count do
				(
					for x = km_startframe_value to km_endframe_value do
					(
						addNewKey selected_tracks[w] x
					)
				)
			)
		)
	)
)

-- Script

rollout km_rollout "KeyMaker"
( 
	button km_doit "Add Keys To To Selected Tracks" width:180 align:#center toolTip:"Add Keys To To Selected Tracks" 
	on km_doit pressed do km_add_keys trackviews.currentTrackView

	spinner km_startframe "Start Frame: " range:[-9999999,9999999,0] fieldWidth:40 type:#integer
	on km_startframe changed val do km_startframe_value = val

	spinner km_endframe "End Frame: " range:[-9999999,9999999,100] fieldWidth:40 type:#integer
	on km_endframe changed val do km_endframe_value = val
)

if km_floater != undefined then CloseRolloutFloater km_floater
km_floater = newRolloutFloater "KeyMaker v1.00" 230 140
addRollout km_rollout km_floater
)
-------------------------------------------------------------------------------