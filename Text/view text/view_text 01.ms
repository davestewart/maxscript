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
	fn davePolytext = 
	(
		try 
		(
			if viewport.activeViewport != lastViewport do
			(	completeredraw()
				lastViewport = viewport.activeViewport 
			)
			viewtext = ""
			if selection.count == 1 do
			(	if getCommandPanelTaskMode() == #modify and subobjectlevel == 1 then
					viewtext = "Vertices: " + (getPolygoncount $)[2] as string
				else
					viewtext = "Triangles: " + (getPolygoncount $)[1] as string
			)
			gw.wtext [5,40,1000]  viewtext  color:(color 255 234 0)
			gw.enlargeUpdateRect #whole 
			gw.updateScreen() 
		)
		catch ()
	)

on chk1 changed state do
	(
		if chk1.checked then
			(
			registerRedrawViewsCallback davePolytext
			print "Turning On PolyText"
			)
		else
			(
			unregisterRedrawViewsCallback davePolytext
			print "Turning Off PolyText"
			)
		completeredraw()
	) 


	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

)

if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 188 88 
addRollout ro1 myFloater






