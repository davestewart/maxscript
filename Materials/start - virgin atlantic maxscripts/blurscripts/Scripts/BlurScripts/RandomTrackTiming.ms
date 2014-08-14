-------------------------------------------------------------------------------
-- RandomTrackTiming.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 10/09/00
-- Modified On: 11/03/00
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes any tracks you have selected and randomly moves all the keys in the 
-- track forward or backwards by a random amount. Good if, say, you have 100
-- birds with the same wing flapping animation, this will change the timing from 
-- where they start flapping (without actually changing the length of time to 
-- do one full flap).
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global jiggle_the_tracks

global rtt_floater
global rtt_rollout

-- Variables

timeback = 5
timeforward = 5

-- Functions

fn jiggle_the_tracks tv = 
	(
	undo "RandomTrackTiming" on
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
					the_amount = (random (-timeback) timeforward) as integer
					try (movekeys selected_tracks[w] the_amount) catch ()
					)
				)
			)
		)
	)

-- Script

rollout rtt_rollout "RandomTrackTiming"
	( 
	button doit "Apply To Selected Tracks" width:155 align:#center toolTip:"Apply To Selected Tracks" 
	on doit pressed do jiggle_the_tracks trackviews.currentTrackView

	spinner backfromstart "Back From Start " range:[0,9999999,5] fieldWidth:40 type:#integer
	on backfromstart changed val do timeback = val

	spinner forwardfromstart "Forward From Start " range:[0,9999999,5] fieldWidth:40 type:#integer
	on forwardfromstart changed val do timeforward = val
	)

if rtt_floater != undefined then CloseRolloutFloater rtt_floater
rtt_floater = newRolloutFloater "RandomTrackTiming v1.00" 205 140
addRollout rtt_rollout rtt_floater
)
-------------------------------------------------------------------------------