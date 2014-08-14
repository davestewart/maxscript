-- MacroScript File

-- Created: Sept 21 1999
-- Modified: Dec 7 2000
-- Modified: Apr 25 2001 LAM
-- Author:   Fred Ruff
-- MacroScript for Turning On a Polygon counter in the viewpot on an object.
--***********************************************************************************************
-- MODIFY THIS AT YOUR OWN RISK
macroScript Poly_Counter
	category:"MAX Script Tools"
	internalcategory:"MAX Script Tools"
	buttontext:"Polygon Counter"
	toolTip:"Polygon Counter" 
(
	local PolyCounterOn = false
	local lastViewport
	fn polytext = 
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

	on ischecked return PolyCounterOn 
	
	On execute do
	(	if PolyCounterOn then 
			unregisterRedrawViewsCallback polytext
		else
			registerRedrawViewsCallback polytext
		PolyCounterOn = not PolyCounterOn 
		completeredraw()
		updateToolbarButtons()
	) 
) 




