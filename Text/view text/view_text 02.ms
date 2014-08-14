rollout ro1 "Options" width:160 height:311
(
	checkbox chk1 "Polycount on / off" pos:[8,8] width:144 height:16
	---------------------------------------------------------------------------------------------------
	-- declare globals
	---------------------------------------------------------------------------------------------------

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------



	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------

	local lastViewport
	fn drawText = 
	(
		try 
		(
			if viewport.activeViewport != lastViewport do
			(	completeredraw()
				lastViewport = viewport.activeViewport 
			)
			viewtext = $.name as String
			gw.setTransform(Matrix3 1) 
			pos = $.position

			gw.text pos  viewtext  color:(color 0 0 0)
			gw.enlargeUpdateRect #whole 
			gw.updateScreen() 
		)
		catch ()
	)

fn displayText = drawText()

on ro1 open do
	(
	unregisterRedrawViewsCallback displayText
	completeredraw()
	)


on chk1 changed state do
	(
		if chk1.checked then registerRedrawViewsCallback displayText
		else unregisterRedrawViewsCallback displayText
		completeredraw()
	) 


	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

)

if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 188 88 
addRollout ro1 myFloater






