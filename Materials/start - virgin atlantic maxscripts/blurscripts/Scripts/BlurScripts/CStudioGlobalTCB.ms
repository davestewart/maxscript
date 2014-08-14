-------------------------------------------------------------------------------
-- CStudioGlobalTCB.ms
-- By Brandon Davis (brandon@blur.com)
-- v 1.00
-- Created On: 01/18/01
-- Modified On:
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Required Files:
-- Character Studio, http://www.discreet.com/
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description: 
-- Allows you to change the TCB values globally on selected portions of a Biped
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Variables

global GlobTCB_floater
global GlobTCB_rollout

doEaseTo = false
doEaseFrom = false
newEaseTo = 0
newEaseFrom = 0

doTension = false
doContinuity = false
doBias = false
newTension = 0
newContinuity = 0
newBias = 0

-- Functions

fn makeChanges obj =
	(
	the_object = obj.controller
	the_index = getkeyindex the_object slidertime
	if the_index != 0 then
		(
		thekey = biped.getkey the_object the_index
		if doEaseTo == true then thekey.easeTo = newEaseTo
		if doEaseFrom == true then thekey.easeFrom = newEaseFrom
		if doTension == true then thekey.tension = newTension
		if doContinuity == true then thekey.continuity = newContinuity
		if doBias == true then thekey.bias = newBias
		)
	)		

-- The Script

rollout GlobTCB_rollout "GlobalTCB"
	(	
	
	group "Ease To/From"
	(
	checkbox easeToCheck "Ease To: " across:2
	spinner easeTo ""  enabled:false range:[0,50,0] fieldwidth:40
	checkbox easeFromCheck "Ease From: " across:2
	spinner easeFrom "" enabled:false range:[0,50,0] fieldwidth:40
	)
	
	group "TCB"
	(
	checkbox tensionCheck "Tension: " across:2
	spinner tension ""  enabled:false range:[0,50,25] fieldwidth:40
	checkbox continuityCheck "Continuity: " across:2
	spinner continuity ""  enabled:false range:[0,50,25] fieldwidth:40
	checkbox biasCheck "Bias: " across:2
	spinner bias ""  enabled:false range:[0,50,25] fieldwidth:40
	)
	
	button applyKeys "Apply" height:25 width:150
	

	on easeToCheck changed state do
		(
		easeTo.enabled = state
		if easeToCheck.checked == true then doEaseTo = true
		else doEaseTo = false
		)
	
	on easeFromCheck changed state do
		(
		easeFrom.enabled = state
		if easeFromCheck.checked == true then doEaseFrom = true
		else doEaseFrom = false
		)

	on easeTo changed val do newEaseTo = val
	on easeFrom changed val do newEaseFrom = val
	
	
	on tensionCheck changed state do
		(
		tension.enabled = state
		if tensionCheck.checked == true then doTension = true
		else doTension = false
		)
		
	on continuityCheck changed state do
		(
		continuity.enabled = state
		if continuityCheck.checked == true then doContinuity = true
		else doContinuity = false
		)

	on biasCheck changed state do
		(
		bias.enabled = state
		if biasCheck.checked == true then doBias = true
		else doBias = false
		)

	on tension changed val do newTension = val
	on continuity changed val do newContinuity = val
	on bias changed val do newBias = val	
	
	on applyKeys pressed do
		(
		if selection.count == 0 then (MessageBox "Please select an object(s)" title:"CS GlobalTCB")
		else
			(
			for i in selection do
				(
				if classof i != Biped_Object then (MessageBox "At least one object in your selection was \nnot a Biped object, however changes \nwere applied to all selected Biped objects." title:"CS GlobalTCB") 
				else
					(
					makeChanges i	
					)
				)	
			)
		)		
		
	)
	
if GlobTCB_floater != undefined then CloseRolloutFloater GlobTCB_floater
GlobTCB_floater = newRolloutFloater "CSGlobal TCB v1.00" 200 250
addRollout GlobTCB_rollout GlobTCB_floater
)