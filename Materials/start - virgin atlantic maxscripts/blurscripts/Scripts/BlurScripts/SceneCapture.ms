-------------------------------------------------------------------------------
-- SceneCapture.ms
-- By Brandon Davis (brandon@blur.com)
-- v 1.00
-- Created On: 07/17/01
-- Modified On:
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description: 
-- Quick and easy way to isolate objects in a scene and return the scene to its
-- previous state.  
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Usage: 
-- Select objects in your scene that you want to retain.  Press CaptureState to
-- capture the scene in its current state.  Press hide to hide all objects except
-- the current selection.  Unhide returns the scene to the initial state.
-------------------------------------------------------------------------------
(
global scc_rollout
global scc_floater

sceneObj = #()

fn hideXRefs =
	(
	if CstateRollout.xrefTest.checked = true then
		(
		for i in 1 to xrefs.getXRefFileCount() do 
			(
			x = xrefs.getXRefFile i
			if x.hidden == true then x.hidden = false
			else x.hidden = true
			)
		)
	)		

rollout scc_rollout "parameters" width:147 height:64
	(
	button capButton "CaptureState" pos:[9,6] width:124 height:19
	button stateHide "Hide" pos:[9,29] width:59 height:24 enabled:false
	button stateUnhide "UnHide" pos:[73,29] width:59 height:24 enabled:false
	checkbox xrefTest "Include XRefs: " checked:true align:#center

	on capButton pressed do
		(
		for i in objects do
			(
			append sceneObj i
			stateHide.enabled = true
			stateUnhide.enabled = true
			)
		)
	
	on stateHide pressed do
		(
		max hide inv
		hideXRefs()
		)
		
	on stateUnhide pressed do
		(
		unhide sceneObj
		hideXRefs()
		)
	)

scc_floater = newRolloutFloater "SceneCapture" 180 140
addRollout scc_rollout scc_floater
)