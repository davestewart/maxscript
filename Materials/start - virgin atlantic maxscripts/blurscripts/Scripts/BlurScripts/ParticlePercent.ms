-------------------------------------------------------------------------------
-- ParticlePercent.ms
-- By Brandon Davis (brandon@blur.com)
-- v 1.00
-- Created On: 09/25/01
-- Modified On:
-- tested using Max 4.2
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Lets you globally/locally adjust the percentage of particles displayed in the 
-- viewport based on presets.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Usage:
-- Clicking on any of the preset percentage buttons will cause any selected particle 
-- systems (actually just the Super series at the moment) to change their Viewport 
-- Percentage values to the value on the button.  IMPORTANT - if no particle system 
-- is selected then the percentage change will be applied to all applicable particle 
-- systems in the scene.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
-- Globals

-- Includes

-- Variables

global pVal = 0

-- Functions

fn GoProcess =
	(
	if $ != undefined then 
		(
		for s in $ do
			(
			if classof s.baseobject == SuperSpray or classof s.baseobject == PArray or classof s.baseobject == PCloud then
				(
				s.viewPercent = pVal
				)
			)
		)	
 	else for i in objects do
		(
		if classof i.baseobject == SuperSpray or classof i.baseobject == PArray or classof i.baseobject == PCloud then
			(
			i.viewPercent = pVal
			)
		)
	)	

-- The Script

rollout PPer_rollout "ParticlePercent" 
	(
	button Pzero 		"0%" across:5
	button Pten 		"10%"
	button Ptwofive		"25%"
	button PfiveOh		"50%"
	button Pmax			"100%"
	
	on Pzero pressed do
		(
		pVal = 0
		GoProcess()
		)
	
	on Pten pressed do
		(
		pVal = 10
		GoProcess()
		)
		
	on Ptwofive pressed do
		(
		pVal = 25
		GoProcess()
		)

	on PfiveOh pressed do
		(
		pVal = 50
		GoProcess()
		)
		
	on Pmax pressed do
		(
		pVal = 100
		GoProcess()
		)	
	)

if PPer_floater != undefined then CloseRolloutFloater PPer_floater
PPer_floater = newRolloutFloater "ParticlePercent v1.00" 250 100
addRollout PPer_rollout PPer_floater
)
-------------------------------------------------------------------------------
