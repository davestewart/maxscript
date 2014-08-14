rollout ro1 "Options" width:160 height:311
(
	---------------------------------------------------------------------------------------------------
	-- declare globals
	---------------------------------------------------------------------------------------------------
	local lastViewport

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	checkbox chk1 "Show Names" pos:[8,8] width:96 height:16
	colorPicker cp1 "" pos:[104,8] width:48 height:16 color:(color 0 0 0)

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------
	fn drawText = 
	(
	-- set the obj names as an array
		objList = #()
		for obj in selection do append objList obj

		if viewport.activeViewport != lastViewport do
			(
			completeredraw()
			lastViewport = viewport.activeViewport 
			)

		for i = 1 to objList.count do
			(
			try 
				(
				if chk1.checked then viewtext = (objList[i].name as String + ": " + objList[i].height as String)

				gw.setTransform(Matrix3 1) 
				pos = objList[i].position
				gw.text pos  viewtext  color:(cp1.color)
				)
			catch ()
			)
				gw.enlargeUpdateRect #whole 
				gw.updateScreen() 
	)

fn dtcb = drawText()





	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	


	on ro1 close do
	(
	unregisterRedrawViewsCallback dtcb
	completeredraw()
	)
	on chk1 changed state do
	(
		if chk1.checked then
			(
			print "registering RedrawViewsCallback"
			registerRedrawViewsCallback dtcb
			)
		else (
			print "UN-registering RedrawViewsCallback"
			unregisterRedrawViewsCallback dtcb
			)
		completeredraw()
	)
	on cp1 changed val do
	(
	completeredraw()
	)
)

if myFloater != undefined then closerolloutfloater myFloater
	myFloater = newRolloutFloater "My Floater" 188 88 
addRollout ro1 myFloater






