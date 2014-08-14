-------------------------------------------------------------------------------
-- PatchControl.ms
-- by Brandon Davis (brandon@blur.com)
-- v 2.0
-- Created On: 13 June 2001
-- Updated On: 07 September 2001
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Allows you to control Patch object parameters globally and locally across 
-- multiple selected patch objects in a scene
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Revision History:
--
-- v 1.0 Allows you to control Patch object parameters globally and locally across 
-- multiple selected patch objects in a scene
--
-- v 2.0 Added a button to set selected objects screen steps to whatever the 
-- render steps are for the object.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

global pac_rollout
global pac_floater

-- Includes

-- Variables

localMode = false

vstepsValue = 5
rstepsValue = 5
showValue = true

-- Functions

fn GoChanges =
(
	for i in selection do
	(
		if classof i.baseobject == Editable_Patch then
		(
			if localMode == false then
			(
				if pac_rollout.checkVsteps.checked == true then patch.setMeshSteps i.baseobject vstepsValue
				if pac_rollout.checkRsteps.checked == true then patch.setMeshStepsRender i.baseobject rstepsValue
				if pac_rollout.checkShow.checked == true then patch.setShowInterior i.baseobject showValue
			)
		)
	)
	completeRedraw()	
)	

fn SetRenderRes =
(
	for i in objects do
	(
		if classof i.baseobject == Editable_Patch then
		(
			local p
			p = patch.getMeshStepsRender i.baseobject 
			patch.setMeshSteps i.baseobject p
		)
	)
	max views redraw 	
)	

--Script

rollout pac_rollout "Parameters" width:162 height:198
(
	GroupBox grp1 "Surface" pos:[4,7] width:154 height:98
	spinner vsteps "View Steps" pos:[29,27] width:105 height:16 enabled:false range:[0,20,5] type:#integer fieldwidth:40 across:2
	checkbutton checkVsteps "" pos:[144,30] width:10 height:10 highlightColor:(color 0 255 0)

	spinner rsteps "Render Steps" pos:[18,56] width:117 height:16 enabled:false range:[0,20,5] type:#integer fieldwidth:40 across:2
	checkbutton checkRsteps "" pos:[144,59] width:10 height:10 highlightColor:(color 0 255 0)

	checkbox showIntEdges "Show Interior Edges" pos:[24,82] width:119 height:15 enabled:false checked:true across:2
	checkbutton checkShow "" pos:[144,85] width:10 height:10 highlightColor:(color 0 255 0)

	GroupBox grp2 "Apply Changes" pos:[5,111] width:154 height:77
	button update "Update" pos:[29,130] width:100 height:21
	button toRenderRes "Set to Render Res" pos:[27,158] width:104 height:21
	--checkbutton mode "Global Mode" pos:[31,155] width:100 height:21 highlightcolor:green

	--enabled/disable parameters

	--set parameter values

	--set global/local mode
	
	-- apply changes

	on vsteps changed val do vstepsValue = val
	
	on checkVsteps changed state do
	(
		if state == on then vsteps.enabled = true
		else vsteps.enabled = false
	)
		
	on rsteps changed val do rstepsValue = val
		
	on checkRsteps changed state do
	(
		if state == on then rsteps.enabled = true
		else rsteps.enabled = false
	)
	
	on showIntEdges changed state do showValue = state
		
	on checkShow changed state do
	(
		if state == on then showIntEdges.enabled = true
		else showIntEdges.enabled = false
	)
	
	on update pressed do GoChanges()
		
	on toRenderRes pressed do SetRenderRes()
)

if pac_floater != undefined then CloseRolloutFloater pac_floater
pac_floater = newRolloutFloater "PatchControl v2.0" 200 261
addRollout pac_rollout pac_floater
)
-------------------------------------------------------------------------------