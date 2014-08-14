rollout ro1 "Options" width:160 height:311
(
	---------------------------------------------------------------------------------------------------
	-- declare globals
	---------------------------------------------------------------------------------------------------
	local lastViewport
	local sel
	local t=timeStamp()

	---------------------------------------------------------------------------------------------------
	-- Interface
	---------------------------------------------------------------------------------------------------
	checkbox chk1 "Show Names" pos:[8,8] width:96 height:16
	colorPicker cp1 "" pos:[104,8] width:48 height:16 color:(color 0 0 0)

	---------------------------------------------------------------------------------------------------
	-- Functions
	---------------------------------------------------------------------------------------------------
	fn drawText p txt col = (
		gw.setTransform(Matrix3 1)
		p = gw.hTransPoint p
		gw.hText p txt color:col
		gw.hText (p+[1,0,0]) txt color:col -- second run makes bold by drawing twice
	)
	
	fn prepText = 
	(
		-- time stuff
			--print ((timeStamp()-t) as string)
			--t=timeStamp()
		-- setup
			if viewport.activeViewport != lastViewport do
		(
			completeredraw()
			lastViewport = viewport.activeViewport 
		)
		-- check
			if ro1.chk1.checked then
			(
				sel=getCurrentSelection()
				--if cp1 !=undefined then col = ro1.cp1.color else col=color 0 0 0
				if sel.count>0 then
				(
					for obj in sel do drawText obj.pos obj.name (obj.wirecolor*0.75)
					gw.enlargeUpdateRect #whole
					gw.updateScreen()
				)
				/*
				*/
			)
	)


	fn dtcb = prepText()

	global viewportTextSel
	function viewportTextSel=
	(
		trace("Sel!")
		if ro1!=undefined AND ro1.open then ro1.sel=getCurrentSelection()
	)
	


	---------------------------------------------------------------------------------------------------
	-- Handlers
	---------------------------------------------------------------------------------------------------

	


	on ro1 close do
	(
		unregisterRedrawViewsCallback dtcb
		callbacks.removeScripts  id:#viewportTextSel
		completeredraw()
	)

	on chk1 changed state do
	(
			if chk1.checked then
			(
				--callbacks.addScript #selectionSetChanged "viewportTextSel()" id:#viewportTextSel
				sel=getCurrentSelection()
				print "registering RedrawViewsCallback"
				registerRedrawViewsCallback dtcb
			)
			else (
				--callbacks.removeScripts  id:#viewportTextSel

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






