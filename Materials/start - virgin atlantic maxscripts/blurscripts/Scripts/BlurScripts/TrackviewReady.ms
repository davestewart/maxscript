-------------------------------------------------------------------------------
-- TrackviewReady.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.02
-- Created On: 10/19/00
-- Modified On: 01/23/01
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Similar to Trackview selected, except also only shows animated tracks and 
-- it's already unrolled.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.00 Similar to Trackview selected, except also only shows animated tracks 
-- and it's already unrolled.
--
-- v 1.01 Fixed a bug that would crash the script if no objects were selected.
--
-- v 1.02 Fixed a bug that would crash the script if you tried running it again
-- while an instance of trackviewready already existed in the scene.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
for t in 1 to Trackview.NumTrackViews() do
	(
	If Trackview.GetTrackviewName T == "TrackviewReady" then 
		(
		trackviews.close "TrackviewReady"
		)
	else 
		(
		)
	)
TrackView.Open "TrackviewReady"
TrackView.setFilter "TrackviewReady" #modifiedObjects #SelectedObjects #animatedTracks #curveX #curveY #curveZ #Objects #Hierarchy #Transforms #Position #Rotation #Scale #positionX #positionY #positionZ #rotationX #rotationY #rotationZ #scaleX #scaleY #scaleZ
TrackView.zoomSelected "TrackviewReady"
if selection.count != 0 then TrackView.zoomSelected Selection[1].name
trackviews.currentTrackView.expandTracks()
)
-------------------------------------------------------------------------------