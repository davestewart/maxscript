-------------------------------------------------------------------------------
-- GoAway.ms
-- By Neil Blevins (soulburn@blur.com)
-- v 1.00
-- Created On: 09/13/00
-- Modified On: 11/02/00
-- tested using Max 4.0
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Description:
-- Takes selected objects and makes them nonrenderable and see-through with one
-- click. Good for quickly dispatching with particle emitters or other object
-- you want to disappear from your final render.
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
(
if selection.count == 0 then (MessageBox "Please select at least one object" title:"GoAway")
	else
	(
		if (queryBox "Make Object(s) GoAway?" title:"GoAway") == true then 
		(
			for i in selection do
			(
				i.renderable = off
				i.xray = on
				i.material = undefined
			)
		)
	)
)
-------------------------------------------------------------------------------